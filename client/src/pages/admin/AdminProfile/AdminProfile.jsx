import React, { useCallback, useEffect, useState } from "react";
import { FaEnvelope, FaIdBadge, FaKey, FaRedoAlt, FaSave, FaUserShield } from "react-icons/fa";
import AdminNavbar from "../../../components/admin/Navbar";
import { useToast } from "../../../components/Toast/ToastContext";
import {
  getAdminProfile,
  updateAdminPassword,
  updateAdminProfile,
} from "../../../lib/admin";
import styles from "./AdminProfile.module.css";

function emptyProfileForm() {
  return {
    username: "",
    full_name: "",
    email: "",
  };
}

function emptyPasswordForm() {
  return {
    current_password: "",
    new_password: "",
  };
}

export default function AdminProfile() {
  const toast = useToast();
  const [admin, setAdmin] = useState(null);
  const [profileForm, setProfileForm] = useState(emptyProfileForm);
  const [passwordForm, setPasswordForm] = useState(emptyPasswordForm);
  const [loading, setLoading] = useState(true);
  const [savingProfile, setSavingProfile] = useState(false);
  const [savingPassword, setSavingPassword] = useState(false);
  const [error, setError] = useState("");

  const loadProfile = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      const data = await getAdminProfile();
      const nextAdmin = data?.admin || null;
      setAdmin(nextAdmin);
      setProfileForm({
        username: nextAdmin?.username || "",
        full_name: nextAdmin?.full_name || "",
        email: nextAdmin?.email || "",
      });
    } catch (err) {
      setError(err?.response?.data?.message || "Unable to load admin profile.");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadProfile();
  }, [loadProfile]);

  const updateField = (field) => (event) => {
    setProfileForm((prev) => ({ ...prev, [field]: event.target.value }));
  };

  const updatePasswordField = (field) => (event) => {
    setPasswordForm((prev) => ({ ...prev, [field]: event.target.value }));
  };

  const saveProfile = async (event) => {
    event.preventDefault();
    setSavingProfile(true);
    try {
      const data = await updateAdminProfile(profileForm);
      const nextAdmin = data?.admin || null;
      setAdmin(nextAdmin);
      toast.success("Admin profile updated");
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to update profile.");
    } finally {
      setSavingProfile(false);
    }
  };

  const savePassword = async (event) => {
    event.preventDefault();
    setSavingPassword(true);
    try {
      await updateAdminPassword(passwordForm);
      setPasswordForm(emptyPasswordForm());
      toast.success("Admin password updated");
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to update password.");
    } finally {
      setSavingPassword(false);
    }
  };

  return (
    <div className={styles.page}>
      <AdminNavbar admin={admin} />

      <main className={styles.main}>
        <section className={styles.hero}>
          <div>
            <p className={styles.kicker}>Admin Profile</p>
            <h1>{loading ? "Loading profile..." : admin?.full_name || admin?.username || "Admin"}</h1>
            <p>Manage admin identity details and change the admin account password.</p>
          </div>

          <button
            type="button"
            className={styles.refreshBtn}
            onClick={loadProfile}
            disabled={loading}
          >
            <FaRedoAlt />
            <span>{loading ? "Refreshing..." : "Refresh"}</span>
          </button>
        </section>

        {error ? (
          <div className={styles.errorBox}>
            <span>{error}</span>
            <button type="button" onClick={loadProfile}>
              Retry
            </button>
          </div>
        ) : null}

        <section className={styles.grid}>
          <form className={styles.panel} onSubmit={saveProfile}>
            <div className={styles.panelHead}>
              <div>
                <p className={styles.kicker}>Identity</p>
                <h2>Profile Details</h2>
              </div>
              <FaUserShield />
            </div>

            <label className={styles.field}>
              <span>
                <FaIdBadge /> Username
              </span>
              <input
                value={profileForm.username}
                onChange={updateField("username")}
                placeholder="Admin username"
                disabled={loading || savingProfile}
              />
            </label>

            <label className={styles.field}>
              <span>
                <FaUserShield /> Full name
              </span>
              <input
                value={profileForm.full_name}
                onChange={updateField("full_name")}
                placeholder="Full name"
                disabled={loading || savingProfile}
              />
            </label>

            <label className={styles.field}>
              <span>
                <FaEnvelope /> Email
              </span>
              <input
                type="email"
                value={profileForm.email}
                onChange={updateField("email")}
                placeholder="Admin email"
                disabled={loading || savingProfile}
              />
            </label>

            <button type="submit" className={styles.primaryBtn} disabled={loading || savingProfile}>
              <FaSave />
              <span>{savingProfile ? "Saving..." : "Save Profile"}</span>
            </button>
          </form>

          <form className={styles.panel} onSubmit={savePassword}>
            <div className={styles.panelHead}>
              <div>
                <p className={styles.kicker}>Security</p>
                <h2>Change Password</h2>
              </div>
              <FaKey />
            </div>

            <label className={styles.field}>
              <span>
                <FaKey /> Current password
              </span>
              <input
                type="password"
                value={passwordForm.current_password}
                onChange={updatePasswordField("current_password")}
                placeholder="Current password"
                autoComplete="current-password"
                disabled={savingPassword}
              />
            </label>

            <label className={styles.field}>
              <span>
                <FaKey /> New password
              </span>
              <input
                type="password"
                value={passwordForm.new_password}
                onChange={updatePasswordField("new_password")}
                placeholder="At least 8 characters"
                autoComplete="new-password"
                disabled={savingPassword}
              />
            </label>

            <button type="submit" className={styles.primaryBtn} disabled={savingPassword}>
              <FaSave />
              <span>{savingPassword ? "Updating..." : "Update Password"}</span>
            </button>
          </form>
        </section>
      </main>
    </div>
  );
}
