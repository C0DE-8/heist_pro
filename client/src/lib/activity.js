import { api } from "./api";
import { getStoredToken } from "./auth";

export async function recordVisit(path) {
  if (!getStoredToken()) return null;
  const { data } = await api.post("/activity/visit", {
    path,
    title: document.title || "",
  });
  return data;
}
