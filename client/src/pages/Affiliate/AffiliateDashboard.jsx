import React, { useCallback, useEffect, useMemo, useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  FiBookOpen,
  FiCopy,
  FiCreditCard,
  FiEye,
  FiEyeOff,
  FiTarget,
  FiTrendingUp,
  FiUsers,
} from "react-icons/fi";
import Header from "../../components/Header/Header";
import Footer from "../../components/Footer/Footer";
import { getPaymentInfo } from "../../lib/transactions";
import { getAffiliateTileDashboard, getUserProfile } from "../../lib/users";
import styles from "../Home/Home.module.css";

const WALLET_HIDE_KEY = "copup_affiliate_hide_wallet_balance";

function formatNum(value) {
  const n = Number(value);
  return Number.isFinite(n) ? n.toLocaleString() : "0";
}

function formatMoney(value, currency = "NGN") {
  const n = Number(value);
  return `${currency} ${Number.isFinite(n) ? n.toLocaleString(undefined, { maximumFractionDigits: 2 }) : "0"}`;
}

function coinValue(copPoints, rate) {
  const points = Number(copPoints || 0);
  const unit = Number(rate?.unit || 0);
  const price = Number(rate?.price || 0);
  if (!Number.isFinite(points) || !Number.isFinite(unit) || !Number.isFinite(price) || unit <= 0) {
    return null;
  }
  return Number(((points / unit) * price).toFixed(2));
}

function shortText(value, start = 6, end = 4) {
  const text = String(value || "");
  if (!text) return "Not assigned";
  if (text.length <= start + end + 3) return text;
  return `${text.slice(0, start)}...${text.slice(-end)}`;
}

export default function AffiliateDashboard() {
  const navigate = useNavigate();
  const [profileData, setProfileData] = useState(null);
  const [dashboard, setDashboard] = useState(null);
  const [paymentInfo, setPaymentInfo] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [copied, setCopied] = useState("");
  const [hideWallet, setHideWallet] = useState(
    () => localStorage.getItem(WALLET_HIDE_KEY) === "1"
  );

  const user = profileData?.user || null;
  const displayName = user?.full_name || user?.username || "Affiliate";
  const copPoints = Number(user?.cop_point || 0);
  const stats = dashboard?.stats || {};
  const assignedTile = dashboard?.assigned_tile || null;
  const estimatedEarning = Number(dashboard?.estimated_earning_cop_points || 0);
  const coinRate = paymentInfo?.coin_rate || null;
  const earningValue = coinValue(estimatedEarning, coinRate);
  const currency = coinRate?.currency || "NGN";

  const loadDashboard = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      const [profile, tileDashboard, info] = await Promise.all([
        getUserProfile(),
        getAffiliateTileDashboard(),
        getPaymentInfo(),
      ]);
      setProfileData(profile);
      setDashboard(tileDashboard);
      setPaymentInfo(info);
    } catch (err) {
      console.error("Affiliate dashboard error:", err);
      setError(err?.response?.data?.message || "Unable to load affiliate dashboard.");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadDashboard();
  }, [loadDashboard]);

  const cards = useMemo(
    () => [
      {
        title: "Tile Plans",
        sub: assignedTile ? `Current: Level ${formatNum(assignedTile.tile_level)}` : "Join or switch your plan",
        icon: <FiTarget />,
        action: () => navigate("/affiliate/plans"),
      },
      {
        title: "Referral Tools",
        sub: `${formatNum(stats.direct_affiliates)} direct affiliates`,
        icon: <FiUsers />,
        action: () => navigate("/affiliate/referral"),
      },
      {
        title: "How It Works",
        sub: "Learn targets and payouts",
        icon: <FiBookOpen />,
        action: () => navigate("/affiliate/how-it-works"),
      },
      {
        title: "Wallet",
        sub: "Top up or withdraw",
        icon: <FiCreditCard />,
        action: () => navigate("/account"),
      },
    ],
    [assignedTile, navigate, stats.direct_affiliates]
  );

  const copyValue = async (label, value) => {
    if (!value) return;
    try {
      await navigator.clipboard.writeText(String(value));
      setCopied(label);
      window.setTimeout(() => setCopied(""), 1400);
    } catch {
      setCopied("");
    }
  };

  return (
    <div className={styles.page}>
      <Header />

      <main className={styles.main}>
        <section className={styles.hero}>
          <p className={styles.welcome}>Affiliate dashboard, {displayName}</p>

          <div className={styles.balanceRow}>
            <h1 className={styles.balance}>
              {loading ? "..." : hideWallet ? "••••••" : `${formatNum(copPoints)} CP`}
            </h1>
            <button
              type="button"
              className={styles.eyeBtn}
              onClick={() => {
                setHideWallet((prev) => {
                  const next = !prev;
                  localStorage.setItem(WALLET_HIDE_KEY, next ? "1" : "0");
                  return next;
                });
              }}
              title={hideWallet ? "Show balance" : "Hide balance"}
            >
              {hideWallet ? <FiEye /> : <FiEyeOff />}
            </button>
          </div>

          <div className={styles.topActionRow}>
            <button
              type="button"
              className={styles.actionBtn}
              onClick={() => navigate("/affiliate/plans")}
            >
              <FiTrendingUp />
              <span>
                {loading
                  ? "Loading earnings..."
                  : earningValue !== null
                    ? `${formatNum(estimatedEarning)} CP · ${formatMoney(earningValue, currency)}`
                    : `${formatNum(estimatedEarning)} CP estimated`}
              </span>
            </button>
          </div>

          <div className={styles.metaRow}>
            <button
              type="button"
              className={styles.metaBtn}
              onClick={() => copyValue("referral code", user?.referral_code)}
            >
              <span>Referral code</span>
              <strong>{user?.referral_code || "Not assigned"}</strong>
              <FiCopy />
            </button>

            <button
              type="button"
              className={styles.metaBtn}
              onClick={() => copyValue("wallet", user?.wallet_address)}
            >
              <span>Wallet</span>
              <strong>{shortText(user?.wallet_address)}</strong>
              <FiCopy />
            </button>
          </div>

          {copied ? <div className={styles.copied}>{copied} copied</div> : null}
        </section>

        <section className={styles.quickLinks}>
          <button type="button" className={styles.quickLink} onClick={() => navigate("/affiliate/plans")}>
            <FiTarget />
            <span>Plans</span>
          </button>
          <button type="button" className={styles.quickLink} onClick={() => navigate("/affiliate/referral")}>
            <FiUsers />
            <span>Referral</span>
          </button>
          <button type="button" className={styles.quickLink} onClick={() => navigate("/affiliate/how-it-works")}>
            <FiBookOpen />
            <span>Guide</span>
          </button>
        </section>

        {error ? (
          <div className={styles.errorBox}>
            <span>{error}</span>
            <button type="button" onClick={loadDashboard}>
              Retry
            </button>
          </div>
        ) : null}

        <section className={styles.cardList}>
          {cards.map((card) => (
            <button key={card.title} type="button" className={styles.card} onClick={card.action}>
              <div className={styles.cardImageWrap}>{card.icon}</div>
              <div className={styles.cardText}>
                <h3>{card.title}</h3>
                <p>{loading ? "Loading..." : card.sub}</p>
              </div>
            </button>
          ))}
        </section>
      </main>

      <Footer />
    </div>
  );
}
