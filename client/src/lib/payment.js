import { api } from "./api";

export async function initCopupTopup(amountNgn) {
  const { data } = await api.post("/payment/copup/init", {
    amount_ngn: amountNgn,
  });
  return data;
}
