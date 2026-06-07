import { api } from "./api";

export async function getGodEyesUsers(params = {}) {
  const { data } = await api.get("/admin/god-eyes", { params });
  return data;
}

export async function getGodEyesUser(id) {
  const { data } = await api.get(`/admin/god-eyes/${id}`);
  return data;
}

export async function setGodEyesUserBlocked(id, isBlocked, reason = "") {
  const { data } = await api.patch(`/admin/god-eyes/${id}/block`, {
    is_blocked: Boolean(isBlocked),
    reason,
  });
  return data;
}
