import { Capacitor } from "@capacitor/core";
import { StatusBar, Style } from "@capacitor/status-bar";

const STATUS_BAR_COLOR = "#070B14";

export async function configureNativeStatusBar() {
  if (!Capacitor.isNativePlatform()) return;

  try {
    await StatusBar.setOverlaysWebView({ overlay: false });
    await StatusBar.setBackgroundColor({ color: STATUS_BAR_COLOR });
    await StatusBar.setStyle({ style: Style.Dark });
    await StatusBar.show();
  } catch (err) {
    console.warn("Unable to configure native status bar:", err);
  }
}
