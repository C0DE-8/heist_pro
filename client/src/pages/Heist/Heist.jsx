import React, { useCallback, useEffect, useMemo, useState } from "react";
import { useNavigate, useSearchParams } from "react-router-dom";
import { FiGift, FiRefreshCw } from "react-icons/fi";
import Header from "../../components/Header/Header";
import Footer from "../../components/Footer/Footer";
import { useToast } from "../../components/Toast/ToastContext";
import {
  getAvailableHeists,
  getCopupJrBalance,
  joinHeist,
  redeemPromoCode,
} from "../../lib/heists";
import HeistCard from "./HeistCard";
import styles from "./Heist.module.css";

const JOIN_LOCK_BEFORE_END_MS = 2 * 60 * 1000;

function formatNum(value) {
  const n = Number(value);
  return Number.isFinite(n) ? n.toLocaleString() : "0";
}

function getReferralCode(searchParams) {
  return (
    searchParams.get("referral_code") ||
    searchParams.get("ref") ||
    searchParams.get("code") ||
    ""
  );
}

function isHeistFull(heist) {
  const maxUsers = Number(heist?.max_users || 0);
  return maxUsers > 0 && Number(heist?.total_participants || 0) >= maxUsers;
}

function isJoinTimeLocked(heist) {
  const endTime = heist?.countdown_ends_at || heist?.ends_at;
  if (!endTime) return false;

  const endMs = new Date(endTime).getTime();
  return Number.isFinite(endMs) && endMs - Date.now() <= JOIN_LOCK_BEFORE_END_MS;
}

function HeistCardSkeleton({ muted = false, children } = {}) {
  return (
    <article className={`${styles.heistSkeleton} ${muted ? styles.mutedSkeleton : ""}`} aria-hidden={!children}>
      <div className={styles.skeletonGlow} />
      <div className={styles.skeletonTop}>
        <span />
        <span />
      </div>
      <div className={styles.skeletonMiddle}>
        <span />
        <span />
        <span />
      </div>
      <div className={styles.skeletonBottom}>
        <span />
        <span />
      </div>
      {children}
    </article>
  );
}

function EmptyHeistFallback() {
  return (
    <>
      <HeistCardSkeleton muted>
        <div className={styles.emptySkeletonMessage}>
          <strong>No available heists yet.</strong>
          <span>Check back soon or refresh to load new heists.</span>
        </div>
      </HeistCardSkeleton>
      <HeistCardSkeleton muted />
      <HeistCardSkeleton muted />
    </>
  );
}

export default function Heist() {
  const navigate = useNavigate();
  const toast = useToast();
  const [searchParams] = useSearchParams();
  const referralCode = useMemo(() => getReferralCode(searchParams), [searchParams]);

  const [available, setAvailable] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [joiningId, setJoiningId] = useState(null);
  const [promoCode, setPromoCode] = useState("");
  const [promoBalance, setPromoBalance] = useState(null);
  const [redeeming, setRedeeming] = useState(false);

  const loadHeists = useCallback(async () => {
    setLoading(true);
    setError("");

    try {
      const availableData = await getAvailableHeists();

      setAvailable(Array.isArray(availableData?.heists) ? availableData.heists : []);
    } catch (err) {
      console.error("Load heists error:", err);
      setError(err?.response?.data?.message || "Unable to load heists.");
    } finally {
      setLoading(false);
    }
  }, []);

  const loadPromoBalance = useCallback(async () => {
    try {
      const data = await getCopupJrBalance();
      setPromoBalance(Number(data?.copup_jr_balance || 0));
    } catch (err) {
      if (err?.response?.status !== 401) {
        console.warn("Load CopUp Jr balance error:", err);
      }
    }
  }, []);

  useEffect(() => {
    loadHeists();
    loadPromoBalance();
  }, [loadHeists, loadPromoBalance]);

  const handleJoin = async (heist) => {
    if (!heist?.id || joiningId) return;

    setJoiningId(heist.id);
    try {
      await joinHeist(heist.id, referralCode);
      toast.success("Joined heist");
      loadPromoBalance();
      navigate(`/heist/${heist.id}`);
    } catch (err) {
      const message = err?.response?.data?.message || "Unable to join heist.";
      if (/already joined/i.test(message)) {
        navigate(`/heist/${heist.id}`);
      } else {
        toast.error(message);
      }
    } finally {
      setJoiningId(null);
    }
  };

  const handleRedeemPromo = async (event) => {
    event.preventDefault();
    const code = promoCode.trim();
    if (!code || redeeming) return;

    setRedeeming(true);
    try {
      const data = await redeemPromoCode(code);
      setPromoCode("");
      setPromoBalance(Number(data?.copup_jr_balance || 0));
      toast.success(`Added ${formatNum(data?.credited_copup_jr)} CopUp Jr`);
      await loadHeists();
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to redeem promo code.");
    } finally {
      setRedeeming(false);
    }
  };

  const handleHeistAction = (heist) => {
    if (!heist?.id || joiningId) return;

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
      navigate(`/heist/${heist.id}/leaderboard`);
      return;
    }

    if (hasJoined) {
      navigate(`/heist/${heist.id}`);
      return;
    }

    if (isHeistFull(heist)) {
      toast.error("This heist is full.");
      return;
    }

    if (isJoinTimeLocked(heist)) {
      toast.error("This heist is locked for joining.");
      return;
    }

    handleJoin(heist);
  };

  return (
    <div className={styles.page}>
      <Header />

      <main className={styles.main}>
        <section className={styles.statsGrid}>
          <div>
            <span>Available</span>
            <strong>{loading ? "..." : formatNum(available.length)}</strong>
          </div>
          <div>
            <span>Referral</span>
            <strong>{referralCode ? "Active" : "None"}</strong>
          </div>
        </section>

        {error ? (
          <div className={styles.errorBox}>
            <span>{error}</span>
            <button type="button" onClick={loadHeists}>
              Retry
            </button>
          </div>
        ) : null}

        <section className={styles.sectionHead}>
          <div>
            <h2>Available Heists</h2>
          </div>
          <button type="button" onClick={loadHeists} className={styles.refreshBtn}>
            <FiRefreshCw />
          </button>
        </section>

        <section className={styles.heistList}>
          {loading ? (
            [0, 1, 2].map((item) => <HeistCardSkeleton key={item} />)
          ) : available.length ? (
            available.map((heist) => (
              <HeistCard
                key={heist.id}
                heist={heist}
                onAction={handleHeistAction}
                isBusy={joiningId === heist.id}
              />
            ))
          ) : (
            <EmptyHeistFallback />
          )}
        </section>

        <section className={styles.promoPanel}>
          <div className={styles.promoIcon}>
            <FiGift />
          </div>
          <div className={styles.promoCopy}>
            <span>Promo code</span>
            <strong>Gift CopUp Coin balance: {promoBalance === null ? "..." : formatNum(promoBalance)}</strong>
            <p>Gift CopUp Coin is only used to join heists and cannot be withdrawn.</p>
          </div>
          <form className={styles.promoForm} onSubmit={handleRedeemPromo}>
            <input
              value={promoCode}
              onChange={(event) => setPromoCode(event.target.value.toUpperCase())}
              placeholder="Enter code"
              autoCapitalize="characters"
            />
            <button type="submit" className={styles.secondaryBtn} disabled={redeeming || !promoCode.trim()}>
              {redeeming ? "Redeeming..." : "Redeem"}
            </button>
          </form>
        </section>
      </main>

      <Footer />
    </div>
  );
}
