import React, { useCallback, useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { FiArrowLeft, FiAward, FiClock, FiRefreshCw, FiTarget } from "react-icons/fi";
import Header from "../../components/Header/Header";
import Footer from "../../components/Footer/Footer";
import { getHeistLeaderboard } from "../../lib/heists";
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

export default function HeistLeaderboard() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [rows, setRows] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const loadLeaderboard = useCallback(async () => {
    setLoading(true);
    setError("");

    try {
      const data = await getHeistLeaderboard(id);
      setRows(Array.isArray(data?.leaderboard) ? data.leaderboard : []);
    } catch (err) {
      console.error("Load leaderboard error:", err);
      setError(err?.response?.data?.message || "Unable to load leaderboard.");
    } finally {
      setLoading(false);
    }
  }, [id]);

  useEffect(() => {
    loadLeaderboard();
  }, [loadLeaderboard]);

  const topRow = rows[0];

  return (
    <div className={styles.page}>
      <Header />

      <main className={styles.main}>
        <button type="button" className={styles.backBtn} onClick={() => navigate(`/heist/${id}`)}>
          <FiArrowLeft />
          <span>Heist</span>
        </button>

        <section className={styles.hero}>
          <div className={styles.heroIcon}>
            <FiAward />
          </div>
          <div>
            <p className={styles.kicker}>Heist Leaderboard</p>
            <h1>Top runs</h1>
            <p>Ranked by correct answers, fastest total time, then earliest submission.</p>
          </div>
        </section>

        {error ? (
          <div className={styles.errorBox}>
            <span>{error}</span>
            <button type="button" onClick={loadLeaderboard}>
              Retry
            </button>
          </div>
        ) : null}

        <section className={styles.resultPanel}>
          <div className={styles.sectionHead}>
            <div>
              <h2>Leaderboard</h2>
              <p>{loading ? "Loading ranks..." : `${formatNum(rows.length)} submitted runs`}</p>
            </div>
            <button
              type="button"
              className={styles.refreshBtn}
              onClick={loadLeaderboard}
              disabled={loading}
              aria-label="Refresh leaderboard"
            >
              <FiRefreshCw />
            </button>
          </div>

          {topRow ? (
            <div className={styles.winnerBox}>
              <span>Current leader</span>
              <strong>
                #{formatNum(topRow.rank)} {topRow.username || "Player"} with{" "}
                {formatNum(topRow.correct_count)} correct in {formatNum(topRow.total_time_seconds)}s
              </strong>
            </div>
          ) : null}

          {loading ? (
            <div className={styles.emptyState}>Loading leaderboard...</div>
          ) : rows.length ? (
            <div className={styles.leaderboardTableWrap}>
              <table className={styles.leaderboardTable}>
                <thead>
                  <tr>
                    <th>Rank</th>
                    <th>Player</th>
                    <th>Correct</th>
                    <th>Wrong</th>
                    <th>Unanswered</th>
                    <th>Score</th>
                    <th>Time</th>
                    <th>Submitted</th>
                  </tr>
                </thead>
                <tbody>
                  {rows.map((row) => (
                    <tr key={`${row.rank}-${row.username}-${row.submitted_at}`}>
                      <td>
                        <strong>#{formatNum(row.rank)}</strong>
                      </td>
                      <td>{row.username || "Player"}</td>
                      <td>
                        <FiTarget />
                        {formatNum(row.correct_count)}
                      </td>
                      <td>{formatNum(row.wrong_count)}</td>
                      <td>{formatNum(row.unanswered_count)}</td>
                      <td>{formatNum(row.score_percent)}%</td>
                      <td>
                        <FiClock />
                        {formatNum(row.total_time_seconds)}s
                      </td>
                      <td>{formatDate(row.submitted_at)}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          ) : (
            <div className={styles.emptyState}>No submitted runs yet.</div>
          )}
        </section>
      </main>

      <Footer />
    </div>
  );
}
