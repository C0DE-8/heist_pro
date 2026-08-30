import { api } from "./api";

export async function getUserProgress() {
  const { data } = await api.get("/users/progress");
  return data?.progress || null;
}

export async function getUserLevels() {
  const { data } = await api.get("/users/progress/levels");
  return {
    progress: data?.progress || null,
    levels: Array.isArray(data?.levels) ? data.levels : [],
  };
}

export async function getUserLevelRewards() {
  const { data } = await api.get("/users/progress/rewards");
  return Array.isArray(data?.rewards) ? data.rewards : [];
}

export async function claimUserLevelReward(rewardId) {
  const { data } = await api.post(`/users/progress/rewards/${rewardId}/claim`);
  return data;
}

export async function redeemUserLevelRewardCode(code) {
  const { data } = await api.post("/users/progress/rewards/redeem-code", { code });
  return data;
}

export async function getAdminLevelSummary() {
  const { data } = await api.get("/admin/levels/summary");
  return data;
}

export async function getAdminBadges() {
  const { data } = await api.get("/admin/levels/badges");
  return Array.isArray(data?.badges) ? data.badges : [];
}

export async function updateAdminBadge(id, payload) {
  const { data } = await api.patch(`/admin/levels/badges/${id}`, payload);
  return data;
}

export async function getAdminLevelDefinitions() {
  const { data } = await api.get("/admin/levels/definitions");
  return Array.isArray(data?.levels) ? data.levels : [];
}

export async function updateAdminLevelDefinition(id, payload) {
  const { data } = await api.patch(`/admin/levels/definitions/${id}`, payload);
  return data;
}

export async function getAdminXpRules() {
  const { data } = await api.get("/admin/levels/xp-rules");
  return Array.isArray(data?.rules) ? data.rules : [];
}

export async function updateAdminXpRule(source, payload) {
  const { data } = await api.patch(`/admin/levels/xp-rules/${source}`, payload);
  return data;
}

export async function getAdminUserProgress(userId) {
  const { data } = await api.get(`/admin/levels/users/${userId}`);
  return data;
}

export async function adjustAdminUserXp(userId, payload) {
  const { data } = await api.post(`/admin/levels/users/${userId}/adjust-xp`, payload);
  return data;
}

export async function getAdminLevelRewards(status = "") {
  const params = status ? { status } : {};
  const { data } = await api.get("/admin/levels/rewards", { params });
  return Array.isArray(data?.rewards) ? data.rewards : [];
}

export async function updateAdminLevelReward(id, payload) {
  const { data } = await api.patch(`/admin/levels/rewards/${id}`, payload);
  return data;
}
