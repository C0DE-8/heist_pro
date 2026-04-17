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

export async function updateUserProfile(payload) {
  const { data } = await api.patch("/users/profile", {
    username: payload?.username,
    full_name: payload?.full_name,
    email: payload?.email,
  });
  cacheUserProfile(data?.user);
  return data;
}
