import { api } from "./api";

export async function getClans(params = {}) {
  const { data } = await api.get("/clans", { params });
  return data;
}

export async function getClan(clanId) {
  const { data } = await api.get(`/clans/${clanId}`);
  return data;
}

export async function getMyClan() {
  const { data } = await api.get("/clans/me");
  return data;
}

export async function getTopClans(params = {}) {
  const { data } = await api.get("/clans/top", { params });
  return data;
}

export async function getClanQuests() {
  const { data } = await api.get("/clans/quests");
  return data;
}

export async function createClan(payload) {
  const { data } = await api.post("/clans", payload);
  return data;
}

export async function uploadClanImages(files = {}, options = {}) {
  const form = new FormData();
  if (options.clanName) form.append("clan_name", options.clanName);
  if (files.logo) form.append("logo", files.logo);
  if (files.banner) form.append("banner", files.banner);
  const { data } = await api.post("/clans/uploads", form, {
    headers: { "Content-Type": "multipart/form-data" },
  });
  return data;
}

export async function updateClan(clanId, payload) {
  const { data } = await api.patch(`/clans/${clanId}`, payload);
  return data;
}

export async function joinClan(clanId, payload = {}) {
  const { data } = await api.post(`/clans/${clanId}/join`, payload);
  return data;
}

export async function leaveClan(clanId) {
  const { data } = await api.post(`/clans/${clanId}/leave`);
  return data;
}

export async function getClanRequests(clanId) {
  const { data } = await api.get(`/clans/${clanId}/requests`);
  return data;
}

export async function decideClanRequest(clanId, requestId, decision) {
  const { data } = await api.post(`/clans/${clanId}/requests/${requestId}/${decision}`);
  return data;
}

export async function updateClanMemberRole(clanId, memberId, role) {
  const { data } = await api.patch(`/clans/${clanId}/members/${memberId}`, { role });
  return data;
}

export async function removeClanMember(clanId, memberId) {
  const { data } = await api.delete(`/clans/${clanId}/members/${memberId}`);
  return data;
}

export async function getClanChat(clanId, params = {}) {
  const { data } = await api.get(`/clans/${clanId}/chat`, { params });
  return data;
}

export async function sendClanChat(clanId, message) {
  const { data } = await api.post(`/clans/${clanId}/chat`, { message });
  return data;
}

export async function deleteClanChatMessage(clanId, messageId) {
  const { data } = await api.delete(`/clans/${clanId}/chat/${messageId}`);
  return data;
}

export async function joinClanQuest(clanId, questId) {
  const { data } = await api.post(`/clans/${clanId}/quests/${questId}/join`);
  return data;
}
