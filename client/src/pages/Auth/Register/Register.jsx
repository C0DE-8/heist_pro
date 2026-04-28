import React, { useEffect, useMemo, useState } from "react";
import { Link, useNavigate, useSearchParams } from "react-router-dom";
import styles from "../Auth.module.css";
import { registerUser, sendRegistrationOtp } from "../../../lib/auth";
import coinImg from "../../../assets/copupcoin.png";

const isEmail = (v) =>
  /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(v || "").trim());

const RESERVED_USERNAMES = new Set(["cop", "copup", "copupbid", "admin"]);

function getUsernameError(value) {
  const username = String(value || "").trim();
  const loweredUsername = username.toLowerCase();

  if (!username) return "Username is required.";
  if (username.length < 2) return "Username must be at least 2 characters.";
  if (RESERVED_USERNAMES.has(loweredUsername)) return "That username is not allowed.";
  return "";
}

export default function Register() {
  const nav = useNavigate();
  const [searchParams] = useSearchParams();
  const urlReferralCode = useMemo(
    () =>
      String(
        searchParams.get("ref") ||
          searchParams.get("referral_code") ||
          searchParams.get("referralCode") ||
          ""
      ).trim(),
    [searchParams]
  );

  // step 1 = send otp, step 2 = register
  const [step, setStep] = useState(1);

  const [sendingOtp, setSendingOtp] = useState(false);
  const [registering, setRegistering] = useState(false);
  const [otpEmail, setOtpEmail] = useState("");
  const [successOpen, setSuccessOpen] = useState(false);

  const [msg, setMsg] = useState("");
  const [err, setErr] = useState("");

  const [form, setForm] = useState({
    username: "",
    full_name: "",
    email: "",
    password: "",
    otp: "",
    referralCode: urlReferralCode,
  });

  useEffect(() => {
    if (!urlReferralCode) return;
    setForm((prev) => {
      if (prev.referralCode === urlReferralCode) return prev;
      return { ...prev, referralCode: prev.referralCode || urlReferralCode };
    });
  }, [urlReferralCode]);

  const onChange = (k) => (e) => {
    setForm((p) => ({ ...p, [k]: e.target.value }));
  };

  const sendOtp = async () => {
    setMsg("");
    setErr("");

    const normalizedEmail = form.email.trim().toLowerCase();
    const usernameError = getUsernameError(form.username);

    if (!normalizedEmail || !isEmail(normalizedEmail)) {
      setErr("Enter a valid email address.");
      return;
    }
    if (usernameError) {
      setErr(usernameError);
      return;
    }

    setSendingOtp(true);
    try {
      const data = await sendRegistrationOtp({
        email: normalizedEmail,
        name: form.full_name || form.username || "New CopUp User",
      });
      setForm((p) => ({ ...p, email: normalizedEmail }));
      setOtpEmail(normalizedEmail);
      setMsg(data?.message || "OTP sent to your email.");
      setStep(2);
    } catch (e2) {
      const apiMsg =
        e2?.response?.data?.message || e2?.message || "Failed to send OTP";
      setErr(apiMsg);
    } finally {
      setSendingOtp(false);
    }
  };

  const register = async (e) => {
    e.preventDefault();
    setMsg("");
    setErr("");

    const registrationEmail = otpEmail || form.email.trim().toLowerCase();
    const usernameError = getUsernameError(form.username);

    if (!registrationEmail || !form.password || !form.otp) {
      setErr("username, email, password and otp are required.");
      return;
    }
    if (usernameError) {
      setErr(usernameError);
      return;
    }
    if (!isEmail(registrationEmail)) {
      setErr("Enter a valid email address.");
      return;
    }
    if (!otpEmail) {
      setErr("Send OTP before creating your account.");
      setStep(1);
      return;
    }

    setRegistering(true);
    try {
      const activeReferralCode = form.referralCode.trim() || urlReferralCode || null;
      const data = await registerUser({
        username: form.username.trim(),
        full_name: form.full_name.trim() || null,
        email: registrationEmail,
        password: form.password,
        otp: form.otp.trim(),
        referralCode: activeReferralCode,
      });

      setMsg(data?.message || "Registered successfully.");
      setSuccessOpen(true);
    } catch (e2) {
      const apiMsg =
        e2?.response?.data?.message || e2?.message || "Registration failed";
      setErr(apiMsg);
    } finally {
      setRegistering(false);
    }
  };

  return (
    <div className={styles.page}>
      {successOpen ? (
        <div className={styles.modalOverlay} role="dialog" aria-modal="true">
          <div className={styles.modalCard}>
            <div className={styles.modalIcon}>
              <img src={coinImg} alt="" className={styles.modalIconImg} />
            </div>
            <h2 className={styles.modalTitle}>Account created successfully</h2>
            <p className={styles.modalText}>
              Your CopupBid account has been created. You can now log in and start playing.
            </p>
            <button
              type="button"
              className={styles.btnPrimary}
              onClick={() => nav("/login", { replace: true })}
            >
              Continue to login
            </button>
          </div>
        </div>
      ) : null}

      <div className={styles.bgGlow} aria-hidden="true">
        <svg className={styles.bgSvg} xmlns="http://www.w3.org/2000/svg">
          <defs>
            <radialGradient id="glow1" cx="50%" cy="50%" r="50%">
              <stop offset="0%" stopColor="#10b981" stopOpacity="0.30" />
              <stop offset="100%" stopColor="#10b981" stopOpacity="0" />
            </radialGradient>
            <radialGradient id="glow2" cx="50%" cy="50%" r="50%">
              <stop offset="0%" stopColor="#3b82f6" stopOpacity="0.22" />
              <stop offset="100%" stopColor="#3b82f6" stopOpacity="0" />
            </radialGradient>
            <radialGradient id="glow3" cx="50%" cy="50%" r="50%">
              <stop offset="0%" stopColor="#f59e0b" stopOpacity="0.14" />
              <stop offset="100%" stopColor="#f59e0b" stopOpacity="0" />
            </radialGradient>
          </defs>
          <circle
            cx="20%"
            cy="30%"
            r="320"
            fill="url(#glow1)"
            className={styles.pulse1}
          />
          <circle
            cx="80%"
            cy="70%"
            r="260"
            fill="url(#glow2)"
            className={styles.pulse2}
          />
          <circle
            cx="60%"
            cy="20%"
            r="210"
            fill="url(#glow3)"
            className={styles.pulse3}
          />
        </svg>
      </div>

      <div className={styles.container}>
        <div className={styles.card}>
          <div className={styles.cardHead}>
            <div className={styles.brandRow}>
              <div className={styles.brandLogo}>
                <img
                  src={coinImg}
                  alt="CopupBid"
                  className={styles.brandLogoImg}
                />
              </div>

              <div className={styles.brandText}>
                <div className={styles.siteName}>CopupBid</div>
                <h1 className={styles.brandTitle}>Create your account</h1>
                <div className={styles.brandSub}>
                  Step {step}/2 • Email OTP verification
                </div>
              </div>
            </div>
          </div>

          <div className={styles.cardBody}>
            {step === 1 ? (
              <div className={styles.row}>
                <div className={styles.grid2}>
                  <div className={styles.field}>
                    <div className={styles.label}>Username</div>
                    <input
                      className={styles.input}
                      value={form.username}
                      onChange={onChange("username")}
                      placeholder="your username"
                      autoComplete="username"
                    />
                  </div>

                  <div className={styles.field}>
                    <div className={styles.label}>Full name (optional)</div>
                    <input
                      className={styles.input}
                      value={form.full_name}
                      onChange={onChange("full_name")}
                      placeholder="your full name"
                      autoComplete="name"
                    />
                  </div>
                </div>

                <div className={styles.field}>
                  <div className={styles.label}>Email</div>
                  <input
                    className={styles.input}
                    value={form.email}
                    onChange={onChange("email")}
                    placeholder="name@example.com"
                    autoComplete="email"
                  />
                </div>

                <div className={styles.actions}>
                  <button
                    type="button"
                    className={styles.btnPrimary}
                    onClick={sendOtp}
                    disabled={sendingOtp}
                  >
                    {sendingOtp ? "Sending OTP..." : "Send OTP"}
                  </button>
                </div>

                {msg ? <div className={styles.msgOk}>{msg}</div> : null}
                {err ? <div className={styles.msgErr}>{err}</div> : null}
                {urlReferralCode ? (
                  <div className={styles.msgOk}>Referral code detected: {urlReferralCode}</div>
                ) : null}

                <div className={styles.hr} />
                <div className={styles.miniRow}>
                  <Link className={styles.link} to="/login">
                    I already have an account
                  </Link>
                  <div className={styles.helper}>Next: enter OTP + password</div>
                </div>
              </div>
            ) : (
              <form className={styles.row} onSubmit={register}>
                <div className={styles.grid2}>
                  <div className={styles.field}>
                    <div className={styles.label}>Username</div>
                    <input
                      className={styles.input}
                      value={form.username}
                      onChange={onChange("username")}
                      placeholder="your username"
                    />
                  </div>

                  <div className={styles.field}>
                    <div className={styles.label}>Full name (optional)</div>
                    <input
                      className={styles.input}
                      value={form.full_name}
                      onChange={onChange("full_name")}
                      placeholder="your full name"
                    />
                  </div>
                </div>

                <div className={styles.field}>
                  <div className={styles.label}>Email</div>
                  <input
                    className={styles.input}
                    value={form.email}
                    readOnly
                    placeholder="name@example.com"
                  />
                </div>

                <div className={styles.grid2}>
                  <div className={styles.field}>
                    <div className={styles.label}>OTP</div>
                    <input
                      className={styles.input}
                      value={form.otp}
                      onChange={onChange("otp")}
                      placeholder="6-digit code"
                    />
                  </div>

                  <div className={styles.field}>
                    <div className={styles.label}>Password</div>
                    <input
                      className={styles.input}
                      type="password"
                      value={form.password}
                      onChange={onChange("password")}
                      placeholder="Create a password"
                      autoComplete="new-password"
                    />
                  </div>
                </div>

                <div className={styles.field}>
                  <div className={styles.label}>Referral code (optional)</div>
                  <input
                    className={styles.input}
                    value={form.referralCode}
                    onChange={onChange("referralCode")}
                    placeholder="Referral code"
                    readOnly={Boolean(urlReferralCode)}
                  />
                  {urlReferralCode ? (
                    <div className={styles.helper}>Locked from referral link: {urlReferralCode}</div>
                  ) : null}
                </div>

                <div className={styles.actions}>
                  <button
                    className={styles.btnPrimary}
                    disabled={registering}
                    type="submit"
                  >
                    {registering ? "Creating account..." : "Create account"}
                  </button>

                  <button
                    type="button"
                    className={styles.btnGhost}
                    onClick={() => setStep(1)}
                    disabled={registering}
                  >
                    Back to Send OTP
                  </button>
                </div>

                {msg ? <div className={styles.msgOk}>{msg}</div> : null}
                {err ? <div className={styles.msgErr}>{err}</div> : null}

                <div className={styles.hr} />
                <div className={styles.miniRow}>
                  <Link className={styles.link} to="/login">
                    Already have an account?
                  </Link>
                  <div className={styles.helper}>OTP expires in 10 mins</div>
                </div>
              </form>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
