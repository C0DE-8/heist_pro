import { api } from "./api";
import { getAdminProfile } from "./admin";
import { emitAuthChanged } from "./copupEvents";
import { getUserProfile } from "./users";

export { getUserProfile } from "./users";

export function normalizeRole(raw) {
  const role = String(raw || "").toLowerCase();
  return role.includes("admin") ? "admin" : "user";
}

export function getStoredToken() {
  return (
    localStorage.getItem("token") ||
    localStorage.getItem("accessToken") ||
    localStorage.getItem("jwt")
  );
}

export function getStoredRole() {
  return normalizeRole(localStorage.getItem("role") || "user");
}

export function getJwtExp(token) {
  try {
    if (!token) return null;
    const parts = String(token).split(".");
    if (parts.length !== 3) return null;

    const payload = parts[1].replace(/-/g, "+").replace(/_/g, "/");
    const padded = payload + "=".repeat((4 - (payload.length % 4)) % 4);
    const data = JSON.parse(atob(padded));

    return typeof data?.exp === "number" ? data.exp : null;
  } catch (_) {
    return null;
  }
}

export function isTokenExpired(token) {
  const exp = getJwtExp(token);
  if (!exp) return false;
  return Math.floor(Date.now() / 1000) >= exp;
}

export function clearAuthSession() {
  localStorage.removeItem("token");
  localStorage.removeItem("accessToken");
  localStorage.removeItem("jwt");
  localStorage.removeItem("role");
  localStorage.removeItem("user");
  emitAuthChanged();
}

export function saveAuthSession(data) {
  const token = data?.token || data?.accessToken || data?.data?.token;
  const user = data?.user || data?.data?.user || null;
  const role = normalizeRole(data?.role || data?.data?.role || user?.role);

  if (token) localStorage.setItem("token", token);
  localStorage.setItem("role", role);
  if (user) localStorage.setItem("user", JSON.stringify(user));

  emitAuthChanged();
  return { token, role, user };
}

export async function loginUser({ identifier, password }) {
  const { data } = await api.post("/auth/login", {
    identifier: String(identifier || "").trim(),
    password,
  });

  const session = saveAuthSession(data);
  return { data, ...session };
}

export async function sendRegistrationOtp({ email, name }) {
  const { data } = await api.post("/auth/send-otp", {
    email: String(email || "").trim().toLowerCase(),
    name,
  });
  return data;
}

export async function registerUser(payload) {
  const { data } = await api.post("/auth/register", {
    username: String(payload?.username || "").trim(),
    full_name: String(payload?.full_name || "").trim() || null,
    email: String(payload?.email || "").trim().toLowerCase(),
    password: payload?.password,
    otp: String(payload?.otp || "").trim(),
    referralCode: String(payload?.referralCode || "").trim() || null,
  });
  return data;
}

export async function sendPasswordResetOtp(email) {
  const { data } = await api.post("/auth/forget-password", {
    email: String(email || "").trim().toLowerCase(),
  });
  return data;
}

export async function resetPassword({ email, otp, newPassword }) {
  const { data } = await api.post("/auth/reset-password", {
    email: String(email || "").trim().toLowerCase(),
    otp: String(otp || "").trim(),
    newPassword,
  });
  return data;
}

export async function verifyStoredSession() {
  const token = getStoredToken();
  if (!token) return null;

  if (isTokenExpired(token)) {
    clearAuthSession();
    return null;
  }

  const role = getStoredRole();
  const profile = role === "admin" ? await getAdminProfile() : await getUserProfile();
  const user = profile?.user || profile?.admin || null;
  if (user?.role) localStorage.setItem("role", normalizeRole(user.role));
  if (user) localStorage.setItem("user", JSON.stringify(user));
  return { profile, role: normalizeRole(user?.role || role), token };
}
