import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import { Capacitor } from "@capacitor/core";
import App from "./App.jsx";
import { ToastProvider } from "./components/Toast/ToastContext.jsx";
import "./styles/native-safe-area.css";

if (Capacitor.isNativePlatform()) {
  document.documentElement.classList.add("capacitor-native");
}

createRoot(document.getElementById("root")).render(
  <StrictMode>
    <ToastProvider>
      <App />
    </ToastProvider>
  </StrictMode>
);
