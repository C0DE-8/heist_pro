import React, { useCallback, useEffect, useMemo, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { FiArrowLeft, FiAward, FiClock, FiLogIn, FiShield, FiUserPlus } from "react-icons/fi";
import Header from "../../components/Header/Header";
import Footer from "../../components/Footer/Footer";
import { api } from "../../lib/api";
import { getStoredToken } from "../../lib/auth";
import { joinHeist } from "../../lib/heists";
import {
  clearPendingReferralJoin,
  savePendingReferralJoin,
} from "../../lib/referralStorage";
import styles from "./ReferralJoinPage.module.css";

const JOIN_LOCK_BEFORE_END_MS = 2 * 60 * 1000;

function formatNum(value) {
  const n = Number(value);
  return Number.isFinite(n) ? n.toLocaleString() : "0";
}

function formatDate(value) {
  if (!value) return "Not scheduled";
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "Not scheduled";
  return date.toLocaleString([], {
    month: "short",
    day: "numeric",
    year: "numeric",
    hour: "numeric",
    minute: "2-digit",
  });
}

function isClosedStatus(status) {
  const value = String(status || "").toLowerCase();
  return value === "completed" || value === "cancelled";
}

function isJoinTimeLocked(heist) {
  const endTime = heist?.countdown_ends_at || heist?.ends_at;
  if (!endTime) return false;

  const endMs = new Date(endTime).getTime();
  return Number.isFinite(endMs) && endMs - Date.now() <= JOIN_LOCK_BEFORE_END_MS;
}

function getStoredUserId() {
  try {
    const user = JSON.parse(localStorage.getItem("user") || "null");
    return user?.id || user?.userId || null;
  } catch {
    return null;
  }
}

export default function ReferralJoinPage() {
  const { id, code } = useParams();
  const navigate = useNavigate();

  const [payload, setPayload] = useState(null);
  const [loading, setLoading] = useState(true);
  const [joining, setJoining] = useState(false);
  const [joined, setJoined] = useState(false);
  const [alreadyJoined, setAlreadyJoined] = useState(false);
  const [error, setError] = useState("");

  const token = useMemo(() => getStoredToken(), []);
  const currentUserId = useMemo(() => getStoredUserId(), []);
  const heist = payload?.heist || null;
  const affiliate = payload?.affiliate || null;
  const closed = isClosedStatus(heist?.status);
  const maxUsers = Number(heist?.max_users || 0);
  const totalParticipants = Number(heist?.total_participants || 0);
  const isFull = !alreadyJoined && maxUsers > 0 && totalParticipants >= maxUsers;
  const isJoinLocked = !alreadyJoined && (isFull || isJoinTimeLocked(heist));
  const isOwnReferral = Boolean(
    token &&
      currentUserId &&
      affiliate?.user_id &&
      Number(currentUserId) === Number(affiliate.user_id)
  );
  const redirectTo = `/heists/${id}/ref/${code}`;

  const loadReferral = useCallback(async () => {
    setLoading(true);
    setError("");

    try {
      const { data } = await api.get(`/heists/${id}/ref/${code}`);
      setPayload(data || null);
    } catch (err) {
      console.error("Referral heist load error:", err);
      setPayload(null);
      setError(
        err?.response?.data?.message ||
          "This referral link is invalid or the heist is no longer available."
      );
    } finally {
      setLoading(false);
    }
  }, [id, code]);

  useEffect(() => {
    loadReferral();
  }, [loadReferral]);

  useEffect(() => {
    if (!token || !heist?.id || closed) return;

    let mounted = true;
    api
      .get(`/heists/${id}/play`)
      .then(() => {
        if (mounted) {
          setAlreadyJoined(true);
          clearPendingReferralJoin();
        }
      })
      .catch((err) => {
        if (err?.response?.status !== 403 && err?.response?.status !== 404) {
          console.warn("Referral joined check failed:", err);
        }
      });

    return () => {
      mounted = false;
    };
  }, [token, heist?.id, id, closed]);

  const saveReferralAndLogin = () => {
    savePendingReferralJoin({
      heistId: id,
      referralCode: code,
      redirectTo,
    });
    navigate("/login", { state: { from: redirectTo } });
  };

  const handleJoin = async () => {
    if (loading || joining || joined || closed) return;

    if (alreadyJoined) {
      navigate(`/heist/${id}`);
      return;
    }

    if (isJoinLocked) {
      setError(isFull ? "This heist is full." : "This heist is locked for joining.");
      return;
    }

    if (isOwnReferral) {
      setError("You cannot use your own referral link.");
      return;
    }

    if (!token) {
      saveReferralAndLogin();
      return;
    }

    setJoining(true);
    setError("");

    try {
      await joinHeist(id, code);
      clearPendingReferralJoin();
      setJoined(true);
      window.setTimeout(() => {
        navigate(`/heist/${id}`);
      }, 900);
    } catch (err) {
      const message = err?.response?.data?.message || "Unable to join this heist.";
      if (/already joined/i.test(message)) {
        clearPendingReferralJoin();
        setAlreadyJoined(true);
        setError("");
        return;
      }
      setError(message);
    } finally {
      setJoining(false);
    }
  };

  const buttonText = (() => {
    if (loading) return "Loading...";
    if (joining) return "Joining...";
    if (joined) return "Joined Successfully";
    if (alreadyJoined) return "Go to Heist";
    if (isJoinLocked) return "Heist Locked";
    if (isOwnReferral) return "Own Referral Link";
    if (!token) return "Login to Join";
    return "Join Heist";
  })();

  return (
    <div className={styles.page}>
      <Header />

      <main className={styles.main}>
        <button type="button" className={styles.backBtn} onClick={() => navigate("/heist")}>
          <FiArrowLeft />
          <span>Heists</span>
        </button>

        <section className={styles.card}>
          {loading ? (
            <div className={styles.stateBox}>
              <div className={styles.spinner} />
              <h1>Loading referral...</h1>
              <p>Checking this heist link before you join.</p>
            </div>
          ) : error && !heist ? (
            <div className={styles.stateBox}>
              <div className={styles.badIcon}>!</div>
              <h1>Referral unavailable</h1>
              <p>{error}</p>
              <button type="button" className={styles.secondaryBtn} onClick={loadReferral}>
                Try again
              </button>
            </div>
          ) : (
            <>
              <div className={styles.topRow}>
                <span className={styles.status}>{heist?.status || "pending"}</span>
                <span className={styles.sharedBy}>
                  Shared by {affiliate?.username || "a CopUp player"}
                </span>
              </div>

              <div className={styles.heroText}>
                <p className={styles.kicker}>Heist Referral</p>
                <h1>{heist?.name || "Heist"}</h1>
                <p>
                  {heist?.description ||
                    "Join this True/False heist, answer fast, and compete for CopUpCoin."}
                </p>
              </div>

              <div className={styles.metricGrid}>
                <div>
                  <FiUserPlus />
                  <span>Ticket</span>
                  <strong>{formatNum(heist?.ticket_price)} CP</strong>
                </div>
                <div>
                  <FiAward />
                  <span>Prize</span>
                  <strong>{formatNum(heist?.prize_cop_points)} CP</strong>
                </div>
                <div>
                  <FiClock />
                  <span>Starts</span>
                  <strong>{formatDate(heist?.starts_at)}</strong>
                </div>
                <div>
                  <FiShield />
                  <span>Seats</span>
                  <strong>
                    {maxUsers > 0 ? `${formatNum(totalParticipants)} / ${formatNum(maxUsers)}` : "Open"}
                  </strong>
                </div>
              </div>

              {closed ? (
                <div className={styles.notice}>
                  This heist is no longer available for joining.
                </div>
              ) : null}

              {isOwnReferral ? (
                <div className={styles.notice}>
                  You cannot join this heist using your own referral link.
                </div>
              ) : null}

              {isJoinLocked ? (
                <div className={styles.notice}>
                  {isFull
                    ? "This heist has reached its maximum number of users."
                    : "This heist is locked for joining."}
                </div>
              ) : null}

              {alreadyJoined ? (
                <div className={styles.notice}>
                  You have already joined this heist. Continue to the heist page when ready.
                </div>
              ) : null}

              {!token ? (
                <div className={styles.notice}>
                  You are not logged in. Log in first and we will bring you back to this referral page.
                </div>
              ) : null}

              {error ? <div className={styles.errorBox}>{error}</div> : null}

              <div className={styles.actions}>
                <button
                  type="button"
                  className={styles.primaryBtn}
                  onClick={handleJoin}
                  disabled={loading || joining || joined || closed || isOwnReferral || isJoinLocked}
                >
                  {token ? <FiUserPlus /> : <FiLogIn />}
                  <span>{buttonText}</span>
                </button>

                {!token ? (
                  <button type="button" className={styles.secondaryBtn} onClick={saveReferralAndLogin}>
                    <FiLogIn />
                    <span>Login</span>
                  </button>
                ) : null}
              </div>
            </>
          )}
        </section>
      </main>

      <Footer />
    </div>
  );
}
