import React, { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import { FiArrowLeft, FiCopy, FiCreditCard, FiDownload, FiShield } from "react-icons/fi";
import Header from "../../components/Header/Header";
import Footer from "../../components/Footer/Footer";
import { useToast } from "../../components/Toast/ToastContext";
import { getStoredToken } from "../../lib/auth";
import {
  getPayinRequests,
  getPaymentInfo,
  getPayoutRequests,
  submitPayinRequest,
  submitPayoutRequest,
} from "../../lib/transactions";
import { getFlutterwaveBanks, resolveFlutterwaveAccount } from "../../lib/flutterwave";
import { getUserProfile } from "../../lib/users";
import styles from "./Account.module.css";

function formatNum(value) {
  const n = Number(value);
  return Number.isFinite(n) ? n.toLocaleString() : "0";
}

function shortText(value, start = 8, end = 6) {
  const text = String(value || "");
  if (!text) return "Not assigned";
  if (text.length <= start + end + 3) return text;
  return `${text.slice(0, start)}...${text.slice(-end)}`;
}

function formatMoney(value, currency = "NGN") {
  const n = Number(value);
  return `${currency} ${Number.isFinite(n) ? n.toLocaleString(undefined, { maximumFractionDigits: 2 }) : "0"}`;
}

function formatAccountType(value) {
  const text = String(value || "").trim();
  if (!text) return "";
  return text.replace(/_/g, " ").replace(/\b\w/g, (char) => char.toUpperCase());
}

function formatDate(value) {
  if (!value) return "Not reviewed";
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "Not reviewed";
  return date.toLocaleString([], {
    month: "short",
    day: "numeric",
    hour: "numeric",
    minute: "2-digit",
  });
}

function statusClass(status) {
  const value = String(status || "pending").toLowerCase();
  if (value === "approved") return styles.approved;
  if (value === "rejected") return styles.rejected;
  return styles.pending;
}

const HISTORY_LIMIT = 5;
const PAYOUT_FEE_RATE = 0.1;

export default function Account() {
  const navigate = useNavigate();
  const toast = useToast();
  const location = useLocation();
  const token = useMemo(() => getStoredToken(), []);
  const selectedTab = new URLSearchParams(location.search).get("tab") || "topup";

  const [activeTab, setActiveTab] = useState(
    selectedTab === "withdraw" ? "withdraw" : "topup"
  );
  const [profileData, setProfileData] = useState(null);
  const [paymentInfo, setPaymentInfo] = useState(null);
  const [payins, setPayins] = useState([]);
  const [payouts, setPayouts] = useState([]);
  const [payinPagination, setPayinPagination] = useState(null);
  const [payoutPagination, setPayoutPagination] = useState(null);
  const [payinPage, setPayinPage] = useState(1);
  const [payoutPage, setPayoutPage] = useState(1);
  const [loading, setLoading] = useState(Boolean(token));
  const [historyLoading, setHistoryLoading] = useState(false);
  const [transactionLoading, setTransactionLoading] = useState(false);
  const [payinStage, setPayinStage] = useState("idle");
  const [coinAmount, setCoinAmount] = useState("10");
  const [proofReference, setProofReference] = useState("");
  const [receiptFile, setReceiptFile] = useState(null);
  const [payinNote, setPayinNote] = useState("");
  const [withdrawForm, setWithdrawForm] = useState({
    cop_points: "",
    account_name: "",
    account_number: "",
    account_type: "bank_transfer",
    bank_name: "",
    bank_code: "",
    note: "",
  });
  const [banks, setBanks] = useState([]);
  const [bankSearch, setBankSearch] = useState("");
  const [bankDropdownOpen, setBankDropdownOpen] = useState(false);
  const [bankLoading, setBankLoading] = useState(false);
  const [resolvingAccount, setResolvingAccount] = useState(false);
  const [resolvedAccount, setResolvedAccount] = useState(null);
  const [error, setError] = useState("");
  const [copied, setCopied] = useState(false);
  const bankSelectRef = useRef(null);

  const user = profileData?.user || null;
  const copPoints = Number(user?.cop_point || 0);
  const coinRate = paymentInfo?.coin_rate || null;
  const paymentAccount = paymentInfo?.payment_account || null;
  const rateCurrency = coinRate?.currency || "NGN";
  const calculatedPayinAmount = useMemo(() => {
    const coins = Number(coinAmount);
    const unit = Number(coinRate?.unit);
    const price = Number(coinRate?.price);
    if (!Number.isFinite(coins) || !Number.isFinite(unit) || !Number.isFinite(price) || unit <= 0) {
      return 0;
    }
    return Number(((coins / unit) * price).toFixed(2));
  }, [coinAmount, coinRate]);
  const estimatedWithdrawAmount = useMemo(() => {
    const points = Number(withdrawForm.cop_points);
    const unit = Number(coinRate?.unit);
    const price = Number(coinRate?.price);
    if (!Number.isFinite(points) || !Number.isFinite(unit) || !Number.isFinite(price) || unit <= 0) {
      return 0;
    }
    return Number((((points / unit) * price) * (1 - PAYOUT_FEE_RATE)).toFixed(2));
  }, [coinRate, withdrawForm.cop_points]);
  const filteredBanks = useMemo(() => {
    const query = bankSearch.trim().toLowerCase();
    if (!query) return banks;
    return banks.filter((bank) => bank.name.toLowerCase().includes(query));
  }, [bankSearch, banks]);

  const loadProfile = useCallback(async () => {
    if (!token) {
      setLoading(false);
      return;
    }

    setLoading(true);
    setError("");

    try {
      const [profile, info] = await Promise.all([getUserProfile(), getPaymentInfo()]);
      setProfileData(profile);
      setPaymentInfo(info);
    } catch (err) {
      console.error("Account profile error:", err);
      setError(err?.response?.data?.message || "Unable to load account.");
    } finally {
      setLoading(false);
    }
  }, [token]);

  useEffect(() => {
    loadProfile();
  }, [loadProfile]);

  const loadPayins = useCallback(async () => {
    if (!token) return;

    setHistoryLoading(true);
    try {
      const data = await getPayinRequests({ page: payinPage, limit: HISTORY_LIMIT });
      setPayins(Array.isArray(data?.payins) ? data.payins : []);
      setPayinPagination(data?.pagination || null);
    } catch (err) {
      console.error("Pay-in history error:", err);
      setError(err?.response?.data?.message || "Unable to load pay-in history.");
    } finally {
      setHistoryLoading(false);
    }
  }, [payinPage, token]);

  const loadPayouts = useCallback(async () => {
    if (!token) return;

    setHistoryLoading(true);
    try {
      const data = await getPayoutRequests({ page: payoutPage, limit: HISTORY_LIMIT });
      setPayouts(Array.isArray(data?.payouts) ? data.payouts : []);
      setPayoutPagination(data?.pagination || null);
    } catch (err) {
      console.error("Payout history error:", err);
      setError(err?.response?.data?.message || "Unable to load payout history.");
    } finally {
      setHistoryLoading(false);
    }
  }, [payoutPage, token]);

  useEffect(() => {
    loadPayins();
  }, [loadPayins]);

  useEffect(() => {
    loadPayouts();
  }, [loadPayouts]);

  useEffect(() => {
    if (!token) return;

    let mounted = true;
    setBankLoading(true);
    getFlutterwaveBanks()
      .then((data) => {
        if (mounted) setBanks(Array.isArray(data?.banks) ? data.banks : []);
      })
      .catch((err) => {
        console.error("Flutterwave banks error:", err);
        if (mounted) setError(err?.response?.data?.message || "Unable to load banks.");
      })
      .finally(() => {
        if (mounted) setBankLoading(false);
      });

    return () => {
      mounted = false;
    };
  }, [token]);

  useEffect(() => {
    const handlePointerDown = (event) => {
      if (!bankSelectRef.current?.contains(event.target)) {
        setBankDropdownOpen(false);
      }
    };

    document.addEventListener("pointerdown", handlePointerDown);
    return () => document.removeEventListener("pointerdown", handlePointerDown);
  }, []);

  const copyWallet = async () => {
    if (!user?.wallet_address) return;

    try {
      await navigator.clipboard.writeText(String(user.wallet_address));
      setCopied(true);
      toast.success("Wallet copied");
      setTimeout(() => setCopied(false), 1400);
    } catch {
      setCopied(false);
      toast.error("Unable to copy wallet address.");
    }
  };

  const changeTab = (tab) => {
    setActiveTab(tab);
    navigate(`/account?tab=${tab}`, { replace: true });
  };

  const chooseCoins = (coins) => {
    setCoinAmount(String(coins));
    setError("");
  };

  const revealPaymentDetails = async () => {
    if (payinStage === "loading") return;
    setError("");
    setPayinStage("loading");
    await new Promise((resolve) => window.setTimeout(resolve, 900));
    setPayinStage("ready");
  };

  const copyPaymentAccount = async () => {
    if (!paymentAccount?.account_number) return;

    try {
      await navigator.clipboard.writeText(String(paymentAccount.account_number));
      setCopied(true);
      toast.success("Account number copied");
      setTimeout(() => setCopied(false), 1400);
    } catch {
      setCopied(false);
      toast.error("Unable to copy account number.");
    }
  };

  const copyPayinAmount = async () => {
    if (!calculatedPayinAmount) return;

    try {
      await navigator.clipboard.writeText(String(calculatedPayinAmount));
      setCopied(true);
      toast.success("Amount copied");
      setTimeout(() => setCopied(false), 1400);
    } catch {
      setCopied(false);
      toast.error("Unable to copy amount.");
    }
  };

  const startTopup = async (event) => {
    event.preventDefault();
    if (transactionLoading) return;

    const coins = Number(coinAmount);
    if (!Number.isInteger(coins) || coins <= 0) {
      toast.error("Enter a valid coin amount.");
      return;
    }
    if (!paymentAccount) {
      toast.error("Payment details are not available yet.");
      return;
    }
    if (!receiptFile) {
      toast.error("Upload your payment receipt.");
      return;
    }

    setTransactionLoading(true);
    setError("");

    try {
      const formData = new FormData();
      formData.append("coin_amount", String(coins));
      formData.append("proof_reference", proofReference);
      formData.append("note", payinNote);
      formData.append("receipt", receiptFile);

      await submitPayinRequest(formData);
      setProofReference("");
      setReceiptFile(null);
      setPayinNote("");
      setPayinStage("success");
      setPayinPage(1);
      await loadPayins();
      toast.success("Pay-in request submitted.");
    } catch (err) {
      console.error("Pay-in request error:", err);
      toast.error(err?.response?.data?.message || "Unable to submit pay-in request.");
    } finally {
      setTransactionLoading(false);
    }
  };

  const requestWithdraw = async (event) => {
    event.preventDefault();
    if (transactionLoading) return;

    const points = Number(withdrawForm.cop_points);
    if (!Number.isInteger(points) || points <= 0) {
      toast.error("Enter a valid CopUpCoin amount.");
      return;
    }
    if (points > copPoints) {
      toast.error("You do not have enough CopUpCoin for this withdrawal.");
      return;
    }
    if (!withdrawForm.account_name || !withdrawForm.account_number || !withdrawForm.account_type) {
      toast.error("Add your payout account name, number, and type.");
      return;
    }
    const selectedBank = banks.find(
      (bank) => bank.name === withdrawForm.bank_name && bank.code === withdrawForm.bank_code
    );
    if (!selectedBank) {
      toast.error("Select your bank from the list.");
      return;
    }
    if (
      !resolvedAccount ||
      resolvedAccount.account_number !== withdrawForm.account_number ||
      resolvedAccount.bank_code !== withdrawForm.bank_code
    ) {
      toast.error("Verify your account number before requesting withdrawal.");
      return;
    }

    setTransactionLoading(true);
    setError("");

    try {
      await submitPayoutRequest({
        ...withdrawForm,
        cop_points: points,
      });
      setWithdrawForm({
        cop_points: "",
        account_name: "",
        account_number: "",
        account_type: "bank_transfer",
        bank_name: "",
        bank_code: "",
        note: "",
      });
      setBankSearch("");
      setResolvedAccount(null);
      setPayoutPage(1);
      await Promise.all([loadProfile(), loadPayouts()]);
      toast.success("Withdrawal request submitted.");
    } catch (err) {
      console.error("Payout request error:", err);
      toast.error(err?.response?.data?.message || "Unable to submit payout request.");
    } finally {
      setTransactionLoading(false);
    }
  };

  const verifyWithdrawAccount = async () => {
    if (resolvingAccount || transactionLoading) return;
    if (!withdrawForm.bank_code) {
      toast.error("Select your bank from the list.");
      return;
    }
    if (!/^\d{10}$/.test(withdrawForm.account_number)) {
      toast.error("Account number must be 10 digits.");
      return;
    }

    setResolvingAccount(true);
    setError("");
    setResolvedAccount(null);
    try {
      const data = await resolveFlutterwaveAccount({
        account_bank: withdrawForm.bank_code,
        account_number: withdrawForm.account_number,
      });
      if (!data?.verified) {
        toast.error(data?.message || "Unable to verify account.");
        return;
      }
      setResolvedAccount(data);
      setWithdrawForm((prev) => ({
        ...prev,
        account_name: data.account_name || prev.account_name,
        account_number: data.account_number || prev.account_number,
      }));
      toast.success("Account verified.");
    } catch (err) {
      console.error("Resolve account error:", err);
      toast.error(err?.response?.data?.message || "Unable to verify account.");
    } finally {
      setResolvingAccount(false);
    }
  };

  return (
    <div className={styles.page}>
      <Header />

      <main className={styles.main}>
        <button type="button" className={styles.backBtn} onClick={() => navigate("/dashboard")}>
          <FiArrowLeft />
          <span>Dashboard</span>
        </button>

        <section className={styles.hero}>
          <div>
            <p className={styles.kicker}>CopUp Wallet</p>
            <h1>{loading ? "..." : `${formatNum(copPoints)} CP`}</h1>
            <p className={styles.copy}>
              Submit pay-ins, request withdrawals, and track every CopUpCoin transaction.
            </p>
          </div>

          <div className={styles.walletLine}>
            <span>{shortText(user?.wallet_address)}</span>
            <button type="button" onClick={copyWallet} title="Copy wallet address">
              <FiCopy />
            </button>
          </div>

          {copied ? <div className={styles.notice}>Wallet copied</div> : null}
        </section>

        <section className={styles.panel}>
          <div className={styles.tabs} role="tablist" aria-label="Wallet action">
            <button
              type="button"
              className={activeTab === "topup" ? styles.activeTab : ""}
              onClick={() => changeTab("topup")}
            >
              <FiCreditCard />
              <span>Top up</span>
            </button>

            <button
              type="button"
              className={activeTab === "withdraw" ? styles.activeTab : ""}
              onClick={() => changeTab("withdraw")}
            >
              <FiDownload />
              <span>Withdraw</span>
            </button>
          </div>

          <div className={styles.actionCard}>
            <div className={styles.iconWrap}>
              {activeTab === "topup" ? <FiCreditCard /> : <FiDownload />}
            </div>

            {activeTab === "topup" ? (
              <form className={styles.topupForm} onSubmit={startTopup}>
                <div>
                  <h2>Buy CopUpCoin</h2>
                  <p>
                    Choose the coins you want, let the system prepare payment details, then upload
                    your receipt for confirmation.
                  </p>
                </div>

                <div className={styles.rateBox}>
                  <span>Rate</span>
                  <strong>
                    {formatNum(coinRate?.unit || 1)} CP ={" "}
                    {formatMoney(coinRate?.price || 0, rateCurrency)}
                  </strong>
                  <button
                    type="button"
                    className={styles.amountCopy}
                    onClick={copyPayinAmount}
                    disabled={!calculatedPayinAmount}
                  >
                    <span>Amount to pay</span>
                    <b>{formatMoney(calculatedPayinAmount, rateCurrency)}</b>
                    <FiCopy />
                  </button>
                  {copied ? <small className={styles.copiedText}>Copied!</small> : null}
                </div>

                <div className={styles.amountGrid}>
                  {[10, 25, 50, 100].map((coins) => (
                    <button
                      type="button"
                      key={coins}
                      className={Number(coinAmount) === coins ? styles.selectedAmount : ""}
                      onClick={() => chooseCoins(coins)}
                    >
                      {formatNum(coins)} CP
                    </button>
                  ))}
                </div>

                <label className={styles.amountField}>
                  <span>Coins to buy</span>
                  <input
                    type="number"
                    min="1"
                    inputMode="numeric"
                    value={coinAmount}
                    onChange={(event) => {
                      setCoinAmount(event.target.value);
                      setError("");
                    }}
                    placeholder="Enter coin amount"
                    disabled={transactionLoading}
                  />
                </label>

                {payinStage === "idle" || payinStage === "loading" ? (
                  <button
                    type="button"
                    className={styles.payBtn}
                    onClick={revealPaymentDetails}
                    disabled={payinStage === "loading" || !paymentAccount}
                  >
                    {payinStage === "loading" ? (
                      <span className={styles.loaderText}>
                        <span className={styles.spinner} />
                        Preparing payment...
                      </span>
                    ) : (
                      "Submit Pay-In Request"
                    )}
                  </button>
                ) : null}

                {payinStage === "success" ? (
                  <div className={styles.successBox}>
                    <strong>Request submitted</strong>
                    <span>Your payment is pending confirmation.</span>
                  </div>
                ) : null}

                {payinStage === "ready" || payinStage === "success" ? (
                  <div className={styles.paymentInfo}>
                    <span>Payment account</span>
                    {paymentAccount ? (
                      <React.Fragment>
                        <div className={styles.accountDetail}>
                          <span>Bank name</span>
                          <strong>{paymentAccount.bank_name || "Bank name not set"}</strong>
                        </div>
                        <div className={styles.accountDetail}>
                          <span>Account name</span>
                          <strong>{paymentAccount.account_name || "Account name not set"}</strong>
                        </div>
                        <div className={styles.accountDetail}>
                          <span>Account type</span>
                          <strong>{formatAccountType(paymentAccount.account_type) || "Not set"}</strong>
                        </div>
                        <span className={styles.accountNumberLabel}>Account number</span>
                        <div className={styles.copyAccount}>
                          <b>{paymentAccount.account_number}</b>
                          <button type="button" onClick={copyPaymentAccount} title="Copy account number">
                            <FiCopy />
                          </button>
                        </div>
                      </React.Fragment>
                    ) : (
                      <strong>Payment details not set</strong>
                    )}
                  </div>
                ) : null}

                {payinStage === "ready" ? (
                  <React.Fragment>
                <label className={styles.amountField}>
                  <span>Payment reference</span>
                  <input
                    value={proofReference}
                    onChange={(event) => setProofReference(event.target.value)}
                    placeholder="Bank transfer reference"
                    disabled={transactionLoading}
                  />
                </label>

                <label className={styles.amountField}>
                  <span>Upload receipt</span>
                  <input
                    type="file"
                    accept="image/*"
                    onChange={(event) => setReceiptFile(event.target.files?.[0] || null)}
                    disabled={transactionLoading}
                  />
                  {receiptFile ? <small>{receiptFile.name}</small> : null}
                </label>

                <label className={styles.amountField}>
                  <span>Note optional</span>
                  <textarea
                    value={payinNote}
                    onChange={(event) => setPayinNote(event.target.value)}
                    placeholder="Any extra details for admin"
                    disabled={transactionLoading}
                  />
                </label>

                <button type="submit" className={styles.payBtn} disabled={transactionLoading}>
                  {transactionLoading ? "Submitting..." : "Submit pay-in request"}
                </button>
                  </React.Fragment>
                ) : null}
              </form>
            ) : (
              <form className={styles.topupForm} onSubmit={requestWithdraw}>
                <div>
                  <h2>Request withdrawal</h2>
                  <p>
                    Your CopUpCoin is reserved when you submit a withdrawal. If admin rejects the
                    request, the reserved coins are returned to your balance.
                  </p>
                </div>

                <div className={styles.rateBox}>
                  <span>Withdrawal value after 10% fee</span>
                  <strong>{formatMoney(estimatedWithdrawAmount, rateCurrency)}</strong>
                  <small>Available balance: {formatNum(copPoints)} CP</small>
                </div>

                <label className={styles.amountField}>
                  <span>CopUpCoin amount</span>
                  <input
                    type="number"
                    min="1"
                    max={copPoints || undefined}
                    inputMode="numeric"
                    value={withdrawForm.cop_points}
                    onChange={(event) =>
                      setWithdrawForm((prev) => ({ ...prev, cop_points: event.target.value }))
                    }
                    placeholder="Enter CP amount"
                    disabled={transactionLoading}
                  />
                </label>

                <label className={styles.amountField}>
                  <span>Account name</span>
                  <input
                    value={withdrawForm.account_name}
                    readOnly
                    placeholder="Verify account to fill name"
                    disabled={transactionLoading || resolvingAccount}
                  />
                </label>

                <label className={styles.amountField}>
                  <span>Account number</span>
                  <input
                    value={withdrawForm.account_number}
                    onChange={(event) => {
                      const accountNumber = event.target.value.replace(/\D/g, "").slice(0, 10);
                      setWithdrawForm((prev) => ({ ...prev, account_number: accountNumber }));
                      setResolvedAccount(null);
                    }}
                    placeholder="Account number"
                    inputMode="numeric"
                    maxLength={10}
                    disabled={transactionLoading}
                  />
                </label>

                <label className={styles.amountField}>
                  <span>Account type</span>
                  <input
                    value={withdrawForm.account_type}
                    onChange={(event) =>
                      setWithdrawForm((prev) => ({ ...prev, account_type: event.target.value }))
                    }
                    placeholder="bank_transfer"
                    disabled={transactionLoading}
                  />
                </label>

                <div className={styles.amountField} ref={bankSelectRef}>
                  <span>Bank name</span>
                  <div className={styles.bankSelect}>
                    <input
                      value={bankSearch}
                      onChange={(event) => {
                        setBankSearch(event.target.value);
                        setBankDropdownOpen(true);
                        setWithdrawForm((prev) => ({ ...prev, bank_name: "", bank_code: "" }));
                        setResolvedAccount(null);
                      }}
                      onFocus={() => setBankDropdownOpen(true)}
                      placeholder={bankLoading ? "Loading banks..." : "Search Nigerian banks"}
                      disabled={transactionLoading || bankLoading}
                      role="combobox"
                      aria-expanded={bankDropdownOpen}
                      aria-controls="bank-options"
                      aria-autocomplete="list"
                      autoComplete="off"
                      required
                    />
                    {bankSearch && !transactionLoading ? (
                      <button
                        type="button"
                        className={styles.clearBankBtn}
                        onClick={() => {
                          setBankSearch("");
                          setBankDropdownOpen(true);
                          setWithdrawForm((prev) => ({ ...prev, bank_name: "", bank_code: "" }));
                          setResolvedAccount(null);
                        }}
                        aria-label="Clear selected bank"
                      >
                        x
                      </button>
                    ) : null}
                  </div>
                  {bankDropdownOpen && !transactionLoading ? (
                    <div className={styles.bankOptions} id="bank-options" role="listbox">
                      {filteredBanks.length ? (
                        filteredBanks.map((bank) => (
                          <button
                            type="button"
                            key={`${bank.code}-${bank.name}`}
                            className={
                              withdrawForm.bank_code === bank.code
                                ? styles.bankOptionSelected
                                : styles.bankOption
                            }
                            onMouseDown={(event) => {
                              event.preventDefault();
                              setWithdrawForm((prev) => ({
                                ...prev,
                                bank_name: bank.name,
                                bank_code: bank.code,
                              }));
                              setBankSearch(bank.name);
                              setBankDropdownOpen(false);
                              setResolvedAccount(null);
                              setError("");
                            }}
                            role="option"
                            aria-selected={withdrawForm.bank_code === bank.code}
                          >
                            {bank.name}
                          </button>
                        ))
                      ) : (
                        <div className={styles.noBankResult}>No matching bank in list.</div>
                      )}
                    </div>
                  ) : null}
                  <small>Select a bank from the list. Typed text is not submitted.</small>
                </div>

                <div className={styles.resolveBox}>
                  {resolvedAccount ? (
                    <div>
                      <span>Verified account name</span>
                      <strong>{resolvedAccount.account_name}</strong>
                    </div>
                  ) : (
                    <span>Verify account name before submitting.</span>
                  )}
                  <button
                    type="button"
                    className={styles.verifyBtn}
                    onClick={verifyWithdrawAccount}
                    disabled={
                      transactionLoading ||
                      resolvingAccount ||
                      !withdrawForm.bank_code ||
                      !/^\d{10}$/.test(withdrawForm.account_number)
                    }
                  >
                    {resolvingAccount ? "Verifying..." : "Verify account"}
                  </button>
                </div>

                <label className={styles.amountField}>
                  <span>Note optional</span>
                  <textarea
                    value={withdrawForm.note}
                    onChange={(event) =>
                      setWithdrawForm((prev) => ({ ...prev, note: event.target.value }))
                    }
                    placeholder="Any extra payout details"
                    disabled={transactionLoading}
                  />
                </label>

                <button type="submit" className={styles.payBtn} disabled={transactionLoading}>
                  {transactionLoading ? "Submitting..." : "Request withdrawal"}
                </button>
              </form>
            )}
          </div>
        </section>

        <section className={styles.historyGrid}>
          <TransactionHistory
            title="Pay-ins"
            loading={historyLoading}
            rows={payins}
            pagination={payinPagination}
            onPrev={() => setPayinPage((page) => Math.max(1, page - 1))}
            onNext={() => setPayinPage((page) => page + 1)}
            renderRow={(item) => (
              <div className={styles.transactionRow} key={item.id}>
                <div>
                  <strong>{formatMoney(item.amount_ngn)}</strong>
                  <span>{formatNum(item.coin_amount)} CP · {formatDate(item.created_at)}</span>
                  {item.rejection_reason ? <em>{item.rejection_reason}</em> : null}
                </div>
                <span className={`${styles.statusBadge} ${statusClass(item.status)}`}>
                  {item.status}
                </span>
              </div>
            )}
          />

          <TransactionHistory
            title="Payouts"
            loading={historyLoading}
            rows={payouts}
            pagination={payoutPagination}
            onPrev={() => setPayoutPage((page) => Math.max(1, page - 1))}
            onNext={() => setPayoutPage((page) => page + 1)}
            renderRow={(item) => (
              <div className={styles.transactionRow} key={item.id}>
                <div>
                  <strong>{formatNum(item.cop_points)} CP</strong>
                  <span>{formatMoney(item.amount_ngn)} after fee · {formatDate(item.created_at)}</span>
                  <span className={styles.payoutAccountLine}>
                    <b>Bank:</b> {item.bank_name || "Not set"} · <b>Name:</b>{" "}
                    {item.account_name || "Not set"} · <b>No:</b>{" "}
                    {shortText(item.account_number, 4, 4)}
                  </span>
                  {item.rejection_reason ? <em>{item.rejection_reason}</em> : null}
                </div>
                <span className={`${styles.statusBadge} ${statusClass(item.status)}`}>
                  {item.status}
                </span>
              </div>
            )}
          />
        </section>

        <section className={styles.security}>
          <FiShield />
          <div>
            <h3>Account protected</h3>
            <p>Wallet actions stay behind the logged-in user route.</p>
          </div>
        </section>

        {error ? (
          <div className={styles.errorBox}>
            <span>{error}</span>
            <button type="button" onClick={loadProfile}>
              Retry
            </button>
          </div>
        ) : null}
      </main>

      <Footer />
    </div>
  );
}

function TransactionHistory({ title, loading, rows, pagination, onPrev, onNext, renderRow }) {
  const page = pagination?.page || 1;
  const totalPages = pagination?.total_pages || 1;

  return (
    <section className={styles.historyPanel}>
      <div className={styles.historyHead}>
        <div>
          <p className={styles.kicker}>History</p>
          <h2>{title}</h2>
        </div>
        <span>
          Page {page} / {totalPages}
        </span>
      </div>

      <div className={styles.historyRows}>
        {loading ? (
          <div className={styles.emptyState}>Loading transactions...</div>
        ) : rows.length ? (
          rows.map(renderRow)
        ) : (
          <div className={styles.emptyState}>No transactions yet.</div>
        )}
      </div>

      <div className={styles.pagination}>
        <button type="button" onClick={onPrev} disabled={!pagination?.has_prev || loading}>
          Previous
        </button>
        <button type="button" onClick={onNext} disabled={!pagination?.has_next || loading}>
          Next
        </button>
      </div>
    </section>
  );
}
