import { api } from "./api";

export async function sendAdminNotice(payload) {
  const { data } = await api.post("/admin/notifications/notice", {
    title: payload?.title,
    message: payload?.message,
    type: payload?.type,
    path: payload?.path,
    priority: payload?.priority,
    all_users: Boolean(payload?.all_users),
    user_id: payload?.all_users ? undefined : payload?.user_id,
  });
  return data;
}
