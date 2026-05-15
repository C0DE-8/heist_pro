import React from "react";
import { FiEye, FiLock, FiPlay, FiPlus } from "react-icons/fi";
import styles from "./HeistCard.module.css";

const DEFAULT_HEIST_IMAGE = "/assets/m2-foods.png";
const JOIN_LOCK_BEFORE_END_MS = 2 * 60 * 1000;

function formatNum(value) {
  const n = Number(value);
  return Number.isFinite(n) ? n.toLocaleString() : "0";
}

function isJoinTimeLocked(heist) {
  const endTime = heist?.countdown_ends_at || heist?.ends_at;
  if (!endTime) return false;

  const endMs = new Date(endTime).getTime();
  return Number.isFinite(endMs) && endMs - Date.now() <= JOIN_LOCK_BEFORE_END_MS;
}

function getHeistUiState(heist, isLocked) {
  const hasSubmitted =
    Number(heist?.has_submitted) === 1 ||
    heist?.has_submitted === true ||
    heist?.participant_status === "submitted";
  const hasJoined =
    hasSubmitted ||
    Number(heist?.has_joined) === 1 ||
    heist?.has_joined === true ||
    heist?.participant_status === "joined";

  if (hasSubmitted) {
    return {
      label: "View",
      stateLabel: "Played",
      icon: FiEye,
      tone: styles.viewState,
    };
  }

  if (hasJoined) {
    return {
      label: "Play",
      stateLabel: "Joined",
      icon: FiPlay,
      tone: styles.playState,
    };
  }

  if (isLocked) {
    return {
      label: "Locked",
      stateLabel: "Locked",
      icon: FiLock,
      tone: styles.fullState,
      disabled: true,
    };
  }

  return {
    label: "Join",
    stateLabel: "Join first",
    icon: FiPlus,
    tone: styles.joinState,
  };
}

export default function HeistCard({ heist, onAction, isBusy }) {
  const imageSrc = heist?.image || DEFAULT_HEIST_IMAGE;
  const title = heist?.name || "Heist";
  const totalParticipants = Number(heist?.total_participants || 0);
  const maxUsers = Number(heist?.max_users || 0);
  const hasMaxUsers = maxUsers > 0;
  const isFull = hasMaxUsers && totalParticipants >= maxUsers;
  const isLocked = isFull || isJoinTimeLocked(heist);
  const description =
    heist?.description || "Answer true or false questions, beat the clock, and climb the ranks.";
  const action = getHeistUiState(heist, isLocked);
  const ActionIcon = action.icon;

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
          <span className={`${styles.userState} ${action.tone}`}>{action.stateLabel}</span>
        </div>

        <div className={styles.middle}>
          <h3>{title}</h3>
          <p>{description}</p>
        </div>

        <div className={styles.bottom}>
          <div className={styles.moneyStack}>
            <div className={styles.prize}>
              <span>Prize</span>
              <strong>{formatNum(heist?.prize_cop_points)} CP</strong>
            </div>
            <div className={styles.entryFee}>
              <span>Entry fee</span>
              <strong>{formatNum(heist?.ticket_price)} CP</strong>
            </div>
          </div>

          <button
            type="button"
            className={styles.button}
            onClick={() => onAction?.(heist)}
            disabled={isBusy || action.disabled}
          >
            <ActionIcon />
            <span>{isBusy ? "Please wait" : action.label}</span>
          </button>
        </div>
      </div>
    </article>
  );
}
