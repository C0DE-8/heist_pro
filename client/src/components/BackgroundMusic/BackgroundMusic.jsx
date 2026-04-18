import { useEffect, useRef, useState } from "react";
import backgroundMusic from "../../assets/aud/background.aac";
import {
  getSoundEnabled,
  SOUND_CHANGED_EVENT,
  SOUND_STORAGE_KEY,
} from "../../lib/sound";

export default function BackgroundMusic() {
  const audioRef = useRef(null);
  const [enabled, setEnabled] = useState(() => getSoundEnabled());

  const playAudio = () => {
    const audio = audioRef.current;
    if (!audio) return;
    audio.volume = 0.32;
    audio.play().catch(() => {
      // Browsers can block audio until a user gesture. The next pointer/key event retries playback.
    });
  };

  useEffect(() => {
    const syncSound = (nextEnabled) => {
      setEnabled(nextEnabled);
    };

    const onSoundChanged = (event) => {
      syncSound(Boolean(event.detail?.enabled));
    };

    const onStorage = (event) => {
      if (event.key === SOUND_STORAGE_KEY) syncSound(getSoundEnabled());
    };

    window.addEventListener(SOUND_CHANGED_EVENT, onSoundChanged);
    window.addEventListener("storage", onStorage);

    return () => {
      window.removeEventListener(SOUND_CHANGED_EVENT, onSoundChanged);
      window.removeEventListener("storage", onStorage);
    };
  }, []);

  useEffect(() => {
    const audio = audioRef.current;
    if (!audio) return;

    audio.volume = 0.32;

    if (!enabled) {
      audio.pause();
      return;
    }

    playAudio();
  }, [enabled]);

  useEffect(() => {
    if (!enabled) return undefined;

    const retryPlayback = () => playAudio();

    window.addEventListener("pointerdown", retryPlayback, { once: true });
    window.addEventListener("keydown", retryPlayback, { once: true });

    return () => {
      window.removeEventListener("pointerdown", retryPlayback);
      window.removeEventListener("keydown", retryPlayback);
    };
  }, [enabled]);

  return (
    <audio
      ref={audioRef}
      src={backgroundMusic}
      loop
      preload="auto"
      aria-hidden="true"
    />
  );
}
