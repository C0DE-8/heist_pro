import React from "react";
import { FaRedoAlt } from "react-icons/fa";
import styles from "./AdminPageHeader.module.css";

export default function AdminPageHeader({
  kicker,
  title,
  description,
  onRefresh,
  refreshing = false,
  refreshLabel = "Refresh",
  refreshingLabel = "Refreshing...",
  error = "",
  onRetry,
}) {
  return (
    <>
      <section className={styles.hero}>
        <div>
          {kicker ? <p className={styles.kicker}>{kicker}</p> : null}
          {title ? <h1>{title}</h1> : null}
          {description ? <p className={styles.description}>{description}</p> : null}
        </div>

        {onRefresh ? (
          <button
            type="button"
            className={styles.refreshBtn}
            onClick={onRefresh}
            disabled={refreshing}
          >
            <FaRedoAlt />
            <span>{refreshing ? refreshingLabel : refreshLabel}</span>
          </button>
        ) : null}
      </section>

      {error ? (
        <div className={styles.errorBox}>
          <span>{error}</span>
          {onRetry ? (
            <button type="button" onClick={onRetry}>
              Retry
            </button>
          ) : null}
        </div>
      ) : null}
    </>
  );
}
