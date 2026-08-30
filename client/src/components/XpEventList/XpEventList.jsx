import React from "react";
import { CalendarCheck, CircleDollarSign, ShieldCheck, Trophy, UserPlus, Wallet } from "lucide-react";
import { formatDate, formatNumber } from "../../lib/levelBadges";
import styles from "./XpEventList.module.css";

const SOURCE_LABELS = {
  daily_login: "Daily check-in",
  heist_play: "Heist played",
  heist_win: "Heist won",
  referral_signup: "Referral reward",
  deposit: "Deposit",
  withdrawal: "Withdrawal",
  admin_adjustment: "Admin adjustment",
};

function sourceIcon(source) {
  if (source === "daily_login") return <CalendarCheck size={16} />;
  if (source === "heist_win") return <Trophy size={16} />;
  if (source === "heist_play") return <ShieldCheck size={16} />;
  if (source === "referral_signup") return <UserPlus size={16} />;
  if (source === "deposit") return <CircleDollarSign size={16} />;
  if (source === "withdrawal") return <Wallet size={16} />;
  return <ShieldCheck size={16} />;
}

export default function XpEventList({ events = [] }) {
  if (!events.length) {
    return <div className={styles.empty}>No XP activity yet.</div>;
  }

  return (
    <div className={styles.list}>
      {events.map((event) => (
        <article className={styles.row} key={event.id}>
          <span className={styles.icon}>{sourceIcon(event.source)}</span>
          <div>
            <strong>{SOURCE_LABELS[event.source] || event.source}</strong>
            <small>{formatDate(event.created_at)}</small>
          </div>
          <em>{formatNumber(event.xp_amount)} XP</em>
        </article>
      ))}
    </div>
  );
}
