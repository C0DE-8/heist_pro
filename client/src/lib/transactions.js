import { api } from "./api";

export async function getPaymentInfo() {
  const { data } = await api.get("/transactions/payment-info");
  return data;
}

export async function submitPayinRequest(payload) {
  const isFormData = payload instanceof FormData;
  const { data } = await api.post("/transactions/payins", payload, {
    headers: isFormData ? { "Content-Type": "multipart/form-data" } : undefined,
  });
  return data;
}

export async function getPayinRequests({ page = 1, limit = 5 } = {}) {
  const { data } = await api.get("/transactions/payins", {
    params: { page, limit },
  });
  return data;
}

export async function submitPayoutRequest(payload) {
  const { data } = await api.post("/transactions/payouts", payload);
  return data;
}

export async function getPayoutRequests({ page = 1, limit = 5 } = {}) {
  const { data } = await api.get("/transactions/payouts", {
    params: { page, limit },
  });
  return data;
}
