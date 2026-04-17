import React, { useCallback, useEffect, useMemo, useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  FiArrowLeft,
  FiCheckCircle,
  FiCopy,
  FiExternalLink,
  FiLink,
  FiRefreshCw,
  FiTrendingUp,
  FiUsers,
} from "react-icons/fi";
import Header from "../../components/Header/Header";
import Footer from "../../components/Footer/Footer";
import { useToast } from "../../components/Toast/ToastContext";
import { createHeistAffiliateLink, getAvailableHeists } from "../../lib/heists";
import { getUserProfile } from "../../lib/users";
import styles from "./Affiliate.module.css";

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

function progressPercent(current, required) {
  const c = Number(current || 0);
  const r = Number(required || 0);
  if (!r) return 0;
  return Math.min(100, Math.round((c / r) * 100));
}

export default function Affiliate() {
  const navigate = useNavigate();
  const toast = useToast();

  const [heists, setHeists] = useState([]);
  const [profileData, setProfileData] = useState(null);
  const [linksByHeist, setLinksByHeist] = useState({});
  const [loading, setLoading] = useState(true);
  const [busyId, setBusyId] = useState(null);
  const [busyAll, setBusyAll] = useState(false);
  const [copiedKey, setCopiedKey] = useState("");
  const [error, setError] = useState("");

  const affiliateStats = profileData?.stats?.affiliate || {};
  const taskStats = profileData?.stats?.affiliate_tasks || {};
  const taskProgress = Array.isArray(profileData?.affiliate_task_progress)
    ? profileData.affiliate_task_progress
    : [];

  const activeHeists = useMemo(
    () => heists.filter((heist) => heist.status !== "completed" && heist.status !== "cancelled"),
    [heists]
  );

  const loadAffiliate = useCallback(async () => {
    setLoading(true);
    setError("");

    try {
      const [heistData, profile] = await Promise.all([
        getAvailableHeists(),
        getUserProfile(),
      ]);

      setHeists(Array.isArray(heistData?.heists) ? heistData.heists : []);
      setProfileData(profile);
    } catch (err) {
      console.error("Affiliate load error:", err);
      setError(err?.response?.data?.message || "Unable to load affiliate page.");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadAffiliate();
  }, [loadAffiliate]);

  const copyValue = async (key, value, label) => {
    if (!value) return false;

    try {
      await navigator.clipboard.writeText(String(value));
      setCopiedKey(key);
      toast.success(`${label} copied`);
      window.setTimeout(() => setCopiedKey(""), 1400);
      return true;
    } catch (err) {
      toast.error("Unable to copy");
      return false;
    }
  };

  const generateLink = async (heistId, { copy = true } = {}) => {
    if (!heistId || busyId || busyAll) return;

    setBusyId(heistId);
    try {
      const data = await createHeistAffiliateLink(heistId);
      setLinksByHeist((prev) => ({
        ...prev,
        [heistId]: data,
      }));
      if (copy && data?.referral_link) {
        await copyValue(`link-${heistId}`, data.referral_link, "Link");
      } else {
        toast.success("Affiliate link ready");
      }
    } catch (err) {
      console.error("Create affiliate link error:", err);
      toast.error(err?.response?.data?.message || "Unable to create affiliate link.");
    } finally {
      setBusyId(null);
    }
  };

  const generateAllLinks = async () => {
    const missingHeists = activeHeists.filter((heist) => !linksByHeist[heist.id]);
    if (!missingHeists.length || busyAll) {
      toast.info("All visible links are ready");
      return;
    }

    setBusyAll(true);
    try {
      const results = await Promise.all(
        missingHeists.map(async (heist) => {
          const data = await createHeistAffiliateLink(heist.id);
          return [heist.id, data];
        })
      );

      setLinksByHeist((prev) => {
        const next = { ...prev };
        results.forEach(([heistId, data]) => {
          next[heistId] = data;
        });
        return next;
      });
      toast.success("Affiliate links ready");
    } catch (err) {
      console.error("Create all affiliate links error:", err);
      toast.error(err?.response?.data?.message || "Unable to create all links.");
    } finally {
      setBusyAll(false);
    }
  };

  return (
    <div className={styles.page}>
      <Header />

      <main className={styles.main}>
        <div className={styles.topBar}>
          <button type="button" className={styles.backBtn} onClick={() => navigate("/dashboard")}>
            <FiArrowLeft />
            <span>Dashboard</span>
          </button>

          <button
            type="button"
            className={styles.refreshBtn}
            onClick={loadAffiliate}
            disabled={loading}
            aria-label="Refresh affiliate page"
          >
            <FiRefreshCw />
          </button>
        </div>

        <section className={styles.hero}>
          <div>
            <p className={styles.kicker}>Affiliate Heists</p>
            <h1>Share heists. Earn CopUpCoin.</h1>
            <p>
              Generate a heist affiliate link, share it, and earn task rewards when users join
              before that heist is completed.
            </p>
          </div>

          <div className={styles.heroBadge}>
            <FiLink />
            <span>{formatNum(activeHeists.length)} shareable heists</span>
          </div>
        </section>

        {error ? (
          <div className={styles.errorBox}>
            <span>{error}</span>
            <button type="button" onClick={loadAffiliate}>
              Retry
            </button>
          </div>
        ) : null}

        <section className={styles.statsGrid}>
          <div>
            <FiLink />
            <span>Total links</span>
            <strong>{loading ? "..." : formatNum(affiliateStats.total_links)}</strong>
          </div>
          <div>
            <FiTrendingUp />
            <span>Total clicks</span>
            <strong>{loading ? "..." : formatNum(affiliateStats.total_clicks)}</strong>
          </div>
          <div>
            <FiUsers />
            <span>Referred joins</span>
            <strong>{loading ? "..." : formatNum(affiliateStats.referred_joins)}</strong>
          </div>
          <div>
            <FiCheckCircle />
            <span>Rewards earned</span>
            <strong>{loading ? "..." : `${formatNum(taskStats.affiliate_rewards_earned)} CP`}</strong>
          </div>
        </section>

        <section className={styles.sectionHead}>
          <div>
            <p className={styles.kicker}>Links</p>
            <h2>Get heist affiliate links</h2>
          </div>
          <button
            type="button"
            className={styles.primaryBtn}
            onClick={generateAllLinks}
            disabled={loading || busyAll || !activeHeists.length}
          >
            <FiLink />
            <span>{busyAll ? "Getting links..." : "Get all links"}</span>
          </button>
        </section>

        <section className={styles.heistGrid}>
          {loading ? (
            <div className={styles.emptyState}>Loading heists...</div>
          ) : activeHeists.length ? (
            activeHeists.map((heist) => {
              const link = linksByHeist[heist.id];
              const linkKey = `link-${heist.id}`;
              const codeKey = `code-${heist.id}`;

              return (
                <article className={styles.heistCard} key={heist.id}>
                  <div className={styles.cardTop}>
                    <span className={styles.status}>{heist.status}</span>
                    <strong>{formatNum(heist.prize_cop_points)} CP</strong>
                  </div>

                  <div>
                    <h3>{heist.name}</h3>
                    <p>{heist.description || "Share this heist and earn when referred users join."}</p>
                  </div>

                  <div className={styles.metaLine}>
                    <span>{formatNum(heist.ticket_price)} CP ticket</span>
                    <span>Ends {formatDate(heist.countdown_ends_at || heist.ends_at)}</span>
                  </div>

                  {link ? (
                    <div className={styles.shareStack}>
                      <div className={styles.linkBox}>
                        <div>
                          <span>Referral link</span>
                          <strong>{link.referral_link}</strong>
                        </div>
                        <button
                          type="button"
                          onClick={() => copyValue(linkKey, link.referral_link, "Link")}
                          aria-label="Copy referral link"
                        >
                          {copiedKey === linkKey ? <FiCheckCircle /> : <FiCopy />}
                        </button>
                      </div>

                      <div className={styles.linkBox}>
                        <div>
                          <span>Referral code</span>
                          <strong>{link.referral_code}</strong>
                        </div>
                        <button
                          type="button"
                          onClick={() => copyValue(codeKey, link.referral_code, "Code")}
                          aria-label="Copy referral code"
                        >
                          {copiedKey === codeKey ? <FiCheckCircle /> : <FiCopy />}
                        </button>
                      </div>

                      <div className={styles.linkActions}>
                        <button
                          type="button"
                          className={styles.primaryBtn}
                          onClick={() => copyValue(linkKey, link.referral_link, "Link")}
                        >
                          {copiedKey === linkKey ? <FiCheckCircle /> : <FiCopy />}
                          <span>{copiedKey === linkKey ? "Copied" : "Copy link"}</span>
                        </button>
                        <button
                          type="button"
                          className={styles.softBtn}
                          onClick={() => window.open(link.referral_link, "_blank", "noopener,noreferrer")}
                        >
                          <FiExternalLink />
                          <span>Open</span>
                        </button>
                      </div>
                    </div>
                  ) : (
                    <button
                      type="button"
                      className={styles.primaryBtn}
                      onClick={() => generateLink(heist.id, { copy: true })}
                      disabled={busyId === heist.id || busyAll}
                    >
                      <FiCopy />
                      <span>{busyId === heist.id ? "Getting link..." : "Get link"}</span>
                    </button>
                  )}
                </article>
              );
            })
          ) : (
            <div className={styles.emptyState}>No shareable heists right now.</div>
          )}
        </section>

        <section className={styles.sectionHead}>
          <div>
            <p className={styles.kicker}>Progress</p>
            <h2>Affiliate task rewards</h2>
          </div>
        </section>

        <section className={styles.progressPanel}>
          {loading ? (
            <div className={styles.emptyState}>Loading task progress...</div>
          ) : taskProgress.length ? (
            taskProgress.map((task) => {
              const pct = progressPercent(task.current_joins, task.required_joins);
              return (
                <article className={styles.taskCard} key={task.task_id}>
                  <div className={styles.taskTop}>
                    <div>
                      <h3>{task.heist_name}</h3>
                      <p>{formatNum(task.reward_cop_points)} CP reward</p>
                    </div>
                    <span className={task.is_completed ? styles.donePill : styles.openPill}>
                      {task.is_completed ? "Completed" : "In progress"}
                    </span>
                  </div>

                  <div className={styles.progressText}>
                    <span>
                      {formatNum(task.current_joins)} / {formatNum(task.required_joins)} joins
                    </span>
                    <strong>{pct}%</strong>
                  </div>

                  <div className={styles.progressTrack}>
                    <span style={{ width: `${pct}%` }} />
                  </div>

                  {task.rewarded_at ? (
                    <small>Rewarded {formatDate(task.rewarded_at)}</small>
                  ) : null}
                </article>
              );
            })
          ) : (
            <div className={styles.emptyState}>
              No affiliate task progress yet. Generate a link and bring users into a heist.
            </div>
          )}
        </section>
      </main>

      <Footer />
    </div>
  );
}
