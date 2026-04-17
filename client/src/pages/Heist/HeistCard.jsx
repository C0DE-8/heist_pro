import React from "react";
import { FiPlay } from "react-icons/fi";
import styles from "./HeistCard.module.css";

const DEFAULT_HEIST_IMAGE = "/assets/m2-foods.png";

function formatNum(value) {
  const n = Number(value);
  return Number.isFinite(n) ? n.toLocaleString() : "0";
}

export default function HeistCard({ heist, onJoin }) {
  const imageSrc = heist?.image || DEFAULT_HEIST_IMAGE;
  const title = heist?.name || "Heist";
  const participantTarget = Math.max(0, Number(heist?.min_users || 0) - 1);
  const description =
    heist?.description || "Answer true or false questions, beat the clock, and climb the ranks.";

  const handleImageError = (event) => {
    if (event.currentTarget.src.endsWith(DEFAULT_HEIST_IMAGE)) return;
    event.currentTarget.src = DEFAULT_HEIST_IMAGE;
  };

  return (
    <article className={styles.card}>
      <img
        className={styles.image}
        src={imageSrc}
        alt=""
        loading="lazy"
        onError={handleImageError}
      />
      <div className={styles.scrim} />

      <div className={styles.content}>
        <div className={styles.topRow}>
          <span className={styles.status}>{heist?.status || "pending"}</span>
          <span className={styles.participants}>
            <strong>{formatNum(participantTarget)}</strong>
            <span>min users</span>
          </span>
        </div>

        <div className={styles.middle}>
          <h3>{title}</h3>
          <p>{description}</p>
        </div>

        <div className={styles.bottom}>
          <div className={styles.prize}>
            <span>Prize</span>
            <strong>{formatNum(heist?.prize_cop_points)} CP</strong>
          </div>

          <button type="button" className={styles.button} onClick={() => onJoin?.(heist)}>
            <FiPlay />
            <span>Join / Play</span>
          </button>
        </div>
      </div>
    </article>
  );
}
