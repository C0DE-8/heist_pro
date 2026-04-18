import React, { useCallback, useEffect, useMemo, useState } from "react";
import {
  FiAlertTriangle,
  FiAward,
  FiCheckCircle,
  FiChevronLeft,
  FiChevronRight,
  FiClock,
  FiCopy,
  FiRefreshCw,
  FiUsers,
} from "react-icons/fi";
import Header from "../../components/Header/Header";
import Footer from "../../components/Footer/Footer";
import SkeletonGrid from "../../components/SkeletonGrid/SkeletonGrid";
import { getCompletedHeists, getHeistLeaderboard } from "../../lib/heists";
import styles from "./Winner.module.css";

function formatNum(value) {
  const n = Number(value);
  return Number.isFinite(n) ? n.toLocaleString() : "0";
}

function formatDate(value) {
  if (!value) return "Not set";
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "Not set";
  return date.toLocaleString([], {
    month: "short",
    day: "numeric",
    hour: "numeric",
    minute: "2-digit",
  });
}

function formatSeconds(value) {
  const n = Number(value);
  if (!Number.isFinite(n)) return "0s";
  if (n < 60) return `${n}s`;
  const minutes = Math.floor(n / 60);
  const seconds = n - minutes * 60;
  return `${minutes}m ${seconds}s`;
}

function winnerName(heist) {
  return heist?.winner_full_name || heist?.winner_username || "Winner unavailable";
}

export default function Winner() {
  const [loading, setLoading] = useState(true);
  const [leaderboardLoading, setLeaderboardLoading] = useState(false);
  const [error, setError] = useState("");
  const [completed, setCompleted] = useState([]);
  const [leaderboard, setLeaderboard] = useState([]);
  const [activeIdx, setActiveIdx] = useState(0);
  const [copied, setCopied] = useState(false);

  const activeHeist = useMemo(() => {
    if (!completed.length) return null;
    return completed[Math.max(0, Math.min(activeIdx, completed.length - 1))] || null;
  }, [activeIdx, completed]);

  const loadCompleted = useCallback(async () => {
    setLoading(true);
    setError("");

    try {
      const data = await getCompletedHeists();
      const rows = Array.isArray(data?.heists) ? data.heists : [];
      setCompleted(rows);
      setActiveIdx(0);
    } catch (err) {
      console.error("Completed heists error:", err);
      setError(err?.response?.data?.message || "Unable to load completed heists.");
      setCompleted([]);
    } finally {
      setLoading(false);
    }
  }, []);

  const loadLeaderboard = useCallback(async (heistId) => {
    if (!heistId) {
      setLeaderboard([]);
      return;
    }

    setLeaderboardLoading(true);
    try {
      const data = await getHeistLeaderboard(heistId);
      setLeaderboard(Array.isArray(data?.leaderboard) ? data.leaderboard : []);
    } catch (err) {
      console.warn("Winner leaderboard error:", err);
      setLeaderboard([]);
    } finally {
      setLeaderboardLoading(false);
    }
  }, []);

  useEffect(() => {
    loadCompleted();
  }, [loadCompleted]);

  useEffect(() => {
    loadLeaderboard(activeHeist?.id);
  }, [activeHeist?.id, loadLeaderboard]);

  const copyWinner = async () => {
    if (!activeHeist) return;

    try {
      await navigator.clipboard.writeText(winnerName(activeHeist));
      setCopied(true);
      setTimeout(() => setCopied(false), 1300);
    } catch {
      setCopied(false);
    }
  };

  return (
    <div className={styles.page}>
      <div className={styles.bgGlow} aria-hidden="true">
        <svg className={styles.bgSvg} xmlns="http://www.w3.org/2000/svg">
          <defs>
            <radialGradient id="glow1" cx="50%" cy="50%" r="50%">
              <stop offset="0%" stopColor="#10b981" stopOpacity="0.30" />
              <stop offset="100%" stopColor="#10b981" stopOpacity="0" />
            </radialGradient>
            <radialGradient id="glow2" cx="50%" cy="50%" r="50%">
              <stop offset="0%" stopColor="#3b82f6" stopOpacity="0.22" />
              <stop offset="100%" stopColor="#3b82f6" stopOpacity="0" />
            </radialGradient>
          </defs>
          <circle cx="20%" cy="30%" r="320" fill="url(#glow1)" className={styles.pulse1} />
          <circle cx="80%" cy="70%" r="260" fill="url(#glow2)" className={styles.pulse2} />
        </svg>
      </div>

      <Header />

      <section className={styles.hero}>
        <div className={styles.container}>
          <div className={styles.heroCard}>
            <div className={styles.heroTop}>
              <div className={styles.heroIcon}>
                <FiAward />
              </div>

              <div className={styles.heroMain}>
                <div className={styles.heroTitle}>Winners</div>
                <div className={styles.heroSub}>
                  View completed heists, winners, prizes, and final leaderboard results.
                </div>

                <div className={styles.pills}>
                  <div className={styles.pill}>
                    <FiUsers />
                    <span>
                      Completed: <b>{formatNum(completed.length)}</b>
                    </span>
                  </div>
                  <div className={styles.pillAlt}>
                    {copied ? <FiCheckCircle /> : <FiClock />}
                    <span>{copied ? "Winner copied" : "Correct answers, speed, submit time"}</span>
                  </div>
                </div>
              </div>

              <div className={styles.heroActions}>
                <button type="button" className={styles.btnPrimary} onClick={loadCompleted}>
                  <FiRefreshCw style={{ marginRight: 8 }} />
                  Refresh
                </button>
              </div>
            </div>

            <div className={styles.selectorRow}>
              <button
                type="button"
                className={styles.pageBtn}
                onClick={() => setActiveIdx((idx) => Math.max(0, idx - 1))}
                disabled={activeIdx <= 0}
                title="Previous"
              >
                <FiChevronLeft />
              </button>

              <div className={styles.selectorMid}>
                <div className={styles.selectorTitle}>{activeHeist?.name || "No completed heist"}</div>
                <div className={styles.selectorSub}>
                  {activeHeist ? `Completed ${formatDate(activeHeist.updated_at)}` : "Completed heists will appear here"}
                </div>
              </div>

              <button
                type="button"
                className={styles.pageBtn}
                onClick={() =>
                  setActiveIdx((idx) => Math.min(completed.length - 1, idx + 1))
                }
                disabled={!completed.length || activeIdx >= completed.length - 1}
                title="Next"
              >
                <FiChevronRight />
              </button>
            </div>
          </div>
        </div>
      </section>

      <section className={styles.body}>
        <div className={styles.container}>
          {loading ? (
            <SkeletonGrid count={6} />
          ) : error ? (
            <div className={styles.stateCard}>
              <div className={styles.stateTop}>
                <div className={styles.stateIcon}>
                  <FiAlertTriangle />
                </div>
                <div>
                  <div className={styles.stateTitle}>Unable to load winners</div>
                  <div className={styles.stateSub}>{error}</div>
                </div>
              </div>
              <div className={styles.stateActions}>
                <button type="button" className={styles.btnPrimary} onClick={loadCompleted}>
                  Try again
                </button>
              </div>
            </div>
          ) : !activeHeist ? (
            <div className={styles.stateCard}>
              <div className={styles.stateTop}>
                <div className={styles.stateIcon}>
                  <FiAward />
                </div>
                <div>
                  <div className={styles.stateTitle}>No completed heists yet</div>
                  <div className={styles.stateSub}>
                    Once admins finalize heists, the winners will show here.
                  </div>
                </div>
              </div>
            </div>
          ) : (
            <>
              <div className={styles.gridTop}>
                <div className={styles.card}>
                  <div className={styles.cardHeader}>
                    <div className={styles.cardTitle}>Winner</div>
                    <div className={styles.cardSub}>Official winner selected during finalize</div>
                  </div>

                  <div className={styles.winnerRow}>
                    <div className={styles.avatarWrap}>
                      <div className={styles.avatarFallback}>
                        {String(winnerName(activeHeist)).slice(0, 1).toUpperCase()}
                      </div>
                    </div>

                    <div className={styles.winnerMain}>
                      <div className={styles.winnerName}>{winnerName(activeHeist)}</div>
                      <div className={styles.winnerSub}>
                        @{activeHeist.winner_username || "winner"}
                      </div>
                    </div>

                    <button type="button" className={styles.btnGhost} onClick={copyWinner}>
                      <FiCopy style={{ marginRight: 8 }} />
                      Copy
                    </button>
                  </div>

                  <div className={styles.divider} />

                  <div className={styles.metaGrid}>
                    <div className={styles.metaItem}>
                      <div className={styles.metaLabel}>Prize</div>
                      <div className={styles.metaValue}>
                        {formatNum(activeHeist.prize_cop_points)} CP
                      </div>
                    </div>
                    <div className={styles.metaItem}>
                      <div className={styles.metaLabel}>Status</div>
                      <div className={styles.metaValue}>{activeHeist.status}</div>
                    </div>
                    <div className={styles.metaItem}>
                      <div className={styles.metaLabel}>Ended</div>
                      <div className={styles.metaValue}>{formatDate(activeHeist.countdown_ends_at)}</div>
                    </div>
                  </div>
                </div>

                <div className={styles.card}>
                  <div className={styles.cardHeader}>
                    <div className={styles.cardTitle}>{activeHeist.name}</div>
                    <div className={styles.cardSub}>Completed heist summary</div>
                  </div>

                  <div className={styles.storyWrap}>
                    <p className={styles.story}>
                      {activeHeist.description || "No description was added for this heist."}
                    </p>
                  </div>

                  <div className={styles.prizeRow}>
                    <div className={styles.prizeImgFallback}>CP</div>
                    <div className={styles.prizeText}>
                      <div className={styles.prizeTitle}>
                        {formatNum(activeHeist.prize_cop_points)} CopUpCoin
                      </div>
                      <div className={styles.prizeSub}>Credited to the winner</div>
                    </div>
                  </div>
                </div>
              </div>

              <div className={styles.card}>
                <div className={styles.cardHeaderRow}>
                  <div>
                    <div className={styles.cardTitle}>Leaderboard</div>
                    <div className={styles.cardSub}>
                      Ranking: correct answers, total time, submitted time
                    </div>
                  </div>
                  <div className={styles.badgeSoft}>{leaderboard.length} submitted</div>
                </div>

                {leaderboardLoading ? (
                  <div className={styles.softNote}>Loading leaderboard...</div>
                ) : leaderboard.length ? (
                  <div className={styles.tableWrap}>
                    <table className={styles.table}>
                      <thead>
                        <tr>
                          <th>#</th>
                          <th>User</th>
                          <th>Correct</th>
                          <th>Wrong</th>
                          <th>Time</th>
                          <th>Submitted</th>
                        </tr>
                      </thead>
                      <tbody>
                        {leaderboard.map((row) => (
                          <tr key={`${row.rank}-${row.username}-${row.submitted_at}`}>
                            <td className={styles.tdRank}>{row.rank}</td>
                            <td>{row.username || "Unknown"}</td>
                            <td>{formatNum(row.correct_count)}</td>
                            <td>{formatNum(row.wrong_count)}</td>
                            <td>
                              <span className={styles.timePill}>
                                <FiClock style={{ marginRight: 6 }} />
                                {formatSeconds(row.total_time_seconds)}
                              </span>
                            </td>
                            <td>{formatDate(row.submitted_at)}</td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                ) : (
                  <div className={styles.softNote}>No submitted leaderboard rows for this heist.</div>
                )}
              </div>
            </>
          )}
        </div>
      </section>

      <Footer />
    </div>
  );
}
