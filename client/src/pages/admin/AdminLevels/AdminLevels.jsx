import React, { useCallback, useEffect, useMemo, useState } from "react";
import {
  FaAward,
  FaGift,
  FaRedo,
  FaSave,
  FaSearch,
  FaSlidersH,
  FaUsers,
} from "react-icons/fa";
import AdminNavbar from "../../../components/admin/Navbar";
import { formatDate, formatLevelName, formatNumber, getBadgeImage } from "../../../lib/levelBadges";
import {
  adjustAdminUserXp,
  getAdminBadges,
  getAdminLevelDefinitions,
  getAdminLevelRewards,
  getAdminLevelSummary,
  getAdminUserProgress,
  getAdminXpRules,
  updateAdminBadge,
  updateAdminLevelDefinition,
  updateAdminLevelReward,
  updateAdminXpRule,
} from "../../../lib/levels";
import styles from "./AdminLevels.module.css";

const TABS = ["overview", "badges", "levels", "xp rules", "rewards", "users"];
const REWARD_STATUSES = ["", "earned", "claimed", "redeemed", "expired"];

export default function AdminLevels() {
  const [activeTab, setActiveTab] = useState("overview");
  const [summary, setSummary] = useState(null);
  const [badges, setBadges] = useState([]);
  const [levels, setLevels] = useState([]);
  const [rules, setRules] = useState([]);
  const [rewards, setRewards] = useState([]);
  const [rewardStatus, setRewardStatus] = useState("");
  const [userId, setUserId] = useState("");
  const [userProgress, setUserProgress] = useState(null);
  const [adjustment, setAdjustment] = useState({ xp_amount: "", reason: "" });
  const [loading, setLoading] = useState(true);
  const [busy, setBusy] = useState("");
  const [error, setError] = useState("");

  const levelStats = useMemo(() => summary?.summary || {}, [summary]);

  const loadAll = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      const [nextSummary, nextBadges, nextLevels, nextRules, nextRewards] = await Promise.all([
        getAdminLevelSummary(),
        getAdminBadges(),
        getAdminLevelDefinitions(),
        getAdminXpRules(),
        getAdminLevelRewards(rewardStatus),
      ]);
      setSummary(nextSummary);
      setBadges(nextBadges);
      setLevels(nextLevels);
      setRules(nextRules);
      setRewards(nextRewards);
    } catch (err) {
      setError(err?.response?.data?.message || "Unable to load level admin.");
    } finally {
      setLoading(false);
    }
  }, [rewardStatus]);

  useEffect(() => {
    loadAll();
  }, [loadAll]);

  const saveBadge = async (badge) => {
    setBusy(`badge:${badge.id}`);
    try {
      await updateAdminBadge(badge.id, badge);
      await loadAll();
    } finally {
      setBusy("");
    }
  };

  const saveLevel = async (level) => {
    setBusy(`level:${level.id}`);
    try {
      await updateAdminLevelDefinition(level.id, {
        xp_required: Number(level.xp_required || 0),
        coupon_copup_jr_amount: Number(level.coupon_copup_jr_amount || 0),
        is_active: Number(level.is_active) ? 1 : 0,
      });
      await loadAll();
    } finally {
      setBusy("");
    }
  };

  const saveRule = async (rule) => {
    setBusy(`rule:${rule.source}`);
    try {
      await updateAdminXpRule(rule.source, {
        xp_amount: Number(rule.xp_amount || 0),
        label: rule.label,
        is_active: Number(rule.is_active) ? 1 : 0,
      });
      await loadAll();
    } finally {
      setBusy("");
    }
  };

  const changeRewardStatus = async (reward, status) => {
    setBusy(`reward:${reward.id}`);
    try {
      await updateAdminLevelReward(reward.id, { status });
      await loadAll();
    } finally {
      setBusy("");
    }
  };

  const findUser = async (event) => {
    event.preventDefault();
    if (!userId.trim()) return;
    setBusy("user-search");
    setUserProgress(null);
    try {
      setUserProgress(await getAdminUserProgress(userId.trim()));
    } finally {
      setBusy("");
    }
  };

  const submitAdjustment = async (event) => {
    event.preventDefault();
    if (!userProgress?.user?.id) return;
    setBusy("adjust");
    try {
      await adjustAdminUserXp(userProgress.user.id, {
        xp_amount: Number(adjustment.xp_amount),
        reason: adjustment.reason,
      });
      setAdjustment({ xp_amount: "", reason: "" });
      setUserProgress(await getAdminUserProgress(userProgress.user.id));
      await loadAll();
    } finally {
      setBusy("");
    }
  };

  const updateBadgeState = (id, patch) => {
    setBadges((items) => items.map((item) => (item.id === id ? { ...item, ...patch } : item)));
  };

  const updateLevelState = (id, patch) => {
    setLevels((items) => items.map((item) => (item.id === id ? { ...item, ...patch } : item)));
  };

  const updateRuleState = (source, patch) => {
    setRules((items) => items.map((item) => (item.source === source ? { ...item, ...patch } : item)));
  };

  return (
    <div className={styles.page}>
      <AdminNavbar />
      <main className={styles.main}>
        <section className={styles.hero}>
          <div>
            <p className={styles.kicker}>Levels And Rewards</p>
            <h1>User progression</h1>
            <p>Manage badge images, Roman numeral levels, XP sources, and coupon rewards.</p>
          </div>
          <button type="button" className={styles.refreshBtn} onClick={loadAll} disabled={loading}>
            <FaRedo />
          </button>
        </section>

        {error ? <div className={styles.errorBox}>{error}</div> : null}

        <nav className={styles.tabs}>
          {TABS.map((tab) => (
            <button
              key={tab}
              type="button"
              className={activeTab === tab ? styles.activeTab : ""}
              onClick={() => setActiveTab(tab)}
            >
              {tab}
            </button>
          ))}
        </nav>

        {activeTab === "overview" ? (
          <section className={styles.grid}>
            <Metric icon={<FaUsers />} label="Users with XP" value={levelStats.users_with_xp} />
            <Metric icon={<FaSlidersH />} label="Total XP" value={levelStats.total_xp} />
            <Metric icon={<FaGift />} label="Rewards earned" value={levelStats.rewards_earned} />
            <Metric icon={<FaAward />} label="Redeemed" value={levelStats.rewards_redeemed} />
          </section>
        ) : null}

        {activeTab === "badges" ? (
          <section className={styles.panel}>
            <PanelTitle title="Badge manager" note={`${badges.length} badges`} />
            <div className={styles.badgeGrid}>
              {badges.map((badge) => (
                <article className={styles.badgeCard} key={badge.id}>
                  <img src={getBadgeImage(badge)} alt={badge.name} />
                  <label>
                    <span>Name</span>
                    <input value={badge.name || ""} onChange={(e) => updateBadgeState(badge.id, { name: e.target.value })} />
                  </label>
                  <label>
                    <span>Image path</span>
                    <input value={badge.image_path || ""} onChange={(e) => updateBadgeState(badge.id, { image_path: e.target.value })} />
                  </label>
                  <label className={styles.check}>
                    <input type="checkbox" checked={Boolean(Number(badge.is_active))} onChange={(e) => updateBadgeState(badge.id, { is_active: e.target.checked ? 1 : 0 })} />
                    <span>Active</span>
                  </label>
                  <button type="button" onClick={() => saveBadge(badge)} disabled={busy === `badge:${badge.id}`}>
                    <FaSave /> Save
                  </button>
                </article>
              ))}
            </div>
          </section>
        ) : null}

        {activeTab === "levels" ? (
          <section className={styles.panel}>
            <PanelTitle title="Level rules" note={`${levels.length} total levels`} />
            <div className={styles.table}>
              {levels.map((level) => (
                <article className={styles.levelRow} key={level.id}>
                  <img src={getBadgeImage(level)} alt={formatLevelName(level)} />
                  <strong>{formatLevelName(level)}</strong>
                  <label>
                    <span>XP</span>
                    <input type="number" min="0" value={level.xp_required} onChange={(e) => updateLevelState(level.id, { xp_required: e.target.value })} />
                  </label>
                  <label>
                    <span>Coupon</span>
                    <input type="number" min="0" value={level.coupon_copup_jr_amount} onChange={(e) => updateLevelState(level.id, { coupon_copup_jr_amount: e.target.value })} />
                  </label>
                  <button type="button" onClick={() => saveLevel(level)} disabled={busy === `level:${level.id}`}>
                    <FaSave /> Save
                  </button>
                </article>
              ))}
            </div>
          </section>
        ) : null}

        {activeTab === "xp rules" ? (
          <section className={styles.panel}>
            <PanelTitle title="XP source rules" note="Login, heist, referral, deposit, withdrawal" />
            <div className={styles.table}>
              {rules.map((rule) => (
                <article className={styles.ruleRow} key={rule.source}>
                  <strong>{rule.source}</strong>
                  <label>
                    <span>Label</span>
                    <input value={rule.label || ""} onChange={(e) => updateRuleState(rule.source, { label: e.target.value })} />
                  </label>
                  <label>
                    <span>XP</span>
                    <input type="number" min="0" value={rule.xp_amount} onChange={(e) => updateRuleState(rule.source, { xp_amount: e.target.value })} />
                  </label>
                  <label className={styles.check}>
                    <input type="checkbox" checked={Boolean(Number(rule.is_active))} onChange={(e) => updateRuleState(rule.source, { is_active: e.target.checked ? 1 : 0 })} />
                    <span>Active</span>
                  </label>
                  <button type="button" onClick={() => saveRule(rule)} disabled={busy === `rule:${rule.source}`}>
                    <FaSave /> Save
                  </button>
                </article>
              ))}
            </div>
          </section>
        ) : null}

        {activeTab === "rewards" ? (
          <section className={styles.panel}>
            <PanelTitle title="Reward audit" note={`${rewards.length} rewards`} />
            <select value={rewardStatus} onChange={(e) => setRewardStatus(e.target.value)}>
              {REWARD_STATUSES.map((status) => (
                <option key={status || "all"} value={status}>
                  {status || "all statuses"}
                </option>
              ))}
            </select>
            <div className={styles.table}>
              {rewards.map((reward) => (
                <article className={styles.rewardRow} key={reward.id}>
                  <div>
                    <strong>{reward.username || reward.email}</strong>
                    <small>{formatLevelName(reward)} - {formatDate(reward.earned_at)}</small>
                  </div>
                  <code>{reward.code}</code>
                  <select
                    value={reward.status}
                    onChange={(e) => changeRewardStatus(reward, e.target.value)}
                    disabled={busy === `reward:${reward.id}`}
                  >
                    {REWARD_STATUSES.filter(Boolean).map((status) => (
                      <option key={status} value={status}>{status}</option>
                    ))}
                  </select>
                </article>
              ))}
            </div>
          </section>
        ) : null}

        {activeTab === "users" ? (
          <section className={styles.panel}>
            <PanelTitle title="User progress lookup" note="Search by user id" />
            <form className={styles.searchForm} onSubmit={findUser}>
              <input value={userId} onChange={(e) => setUserId(e.target.value)} placeholder="User ID" />
              <button type="submit" disabled={busy === "user-search"}>
                <FaSearch /> Search
              </button>
            </form>

            {userProgress ? (
              <div className={styles.userBox}>
                <div>
                  <strong>{userProgress.user?.username || userProgress.user?.email}</strong>
                  <small>{formatLevelName(userProgress.progress?.current_level)} - {formatNumber(userProgress.progress?.total_xp)} XP</small>
                </div>
                <form className={styles.adjustForm} onSubmit={submitAdjustment}>
                  <input
                    type="number"
                    value={adjustment.xp_amount}
                    onChange={(e) => setAdjustment((prev) => ({ ...prev, xp_amount: e.target.value }))}
                    placeholder="XP amount"
                  />
                  <input
                    value={adjustment.reason}
                    onChange={(e) => setAdjustment((prev) => ({ ...prev, reason: e.target.value }))}
                    placeholder="Reason"
                  />
                  <button type="submit" disabled={busy === "adjust"}>
                    <FaSave /> Adjust
                  </button>
                </form>
              </div>
            ) : null}
          </section>
        ) : null}
      </main>
    </div>
  );
}

function Metric({ icon, label, value }) {
  return (
    <article className={styles.metric}>
      <span>{icon}</span>
      <small>{label}</small>
      <strong>{formatNumber(value)}</strong>
    </article>
  );
}

function PanelTitle({ title, note }) {
  return (
    <div className={styles.panelTitle}>
      <h2>{title}</h2>
      <p>{note}</p>
    </div>
  );
}
