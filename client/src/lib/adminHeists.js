import { api } from "./api";

export async function getAdminHeists() {
  const { data } = await api.get("/admin/heists");
  return data;
}

export async function createAdminHeist(payload) {
  const { data } = await api.post("/admin/heists", payload);
  return data;
}

export async function getAdminHeist(heistId) {
  const { data } = await api.get(`/admin/heists/${heistId}`);
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

export async function getAdminQuestionBank(params = {}) {
  const { data } = await api.get("/admin/heists/question-bank", { params });
  return data;
}

export async function addAdminQuestionBankQuestions(questions) {
  const { data } = await api.post("/admin/heists/question-bank/questions", { questions });
  return data;
}

export async function updateAdminQuestionBankQuestion(questionId, payload) {
  const { data } = await api.patch(`/admin/heists/question-bank/questions/${questionId}`, payload);
  return data;
}

export async function deleteAdminQuestionBankQuestion(questionId) {
  const { data } = await api.delete(`/admin/heists/question-bank/questions/${questionId}`);
  return data;
}

export async function getAdminHeistContentBank() {
  const { data } = await api.get("/admin/heists/content-bank");
  return data;
}

export async function createAdminHeistContent(payload) {
  const { data } = await api.post("/admin/heists/content-bank", payload);
  return data;
}

export async function updateAdminHeistContent(contentId, payload) {
  const { data } = await api.patch(`/admin/heists/content-bank/${contentId}`, payload);
  return data;
}

export async function deleteAdminHeistContent(contentId) {
  const { data } = await api.delete(`/admin/heists/content-bank/${contentId}`);
  return data;
}

export async function getAdminAutoHeistSettings() {
  const { data } = await api.get("/admin/heists/auto-settings");
  return data;
}

export async function updateAdminAutoHeistSettings(payload) {
  const { data } = await api.patch("/admin/heists/auto-settings", payload);
  return data;
}

export async function runAdminAutoHeist() {
  const { data } = await api.post("/admin/heists/auto-settings/run");
  return data;
}

export async function getAdminDemoUsers() {
  const { data } = await api.get("/admin/heists/demo-users");
  return data;
}

export async function getAdminPromoCodes() {
  const { data } = await api.get("/admin/heists/promo-codes");
  return data;
}

export async function createAdminPromoCode(payload) {
  const { data } = await api.post("/admin/heists/promo-codes", payload);
  return data;
}

export async function updateAdminPromoCode(promoCodeId, payload) {
  const { data } = await api.patch(`/admin/heists/promo-codes/${promoCodeId}`, payload);
  return data;
}

export async function expireAdminPromoCode(promoCodeId) {
  const { data } = await api.patch(`/admin/heists/promo-codes/${promoCodeId}/expire`);
  return data;
}

export async function deleteAdminPromoCode(promoCodeId) {
  const { data } = await api.delete(`/admin/heists/promo-codes/${promoCodeId}`);
  return data;
}

export async function createAdminDemoUser(payload) {
  const { data } = await api.post("/admin/heists/demo-users", payload);
  return data;
}

export async function updateAdminDemoUser(demoUserId, payload) {
  const { data } = await api.patch(`/admin/heists/demo-users/${demoUserId}`, payload);
  return data;
}

export async function assignAdminHeistQuestions(heistId, questionCount) {
  const { data } = await api.post(`/admin/heists/${heistId}/questions/assign`, {
    question_count: questionCount,
  });
  return data;
}

export async function createAdminHeistDemoUser(heistId, payload) {
  const { data } = await api.post(`/admin/heists/${heistId}/demo-users`, payload);
  return data;
}

export async function deleteAdminHeistDemoUser(heistId, demoId) {
  const { data } = await api.delete(`/admin/heists/${heistId}/demo-users/${demoId}`);
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
