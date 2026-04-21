import { api } from "./api";

export async function getAdminAnalytics() {
  const { data } = await api.get("/admin/analytics");
  return data;
}

export async function getAdminUserCoinAnalytics() {
  const { data } = await api.get("/admin/analytics/users");
  return data;
}

export async function getAdminHeistAnalytics() {
  const { data } = await api.get("/admin/analytics/heists");
  return data;
}

export async function updateAdminAnalyticsUserInclusion(userId, included) {
  const { data } = await api.patch(`/admin/analytics/users/${userId}/inclusion`, {
    included,
  });
  return data;
}

export async function clearAdminAnalyticsExclusions() {
  const { data } = await api.delete("/admin/analytics/exclusions");
  return data;
}
