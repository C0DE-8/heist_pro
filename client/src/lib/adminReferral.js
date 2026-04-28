import { api } from "./api";

export async function getAdminReferralSettings() {
  const { data } = await api.get("/admin/referral");
  return data;
}

export async function updateAdminReferralSettings(payload) {
  const { data } = await api.patch("/admin/referral", payload);
  return data;
}

export async function resetAdminReferralSettings() {
  const { data } = await api.post("/admin/referral/reset");
  return data;
}
