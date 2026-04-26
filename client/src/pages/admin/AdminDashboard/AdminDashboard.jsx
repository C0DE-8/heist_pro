import React, { useCallback, useEffect, useMemo, useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  FaChartLine,
  FaCoins,
  FaFlask,
  FaRedoAlt,
  FaTrophy,
  FaUsers,
  FaWallet,
} from "react-icons/fa";
import AdminNavbar from "../../../components/admin/Navbar";
import { getAdminProfile } from "../../../lib/admin";
import styles from "./AdminDashboard.module.css";

function formatNum(value) {
  const n = Number(value);
  return Number.isFinite(n) ? n.toLocaleString() : "0";
}

function formatDate(value) {
  if (!value) return "Not scheduled";
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "Not scheduled";
  return date.toLocaleString([], {
    month: "short",
    day: "numeric",
    hour: "numeric",
    minute: "2-digit",
  });
}

function adminName(admin) {
  return admin?.full_name || admin?.username || admin?.email || "Admin";
}

export default function AdminDashboard() {
  const navigate = useNavigate();
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const admin = data?.admin || null;
  const userStats = data?.stats?.users || {};
  const heistStats = data?.stats?.heists || {};
  const activityStats = data?.stats?.activity || {};
  const rewardStats = data?.stats?.rewards || {};
  const analyticsStats = data?.stats?.analytics || {};
  const recentHeists = Array.isArray(data?.recent_heists) ? data.recent_heists : [];
  const recentUsers = Array.isArray(data?.recent_users) ? data.recent_users : [];

  const loadDashboard = useCallback(async () => {
    setLoading(true);
    setError("");

    try {
      const result = await getAdminProfile();
      setData(result);
    } catch (err) {
      console.error("Admin dashboard error:", err);
      setError(err?.response?.data?.message || "Unable to load admin dashboard.");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadDashboard();
  }, [loadDashboard]);

  const actionCards = useMemo(
    () => [
      {
        title: "Manage Heists",
        text: "Create heists, add true/false questions, control status, tasks, and finalize winners.",
        path: "/admin/heists",
        icon: <FaFlask />,
        stat: `${formatNum(heistStats.total_heists)} heists`,
        tone: "cyan",
      },
      {
        title: "Users",
        text: "Review user accounts, balances, roles, blocked state, and verification state.",
        path: "/admin/users",
        icon: <FaUsers />,
        stat: `${formatNum(userStats.total_users)} users`,
        tone: "green",
      },
      {
        title: "Transactions",
        text: "Manage pay-in details, coin rate, payment requests, approvals, and withdrawals.",
        path: "/admin/transactions",
        icon: <FaCoins />,
        stat: `${formatNum(userStats.total_cop_points)} CP`,
        tone: "gold",
      },
      {
        title: "Analytics",
        text: "Review platform coin totals, excluded accounts, heist profit, and reconciliation.",
        path: "/admin/analytics",
        icon: <FaChartLine />,
        stat: `${formatNum(analyticsStats.excluded_users)} excluded`,
        tone: "purple",
      },
      {
        title: "Payouts",
        text: "Jump directly into outgoing withdrawal reviews and payout decisions.",
        path: "/admin/transactions",
        icon: <FaWallet />,
        stat: "Payouts",
        tone: "pink",
      },
    ],
    [
      analyticsStats.excluded_users,
      heistStats.total_heists,
      userStats.total_cop_points,
      userStats.total_users,
    ]
  );

  return (
    <div className={styles.page}>
      <AdminNavbar admin={admin} />

      <main className={styles.main}>
        <section className={styles.hero}>
          <div>
            <p className={styles.kicker}>Admin Dashboard</p>
            <h1>{loading ? "Loading control room..." : `Welcome, ${adminName(admin)}`}</h1>
            <p>
              Monitor CopUpCoin balances, Heist activity, affiliate rewards, and platform users
              from one admin workspace.
            </p>
          </div>

          <button
            type="button"
            className={styles.refreshBtn}
            onClick={loadDashboard}
            disabled={loading}
          >
            <FaRedoAlt />
            <span>{loading ? "Refreshing..." : "Refresh"}</span>
          </button>
        </section>

        {error ? (
          <div className={styles.errorBox}>
            <span>{error}</span>
            <button type="button" onClick={loadDashboard}>
              Retry
            </button>
          </div>
        ) : null}

        <section className={styles.statsGrid}>
          <div className={styles.statCard}>
            <span>Total users</span>
            <strong>{loading ? "..." : formatNum(userStats.total_users)}</strong>
            <small>
              {formatNum(userStats.included_users)} shown · {formatNum(userStats.excluded_users)} excluded
            </small>
          </div>
          <div className={styles.statCard}>
            <span>Started heists</span>
            <strong>{loading ? "..." : formatNum(heistStats.started_heists)}</strong>
            <small>{formatNum(heistStats.pending_heists)} pending</small>
          </div>
          <div className={styles.statCard}>
            <span>Submitted results</span>
            <strong>{loading ? "..." : formatNum(activityStats.submitted_results)}</strong>
            <small>{formatNum(activityStats.total_submissions)} submissions</small>
          </div>
          <div className={styles.statCard}>
            <span>Total user coins</span>
            <strong>{loading ? "..." : `${formatNum(userStats.total_cop_points)} CP`}</strong>
            <small>{formatNum(userStats.excluded_user_coin_balance)} CP excluded</small>
          </div>
          <div className={styles.statCard}>
            <span>Affiliate rewards</span>
            <strong>{loading ? "..." : `${formatNum(rewardStats.affiliate_rewards_awarded)} CP`}</strong>
            <small>{formatNum(activityStats.completed_affiliate_tasks)} completed tasks</small>
          </div>
        </section>

        <section className={styles.sectionHead}>
          <div>
            <p className={styles.kicker}>Admin Tools</p>
            <h2>Choose what to manage</h2>
          </div>
        </section>

        <section className={styles.cardGrid}>
          {actionCards.map((card) => (
            <button
              type="button"
              key={card.path}
              className={`${styles.actionCard} ${styles[card.tone]}`}
              onClick={() => navigate(card.path)}
            >
              <span className={styles.cardIcon}>{card.icon}</span>
              <span className={styles.cardStat}>{card.stat}</span>
              <strong>{card.title}</strong>
              <span>{card.text}</span>
            </button>
          ))}
        </section>

        <section className={styles.overviewGrid}>
          <article className={styles.panel}>
            <div className={styles.panelHead}>
              <div>
                <p className={styles.kicker}>Heists</p>
                <h2>Recent heists</h2>
              </div>
              <FaTrophy />
            </div>

            <div className={styles.rows}>
              {loading ? (
                <div className={styles.emptyState}>Loading heists...</div>
              ) : recentHeists.length ? (
                recentHeists.slice(0, 6).map((heist) => (
                  <button
                    type="button"
                    key={heist.id}
                    className={styles.rowBtn}
                    onClick={() => navigate("/admin/heists")}
                  >
                    <span>
                      <strong>{heist.name}</strong>
                      <small>
                        {formatNum(heist.prize_cop_points)} CP prize ·{" "}
                        {formatDate(heist.countdown_ends_at)}
                      </small>
                    </span>
                    <em>{heist.status}</em>
                  </button>
                ))
              ) : (
                <div className={styles.emptyState}>No heists yet.</div>
              )}
            </div>
          </article>

          <article className={styles.panel}>
            <div className={styles.panelHead}>
              <div>
                <p className={styles.kicker}>Users</p>
                <h2>Newest included users</h2>
              </div>
              <FaUsers />
            </div>

            <div className={styles.rows}>
              {loading ? (
                <div className={styles.emptyState}>Loading users...</div>
              ) : recentUsers.length ? (
                recentUsers.slice(0, 6).map((user) => (
                  <button
                    type="button"
                    key={user.id}
                    className={styles.rowBtn}
                    onClick={() => navigate("/admin/users")}
                  >
                    <span>
                      <strong>{user.full_name || user.username || user.email}</strong>
                      <small>
                        {formatNum(user.cop_point)} CP · {formatDate(user.created_at)}
                      </small>
                    </span>
                    <em>{user.role}</em>
                  </button>
                ))
              ) : (
                <div className={styles.emptyState}>No included users to show.</div>
              )}
            </div>
            <p className={styles.panelNote}>
              Excluded accounts are removed from this list and from the dashboard user-coin total.
            </p>
          </article>
        </section>
      </main>
    </div>
  );
}
