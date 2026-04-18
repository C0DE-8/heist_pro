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
} from "lucide-react";
import styles from "./UserToolbar.module.css";
import { imgUrl } from "../../lib/api";
import { clearAuthSession, getStoredToken } from "../../lib/auth";
import { COPUP_EVENTS } from "../../lib/copupEvents";
import { getUserProfile } from "../../lib/users";
import { getSoundEnabled, setSoundEnabled } from "../../lib/sound";

export default function UserToolbar() {
  const nav = useNavigate();

  // ✅ token must be reactive (not useMemo), so UI updates instantly without refresh
  const [token, setToken] = useState(() => getStoredToken());

  const [open, setOpen] = useState(false);
  const [profile, setProfile] = useState(null);
  const [profileData, setProfileData] = useState(null);
  const [loading, setLoading] = useState(false);
  const [soundOn, setSoundOn] = useState(() => getSoundEnabled());

  const displayName = profile?.full_name || profile?.username || "User";
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

        <button type="button" className={styles.trigger} onClick={() => setOpen(true)}>
          <div className={styles.coins}>
            <div className={styles.coinBadge}>
              <Coins size={14} />
              {copPoints.toLocaleString()}
            </div>

            <div className={styles.taskBadge}>
              <Target size={14} />
              {joinedHeists.toLocaleString()}
            </div>
          </div>

          <div className={styles.avatar}>
            {profileImageSrc ? (
              <img src={profileImageSrc} alt="Profile" className={styles.avatarImg} />
            ) : (
              <UserRound size={18} />
            )}
          </div>
        </button>
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
            <div className={styles.profileMeta}>
              {copPoints.toLocaleString()} CP • {joinedHeists.toLocaleString()} heists
            </div>

            <button className={styles.profileLink} onClick={() => go("/profile")}>
              View profile
            </button>
          </div>
        </div>

        <div className={styles.section}>
          <button className={styles.item} onClick={() => go("/dashboard")}>
            <LayoutGrid size={16} /> Dashboard
          </button>

          <button className={styles.item} onClick={() => go("/heist")}>
            <ShieldAlert size={16} /> Heist
          </button>

          <button className={styles.item} onClick={() => go("/trade")}>
            <TrendingUp size={16} /> Trade
          </button>
        </div>

        <div className={styles.divider} />

        <div className={styles.section}>
          <button className={styles.item} onClick={() => go("/affiliate")}>
            <Users size={16} /> Affiliate
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
