import { api } from "./api";

export async function getTradePinStatus() {
  const { data } = await api.get("/trade/pin-status");
  return data;
}

export async function updateTradePin(payload) {
  const { data } = await api.patch("/trade/pin", {
    current_pin: payload?.current_pin,
    new_pin: payload?.new_pin,
  });
  return data;
}

export async function sendCopPoints(payload) {
  const { data } = await api.post("/trade/send", {
    wallet_address: payload?.wallet_address,
    cop_points: payload?.cop_points,
    pin: payload?.pin,
    note: payload?.note,
  });
  return data;
}

export async function getTradeTransfers(params = {}) {
  const { data } = await api.get("/trade/transfers", { params });
  return data;
}
