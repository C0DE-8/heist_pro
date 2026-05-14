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

export async function createAffiliateTile(payload) {
  const { data } = await api.post("/admin/referral/tiles", {
    ...payload,
    plan_price_cop_points: Number(payload?.plan_price_cop_points || 0),
  });
  return data;
}

export async function updateAffiliateTile(tileId, payload) {
  const { data } = await api.patch(`/admin/referral/tiles/${tileId}`, {
    ...payload,
    plan_price_cop_points: Number(payload?.plan_price_cop_points || 0),
  });
  return data;
}

export async function deleteAffiliateTile(tileId) {
  const { data } = await api.delete(`/admin/referral/tiles/${tileId}`);
  return data;
}
