import React, { useState } from "react";
import { CalendarCheck, Clock, Sparkles } from "lucide-react";
import { claimDailyCheckIn } from "../../lib/levels";
import { formatNumber } from "../../lib/levelBadges";
import styles from "./DailyCheckInPrompt.module.css";

function formatNext(value) {
  if (!value) return "tomorrow";
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "tomorrow";
  return date.toLocaleDateString([], {
    month: "short",
    day: "numeric",
  });
}

export default function DailyCheckInPrompt({ checkIn, onClaimed }) {
  const [claiming, setClaiming] = useState(false);
  const [claimed, setClaimed] = useState(false);
  const [error, setError] = useState("");

  if (!checkIn?.eligible && !claimed) return null;

  const claim = async () => {
    if (claiming) return;
    setClaiming(true);
    setError("");
    try {
      const data = await claimDailyCheckIn();
      setClaimed(true);
      onClaimed?.(data);
    } catch (err) {
      setError(err?.response?.data?.message || "Unable to claim daily check-in.");
    } finally {
      setClaiming(false);
    }
  };

  if (claimed) {
    return (
      <section className={`${styles.card} ${styles.claimed}`}>
        <span className={styles.icon}>
          <Clock size={18} />
        </span>
        <div>
          <strong>Checked in today</strong>
          <small>Check in tomorrow for more XP.</small>
        </div>
      </section>
    );
  }

  return (
    <section className={styles.card}>
      <span className={styles.icon}>
        <CalendarCheck size={18} />
      </span>
      <div className={styles.copy}>
        <strong>Daily check-in available</strong>
        <small>
          {error || `Claim ${formatNumber(checkIn.xp_amount)} XP today. Next check-in opens ${formatNext(checkIn.next_check_in_at)}.`}
        </small>
      </div>
      <button type="button" onClick={claim} disabled={claiming}>
        <Sparkles size={16} />
        <span>{claiming ? "Claiming" : "Claim"}</span>
      </button>
    </section>
  );
}
