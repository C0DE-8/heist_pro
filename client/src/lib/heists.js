import { api } from "./api";

export async function getAvailableHeists() {
  const { data } = await api.get("/heists/available");
  return data;
}

export async function getCompletedHeists() {
  const { data } = await api.get("/heists/completed");
  return data;
}

export async function getHeist(id) {
  const { data } = await api.get(`/heists/${id}`);
  return data;
}

export async function joinHeist(id, referralCode) {
  const payload = referralCode ? { referral_code: referralCode } : {};
  const { data } = await api.post(`/heists/${id}/join`, payload);
  return data;
}

export async function getHeistPlay(id) {
  const { data } = await api.get(`/heists/${id}/play`);
  return data;
}

export async function startHeist(id) {
  const { data } = await api.post(`/heists/${id}/start`);
  return data;
}

export async function submitHeistAnswers(id, payload) {
  const { data } = await api.post(`/heists/${id}/submit`, payload);
  return data;
}

export async function getHeistResult(id) {
  const { data } = await api.get(`/heists/${id}/result`);
  return data;
}

export async function getHeistLeaderboard(id) {
  const { data } = await api.get(`/heists/${id}/leaderboard`);
  return data;
}

export async function createHeistAffiliateLink(id) {
  const { data } = await api.post(`/heists/${id}/affiliate-link`);
  return data;
}

export async function getReferralHeist(id, code) {
  const { data } = await api.get(`/heists/${id}/ref/${code}`);
  return data;
}
