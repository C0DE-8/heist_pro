import React, { useCallback, useEffect, useMemo, useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  FiArrowLeft,
  FiAward,
  FiChevronLeft,
  FiChevronRight,
  FiCheckCircle,
  FiCopy,
  FiEdit3,
  FiRefreshCw,
  FiRepeat,
  FiShield,
  FiTarget,
  FiUser,
  FiUsers,
} from "react-icons/fi";
import Header from "../../components/Header/Header";
import Footer from "../../components/Footer/Footer";
import { useToast } from "../../components/Toast/ToastContext";
import { getUserProfile, switchUserMode, updateUserPassword, updateUserProfile } from "../../lib/users";
import styles from "./Profile.module.css";

function formatNum(value) {
  const n = Number(value);
  return Number.isFinite(n) ? n.toLocaleString() : "0";
}

function formatPercent(value) {
  const n = Number(value);
  return Number.isFinite(n) ? `${n.toFixed(1)}%` : "0.0%";
}

function formatDate(value) {
  if (!value) return "Not available";
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "Not available";
  return date.toLocaleString([], {
    month: "short",
    day: "numeric",
    year: "numeric",
    hour: "numeric",
    minute: "2-digit",
  });
}

function shortText(value, start = 10, end = 6) {
  const text = String(value || "");
  if (!text) return "Not assigned";
  if (text.length <= start + end + 3) return text;
  return `${text.slice(0, start)}...${text.slice(-end)}`;
}

function makeInitials(user) {
  const source = user?.full_name || user?.username || user?.email || "User";
  return source
    .split(/\s+/)
    .filter(Boolean)
    .slice(0, 2)
    .map((part) => part[0])
    .join("")
    .toUpperCase();
}

export default function Profile() {
  const navigate = useNavigate();
  const toast = useToast();

  const [profileData, setProfileData] = useState(null);
  const [form, setForm] = useState({ username: "", full_name: "", email: "" });
  const [passwordForm, setPasswordForm] = useState({
    current_password: "",
    new_password: "",
    confirm_password: "",
  });
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [passwordSaving, setPasswordSaving] = useState(false);
  const [modeSaving, setModeSaving] = useState(false);
  const [activeSettingsSlide, setActiveSettingsSlide] = useState(0);
  const [activeProfileSlide, setActiveProfileSlide] = useState(0);
  const [error, setError] = useState("");
  const [copied, setCopied] = useState("");

  const user = profileData?.user || null;
  const isAffiliate = String(user?.role || "").toLowerCase() === "affiliate";
  const stats = profileData?.stats || {};
  const heistStats = stats.heists || {};
  const submissionStats = stats.submissions || {};
  const affiliateStats = stats.affiliate || {};
  const taskStats = stats.affiliate_tasks || {};
  const recentHeists = Array.isArray(profileData?.recent_heists)
    ? profileData.recent_heists
    : [];
  const affiliateProgress = Array.isArray(profileData?.affiliate_task_progress)
    ? profileData.affiliate_task_progress
    : [];

  const initials = useMemo(() => makeInitials(user), [user]);
  const isDirty = Boolean(
    user &&
      (form.username !== (user.username || "") ||
        form.full_name !== (user.full_name || "") ||
        form.email !== (user.email || ""))
  );
  const passwordDirty = Boolean(
    passwordForm.current_password || passwordForm.new_password || passwordForm.confirm_password
  );

  const profileSlides = [
    {
      key: "identity",
      label: "Identity",
      eyebrow: "Account",
      title: "Identity and wallet",
      icon: <FiUser />,
      content: (
        <React.Fragment>
          <div className={styles.infoList}>
            <div>
              <span>Role</span>
              <strong>{user?.role || "user"}</strong>
            </div>
            <div>
              <span>Game ID</span>
              <strong>{user?.game_id || "Not assigned"}</strong>
            </div>
            {isAffiliate ? (
              <div>
                <span>Referral code</span>
                <button
                  type="button"
                  onClick={() => copyValue("Referral code", user?.referral_code)}
                  disabled={!user?.referral_code}
                >
                  <strong>{user?.referral_code || "Not assigned"}</strong>
                  <FiCopy />
                </button>
              </div>
            ) : null}
            <div>
              <span>Wallet</span>
              <button
                type="button"
                onClick={() => copyValue("Wallet", user?.wallet_address)}
                disabled={!user?.wallet_address}
              >
                <strong>{shortText(user?.wallet_address)}</strong>
                <FiCopy />
              </button>
            </div>
            <div>
              <span>Joined</span>
              <strong>{formatDate(user?.created_at)}</strong>
            </div>
          </div>

          {copied ? <p className={styles.notice}>{copied} copied</p> : null}
        </React.Fragment>
      ),
    },
    {
      key: "performance",
      label: "Record",
      eyebrow: "Performance",
      title: "Heist record",
      icon: <FiAward />,
      content: (
        <div className={styles.scoreGrid}>
          <div>
            <span>Total submissions</span>
            <strong>{formatNum(submissionStats.total_submissions)}</strong>
          </div>
          <div>
            <span>Best correct</span>
            <strong>{formatNum(submissionStats.best_correct_count)}</strong>
          </div>
          <div>
            <span>Average score</span>
            <strong>{formatPercent(submissionStats.average_score_percent)}</strong>
          </div>
          {isAffiliate ? (
            <div>
              <span>Affiliate rewards</span>
              <strong>{formatNum(taskStats.affiliate_rewards_earned)} CP</strong>
            </div>
          ) : (
            <div>
              <span>Live heists</span>
              <strong>{formatNum(heistStats.active_heists)}</strong>
            </div>
          )}
        </div>
      ),
    },
    {
      key: "recent",
      label: "Recent",
      eyebrow: "Recent",
      title: "Heist activity",
      icon: <FiTarget />,
      content: (
        <div className={styles.rows}>
          {loading ? (
            <div className={styles.emptyState}>Loading heists...</div>
          ) : recentHeists.length ? (
            recentHeists.map((heist) => (
              <button
                type="button"
                key={`${heist.id}-${heist.joined_at}`}
                className={styles.activityRow}
                onClick={() => navigate(`/heist/${heist.id}`)}
              >
                <span>
                  <strong>{heist.name}</strong>
                  <small>{formatDate(heist.joined_at)}</small>
                </span>
                <em>{heist.participant_status || heist.status}</em>
              </button>
            ))
          ) : (
            <div className={styles.emptyState}>No heist activity yet.</div>
          )}
        </div>
      ),
    },
    ...(isAffiliate
      ? [
          {
            key: "affiliate",
            label: "Affiliate",
            eyebrow: "Affiliate",
            title: "Task progress",
            icon: <FiUsers />,
            content: (
              <div className={styles.rows}>
                {loading ? (
                  <div className={styles.emptyState}>Loading tasks...</div>
                ) : affiliateProgress.length ? (
                  affiliateProgress.map((task) => {
                    const required = Number(task.required_joins || 0);
                    const current = Number(task.current_joins || 0);
                    const pct = required
                      ? Math.min(100, Math.round((current / required) * 100))
                      : 0;

                    return (
                      <div className={styles.taskRow} key={task.task_id}>
                        <div className={styles.taskTop}>
                          <span>
                            <strong>{task.heist_name}</strong>
                            <small>{formatNum(task.reward_cop_points)} CP reward</small>
                          </span>
                          <em>
                            {task.is_completed
                              ? "Complete"
                              : `${formatNum(current)} / ${formatNum(required)}`}
                          </em>
                        </div>
                        <div className={styles.progressTrack}>
                          <span style={{ width: `${pct}%` }} />
                        </div>
                      </div>
                    );
                  })
                ) : (
                  <div className={styles.emptyState}>No affiliate task progress yet.</div>
                )}
              </div>
            ),
          },
        ]
      : []),
  ];

  useEffect(() => {
    setActiveProfileSlide((index) => Math.min(index, profileSlides.length - 1));
  }, [profileSlides.length]);

  const moveProfileSlide = (direction) => {
    setActiveProfileSlide((index) => {
      const next = index + direction;
      if (next < 0) return profileSlides.length - 1;
      if (next >= profileSlides.length) return 0;
      return next;
    });
  };

  const settingsSlideCount = 3;

  const moveSettingsSlide = (direction) => {
    setActiveSettingsSlide((index) => {
      const next = index + direction;
      if (next < 0) return settingsSlideCount - 1;
      if (next >= settingsSlideCount) return 0;
      return next;
    });
  };

  const loadProfile = useCallback(async () => {
    setLoading(true);
    setError("");

    try {
      const data = await getUserProfile();
      setProfileData(data);
      setForm({
        username: data?.user?.username || "",
        full_name: data?.user?.full_name || "",
        email: data?.user?.email || "",
      });
    } catch (err) {
      console.error("Profile load error:", err);
      setError(err?.response?.data?.message || "Unable to load profile.");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadProfile();
  }, [loadProfile]);

  const updateField = (event) => {
    const { name, value } = event.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const updatePasswordField = (event) => {
    const { name, value } = event.target;
    setPasswordForm((prev) => ({ ...prev, [name]: value }));
  };

  const copyValue = async (label, value) => {
    if (!value) return;

    try {
      await navigator.clipboard.writeText(String(value));
      setCopied(label);
      toast.success(`${label} copied`);
      window.setTimeout(() => setCopied(""), 1400);
    } catch (err) {
      toast.error("Unable to copy");
    }
  };

  const handleSubmit = async (event) => {
    event.preventDefault();
    if (!isDirty || saving) return;

    setSaving(true);
    try {
      const data = await updateUserProfile(form);
      setProfileData((prev) => ({ ...(prev || {}), user: data?.user }));
      setForm({
        username: data?.user?.username || "",
        full_name: data?.user?.full_name || "",
        email: data?.user?.email || "",
      });
      toast.success("Profile updated");
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to update profile.");
    } finally {
      setSaving(false);
    }
  };

  const handlePasswordSubmit = async (event) => {
    event.preventDefault();
    if (!passwordDirty || passwordSaving) return;
    if (passwordForm.new_password.length < 8) {
      toast.error("New password must be at least 8 characters.");
      return;
    }
    if (passwordForm.new_password !== passwordForm.confirm_password) {
      toast.error("New password and confirm password must match.");
      return;
    }

    setPasswordSaving(true);
    try {
      const data = await updateUserPassword({
        current_password: passwordForm.current_password,
        new_password: passwordForm.new_password,
      });
      setPasswordForm({
        current_password: "",
        new_password: "",
        confirm_password: "",
      });
      toast.success(data?.message || "Password updated");
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to update password.");
    } finally {
      setPasswordSaving(false);
    }
  };

  const handleModeSwitch = async () => {
    if (!user || modeSaving) return;

    const nextMode = isAffiliate ? "user" : "affiliate";
    setModeSaving(true);
    try {
      const data = await switchUserMode(nextMode);
      setProfileData((prev) => ({ ...(prev || {}), user: data?.user }));
      toast.success(data?.message || "Account mode updated");
      navigate(nextMode === "affiliate" ? "/affiliate-dashboard" : "/dashboard", { replace: true });
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to switch account mode.");
    } finally {
      setModeSaving(false);
    }
  };

  return (
    <div className={styles.page}>
      <Header />

      <main className={styles.main}>
        <div className={styles.topBar}>
          <button
            type="button"
            className={styles.backBtn}
            onClick={() => navigate(isAffiliate ? "/affiliate-dashboard" : "/dashboard")}
          >
            <FiArrowLeft />
            <span>Dashboard</span>
          </button>

          <button
            type="button"
            className={styles.refreshBtn}
            onClick={loadProfile}
            disabled={loading || saving}
            aria-label="Refresh profile"
          >
            <FiRefreshCw />
          </button>
        </div>

        {error ? (
          <div className={styles.errorBox}>
            <span>{error}</span>
            <button type="button" onClick={loadProfile}>
              Retry
            </button>
          </div>
        ) : null}

        <section className={styles.heroGrid}>
          <article className={styles.profileCard}>
            <div className={styles.avatarWrap}>
              <div className={styles.avatar}>{loading ? "..." : initials}</div>
              <span className={user?.is_verified ? styles.verified : styles.unverified}>
                {user?.is_verified ? <FiCheckCircle /> : <FiShield />}
                {user?.is_verified ? "Verified" : "Not verified"}
              </span>
            </div>

            <div className={styles.profileMain}>
              <p className={styles.kicker}>Player Profile</p>
              <h1>{loading ? "Loading..." : user?.full_name || user?.username || "Player"}</h1>
              <p>{user?.email || "Email not available"}</p>
            </div>

            <div className={styles.balanceCard}>
              <span>CopUpCoin balance</span>
              <strong>{formatNum(user?.cop_point)} CP</strong>
            </div>
          </article>

          <section className={styles.settingsSwap} aria-label="Profile settings cards">
            <div className={styles.miniSwapTop}>
              <div>
                <p className={styles.kicker}>Settings Cards</p>
                <h2>
                  {activeSettingsSlide === 0
                    ? "Account details"
                    : activeSettingsSlide === 1
                      ? "Update password"
                      : "Account mode"}
                </h2>
              </div>

              <div className={styles.swapControls}>
                <button
                  type="button"
                  onClick={() => moveSettingsSlide(-1)}
                  aria-label="Previous settings card"
                >
                  <FiChevronLeft />
                </button>
                <span>{activeSettingsSlide + 1}/{settingsSlideCount}</span>
                <button
                  type="button"
                  onClick={() => moveSettingsSlide(1)}
                  aria-label="Next settings card"
                >
                  <FiChevronRight />
                </button>
              </div>
            </div>

            <div className={`${styles.swapDeck} ${styles.settingsDeck}`}>
              <form
                className={`${styles.swapCard} ${styles.settingsCard}`}
                data-active={activeSettingsSlide === 0 ? "true" : "false"}
                style={{ "--offset": 0 - activeSettingsSlide, "--abs-offset": Math.abs(0 - activeSettingsSlide) }}
                aria-hidden={activeSettingsSlide !== 0}
                onSubmit={handleSubmit}
              >
                <div className={styles.cardHead}>
                  <div>
                    <p className={styles.kicker}>Update Profile</p>
                    <h2>Account details</h2>
                  </div>
                  <FiEdit3 />
                </div>

                <label className={styles.field}>
                  <span>Username</span>
                  <input
                    name="username"
                    value={form.username}
                    onChange={updateField}
                    placeholder="Username"
                    disabled={loading || saving}
                  />
                </label>

                <label className={styles.field}>
                  <span>Full name</span>
                  <input
                    name="full_name"
                    value={form.full_name}
                    onChange={updateField}
                    placeholder="Full name"
                    disabled={loading || saving}
                  />
                </label>

                <label className={styles.field}>
                  <span>Email</span>
                  <input
                    type="email"
                    name="email"
                    value={form.email}
                    onChange={updateField}
                    placeholder="Email address"
                    disabled={loading || saving}
                  />
                </label>

                <button type="submit" className={styles.saveBtn} disabled={!isDirty || loading || saving}>
                  {saving ? "Saving..." : "Save changes"}
                </button>
              </form>

              <form
                className={`${styles.swapCard} ${styles.settingsCard}`}
                data-active={activeSettingsSlide === 1 ? "true" : "false"}
                style={{ "--offset": 1 - activeSettingsSlide, "--abs-offset": Math.abs(1 - activeSettingsSlide) }}
                aria-hidden={activeSettingsSlide !== 1}
                onSubmit={handlePasswordSubmit}
              >
                <div className={styles.cardHead}>
                  <div>
                    <p className={styles.kicker}>Security</p>
                    <h2>Update password</h2>
                  </div>
                  <FiShield />
                </div>

                <label className={styles.field}>
                  <span>Current password</span>
                  <input
                    type="password"
                    name="current_password"
                    value={passwordForm.current_password}
                    onChange={updatePasswordField}
                    placeholder="Current password"
                    disabled={loading || passwordSaving}
                  />
                </label>

                <label className={styles.field}>
                  <span>New password</span>
                  <input
                    type="password"
                    name="new_password"
                    value={passwordForm.new_password}
                    onChange={updatePasswordField}
                    placeholder="New password"
                    disabled={loading || passwordSaving}
                  />
                </label>

                <label className={styles.field}>
                  <span>Confirm new password</span>
                  <input
                    type="password"
                    name="confirm_password"
                    value={passwordForm.confirm_password}
                    onChange={updatePasswordField}
                    placeholder="Confirm new password"
                    disabled={loading || passwordSaving}
                  />
                </label>

                <button
                  type="submit"
                  className={styles.saveBtn}
                  disabled={!passwordDirty || loading || passwordSaving}
                >
                  {passwordSaving ? "Updating..." : "Update password"}
                </button>
              </form>

              <article
                className={`${styles.swapCard} ${styles.settingsCard}`}
                data-active={activeSettingsSlide === 2 ? "true" : "false"}
                style={{ "--offset": 2 - activeSettingsSlide, "--abs-offset": Math.abs(2 - activeSettingsSlide) }}
                aria-hidden={activeSettingsSlide !== 2}
              >
                <div className={styles.cardHead}>
                  <div>
                    <p className={styles.kicker}>Account Mode</p>
                    <h2>{isAffiliate ? "Affiliate mode" : "User mode"}</h2>
                  </div>
                  <FiRepeat />
                </div>

                <p className={styles.modeText}>
                  {isAffiliate
                    ? "Referral tools, affiliate plans, affiliate rewards, and affiliate task progress are active."
                    : "Normal user mode keeps the profile focused on heists, wallet, clans, winners, and gameplay."}
                </p>

                <button
                  type="button"
                  className={styles.switchBtn}
                  onClick={handleModeSwitch}
                  disabled={loading || modeSaving}
                >
                  {modeSaving
                    ? "Switching..."
                    : isAffiliate
                      ? "Switch to user mode"
                      : "Switch to affiliate mode"}
                </button>
              </article>
            </div>

            <div className={styles.swapDots} aria-label="Settings card selector">
              {["Account details", "Password", "Mode"].map((label, index) => (
                <button
                  type="button"
                  key={label}
                  className={index === activeSettingsSlide ? styles.swapDotActive : ""}
                  onClick={() => setActiveSettingsSlide(index)}
                  aria-label={`Show ${label}`}
                />
              ))}
            </div>
          </section>
        </section>

        <section className={styles.statsGrid}>
          <div className={styles.statCard}>
            <FiTarget />
            <span>Joined heists</span>
            <strong>{formatNum(heistStats.joined_heists)}</strong>
          </div>
          <div className={styles.statCard}>
            <FiCheckCircle />
            <span>Submitted</span>
            <strong>{formatNum(heistStats.submitted_heists)}</strong>
          </div>
          <div className={styles.statCard}>
            <FiAward />
            <span>Won heists</span>
            <strong>{formatNum(heistStats.won_heists)}</strong>
          </div>
          {isAffiliate ? (
            <div className={styles.statCard}>
              <FiUsers />
              <span>Referred joins</span>
              <strong>{formatNum(affiliateStats.referred_joins)}</strong>
            </div>
          ) : (
            <div className={styles.statCard}>
              <FiTarget />
              <span>Live heists</span>
              <strong>{formatNum(heistStats.active_heists)}</strong>
            </div>
          )}
        </section>

        <section className={styles.swapSection}>
          <div className={styles.swapTop}>
            <div>
              <p className={styles.kicker}>Profile Cards</p>
              <h2>{profileSlides[activeProfileSlide]?.title || "Profile details"}</h2>
            </div>

            <div className={styles.swapControls}>
              <button
                type="button"
                onClick={() => moveProfileSlide(-1)}
                aria-label="Previous profile card"
              >
                <FiChevronLeft />
              </button>
              <span>
                {activeProfileSlide + 1}/{profileSlides.length}
              </span>
              <button
                type="button"
                onClick={() => moveProfileSlide(1)}
                aria-label="Next profile card"
              >
                <FiChevronRight />
              </button>
            </div>
          </div>

          <div className={styles.swapDeck}>
            {profileSlides.map((slide, index) => {
              const offset = index - activeProfileSlide;
              const isActive = offset === 0;
              return (
                <article
                  className={styles.swapCard}
                  key={slide.key}
                  data-active={isActive ? "true" : "false"}
                  style={{ "--offset": offset, "--abs-offset": Math.abs(offset) }}
                  aria-hidden={!isActive}
                >
                  <div className={styles.cardHead}>
                    <div>
                      <p className={styles.kicker}>{slide.eyebrow}</p>
                      <h2>{slide.title}</h2>
                    </div>
                    {slide.icon}
                  </div>
                  {slide.content}
                </article>
              );
            })}
          </div>

          <div className={styles.swapDots} aria-label="Profile card selector">
            {profileSlides.map((slide, index) => (
              <button
                type="button"
                key={slide.key}
                className={index === activeProfileSlide ? styles.swapDotActive : ""}
                onClick={() => setActiveProfileSlide(index)}
                aria-label={`Show ${slide.label}`}
              />
            ))}
          </div>
        </section>
      </main>

      <Footer />
    </div>
  );
}
