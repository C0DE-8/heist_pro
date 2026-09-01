import React, { useEffect, useMemo, useRef, useState } from "react";
import {
  FaCheck,
  FaCopy,
  FaPrint,
  FaReceipt,
  FaRedoAlt,
  FaTimes,
  FaUniversity,
} from "react-icons/fa";
import AdminNavbar from "../../../components/admin/Navbar";
import AdminPageHeader from "../../../components/admin/AdminPageHeader";
import { ToastProvider, useToast } from "../../../components/ui/Toaster";
import { getFlutterwaveBanks, resolveFlutterwaveAccount } from "../../../lib/flutterwave";
import successMarkImage from "../../../assets/banks/successmark.png";
import styles from "./AdminReceipts.module.css";

const DEFAULT_FORM = {
  amount: "9000",
  business_name: "COPUPBID LIMITED -",
  sender_name: "COPUPBID LIMITED -",
  narration: "from light potato",
  account_number: "",
  bank_name: "",
  bank_code: "",
  account_name: "",
  transaction_date: toDateTimeLocal(new Date()),
  session_id: "",
  transaction_reference: "",
  template: "success",
};

function toDateTimeLocal(value) {
  const date = value instanceof Date ? value : new Date(value);
  if (Number.isNaN(date.getTime())) return "";
  const offset = date.getTimezoneOffset();
  const local = new Date(date.getTime() - offset * 60000);
  return local.toISOString().slice(0, 16);
}

function formatMoney(value) {
  const n = Number(value);
  return `NGN ${Number.isFinite(n) ? n.toLocaleString(undefined, { maximumFractionDigits: 2 }) : "0"}`;
}

function formatReceiptMoney(value) {
  const n = Number(value);
  return `₦${Number.isFinite(n) ? n.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 }) : "0.00"}`;
}

function formatShortDate(value) {
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "Select date";
  return date.toLocaleString([], {
    day: "numeric",
    month: "long",
    year: "numeric",
    hour: "numeric",
    minute: "2-digit",
  });
}

function formatLongDate(value) {
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "Select date";
  return date.toLocaleString([], {
    weekday: "long",
    month: "long",
    day: "numeric",
    year: "numeric",
    hour: "numeric",
    minute: "2-digit",
  });
}

function makeToken(prefix) {
  const time = Date.now().toString();
  const random = Math.random().toString().slice(2, 12);
  return `${prefix}${time}${random}`;
}

function AdminReceiptsPage() {
  const toast = useToast();
  const bankSelectRef = useRef(null);
  const [form, setForm] = useState(() => ({
    ...DEFAULT_FORM,
    session_id: makeToken("APT"),
    transaction_reference: makeToken("TRF|CMP"),
  }));
  const [banks, setBanks] = useState([]);
  const [bankSearch, setBankSearch] = useState("");
  const [bankDropdownOpen, setBankDropdownOpen] = useState(false);
  const [bankLoading, setBankLoading] = useState(true);
  const [resolving, setResolving] = useState(false);
  const [verifiedAccount, setVerifiedAccount] = useState(null);
  const [error, setError] = useState("");

  const filteredBanks = useMemo(() => {
    const query = bankSearch.trim().toLowerCase();
    if (!query) return banks;
    return banks.filter((bank) => bank.name.toLowerCase().includes(query));
  }, [bankSearch, banks]);

  const canUseReceipt =
    verifiedAccount?.account_number === form.account_number &&
    verifiedAccount?.bank_code === form.bank_code &&
    Boolean(verifiedAccount?.account_name);

  useEffect(() => {
    let mounted = true;
    setBankLoading(true);
    setError("");

    getFlutterwaveBanks()
      .then((data) => {
        if (mounted) setBanks(Array.isArray(data?.banks) ? data.banks : []);
      })
      .catch((err) => {
        console.error("Load receipt banks error:", err);
        if (mounted) setError(err?.response?.data?.message || "Unable to load Flutterwave banks.");
      })
      .finally(() => {
        if (mounted) setBankLoading(false);
      });

    return () => {
      mounted = false;
    };
  }, []);

  useEffect(() => {
    const close = (event) => {
      if (!bankSelectRef.current?.contains(event.target)) setBankDropdownOpen(false);
    };
    document.addEventListener("mousedown", close);
    return () => document.removeEventListener("mousedown", close);
  }, []);

  const updateForm = (key, value) => {
    setForm((prev) => ({ ...prev, [key]: value }));
    if (["account_number", "bank_code", "bank_name"].includes(key)) {
      setVerifiedAccount(null);
    }
  };

  const selectBank = (bank) => {
    setForm((prev) => ({
      ...prev,
      bank_name: bank.name,
      bank_code: bank.code,
      account_name: "",
    }));
    setBankSearch(bank.name);
    setVerifiedAccount(null);
    setBankDropdownOpen(false);
  };

  const verifyAccount = async () => {
    if (!form.bank_code) {
      toast.error("Select a bank from the list.");
      return;
    }
    if (!/^\d{10}$/.test(form.account_number)) {
      toast.error("Enter a 10-digit account number.");
      return;
    }

    setResolving(true);
    try {
      const data = await resolveFlutterwaveAccount({
        account_bank: form.bank_code,
        account_number: form.account_number,
      });

      if (!data?.verified) {
        toast.error(data?.message || "Unable to verify account.");
        setVerifiedAccount(null);
        return;
      }

      const account = {
        account_name: data.account_name,
        account_number: data.account_number || form.account_number,
        bank_code: data.bank_code || form.bank_code,
      };
      setVerifiedAccount(account);
      setForm((prev) => ({ ...prev, account_name: account.account_name }));
      toast.success("Account name verified");
    } catch (err) {
      console.error("Verify receipt account error:", err);
      toast.error(err?.response?.data?.message || "Unable to verify account.");
    } finally {
      setResolving(false);
    }
  };

  const regenerateReferences = () => {
    setForm((prev) => ({
      ...prev,
      session_id: makeToken("APT"),
      transaction_reference: makeToken("TRF|CMP"),
    }));
  };

  const copySummary = async () => {
    const summary = [
      "Transfer Successful",
      `Amount: ${formatMoney(form.amount)}`,
      `Beneficiary: ${form.account_name} | ${form.account_number}`,
      `Bank: ${form.bank_name}`,
      `Date: ${formatLongDate(form.transaction_date)}`,
      `Narration: ${form.narration}`,
      `Session ID: ${form.session_id}`,
      `Reference: ${form.transaction_reference}`,
    ].join("\n");

    try {
      await navigator.clipboard.writeText(summary);
      toast.success("Receipt details copied");
    } catch (err) {
      console.error("Copy receipt error:", err);
      toast.error("Unable to copy receipt details.");
    }
  };

  return (
    <div className={styles.page}>
      <AdminNavbar />

      <main className={styles.main}>
        <AdminPageHeader
          kicker="Receipts"
          title="Marketing receipt generator"
          description="Create verified receipt previews for marketing demos. Account names are resolved through Flutterwave before they appear on the receipt."
          error={error}
        />

        <section className={styles.workspace}>
          <form className={styles.panel} onSubmit={(event) => event.preventDefault()}>
            <div className={styles.panelHead}>
              <div>
                <p className={styles.kicker}>Receipt Details</p>
                <h2>Beneficiary and transaction</h2>
              </div>
              <FaReceipt />
            </div>

            <div className={styles.templateSwitch} role="group" aria-label="Receipt template">
              <button
                type="button"
                className={form.template === "success" ? styles.templateActive : ""}
                onClick={() => updateForm("template", "success")}
              >
                Success screen
              </button>
              <button
                type="button"
                className={form.template === "debit" ? styles.templateActive : ""}
                onClick={() => updateForm("template", "debit")}
              >
                Debit receipt
              </button>
            </div>

            <div className={styles.formGrid}>
              <label>
                <span>Amount</span>
                <input
                  type="number"
                  min="1"
                  value={form.amount}
                  onChange={(event) => updateForm("amount", event.target.value)}
                />
              </label>
              <label>
                <span>Transaction date</span>
                <input
                  type="datetime-local"
                  value={form.transaction_date}
                  onChange={(event) => updateForm("transaction_date", event.target.value)}
                />
              </label>
              <label>
                <span>Business name</span>
                <input
                  value={form.business_name}
                  onChange={(event) => updateForm("business_name", event.target.value)}
                />
              </label>
              <label>
                <span>Sender name</span>
                <input
                  value={form.sender_name}
                  onChange={(event) => updateForm("sender_name", event.target.value)}
                />
              </label>
              <label>
                <span>Account number</span>
                <input
                  inputMode="numeric"
                  value={form.account_number}
                  onChange={(event) =>
                    updateForm("account_number", event.target.value.replace(/\D/g, "").slice(0, 10))
                  }
                  placeholder="0123456789"
                />
              </label>
              <div className={styles.bankField} ref={bankSelectRef}>
                <label>
                  <span>Bank</span>
                  <input
                    value={bankSearch}
                    onChange={(event) => {
                      setBankSearch(event.target.value);
                      setBankDropdownOpen(true);
                      setForm((prev) => ({ ...prev, bank_name: "", bank_code: "", account_name: "" }));
                      setVerifiedAccount(null);
                    }}
                    onFocus={() => setBankDropdownOpen(true)}
                    placeholder={bankLoading ? "Loading banks..." : "Search Nigerian banks"}
                    disabled={bankLoading}
                    aria-expanded={bankDropdownOpen}
                    aria-controls="receipt-bank-options"
                  />
                </label>
                {bankSearch ? (
                  <button
                    type="button"
                    className={styles.clearBankBtn}
                    onClick={() => {
                      setBankSearch("");
                      setForm((prev) => ({ ...prev, bank_name: "", bank_code: "", account_name: "" }));
                      setVerifiedAccount(null);
                    }}
                    aria-label="Clear selected bank"
                    title="Clear selected bank"
                  >
                    <FaTimes />
                  </button>
                ) : null}
                {bankDropdownOpen && !bankLoading ? (
                  <div className={styles.bankOptions} id="receipt-bank-options" role="listbox">
                    {filteredBanks.length ? (
                      filteredBanks.slice(0, 80).map((bank) => (
                        <button
                          type="button"
                          key={`${bank.code}-${bank.name}`}
                          className={form.bank_code === bank.code ? styles.bankOptionSelected : styles.bankOption}
                          onClick={() => selectBank(bank)}
                          role="option"
                          aria-selected={form.bank_code === bank.code}
                        >
                          <FaUniversity />
                          <span>{bank.name}</span>
                        </button>
                      ))
                    ) : (
                      <div className={styles.noBankResult}>No matching bank in list.</div>
                    )}
                  </div>
                ) : null}
              </div>
              <label className={styles.fullField}>
                <span>Verified account name</span>
                <input value={form.account_name} readOnly placeholder="Verify account to fill name" />
              </label>
              <label className={styles.fullField}>
                <span>Narration</span>
                <input
                  value={form.narration}
                  onChange={(event) => updateForm("narration", event.target.value)}
                />
              </label>
              <label>
                <span>Session ID</span>
                <input
                  value={form.session_id}
                  onChange={(event) => updateForm("session_id", event.target.value)}
                />
              </label>
              <label>
                <span>Transaction reference</span>
                <input
                  value={form.transaction_reference}
                  onChange={(event) => updateForm("transaction_reference", event.target.value)}
                />
              </label>
            </div>

            <div className={styles.actions}>
              <button type="button" className={styles.primaryBtn} onClick={verifyAccount} disabled={resolving}>
                <FaCheck />
                <span>{resolving ? "Verifying..." : "Verify account"}</span>
              </button>
              <button type="button" className={styles.softBtn} onClick={regenerateReferences}>
                <FaRedoAlt />
                <span>New references</span>
              </button>
            </div>

            <div className={canUseReceipt ? styles.verifiedBox : styles.warningBox}>
              {canUseReceipt ? (
                <>
                  <FaCheck />
                  <span>{form.account_name} is verified for this account and bank.</span>
                </>
              ) : (
                <span>Verify the beneficiary account before using the receipt preview.</span>
              )}
            </div>
          </form>

          <section className={styles.previewPanel}>
            <div className={styles.previewTop}>
              <div>
                <p className={styles.kicker}>Preview</p>
                <h2>{form.template === "success" ? "Transfer success" : "Debit receipt"}</h2>
              </div>
              <div className={styles.previewActions}>
                <button type="button" onClick={copySummary} title="Copy receipt details" aria-label="Copy receipt details">
                  <FaCopy />
                </button>
                <button type="button" onClick={() => window.print()} title="Print receipt" aria-label="Print receipt">
                  <FaPrint />
                </button>
              </div>
            </div>

            <div className={styles.receiptStage}>
              {form.template === "success" ? (
                <SuccessReceipt form={form} canUseReceipt={canUseReceipt} />
              ) : (
                <DebitReceipt form={form} canUseReceipt={canUseReceipt} />
              )}
            </div>
          </section>
        </section>
      </main>
    </div>
  );
}

function SuccessReceipt({ form, canUseReceipt }) {
  return (
    <article className={`${styles.successReceipt} ${!canUseReceipt ? styles.unverifiedReceipt : ""}`}>
      <div className={styles.helpText}>Need Help?</div>
      <div className={styles.successMark}>
        <img src={successMarkImage} alt="" />
      </div>
      <h2>Transfer Successful</h2>
      <p>Beneficiary should get the money within 5 mins, depending on their bank.</p>
      <div className={styles.successCard}>
        <strong>{formatReceiptMoney(form.amount).replace(".00", "")}</strong>
        <b>{form.account_name || "Verify account name"}</b>
        <span>{form.bank_name || "Selected bank"}</span>
        <small>{formatShortDate(form.transaction_date)}</small>
        <div className={styles.progressLine}>
          <Step label="Transfer initiated" />
          <Step label="Transfer processed" />
          <Step label={`Received by ${form.bank_name || "bank"}`} />
        </div>
      </div>
    </article>
  );
}

function Step({ label }) {
  return (
    <div className={styles.step}>
      <span><FaCheck /></span>
      <b>{label}</b>
    </div>
  );
}

function DebitReceipt({ form, canUseReceipt }) {
  return (
    <article className={`${styles.debitReceipt} ${!canUseReceipt ? styles.unverifiedReceipt : ""}`}>
      <div className={styles.debitBrand}>
        <span>M</span>
        <div>
          <strong>Moniepoint</strong>
          <small>Microfinance Bank</small>
        </div>
      </div>
      <div className={styles.paper}>
        <span className={styles.debitPill}>DEBIT</span>
        <div className={styles.amountLine}>
          <strong>{formatReceiptMoney(form.amount)}</strong>
          <span>M</span>
        </div>
        <dl className={styles.receiptRows}>
          <ReceiptRow label="Transaction Type" value="Transfer" pill="blue" />
          <ReceiptRow label="Transaction Status" value="Successful" pill="green" />
          <ReceiptRow label="Business Name" value={form.business_name || "COPUPBID LIMITED -"} />
          <ReceiptRow label="Sender Name" value={form.sender_name || "COPUPBID LIMITED -"} />
          <ReceiptRow
            label="Beneficiary"
            value={`${form.account_name || "Verify account name"} | ${form.account_number || "Account number"}`}
          />
          <ReceiptRow label="Beneficiary Institution" value={form.bank_name || "Selected bank"} />
          <ReceiptRow label="Transaction Date" value={formatLongDate(form.transaction_date)} />
          <ReceiptRow label="Narration" value={form.narration || "Not set"} />
          <ReceiptRow label="Session ID" value={form.session_id || "Not set"} />
          <ReceiptRow label="Transaction Reference" value={form.transaction_reference || "Not set"} />
        </dl>
      </div>
    </article>
  );
}

function ReceiptRow({ label, value, pill }) {
  return (
    <div>
      <dt>{label}</dt>
      <dd className={pill === "blue" ? styles.bluePill : pill === "green" ? styles.greenPill : ""}>
        {value}
      </dd>
    </div>
  );
}

export default function AdminReceipts() {
  return (
    <ToastProvider>
      <AdminReceiptsPage />
    </ToastProvider>
  );
}
