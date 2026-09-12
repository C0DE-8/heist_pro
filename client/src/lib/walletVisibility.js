export const WALLET_HIDE_KEY = "copup_hide_wallet_balance";
export const WALLET_VISIBILITY_EVENT = "copup:wallet-visibility-changed";

export function isWalletHidden() {
  return localStorage.getItem(WALLET_HIDE_KEY) === "1";
}

export function setWalletHidden(hidden) {
  localStorage.setItem(WALLET_HIDE_KEY, hidden ? "1" : "0");
  window.dispatchEvent(new CustomEvent(WALLET_VISIBILITY_EVENT, { detail: { hidden } }));
}
