import React from "react";
import { Lock, Unlock } from "lucide-react";
import { formatLevelName, formatNumber, getBadgeImage } from "../../lib/levelBadges";
import styles from "./BadgeLevelCard.module.css";

export default function BadgeLevelCard({ level, currentOrder = 1 }) {
  const levelOrder = Number(level?.level_order || 0);
  const unlocked = levelOrder <= Number(currentOrder || 0);
  const active = levelOrder === Number(currentOrder || 0);

  return (
    <article className={`${styles.card} ${unlocked ? styles.unlocked : ""} ${active ? styles.active : ""}`}>
      <img src={getBadgeImage(level)} alt={formatLevelName(level)} className={styles.image} />
      <div className={styles.body}>
        <div className={styles.titleRow}>
          <strong>{formatLevelName(level)}</strong>
          <span>{unlocked ? <Unlock size={14} /> : <Lock size={14} />}</span>
        </div>
        <small>{formatNumber(level?.xp_required)} XP required</small>
        <em>{formatNumber(level?.coupon_copup_jr_amount)} CopUp Jr reward</em>
      </div>
    </article>
  );
}
