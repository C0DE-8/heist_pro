import React, { useCallback, useEffect, useMemo, useState } from "react";
import {
  FaBan,
  FaCheckCircle,
  FaEdit,
  FaSave,
  FaSearch,
  FaTrash,
  FaUser,
  FaUserShield,
  FaWallet,
} from "react-icons/fa";
import AdminNavbar from "../../../components/admin/Navbar";
import AdminPageHeader from "../../../components/admin/AdminPageHeader";
import { useToast } from "../../../components/Toast/ToastContext";
import {
  deleteAdminUser,
  getAdminUser,
  getAdminUsers,
  updateAdminUser,
} from "../../../lib/adminUsers";
import styles from "./AdminUsers.module.css";

const EMPTY_FORM = {
  email: "",
  username: "",
  full_name: "",
  role: "user",
  is_verified: true,
  is_blocked: false,
  cop_point: 0,
  referral_code: "",
  wallet_address: "",
  game_id: "",
  new_password: "",
};

function formatDate(value) {
  if (!value) return "N/A";
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "N/A";
  return date.toLocaleString();
}

function buildForm(user) {
  return {
    email: user?.email || "",
    username: user?.username || "",
    full_name: user?.full_name || "",
    role: user?.role || "user",
    is_verified: Boolean(user?.is_verified),
    is_blocked: Boolean(user?.is_blocked),
    cop_point: Number(user?.cop_point || 0),
    referral_code: user?.referral_code || "",
    wallet_address: user?.wallet_address || "",
    game_id: user?.game_id || "",
    new_password: "",
  };
}

export default function AdminUsers() {
  const toast = useToast();
  const [users, setUsers] = useState([]);
  const [pagination, setPagination] = useState(null);
  const [selectedUser, setSelectedUser] = useState(null);
  const [stats, setStats] = useState(null);
  const [form, setForm] = useState(EMPTY_FORM);
  const [search, setSearch] = useState("");
  const [role, setRole] = useState("");
  const [filters, setFilters] = useState({ search: "", role: "" });
  const [loading, setLoading] = useState(true);
  const [detailLoading, setDetailLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [deleting, setDeleting] = useState(false);
  const [error, setError] = useState("");

  const totals = useMemo(() => {
    return users.reduce(
      (acc, user) => {
        acc.admins += user.role === "admin" ? 1 : 0;
        acc.blocked += user.is_blocked ? 1 : 0;
        acc.verified += user.is_verified ? 1 : 0;
        acc.points += Number(user.cop_point || 0);
        return acc;
      },
      { admins: 0, blocked: 0, verified: 0, points: 0 }
    );
  }, [users]);

  const loadUsers = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      const data = await getAdminUsers({
        search: filters.search || undefined,
        role: filters.role || undefined,
        limit: 100,
      });
      setUsers(data?.users || []);
      setPagination(data?.pagination || null);
    } catch (err) {
      setError(err?.response?.data?.message || "Unable to load users.");
    } finally {
      setLoading(false);
    }
  }, [filters]);

  useEffect(() => {
    loadUsers();
  }, [loadUsers]);

  const loadUser = async (id) => {
    setDetailLoading(true);
    try {
      const data = await getAdminUser(id);
      const nextUser = data?.user || null;
      setSelectedUser(nextUser);
      setStats(data?.stats || null);
      setForm(buildForm(nextUser));
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to load user details.");
    } finally {
      setDetailLoading(false);
    }
  };

  const updateField = (field) => (event) => {
    const { type, checked, value } = event.target;
    setForm((prev) => ({
      ...prev,
      [field]: type === "checkbox" ? checked : value,
    }));
  };

  const saveUser = async (event) => {
    event.preventDefault();
    if (!selectedUser?.id) return;

    setSaving(true);
    try {
      const payload = {
        ...form,
        cop_point: Number(form.cop_point || 0),
      };
      if (!payload.new_password) delete payload.new_password;

      const data = await updateAdminUser(selectedUser.id, payload);
      const nextUser = data?.user || null;
      setSelectedUser(nextUser);
      setForm(buildForm(nextUser));
      setUsers((prev) => prev.map((user) => (user.id === nextUser.id ? nextUser : user)));
      toast.success("User updated");
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to update user.");
    } finally {
      setSaving(false);
    }
  };

  const removeUser = async () => {
    if (!selectedUser?.id || deleting) return;
    const label = selectedUser.username || selectedUser.email || `user ${selectedUser.id}`;
    const confirmed = window.confirm(`Delete ${label}? This cannot be undone.`);
    if (!confirmed) return;

    setDeleting(true);
    try {
      await deleteAdminUser(selectedUser.id);
      setUsers((prev) => prev.filter((user) => user.id !== selectedUser.id));
      setSelectedUser(null);
      setStats(null);
      setForm(EMPTY_FORM);
      toast.success("User deleted");
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to delete user.");
    } finally {
      setDeleting(false);
    }
  };

  const submitSearch = (event) => {
    event.preventDefault();
    setFilters({ search: search.trim(), role });
  };

  return (
    <div className={styles.page}>
      <AdminNavbar />

      <main className={styles.main}>
        <AdminPageHeader
          kicker="Admin Users"
          title="Users"
          description="Manage accounts, balances, roles, verification, and access status."
          onRefresh={loadUsers}
          refreshing={loading}
          error={error}
          onRetry={loadUsers}
        />

        <section className={styles.statsGrid}>
          <div className={styles.statBox}>
            <FaUser />
            <span>Total users</span>
            <strong>{pagination?.total ?? users.length}</strong>
          </div>
          <div className={styles.statBox}>
            <FaUserShield />
            <span>Admins shown</span>
            <strong>{totals.admins}</strong>
          </div>
          <div className={styles.statBox}>
            <FaCheckCircle />
            <span>Verified shown</span>
            <strong>{totals.verified}</strong>
          </div>
          <div className={styles.statBox}>
            <FaWallet />
            <span>COP shown</span>
            <strong>{totals.points.toLocaleString()}</strong>
          </div>
        </section>

        <form className={styles.filters} onSubmit={submitSearch}>
          <label>
            <span>Search</span>
            <div className={styles.searchBox}>
              <FaSearch />
              <input
                value={search}
                onChange={(event) => setSearch(event.target.value)}
                placeholder="Email, username, wallet, game ID"
              />
            </div>
          </label>

          <label>
            <span>Role</span>
            <select value={role} onChange={(event) => setRole(event.target.value)}>
              <option value="">All roles</option>
              <option value="user">Users</option>
              <option value="admin">Admins</option>
            </select>
          </label>

          <button type="submit" className={styles.primaryBtn} disabled={loading}>
            <FaSearch />
            <span>Apply</span>
          </button>
        </form>

        <section className={styles.contentGrid}>
          <div className={styles.panel}>
            <div className={styles.panelHead}>
              <div>
                <p className={styles.kicker}>Directory</p>
                <h2>All Users</h2>
              </div>
              {loading ? <span className={styles.badge}>Loading</span> : <span className={styles.badge}>{users.length} shown</span>}
            </div>

            <div className={styles.userList}>
              {loading ? (
                <div className={styles.emptyState}>Loading users...</div>
              ) : users.length ? (
                users.map((user) => (
                  <button
                    key={user.id}
                    type="button"
                    className={`${styles.userRow} ${
                      selectedUser?.id === user.id ? styles.userRowActive : ""
                    }`}
                    onClick={() => loadUser(user.id)}
                  >
                    <span className={styles.avatar}>
                      {String(user.username || user.email || "U").slice(0, 1).toUpperCase()}
                    </span>
                    <span className={styles.userMeta}>
                      <strong>{user.username || "No username"}</strong>
                      <small>{user.email}</small>
                    </span>
                    <span className={styles.userFlags}>
                      <span className={user.role === "admin" ? styles.adminPill : styles.rolePill}>
                        {user.role}
                      </span>
                      {user.is_blocked ? <span className={styles.blockedPill}>Blocked</span> : null}
                    </span>
                  </button>
                ))
              ) : (
                <div className={styles.emptyState}>No users found.</div>
              )}
            </div>
          </div>

          <form className={styles.panel} onSubmit={saveUser}>
            <div className={styles.panelHead}>
              <div>
                <p className={styles.kicker}>Details</p>
                <h2>{selectedUser ? selectedUser.username || selectedUser.email : "Select a user"}</h2>
              </div>
              <FaEdit />
            </div>

            {!selectedUser ? (
              <div className={styles.emptyState}>Open a user from the list to edit account details.</div>
            ) : detailLoading ? (
              <div className={styles.emptyState}>Loading user details...</div>
            ) : (
              <>
                <div className={styles.detailStats}>
                  <span>Joined: {Number(stats?.joined_heists || 0)}</span>
                  <span>Submissions: {Number(stats?.heist_submissions || 0)}</span>
                  <span>Won: {Number(stats?.won_heists || 0)}</span>
                  <span>Payins: {Number(stats?.payins || 0)}</span>
                  <span>Payouts: {Number(stats?.payout_requests || 0)}</span>
                </div>

                <div className={styles.formGrid}>
                  <label className={styles.field}>
                    <span>Email</span>
                    <input type="email" value={form.email} onChange={updateField("email")} required />
                  </label>

                  <label className={styles.field}>
                    <span>Username</span>
                    <input value={form.username} onChange={updateField("username")} required />
                  </label>

                  <label className={styles.field}>
                    <span>Full name</span>
                    <input value={form.full_name} onChange={updateField("full_name")} />
                  </label>

                  <label className={styles.field}>
                    <span>Role</span>
                    <select value={form.role} onChange={updateField("role")}>
                      <option value="user">User</option>
                      <option value="admin">Admin</option>
                    </select>
                  </label>

                  <label className={styles.field}>
                    <span>COP points</span>
                    <input
                      type="number"
                      min="0"
                      value={form.cop_point}
                      onChange={updateField("cop_point")}
                    />
                  </label>

                  <label className={styles.field}>
                    <span>Referral code</span>
                    <input value={form.referral_code} onChange={updateField("referral_code")} />
                  </label>

                  <label className={styles.field}>
                    <span>Wallet address</span>
                    <input value={form.wallet_address} onChange={updateField("wallet_address")} />
                  </label>

                  <label className={styles.field}>
                    <span>Game ID</span>
                    <input value={form.game_id} onChange={updateField("game_id")} />
                  </label>

                  <label className={`${styles.field} ${styles.fullField}`}>
                    <span>New password</span>
                    <input
                      type="password"
                      value={form.new_password}
                      onChange={updateField("new_password")}
                      placeholder="Leave blank to keep current password"
                      autoComplete="new-password"
                    />
                  </label>
                </div>

                <div className={styles.checks}>
                  <label>
                    <input
                      type="checkbox"
                      checked={form.is_verified}
                      onChange={updateField("is_verified")}
                    />
                    <span>Verified</span>
                  </label>
                  <label>
                    <input
                      type="checkbox"
                      checked={form.is_blocked}
                      onChange={updateField("is_blocked")}
                    />
                    <span>Blocked</span>
                  </label>
                </div>

                <div className={styles.metaLine}>
                  <span>Created: {formatDate(selectedUser.created_at)}</span>
                  <span>Updated: {formatDate(selectedUser.updated_at)}</span>
                </div>

                <div className={styles.actions}>
                  <button type="submit" className={styles.primaryBtn} disabled={saving || deleting}>
                    <FaSave />
                    <span>{saving ? "Saving..." : "Save User"}</span>
                  </button>
                  <button
                    type="button"
                    className={styles.dangerBtn}
                    onClick={removeUser}
                    disabled={saving || deleting}
                  >
                    {deleting ? <FaBan /> : <FaTrash />}
                    <span>{deleting ? "Deleting..." : "Delete User"}</span>
                  </button>
                </div>
              </>
            )}
          </form>
        </section>
      </main>
    </div>
  );
}
