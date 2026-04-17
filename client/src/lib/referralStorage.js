const PENDING_REFERRAL_KEY = "copup_pending_referral_join";

export function savePendingReferralJoin({ heistId, referralCode, redirectTo }) {
  const payload = {
    heistId: String(heistId || ""),
    referralCode: String(referralCode || ""),
    redirectTo: String(redirectTo || ""),
  };

  localStorage.setItem(PENDING_REFERRAL_KEY, JSON.stringify(payload));
  return payload;
}

export function getPendingReferralJoin() {
  try {
    const raw = localStorage.getItem(PENDING_REFERRAL_KEY);
    if (!raw) return null;
    const data = JSON.parse(raw);
    if (!data?.heistId || !data?.referralCode || !data?.redirectTo) return null;
    return data;
  } catch (_) {
    return null;
  }
}

export function clearPendingReferralJoin() {
  localStorage.removeItem(PENDING_REFERRAL_KEY);
}
