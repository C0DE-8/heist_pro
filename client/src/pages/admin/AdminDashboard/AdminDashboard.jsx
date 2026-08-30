import React, { useCallback, useEffect, useMemo, useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  FaArrowRight,
  FaChartLine,
  FaCoins,
  FaEye,
  FaFlask,
  FaGift,
  FaMedal,
  FaBell,
  FaShieldAlt,
  FaSignal,
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
        text: "Build rounds, assign questions, control status, and finalize winners.",
        path: "/admin/heists",
        icon: <FaFlask />,
        stat: `${formatNum(heistStats.total_heists)} heists`,
        tone: "cyan",
        featured: true,
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
        title: "God Eyes",
        text: "Watch login activity, site visits, IPs, device matches, account limits, and suspicious users.",
        path: "/admin/god-eyes",
        icon: <FaEye />,
        stat: "Security",
        tone: "cyan",
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
        title: "Affiliate System",
        text: "Manage affiliate links, Tiles, ticket targets, rewards, referral progress, and monthly earnings.",
        path: "/admin/referral",
        icon: <FaGift />,
        stat: `${formatNum(activityStats.affiliate_referrals)} affiliate joins`,
        tone: "purple",
      },
      {
        title: "User Alerts",
        text: "Send in-app notices and push alerts to one user or every active user.",
        path: "/admin/notifications",
        icon: <FaBell />,
        stat: "Notices",
        tone: "cyan",
      },
      {
        title: "Clan Management",
        text: "Review clans, manage status, configure clan settings, create quests, and distribute clan rewards.",
        path: "/admin/clans",
        icon: <FaShieldAlt />,
        stat: "Clans",
        tone: "green",
      },
      {
        title: "Levels",
        text: "Manage badges, XP rules, Roman numeral levels, and coupon reward status.",
        path: "/admin/levels",
        icon: <FaMedal />,
        stat: "XP",
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
      activityStats.affiliate_referrals,
      heistStats.total_heists,
      userStats.total_cop_points,
      userStats.total_users,
    ]
  );

  const heroMetrics = [
    {
      label: "Active heists",
      value: loading ? "..." : formatNum(heistStats.started_heists),
      note: `${formatNum(heistStats.pending_heists)} pending`,
    },
    {
      label: "User balance",
      value: loading ? "..." : `${formatNum(userStats.total_cop_points)} CP`,
      note: `${formatNum(userStats.excluded_user_coin_balance)} CP excluded`,
    },
    {
      label: "Affiliate joins",
      value: loading ? "..." : formatNum(activityStats.affiliate_referrals),
      note: `${formatNum(rewardStats.affiliate_rewards_awarded)} CP rewarded`,
    },
  ];

  const statCards = [
    {
      label: "Total users",
      value: loading ? "..." : formatNum(userStats.total_users),
      note: `${formatNum(userStats.included_users)} shown / ${formatNum(userStats.excluded_users)} excluded`,
    },
    {
      label: "Started heists",
      value: loading ? "..." : formatNum(heistStats.started_heists),
      note: `${formatNum(heistStats.pending_heists)} pending`,
    },
    {
      label: "Submitted results",
      value: loading ? "..." : formatNum(activityStats.submitted_results),
      note: `${formatNum(activityStats.total_submissions)} submissions`,
    },
    {
      label: "Total user coins",
      value: loading ? "..." : `${formatNum(userStats.total_cop_points)} CP`,
      note: `${formatNum(userStats.excluded_user_coin_balance)} CP excluded`,
    },
    {
      label: "Affiliate rewards",
      value: loading ? "..." : `${formatNum(rewardStats.affiliate_rewards_awarded)} CP`,
      note: `${formatNum(activityStats.completed_affiliate_tasks)} completed tasks`,
    },
  ];

  return (
    <div className={styles.page}>
      <AdminNavbar admin={admin} />

      <main className={styles.main}>
        <section className={styles.hero}>
          <div className={styles.heroCopy}>
            <p className={styles.kicker}>Admin Dashboard</p>
            <h1>{loading ? "Loading control room..." : `Welcome, ${adminName(admin)}`}</h1>
            <p>
              Monitor CopUpCoin balances, live heists, affiliate rewards, and user risk from a
              cleaner command workspace.
            </p>

            <div className={styles.heroActions}>
              <button
                type="button"
                className={styles.primaryBtn}
                onClick={() => navigate("/admin/heists")}
              >
                <FaFlask />
                Manage heists
              </button>
              <button
                type="button"
                className={styles.refreshBtn}
                onClick={loadDashboard}
                disabled={loading}
                title={loading ? "Refreshing..." : "Refresh dashboard"}
              >
                <FaSignal />
                {loading ? "Refreshing..." : "Refresh"}
              </button>
            </div>
          </div>

          <div className={styles.heroModel} aria-label="Platform summary">
            <div className={styles.modelTop}>
              <span>Live operations</span>
              <strong>{formatNum(heistStats.total_heists)} total heists</strong>
            </div>
            <div className={styles.modelCards}>
              {heroMetrics.map((metric) => (
                <div className={styles.modelCard} key={metric.label}>
                  <span>{metric.label}</span>
                  <strong>{metric.value}</strong>
                  <small>{metric.note}</small>
                </div>
              ))}
            </div>
          </div>
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
          {statCards.map((stat) => (
            <div className={styles.statCard} key={stat.label}>
              <span>{stat.label}</span>
              <strong>{stat.value}</strong>
              <small>{stat.note}</small>
            </div>
          ))}
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
              className={`${styles.actionCard} ${styles[card.tone]} ${
                card.featured ? styles.featuredCard : ""
              }`}
              onClick={() => navigate(card.path)}
            >
              <span className={styles.cardTop}>
                <span className={styles.cardIcon}>{card.icon}</span>
                <span className={styles.cardStat}>{card.stat}</span>
              </span>
              <span className={styles.cardBody}>
                <strong>{card.title}</strong>
                <span>{card.text}</span>
              </span>
              <span className={styles.cardCta}>
                Open <FaArrowRight />
              </span>
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
