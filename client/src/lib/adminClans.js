import { api } from "./api";

export async function getAdminClans(params = {}) {
  const { data } = await api.get("/admin/clans", { params });
  return data;
}

export async function getAdminClan(clanId) {
  const { data } = await api.get(`/admin/clans/${clanId}`);
  return data;
}

export async function updateAdminClan(clanId, payload) {
  const { data } = await api.patch(`/admin/clans/${clanId}`, payload);
  return data;
}

export async function updateClanSettings(payload) {
  const { data } = await api.patch("/admin/clans/settings", payload);
  return data;
}

export async function createClanQuest(payload) {
  const { data } = await api.post("/admin/clans/quests", payload);
  return data;
}

export async function updateClanQuest(questId, payload) {
  const { data } = await api.patch(`/admin/clans/quests/${questId}`, payload);
  return data;
}

export async function calculateClanQuest(questId) {
  const { data } = await api.post(`/admin/clans/quests/${questId}/calculate`);
  return data;
}

export async function distributeClanQuest(questId) {
  const { data } = await api.post(`/admin/clans/quests/${questId}/distribute`);
  return data;
}
