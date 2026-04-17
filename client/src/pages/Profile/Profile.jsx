import React, { useCallback, useEffect, useMemo, useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  FiArrowLeft,
  FiAward,
  FiCheckCircle,
  FiCopy,
  FiEdit3,
  FiRefreshCw,
  FiShield,
  FiTarget,
  FiUser,
  FiUsers,
} from "react-icons/fi";
import Header from "../../components/Header/Header";
import Footer from "../../components/Footer/Footer";
import { useToast } from "../../components/Toast/ToastContext";
import { getUserProfile, updateUserProfile } from "../../lib/users";
import styles from "./Profile.module.css";

function formatNum(value) {
  const n = Number(value);
  return Number.isFinite(n) ? n.toLocaleString() : "0";
}

function formatPercent(value) {
  const n = Number(value);
  return Number.isFinite(n) ? `${n.toFixed(1)}%` : "0.0%";
}

function formatDate(value) {
  if (!value) return "Not available";
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "Not available";
  return date.toLocaleString([], {
    month: "short",
    day: "numeric",
    year: "numeric",
    hour: "numeric",
    minute: "2-digit",
  });
}

function shortText(value, start = 10, end = 6) {
  const text = String(value || "");
  if (!text) return "Not assigned";
  if (text.length <= start + end + 3) return text;
  return `${text.slice(0, start)}...${text.slice(-end)}`;
}

function makeInitials(user) {
  const source = user?.full_name || user?.username || user?.email || "User";
  return source
    .split(/\s+/)
    .filter(Boolean)
    .slice(0, 2)
    .map((part) => part[0])
    .join("")
    .toUpperCase();
}

export default function Profile() {
  const navigate = useNavigate();
  const toast = useToast();

  const [profileData, setProfileData] = useState(null);
  const [form, setForm] = useState({ username: "", full_name: "", email: "" });
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");
  const [copied, setCopied] = useState("");

  const user = profileData?.user || null;
  const stats = profileData?.stats || {};
  const heistStats = stats.heists || {};
  const submissionStats = stats.submissions || {};
  const affiliateStats = stats.affiliate || {};
  const taskStats = stats.affiliate_tasks || {};
  const recentHeists = Array.isArray(profileData?.recent_heists)
    ? profileData.recent_heists
    : [];
  const affiliateProgress = Array.isArray(profileData?.affiliate_task_progress)
    ? profileData.affiliate_task_progress
    : [];

  const initials = useMemo(() => makeInitials(user), [user]);
  const isDirty = Boolean(
    user &&
      (form.username !== (user.username || "") ||
        form.full_name !== (user.full_name || "") ||
        form.email !== (user.email || ""))
  );

  const loadProfile = useCallback(async () => {
    setLoading(true);
    setError("");

    try {
      const data = await getUserProfile();
      setProfileData(data);
      setForm({
        username: data?.user?.username || "",
        full_name: data?.user?.full_name || "",
        email: data?.user?.email || "",
      });
    } catch (err) {
      console.error("Profile load error:", err);
      setError(err?.response?.data?.message || "Unable to load profile.");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadProfile();
  }, [loadProfile]);

  const updateField = (event) => {
    const { name, value } = event.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const copyValue = async (label, value) => {
    if (!value) return;

    try {
      await navigator.clipboard.writeText(String(value));
      setCopied(label);
      toast.success(`${label} copied`);
      window.setTimeout(() => setCopied(""), 1400);
    } catch (err) {
      toast.error("Unable to copy");
    }
  };

  const handleSubmit = async (event) => {
    event.preventDefault();
    if (!isDirty || saving) return;

    setSaving(true);
    try {
      const data = await updateUserProfile(form);
      setProfileData((prev) => ({ ...(prev || {}), user: data?.user }));
      setForm({
        username: data?.user?.username || "",
        full_name: data?.user?.full_name || "",
        email: data?.user?.email || "",
      });
      toast.success("Profile updated");
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to update profile.");
    } finally {
      setSaving(false);
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
            onClick={loadProfile}
            disabled={loading || saving}
            aria-label="Refresh profile"
          >
            <FiRefreshCw />
          </button>
        </div>

        {error ? (
          <div className={styles.errorBox}>
            <span>{error}</span>
            <button type="button" onClick={loadProfile}>
              Retry
            </button>
          </div>
        ) : null}

        <section className={styles.heroGrid}>
          <article className={styles.profileCard}>
            <div className={styles.avatarWrap}>
              <div className={styles.avatar}>{loading ? "..." : initials}</div>
              <span className={user?.is_verified ? styles.verified : styles.unverified}>
                {user?.is_verified ? <FiCheckCircle /> : <FiShield />}
                {user?.is_verified ? "Verified" : "Not verified"}
              </span>
            </div>

            <div className={styles.profileMain}>
              <p className={styles.kicker}>Player Profile</p>
              <h1>{loading ? "Loading..." : user?.full_name || user?.username || "Player"}</h1>
              <p>{user?.email || "Email not available"}</p>
            </div>

            <div className={styles.balanceCard}>
              <span>CopUpCoin balance</span>
              <strong>{formatNum(user?.cop_point)} CP</strong>
            </div>
          </article>

          <form className={styles.editCard} onSubmit={handleSubmit}>
            <div className={styles.cardHead}>
              <div>
                <p className={styles.kicker}>Update Profile</p>
                <h2>Account details</h2>
              </div>
              <FiEdit3 />
            </div>

            <label className={styles.field}>
              <span>Username</span>
              <input
                name="username"
                value={form.username}
                onChange={updateField}
                placeholder="Username"
                disabled={loading || saving}
              />
            </label>

            <label className={styles.field}>
              <span>Full name</span>
              <input
                name="full_name"
                value={form.full_name}
                onChange={updateField}
                placeholder="Full name"
                disabled={loading || saving}
              />
            </label>

            <label className={styles.field}>
              <span>Email</span>
              <input
                type="email"
                name="email"
                value={form.email}
                onChange={updateField}
                placeholder="Email address"
                disabled={loading || saving}
              />
            </label>

            <button type="submit" className={styles.saveBtn} disabled={!isDirty || loading || saving}>
              {saving ? "Saving..." : "Save changes"}
            </button>
          </form>
        </section>

        <section className={styles.statsGrid}>
          <div className={styles.statCard}>
            <FiTarget />
            <span>Joined heists</span>
            <strong>{formatNum(heistStats.joined_heists)}</strong>
          </div>
          <div className={styles.statCard}>
            <FiCheckCircle />
            <span>Submitted</span>
            <strong>{formatNum(heistStats.submitted_heists)}</strong>
          </div>
          <div className={styles.statCard}>
            <FiAward />
            <span>Won heists</span>
            <strong>{formatNum(heistStats.won_heists)}</strong>
          </div>
          <div className={styles.statCard}>
            <FiUsers />
            <span>Referred joins</span>
            <strong>{formatNum(affiliateStats.referred_joins)}</strong>
          </div>
        </section>

        <section className={styles.detailGrid}>
          <article className={styles.infoPanel}>
            <div className={styles.cardHead}>
              <div>
                <p className={styles.kicker}>Account</p>
                <h2>Identity and wallet</h2>
              </div>
              <FiUser />
            </div>

            <div className={styles.infoList}>
              <div>
                <span>Role</span>
                <strong>{user?.role || "user"}</strong>
              </div>
              <div>
                <span>Game ID</span>
                <strong>{user?.game_id || "Not assigned"}</strong>
              </div>
              <div>
                <span>Referral code</span>
                <button
                  type="button"
                  onClick={() => copyValue("Referral code", user?.referral_code)}
                  disabled={!user?.referral_code}
                >
                  <strong>{user?.referral_code || "Not assigned"}</strong>
                  <FiCopy />
                </button>
              </div>
              <div>
                <span>Wallet</span>
                <button
                  type="button"
                  onClick={() => copyValue("Wallet", user?.wallet_address)}
                  disabled={!user?.wallet_address}
                >
                  <strong>{shortText(user?.wallet_address)}</strong>
                  <FiCopy />
                </button>
              </div>
              <div>
                <span>Joined</span>
                <strong>{formatDate(user?.created_at)}</strong>
              </div>
            </div>

            {copied ? <p className={styles.notice}>{copied} copied</p> : null}
          </article>

          <article className={styles.infoPanel}>
            <div className={styles.cardHead}>
              <div>
                <p className={styles.kicker}>Performance</p>
                <h2>Heist record</h2>
              </div>
              <FiAward />
            </div>

            <div className={styles.scoreGrid}>
              <div>
                <span>Total submissions</span>
                <strong>{formatNum(submissionStats.total_submissions)}</strong>
              </div>
              <div>
                <span>Best correct</span>
                <strong>{formatNum(submissionStats.best_correct_count)}</strong>
              </div>
              <div>
                <span>Average score</span>
                <strong>{formatPercent(submissionStats.average_score_percent)}</strong>
              </div>
              <div>
                <span>Affiliate rewards</span>
                <strong>{formatNum(taskStats.affiliate_rewards_earned)} CP</strong>
              </div>
            </div>
          </article>
        </section>

        <section className={styles.activityGrid}>
          <article className={styles.listPanel}>
            <div className={styles.cardHead}>
              <div>
                <p className={styles.kicker}>Recent</p>
                <h2>Heist activity</h2>
              </div>
            </div>

            <div className={styles.rows}>
              {loading ? (
                <div className={styles.emptyState}>Loading heists...</div>
              ) : recentHeists.length ? (
                recentHeists.map((heist) => (
                  <button
                    type="button"
                    key={`${heist.id}-${heist.joined_at}`}
                    className={styles.activityRow}
                    onClick={() => navigate(`/heist/${heist.id}`)}
                  >
                    <span>
                      <strong>{heist.name}</strong>
                      <small>{formatDate(heist.joined_at)}</small>
                    </span>
                    <em>{heist.participant_status || heist.status}</em>
                  </button>
                ))
              ) : (
                <div className={styles.emptyState}>No heist activity yet.</div>
              )}
            </div>
          </article>

          <article className={styles.listPanel}>
            <div className={styles.cardHead}>
              <div>
                <p className={styles.kicker}>Affiliate</p>
                <h2>Task progress</h2>
              </div>
            </div>

            <div className={styles.rows}>
              {loading ? (
                <div className={styles.emptyState}>Loading tasks...</div>
              ) : affiliateProgress.length ? (
                affiliateProgress.map((task) => {
                  const required = Number(task.required_joins || 0);
                  const current = Number(task.current_joins || 0);
                  const pct = required ? Math.min(100, Math.round((current / required) * 100)) : 0;

                  return (
                    <div className={styles.taskRow} key={task.task_id}>
                      <div className={styles.taskTop}>
                        <span>
                          <strong>{task.heist_name}</strong>
                          <small>{formatNum(task.reward_cop_points)} CP reward</small>
                        </span>
                        <em>{task.is_completed ? "Complete" : `${formatNum(current)} / ${formatNum(required)}`}</em>
                      </div>
                      <div className={styles.progressTrack}>
                        <span style={{ width: `${pct}%` }} />
                      </div>
                    </div>
                  );
                })
              ) : (
                <div className={styles.emptyState}>No affiliate task progress yet.</div>
              )}
            </div>
          </article>
        </section>
      </main>

      <Footer />
    </div>
  );
}
