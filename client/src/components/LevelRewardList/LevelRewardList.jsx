import React from "react";
import { CheckCircle, Copy, Gift, Ticket } from "lucide-react";
import { formatDate, formatLevelName, formatNumber, getBadgeImage } from "../../lib/levelBadges";
import styles from "./LevelRewardList.module.css";

export default function LevelRewardList({ rewards = [], busyId = "", onClaim, onCopy }) {
  if (!rewards.length) {
    return <div className={styles.empty}>No level rewards yet.</div>;
  }

  return (
    <div className={styles.list}>
      {rewards.map((reward) => {
        const claimed = reward.status !== "earned";
        return (
          <article className={styles.reward} key={reward.id}>
            <img src={getBadgeImage(reward)} alt={formatLevelName(reward)} />
            <div className={styles.info}>
              <div className={styles.top}>
                <strong>{formatLevelName(reward)}</strong>
                <span data-status={reward.status}>{reward.status}</span>
              </div>
              <small>{formatNumber(reward.copup_jr_amount)} CopUp Jr coupon</small>
              <em>{formatDate(reward.earned_at)}</em>
              {claimed ? <code>{reward.code}</code> : null}
            </div>
            <div className={styles.actions}>
              {claimed ? (
                <button type="button" onClick={() => onCopy?.(reward.code)} title="Copy code">
                  <Copy size={15} />
                </button>
              ) : (
                <button
                  type="button"
                  onClick={() => onClaim?.(reward.id)}
                  disabled={busyId === reward.id}
                  title="Claim reward"
                >
                  {busyId === reward.id ? <Ticket size={15} /> : <Gift size={15} />}
                </button>
              )}
              {reward.status === "redeemed" ? <CheckCircle className={styles.done} size={16} /> : null}
            </div>
          </article>
        );
      })}
    </div>
  );
}
