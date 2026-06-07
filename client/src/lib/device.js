const DEVICE_KEY = "copup_device_key";

function randomPart() {
  if (window.crypto?.randomUUID) return window.crypto.randomUUID();
  return `${Date.now().toString(36)}-${Math.random().toString(36).slice(2)}`;
}

export function getDeviceKey() {
  try {
    const existing = localStorage.getItem(DEVICE_KEY);
    if (existing) return existing;

    const platform = navigator.platform || "web";
    const screenSize = `${window.screen?.width || 0}x${window.screen?.height || 0}`;
    const timezone = Intl.DateTimeFormat().resolvedOptions().timeZone || "unknown";
    const key = `web:${platform}:${screenSize}:${timezone}:${randomPart()}`.slice(0, 128);
    localStorage.setItem(DEVICE_KEY, key);
    return key;
  } catch {
    return `web:fallback:${randomPart()}`.slice(0, 128);
  }
}
