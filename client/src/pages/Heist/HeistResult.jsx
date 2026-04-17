import React, { useCallback, useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { FiArrowLeft, FiAward, FiClock, FiTarget } from "react-icons/fi";
import Header from "../../components/Header/Header";
import Footer from "../../components/Footer/Footer";
import { getHeistResult } from "../../lib/heists";
import styles from "./Heist.module.css";

function formatNum(value) {
  const n = Number(value);
  return Number.isFinite(n) ? n.toLocaleString() : "0";
}

function formatDate(value) {
  if (!value) return "Pending";
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "Pending";
  return date.toLocaleString();
}

export default function HeistResult() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const loadResult = useCallback(async () => {
    setLoading(true);
    setError("");

    try {
      const result = await getHeistResult(id);
      setData(result);
    } catch (err) {
      console.error("Load result error:", err);
      setError(err?.response?.data?.message || "Unable to load result.");
    } finally {
      setLoading(false);
    }
  }, [id]);

  useEffect(() => {
    loadResult();
  }, [loadResult]);

  const result = data?.result;
  const winner = data?.winner;

  return (
    <div className={styles.page}>
      <Header />

      <main className={styles.main}>
        <button type="button" className={styles.backBtn} onClick={() => navigate("/heist")}>
          <FiArrowLeft />
          <span>Heists</span>
        </button>

        <section className={styles.hero}>
          <div className={styles.heroIcon}>
            <FiAward />
          </div>
          <div>
            <p className={styles.kicker}>Heist Result</p>
            <h1>{winner ? "Winner selected" : "Your result"}</h1>
            <p>Results use correct count, total time, then submitted time.</p>
          </div>
        </section>

        {error ? (
          <div className={styles.errorBox}>
            <span>{error}</span>
            <button type="button" onClick={loadResult}>
              Retry
            </button>
          </div>
        ) : null}

        <section className={styles.resultPanel}>
          {loading ? (
            <div className={styles.emptyState}>Loading result...</div>
          ) : result ? (
            <>
              <div className={styles.statsGrid}>
                <div>
                  <span>Correct</span>
                  <strong>{formatNum(result.correct_count)}</strong>
                </div>
                <div>
                  <span>Wrong</span>
                  <strong>{formatNum(result.wrong_count)}</strong>
                </div>
                <div>
                  <span>Unanswered</span>
                  <strong>{formatNum(result.unanswered_count)}</strong>
                </div>
              </div>

              <div className={styles.metaGrid}>
                <div>
                  <FiTarget />
                  <span>{formatNum(result.score_percent)}% score</span>
                </div>
                <div>
                  <FiClock />
                  <span>{formatNum(result.total_time_seconds)} seconds</span>
                </div>
                <div>
                  <FiAward />
                  <span>Submitted {formatDate(result.submitted_at)}</span>
                </div>
              </div>

              {winner ? (
                <div className={styles.winnerBox}>
                  <span>Winner</span>
                  <strong>
                    {winner.username || `User #${winner.user_id}`} won{" "}
                    {formatNum(winner.prize_cop_points)} CP
                  </strong>
                </div>
              ) : null}
            </>
          ) : (
            <div className={styles.emptyState}>No submitted result found.</div>
          )}
        </section>
      </main>

      <Footer />
    </div>
  );
}
