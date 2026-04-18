export const SOUND_STORAGE_KEY = "copup_background_sound";
export const SOUND_CHANGED_EVENT = "copup:background-sound-changed";

export function getSoundEnabled() {
  return localStorage.getItem(SOUND_STORAGE_KEY) === "on";
}

export function setSoundEnabled(enabled) {
  localStorage.setItem(SOUND_STORAGE_KEY, enabled ? "on" : "off");
  window.dispatchEvent(
    new CustomEvent(SOUND_CHANGED_EVENT, {
      detail: { enabled },
    })
  );
}
