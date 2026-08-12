import React, { useCallback, useEffect, useMemo, useState } from "react";
import { FiAward, FiClock, FiRefreshCw, FiShield, FiUsers } from "react-icons/fi";
import Header from "../../components/Header/Header";
import Footer from "../../components/Footer/Footer";
import { useToast } from "../../components/Toast/ToastContext";
import { imgUrl } from "../../lib/api";
import { getClanQuests, joinClanQuest } from "../../lib/clans";
import styles from "./ClanQuests.module.css";

function formatNum(value) {
  const n = Number(value);
  return Number.isFinite(n) ? n.toLocaleString() : "0";
}

function formatDate(value) {
  if (!value) return "Not set";
  const date = new Date(value);
  return Number.isNaN(date.getTime()) ? "Not set" : date.toLocaleString([], {
    month: "short",
    day: "numeric",
    hour: "numeric",
    minute: "2-digit",
  });
}

function initial(value) {
  return String(value || "C").trim().slice(0, 1).toUpperCase();
}

function QuestSkeleton() {
  return (
    <article className={styles.skeletonQuest}>
      <span />
      <span />
      <span />
    </article>
  );
}

export default function ClanQuests() {
  const toast = useToast();
  const [data, setData] = useState({ quests: [], my_clan: null });
  const [loading, setLoading] = useState(true);
  const [busyQuestId, setBusyQuestId] = useState(null);
  const [error, setError] = useState("");

  const quests = useMemo(() => (Array.isArray(data?.quests) ? data.quests : []), [data?.quests]);
  const myClan = data?.my_clan || null;
  const canJoinQuest = ["leader", "co_leader"].includes(myClan?.role);

  const loadPage = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      setData(await getClanQuests());
    } catch (err) {
      console.error("Clan quests load error:", err);
      setError(err?.response?.data?.message || "Unable to load clan quests.");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadPage();
  }, [loadPage]);

  const summary = useMemo(() => {
    const active = quests.filter((quest) => quest.status === "active").length;
    const totalParticipants = quests.reduce(
      (sum, quest) => sum + Number(quest.participating_clans || 0),
      0
    );
    return { active, totalParticipants };
  }, [quests]);

  const handleJoinQuest = async (questId) => {
    if (!myClan?.clan_id) {
      toast.error("Join or create a clan first.");
      return;
    }
    setBusyQuestId(questId);
    try {
      await joinClanQuest(myClan.clan_id, questId);
      toast.success("Your clan joined the quest.");
      await loadPage();
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to join quest.");
    } finally {
      setBusyQuestId(null);
    }
  };

  return (
    <div className={styles.page}>
      <Header />
      <main className={styles.main}>
        <section className={styles.hero}>
          <div>
            <p className={styles.kicker}>Clan Quests</p>
            <h1>Track the race.</h1>
            <p>
              See every active clan quest, the clans that joined, and the heist wins counted so far.
            </p>
            <div className={styles.pills}>
              <span><FiAward /> {formatNum(summary.active)} active quests</span>
              <span><FiUsers /> {formatNum(summary.totalParticipants)} participating clans</span>
              <span><FiShield /> {myClan ? myClan.clan_name : "No clan yet"}</span>
            </div>
          </div>
          <button type="button" className={styles.iconBtn} onClick={loadPage} aria-label="Refresh clan quests" title="Refresh clan quests">
            <FiRefreshCw />
          </button>
        </section>

        {error ? <div className={styles.error}>{error}</div> : null}

        <section className={styles.questList}>
          {loading ? (
            [0, 1, 2].map((item) => <QuestSkeleton key={item} />)
          ) : quests.length ? (
            quests.map((quest) => {
              const participants = Array.isArray(quest.participants) ? quest.participants : [];
              const alreadyJoined = participants.some(
                (item) => Number(item.clan_id) === Number(myClan?.clan_id)
              );
              return (
                <article className={styles.questCard} key={quest.id}>
                  <div className={styles.questTop}>
                    <div>
                      <div className={styles.status}>{quest.status}</div>
                      <h2>{quest.title}</h2>
                      <p>{quest.description || "No quest description yet."}</p>
                    </div>
                    <div className={styles.prizeBox}>
                      <strong>{formatNum(quest.prize_amount)} CP</strong>
                      <span>Prize</span>
                    </div>
                  </div>

                  <div className={styles.questMeta}>
                    <span><FiClock /> Starts {formatDate(quest.starts_at)}</span>
                    <span><FiClock /> Ends {formatDate(quest.ends_at)}</span>
                    <span><FiUsers /> {formatNum(quest.participating_clans)} clans joined</span>
                  </div>

                  {canJoinQuest && ["scheduled", "active"].includes(quest.status) && !alreadyJoined ? (
                    <button
                      type="button"
                      className={styles.joinBtn}
                      onClick={() => handleJoinQuest(quest.id)}
                      disabled={busyQuestId === quest.id}
                    >
                      Join quest with {myClan.clan_name}
                    </button>
                  ) : null}

                  <div className={styles.board}>
                    <div className={styles.boardHead}>
                      <strong>Participating clans</strong>
                      <span>Wins so far</span>
                    </div>
                    {participants.length ? (
                      participants.map((clan) => (
                        <div className={styles.clanRow} key={`${quest.id}-${clan.clan_id}`}>
                          <div className={styles.rank}>#{clan.rank}</div>
                          <div className={styles.logo}>
                            {clan.logo_url ? <img src={imgUrl(clan.logo_url)} alt="" /> : initial(clan.name)}
                          </div>
                          <div className={styles.clanInfo}>
                            <strong>{clan.name}</strong>
                            <span>
                              {formatNum(clan.member_count)} members · Leader{" "}
                              {clan.leader_full_name || clan.leader_username || "Unavailable"}
                            </span>
                          </div>
                          <div className={styles.wins}>
                            <strong>{formatNum(clan.wins_so_far)}</strong>
                            <span>wins</span>
                          </div>
                        </div>
                      ))
                    ) : (
                      <div className={styles.empty}>No clans have joined this quest yet.</div>
                    )}
                  </div>
                </article>
              );
            })
          ) : (
            <div className={styles.empty}>No clan quests are available yet.</div>
          )}
        </section>
      </main>
      <Footer />
    </div>
  );
}
