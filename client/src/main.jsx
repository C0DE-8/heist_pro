import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import { Capacitor } from "@capacitor/core";
import App from "./App.jsx";
import { ToastProvider } from "./components/Toast/ToastContext.jsx";
import { configureNativeStatusBar } from "./lib/nativeStatusBar.js";
import { initializeNativePushNotifications } from "./lib/nativeNotifications.js";
import "./styles/native-safe-area.css";

if (Capacitor.isNativePlatform()) {
  document.documentElement.classList.add("capacitor-native");
  configureNativeStatusBar();
  initializeNativePushNotifications();
}

createRoot(document.getElementById("root")).render(
  <StrictMode>
    <ToastProvider>
      <App />
    </ToastProvider>
  </StrictMode>
);
