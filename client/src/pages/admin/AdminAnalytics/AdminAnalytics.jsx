import React, { useCallback, useEffect, useMemo, useState } from "react";
import {
  FaBalanceScale,
  FaChartBar,
  FaChartLine,
  FaCoins,
  FaSearch,
  FaTrophy,
  FaUsers,
  FaWallet,
} from "react-icons/fa";
import AdminNavbar from "../../../components/admin/Navbar";
import AdminPageHeader from "../../../components/admin/AdminPageHeader";
import { useToast } from "../../../components/Toast/ToastContext";
import {
  clearAdminAnalyticsExclusions,
  getAdminAnalytics,
  updateAdminAnalyticsUserInclusion,
} from "../../../lib/adminAnalytics";
import styles from "./AdminAnalytics.module.css";

function formatCoins(value) {
  return Number(value || 0).toLocaleString();
}

function formatSignedCoins(value) {
  const amount = Number(value || 0);
  const formatted = Math.abs(amount).toLocaleString();
  if (amount > 0) return `+${formatted}`;
  if (amount < 0) return `-${formatted}`;
  return "0";
}

function formatMoney(value, currency = "NGN") {
  return new Intl.NumberFormat("en-NG", {
    style: "currency",
    currency,
    maximumFractionDigits: 2,
  }).format(Number(value || 0));
}

function formatSignedMoney(value, currency = "NGN") {
  const amount = Number(value || 0);
  const formatted = formatMoney(Math.abs(amount), currency);
  if (amount > 0) return `+${formatted}`;
  if (amount < 0) return `-${formatted}`;
  return formatMoney(0, currency);
}

function statusClassName(value) {
  if (value === "completed") return styles.statusCompleted;
  if (value === "cancelled") return styles.statusDanger;
  if (value === "started" || value === "hold") return styles.statusActive;
  return styles.statusNeutral;
}

function percentOf(value, total) {
  const current = Number(value || 0);
  const max = Number(total || 0);
  if (!max || !Number.isFinite(current) || !Number.isFinite(max)) return 0;
  return Math.min(100, Math.max(0, (current / max) * 100));
}

function maxOf(rows, key) {
  return rows.reduce((max, row) => Math.max(max, Math.abs(Number(row?.[key] || 0))), 0);
}

export default function AdminAnalytics() {
  const toast = useToast();
  const [analytics, setAnalytics] = useState(null);
  const [search, setSearch] = useState("");
  const [loading, setLoading] = useState(true);
  const [savingUserId, setSavingUserId] = useState(null);
  const [error, setError] = useState("");

  const loadAnalytics = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      const data = await getAdminAnalytics();
      setAnalytics(data);
    } catch (err) {
      setError(err?.response?.data?.message || "Unable to load analytics.");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadAnalytics();
  }, [loadAnalytics]);

  const users = useMemo(() => analytics?.coins?.users || [], [analytics]);
  const heists = useMemo(() => analytics?.heists?.heists || [], [analytics]);
  const coinSummary = analytics?.coins?.summary || {};
  const heistSummary = analytics?.heists?.summary || {};
  const platform = analytics?.platform || {};
  const coinRate = analytics?.coin_rate || {};
  const excludedUserIds = analytics?.exclusions?.user_ids || [];
  const completedPercent = percentOf(
    heistSummary.completed_heists,
    heistSummary.total_heists
  );
  const platformBalance = Number(platform.estimated_platform_coin_balance || 0);
  const systemBalance = Number(platform.overall_system_balance || 0);

  const filteredUsers = useMemo(() => {
    const needle = search.trim().toLowerCase();
    if (!needle) return users;
    return users.filter((user) => {
      return [user.username, user.email, user.full_name, user.wallet_address, user.game_id]
        .filter(Boolean)
        .some((value) => String(value).toLowerCase().includes(needle));
    });
  }, [search, users]);

  const statusBreakdown = useMemo(() => {
    const counts = heists.reduce((acc, heist) => {
      const status = heist.status || "pending";
      acc[status] = (acc[status] || 0) + 1;
      return acc;
    }, {});

    return ["completed", "started", "pending", "hold", "cancelled"]
      .map((status) => ({
        status,
        count: counts[status] || 0,
        percent: percentOf(counts[status] || 0, heists.length),
      }))
      .filter((item) => item.count || heists.length === 0);
  }, [heists]);

  const topRevenueHeists = useMemo(
    () =>
      [...heists]
        .sort((a, b) => Number(b.ticket_revenue || 0) - Number(a.ticket_revenue || 0))
        .slice(0, 6),
    [heists]
  );

  const topParticipantHeists = useMemo(
    () =>
      [...heists]
        .sort((a, b) => Number(b.participant_count || 0) - Number(a.participant_count || 0))
        .slice(0, 5),
    [heists]
  );

  const maxRevenue = useMemo(() => maxOf(topRevenueHeists, "ticket_revenue"), [topRevenueHeists]);
  const maxParticipants = useMemo(
    () => maxOf(topParticipantHeists, "participant_count"),
    [topParticipantHeists]
  );
  const maxProfitLoss = useMemo(() => maxOf(topRevenueHeists, "profit_loss"), [topRevenueHeists]);

  const toggleUser = async (userId) => {
    const currentlyIncluded = !excludedUserIds.includes(userId);
    setSavingUserId(userId);
    try {
      const data = await updateAdminAnalyticsUserInclusion(userId, !currentlyIncluded);
      setAnalytics(data?.analytics || null);
      toast.success(!currentlyIncluded ? "User included in analytics" : "User excluded from analytics");
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to update analytics inclusion.");
    } finally {
      setSavingUserId(null);
    }
  };

  const includeAll = async () => {
    if (!excludedUserIds.length) return;
    setSavingUserId("all");
    try {
      const data = await clearAdminAnalyticsExclusions();
      setAnalytics(data?.analytics || null);
      toast.info("All users included in coin calculation");
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to include all users.");
    } finally {
      setSavingUserId(null);
    }
  };

  return (
    <div className={styles.page}>
      <AdminNavbar />

      <main className={styles.main}>
        <AdminPageHeader
          kicker="Admin Analytics"
          title="System Analysis"
          description="Track coin balances, heist revenue, prize payouts, and platform reconciliation."
          onRefresh={loadAnalytics}
          refreshing={loading}
          error={error}
          onRetry={loadAnalytics}
        />

        <section className={styles.statsGrid}>
          <div className={styles.statBox}>
            <FaCoins />
            <span>Total user coins</span>
            <strong>{formatCoins(coinSummary.total_user_coin_balance)}</strong>
          </div>
          <div className={styles.statBox}>
            <FaUsers />
            <span>Filtered user coins</span>
            <strong>{formatCoins(coinSummary.filtered_user_coin_balance)}</strong>
          </div>
          <div className={styles.statBox}>
            <FaWallet />
            <span>Platform heist balance</span>
            <strong>{formatSignedCoins(platform.estimated_platform_coin_balance)}</strong>
          </div>
          <div className={styles.statBox}>
            <FaBalanceScale />
            <span>Overall balance</span>
            <strong>{formatSignedCoins(platform.overall_system_balance)}</strong>
          </div>
        </section>

        <section className={styles.contentGrid}>
          <div className={styles.panel}>
            <div className={styles.panelHead}>
              <div>
                <p className={styles.kicker}>System Coins</p>
                <h2>User Balances</h2>
              </div>
              <button
                type="button"
                className={styles.smallBtn}
                onClick={includeAll}
                disabled={!excludedUserIds.length || savingUserId === "all"}
              >
                Include All
              </button>
            </div>

            <div className={styles.summaryGrid}>
              <span>Users holding coins: {formatCoins(coinSummary.users_holding_coins)}</span>
              <span>Included users: {formatCoins(coinSummary.included_users)}</span>
              <span>Excluded users: {formatCoins(coinSummary.excluded_users)}</span>
              <span>Excluded coins: {formatCoins(coinSummary.excluded_user_coin_balance)}</span>
            </div>

            <label className={styles.searchBox}>
              <FaSearch />
              <input
                value={search}
                onChange={(event) => setSearch(event.target.value)}
                placeholder="Search users, wallet, or game ID"
              />
            </label>

            <div className={`${styles.tableWrap} ${styles.userTableWrap}`}>
              <table className={styles.table}>
                <thead>
                  <tr>
                    <th>Count</th>
                    <th>User</th>
                    <th>Role</th>
                    <th>Coins</th>
                  </tr>
                </thead>
                <tbody>
                  {loading ? (
                    <tr>
                      <td colSpan="4">Loading users...</td>
                    </tr>
                  ) : filteredUsers.length ? (
                    filteredUsers.map((user) => {
                      const included = !excludedUserIds.includes(Number(user.id));
                      return (
                        <tr key={user.id} className={!included ? styles.excludedRow : ""}>
                          <td>
                            <label className={styles.switch}>
                              <input
                                type="checkbox"
                                checked={included}
                                disabled={savingUserId === Number(user.id)}
                                onChange={() => toggleUser(Number(user.id))}
                              />
                              <span>
                                {savingUserId === Number(user.id)
                                  ? "Saving..."
                                  : included
                                    ? "Included"
                                    : "Excluded"}
                              </span>
                            </label>
                          </td>
                          <td>
                            <strong>{user.username || user.email}</strong>
                            <small>{user.email}</small>
                          </td>
                          <td>{user.role}</td>
                          <td>{formatCoins(user.cop_point)}</td>
                        </tr>
                      );
                    })
                  ) : (
                    <tr>
                      <td colSpan="4">No users found.</td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>
          </div>

          <div className={styles.panel}>
            <div className={styles.panelHead}>
              <div>
                <p className={styles.kicker}>Platform</p>
                <h2>Reconciliation</h2>
              </div>
              <FaBalanceScale />
            </div>

            <div className={styles.reconcileList}>
              {(platform.reconciliation || []).map((item) => (
                <div key={item.label} className={styles.reconcileRow}>
                  <span>{item.label}</span>
                  <strong>{formatSignedCoins(item.amount)}</strong>
                </div>
              ))}
              <div className={styles.reconcileRow}>
                <span>Approved pay-ins</span>
                <strong>{formatCoins(platform.transaction_coin_summary?.approved_payin_coins)}</strong>
              </div>
              <div className={styles.reconcileRow}>
                <span>Approved payouts</span>
                <strong>{formatCoins(platform.transaction_coin_summary?.approved_payout_coins)}</strong>
              </div>
              <div className={styles.reconcileTotal}>
                <span>Estimated platform coins</span>
                <strong>{formatSignedCoins(platform.estimated_platform_coin_balance)}</strong>
              </div>
            </div>
          </div>
        </section>

        <section className={`${styles.panel} ${styles.performancePanel}`}>
          <div className={styles.panelHead}>
            <div>
              <p className={styles.kicker}>Heists</p>
              <h2>Performance Analysis</h2>
            </div>
            <FaChartLine />
          </div>

          <div className={styles.performanceBody}>
            <div className={styles.analyticsStrip}>
              <div className={styles.analyticsCard}>
                <span>Total heists</span>
                <strong>{formatCoins(heistSummary.total_heists)}</strong>
                <div className={styles.miniMeter}>
                  <i style={{ "--value": "100%" }} />
                </div>
              </div>
              <div className={styles.analyticsCard}>
                <span>Completed</span>
                <strong>{formatCoins(heistSummary.completed_heists)}</strong>
                <div className={styles.miniMeter}>
                  <i style={{ "--value": `${completedPercent}%` }} />
                </div>
              </div>
              <div className={styles.analyticsCard}>
                <span>Participants</span>
                <strong>{formatCoins(heistSummary.total_participants)}</strong>
                <div className={styles.miniMeter}>
                  <i style={{ "--value": `${percentOf(heistSummary.total_participants, Math.max(Number(heistSummary.total_heists || 0) * 10, 1))}%` }} />
                </div>
              </div>
              <div className={styles.analyticsCard}>
                <span>Ticket revenue</span>
                <strong>{formatCoins(heistSummary.total_ticket_revenue)}</strong>
                <div className={styles.miniMeter}>
                  <i style={{ "--value": `${percentOf(heistSummary.total_ticket_revenue, Number(heistSummary.total_ticket_revenue || 0) + Number(heistSummary.total_prize_payouts || 0))}%` }} />
                </div>
              </div>
              <div className={styles.analyticsCard}>
                <span>Prize payouts</span>
                <strong>{formatCoins(heistSummary.total_prize_payouts)}</strong>
                <div className={styles.miniMeter}>
                  <i style={{ "--value": `${percentOf(heistSummary.total_prize_payouts, Number(heistSummary.total_ticket_revenue || 0) + Number(heistSummary.total_prize_payouts || 0))}%` }} />
                </div>
              </div>
              <div className={styles.analyticsCard}>
                <span>Profit/Loss</span>
                <strong className={Number(heistSummary.total_profit_loss) < 0 ? styles.negative : styles.positive}>
                  {formatSignedCoins(heistSummary.total_profit_loss)}
                </strong>
                <small>{formatSignedMoney(heistSummary.total_profit_loss_value, coinRate.currency)}</small>
              </div>
            </div>

            <div className={styles.chartGrid}>
              <article className={styles.chartPanel}>
                <div className={styles.chartHead}>
                  <div>
                    <span>Revenue map</span>
                    <strong>Tickets vs prizes</strong>
                  </div>
                  <FaChartBar />
                </div>
                <div className={styles.barList}>
                  {topRevenueHeists.length ? (
                    topRevenueHeists.map((heist) => (
                      <div key={heist.id} className={styles.barRow}>
                        <div>
                          <span>{heist.name}</span>
                          <strong>{formatSignedCoins(heist.profit_loss)}</strong>
                        </div>
                        <div className={styles.dualBars}>
                          <i style={{ "--value": `${percentOf(heist.ticket_revenue, maxRevenue)}%` }} />
                          <b style={{ "--value": `${percentOf(heist.prize_payout, maxRevenue)}%` }} />
                        </div>
                        <small>
                          Revenue {formatCoins(heist.ticket_revenue)} / Prize {formatCoins(heist.prize_payout)}
                        </small>
                      </div>
                    ))
                  ) : (
                    <p className={styles.emptyChart}>No heist revenue yet.</p>
                  )}
                </div>
              </article>

              <article className={styles.chartPanel}>
                <div className={styles.chartHead}>
                  <div>
                    <span>Operating view</span>
                    <strong>Status and reach</strong>
                  </div>
                  <FaUsers />
                </div>
                <div className={styles.statusBars}>
                  {statusBreakdown.map((item) => (
                    <div key={item.status}>
                      <span className={`${styles.statusPill} ${statusClassName(item.status)}`}>
                        {item.status}
                      </span>
                      <strong>{formatCoins(item.count)}</strong>
                      <i style={{ "--value": `${item.percent}%` }} />
                    </div>
                  ))}
                </div>
                <div className={styles.participantBars}>
                  {topParticipantHeists.length ? (
                    topParticipantHeists.map((heist) => (
                      <div key={heist.id}>
                        <span>{heist.name}</span>
                        <strong>{formatCoins(heist.participant_count)}</strong>
                        <i style={{ "--value": `${percentOf(heist.participant_count, maxParticipants)}%` }} />
                      </div>
                    ))
                  ) : (
                    <p className={styles.emptyChart}>No participant activity yet.</p>
                  )}
                </div>
              </article>

              <article className={styles.chartPanel}>
                <div className={styles.chartHead}>
                  <div>
                    <span>Balance pressure</span>
                    <strong>Platform health</strong>
                  </div>
                  <FaBalanceScale />
                </div>
                <div className={styles.balanceGauge}>
                  <div>
                    <span>Platform coins</span>
                    <strong className={platformBalance < 0 ? styles.negative : styles.positive}>
                      {formatSignedCoins(platformBalance)}
                    </strong>
                    <i style={{ "--value": `${percentOf(Math.abs(platformBalance), Math.max(Math.abs(platformBalance), Math.abs(systemBalance), 1))}%` }} />
                  </div>
                  <div>
                    <span>System balance</span>
                    <strong className={systemBalance < 0 ? styles.negative : styles.positive}>
                      {formatSignedCoins(systemBalance)}
                    </strong>
                    <i style={{ "--value": `${percentOf(Math.abs(systemBalance), Math.max(Math.abs(platformBalance), Math.abs(systemBalance), 1))}%` }} />
                  </div>
                  <div>
                    <span>Profit/Loss value</span>
                    <strong className={Number(heistSummary.total_profit_loss_value) < 0 ? styles.negative : styles.positive}>
                      {formatSignedMoney(heistSummary.total_profit_loss_value, coinRate.currency)}
                    </strong>
                    <i style={{ "--value": `${percentOf(Math.abs(heistSummary.total_profit_loss), Math.max(maxProfitLoss, Math.abs(Number(heistSummary.total_profit_loss || 0)), 1))}%` }} />
                  </div>
                </div>
              </article>
            </div>
          </div>

          <div className={`${styles.tableWrap} ${styles.heistTableWrap}`}>
            <table className={styles.table}>
              <thead>
                <tr>
                  <th>Heist</th>
                  <th>Status</th>
                  <th>Users</th>
                  <th>Ticket</th>
                  <th>Revenue</th>
                  <th>Prize</th>
                  <th>Profit/Loss</th>
                  <th>Value</th>
                </tr>
              </thead>
              <tbody>
                {loading ? (
                  <tr>
                    <td colSpan="8">Loading heists...</td>
                  </tr>
                ) : heists.length ? (
                  heists.map((heist) => (
                    <tr key={heist.id}>
                      <td>
                        <strong>{heist.name}</strong>
                        <small>
                          {heist.winner_username ? (
                            <>
                              <FaTrophy /> {heist.winner_username}
                            </>
                          ) : (
                            "No winner"
                          )}
                        </small>
                      </td>
                      <td>
                        <span className={`${styles.statusPill} ${statusClassName(heist.status)}`}>
                          {heist.status}
                        </span>
                      </td>
                      <td>{formatCoins(heist.participant_count)}</td>
                      <td>{formatCoins(heist.ticket_price)}</td>
                      <td>{formatCoins(heist.ticket_revenue)}</td>
                      <td>{formatCoins(heist.prize_payout)}</td>
                      <td className={Number(heist.profit_loss) < 0 ? styles.negative : styles.positive}>
                        {formatSignedCoins(heist.profit_loss)}
                      </td>
                      <td className={Number(heist.profit_loss_value) < 0 ? styles.negative : styles.positive}>
                        {formatSignedMoney(heist.profit_loss_value, coinRate.currency)}
                      </td>
                    </tr>
                  ))
                ) : (
                  <tr>
                    <td colSpan="8">No heists found.</td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </section>
      </main>
    </div>
  );
}
