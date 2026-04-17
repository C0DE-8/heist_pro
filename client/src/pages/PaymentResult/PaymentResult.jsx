import React, { useEffect, useMemo, useState } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import styles from "./PaymentResult.module.css";
import Header from "../../components/Header/Header";
import Footer from "../../components/Footer/Footer";
import { FiCheckCircle, FiXCircle, FiArrowLeft } from "react-icons/fi";
import { getUserProfile } from "../../lib/users";

function useQuery() {
  const { search } = useLocation();
  return useMemo(() => new URLSearchParams(search), [search]);
}

function safeNum(v) {
  const n = Number(v);
  return Number.isFinite(n) ? n : 0;
}

export default function PaymentResult() {
  const nav = useNavigate();
  const q = useQuery();

  const status = String(q.get("status") || "").toLowerCase();
  const coins = safeNum(q.get("coins"));
  const amount = safeNum(q.get("amount"));
  const reason = q.get("reason") || "";

  const ok = status === "success";

  const [profile, setProfile] = useState(null);

  // ✅ Optional: confirm new balance by fetching profile after success
  useEffect(() => {
    if (!ok) return;
    (async () => {
      try {
        const data = await getUserProfile();
        setProfile(data);
      } catch (e) {
        console.error("PaymentResult profile fetch failed:", e);
      }
    })();
  }, [ok]);

  useEffect(() => {
    if (!ok) return;
    const t = setTimeout(() => {
      nav("/account?tab=topup");
    }, 4500);
    return () => clearTimeout(t);
  }, [ok, nav]);

  return (
    <div className={styles.page}>
      <Header />

      <main className={styles.main}>
        <div className={styles.card}>
          <div className={styles.iconWrap}>
            {ok ? (
              <FiCheckCircle className={styles.okIcon} />
            ) : (
              <FiXCircle className={styles.badIcon} />
            )}
          </div>

          <div className={styles.title}>
            {ok ? "Payment Successful" : "Payment Failed"}
          </div>

          <div className={styles.sub}>
            {ok
              ? "Your top-up has been verified and your balance has been updated."
              : "We couldn’t complete your payment verification."}
          </div>

          <div className={styles.details}>
            {ok ? (
              <>
                <div className={styles.row}>
                  <span>Credited Coins</span>
                  <b>{coins.toLocaleString()}</b>
                </div>
                <div className={styles.row}>
                  <span>Amount Paid</span>
                  <b>{amount.toLocaleString()}</b>
                </div>

                {profile?.user?.cop_point !== undefined ? (
                  <div className={styles.row}>
                    <span>New CopUpCoin Balance</span>
                    <b>{Number(profile.user.cop_point).toLocaleString()} CP</b>
                  </div>
                ) : null}
              </>
            ) : (
              <div className={styles.reason}>
                <b>Reason:</b>{" "}
                {reason ? decodeURIComponent(reason) : "Payment not successful"}
              </div>
            )}
          </div>

          <div className={styles.actions}>
            <button
              className={styles.primaryBtn}
              onClick={() => nav("/account?tab=topup")}
            >
              Go to Wallet
            </button>

            <button className={styles.ghostBtn} onClick={() => nav(-1)}>
              <FiArrowLeft /> Back
            </button>
          </div>

          {ok ? <div className={styles.note}>Redirecting you back to Wallet...</div> : null}
        </div>
      </main>

      <Footer />
    </div>
  );
}
