import React, { useCallback, useEffect, useState } from "react";
import { Gift, RefreshCw, TicketCheck } from "lucide-react";
import Header from "../../components/Header/Header";
import Footer from "../../components/Footer/Footer";
import LevelProgressBar from "../../components/LevelProgressBar/LevelProgressBar";
import LevelRewardList from "../../components/LevelRewardList/LevelRewardList";
import { useToast } from "../../components/Toast/ToastContext";
import {
  claimUserLevelReward,
  getUserProgress,
  redeemUserLevelRewardCode,
} from "../../lib/levels";
import styles from "./Rewards.module.css";

export default function Rewards() {
  const toast = useToast();
  const [progress, setProgress] = useState(null);
  const [code, setCode] = useState("");
  const [loading, setLoading] = useState(true);
  const [busyId, setBusyId] = useState("");
  const [redeeming, setRedeeming] = useState(false);
  const [error, setError] = useState("");

  const rewards = Array.isArray(progress?.rewards) ? progress.rewards : [];

  const loadProgress = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      setProgress(await getUserProgress());
    } catch (err) {
      setError(err?.response?.data?.message || "Unable to load rewards.");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadProgress();
  }, [loadProgress]);

  const claimReward = async (rewardId) => {
    setBusyId(rewardId);
    try {
      const data = await claimUserLevelReward(rewardId);
      toast.success(data?.message || "Reward claimed");
      await loadProgress();
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to claim reward.");
    } finally {
      setBusyId("");
    }
  };

  const copyCode = async (value) => {
    try {
      await navigator.clipboard.writeText(value);
      toast.success("Code copied");
    } catch {
      toast.error("Unable to copy code");
    }
  };

  const redeemCode = async (event) => {
    event.preventDefault();
    if (!code.trim()) return;
    setRedeeming(true);
    try {
      const data = await redeemUserLevelRewardCode(code);
      toast.success(data?.message || "Code redeemed");
      setCode("");
      await loadProgress();
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to redeem code.");
    } finally {
      setRedeeming(false);
    }
  };

  return (
    <div className={styles.page}>
      <Header />
      <main className={styles.main}>
        <section className={styles.hero}>
          <div>
            <p className={styles.kicker}>Rewards</p>
            <h1>Coupons</h1>
            <p>Claim earned codes and redeem them into Gift CopUp Coin for heist entries.</p>
          </div>
          <button type="button" className={styles.refreshBtn} onClick={loadProgress} disabled={loading}>
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
            <Gift size={18} />
            <div>
              <h2>Redeem code</h2>
              <p>Use a claimed coupon code.</p>
            </div>
          </div>
          <form className={styles.redeemForm} onSubmit={redeemCode}>
            <input
              value={code}
              onChange={(event) => setCode(event.target.value.toUpperCase())}
              placeholder="LVL2-USER-CODE"
            />
            <button type="submit" disabled={redeeming || !code.trim()}>
              <TicketCheck size={16} />
              <span>{redeeming ? "Redeeming" : "Redeem"}</span>
            </button>
          </form>
        </section>

        <section className={styles.panel}>
          <div className={styles.panelHead}>
            <Gift size={18} />
            <div>
              <h2>Earned coupons</h2>
              <p>{loading ? "Loading..." : `${rewards.length} rewards found`}</p>
            </div>
          </div>
          <LevelRewardList
            rewards={rewards}
            busyId={busyId}
            onClaim={claimReward}
            onCopy={copyCode}
          />
        </section>
      </main>
      <Footer />
    </div>
  );
}
