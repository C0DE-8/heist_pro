import React, { useCallback, useEffect, useMemo, useState } from "react";
import {
  FaBalanceScale,
  FaChartLine,
  FaCoins,
  FaRedoAlt,
  FaSearch,
  FaTrophy,
  FaUsers,
  FaWallet,
} from "react-icons/fa";
import AdminNavbar from "../../../components/admin/Navbar";
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

  const filteredUsers = useMemo(() => {
    const needle = search.trim().toLowerCase();
    if (!needle) return users;
    return users.filter((user) => {
      return [user.username, user.email, user.full_name, user.wallet_address, user.game_id]
        .filter(Boolean)
        .some((value) => String(value).toLowerCase().includes(needle));
    });
  }, [search, users]);

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
        <section className={styles.hero}>
          <div>
            <p className={styles.kicker}>Admin Analytics</p>
            <h1>System Analysis</h1>
            <p>Track coin balances, heist revenue, prize payouts, and platform reconciliation.</p>
          </div>

          <button type="button" className={styles.refreshBtn} onClick={loadAnalytics} disabled={loading}>
            <FaRedoAlt />
            <span>{loading ? "Refreshing..." : "Refresh"}</span>
          </button>
        </section>

        {error ? (
          <div className={styles.errorBox}>
            <span>{error}</span>
            <button type="button" onClick={loadAnalytics}>
              Retry
            </button>
          </div>
        ) : null}

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

        <section className={styles.panel}>
          <div className={styles.panelHead}>
            <div>
              <p className={styles.kicker}>Heists</p>
              <h2>Performance Analysis</h2>
            </div>
            <FaChartLine />
          </div>

          <div className={styles.statsGridCompact}>
            <div>
              <span>Total heists</span>
              <strong>{formatCoins(heistSummary.total_heists)}</strong>
            </div>
            <div>
              <span>Completed</span>
              <strong>{formatCoins(heistSummary.completed_heists)}</strong>
            </div>
            <div>
              <span>Participants</span>
              <strong>{formatCoins(heistSummary.total_participants)}</strong>
            </div>
            <div>
              <span>Ticket revenue</span>
              <strong>{formatCoins(heistSummary.total_ticket_revenue)}</strong>
            </div>
            <div>
              <span>Prize payouts</span>
              <strong>{formatCoins(heistSummary.total_prize_payouts)}</strong>
            </div>
            <div>
              <span>Profit/Loss</span>
              <strong>{formatSignedCoins(heistSummary.total_profit_loss)}</strong>
            </div>
            <div>
              <span>Profit/Loss value</span>
              <strong>{formatSignedMoney(heistSummary.total_profit_loss_value, coinRate.currency)}</strong>
            </div>
          </div>

          <div className={styles.tableWrap}>
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
