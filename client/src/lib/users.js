import { api } from "./api";
import { emitAuthChanged } from "./copupEvents";

function normalizeRole(raw) {
  const role = String(raw || "").toLowerCase();
  if (role.includes("admin")) return "admin";
  if (role.includes("affiliate")) return "affiliate";
  return "user";
}

export function cacheUserProfile(user) {
  if (!user) return;
  localStorage.setItem("user", JSON.stringify(user));
  if (user.role) localStorage.setItem("role", normalizeRole(user.role));
  localStorage.setItem("copup_cop_point", String(user.cop_point ?? 0));
}

export async function getUserProfile() {
  const { data } = await api.get("/users/profile");
  cacheUserProfile(data?.user);
  return data;
}

export async function getReferredUsers() {
  const { data } = await api.get("/users/referred");
  return {
    settings: data?.settings || null,
    referrals: Array.isArray(data?.referrals) ? data.referrals : [],
  };
}

export async function getAffiliateTileDashboard() {
  const { data } = await api.get("/users/affiliate-tiles");
  return data;
}

export async function joinAffiliateTile(tileId) {
  const { data } = await api.post(`/users/affiliate-tiles/${tileId}/join`);
  if (data?.user) cacheUserProfile(data.user);
  return data;
}

export async function getUserHeistAlerts() {
  const { data } = await api.get("/users/heist-alerts");
  return Array.isArray(data?.alerts) ? data.alerts : [];
}

export async function registerUserPushToken(payload) {
  const { data } = await api.post("/users/push-token", payload);
  return data;
}

export async function unregisterUserPushToken(token) {
  const { data } = await api.delete("/users/push-token", {
    data: { token },
  });
  return data;
}

export async function claimReferredUserReward(referredUserId) {
  const { data } = await api.post(`/users/referred/${referredUserId}/claim`);
  return data;
}

export async function updateUserProfile(payload) {
  const { data } = await api.patch("/users/profile", {
    username: payload?.username,
    full_name: payload?.full_name,
    email: payload?.email,
  });
  cacheUserProfile(data?.user);
  return data;
}

export async function switchUserMode(mode) {
  const { data } = await api.patch("/users/profile/mode", { mode });
  cacheUserProfile(data?.user);
  emitAuthChanged();
  return data;
}

export async function updateUserPassword(payload) {
  const { data } = await api.patch("/users/profile/password", {
    current_password: payload?.current_password,
    new_password: payload?.new_password,
  });
  return data;
}
