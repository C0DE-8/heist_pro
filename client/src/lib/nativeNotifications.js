import { Capacitor } from "@capacitor/core";
import { Camera, CameraResultType, CameraSource } from "@capacitor/camera";
import { LocalNotifications } from "@capacitor/local-notifications";
import { PushNotifications } from "@capacitor/push-notifications";
import { registerUserPushToken } from "./users";

const CHANNEL_ID = "copup_notices";
const NOTIFICATION_STATE_KEY = "copup_native_notice_notifications";
const PENDING_OPEN_KEY = "copup_pending_native_notice_open";
const REMINDER_DELAYS = [15 * 60 * 1000, 60 * 60 * 1000, 4 * 60 * 60 * 1000];
const PUSH_TOKEN_KEY = "copup_native_push_token";
const PUSH_REGISTERED_KEY = "copup_native_push_registered_token";

let listenersRegistered = false;
let channelReady = false;
let pushListenersRegistered = false;

export const NATIVE_NOTICE_OPEN_EVENT = "copup:native-notice-open";

export function isNativeMobile() {
  return Capacitor.isNativePlatform();
}

function readJson(key, fallback) {
  try {
    const parsed = JSON.parse(localStorage.getItem(key) || "null");
    return parsed && typeof parsed === "object" ? parsed : fallback;
  } catch {
    return fallback;
  }
}

function writeJson(key, value) {
  localStorage.setItem(key, JSON.stringify(value));
}

function hashNoticeId(value, offset = 0) {
  const text = String(value || "notice");
  let hash = 0;
  for (let index = 0; index < text.length; index += 1) {
    hash = (hash * 31 + text.charCodeAt(index)) & 0x7fffffff;
  }
  return 100000 + ((hash + offset) % 900000000);
}

function isImportantNotice(alert) {
  return [
    "winner",
    "trade_received",
    "payin_approved",
    "payout_approved",
    "admin_notice",
  ].includes(alert?.type);
}

function formatNoticeBody(alert) {
  if (alert?.type === "winner") return "You won a heist. Open CopUpBid to view the result.";
  if (alert?.type === "trade_received") return "You received CopUpCoin from another user.";
  if (alert?.type === "payin_approved") return "Your CopUpCoin pay-in has been approved.";
  if (alert?.type === "payout_approved") return "Your payout request has been approved.";
  return alert?.message || "You have a new CopUpBid notice.";
}

function notificationIdsFor(alertId) {
  const baseId = hashNoticeId(alertId);
  return [baseId, ...REMINDER_DELAYS.map((_, index) => hashNoticeId(alertId, (index + 1) * 1009))];
}

async function ensureNotificationChannel() {
  if (!isNativeMobile() || channelReady) return;

  await LocalNotifications.createChannel({
    id: CHANNEL_ID,
    name: "CopUpBid Notices",
    description: "Important CopUpBid alerts and unread notice reminders",
    importance: 5,
    visibility: 1,
    lights: true,
    lightColor: "#39D98A",
    vibration: true,
    sound: "default",
  });
  channelReady = true;
}

export async function requestNativeNotificationPermission() {
  if (!isNativeMobile()) return "web";

  const localCurrent = await LocalNotifications.checkPermissions();
  const pushCurrent = await PushNotifications.checkPermissions();

  let localStatus = localCurrent.display;
  let pushStatus = pushCurrent.receive;

  if (localStatus !== "granted") {
    localStatus = (await LocalNotifications.requestPermissions()).display;
  }

  if (pushStatus !== "granted") {
    pushStatus = (await PushNotifications.requestPermissions()).receive;
  }

  return localStatus === "granted" && pushStatus === "granted" ? "granted" : "denied";
}

export async function requestNativeMediaPermissions() {
  if (!isNativeMobile()) return { camera: "web", photos: "web" };
  return Camera.requestPermissions({ permissions: ["camera", "photos"] });
}

export async function pickNativeReceiptImage() {
  if (!isNativeMobile()) return null;

  await requestNativeMediaPermissions();

  const photo = await Camera.getPhoto({
    quality: 85,
    allowEditing: false,
    resultType: CameraResultType.Base64,
    source: CameraSource.Prompt,
    promptLabelHeader: "Receipt image",
    promptLabelPhoto: "Choose from gallery",
    promptLabelPicture: "Take photo",
  });

  if (!photo?.base64String) return null;

  const mimeType = photo.format === "png" ? "image/png" : "image/jpeg";
  const byteString = atob(photo.base64String);
  const bytes = new Uint8Array(byteString.length);
  for (let index = 0; index < byteString.length; index += 1) {
    bytes[index] = byteString.charCodeAt(index);
  }

  return new File([bytes], `receipt-${Date.now()}.${photo.format || "jpg"}`, {
    type: mimeType,
  });
}

export async function initializeNativeNoticeNotifications() {
  if (!isNativeMobile() || listenersRegistered) return;

  listenersRegistered = true;
  await ensureNotificationChannel();

  LocalNotifications.addListener("localNotificationActionPerformed", (event) => {
    const alertId = event?.notification?.extra?.alertId;
    if (!alertId) return;

    localStorage.setItem(PENDING_OPEN_KEY, String(alertId));
    window.dispatchEvent(
      new CustomEvent(NATIVE_NOTICE_OPEN_EVENT, {
        detail: { alertId },
      })
    );
  });
}

export function consumePendingNativeNoticeOpen() {
  const alertId = localStorage.getItem(PENDING_OPEN_KEY);
  if (alertId) localStorage.removeItem(PENDING_OPEN_KEY);
  return alertId;
}

function handleNotificationOpen(data = {}) {
  const alertId = data.alertId || data.alert_id;
  const path = data.path || data.url;

  if (alertId) {
    localStorage.setItem(PENDING_OPEN_KEY, String(alertId));
    window.dispatchEvent(
      new CustomEvent(NATIVE_NOTICE_OPEN_EVENT, {
        detail: { alertId },
      })
    );
  }

  if (path && typeof path === "string" && path.startsWith("/")) {
    window.location.assign(path);
  }
}

async function registerStoredPushTokenWithBackend() {
  const token = localStorage.getItem(PUSH_TOKEN_KEY);
  const authToken = localStorage.getItem("token");
  const registeredToken = localStorage.getItem(PUSH_REGISTERED_KEY);

  if (!token || !authToken || registeredToken === token) return;

  await registerUserPushToken({
    token,
    platform: Capacitor.getPlatform(),
    app_version: "android-capacitor",
  });
  localStorage.setItem(PUSH_REGISTERED_KEY, token);
}

export async function initializeNativePushNotifications() {
  if (!isNativeMobile() || pushListenersRegistered) return;

  pushListenersRegistered = true;
  await ensureNotificationChannel();

  PushNotifications.addListener("registration", async (token) => {
    localStorage.setItem(PUSH_TOKEN_KEY, token.value);
    try {
      await registerStoredPushTokenWithBackend();
    } catch (err) {
      console.warn("Push token backend registration failed:", err);
    }
  });

  PushNotifications.addListener("registrationError", (err) => {
    console.warn("Push registration failed:", err);
  });

  PushNotifications.addListener("pushNotificationReceived", async (notification) => {
    const permission = await requestNativeNotificationPermission();
    if (permission !== "granted") return;

    await LocalNotifications.schedule({
      notifications: [
        {
          id: hashNoticeId(notification.id || notification.data?.alertId || Date.now()),
          title: notification.title || "CopUpBid notice",
          body: notification.body || "You have a new CopUpBid update.",
          channelId: CHANNEL_ID,
          smallIcon: "ic_stat_copup",
          iconColor: "#39D98A",
          autoCancel: true,
          extra: notification.data || {},
        },
      ],
    });
  });

  PushNotifications.addListener("pushNotificationActionPerformed", (event) => {
    handleNotificationOpen(event.notification?.data || {});
  });

  window.addEventListener("copup:auth-changed", () => {
    registerStoredPushTokenWithBackend().catch((err) => {
      console.warn("Push token backend registration failed:", err);
    });
  });

  const permission = await requestNativeNotificationPermission();
  if (permission === "granted") {
    await PushNotifications.register();
    await registerStoredPushTokenWithBackend();
  }
}

export async function cancelNativeNoticeNotifications(alertIds) {
  if (!isNativeMobile()) return;

  const notifications = [...new Set(alertIds)].flatMap((alertId) =>
    notificationIdsFor(alertId).map((id) => ({ id }))
  );

  if (notifications.length) {
    await LocalNotifications.cancel({ notifications });
  }
}

export async function syncNativeNoticeNotifications(alerts, dismissedIds) {
  if (!isNativeMobile()) return;

  await initializeNativeNoticeNotifications();
  const permission = await requestNativeNotificationPermission();
  if (permission !== "granted") return;

  const dismissed = dismissedIds instanceof Set ? dismissedIds : new Set(dismissedIds || []);
  const unread = alerts.filter((alert) => alert?.id && !dismissed.has(alert.id));
  const unreadIds = new Set(unread.map((alert) => String(alert.id)));
  const state = readJson(NOTIFICATION_STATE_KEY, {});
  const now = Date.now();
  const notifications = [];

  Object.keys(state).forEach((alertId) => {
    if (!unreadIds.has(alertId)) delete state[alertId];
  });

  await cancelNativeNoticeNotifications(
    alerts.filter((alert) => alert?.id && dismissed.has(alert.id)).map((alert) => alert.id)
  );

  unread.forEach((alert) => {
    const alertId = String(alert.id);
    const baseId = hashNoticeId(alertId);
    const entry = state[alertId] || {};

    if (!entry.sentAt && isImportantNotice(alert)) {
      notifications.push({
        id: baseId,
        title: alert.title || "CopUpBid notice",
        body: formatNoticeBody(alert),
        largeBody: alert.message || formatNoticeBody(alert),
        summaryText: "CopUpBid",
        channelId: CHANNEL_ID,
        smallIcon: "ic_stat_copup",
        iconColor: "#39D98A",
        ongoing: false,
        autoCancel: true,
        badge: unread.length,
        extra: { alertId, type: alert.type || "notice" },
      });
      entry.sentAt = now;
    }

    if (isImportantNotice(alert)) {
      REMINDER_DELAYS.forEach((delay, index) => {
        const reminderKey = `reminder${index + 1}At`;
        if (entry[reminderKey]) return;

        notifications.push({
          id: hashNoticeId(alertId, (index + 1) * 1009),
          title: "Unread CopUpBid notice",
          body: formatNoticeBody(alert),
          largeBody: alert.message || formatNoticeBody(alert),
          summaryText: "Reminder",
          channelId: CHANNEL_ID,
          smallIcon: "ic_stat_copup",
          iconColor: "#39D98A",
          autoCancel: true,
          badge: unread.length,
          schedule: { at: new Date(now + delay), allowWhileIdle: true },
          extra: { alertId, type: alert.type || "notice", reminder: true },
        });
        entry[reminderKey] = now + delay;
      });
    }

    state[alertId] = entry;
  });

  if (notifications.length) {
    await LocalNotifications.schedule({ notifications });
  }

  writeJson(NOTIFICATION_STATE_KEY, state);
}
