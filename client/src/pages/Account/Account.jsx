import React, { useCallback, useEffect, useMemo, useState } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import { FiArrowLeft, FiCopy, FiCreditCard, FiDownload, FiShield } from "react-icons/fi";
import Header from "../../components/Header/Header";
import Footer from "../../components/Footer/Footer";
import { getStoredToken } from "../../lib/auth";
import { initCopupTopup } from "../../lib/payment";
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

export default function Account() {
  const navigate = useNavigate();
  const location = useLocation();
  const token = useMemo(() => getStoredToken(), []);
  const selectedTab = new URLSearchParams(location.search).get("tab") || "topup";

  const [activeTab, setActiveTab] = useState(
    selectedTab === "withdraw" ? "withdraw" : "topup"
  );
  const [profileData, setProfileData] = useState(null);
  const [loading, setLoading] = useState(Boolean(token));
  const [paymentLoading, setPaymentLoading] = useState(false);
  const [amountNgn, setAmountNgn] = useState("1000");
  const [error, setError] = useState("");
  const [copied, setCopied] = useState(false);

  const user = profileData?.user || null;
  const copPoints = Number(user?.cop_point || 0);

  const loadProfile = useCallback(async () => {
    if (!token) {
      setLoading(false);
      return;
    }

    setLoading(true);
    setError("");

    try {
      const data = await getUserProfile();
      setProfileData(data);
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

  const copyWallet = async () => {
    if (!user?.wallet_address) return;

    try {
      await navigator.clipboard.writeText(String(user.wallet_address));
      setCopied(true);
      setTimeout(() => setCopied(false), 1400);
    } catch (err) {
      setCopied(false);
    }
  };

  const changeTab = (tab) => {
    setActiveTab(tab);
    navigate(`/account?tab=${tab}`, { replace: true });
  };

  const chooseAmount = (amount) => {
    setAmountNgn(String(amount));
    setError("");
  };

  const startTopup = async (event) => {
    event.preventDefault();
    if (paymentLoading) return;

    const amount = Number(amountNgn);
    if (!Number.isFinite(amount) || amount <= 0) {
      setError("Enter a valid top-up amount.");
      return;
    }

    setPaymentLoading(true);
    setError("");

    try {
      const data = await initCopupTopup(amount);
      if (!data?.ok || !data?.payment_link) {
        setError(data?.message || "Unable to start payment.");
        return;
      }

      window.location.href = data.payment_link;
    } catch (err) {
      console.error("Top-up init error:", err);
      setError(err?.response?.data?.message || "Unable to start payment.");
    } finally {
      setPaymentLoading(false);
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
              Top up your CopUpCoin balance for Heist tickets and rewards.
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
                  <h2>Top up CopUpCoin</h2>
                  <p>
                    Pay securely with Flutterwave. Your credited coins are added to your
                    CopUpCoin balance after verification.
                  </p>
                </div>

                <div className={styles.amountGrid}>
                  {[1000, 2500, 5000, 10000].map((amount) => (
                    <button
                      type="button"
                      key={amount}
                      className={Number(amountNgn) === amount ? styles.selectedAmount : ""}
                      onClick={() => chooseAmount(amount)}
                    >
                      ₦{formatNum(amount)}
                    </button>
                  ))}
                </div>

                <label className={styles.amountField}>
                  <span>Amount in NGN</span>
                  <input
                    type="number"
                    min="1"
                    inputMode="numeric"
                    value={amountNgn}
                    onChange={(event) => {
                      setAmountNgn(event.target.value);
                      setError("");
                    }}
                    placeholder="Enter amount"
                    disabled={paymentLoading}
                  />
                </label>

                <button type="submit" className={styles.payBtn} disabled={paymentLoading}>
                  {paymentLoading ? "Starting payment..." : "Continue to payment"}
                </button>
              </form>
            ) : (
              <div>
                <h2>Withdraw coming soon</h2>
                <p>
                  Withdrawal controls are not live yet. Your current CopUpCoin balance is
                  already synced from the backend profile endpoint.
                </p>
                <button type="button" className={styles.demoBtn}>
                  Demo only
                </button>
              </div>
            )}
          </div>
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
