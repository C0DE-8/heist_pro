import { api } from "./api";

function serializeExcludedUserIds(excludedUserIds = []) {
  return excludedUserIds.length ? excludedUserIds.join(",") : undefined;
}

export async function getAdminAnalytics({ excludedUserIds = [] } = {}) {
  const { data } = await api.get("/admin/analytics", {
    params: {
      excluded_user_ids: serializeExcludedUserIds(excludedUserIds),
    },
  });
  return data;
}

export async function getAdminUserCoinAnalytics({ excludedUserIds = [] } = {}) {
  const { data } = await api.get("/admin/analytics/users", {
    params: {
      excluded_user_ids: serializeExcludedUserIds(excludedUserIds),
    },
  });
  return data;
}

export async function getAdminHeistAnalytics() {
  const { data } = await api.get("/admin/analytics/heists");
  return data;
}
