import { registerUserPushToken } from "./users";

const FIREBASE_APP_URL = "https://www.gstatic.com/firebasejs/10.13.2/firebase-app.js";
const FIREBASE_MESSAGING_URL = "https://www.gstatic.com/firebasejs/10.13.2/firebase-messaging.js";
const WEB_PUSH_REGISTERED_KEY = "copup_web_push_registered_token";
const SERVICE_WORKER_PATH = "/firebase-messaging-sw.js";

let firebaseModulesPromise = null;

function getFirebaseConfig() {
  return {
    apiKey: import.meta.env.VITE_FIREBASE_API_KEY,
    authDomain: import.meta.env.VITE_FIREBASE_AUTH_DOMAIN,
    projectId: import.meta.env.VITE_FIREBASE_PROJECT_ID,
    messagingSenderId: import.meta.env.VITE_FIREBASE_MESSAGING_SENDER_ID,
    appId: import.meta.env.VITE_FIREBASE_APP_ID,
  };
}

function hasFirebaseConfig() {
  const config = getFirebaseConfig();
  return Object.values(config).every(Boolean) && Boolean(import.meta.env.VITE_FIREBASE_VAPID_KEY);
}

function isSupportedBrowser() {
  return (
    typeof window !== "undefined" &&
    "Notification" in window &&
    "serviceWorker" in navigator &&
    window.isSecureContext
  );
}

async function loadFirebaseModules() {
  if (!firebaseModulesPromise) {
    firebaseModulesPromise = Promise.all([
      import(/* @vite-ignore */ FIREBASE_APP_URL),
      import(/* @vite-ignore */ FIREBASE_MESSAGING_URL),
    ]);
  }

  const [appModule, messagingModule] = await firebaseModulesPromise;
  return { appModule, messagingModule };
}

function getStatusLabel(permission) {
  if (!isSupportedBrowser()) return "unsupported";
  if (!hasFirebaseConfig()) return "not_configured";
  return permission || Notification.permission;
}

export function getWebPushStatus() {
  return getStatusLabel();
}

export function canUseWebPush() {
  return isSupportedBrowser() && hasFirebaseConfig();
}

export async function enableWebPushNotifications() {
  if (!isSupportedBrowser()) {
    throw new Error("This browser does not support web push notifications.");
  }

  if (!hasFirebaseConfig()) {
    throw new Error("Firebase web push is not configured.");
  }

  const permission = await Notification.requestPermission();
  if (permission !== "granted") {
    throw new Error("Notification permission was not granted.");
  }

  const serviceWorkerUrl = new URL(SERVICE_WORKER_PATH, window.location.origin);
  Object.entries(getFirebaseConfig()).forEach(([key, value]) => {
    serviceWorkerUrl.searchParams.set(key, value);
  });

  const registration = await navigator.serviceWorker.register(serviceWorkerUrl.toString());
  await navigator.serviceWorker.ready;

  const { appModule, messagingModule } = await loadFirebaseModules();
  const app = appModule.getApps().length
    ? appModule.getApps()[0]
    : appModule.initializeApp(getFirebaseConfig());
  const messaging = messagingModule.getMessaging(app);
  const token = await messagingModule.getToken(messaging, {
    vapidKey: import.meta.env.VITE_FIREBASE_VAPID_KEY,
    serviceWorkerRegistration: registration,
  });

  if (!token) {
    throw new Error("Unable to create browser notification token.");
  }

  const registeredToken = localStorage.getItem(WEB_PUSH_REGISTERED_KEY);
  if (registeredToken !== token) {
    await registerUserPushToken({
      token,
      platform: "web",
      app_version: "web-browser",
    });
    localStorage.setItem(WEB_PUSH_REGISTERED_KEY, token);
  }

  return token;
}
