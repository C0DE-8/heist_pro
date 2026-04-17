import React, { useCallback, useEffect, useMemo, useState } from "react";
import { useNavigate, useSearchParams } from "react-router-dom";
import { FiRefreshCw } from "react-icons/fi";
import Header from "../../components/Header/Header";
import Footer from "../../components/Footer/Footer";
import { useToast } from "../../components/Toast/ToastContext";
import {
  getAvailableHeists,
  getCompletedHeists,
  joinHeist,
} from "../../lib/heists";
import HeistCard from "./HeistCard";
import styles from "./Heist.module.css";

function formatNum(value) {
  const n = Number(value);
  return Number.isFinite(n) ? n.toLocaleString() : "0";
}

function getReferralCode(searchParams) {
  return (
    searchParams.get("referral_code") ||
    searchParams.get("ref") ||
    searchParams.get("code") ||
    ""
  );
}

export default function Heist() {
  const navigate = useNavigate();
  const toast = useToast();
  const [searchParams] = useSearchParams();
  const referralCode = useMemo(() => getReferralCode(searchParams), [searchParams]);

  const [available, setAvailable] = useState([]);
  const [completed, setCompleted] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [joiningId, setJoiningId] = useState(null);

  const loadHeists = useCallback(async () => {
    setLoading(true);
    setError("");

    try {
      const [availableData, completedData] = await Promise.all([
        getAvailableHeists(),
        getCompletedHeists(),
      ]);

      setAvailable(Array.isArray(availableData?.heists) ? availableData.heists : []);
      setCompleted(Array.isArray(completedData?.heists) ? completedData.heists : []);
    } catch (err) {
      console.error("Load heists error:", err);
      setError(err?.response?.data?.message || "Unable to load heists.");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadHeists();
  }, [loadHeists]);

  const handleJoin = async (heist) => {
    if (!heist?.id || joiningId) return;

    setJoiningId(heist.id);
    try {
      await joinHeist(heist.id, referralCode);
      toast.success("Joined heist");
      navigate(`/heist/${heist.id}`);
    } catch (err) {
      const message = err?.response?.data?.message || "Unable to join heist.";
      if (/already joined/i.test(message)) {
        navigate(`/heist/${heist.id}`);
      } else {
        toast.error(message);
      }
    } finally {
      setJoiningId(null);
    }
  };

  return (
    <div className={styles.page}>
      <Header />

      <main className={styles.main}>
        <section className={styles.statsGrid}>
          <div>
            <span>Available</span>
            <strong>{loading ? "..." : formatNum(available.length)}</strong>
          </div>
          <div>
            <span>Completed</span>
            <strong>{loading ? "..." : formatNum(completed.length)}</strong>
          </div>
          <div>
            <span>Referral</span>
            <strong>{referralCode ? "Active" : "None"}</strong>
          </div>
        </section>

        {error ? (
          <div className={styles.errorBox}>
            <span>{error}</span>
            <button type="button" onClick={loadHeists}>
              Retry
            </button>
          </div>
        ) : null}

        <section className={styles.sectionHead}>
          <div>
            <h2>Available Heists</h2>
          </div>
          <button type="button" onClick={loadHeists} className={styles.refreshBtn}>
            <FiRefreshCw />
          </button>
        </section>

        <section className={styles.heistList}>
          {loading ? (
            <div className={styles.emptyState}>Loading heists...</div>
          ) : available.length ? (
            available.map((heist) => (
              <HeistCard key={heist.id} heist={heist} onJoin={handleJoin} />
            ))
          ) : (
            <div className={styles.emptyState}>No available heists yet.</div>
          )}
        </section>

        <section className={styles.sectionHead}>
          <div>
            <h2>Won Heists</h2>
            <p>Completed heists with winners selected.</p>
          </div>
        </section>

        <section className={styles.completedList}>
          {loading ? (
            <div className={styles.emptyState}>Loading completed heists...</div>
          ) : completed.length ? (
            completed.slice(0, 6).map((heist) => (
              <button
                type="button"
                key={heist.id}
                className={styles.completedCard}
                onClick={() => navigate(`/heist/${heist.id}/result`)}
              >
                <span>{heist.name}</span>
                <strong>{formatNum(heist.prize_cop_points)} CP</strong>
              </button>
            ))
          ) : (
            <div className={styles.emptyState}>No won heists yet.</div>
          )}
        </section>
      </main>

      <Footer />
    </div>
  );
}
