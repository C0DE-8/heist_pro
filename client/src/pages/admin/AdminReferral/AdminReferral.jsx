import React, { useCallback, useEffect, useMemo, useState } from "react";
import { FaCheckCircle, FaExclamationTriangle, FaGift, FaPowerOff, FaRedoAlt, FaSave, FaUsers } from "react-icons/fa";
import AdminNavbar from "../../../components/admin/Navbar";
import AdminPageHeader from "../../../components/admin/AdminPageHeader";
import { useToast } from "../../../components/Toast/ToastContext";
import {
  createAffiliateTile,
  deleteAffiliateTile,
  getAdminReferralSettings,
  resetAdminReferralSettings,
  updateAffiliateTile,
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

function buildTileForm(tile) {
  return {
    id: tile?.id || null,
    tile_level: Number(tile?.tile_level || 1),
    name: tile?.name || "",
    target_tickets: Number(tile?.target_tickets || 150),
    reward_cop_points: Number(tile?.reward_cop_points || 65),
    required_affiliates: Number(tile?.required_affiliates || 10),
    plan_price_cop_points: Number(tile?.plan_price_cop_points || 0),
    is_active: tile?.is_active === undefined ? true : Boolean(tile.is_active),
  };
}

export default function AdminReferral() {
  const toast = useToast();
  const [data, setData] = useState(null);
  const [form, setForm] = useState(buildForm(null));
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [resetting, setResetting] = useState(false);
  const [savingTile, setSavingTile] = useState(false);
  const [tileForm, setTileForm] = useState(buildTileForm(null));
  const [error, setError] = useState("");
  const [resetAlertOpen, setResetAlertOpen] = useState(false);

  const settings = data?.settings || null;
  const summary = useMemo(() => data?.summary || {}, [data?.summary]);
  const progress = Array.isArray(data?.progress) ? data.progress : [];
  const tileDashboard = data?.tile_dashboard || {};
  const tiles = Array.isArray(tileDashboard?.tiles) ? tileDashboard.tiles : [];
  const tilePerformance = Array.isArray(tileDashboard?.affiliate_performance)
    ? tileDashboard.affiliate_performance
    : [];
  const activeTiles = tiles.filter((tile) => tile.is_active);
  const assignedAffiliates = tilePerformance.filter((item) => item.assigned_tile).length;
  const estimatedTileRewards = tilePerformance.reduce(
    (sum, item) => sum + Number(item.estimated_earning_cop_points || 0),
    0
  );

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

  const updateTileField = (field) => (event) => {
    const value = event.target.type === "checkbox" ? event.target.checked : event.target.value;
    setTileForm((prev) => ({ ...prev, [field]: value }));
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

  const saveTile = async (event) => {
    event.preventDefault();
    setSavingTile(true);
    try {
      const payload = {
        name: tileForm.name,
        tile_level: Number(tileForm.tile_level || 1),
        target_tickets: Number(tileForm.target_tickets || 0),
        reward_cop_points: Number(tileForm.reward_cop_points || 0),
        required_affiliates: Number(tileForm.required_affiliates || 0),
        plan_price_cop_points: Number(tileForm.plan_price_cop_points || 0),
        is_active: Boolean(tileForm.is_active),
      };
      const result = tileForm.id
        ? await updateAffiliateTile(tileForm.id, payload)
        : await createAffiliateTile(payload);

      setData((prev) => ({ ...(prev || {}), tile_dashboard: result.tile_dashboard }));
      setTileForm(buildTileForm(null));
      toast.success(tileForm.id ? "Tile updated." : "Tile created.");
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to save affiliate tile.");
    } finally {
      setSavingTile(false);
    }
  };

  const editTile = (tile) => {
    setTileForm(buildTileForm(tile));
    toast.info("Tile loaded for editing.");
  };

  const removeTile = async (tileId) => {
    if (!tileId || savingTile) return;
    setSavingTile(true);
    try {
      const result = await deleteAffiliateTile(tileId);
      setData((prev) => ({ ...(prev || {}), tile_dashboard: result.tile_dashboard }));
      if (Number(tileForm.id) === Number(tileId)) setTileForm(buildTileForm(null));
      toast.success("Tile deleted.");
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to delete affiliate tile.");
    } finally {
      setSavingTile(false);
    }
  };

  return (
    <div className={styles.page}>
      <AdminNavbar />

      <main className={styles.main}>
        <AdminPageHeader
          kicker="Admin Referral"
          title="Referral Rewards"
          description="Control how many heists a referred user must join, how many coins the referrer earns, and when the reward cycle resets."
          onRefresh={loadPage}
          refreshing={loading}
          error={error}
          onRetry={loadPage}
        />

        <section className={styles.statsGrid}>
          {stats.map((stat) => (
            <div className={styles.statCard} key={stat.label}>
              {stat.icon}
              <span>{stat.label}</span>
              <strong>{loading ? "..." : stat.value}</strong>
            </div>
          ))}
        </section>

        <section className={styles.tileOverview}>
          <div>
            <span>Active Tile plans</span>
            <strong>{loading ? "..." : formatNum(activeTiles.length)}</strong>
          </div>
          <div>
            <span>Assigned affiliates</span>
            <strong>{loading ? "..." : formatNum(assignedAffiliates)}</strong>
          </div>
          <div>
            <span>Estimated Tile rewards</span>
            <strong>{loading ? "..." : `${formatNum(estimatedTileRewards)} CP`}</strong>
          </div>
          <div>
            <span>Period</span>
            <strong>{tileDashboard?.period?.label || "This month"}</strong>
          </div>
        </section>

        <section className={styles.contentGrid}>
          <article className={styles.panel}>
            <div className={styles.panelHead}>
              <div>
                <p className={styles.kicker}>Affiliate Tiles</p>
                <h2>{tileForm.id ? "Edit tile" : "Create tile"}</h2>
              </div>
              <span className={tileForm.is_active ? styles.liveBadge : styles.offBadge}>
                <FaPowerOff />
                {tileForm.is_active ? "Active" : "Off"}
              </span>
            </div>

            <form className={styles.form} onSubmit={saveTile}>
              <label>
                <span>Tile level</span>
                <input
                  type="number"
                  min="1"
                  value={tileForm.tile_level}
                  onChange={updateTileField("tile_level")}
                />
              </label>

              <label>
                <span>Tile name</span>
                <input
                  type="text"
                  value={tileForm.name}
                  onChange={updateTileField("name")}
                  placeholder="Street Scout"
                  maxLength={120}
                  required
                />
              </label>

              <label>
                <span>Required referred affiliates</span>
                <input
                  type="number"
                  min="0"
                  value={tileForm.required_affiliates}
                  onChange={updateTileField("required_affiliates")}
                />
              </label>

              <label>
                <span>Target tickets per month</span>
                <input
                  type="number"
                  min="1"
                  value={tileForm.target_tickets}
                  onChange={updateTileField("target_tickets")}
                />
              </label>

              <label>
                <span>Reward value (CP)</span>
                <input
                  type="number"
                  min="1"
                  value={tileForm.reward_cop_points}
                  onChange={updateTileField("reward_cop_points")}
                />
              </label>

              <label>
                <span>Plan price to join (CP)</span>
                <input
                  type="number"
                  min="0"
                  value={tileForm.plan_price_cop_points}
                  onChange={updateTileField("plan_price_cop_points")}
                />
              </label>

              <div className={styles.switchRow}>
                <span>
                  <strong>Tile status</strong>
                  <small>Inactive tiles stay saved but are not used for monthly earning estimates.</small>
                </span>
                <button
                  type="button"
                  className={tileForm.is_active ? styles.toggleOn : styles.toggleOff}
                  onClick={() => setTileForm((prev) => ({ ...prev, is_active: !prev.is_active }))}
                  aria-pressed={Boolean(tileForm.is_active)}
                >
                  <span className={styles.toggleThumb} />
                  <span>{tileForm.is_active ? "On" : "Off"}</span>
                </button>
              </div>

              <div className={styles.actions}>
                <button type="submit" className={styles.primaryBtn} disabled={savingTile}>
                  <FaSave />
                  <span>{savingTile ? "Saving..." : tileForm.id ? "Update tile" : "Create tile"}</span>
                </button>
                {tileForm.id ? (
                  <button
                    type="button"
                    className={styles.softBtn}
                    onClick={() => setTileForm(buildTileForm(null))}
                    disabled={savingTile}
                  >
                    Cancel edit
                  </button>
                ) : null}
              </div>
            </form>
          </article>

          <article className={styles.panel}>
            <div className={styles.panelHead}>
              <div>
                <p className={styles.kicker}>Live Performance</p>
                <h2>Tiles and earnings</h2>
              </div>
              <span className={styles.badge}>{tileDashboard?.period?.label || "This month"}</span>
            </div>

            <div className={styles.tileGrid}>
              {loading ? (
                <div className={styles.emptyState}>Loading tiles...</div>
              ) : tiles.length ? (
                <React.Fragment>
                  {tiles.map((tile) => (
                    <article
                      className={`${styles.tileCard} ${tile.is_active ? styles.tileCardActive : ""}`}
                      key={tile.id}
                    >
                      <div className={styles.tileCardHead}>
                        <span>Level {formatNum(tile.tile_level)}</span>
                        <h3>{tile.name}</h3>
                        <em className={tile.is_active ? styles.donePill : styles.pendingPill}>
                          {tile.is_active ? "Active" : "Inactive"}
                        </em>
                      </div>

                      <div className={styles.tilePrice}>
                        <strong>{formatNum(tile.plan_price_cop_points)} CP</strong>
                        <span>Plan price</span>
                      </div>

                      <div className={styles.tileFacts}>
                        <div>
                          <span>Required affiliates</span>
                          <strong>{formatNum(tile.required_affiliates)}</strong>
                        </div>
                        <div>
                          <span>Ticket target</span>
                          <strong>{formatNum(tile.target_tickets)}</strong>
                        </div>
                        <div>
                          <span>Reward</span>
                          <strong>{formatNum(tile.reward_cop_points)} CP</strong>
                        </div>
                        <div>
                          <span>Assigned</span>
                          <strong>
                            {
                              tilePerformance.filter(
                                (item) => Number(item.assigned_tile?.id) === Number(tile.id)
                              ).length
                            }
                          </strong>
                        </div>
                      </div>

                      <div className={styles.actions}>
                        <button type="button" className={styles.softBtn} onClick={() => editTile(tile)}>
                          Edit
                        </button>
                        <button
                          type="button"
                          className={styles.dangerBtn}
                          onClick={() => removeTile(tile.id)}
                          disabled={savingTile}
                        >
                          Delete
                        </button>
                      </div>
                    </article>
                  ))}
                </React.Fragment>
              ) : (
                <div className={styles.emptyState}>No affiliate tiles have been created yet.</div>
              )}
            </div>
          </article>
        </section>

        <section className={styles.panel}>
          <div className={styles.panelHead}>
            <div>
              <p className={styles.kicker}>Affiliate Performance</p>
              <h2>Current Tile assignments</h2>
            </div>
            <span className={styles.badge}>{formatNum(tilePerformance.length)} affiliates</span>
          </div>

          <div className={styles.performanceGrid}>
            {loading ? (
              <div className={styles.emptyState}>Loading affiliate performance...</div>
            ) : tilePerformance.length ? (
              tilePerformance.slice(0, 12).map((item) => (
                <article className={styles.performanceCard} key={`affiliate-${item.user_id}`}>
                  <div className={styles.rowTop}>
                    <div>
                      <strong>{item.full_name || item.username || `User #${item.user_id}`}</strong>
                      <small>
                        {item.assigned_tile
                          ? `Level ${formatNum(item.assigned_tile.tile_level)} · ${item.assigned_tile.name}`
                          : "No tile assigned"}
                      </small>
                    </div>
                    <em className={item.assigned_tile ? styles.donePill : styles.pendingPill}>
                      {formatNum(item.estimated_earning_cop_points)} CP
                    </em>
                  </div>
                  <div className={styles.tileFacts}>
                    <div>
                      <span>Direct affiliates</span>
                      <strong>{formatNum(item.stats?.direct_affiliates)}</strong>
                    </div>
                    <div>
                      <span>Network tickets</span>
                      <strong>{formatNum(item.stats?.network_tickets)}</strong>
                    </div>
                    <div>
                      <span>Ticket value</span>
                      <strong>{formatNum(item.stats?.network_ticket_value)} CP</strong>
                    </div>
                  </div>
                </article>
              ))
            ) : (
              <div className={styles.emptyState}>No affiliate performance yet.</div>
            )}
          </div>
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
