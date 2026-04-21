import { api } from "./api";

export async function getAdminProfile() {
  const { data } = await api.get("/admin/profile");
  return data;
}

export async function updateAdminProfile(payload) {
  const { data } = await api.patch("/admin/profile", {
    username: payload?.username,
    full_name: payload?.full_name,
    email: payload?.email,
  });
  return data;
}

export async function updateAdminPassword(payload) {
  const { data } = await api.patch("/admin/profile/password", {
    current_password: payload?.current_password,
    new_password: payload?.new_password,
  });
  return data;
}
