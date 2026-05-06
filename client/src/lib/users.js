import { api } from "./api";

export function cacheUserProfile(user) {
  if (!user) return;
  localStorage.setItem("user", JSON.stringify(user));
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

export async function getUserHeistAlerts() {
  const { data } = await api.get("/users/heist-alerts");
  return Array.isArray(data?.alerts) ? data.alerts : [];
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

export async function updateUserPassword(payload) {
  const { data } = await api.patch("/users/profile/password", {
    current_password: payload?.current_password,
    new_password: payload?.new_password,
  });
  return data;
}
