import React from "react";
import { ChevronRight, Gift } from "lucide-react";
import { formatLevelName, formatNumber, getBadgeImage } from "../../lib/levelBadges";
import styles from "./LevelProgressBar.module.css";

export default function LevelProgressBar({ progress, compact = false, onRewards, onLevels }) {
  const currentLevel = progress?.current_level;
  const nextLevel = progress?.next_level;
  const percent = Math.max(0, Math.min(100, Number(progress?.progress_percent || 0)));
  const rewardCount = Number(progress?.unclaimed_reward_count || 0);

  return (
    <section className={`${styles.card} ${compact ? styles.compact : ""}`}>
      <div className={styles.top}>
        <img
          src={getBadgeImage(currentLevel)}
          alt={formatLevelName(currentLevel)}
          className={styles.badge}
        />
        <div className={styles.meta}>
          <span>Level rank</span>
          <strong>{formatLevelName(currentLevel)}</strong>
          <small>{formatNumber(progress?.total_xp)} XP earned</small>
        </div>
        {rewardCount ? (
          <button type="button" className={styles.rewardBtn} onClick={onRewards}>
            <Gift size={16} />
            <span>{rewardCount}</span>
          </button>
        ) : null}
      </div>

      <div className={styles.trackWrap}>
        <div className={styles.track} aria-label={`${percent}% to next level`}>
          <span style={{ width: `${percent}%` }} />
        </div>
        <div className={styles.trackText}>
          <span>{percent}%</span>
          <span>
            {nextLevel
              ? `${formatNumber(progress?.xp_to_next_level)} XP to ${formatLevelName(nextLevel)}`
              : "Max level"}
          </span>
        </div>
      </div>

      <div className={styles.actions}>
        <button type="button" onClick={onLevels}>
          <span>View levels</span>
          <ChevronRight size={16} />
        </button>
        <button type="button" onClick={onRewards}>
          <span>Rewards</span>
          <ChevronRight size={16} />
        </button>
      </div>
    </section>
  );
}
