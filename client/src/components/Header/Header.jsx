import React, { useCallback, useEffect, useMemo, useState } from "react";
import styles from "./Header.module.css";
import coinImg from "../../assets/copupcoin.png";
import UserToolbar from "../UserToolbar/UserToolbar";
import { Bell, CheckCheck, Clock, Coins, Trophy, X } from "lucide-react";
import { COPUP_EVENTS } from "../../lib/copupEvents";
import { getUserHeistAlerts } from "../../lib/users";

const DISMISSED_ALERTS_KEY = "copup_heist_alerts_dismissed";
const WIN_POPUPS_KEY = "copup_heist_win_popups_seen";

function readStoredIds(key) {
  try {
    const parsed = JSON.parse(localStorage.getItem(key) || "[]");
    return new Set(Array.isArray(parsed) ? parsed : []);
  } catch {
    return new Set();
  }
}

function writeStoredIds(key, ids) {
  localStorage.setItem(key, JSON.stringify([...ids]));
}

function formatCoins(value) {
  return Number(value || 0).toLocaleString();
}

function formatAlertTime(value) {
  if (!value) return "";
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "";
  return date.toLocaleString(undefined, {
    month: "short",
    day: "numeric",
    hour: "numeric",
    minute: "2-digit",
  });
}

export default function Header() {
  const [token, setToken] = useState(() => localStorage.getItem("token"));
  const [alerts, setAlerts] = useState([]);
  const [alertsOpen, setAlertsOpen] = useState(false);
  const [winnerPopup, setWinnerPopup] = useState(null);
  const [dismissedAlerts, setDismissedAlerts] = useState(() => readStoredIds(DISMISSED_ALERTS_KEY));

  const unreadAlerts = useMemo(
    () => alerts.filter((alert) => !dismissedAlerts.has(alert.id)),
    [alerts, dismissedAlerts]
  );

  const unreadCount = unreadAlerts.length;

  const rememberId = useCallback((key, id) => {
    if (!id) return;
    const ids = readStoredIds(key);
    ids.add(id);
    writeStoredIds(key, ids);
    if (key === DISMISSED_ALERTS_KEY) setDismissedAlerts(new Set(ids));
  }, []);

  const fetchAlerts = useCallback(async () => {
    if (!localStorage.getItem("token")) {
      setAlerts([]);
      setAlertsOpen(false);
      setWinnerPopup(null);
      return;
    }

    try {
      const nextAlerts = await getUserHeistAlerts();
      setAlerts(nextAlerts);

      const seenWinnerPopups = readStoredIds(WIN_POPUPS_KEY);
      const nextWinnerPopup = nextAlerts.find(
        (alert) => alert.type === "winner" && !seenWinnerPopups.has(alert.id)
      );
      if (nextWinnerPopup) setWinnerPopup(nextWinnerPopup);
    } catch (err) {
      if (err?.response?.status === 401 || err?.response?.status === 403) {
        setAlerts([]);
        setAlertsOpen(false);
        setWinnerPopup(null);
      }
    }
  }, []);

  const markAlertRead = (id) => {
    rememberId(DISMISSED_ALERTS_KEY, id);
  };

  const markAllRead = () => {
    const ids = new Set(dismissedAlerts);
    alerts.forEach((alert) => ids.add(alert.id));
    writeStoredIds(DISMISSED_ALERTS_KEY, ids);
    setDismissedAlerts(ids);
  };

  const closeWinnerPopup = () => {
    if (winnerPopup?.id) {
      rememberId(WIN_POPUPS_KEY, winnerPopup.id);
      rememberId(DISMISSED_ALERTS_KEY, winnerPopup.id);
    }
    setWinnerPopup(null);
  };

  useEffect(() => {
    const syncToken = () => {
      const nextToken = localStorage.getItem("token");
      setToken(nextToken);
      if (!nextToken) {
        setAlerts([]);
        setAlertsOpen(false);
        setWinnerPopup(null);
      }
    };

    // ✅ When other tabs change storage
    const onStorage = (e) => {
      if (e.key === "token") syncToken();
    };

    // ✅ When our app changes auth (login/logout)
    const onAuthChanged = () => syncToken();

    window.addEventListener("storage", onStorage);
    window.addEventListener(COPUP_EVENTS.AUTH_CHANGED, onAuthChanged);

    return () => {
      window.removeEventListener("storage", onStorage);
      window.removeEventListener(COPUP_EVENTS.AUTH_CHANGED, onAuthChanged);
    };
  }, []);

  useEffect(() => {
    if (!token) return undefined;

    const immediate = window.setTimeout(fetchAlerts, 0);
    const timer = window.setInterval(fetchAlerts, 30000);
    return () => {
      window.clearTimeout(immediate);
      window.clearInterval(timer);
    };
  }, [token, fetchAlerts]);

  return (
    <header className={styles.header}>
      <div className={styles.inner}>
        <a href="/" className={styles.brand} aria-label="CopUpBid Home">
          <img src={coinImg} alt="CopUpCoin" className={styles.logo} />
          <div className={styles.brandText}>
            <div className={styles.title}>CopUpBid</div>
            <div className={styles.sub}>Shop • Buy with CopUpCoin</div>
          </div>
        </a>

        <nav className={styles.actions} aria-label="Header actions">
          {token ? (
            <>
              <div className={styles.alertWrap}>
                <button
                  type="button"
                  className={`${styles.alertBtn} ${unreadCount ? styles.alertBtnActive : ""}`}
                  onClick={() => setAlertsOpen((open) => !open)}
                  aria-label="Open alerts"
                  title="Alerts"
                >
                  <Bell size={17} />
                  {unreadCount ? <span className={styles.alertCount}>{unreadCount}</span> : null}
                </button>

                {alertsOpen ? (
                  <div className={styles.alertPanel}>
                    <div className={styles.alertPanelTop}>
                      <strong>Alerts</strong>
                      <button type="button" onClick={markAllRead} disabled={!unreadAlerts.length}>
                        <CheckCheck size={14} />
                        Read
                      </button>
                    </div>

                    <div className={styles.alertList}>
                      {unreadAlerts.length ? (
                        unreadAlerts.map((alert) => {
                          const isWinner = alert.type === "winner";
                          const isTrade = alert.type === "trade_received";
                          return (
                            <button
                              type="button"
                              key={alert.id}
                              className={`${styles.alertItem} ${styles.alertItemUnread}`}
                              onClick={() => markAlertRead(alert.id)}
                            >
                              <span className={styles.alertIcon}>
                                {isWinner ? (
                                  <Trophy size={16} />
                                ) : isTrade ? (
                                  <Coins size={16} />
                                ) : (
                                  <Clock size={16} />
                                )}
                              </span>
                              <span className={styles.alertText}>
                                <strong>{alert.title}</strong>
                                <small>
                                  {isWinner
                                    ? `${formatCoins(alert.prize_cop_points)} CopUpCoin won`
                                    : isTrade
                                      ? `${formatCoins(alert.cop_points)} CopUpCoin from ${alert.sender_name || "a user"}`
                                    : alert.message}
                                </small>
                                <em>{formatAlertTime(alert.created_at)}</em>
                              </span>
                            </button>
                          );
                        })
                      ) : (
                        <div className={styles.emptyAlerts}>No unread alerts.</div>
                      )}
                    </div>
                  </div>
                ) : null}
              </div>
              <UserToolbar />
            </>
          ) : (
            <>
              <a className={styles.loginBtn} href="/login">
                Login
              </a>
              <a className={styles.joinBtn} href="/register">
                Join
              </a>
            </>
          )}
        </nav>
      </div>

      {winnerPopup ? (
        <div className={styles.winOverlay} role="dialog" aria-modal="true" aria-label="Heist win">
          <div className={styles.winPopup}>
            <button
              type="button"
              className={styles.winClose}
              onClick={closeWinnerPopup}
              aria-label="Close win alert"
            >
              <X size={18} />
            </button>
            <div className={styles.winIcon}>
              <Trophy size={30} />
            </div>
            <p>You won the heist</p>
            <h2>{winnerPopup.heist_name}</h2>
            <strong>{formatCoins(winnerPopup.prize_cop_points)} CopUpCoin</strong>
            <button type="button" className={styles.winBtn} onClick={closeWinnerPopup}>
              Got it
            </button>
          </div>
        </div>
      ) : null}
    </header>
  );
}
