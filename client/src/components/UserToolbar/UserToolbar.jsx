// src/components/UserToolbar/UserToolbar.jsx

import React, { useEffect, useState, useCallback, useMemo } from "react";
import { useNavigate } from "react-router-dom";
import {
  X,
  LayoutGrid,
  ShieldAlert,
  TrendingUp,
  Users,
  Trophy,
  HelpCircle,
  LogOut,
  UserRound,
  Coins,
  Target,
  Volume2,
  VolumeX,
  Bell,
  Shield,
} from "lucide-react";
import styles from "./UserToolbar.module.css";
import { imgUrl } from "../../lib/api";
import { clearAuthSession, getStoredToken } from "../../lib/auth";
import { COPUP_EVENTS } from "../../lib/copupEvents";
import { getUserProfile } from "../../lib/users";
import { getSoundEnabled, setSoundEnabled } from "../../lib/sound";
import {
  canUseWebPush,
  enableWebPushNotifications,
  getWebPushStatus,
} from "../../lib/webPushNotifications";

export default function UserToolbar() {
  const nav = useNavigate();

  // ✅ token must be reactive (not useMemo), so UI updates instantly without refresh
  const [token, setToken] = useState(() => getStoredToken());

  const [open, setOpen] = useState(false);
  const [profile, setProfile] = useState(null);
  const [profileData, setProfileData] = useState(null);
  const [loading, setLoading] = useState(false);
  const [soundOn, setSoundOn] = useState(() => getSoundEnabled());
  const [hideCoins, setHideCoins] = useState(
    () => localStorage.getItem("copup_toolbar_hide_coins") === "1"
  );
  const [hideTasks, setHideTasks] = useState(
    () => localStorage.getItem("copup_toolbar_hide_tasks") === "1"
  );
  const [webPushStatus, setWebPushStatus] = useState(() => getWebPushStatus());
  const [enablingAlerts, setEnablingAlerts] = useState(false);
  const [alertMessage, setAlertMessage] = useState("");

  const displayName = profile?.full_name || profile?.username || "User";
  const role = String(profile?.role || "").toLowerCase();
  const isAffiliate = role === "affiliate";
  const copPoints = Number(profile?.cop_point || 0);
  const joinedHeists = Number(profileData?.stats?.heists?.joined_heists || 0);

  // ✅ IMPORTANT: convert "uploads/xxx.jpg" -> "http://host/uploads/xxx.jpg"
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
    setProfileData(null);
    setOpen(false);

    // ✅ update token state instantly
    setToken(null);

    nav("/login", { replace: true });
  }, [nav]);

  const toggleSound = () => {
    const next = !soundOn;
    setSoundOn(next);
    setSoundEnabled(next);
  };

  const toggleCoins = () => {
    setHideCoins((prev) => {
      const next = !prev;
      localStorage.setItem("copup_toolbar_hide_coins", next ? "1" : "0");
      return next;
    });
  };

  const toggleTasks = () => {
    setHideTasks((prev) => {
      const next = !prev;
      localStorage.setItem("copup_toolbar_hide_tasks", next ? "1" : "0");
      return next;
    });
  };

  const enableBrowserAlerts = async () => {
    setEnablingAlerts(true);
    setAlertMessage("");

    try {
      await enableWebPushNotifications();
      setWebPushStatus("granted");
      setAlertMessage("Browser alerts are on.");
    } catch (err) {
      const nextStatus = getWebPushStatus();
      setWebPushStatus(nextStatus);
      setAlertMessage(err?.message || "Unable to enable browser alerts.");
    } finally {
      setEnablingAlerts(false);
    }
  };

  // ✅ 1) keep token in sync (login/logout in same tab and other tabs)
  useEffect(() => {
    const syncToken = () => setToken(getStoredToken());

    const onStorage = (e) => {
      if (e.key === "token" || e.key === "accessToken") syncToken();
    };

    const onAuthChanged = () => syncToken();

    window.addEventListener("storage", onStorage);
    window.addEventListener(COPUP_EVENTS.AUTH_CHANGED, onAuthChanged);

    return () => {
      window.removeEventListener("storage", onStorage);
      window.removeEventListener(COPUP_EVENTS.AUTH_CHANGED, onAuthChanged);
    };
  }, []);

  // ✅ 2) fetch profile (and reuse it for balance refresh)
  const fetchProfile = useCallback(async () => {
    const t = getStoredToken();
    if (!t) {
      setProfile(null);
      setProfileData(null);
      return;
    }

    setLoading(true);
    try {
      const data = await getUserProfile();
      setProfileData(data);
      setProfile(data?.user || null);
    } catch (err) {
      const code = err?.response?.status;
      if (code === 401 || code === 403) logout();
    } finally {
      setLoading(false);
    }
  }, [logout]);

  // ✅ initial load + when token changes
  useEffect(() => {
    if (!token) return;
    fetchProfile();
  }, [token, fetchProfile]);

  // ✅ 3) listen for balance updates (buy/bid/heist) and refetch immediately
  useEffect(() => {
    const onBalance = () => {
      const cachedCopPoint = localStorage.getItem("copup_cop_point");
      if (cachedCopPoint !== null) {
        setProfile((prev) => ({
          ...(prev || {}),
          cop_point: Number(cachedCopPoint) || 0,
        }));
      }

      // real update from server (source of truth)
      fetchProfile();
    };

    window.addEventListener(COPUP_EVENTS.BALANCE_UPDATED, onBalance);
    return () => window.removeEventListener(COPUP_EVENTS.BALANCE_UPDATED, onBalance);
  }, [fetchProfile]);

  if (!token) return null;

  return (
    <>
      {/* Trigger Button */}
      <div className={styles.toolbarCluster}>
        <button
          type="button"
          className={`${styles.soundBtn} ${soundOn ? styles.soundBtnOn : ""}`}
          onClick={toggleSound}
          aria-label={soundOn ? "Turn background music off" : "Turn background music on"}
          title={soundOn ? "Sound on" : "Sound off"}
        >
          {soundOn ? <Volume2 size={16} /> : <VolumeX size={16} />}
        </button>

        <div className={styles.trigger}>
          <div className={styles.coins}>
            <button
              type="button"
              className={styles.coinBadge}
              onClick={toggleCoins}
              aria-label={hideCoins ? "Show coin balance" : "Hide coin balance"}
              title={hideCoins ? "Show balance" : "Hide balance"}
            >
              <Coins size={14} />
              {hideCoins ? "••••" : copPoints.toLocaleString()}
            </button>

            <button
              type="button"
              className={styles.taskBadge}
              onClick={toggleTasks}
              aria-label={hideTasks ? "Show joined heists" : "Hide joined heists"}
              title={hideTasks ? "Show heists" : "Hide heists"}
            >
              <Target size={14} />
              {hideTasks ? "••" : joinedHeists.toLocaleString()}
            </button>
          </div>

          <button
            type="button"
            className={styles.avatar}
            onClick={() => setOpen(true)}
            aria-label="Open profile menu"
          >
            {profileImageSrc ? (
              <img src={profileImageSrc} alt="Profile" className={styles.avatarImg} />
            ) : (
              <UserRound size={18} />
            )}
          </button>
        </div>
      </div>

      {/* Overlay */}
      <div
        className={`${styles.overlay} ${open ? styles.overlayOpen : ""}`}
        onClick={() => setOpen(false)}
      />

      {/* Drawer */}
      <aside className={`${styles.drawer} ${open ? styles.drawerOpen : ""}`}>
        <div className={styles.drawerTop}>
          <div className={styles.drawerTitle}>Copup Heist</div>
          <button type="button" className={styles.iconBtn} onClick={() => setOpen(false)}>
            <X size={18} />
          </button>
        </div>

        {/* Profile */}
        <div className={styles.profileBlock}>
          <div className={styles.profileAvatar}>
            {profileImageSrc ? (
              <img
                src={profileImageSrc}
                alt="Profile"
                className={styles.profileAvatarImg}
              />
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

          <button className={styles.item} onClick={() => go(isAffiliate ? "/affiliate-dashboard" : "/dashboard")}>
            <LayoutGrid size={16} /> Dashboard
          </button>

          <button className={styles.item} onClick={() => go("/heist")}>
            <ShieldAlert size={16} /> Heist
          </button>

          <button className={styles.item} onClick={() => go("/clans")}>
            <Shield size={16} /> Clans
          </button>

          <button className={styles.item} onClick={() => go("/my-clan")}>
            <Users size={16} /> My Clan
          </button>

          <button className={styles.item} onClick={() => go("/clan-quests")}>
            <Trophy size={16} /> Clan quests
          </button>

          <button className={styles.item} onClick={() => go("/trade")}>
            <TrendingUp size={16} /> Trade
          </button>
        </div>

        <div className={styles.divider} />

        <div className={styles.section}>
          {isAffiliate ? (
            <React.Fragment>
              <button className={styles.item} onClick={() => go("/affiliate-dashboard")}>
                <Target size={16} /> Affiliate
              </button>
            </React.Fragment>
          ) : null}

          <button className={styles.item} onClick={() => go("/referral")}>
            <Users size={16} /> Referral
          </button>

          <button className={styles.item} onClick={() => go("/winners")}>
            <Trophy size={16} /> Winners
          </button>

          <button className={styles.item} onClick={() => go("/how-to-play")}>
            <HelpCircle size={16} /> How to play
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
