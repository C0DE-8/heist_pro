import { api } from "./api";

export async function getAdminHeists() {
  const { data } = await api.get("/admin/heists");
  return data;
}

export async function createAdminHeist(payload) {
  const { data } = await api.post("/admin/heists", payload);
  return data;
}

export async function updateAdminHeist(heistId, payload) {
  const { data } = await api.patch(`/admin/heists/${heistId}`, payload);
  return data;
}

export async function getAdminHeistQuestions(heistId) {
  const { data } = await api.get(`/admin/heists/${heistId}/questions`);
  return data;
}

export async function addAdminHeistQuestions(heistId, questions) {
  const { data } = await api.post(`/admin/heists/${heistId}/questions`, { questions });
  return data;
}

export async function deleteAdminHeistQuestion(heistId, questionId) {
  const { data } = await api.delete(`/admin/heists/${heistId}/questions/${questionId}`);
  return data;
}

export async function updateAdminHeistStatus(heistId, status) {
  const { data } = await api.patch(`/admin/heists/${heistId}/status`, { status });
  return data;
}

export async function finalizeAdminHeist(heistId) {
  const { data } = await api.post(`/admin/heists/${heistId}/finalize`);
  return data;
}

export async function getAdminAffiliateTasks(heistId) {
  const { data } = await api.get(`/admin/heists/${heistId}/affiliate-tasks`);
  return data;
}

export async function createAdminAffiliateTask(heistId, payload) {
  const { data } = await api.post(`/admin/heists/${heistId}/affiliate-tasks`, payload);
  return data;
}

export async function updateAdminAffiliateTask(heistId, taskId, payload) {
  const { data } = await api.patch(`/admin/heists/${heistId}/affiliate-tasks/${taskId}`, payload);
  return data;
}

export async function deleteAdminAffiliateTask(heistId, taskId) {
  const { data } = await api.delete(`/admin/heists/${heistId}/affiliate-tasks/${taskId}`);
  return data;
}

export async function getAdminAffiliateTaskProgress(heistId) {
  const { data } = await api.get(`/admin/heists/${heistId}/affiliate-tasks/progress`);
  return data;
}
