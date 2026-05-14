import React, { useCallback, useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  FiArrowLeft,
  FiCheckCircle,
  FiRefreshCw,
  FiTarget,
  FiTrendingUp,
  FiUsers,
} from "react-icons/fi";
import Header from "../../components/Header/Header";
import Footer from "../../components/Footer/Footer";
import { useToast } from "../../components/Toast/ToastContext";
import { COPUP_EVENTS } from "../../lib/copupEvents";
import { getPaymentInfo } from "../../lib/transactions";
import { getAffiliateTileDashboard, joinAffiliateTile } from "../../lib/users";
import styles from "./Affiliate.module.css";

function formatNum(value) {
  const n = Number(value);
  return Number.isFinite(n) ? n.toLocaleString() : "0";
}

function formatMoney(value, currency = "NGN") {
  const n = Number(value);
  return `${currency} ${Number.isFinite(n) ? n.toLocaleString(undefined, { maximumFractionDigits: 2 }) : "0"}`;
}

function coinValue(copPoints, rate) {
  const points = Number(copPoints || 0);
  const unit = Number(rate?.unit || 0);
  const price = Number(rate?.price || 0);
  if (!Number.isFinite(points) || !Number.isFinite(unit) || !Number.isFinite(price) || unit <= 0) {
    return null;
  }
  return Number(((points / unit) * price).toFixed(2));
}

export default function Affiliate() {
  const navigate = useNavigate();
  const toast = useToast();
  const [dashboard, setDashboard] = useState(null);
  const [paymentInfo, setPaymentInfo] = useState(null);
  const [loading, setLoading] = useState(true);
  const [joiningId, setJoiningId] = useState(null);
  const [error, setError] = useState("");

  const tiles = Array.isArray(dashboard?.tiles) ? dashboard.tiles : [];
  const stats = dashboard?.stats || {};
  const assignedTile = dashboard?.assigned_tile || null;
  const estimatedEarning = Number(dashboard?.estimated_earning_cop_points || 0);
  const coinRate = paymentInfo?.coin_rate || null;
  const rateCurrency = coinRate?.currency || "NGN";
  const estimatedEarningValue = coinValue(estimatedEarning, coinRate);

  const loadAffiliate = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      const [data, info] = await Promise.all([
        getAffiliateTileDashboard(),
        getPaymentInfo(),
      ]);
      setDashboard(data);
      setPaymentInfo(info);
    } catch (err) {
      console.error("Affiliate tile load error:", err);
      setError(err?.response?.data?.message || "Unable to load affiliate earnings.");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadAffiliate();
  }, [loadAffiliate]);

  const handleJoinTile = async (tile) => {
    if (!tile?.id || joiningId) return;

    setJoiningId(tile.id);
    try {
      const result = await joinAffiliateTile(tile.id);
      if (result?.dashboard) setDashboard(result.dashboard);
      if (result?.user?.cop_point !== undefined) {
        localStorage.setItem("copup_cop_point", String(result.user.cop_point || 0));
        window.dispatchEvent(new Event(COPUP_EVENTS.BALANCE_UPDATED));
      }
      toast.success(result?.membership?.action === "switched" ? `Switched to ${tile.name}` : `Joined ${tile.name}`);
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to join Tile.");
    } finally {
      setJoiningId(null);
    }
  };

  return (
    <div className={styles.page}>
      <Header />

      <main className={styles.main}>
        <div className={styles.topBar}>
          <button type="button" className={styles.backBtn} onClick={() => navigate("/affiliate-dashboard")}>
            <FiArrowLeft />
            <span>Affiliate Dashboard</span>
          </button>

          <button
            type="button"
            className={styles.refreshBtn}
            onClick={loadAffiliate}
            disabled={loading}
            aria-label="Refresh affiliate earnings"
          >
            <FiRefreshCw />
          </button>
        </div>

        <section className={styles.hero}>
          <div>
            <p className={styles.kicker}>Affiliate Earnings</p>
            <h1>Choose your Tile plan.</h1>
            <p>
              You can qualify by referred affiliates or join a Tile plan with CopUpCoin. Tickets
              bought by users in your referral network count toward your monthly target.
            </p>
          </div>

          <div className={styles.heroBadge}>
            <FiTarget />
            <span>{assignedTile ? `Level ${formatNum(assignedTile.tile_level)}` : "No Tile yet"}</span>
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

        <section className={`${styles.statsGrid} ${styles.statsList}`}>
          <div>
            <FiUsers />
            <span>Direct affiliates</span>
            <strong>{loading ? "..." : formatNum(stats.direct_affiliates)}</strong>
          </div>
          <div>
            <FiTarget />
            <span>Network tickets</span>
            <strong>{loading ? "..." : formatNum(stats.network_tickets)}</strong>
          </div>
          <div>
            <FiTrendingUp />
            <span>Ticket value</span>
            <strong>{loading ? "..." : `${formatNum(stats.network_ticket_value)} CP`}</strong>
          </div>
          <div>
            <FiCheckCircle />
            <span>Estimated earning</span>
            <strong>{loading ? "..." : `${formatNum(estimatedEarning)} CP`}</strong>
            <small>
              {loading
                ? "..."
                : estimatedEarningValue !== null
                  ? formatMoney(estimatedEarningValue, rateCurrency)
                  : "Rate not set"}
            </small>
          </div>
        </section>

        <section className={styles.sectionHead}>
          <div>
            <p className={styles.kicker}>{dashboard?.period?.label || "This month"}</p>
            <h2>Tile plans</h2>
          </div>
          <button type="button" className={styles.primaryBtn} onClick={() => navigate("/affiliate/referral")}>
            <FiUsers />
            <span>Referral tools</span>
          </button>
        </section>

        <section className={styles.progressPanel}>
          {loading ? (
            <div className={styles.emptyState}>Loading Tile performance...</div>
          ) : tiles.length ? (
            <React.Fragment>
              {assignedTile ? (
                <article className={`${styles.taskCard} ${styles.activePlanCard}`}>
                  <div className={styles.taskTop}>
                    <div>
                      <h3>
                        Level {formatNum(assignedTile.tile_level)} · {assignedTile.name}
                      </h3>
                      <p>
                        Current estimated earning: {formatNum(estimatedEarning)} /{" "}
                        {formatNum(assignedTile.reward_cop_points)} CP
                      </p>
                      <small className={styles.moneyNote}>
                        {estimatedEarningValue !== null
                          ? `Current value: ${formatMoney(estimatedEarningValue, rateCurrency)}`
                          : "Naira value unavailable until the coin rate is set."}
                      </small>
                    </div>
                    <span className={styles.donePill}>Assigned</span>
                  </div>
                  <div className={styles.progressText}>
                    <span>
                      {formatNum(stats.network_tickets)} / {formatNum(assignedTile.target_tickets)} tickets
                    </span>
                    <strong>{formatNum(assignedTile.ticket_percent)}%</strong>
                  </div>
                  <div className={styles.progressTrack}>
                    <span style={{ width: `${Math.min(Number(assignedTile.ticket_percent || 0), 100)}%` }} />
                  </div>
                  <small>
                    {assignedTile.remaining_tickets
                      ? `${formatNum(assignedTile.remaining_tickets)} more ticket(s) to hit the full reward.`
                      : "Full ticket target reached for this Tile."}
                  </small>
                </article>
              ) : (
                <div className={`${styles.emptyState} ${styles.planIntro}`}>
                  You are not in a Tile yet. Build the required direct affiliates or join a Tile plan
                  with CopUpCoin.
                </div>
              )}

              {tiles.map((tile) => {
                const isActivePlan = Boolean(tile.is_eligible);
                const isLockedByJoinedPlan = Boolean(tile.earning_locked_by_joined_plan);
                const canSwitchPlan = Boolean(assignedTile?.is_joined && !tile.is_assigned_tile);
                const switchCost = Math.max(
                  Number(tile.plan_price_cop_points || 0) - Number(assignedTile?.paid_cop_points || 0),
                  0
                );
                const switchLabel =
                  Number(tile.tile_level || 0) > Number(assignedTile?.tile_level || 0)
                    ? "Upgrade"
                    : Number(tile.tile_level || 0) < Number(assignedTile?.tile_level || 0)
                      ? "Downgrade"
                      : "Switch";
                return (
                  <article
                    className={`${styles.taskCard} ${styles.planCard} ${
                      isActivePlan ? styles.planCardActive : ""
                    }`}
                    key={tile.id}
                  >
                    <div className={styles.planHeader}>
                      <span className={styles.planLevel}>Level {formatNum(tile.tile_level)}</span>
                      <h3>{tile.name}</h3>
                      <span
                        className={
                          isActivePlan
                            ? styles.donePill
                            : styles.openPill
                        }
                      >
                        {tile.is_assigned_tile
                          ? "Your Tile"
                          : tile.is_joined
                            ? "Joined"
                          : isLockedByJoinedPlan
                            ? "Plan locked"
                          : tile.is_eligible
                            ? "Qualified"
                            : "Locked"}
                      </span>
                    </div>

                    <div className={styles.planPrice}>
                      <strong>
                        {tile.plan_price_cop_points
                          ? `${formatNum(tile.plan_price_cop_points)} CP`
                          : "Free"}
                      </strong>
                      <span>Plan price</span>
                      {tile.plan_price_cop_points ? (
                        <small>
                          {coinValue(tile.plan_price_cop_points, coinRate) !== null
                            ? formatMoney(coinValue(tile.plan_price_cop_points, coinRate), rateCurrency)
                            : "Rate not set"}
                        </small>
                      ) : null}
                    </div>

                    <hr className={styles.planRule} />

                    <ul className={styles.planFeatures}>
                      <li>
                        <strong>{formatNum(tile.required_affiliates)}</strong>
                        <span>direct affiliates required</span>
                      </li>
                      <li>
                        <strong>{formatNum(tile.target_tickets)}</strong>
                        <span>network tickets per month</span>
                      </li>
                      <li>
                        <strong>{formatNum(tile.reward_cop_points)} CP</strong>
                        <span>maximum monthly reward</span>
                        <small>
                          {coinValue(tile.reward_cop_points, coinRate) !== null
                            ? formatMoney(coinValue(tile.reward_cop_points, coinRate), rateCurrency)
                            : "Rate not set"}
                        </small>
                      </li>
                    </ul>

                    {isActivePlan ? (
                      <div className={styles.planDetails}>
                        <div className={styles.progressText}>
                          <span>
                            {formatNum(stats.network_tickets)} / {formatNum(tile.target_tickets)} tickets
                          </span>
                          <strong>{formatNum(tile.ticket_percent)}%</strong>
                        </div>
                        <div className={styles.progressTrack}>
                          <span style={{ width: `${Math.min(Number(tile.ticket_percent || 0), 100)}%` }} />
                        </div>
                        <small>
                          {tile.is_joined
                            ? `Joined plan. ${formatNum(tile.earning_cop_points)} CP estimated (${coinValue(tile.earning_cop_points, coinRate) !== null ? formatMoney(coinValue(tile.earning_cop_points, coinRate), rateCurrency) : "rate not set"}) from current ticket activity.`
                            : `${formatNum(tile.earning_cop_points)} CP estimated (${coinValue(tile.earning_cop_points, coinRate) !== null ? formatMoney(coinValue(tile.earning_cop_points, coinRate), rateCurrency) : "rate not set"}) from current performance.`}
                        </small>
                      </div>
                    ) : (
                      <small>
                        {isLockedByJoinedPlan
                          ? "You are already in another Tile plan. Switch plans if you want this one to earn."
                          : `Needs ${formatNum(tile.remaining_affiliates)} more direct affiliate(s), or join this plan with ${formatNum(tile.plan_price_cop_points)} CP.`}
                      </small>
                    )}

                    {canSwitchPlan ? (
                      <button
                        type="button"
                        className={styles.primaryBtn}
                        onClick={() => handleJoinTile(tile)}
                        disabled={joiningId === tile.id}
                      >
                        <FiCheckCircle />
                        <span>
                          {joiningId === tile.id
                            ? "Switching..."
                            : switchCost
                              ? `${switchLabel} for ${formatNum(switchCost)} CP`
                              : `${switchLabel} free`}
                        </span>
                      </button>
                    ) : !isActivePlan && !isLockedByJoinedPlan ? (
                      <button
                        type="button"
                        className={styles.primaryBtn}
                        onClick={() => handleJoinTile(tile)}
                        disabled={joiningId === tile.id}
                      >
                        <FiCheckCircle />
                        <span>
                          {joiningId === tile.id
                            ? "Joining..."
                            : tile.plan_price_cop_points
                              ? `Join for ${formatNum(tile.plan_price_cop_points)} CP`
                              : "Join free"}
                        </span>
                      </button>
                    ) : null}
                  </article>
                );
              })}
            </React.Fragment>
          ) : (
            <div className={styles.emptyState}>No active Tile levels are available yet.</div>
          )}
        </section>
      </main>

      <Footer />
    </div>
  );
}
