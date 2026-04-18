import { api } from "./api";

export async function getTransactionSettings() {
  const { data } = await api.get("/admin/transactions/settings");
  return data;
}

export async function updatePaymentInfo(payload) {
  const { data } = await api.put("/admin/transactions/payment-info", payload);
  return data;
}

export async function updateCoinRate(payload) {
  const { data } = await api.put("/admin/transactions/coin-rate", payload);
  return data;
}

export async function getAdminPayins(status = "") {
  const { data } = await api.get("/admin/transactions/payins", {
    params: status ? { status } : {},
  });
  return data;
}

export async function reviewPayin(id, payload) {
  const { data } = await api.patch(`/admin/transactions/payins/${id}/review`, payload);
  return data;
}

export async function getAdminPayouts(status = "") {
  const { data } = await api.get("/admin/transactions/payouts", {
    params: status ? { status } : {},
  });
  return data;
}

export async function reviewPayout(id, payload) {
  const { data } = await api.patch(`/admin/transactions/payouts/${id}/review`, payload);
  return data;
}
