import { api } from "./api";

export async function getAdminUsers(params = {}) {
  const { data } = await api.get("/admin/users", { params });
  return data;
}

export async function getAdminUser(id) {
  const { data } = await api.get(`/admin/users/${id}`);
  return data;
}

export async function updateAdminUser(id, payload) {
  const { data } = await api.patch(`/admin/users/${id}`, payload);
  return data;
}

export async function deleteAdminUser(id) {
  const { data } = await api.delete(`/admin/users/${id}`);
  return data;
}
