import React, { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { FiArrowLeft } from "react-icons/fi";
import Header from "../../components/Header/Header";
import Footer from "../../components/Footer/Footer";
import { useToast } from "../../components/Toast/ToastContext";
import {
  getHeistPlay,
  getHeistResult,
  startHeist,
  submitHeistAnswers,
} from "../../lib/heists";
import styles from "./HeistPlay.module.css";

function formatNum(value) {
  const n = Number(value);
  return Number.isFinite(n) ? n.toLocaleString() : "0";
}

function getStoredUserId() {
  try {
    const raw = localStorage.getItem("user");
    if (!raw) return "guest";
    const user = JSON.parse(raw);
    return user?.id || user?.userId || "guest";
  } catch {
    return "guest";
  }
}

function getAttemptStorageKey(heistId) {
  return `copup_heist_attempt_${getStoredUserId()}_${heistId}`;
}

function readStoredAttempt(heistId) {
  try {
    const raw = localStorage.getItem(getAttemptStorageKey(heistId));
    return raw ? JSON.parse(raw) : null;
  } catch {
    return null;
  }
}

function writeStoredAttempt(heistId, attempt) {
  try {
    localStorage.setItem(getAttemptStorageKey(heistId), JSON.stringify(attempt));
  } catch {
    // Local storage can fail in private browsing or full quota. Gameplay still continues in memory.
  }
}

function clearStoredAttempt(heistId) {
  try {
    localStorage.removeItem(getAttemptStorageKey(heistId));
  } catch {
    // Ignore storage cleanup failures.
  }
}

function wait(ms) {
  return new Promise((resolve) => window.setTimeout(resolve, ms));
}

function clampNumber(value, min, max) {
  return Math.max(min, Math.min(max, value));
}

function makeRadialSprite(size, stops) {
  const canvas = document.createElement("canvas");
  canvas.width = size;
  canvas.height = size;
  const ctx = canvas.getContext("2d");
  const gradient = ctx.createRadialGradient(
    size * 0.5,
    size * 0.5,
    0,
    size * 0.5,
    size * 0.5,
    size * 0.5
  );

  stops.forEach(([offset, color]) => gradient.addColorStop(offset, color));
  ctx.fillStyle = gradient;
  ctx.beginPath();
  ctx.arc(size * 0.5, size * 0.5, size * 0.5, 0, Math.PI * 2);
  ctx.fill();
  return canvas;
}

const burnAssets = (() => {
  let cached = null;
  return () => {
    if (cached) return cached;
    cached = {
      smoke: makeRadialSprite(128, [
        [0, "rgba(150,150,150,0.22)"],
        [0.45, "rgba(95,95,95,0.12)"],
        [1, "rgba(30,30,30,0)"],
      ]),
      ember: makeRadialSprite(96, [
        [0, "rgba(255,242,180,1)"],
        [0.25, "rgba(255,170,72,0.92)"],
        [0.68, "rgba(255,90,20,0.28)"],
        [1, "rgba(255,60,10,0)"],
      ]),
    };
    return cached;
  };
})();

function smoothstep(t) {
  return t * t * (3 - 2 * t);
}

function lerp(a, b, t) {
  return a + (b - a) * t;
}

function rand(min, max) {
  return min + Math.random() * (max - min);
}

function makeValueNoise2D(width, height, cell) {
  const gridWidth = Math.ceil(width / cell) + 3;
  const gridHeight = Math.ceil(height / cell) + 3;
  const grid = new Float32Array(gridWidth * gridHeight);
  const out = new Float32Array(width * height);

  for (let i = 0; i < grid.length; i += 1) grid[i] = Math.random() * 2 - 1;

  for (let y = 0; y < height; y += 1) {
    const gy = y / cell;
    const iy = Math.floor(gy);
    const ty = smoothstep(gy - iy);

    for (let x = 0; x < width; x += 1) {
      const gx = x / cell;
      const ix = Math.floor(gx);
      const tx = smoothstep(gx - ix);
      const a = lerp(grid[iy * gridWidth + ix], grid[iy * gridWidth + ix + 1], tx);
      const b = lerp(grid[(iy + 1) * gridWidth + ix], grid[(iy + 1) * gridWidth + ix + 1], tx);
      out[y * width + x] = lerp(a, b, ty);
    }
  }

  return out;
}

function makeValueNoise1D(width, cell) {
  const gridWidth = Math.ceil(width / cell) + 3;
  const grid = new Float32Array(gridWidth);
  const out = new Float32Array(width);

  for (let i = 0; i < grid.length; i += 1) grid[i] = Math.random() * 2 - 1;

  for (let x = 0; x < width; x += 1) {
    const gx = x / cell;
    const ix = Math.floor(gx);
    const tx = smoothstep(gx - ix);
    out[x] = lerp(grid[ix], grid[ix + 1], tx);
  }

  return out;
}

function makeBurnAnimator(sourceCanvas, targetCanvas) {
  const ctx = targetCanvas.getContext("2d", { alpha: true, desynchronized: true });
  const width = sourceCanvas.width;
  const height = sourceCanvas.height;
  const sourceCtx = sourceCanvas.getContext("2d", { alpha: true });
  const sourcePixels = sourceCtx.getImageData(0, 0, width, height).data;
  const frameImageData = ctx.createImageData(width, height);
  const framePixels = frameImageData.data;
  const { smoke: smokeSprite, ember: emberGlowSprite } = burnAssets();
  const frontierMap = new Float32Array(width);

  let progress = 0;
  let burning = true;
  let done = false;
  let lastTime = 0;
  let floatT = 0;
  let embers = [];
  let smoke = [];
  let noiseCombined = null;
  let columnNoiseA = null;
  let columnNoiseB = null;
  let profile = null;

  function buildProfile() {
    profile = {
      largeAmp: rand(18, 34),
      mainAmp: rand(10, 20),
      detailAmp: rand(4, 11),
      edgeAmpA: rand(5, 18),
      edgeAmpB: rand(3, 12),
      edgeAmpC: rand(2, 8),
      freqA: rand(0.03, 0.085),
      freqB: rand(0.01, 0.032),
      freqC: rand(0.09, 0.22),
      speedA: rand(0.003, 0.008),
      speedB: rand(0.0016, 0.0048),
      speedC: rand(0.008, 0.02),
      phaseA: rand(0, Math.PI * 2),
      phaseB: rand(0, Math.PI * 2),
      phaseC: rand(0, Math.PI * 2),
      columnAmpA: rand(12, 28),
      columnAmpB: rand(8, 18),
      slant: rand(-0.18, 0.18),
      bow: rand(-20, 20),
      glowBand: rand(14, 22),
      charBand: rand(28, 42),
      emberBurst: rand(0.85, 1.35),
      flameBoost: rand(0.9, 1.35),
    };

    const noiseLarge = makeValueNoise2D(width, height, rand(46, 70));
    const noiseMain = makeValueNoise2D(width, height, rand(22, 38));
    const noiseDetail = makeValueNoise2D(width, height, rand(8, 16));
    noiseCombined = new Float32Array(width * height);

    for (let i = 0; i < noiseCombined.length; i += 1) {
      noiseCombined[i] =
        noiseLarge[i] * profile.largeAmp +
        noiseMain[i] * profile.mainAmp +
        noiseDetail[i] * profile.detailAmp;
    }

    columnNoiseA = makeValueNoise1D(width, rand(18, 34));
    columnNoiseB = makeValueNoise1D(width, rand(42, 76));
  }

  function getFrontierY(x, t) {
    const nx = x / (width - 1);
    const center = nx - 0.5;
    const base = height + 44 - progress * (height + 92);
    const slant = center * profile.slant * height;
    const bow = profile.bow * (1 - Math.abs(center) * 2);
    const wobbleA = Math.sin(t * profile.speedA + x * profile.freqA + profile.phaseA) * profile.edgeAmpA;
    const wobbleB = Math.sin(t * profile.speedB + x * profile.freqB + profile.phaseB) * profile.edgeAmpB;
    const wobbleC = Math.sin(t * profile.speedC + x * profile.freqC + profile.phaseC) * profile.edgeAmpC;
    return (
      base +
      slant +
      bow +
      wobbleA +
      wobbleB +
      wobbleC +
      columnNoiseA[x] * profile.columnAmpA +
      columnNoiseB[x] * profile.columnAmpB
    );
  }

  function updateFrontierMap(t) {
    for (let x = 0; x < width; x += 1) frontierMap[x] = getFrontierY(x, t);
  }

  function spawnParticles() {
    if (!burning || done) return;
    const count = Math.max(3, Math.round((4 + progress * 5) * profile.emberBurst));

    for (let i = 0; i < count; i += 1) {
      const x = Math.random() * width;
      const y = frontierMap[x | 0];
      if (y < -15 || y > height + 10) continue;

      embers.push({
        x: x + (Math.random() - 0.5) * 6,
        y: y + (Math.random() - 0.5) * 4,
        vx: (Math.random() - 0.5) * 0.75,
        vy: -0.8 - Math.random() * 2.3,
        size: 1 + Math.random() * 2.2,
        life: 20 + Math.random() * 24,
        maxLife: 20 + Math.random() * 24,
        glow: Math.random() * 0.6 + 0.4,
      });

      if (Math.random() < 0.14) {
        smoke.push({
          x: x + (Math.random() - 0.5) * 8,
          y: y - 2,
          vx: (Math.random() - 0.5) * 0.28,
          vy: -0.15 - Math.random() * 0.45,
          size: 7 + Math.random() * 8,
          grow: 0.1 + Math.random() * 0.15,
          life: 24 + Math.random() * 30,
          maxLife: 24 + Math.random() * 30,
        });
      }
    }
  }

  function updateParticles(dt) {
    const step = dt * 0.06;
    for (let i = embers.length - 1; i >= 0; i -= 1) {
      const p = embers[i];
      p.x += p.vx * step;
      p.y += p.vy * step;
      p.vy += 0.01 * step;
      p.life -= step;
      if (p.life <= 0) embers.splice(i, 1);
    }
    for (let i = smoke.length - 1; i >= 0; i -= 1) {
      const p = smoke[i];
      p.x += p.vx * step;
      p.y += p.vy * step;
      p.size += p.grow * step;
      p.life -= step;
      if (p.life <= 0) smoke.splice(i, 1);
    }
  }

  function renderBurnFrame() {
    framePixels.fill(0);

    for (let y = 0; y < height; y += 1) {
      const row = y * width;
      for (let x = 0; x < width; x += 1) {
        const pixelIndex = row + x;
        const i = pixelIndex * 4;
        const alpha = sourcePixels[i + 3];
        if (alpha === 0) continue;

        const field = y - frontierMap[x] + noiseCombined[pixelIndex];
        if (field > 0) continue;

        let r = sourcePixels[i];
        let g = sourcePixels[i + 1];
        let b = sourcePixels[i + 2];
        let a = alpha;

        if (field > -profile.glowBand) {
          const edge = 1 - clampNumber(-field / profile.glowBand, 0, 1);
          const glow = Math.pow(edge, 0.85);
          r = r * (1 - glow * 0.82) + 255 * glow * 0.95;
          g = g * (1 - glow * 0.88) + 138 * glow * 0.55;
          b = b * (1 - glow * 0.95) + 34 * glow * 0.18;
          a *= 1 - glow * 0.15;
        } else if (field > -profile.charBand) {
          const charAmt = 1 - clampNumber(((-field) - profile.glowBand) / (profile.charBand - profile.glowBand), 0, 1);
          r *= 1 - charAmt * 0.18;
          g *= 1 - charAmt * 0.22;
          b *= 1 - charAmt * 0.28;
        }

        framePixels[i] = r;
        framePixels[i + 1] = g;
        framePixels[i + 2] = b;
        framePixels[i + 3] = a;
      }
    }

    ctx.clearRect(0, 0, width, height);
    ctx.putImageData(frameImageData, 0, 0);
  }

  function drawSmoke() {
    ctx.save();
    ctx.globalCompositeOperation = "source-over";
    smoke.forEach((p) => {
      const alpha = clampNumber(p.life / p.maxLife, 0, 1) * 0.7;
      const d = p.size * 2;
      ctx.globalAlpha = alpha;
      ctx.drawImage(smokeSprite, p.x - p.size, p.y - p.size, d, d);
    });
    ctx.restore();
    ctx.globalAlpha = 1;
  }

  function drawEmbers() {
    ctx.save();
    ctx.globalCompositeOperation = "screen";
    embers.forEach((p) => {
      const life = clampNumber(p.life / p.maxLife, 0, 1);
      const glow = p.size * (2.2 + p.glow * 1.5);
      const d = glow * 2;
      ctx.globalAlpha = life * 0.95;
      ctx.drawImage(emberGlowSprite, p.x - glow, p.y - glow, d, d);
      ctx.globalAlpha = life * 0.85;
      ctx.fillStyle = "rgba(255,245,220,1)";
      ctx.beginPath();
      ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2);
      ctx.fill();
    });
    ctx.restore();
    ctx.globalAlpha = 1;
  }

  function drawFlameFront(t) {
    if (progress <= 0 || done) return;

    ctx.save();
    ctx.globalCompositeOperation = "screen";
    ctx.beginPath();
    ctx.moveTo(0, frontierMap[0]);
    for (let x = 8; x <= width; x += 8) ctx.lineTo(x, frontierMap[Math.min(width - 1, x)]);

    ctx.lineWidth = 16;
    ctx.strokeStyle = "rgba(255, 94, 26, 0.14)";
    ctx.shadowBlur = 18;
    ctx.shadowColor = "rgba(255, 94, 26, 0.34)";
    ctx.stroke();

    ctx.beginPath();
    ctx.moveTo(0, frontierMap[0]);
    for (let x = 8; x <= width; x += 8) ctx.lineTo(x, frontierMap[Math.min(width - 1, x)]);
    ctx.lineWidth = 6;
    ctx.strokeStyle = "rgba(255, 182, 73, 0.38)";
    ctx.shadowBlur = 10;
    ctx.shadowColor = "rgba(255, 174, 51, 0.28)";
    ctx.stroke();
    ctx.shadowBlur = 0;

    for (let x = 0; x < width; x += 24) {
      const y = frontierMap[x];
      if (y < -20 || y > height + 10) continue;
      const flameH = (
        8 +
        (Math.sin(t * 0.02 + x * 0.31 + profile.phaseA) * 0.5 + 0.5) * 12 +
        progress * 8
      ) * profile.flameBoost;
      const flameW = 5 + (Math.sin(t * 0.017 + x * 0.12 + profile.phaseB) * 0.5 + 0.5) * 4;

      ctx.fillStyle = "rgba(255, 128, 46, 0.34)";
      ctx.beginPath();
      ctx.moveTo(x - flameW, y + 2);
      ctx.quadraticCurveTo(x - flameW * 0.2, y - flameH * 0.6, x, y - flameH);
      ctx.quadraticCurveTo(x + flameW * 0.2, y - flameH * 0.55, x + flameW, y + 2);
      ctx.closePath();
      ctx.fill();
    }

    ctx.restore();
  }

  return {
    start() {
      buildProfile();
      return new Promise((resolve) => {
        function loop(now) {
          const dt = Math.min(32, now - lastTime || 16.67);
          lastTime = now;
          floatT += dt;

          if (burning && !done) {
            progress += dt * 0.00142;
            if (progress >= 1.08) {
              progress = 1.08;
              burning = false;
              done = true;
            }
          }

          updateFrontierMap(floatT);
          spawnParticles();
          updateParticles(dt);
          renderBurnFrame();
          drawSmoke();
          drawFlameFront(floatT);
          drawEmbers();

          if (burning || embers.length > 0 || smoke.length > 0) {
            requestAnimationFrame(loop);
          } else {
            ctx.clearRect(0, 0, width, height);
            resolve();
          }
        }

        lastTime = performance.now();
        requestAnimationFrame(loop);
      });
    },
  };
}

function drawBurnSourceCard(canvas, { answer, questionNumber }) {
  const ctx = canvas.getContext("2d", { alpha: true });
  const width = canvas.width;
  const height = canvas.height;
  const isTrue = answer === "true";

  ctx.clearRect(0, 0, width, height);
  const bg = ctx.createLinearGradient(0, 0, 0, height);
  bg.addColorStop(0, isTrue ? "rgba(22, 78, 71, 0.98)" : "rgba(76, 32, 48, 0.98)");
  bg.addColorStop(1, "rgba(10, 13, 28, 0.98)");
  ctx.fillStyle = bg;
  ctx.roundRect(0, 0, width, height, 28);
  ctx.fill();

  ctx.strokeStyle = "rgba(255,255,255,0.18)";
  ctx.lineWidth = 2;
  ctx.stroke();

  ctx.fillStyle = isTrue ? "rgba(97,246,181,0.16)" : "rgba(255,122,145,0.16)";
  ctx.beginPath();
  ctx.arc(width * 0.78, height * 0.24, 96, 0, Math.PI * 2);
  ctx.fill();

  ctx.fillStyle = "rgba(255,255,255,0.88)";
  ctx.font = "900 34px Inter, system-ui, sans-serif";
  ctx.fillText(isTrue ? "T" : "F", 28, 50);
  ctx.save();
  ctx.translate(width - 28, height - 22);
  ctx.rotate(Math.PI);
  ctx.fillText(isTrue ? "T" : "F", 0, 0);
  ctx.restore();

  ctx.textAlign = "center";
  ctx.textBaseline = "middle";
  ctx.font = "900 150px Inter, system-ui, sans-serif";
  ctx.fillStyle = isTrue ? "rgba(97,246,181,0.18)" : "rgba(255,122,145,0.18)";
  ctx.fillText(isTrue ? "✓" : "×", width / 2, height / 2);

  ctx.textAlign = "left";
  ctx.textBaseline = "alphabetic";
  ctx.fillStyle = "rgba(255,255,255,0.88)";
  ctx.font = "900 42px Inter, system-ui, sans-serif";
  ctx.fillText(isTrue ? "TRUE" : "FALSE", 28, height - 112);

  ctx.fillStyle = "rgba(170,179,217,0.9)";
  ctx.font = "500 22px Inter, system-ui, sans-serif";
  ctx.fillText(isTrue ? "Trust the statement." : "Call the statement wrong.", 28, height - 76);

  ctx.fillStyle = "rgba(255,214,103,0.95)";
  ctx.font = "800 19px Inter, system-ui, sans-serif";
  ctx.fillText(`Question ${questionNumber}`, 28, height - 34);
}

export default function HeistPlay() {
  const { id } = useParams();
  const navigate = useNavigate();
  const toast = useToast();

  const [payload, setPayload] = useState(null);
  const [previousResult, setPreviousResult] = useState(null);
  const [submissionId, setSubmissionId] = useState(null);
  const [questionStartedAt, setQuestionStartedAt] = useState(null);
  const [currentIndex, setCurrentIndex] = useState(0);
  const [answerList, setAnswerList] = useState([]);
  const [selectedAnswer, setSelectedAnswer] = useState("");
  const [animatingSide, setAnimatingSide] = useState("");
  const [effectKey, setEffectKey] = useState(0);
  const [burningAnswer, setBurningAnswer] = useState("");
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");
  const burnCanvasRefs = useRef({});
  const restoreCheckedRef = useRef(false);

  const questions = useMemo(
    () => (Array.isArray(payload?.questions) ? payload.questions : []),
    [payload]
  );
  const heist = payload?.heist || null;
  const currentQuestion = questions[currentIndex] || null;
  const answeredCount = answerList.length;
  const progressPct = questions.length
    ? Math.min(100, Math.round((answeredCount / questions.length) * 100))
    : 0;
  const isComplete = questions.length > 0 && answeredCount >= questions.length;
  const hasSubmittedAttempt = Boolean(previousResult?.result);
  const entryFee = heist?.ticket_price;

  const loadPlay = useCallback(async () => {
    setLoading(true);
    setError("");

    try {
      const data = await getHeistPlay(id);
      setPayload(data);

      try {
        const resultData = await getHeistResult(id);
        setPreviousResult(resultData || null);
      } catch (resultErr) {
        if (resultErr?.response?.status !== 404) {
          console.warn("Previous heist result check failed:", resultErr);
        }
        setPreviousResult(null);
      }
    } catch (err) {
      console.error("Load heist play error:", err);
      const message = err?.response?.data?.message || "Unable to load heist.";
      if (err?.response?.status === 400 && /closed|ended/i.test(message)) {
        try {
          const resultData = await getHeistResult(id);
          if (resultData?.result) {
            navigate(`/heist/${id}/result`, { replace: true });
            return;
          }
        } catch (resultErr) {
          if (resultErr?.response?.status !== 404) {
            console.warn("Closed heist result check failed:", resultErr);
          }
        }
        setError("This heist is closed. No more play or retries are allowed.");
      } else {
        setError(message);
      }
    } finally {
      setLoading(false);
    }
  }, [id, navigate]);

  useEffect(() => {
    loadPlay();
  }, [loadPlay]);

  useEffect(() => {
    restoreCheckedRef.current = false;
    setSubmissionId(null);
    setQuestionStartedAt(null);
    setCurrentIndex(0);
    setAnswerList([]);
    setSelectedAnswer("");
    setAnimatingSide("");
    setBurningAnswer("");
  }, [id]);

  useEffect(() => {
    if (loading || restoreCheckedRef.current || !questions.length || hasSubmittedAttempt) return;

    restoreCheckedRef.current = true;
    const storedAttempt = readStoredAttempt(id);
    if (!storedAttempt?.submissionId) return;

    const validQuestionIds = new Set(questions.map((question) => Number(question.id)));
    const restoredAnswers = Array.isArray(storedAttempt.answerList)
      ? storedAttempt.answerList.filter((item) => {
          const questionId = Number(item?.question_id);
          const answer = item?.answer;
          const seconds = Number(item?.time_spent_seconds);
          return (
            validQuestionIds.has(questionId) &&
            (answer === "true" || answer === "false") &&
            Number.isFinite(seconds) &&
            seconds >= 0
          );
        })
      : [];

    const storedIndex = Number(storedAttempt.currentIndex);
    const restoredIndex = Math.min(restoredAnswers.length, questions.length);
    const restoredStartedAt = Number(storedAttempt.questionStartedAt);
    const shouldRestartQuestionClock =
      Number.isFinite(storedIndex) && restoredAnswers.length > storedIndex;

    setSubmissionId(storedAttempt.submissionId);
    setAnswerList(restoredAnswers);
    setCurrentIndex(restoredIndex);
    setQuestionStartedAt(
      !shouldRestartQuestionClock && Number.isFinite(restoredStartedAt)
        ? restoredStartedAt
        : Date.now()
    );
    setSelectedAnswer("");
    setAnimatingSide("");
    setBurningAnswer("");

    toast.info("Your heist attempt was restored.");
  }, [hasSubmittedAttempt, id, loading, questions, toast]);

  useEffect(() => {
    if (!submissionId) return;

    writeStoredAttempt(id, {
      heistId: id,
      submissionId,
      answerList,
      currentIndex,
      questionStartedAt: questionStartedAt || Date.now(),
      savedAt: Date.now(),
    });
  }, [answerList, currentIndex, id, questionStartedAt, submissionId]);

  useEffect(() => {
    if (hasSubmittedAttempt) clearStoredAttempt(id);
  }, [hasSubmittedAttempt, id]);

  const begin = async () => {
    if (submissionId || saving) return;
    if (hasSubmittedAttempt) {
      navigate(`/heist/${id}/result`);
      return;
    }

    setSaving(true);
    try {
      const data = await startHeist(id);
      clearStoredAttempt(id);
      setSubmissionId(data?.submission_id);
      setQuestionStartedAt(Date.now());
      setCurrentIndex(0);
      setAnswerList([]);
      setSelectedAnswer("");
      setAnimatingSide("");
      setBurningAnswer("");
      toast.success("Heist started");
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to start heist.");
    } finally {
      setSaving(false);
    }
  };

  const burnAwayAnswerCard = async (answer, questionNumber) => {
    const canvas = burnCanvasRefs.current[answer];
    if (!canvas) return;

    const sourceCanvas = document.createElement("canvas");
    sourceCanvas.width = 360;
    sourceCanvas.height = 504;
    drawBurnSourceCard(sourceCanvas, { answer, questionNumber });

    canvas.width = sourceCanvas.width;
    canvas.height = sourceCanvas.height;
    const ctx = canvas.getContext("2d", { alpha: true });
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.drawImage(sourceCanvas, 0, 0);
    canvas.style.opacity = "1";

    await new Promise((resolve) => requestAnimationFrame(resolve));
    await makeBurnAnimator(sourceCanvas, canvas).start();
    canvas.style.opacity = "0";
  };

  const chooseAnswer = async (answer) => {
    if (!submissionId) {
      toast.info("Start the heist first.");
      return;
    }
    if (!currentQuestion || selectedAnswer || isComplete) return;

    const now = Date.now();
    const timeSpent = questionStartedAt
      ? Math.max(1, Math.round((now - questionStartedAt) / 1000))
      : 1;

    setSelectedAnswer(answer);
    setAnimatingSide(answer);
    setEffectKey((prev) => prev + 1);
    const otherAnswer = answer === "true" ? "false" : "true";
    setBurningAnswer(otherAnswer);
    setAnswerList((prev) => [
      ...prev,
      {
        question_id: currentQuestion.id,
        answer,
        time_spent_seconds: timeSpent,
      },
    ]);

    await Promise.all([burnAwayAnswerCard(otherAnswer, currentIndex + 1), wait(620)]);
    setSelectedAnswer("");
    setAnimatingSide("");
    setBurningAnswer("");
    setCurrentIndex((prev) => Math.min(prev + 1, questions.length));
    setQuestionStartedAt(Date.now());
  };

  const submit = async () => {
    if (!submissionId || saving || !isComplete) return;

    setSaving(true);
    try {
      await submitHeistAnswers(id, {
        submission_id: submissionId,
        answers: answerList,
      });

      clearStoredAttempt(id);
      toast.success("Heist submitted");
      navigate(`/heist/${id}/result`);
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to submit answers.");
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className={`${styles.page} ${styles.playPage}`}>
      <Header />

      <main className={`${styles.main} ${styles.playMain}`}>
        <button type="button" className={styles.backBtn} onClick={() => navigate("/heist")}>
          <FiArrowLeft />
          <span>Heists</span>
        </button>

        <section className={styles.gameHud}>
          <button type="button" className={styles.avatarBtn} onClick={() => navigate("/heist")}>
            <span className={styles.avatarFace}>H</span>
              <span className={styles.avatarMeta}>
                <span className={styles.avatarName}>{heist?.name || "Heist"}</span>
              <span className={styles.avatarSub}>
                Question arena
              </span>
              </span>
            </button>

          <div className={styles.hudStats}>
            <div className={`${styles.hudPill} ${styles.prizePill}`}>
              Prize <strong>{formatNum(heist?.prize_cop_points)} CP</strong>
            </div>
            <div className={`${styles.hudPill} ${styles.coinPill}`}>
              Ticket <strong>{formatNum(entryFee)} CP</strong>
            </div>
            <div className={`${styles.hudPill} ${styles.questionPill}`}>
              Questions <strong>{formatNum(answeredCount)} / {formatNum(questions.length)}</strong>
            </div>
          </div>
        </section>

        <section className={styles.battlePanel}>
          <div className={styles.scene}>
            <div className={styles.stars} />
            <div className={styles.starDrift} />
            <div className={styles.mist} />
            <div className={`${styles.trees} ${styles.far}`} />
            <div className={`${styles.trees} ${styles.mid}`} />
            <div className={`${styles.trees} ${styles.near}`} />
            <div className={styles.path} />
            <div className={styles.ground} />
            <div className={styles.sparkLayer} aria-hidden="true">
              <span className={`${styles.spark} ${styles.sparkOne}`} />
              <span className={`${styles.spark} ${styles.sparkTwo}`} />
              <span className={`${styles.spark} ${styles.sparkThree}`} />
              <span className={`${styles.spark} ${styles.sparkFour}`} />
            </div>

            <div className={styles.enemyMini}>
              <div className={styles.enemyMiniTrack}>
                <div className={styles.enemyMiniFill} style={{ width: `${progressPct}%` }} />
              </div>
            </div>

            <div className={`${styles.sceneCornerName} ${styles.playerCorner}`}>You</div>
            <div className={`${styles.sceneCornerName} ${styles.enemyCorner}`}>Question {Math.min(currentIndex + 1, questions.length || 1)}</div>

            <div
              className={`${styles.fighter} ${styles.playerFighter} ${
                animatingSide === "true" ? styles.attacking : ""
              }`}
            >
              <div className={styles.sprite}>✓</div>
            </div>

            <div
              className={`${styles.fighter} ${styles.enemyFighter} ${
                animatingSide === "false" ? styles.attacking : ""
              }`}
            >
              <div className={styles.sprite}>×</div>
            </div>

            {selectedAnswer ? (
              <React.Fragment key={effectKey}>
                <div
                  className={`${styles.burstRing} ${
                    selectedAnswer === "true" ? styles.playerBurst : styles.enemyBurst
                  }`}
                />
                <div
                  className={`${styles.attackEffect} ${
                    selectedAnswer === "true" ? styles.playerEffect : styles.enemyEffect
                  } ${styles.showEffect}`}
                >
                  {selectedAnswer === "true" ? "TRUE" : "FALSE"}
                </div>
              </React.Fragment>
            ) : null}
          </div>
        </section>

        {error ? (
          <div className={styles.errorBox}>
            <span>{error}</span>
            <button type="button" onClick={loadPlay}>
              Retry
            </button>
          </div>
        ) : null}

        <section className={styles.gamePanel}>
          <div className={styles.promptHead}>
            <div>
              <h2 className={styles.promptTitle}>
                {loading
                  ? "Loading..."
                  : isComplete
                    ? "Ready to submit"
                    : currentQuestion?.question_text || "No active question"}
              </h2>
              <p className={styles.promptCopy}>
                {submissionId
                  ? isComplete
                    ? "Submit your run to lock your leaderboard result."
                    : "Pick true or false."
                  : hasSubmittedAttempt
                    ? "You already submitted this heist. View your result."
                    : "Start the heist to unlock the cards."}
              </p>
            </div>
          </div>

          {!submissionId ? (
            <div className={`${styles.cardGrid} ${styles.twoCard}`}>
              <button
                type="button"
                className={`${styles.playCard} ${styles.trueCard}`}
                onClick={begin}
                disabled={loading || saving || (!hasSubmittedAttempt && !questions.length)}
                style={{ "--tilt": "-1.5deg" }}
              >
                <span className={styles.cardCorner}>{hasSubmittedAttempt ? "DONE" : "GO"}</span>
                <span className={`${styles.cardCorner} ${styles.bottom}`}>
                  {hasSubmittedAttempt ? "DONE" : "GO"}
                </span>
                <span className={styles.cardGlyph}>▶</span>
                <div className={styles.cardBody}>
                  <span className={styles.cardTag}>
                    {hasSubmittedAttempt ? "Result" : "Start"}
                  </span>
                  <h4 className={styles.cardTitle}>
                    {saving
                      ? "Starting..."
                      : hasSubmittedAttempt
                        ? "View Result"
                        : "Begin Heist"}
                  </h4>
                  <p className={styles.cardCopy}>
                    {hasSubmittedAttempt
                      ? "Retries are not available for heists."
                      : "Create your attempt and start the clock."}
                  </p>
                  <span className={styles.cardPrice}>
                    {hasSubmittedAttempt ? "Submitted" : `${formatNum(entryFee)} CP ticket`}
                  </span>
                </div>
              </button>

              {hasSubmittedAttempt ? (
                <button
                  type="button"
                  className={`${styles.playCard} ${styles.falseCard}`}
                  onClick={() => navigate(`/heist/${id}/leaderboard`)}
                  disabled={loading || saving}
                  style={{ "--tilt": "1.5deg" }}
                >
                  <span className={styles.cardCorner}>RANK</span>
                  <span className={`${styles.cardCorner} ${styles.bottom}`}>RANK</span>
                  <span className={styles.cardGlyph}>#</span>
                  <div className={styles.cardBody}>
                    <span className={styles.cardTag}>Leaderboard</span>
                    <h4 className={styles.cardTitle}>View Ranks</h4>
                    <p className={styles.cardCopy}>Open the heist leaderboard and compare runs.</p>
                    <span className={styles.cardPrice}>Correct, time, submitted</span>
                  </div>
                </button>
              ) : null}
            </div>
          ) : isComplete ? (
            <div className={`${styles.cardGrid} ${styles.twoCard}`}>
              <button
                type="button"
                className={`${styles.playCard} ${styles.trueCard}`}
                onClick={submit}
                disabled={saving}
                style={{ "--tilt": "0deg" }}
              >
                <span className={styles.cardCorner}>END</span>
                <span className={`${styles.cardCorner} ${styles.bottom}`}>END</span>
                <span className={styles.cardGlyph}>◆</span>
                <div className={styles.cardBody}>
                  <span className={styles.cardTag}>Submit</span>
                  <h4 className={styles.cardTitle}>{saving ? "Submitting..." : "Lock Result"}</h4>
                  <p className={styles.cardCopy}>Send your answers to calculate score and rank.</p>
                  <span className={styles.cardPrice}>{formatNum(heist?.prize_cop_points)} CP prize</span>
                </div>
              </button>
            </div>
          ) : (
            <div
              className={`${styles.cardGrid} ${styles.twoCard} ${
                selectedAnswer ? styles.isAnimating : ""
              }`}
            >
              <button
                type="button"
                className={`${styles.playCard} ${styles.trueCard} ${
                  selectedAnswer === "true" ? styles.selectedCard : ""
                } ${burningAnswer === "true" ? styles.isBurning : ""}`}
                onClick={() => chooseAnswer("true")}
                style={{ "--tilt": "-2deg" }}
              >
                <canvas
                  className={styles.burnCanvas}
                  width="360"
                  height="504"
                  aria-hidden="true"
                  ref={(node) => {
                    if (node) burnCanvasRefs.current.true = node;
                  }}
                />
                <span className={styles.cardCorner}>T</span>
                <span className={`${styles.cardCorner} ${styles.bottom}`}>T</span>
                <span className={styles.cardGlyph}>✓</span>
                <div className={styles.cardBody}>
                  <span className={styles.cardTag}>Answer</span>
                  <h4 className={styles.cardTitle}>TRUE</h4>
                  <p className={styles.cardCopy}>Trust the statement.</p>
                  <span className={styles.cardPrice}>Question {formatNum(currentIndex + 1)}</span>
                </div>
              </button>

              <button
                type="button"
                className={`${styles.playCard} ${styles.falseCard} ${
                  selectedAnswer === "false" ? styles.selectedCard : ""
                } ${burningAnswer === "false" ? styles.isBurning : ""}`}
                onClick={() => chooseAnswer("false")}
                style={{ "--tilt": "2deg" }}
              >
                <canvas
                  className={styles.burnCanvas}
                  width="360"
                  height="504"
                  aria-hidden="true"
                  ref={(node) => {
                    if (node) burnCanvasRefs.current.false = node;
                  }}
                />
                <span className={styles.cardCorner}>F</span>
                <span className={`${styles.cardCorner} ${styles.bottom}`}>F</span>
                <span className={styles.cardGlyph}>×</span>
                <div className={styles.cardBody}>
                  <span className={styles.cardTag}>Answer</span>
                  <h4 className={styles.cardTitle}>FALSE</h4>
                  <p className={styles.cardCopy}>Call the statement wrong.</p>
                  <span className={styles.cardPrice}>Question {formatNum(currentIndex + 1)}</span>
                </div>
              </button>
            </div>
          )}
        </section>
      </main>

      <Footer />
    </div>
  );
}
