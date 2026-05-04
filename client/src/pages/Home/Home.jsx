import React, { useCallback, useEffect, useMemo, useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  FiArrowUpRight,
  FiCopy,
  FiEye,
  FiEyeOff,
  FiHelpCircle,
  FiTarget,
  FiRepeat,
  FiCreditCard,
} from "react-icons/fi";
import Header from "../../components/Header/Header";
import Footer from "../../components/Footer/Footer";
import { getStoredToken } from "../../lib/auth";
import { getUserProfile } from "../../lib/users";
import styles from "./Home.module.css";

import m1Img from "../../assets/m1.png";
import m2Img from "../../assets/m2.png";
import m3Img from "../../assets/m3.png";
import m4Img from "../../assets/m4.png";

const WALLET_HIDE_KEY = "copup_hide_wallet_balance";

function formatNum(value) {
  const n = Number(value);
  return Number.isFinite(n) ? n.toLocaleString() : "0";
}

function shortText(value, start = 6, end = 4) {
  const text = String(value || "");
  if (!text) return "Not assigned";
  if (text.length <= start + end + 3) return text;
  return `${text.slice(0, start)}...${text.slice(-end)}`;
}

export default function Home() {
  const navigate = useNavigate();
  const token = useMemo(() => getStoredToken(), []);

  const [profileData, setProfileData] = useState(null);
  const [loading, setLoading] = useState(Boolean(token));
  const [error, setError] = useState("");
  const [hideWallet, setHideWallet] = useState(
    () => localStorage.getItem(WALLET_HIDE_KEY) === "1"
  );
  const [copied, setCopied] = useState("");

  const user = profileData?.user || null;
  const displayName = user?.full_name || user?.username || "Player";
  const copPoints = Number(user?.cop_point || 0);
  const monthHighlights = useMemo(
    () => ["May Missions", "Fresh Drops", "Fast Trade Windows"],
    []
  );

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
      console.error("Home profile error:", err);
      setError(err?.response?.data?.message || "Unable to load dashboard.");
    } finally {
      setLoading(false);
    }
  }, [token]);

  useEffect(() => {
    loadProfile();
  }, [loadProfile]);

  const copyValue = async (label, value) => {
    if (!value) return;

    try {
      await navigator.clipboard.writeText(String(value));
      setCopied(label);
      setTimeout(() => setCopied(""), 1400);
    } catch (err) {
      setCopied("");
    }
  };

  const toggleWalletVisibility = () => {
    setHideWallet((prev) => {
      const next = !prev;
      localStorage.setItem(WALLET_HIDE_KEY, next ? "1" : "0");
      return next;
    });
  };

  const cards = [
    {
      id: 1,
      title: "Heist Arena",
      sub: "Join live missions",
      image: m1Img,
      tone: "mint",
      action: () => navigate("/heist"),
    },
    {
      id: 2,
      title: "Trade Hub",
      sub: "Manage your exchange",
      image: m2Img,
      tone: "sky",
      action: () => navigate("/trade"),
    },
    {
      id: 3,
      title: "How To Play",
      sub: "Learn the full flow",
      image: m3Img,
      tone: "gold",
      action: () => navigate("/how-to-play"),
    },
    {
      id: 4,
      title: "Your Wallet",
      sub: "Track points and access",
      image: m4Img,
      tone: "rose",
      action: () => navigate("/profile"),
    },
  ];

  const setParallax = (event, strength = 1) => {
    const element = event.currentTarget;
    const rect = element.getBoundingClientRect();
    const x = (event.clientX - rect.left) / rect.width - 0.5;
    const y = (event.clientY - rect.top) / rect.height - 0.5;

    element.style.setProperty("--pointer-x", (x * strength).toFixed(3));
    element.style.setProperty("--pointer-y", (y * strength).toFixed(3));
  };

  const resetParallax = (event) => {
    const element = event.currentTarget;
    element.style.setProperty("--pointer-x", "0");
    element.style.setProperty("--pointer-y", "0");
  };

  return (
    <div className={styles.page}>
      <Header />

      <main className={styles.main}>
        <section
          className={styles.hero}
          onPointerMove={(event) => setParallax(event, 1)}
          onPointerLeave={resetParallax}
        >
          <div className={styles.heroBackdrop} aria-hidden="true">
            <span className={`${styles.orb} ${styles.orbA}`} />
            <span className={`${styles.orb} ${styles.orbB}`} />
            <span className={`${styles.orb} ${styles.orbC}`} />
            <span className={styles.gridGlow} />
          </div>

          <div className={styles.heroTop}>
            <div className={styles.heroCopy}>
              <div className={styles.mayTag}>May Edition</div>
              <p className={styles.welcome}>Welcome back, {displayName}</p>
              <h1 className={styles.heroTitle}>Bloom your balance and chase the next drop.</h1>
              <p className={styles.heroText}>
                Fresh missions, quicker trade checks, and a cleaner wallet view for the month of
                May.
              </p>

              <div className={styles.balanceRow}>
                <h2 className={styles.balance}>
                  {loading ? "..." : hideWallet ? "••••••" : `${formatNum(copPoints)} CP`}
                </h2>

                <button
                  type="button"
                  className={styles.eyeBtn}
                  onClick={toggleWalletVisibility}
                  title={hideWallet ? "Show balance" : "Hide balance"}
                >
                  {hideWallet ? <FiEye /> : <FiEyeOff />}
                </button>
              </div>

              <div className={styles.topActionRow}>
                <button
                  type="button"
                  className={styles.actionBtn}
                  onClick={() => navigate("/account")}
                >
                  <FiCreditCard />
                  <span>Top up / Withdraw</span>
                  <FiArrowUpRight />
                </button>
              </div>
            </div>

            <div className={styles.heroScene} aria-hidden="true">
              <div className={styles.scenePlate} />
              <div className={`${styles.depthCard} ${styles.depthCardBack}`}>
                <span>Season Pulse</span>
                <strong>High</strong>
              </div>
              <div className={`${styles.depthCard} ${styles.depthCardMid}`}>
                <span>May Window</span>
                <strong>Live</strong>
              </div>
              <div className={`${styles.depthCard} ${styles.depthCardFront}`}>
                <span>CopUpCoin</span>
                <strong>{loading ? "..." : formatNum(copPoints)}</strong>
              </div>
              <div className={styles.sceneRing} />
            </div>
          </div>

          <div className={styles.highlightRow}>
            {monthHighlights.map((item) => (
              <span key={item} className={styles.highlightPill}>
                {item}
              </span>
            ))}
          </div>

          <div className={styles.metaRow}>
            <button
              type="button"
              className={styles.metaBtn}
              onClick={() => copyValue("wallet", user?.wallet_address)}
            >
              <span>Wallet</span>
              <strong>{shortText(user?.wallet_address)}</strong>
              <FiCopy />
            </button>

            <button
              type="button"
              className={styles.metaBtn}
              onClick={() => copyValue("game id", user?.game_id)}
            >
              <span>Game ID</span>
              <strong>{shortText(user?.game_id)}</strong>
              <FiCopy />
            </button>
          </div>

          {copied ? <div className={styles.copied}>{copied} copied</div> : null}
        </section>

        <section className={styles.quickLinks}>
          <button type="button" className={styles.quickLink} onClick={() => navigate("/heist")}>
            <FiTarget />
            <span>Heist</span>
          </button>

          <button type="button" className={styles.quickLink} onClick={() => navigate("/trade")}>
            <FiRepeat />
            <span>Trade</span>
          </button>

          <button type="button" className={styles.quickLink} onClick={() => navigate("/how-to-play")}>
            <FiHelpCircle />
            <span>How To Play</span>
          </button>
        </section>

        {error ? (
          <div className={styles.errorBox}>
            <span>{error}</span>
            <button type="button" onClick={loadProfile}>
              Retry
            </button>
          </div>
        ) : null}

        <section className={styles.sectionHead}>
          <div>
            <span className={styles.sectionKicker}>Curated For May</span>
            <h2>Seasonal shortcuts</h2>
          </div>
        </section>

        <section className={styles.cardList}>
          {cards.map((card) => (
            <button
              key={card.id}
              type="button"
              className={`${styles.card} ${styles[card.tone]}`}
              onClick={card.action}
              onPointerMove={(event) => setParallax(event, 1.4)}
              onPointerLeave={resetParallax}
            >
              <div className={styles.cardGlow} aria-hidden="true" />
              <div className={styles.cardImageWrap}>
                <img src={card.image} alt={card.title} className={styles.cardImage} />
              </div>

              <div className={styles.cardText}>
                <span className={styles.cardEyebrow}>May pick</span>
                <h3>{card.title}</h3>
                <p>{card.sub}</p>
              </div>
            </button>
          ))}
        </section>
      </main>

      <Footer />
    </div>
  );
}
