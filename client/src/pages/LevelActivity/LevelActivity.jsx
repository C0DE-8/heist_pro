import React, { useCallback, useEffect, useState } from "react";
import { RefreshCw, ScrollText } from "lucide-react";
import Header from "../../components/Header/Header";
import Footer from "../../components/Footer/Footer";
import XpEventList from "../../components/XpEventList/XpEventList";
import LevelProgressBar from "../../components/LevelProgressBar/LevelProgressBar";
import { getUserProgress } from "../../lib/levels";
import styles from "../Rewards/Rewards.module.css";

export default function LevelActivity() {
  const [progress, setProgress] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const loadActivity = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      setProgress(await getUserProgress());
    } catch (err) {
      setError(err?.response?.data?.message || "Unable to load XP activity.");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadActivity();
  }, [loadActivity]);

  return (
    <div className={styles.page}>
      <Header />
      <main className={styles.main}>
        <section className={styles.hero}>
          <div>
            <p className={styles.kicker}>XP Activity</p>
            <h1>Progress ledger</h1>
            <p>{loading ? "Loading XP..." : "Daily login, heists, referrals, deposits, and withdrawals."}</p>
          </div>
          <button type="button" className={styles.refreshBtn} onClick={loadActivity} disabled={loading}>
            <RefreshCw size={16} />
          </button>
        </section>

        {error ? <div className={styles.errorBox}>{error}</div> : null}

        <LevelProgressBar
          progress={progress}
          onLevels={() => window.location.assign("/levels")}
          onRewards={() => window.location.assign("/rewards")}
        />

        <section className={styles.panel}>
          <div className={styles.panelHead}>
            <ScrollText size={18} />
            <div>
              <h2>Recent XP</h2>
              <p>{loading ? "Loading..." : `${progress?.recent_events?.length || 0} latest events`}</p>
            </div>
          </div>
          <XpEventList events={progress?.recent_events || []} />
        </section>
      </main>
      <Footer />
    </div>
  );
}
