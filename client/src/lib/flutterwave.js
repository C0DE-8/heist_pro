import { api } from "./api";

export async function getFlutterwaveBanks() {
  const { data } = await api.get("/flutterwave/banks");
  return data;
}

export async function resolveFlutterwaveAccount(payload) {
  const { data } = await api.post("/flutterwave/resolve-account", {
    account_bank: payload?.account_bank,
    account_number: payload?.account_number,
  });
  return data;
}
