import React, { useCallback, useEffect, useMemo, useState } from "react";
import { FaBell, FaCheckCircle, FaPaperPlane, FaRedoAlt, FaSearch, FaUsers } from "react-icons/fa";
import AdminNavbar from "../../../components/admin/Navbar";
import AdminPageHeader from "../../../components/admin/AdminPageHeader";
import { useToast } from "../../../components/Toast/ToastContext";
import { sendAdminNotice } from "../../../lib/adminNotifications";
import { getAdminUsers } from "../../../lib/adminUsers";
import styles from "./AdminNotifications.module.css";

const DEFAULT_FORM = {
  all_users: true,
  user_id: "",
  title: "",
  message: "",
  type: "admin_notice",
  path: "/dashboard",
  priority: "important",
};

const QUICK_PATHS = [
  { label: "Dashboard", value: "/dashboard" },
  { label: "Heists", value: "/heist" },
  { label: "Wallet", value: "/account" },
  { label: "Trade", value: "/trade" },
  { label: "Winners", value: "/winners" },
];

function userLabel(user) {
  const name = user?.full_name || user?.username || user?.email || `User #${user?.id}`;
  return `${name} (#${user?.id})`;
}

export default function AdminNotifications() {
  const toast = useToast();
  const [form, setForm] = useState(DEFAULT_FORM);
  const [users, setUsers] = useState([]);
  const [userSearch, setUserSearch] = useState("");
  const [selectedUser, setSelectedUser] = useState(null);
  const [loadingUsers, setLoadingUsers] = useState(true);
  const [usersError, setUsersError] = useState("");
  const [sending, setSending] = useState(false);
  const [lastResult, setLastResult] = useState(null);

  const targetLabel = useMemo(() => {
    if (form.all_users) return "All active users";
    const selected =
      selectedUser ||
      users.find((user) => Number(user.id) === Number(form.user_id));
    return selected ? userLabel(selected) : "One user";
  }, [form.all_users, form.user_id, selectedUser, users]);

  const loadUsers = useCallback(async () => {
    setLoadingUsers(true);
    setUsersError("");
    try {
      const data = await getAdminUsers({
        role: "user",
        search: userSearch.trim() || undefined,
        limit: 25,
      });
      setUsers(Array.isArray(data?.users) ? data.users : []);
    } catch (err) {
      console.error("Load notice users error:", err);
      setUsersError(err?.response?.data?.message || "Unable to load users.");
    } finally {
      setLoadingUsers(false);
    }
  }, [userSearch]);

  useEffect(() => {
    loadUsers();
  }, [loadUsers]);

  const updateField = (field) => (event) => {
    const value = event.target.type === "checkbox" ? event.target.checked : event.target.value;
    setForm((prev) => ({ ...prev, [field]: value }));
  };

  const chooseTarget = (allUsers) => {
    setForm((prev) => ({ ...prev, all_users: allUsers }));
  };

  const chooseUser = (user) => {
    setSelectedUser(user);
    setUserSearch(userLabel(user));
    setForm((prev) => ({ ...prev, all_users: false, user_id: String(user.id) }));
  };

  const clearSelectedUser = () => {
    setSelectedUser(null);
    setUserSearch("");
    setForm((prev) => ({ ...prev, user_id: "" }));
  };

  const resetForm = () => {
    setForm(DEFAULT_FORM);
    setSelectedUser(null);
    setUserSearch("");
    setLastResult(null);
  };

  const submitNotice = async (event) => {
    event.preventDefault();
    setSending(true);
    setLastResult(null);

    try {
      const result = await sendAdminNotice({
        ...form,
        user_id: Number(form.user_id),
      });
      setLastResult(result);
      toast.success(`Notice sent to ${result?.target_count || 0} user(s).`);
      setForm((prev) => ({
        ...DEFAULT_FORM,
        all_users: prev.all_users,
        user_id: prev.user_id,
      }));
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to send notice.");
    } finally {
      setSending(false);
    }
  };

  return (
    <div className={styles.page}>
      <AdminNavbar />

      <main className={styles.main}>
        <AdminPageHeader
          kicker="Admin Notices"
          title="Send User Alerts"
          description="Send an in-app notice and push notification to all active users or one selected user."
          onRefresh={loadUsers}
          refreshing={loadingUsers}
          error={usersError}
          onRetry={loadUsers}
        />

        <section className={styles.layout}>
          <article className={styles.panel}>
            <div className={styles.panelHead}>
              <div>
                <p className={styles.kicker}>Composer</p>
                <h2>Notice details</h2>
              </div>
              <span className={styles.badge}>
                <FaBell />
                {form.priority}
              </span>
            </div>

            <form className={styles.form} onSubmit={submitNotice}>
              <div className={styles.segmented} aria-label="Notice target">
                <button
                  type="button"
                  className={form.all_users ? styles.segmentActive : styles.segment}
                  onClick={() => chooseTarget(true)}
                >
                  <FaUsers />
                  <span>All users</span>
                </button>
                <button
                  type="button"
                  className={!form.all_users ? styles.segmentActive : styles.segment}
                  onClick={() => chooseTarget(false)}
                >
                  <FaBell />
                  <span>One user</span>
                </button>
              </div>

              {!form.all_users ? (
                <label className={styles.userPicker}>
                  <span>User</span>
                  <div className={styles.searchInput}>
                    <FaSearch />
                    <input
                      value={userSearch}
                      onChange={(event) => {
                        setUserSearch(event.target.value);
                        setSelectedUser(null);
                        setForm((prev) => ({ ...prev, user_id: "" }));
                      }}
                      placeholder="Search username, email, name, wallet, or game ID"
                      required={!form.user_id}
                    />
                  </div>

                  {selectedUser ? (
                    <div className={styles.selectedUser}>
                      <FaCheckCircle />
                      <strong>{userLabel(selectedUser)}</strong>
                      <button type="button" onClick={clearSelectedUser}>
                        Change
                      </button>
                    </div>
                  ) : (
                    <div className={styles.userResults}>
                      {loadingUsers ? (
                        <div className={styles.userResultEmpty}>Searching users...</div>
                      ) : users.length ? (
                        users.map((user) => (
                          <button key={user.id} type="button" onClick={() => chooseUser(user)}>
                            <span>
                              <strong>{userLabel(user)}</strong>
                              <small>{user.email}</small>
                            </span>
                            <em>{user.game_id || "No game ID"}</em>
                          </button>
                        ))
                      ) : (
                        <div className={styles.userResultEmpty}>No users found.</div>
                      )}
                    </div>
                  )}
                </label>
              ) : null}

              <label>
                <span>Title</span>
                <input
                  value={form.title}
                  onChange={updateField("title")}
                  placeholder="Payment approved"
                  maxLength={160}
                  required
                />
              </label>

              <label>
                <span>Message</span>
                <textarea
                  value={form.message}
                  onChange={updateField("message")}
                  placeholder="Write the alert users should receive."
                  rows={6}
                  required
                />
              </label>

              <div className={styles.twoCol}>
                <label>
                  <span>Type</span>
                  <input value={form.type} onChange={updateField("type")} maxLength={64} />
                </label>
                <label>
                  <span>Priority</span>
                  <select value={form.priority} onChange={updateField("priority")}>
                    <option value="important">Important</option>
                    <option value="normal">Normal</option>
                  </select>
                </label>
              </div>

              <label>
                <span>Open path</span>
                <input value={form.path} onChange={updateField("path")} placeholder="/dashboard" />
              </label>

              <div className={styles.quickPaths}>
                {QUICK_PATHS.map((path) => (
                  <button
                    key={path.value}
                    type="button"
                    className={form.path === path.value ? styles.pathActive : styles.pathBtn}
                    onClick={() => setForm((prev) => ({ ...prev, path: path.value }))}
                  >
                    {path.label}
                  </button>
                ))}
              </div>

              <div className={styles.actions}>
                <button type="submit" className={styles.primaryBtn} disabled={sending}>
                  <FaPaperPlane />
                  <span>{sending ? "Sending..." : "Send notice"}</span>
                </button>
                <button type="button" className={styles.softBtn} onClick={resetForm} disabled={sending}>
                  <FaRedoAlt />
                  <span>Reset</span>
                </button>
              </div>
            </form>
          </article>

          <aside className={styles.previewPanel}>
            <div className={styles.panelHead}>
              <div>
                <p className={styles.kicker}>Preview</p>
                <h2>Alert card</h2>
              </div>
            </div>

            <div className={styles.previewCard}>
              <span className={styles.previewIcon}>
                <FaBell />
              </span>
              <div>
                <strong>{form.title || "Notice title"}</strong>
                <p>{form.message || "The notice message will appear here before you send it."}</p>
              </div>
            </div>

            <div className={styles.summaryGrid}>
              <div>
                <span>Target</span>
                <strong>{targetLabel}</strong>
              </div>
              <div>
                <span>Path</span>
                <strong>{form.path || "/dashboard"}</strong>
              </div>
              <div>
                <span>Users loaded</span>
                <strong>{loadingUsers ? "..." : users.length}</strong>
              </div>
            </div>

            {lastResult ? (
              <div className={styles.successBox}>
                Sent to {lastResult.target_count} user(s). Notice IDs:{" "}
                {(lastResult.notice_ids || []).join(", ")}
              </div>
            ) : null}
          </aside>
        </section>
      </main>
    </div>
  );
}
