import React, { useCallback, useEffect, useMemo, useState } from "react";
import { FaCheckCircle, FaExclamationTriangle, FaGift, FaPowerOff, FaRedoAlt, FaSave, FaUsers } from "react-icons/fa";
import AdminNavbar from "../../../components/admin/Navbar";
import { useToast } from "../../../components/Toast/ToastContext";
import {
  getAdminReferralSettings,
  resetAdminReferralSettings,
  updateAdminReferralSettings,
} from "../../../lib/adminReferral";
import styles from "./AdminReferral.module.css";

function formatNum(value) {
  const n = Number(value);
  return Number.isFinite(n) ? n.toLocaleString() : "0";
}

function formatDate(value) {
  if (!value) return "Never";
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "Never";
  return date.toLocaleString();
}

function buildForm(settings) {
  return {
    is_enabled: Boolean(settings?.is_enabled),
    required_heist_joins: Number(settings?.required_heist_joins || 3),
    reward_cop_points: Number(settings?.reward_cop_points || 1),
  };
}

export default function AdminReferral() {
  const toast = useToast();
  const [data, setData] = useState(null);
  const [form, setForm] = useState(buildForm(null));
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [resetting, setResetting] = useState(false);
  const [error, setError] = useState("");
  const [resetAlertOpen, setResetAlertOpen] = useState(false);

  const settings = data?.settings || null;
  const summary = data?.summary || {};
  const progress = Array.isArray(data?.progress) ? data.progress : [];

  const loadPage = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      const result = await getAdminReferralSettings();
      setData(result);
      setForm(buildForm(result?.settings));
    } catch (err) {
      console.error("Admin referral load error:", err);
      setError(err?.response?.data?.message || "Unable to load referral rewards.");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadPage();
  }, [loadPage]);

  const stats = useMemo(
    () => [
      { label: "Tracked users", value: formatNum(summary.tracked_users), icon: <FaUsers /> },
      { label: "Rewarded users", value: formatNum(summary.rewarded_users), icon: <FaCheckCircle /> },
      { label: "Total joins", value: formatNum(summary.total_join_count), icon: <FaGift /> },
      {
        label: "Rewards awarded",
        value: `${formatNum(summary.total_rewards_awarded)} CP`,
        icon: <FaGift />,
      },
    ],
    [summary]
  );

  const updateField = (field) => (event) => {
    const value = event.target.type === "checkbox" ? event.target.checked : event.target.value;
    setForm((prev) => ({ ...prev, [field]: value }));
  };

  const toggleEnabled = () => {
    setForm((prev) => ({ ...prev, is_enabled: !prev.is_enabled }));
    toast.info(
      !form.is_enabled
        ? "Referral rewards will be enabled after you save."
        : "Referral rewards will be disabled after you save."
    );
  };

  const saveSettings = async (event) => {
    event.preventDefault();
    setSaving(true);
    try {
      const result = await updateAdminReferralSettings({
        is_enabled: Boolean(form.is_enabled),
        required_heist_joins: Number(form.required_heist_joins || 0),
        reward_cop_points: Number(form.reward_cop_points || 0),
      });
      setData(result);
      setForm(buildForm(result?.settings));
      toast.success(
        result?.awarded_now
          ? `Settings updated. ${formatNum(result.awarded_now)} rewards awarded now.`
          : "Referral reward settings updated."
      );
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to update referral settings.");
    } finally {
      setSaving(false);
    }
  };

  const resetProgress = async () => {
    setResetting(true);
    try {
      const result = await resetAdminReferralSettings();
      setData(result);
      setForm(buildForm(result?.settings));
      setResetAlertOpen(false);
      toast.success("Referral reward progress reset.");
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to reset referral progress.");
    } finally {
      setResetting(false);
    }
  };

  return (
    <div className={styles.page}>
      <AdminNavbar />

      <main className={styles.main}>
        <section className={styles.hero}>
          <div>
            <p className={styles.kicker}>Admin Referral</p>
            <h1>Referral Rewards</h1>
            <p>
              Control how many heists a referred user must join, how many coins the referrer earns,
              and when the reward cycle resets.
            </p>
          </div>

          <button type="button" className={styles.refreshBtn} onClick={loadPage} disabled={loading}>
            <FaRedoAlt />
            <span>{loading ? "Refreshing..." : "Refresh"}</span>
          </button>
        </section>

        {error ? (
          <div className={styles.errorBox}>
            <span>{error}</span>
            <button type="button" onClick={loadPage}>
              Retry
            </button>
          </div>
        ) : null}

        <section className={styles.statsGrid}>
          {stats.map((stat) => (
            <div className={styles.statCard} key={stat.label}>
              {stat.icon}
              <span>{stat.label}</span>
              <strong>{loading ? "..." : stat.value}</strong>
            </div>
          ))}
        </section>

        <section className={styles.contentGrid}>
          <article className={styles.panel}>
            <div className={styles.panelHead}>
              <div>
                <p className={styles.kicker}>Controls</p>
                <h2>Reward settings</h2>
              </div>
              <span className={form.is_enabled ? styles.liveBadge : styles.offBadge}>
                <FaPowerOff />
                {form.is_enabled ? "Enabled" : "Disabled"}
              </span>
            </div>

            <form className={styles.form} onSubmit={saveSettings}>
              <div className={styles.switchRow}>
                <span>
                  <strong>Referral reward system</strong>
                  <small>Turn reward earning on or off without deleting current cycle data.</small>
                </span>
                <button
                  type="button"
                  className={form.is_enabled ? styles.toggleOn : styles.toggleOff}
                  onClick={toggleEnabled}
                  aria-pressed={Boolean(form.is_enabled)}
                >
                  <span className={styles.toggleThumb} />
                  <span>{form.is_enabled ? "On" : "Off"}</span>
                </button>
              </div>

              <label>
                <span>Required heists joined</span>
                <input
                  type="number"
                  min="1"
                  value={form.required_heist_joins}
                  onChange={updateField("required_heist_joins")}
                />
              </label>

              <label>
                <span>Reward per qualified user (CP)</span>
                <input
                  type="number"
                  min="1"
                  value={form.reward_cop_points}
                  onChange={updateField("reward_cop_points")}
                />
              </label>

              <div className={styles.metaGrid}>
                <div>
                  <span>Current cycle</span>
                  <strong>{loading ? "..." : formatNum(settings?.reset_version)}</strong>
                </div>
                <div>
                  <span>Last reset</span>
                  <strong>{loading ? "..." : formatDate(settings?.last_reset_at)}</strong>
                </div>
              </div>

              <div className={styles.actions}>
                <button type="submit" className={styles.primaryBtn} disabled={saving || loading}>
                  <FaSave />
                  <span>{saving ? "Saving..." : "Save settings"}</span>
                </button>
                <button
                  type="button"
                  className={styles.dangerBtn}
                  onClick={() => {
                    setResetAlertOpen(true);
                    toast.info("Review the reset warning before continuing.");
                  }}
                  disabled={resetting || loading}
                >
                  <FaRedoAlt />
                  <span>{resetting ? "Resetting..." : "Reset progress"}</span>
                </button>
              </div>
            </form>

            {resetAlertOpen ? (
              <div className={styles.alertBox} role="alert">
                <div className={styles.alertHead}>
                  <FaExclamationTriangle />
                  <strong>Reset referral progress?</strong>
                </div>
                <p>
                  All current referral join counts for this cycle will be cleared. Referred users who
                  have not reached the goal will lose that partial progress.
                </p>
                <div className={styles.alertActions}>
                  <button
                    type="button"
                    className={styles.dangerBtn}
                    onClick={resetProgress}
                    disabled={resetting}
                  >
                    <FaRedoAlt />
                    <span>{resetting ? "Resetting..." : "Confirm reset"}</span>
                  </button>
                  <button
                    type="button"
                    className={styles.softBtn}
                    onClick={() => setResetAlertOpen(false)}
                    disabled={resetting}
                  >
                    Cancel
                  </button>
                </div>
              </div>
            ) : null}
          </article>

          <article className={styles.panel}>
            <div className={styles.panelHead}>
              <div>
                <p className={styles.kicker}>Cycle Progress</p>
                <h2>Tracked referred users</h2>
              </div>
              <span className={styles.badge}>{loading ? "..." : `${progress.length} users`}</span>
            </div>

            <div className={styles.rows}>
              {loading ? (
                <div className={styles.emptyState}>Loading referral progress...</div>
              ) : progress.length ? (
                progress.map((item) => (
                  <div className={styles.rowCard} key={item.id}>
                    <div className={styles.rowTop}>
                      <div>
                        <strong>{item.referred_full_name || item.referred_username || "Unnamed user"}</strong>
                        <small>
                          Referred by {item.referrer_full_name || item.referrer_username || "Unknown"}
                        </small>
                      </div>
                      <em className={item.is_rewarded ? styles.donePill : styles.pendingPill}>
                        {item.is_rewarded ? "Rewarded" : "Pending"}
                      </em>
                    </div>

                    <div className={styles.rowMeta}>
                      <span>{item.referred_email || "No email"}</span>
                      <span>
                        {formatNum(item.joined_heists)} / {formatNum(settings?.required_heist_joins)} joins
                      </span>
                    </div>

                    <div className={styles.rowMeta}>
                      <span>Last join: {formatDate(item.last_joined_at)}</span>
                      <span>
                        Reward: {item.is_rewarded ? `${formatNum(item.awarded_cop_points)} CP` : "Not yet"}
                      </span>
                    </div>
                  </div>
                ))
              ) : (
                <div className={styles.emptyState}>No referred users are being tracked in this cycle.</div>
              )}
            </div>
          </article>
        </section>
      </main>
    </div>
  );
}
