import React, { useCallback, useEffect, useMemo, useState } from "react";
import { FaCalculator, FaGift, FaRedoAlt, FaSave, FaShieldAlt, FaUsers } from "react-icons/fa";
import AdminNavbar from "../../../components/admin/Navbar";
import AdminPageHeader from "../../../components/admin/AdminPageHeader";
import { useToast } from "../../../components/Toast/ToastContext";
import {
  calculateClanQuest,
  createClanQuest,
  distributeClanQuest,
  getAdminClans,
  updateAdminClan,
  updateClanSettings,
} from "../../../lib/adminClans";
import styles from "./AdminClans.module.css";

function formatNum(value) {
  const n = Number(value);
  return Number.isFinite(n) ? n.toLocaleString() : "0";
}

function formatDate(value) {
  if (!value) return "Not set";
  const date = new Date(value);
  return Number.isNaN(date.getTime()) ? "Not set" : date.toLocaleString();
}

const questDefaults = {
  title: "Top Heist Clan of the Week",
  description: "Clan with the most successful heist wins during the quest period wins.",
  quest_type: "heist_wins",
  status: "scheduled",
  starts_at: "",
  ends_at: "",
  prize_amount: 0,
  participation_policy: "opt_in",
  min_members: 1,
};

function SkeletonStat() {
  return (
    <div className={styles.skeletonStat}>
      <span className={styles.skeletonLine} />
      <span className={styles.skeletonLineShort} />
    </div>
  );
}

function SkeletonRows({ count = 3 }) {
  return (
    <>
      {Array.from({ length: count }, (_, index) => (
        <div className={styles.skeletonRow} key={index}>
          <span className={styles.skeletonLine} />
          <span className={styles.skeletonLineShort} />
          <span className={styles.skeletonPill} />
          <span className={styles.skeletonPill} />
        </div>
      ))}
    </>
  );
}

export default function AdminClans() {
  const toast = useToast();
  const [data, setData] = useState(null);
  const [settingsForm, setSettingsForm] = useState({ creation_cost_cop_points: 0, max_members: "", is_enabled: true });
  const [questForm, setQuestForm] = useState(questDefaults);
  const [loading, setLoading] = useState(true);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState("");

  const summary = useMemo(() => data?.summary || {}, [data?.summary]);
  const clans = Array.isArray(data?.clans) ? data.clans : [];
  const quests = Array.isArray(data?.quests) ? data.quests : [];

  const loadPage = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      const result = await getAdminClans();
      setData(result);
      setSettingsForm({
        creation_cost_cop_points: Number(result.settings?.creation_cost_cop_points || 0),
        max_members: result.settings?.max_members ?? "",
        is_enabled: Boolean(result.settings?.is_enabled),
      });
    } catch (err) {
      console.error("Admin clans load error:", err);
      setError(err?.response?.data?.message || "Unable to load clan dashboard.");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadPage();
  }, [loadPage]);

  const stats = useMemo(
    () => [
      { label: "Total clans", value: formatNum(summary.total_clans), icon: <FaShieldAlt /> },
      { label: "Active clans", value: formatNum(summary.active_clans), icon: <FaUsers /> },
      { label: "Suspended clans", value: formatNum(summary.suspended_clans), icon: <FaShieldAlt /> },
    ],
    [summary]
  );

  const updateSettingsField = (field) => (event) => {
    const value = event.target.type === "checkbox" ? event.target.checked : event.target.value;
    setSettingsForm((prev) => ({ ...prev, [field]: value }));
  };

  const updateQuestField = (field) => (event) => {
    setQuestForm((prev) => ({ ...prev, [field]: event.target.value }));
  };

  const saveSettings = async (event) => {
    event.preventDefault();
    setBusy(true);
    try {
      const result = await updateClanSettings({
        creation_cost_cop_points: Number(settingsForm.creation_cost_cop_points || 0),
        max_members: settingsForm.max_members === "" ? null : Number(settingsForm.max_members),
        is_enabled: Boolean(settingsForm.is_enabled),
      });
      setData((prev) => ({ ...(prev || {}), settings: result.settings }));
      toast.success("Clan settings updated.");
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to update clan settings.");
    } finally {
      setBusy(false);
    }
  };

  const saveQuest = async (event) => {
    event.preventDefault();
    setBusy(true);
    try {
      const result = await createClanQuest({
        ...questForm,
        prize_amount: Number(questForm.prize_amount || 0),
        min_members: Number(questForm.min_members || 1),
      });
      setData((prev) => ({ ...(prev || {}), quests: result.quests || prev?.quests || [] }));
      setQuestForm(questDefaults);
      toast.success("Clan quest created.");
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to create quest.");
    } finally {
      setBusy(false);
    }
  };

  const changeClanStatus = async (clanId, status) => {
    setBusy(true);
    try {
      await updateAdminClan(clanId, { status });
      toast.success("Clan status updated.");
      await loadPage();
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to update clan.");
    } finally {
      setBusy(false);
    }
  };

  const calculateQuest = async (questId) => {
    setBusy(true);
    try {
      const result = await calculateClanQuest(questId);
      setData((prev) => ({ ...(prev || {}), quests: result.quests || prev?.quests || [] }));
      toast.success("Quest scores calculated.");
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to calculate quest.");
    } finally {
      setBusy(false);
    }
  };

  const distributeQuest = async (questId) => {
    setBusy(true);
    try {
      const result = await distributeClanQuest(questId);
      setData((prev) => ({ ...(prev || {}), quests: result.quests || prev?.quests || [] }));
      toast.success(`Reward distributed to ${formatNum(result.member_count)} members.`);
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to distribute reward.");
    } finally {
      setBusy(false);
    }
  };

  return (
    <div className={styles.page}>
      <AdminNavbar />
      <main className={styles.main}>
        <AdminPageHeader
          title="Clan Management"
          kicker="Communities"
          description="Monitor clans, configure creation fees, manage status, create quests, calculate heist performance, and distribute rewards."
        />

        {error ? <div className={styles.error}>{error}</div> : null}

        <section className={styles.grid}>
          {loading ? Array.from({ length: 3 }, (_, index) => (
            <SkeletonStat key={index} />
          )) : stats.map((stat) => (
            <div className={styles.stat} key={stat.label}>
              <span>{stat.label}</span>
              <strong>{stat.value}</strong>
            </div>
          ))}
        </section>

        <section className={styles.panel}>
          <div className={styles.panelHead}>
            <h2>Clan settings</h2>
          </div>
          <form className={styles.form} onSubmit={saveSettings}>
            <label>
              Creation cost
              <input type="number" min="0" value={settingsForm.creation_cost_cop_points} onChange={updateSettingsField("creation_cost_cop_points")} />
            </label>
            <label>
              Max members
              <input type="number" min="1" value={settingsForm.max_members} onChange={updateSettingsField("max_members")} placeholder="No limit" />
            </label>
            <label>
              Enabled
              <select value={settingsForm.is_enabled ? "1" : "0"} onChange={(e) => setSettingsForm((prev) => ({ ...prev, is_enabled: e.target.value === "1" }))}>
                <option value="1">Enabled</option>
                <option value="0">Disabled</option>
              </select>
            </label>
            <button className={styles.primaryBtn} disabled={busy}><FaSave /> Save settings</button>
          </form>
        </section>

        <section className={styles.panel}>
          <div className={styles.panelHead}>
            <h2>Create clan quest</h2>
          </div>
          <form className={styles.form} onSubmit={saveQuest}>
            <label className={styles.wide}>
              Title
              <input value={questForm.title} onChange={updateQuestField("title")} required />
            </label>
            <label>
              Quest type
              <select value={questForm.quest_type} onChange={updateQuestField("quest_type")}>
                <option value="heist_wins">Heist wins</option>
                <option value="custom">Custom</option>
              </select>
            </label>
            <label>
              Status
              <select value={questForm.status} onChange={updateQuestField("status")}>
                <option value="draft">Draft</option>
                <option value="scheduled">Scheduled</option>
                <option value="active">Active</option>
              </select>
            </label>
            <label className={styles.full}>
              Description
              <textarea value={questForm.description} onChange={updateQuestField("description")} />
            </label>
            <label>
              Starts at
              <input type="datetime-local" value={questForm.starts_at} onChange={updateQuestField("starts_at")} required />
            </label>
            <label>
              Ends at
              <input type="datetime-local" value={questForm.ends_at} onChange={updateQuestField("ends_at")} required />
            </label>
            <label>
              Prize CP
              <input type="number" min="0" value={questForm.prize_amount} onChange={updateQuestField("prize_amount")} />
            </label>
            <label>
              Participation
              <select value={questForm.participation_policy} onChange={updateQuestField("participation_policy")}>
                <option value="opt_in">Opt in</option>
                <option value="auto">Auto</option>
              </select>
            </label>
            <button className={styles.primaryBtn} disabled={busy}><FaGift /> Create quest</button>
          </form>
        </section>

        <section className={styles.panel}>
          <div className={styles.panelHead}>
            <h2>Clans</h2>
            <button className={styles.ghostBtn} onClick={loadPage} disabled={busy} aria-label="Refresh clans" title="Refresh clans"><FaRedoAlt /></button>
          </div>
          <div className={styles.tableWrap}>
            {loading ? <SkeletonRows /> : (
              <table className={styles.table}>
                <thead>
                  <tr><th>Clan</th><th>Leader</th><th>Members</th><th>Policy</th><th>Status</th><th>Actions</th></tr>
                </thead>
                <tbody>
                  {clans.map((clan) => (
                    <tr key={clan.id}>
                      <td className={styles.nameCell}><strong>{clan.name}</strong><span>{clan.description || "No description"}</span></td>
                      <td>{clan.leader_full_name || clan.leader_username}</td>
                      <td>{formatNum(clan.member_count)}</td>
                      <td><span className={styles.badge}>{clan.join_policy}</span></td>
                      <td>
                        <select value={clan.status} onChange={(e) => changeClanStatus(clan.id, e.target.value)} disabled={busy}>
                          <option value="active">Active</option>
                          <option value="suspended">Suspended</option>
                          <option value="deleted">Deleted</option>
                        </select>
                      </td>
                      <td className={styles.actions}>
                        <button className={styles.secondaryBtn} onClick={() => window.location.assign(`/clans/${clan.id}`)}>Open</button>
                      </td>
                    </tr>
                  ))}
                  {!clans.length ? <tr><td colSpan="6">No clans yet.</td></tr> : null}
                </tbody>
              </table>
            )}
          </div>
        </section>

        <section className={styles.panel}>
          <div className={styles.panelHead}>
            <h2>Clan quests</h2>
          </div>
          <div className={styles.tableWrap}>
            {loading ? <SkeletonRows /> : (
              <table className={styles.table}>
                <thead>
                  <tr><th>Quest</th><th>Period</th><th>Prize</th><th>Participants</th><th>Winner</th><th>Status</th><th>Actions</th></tr>
                </thead>
                <tbody>
                  {quests.map((quest) => (
                    <tr key={quest.id}>
                      <td className={styles.nameCell}><strong>{quest.title}</strong><span>{quest.quest_type}</span></td>
                      <td>{formatDate(quest.starts_at)}<br />{formatDate(quest.ends_at)}</td>
                      <td>{formatNum(quest.prize_amount)} CP</td>
                      <td>{formatNum(quest.participating_clans)}</td>
                      <td>{quest.winning_clan_name || "Not decided"}</td>
                      <td><span className={styles.badge}>{quest.status}</span></td>
                      <td>
                        <div className={styles.actions}>
                          <button className={styles.secondaryBtn} onClick={() => calculateQuest(quest.id)} disabled={busy}><FaCalculator /> Calculate</button>
                          <button className={styles.primaryBtn} onClick={() => distributeQuest(quest.id)} disabled={busy}><FaGift /> Distribute</button>
                        </div>
                      </td>
                    </tr>
                  ))}
                  {!quests.length ? <tr><td colSpan="7">No quests yet.</td></tr> : null}
                </tbody>
              </table>
            )}
          </div>
        </section>
      </main>
    </div>
  );
}
