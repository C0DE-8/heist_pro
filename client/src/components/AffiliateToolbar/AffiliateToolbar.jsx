import React, { useCallback, useEffect, useMemo, useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  BookOpen,
  Bell,
  Coins,
  LayoutGrid,
  LogOut,
  Target,
  TrendingUp,
  UserRound,
  Users,
  Volume2,
  VolumeX,
  X,
} from "lucide-react";
import styles from "../UserToolbar/UserToolbar.module.css";
import { imgUrl } from "../../lib/api";
import { clearAuthSession, getStoredToken } from "../../lib/auth";
import { COPUP_EVENTS } from "../../lib/copupEvents";
import { getSoundEnabled, setSoundEnabled } from "../../lib/sound";
import { getUserProfile } from "../../lib/users";
import {
  canUseWebPush,
  enableWebPushNotifications,
  getWebPushStatus,
} from "../../lib/webPushNotifications";

export default function AffiliateToolbar() {
  const nav = useNavigate();
  const [token, setToken] = useState(() => getStoredToken());
  const [open, setOpen] = useState(false);
  const [profile, setProfile] = useState(null);
  const [loading, setLoading] = useState(false);
  const [soundOn, setSoundOn] = useState(() => getSoundEnabled());
  const [hideCoins, setHideCoins] = useState(
    () => localStorage.getItem("copup_toolbar_hide_coins") === "1"
  );
  const [webPushStatus, setWebPushStatus] = useState(() => getWebPushStatus());
  const [enablingAlerts, setEnablingAlerts] = useState(false);
  const [alertMessage, setAlertMessage] = useState("");

  const displayName = profile?.full_name || profile?.username || "Affiliate";
  const copPoints = Number(profile?.cop_point || 0);
  const profileImageSrc = useMemo(() => {
    const p = profile?.profile;
    return p ? imgUrl(p) : "";
  }, [profile?.profile]);

  const go = (path) => {
    setOpen(false);
    nav(path);
  };

  const logout = useCallback(() => {
    clearAuthSession();
    setProfile(null);
    setOpen(false);
    setToken(null);
    nav("/login", { replace: true });
  }, [nav]);

  const enableBrowserAlerts = async () => {
    setEnablingAlerts(true);
    setAlertMessage("");

    try {
      await enableWebPushNotifications();
      setWebPushStatus("granted");
      setAlertMessage("Browser alerts are on.");
    } catch (err) {
      setWebPushStatus(getWebPushStatus());
      setAlertMessage(err?.message || "Unable to enable browser alerts.");
    } finally {
      setEnablingAlerts(false);
    }
  };

  const fetchProfile = useCallback(async () => {
    const t = getStoredToken();
    if (!t) {
      setProfile(null);
      return;
    }

    setLoading(true);
    try {
      const data = await getUserProfile();
      setProfile(data?.user || null);
    } catch (err) {
      const code = err?.response?.status;
      if (code === 401 || code === 403) logout();
    } finally {
      setLoading(false);
    }
  }, [logout]);

  useEffect(() => {
    const syncToken = () => setToken(getStoredToken());
    const onStorage = (event) => {
      if (event.key === "token" || event.key === "accessToken") syncToken();
    };
    window.addEventListener("storage", onStorage);
    window.addEventListener(COPUP_EVENTS.AUTH_CHANGED, syncToken);
    return () => {
      window.removeEventListener("storage", onStorage);
      window.removeEventListener(COPUP_EVENTS.AUTH_CHANGED, syncToken);
    };
  }, []);

  useEffect(() => {
    if (!token) return;
    fetchProfile();
  }, [token, fetchProfile]);

  useEffect(() => {
    const onBalance = () => {
      const cachedCopPoint = localStorage.getItem("copup_cop_point");
      if (cachedCopPoint !== null) {
        setProfile((prev) => ({
          ...(prev || {}),
          cop_point: Number(cachedCopPoint) || 0,
        }));
      }
      fetchProfile();
    };

    window.addEventListener(COPUP_EVENTS.BALANCE_UPDATED, onBalance);
    return () => window.removeEventListener(COPUP_EVENTS.BALANCE_UPDATED, onBalance);
  }, [fetchProfile]);

  if (!token) return null;

  return (
    <>
      <div className={styles.toolbarCluster}>
        <button
          type="button"
          className={`${styles.soundBtn} ${soundOn ? styles.soundBtnOn : ""}`}
          onClick={() => {
            const next = !soundOn;
            setSoundOn(next);
            setSoundEnabled(next);
          }}
          aria-label={soundOn ? "Turn background music off" : "Turn background music on"}
        >
          {soundOn ? <Volume2 size={16} /> : <VolumeX size={16} />}
        </button>

        <div className={styles.trigger}>
          <div className={styles.coins}>
            <button
              type="button"
              className={styles.coinBadge}
              onClick={() => {
                setHideCoins((prev) => {
                  const next = !prev;
                  localStorage.setItem("copup_toolbar_hide_coins", next ? "1" : "0");
                  return next;
                });
              }}
            >
              <Coins size={14} />
              {hideCoins ? "••••" : copPoints.toLocaleString()}
            </button>
          </div>

          <button
            type="button"
            className={styles.avatar}
            onClick={() => setOpen(true)}
            aria-label="Open affiliate menu"
          >
            {profileImageSrc ? (
              <img src={profileImageSrc} alt="Profile" className={styles.avatarImg} />
            ) : (
              <UserRound size={18} />
            )}
          </button>
        </div>
      </div>

      <div
        className={`${styles.overlay} ${open ? styles.overlayOpen : ""}`}
        onClick={() => setOpen(false)}
      />

      <aside className={`${styles.drawer} ${open ? styles.drawerOpen : ""}`}>
        <div className={styles.drawerTop}>
          <div className={styles.drawerTitle}>Affiliate Hub</div>
          <button type="button" className={styles.iconBtn} onClick={() => setOpen(false)}>
            <X size={18} />
          </button>
        </div>

        <div className={styles.profileBlock}>
          <div className={styles.profileAvatar}>
            {profileImageSrc ? (
              <img src={profileImageSrc} alt="Profile" className={styles.profileAvatarImg} />
            ) : (
              <UserRound size={18} />
            )}
          </div>

          <div className={styles.profileText}>
            <div className={styles.profileName}>{loading ? "Loading..." : displayName}</div>
            <button className={styles.profileLink} onClick={() => go("/profile")}>
              View profile
            </button>
          </div>
        </div>

        <div className={styles.section}>
          <button
            className={styles.item}
            onClick={enableBrowserAlerts}
            disabled={enablingAlerts || webPushStatus === "granted" || !canUseWebPush()}
            title={
              webPushStatus === "unsupported"
                ? "This browser does not support web push alerts"
                : webPushStatus === "not_configured"
                  ? "Firebase web push is not configured"
                  : "Enable browser alerts"
            }
          >
            <Bell size={16} />
            {webPushStatus === "granted"
              ? "Alerts enabled"
              : enablingAlerts
                ? "Enabling alerts..."
                : "Enable alerts"}
          </button>

          {alertMessage ? <p className={styles.alertHint}>{alertMessage}</p> : null}

          <button className={styles.item} onClick={() => go("/affiliate-dashboard")}>
            <LayoutGrid size={16} /> Dashboard
          </button>
          <button className={styles.item} onClick={() => go("/affiliate/plans")}>
            <Target size={16} /> Plans
          </button>
          <button className={styles.item} onClick={() => go("/affiliate/referral")}>
            <Users size={16} /> Referral
          </button>
          <button className={styles.item} onClick={() => go("/affiliate/trade")}>
            <TrendingUp size={16} /> Trade
          </button>
          <button className={styles.item} onClick={() => go("/affiliate/how-it-works")}>
            <BookOpen size={16} /> How it works
          </button>
        </div>

        <div className={styles.divider} />

        <div className={styles.section}>
          <button className={styles.item} onClick={() => go("/account")}>
            <Coins size={16} /> Wallet
          </button>
        </div>

        <div className={styles.drawerBottom}>
          <button className={styles.logoutBtn} onClick={logout}>
            <LogOut size={16} />
            Logout
          </button>
        </div>
      </aside>
    </>
  );
}
