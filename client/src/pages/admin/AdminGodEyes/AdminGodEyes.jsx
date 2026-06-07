import React, { useCallback, useEffect, useMemo, useState } from "react";
import {
  FaBan,
  FaCheckCircle,
  FaEye,
  FaMobileAlt,
  FaMousePointer,
  FaSearch,
  FaShieldAlt,
  FaSignInAlt,
  FaUsers,
} from "react-icons/fa";
import AdminNavbar from "../../../components/admin/Navbar";
import AdminPageHeader from "../../../components/admin/AdminPageHeader";
import { useToast } from "../../../components/Toast/ToastContext";
import {
  getGodEyesUser,
  getGodEyesUsers,
  setGodEyesUserBlocked,
} from "../../../lib/adminGodEyes";
import styles from "./AdminGodEyes.module.css";

function formatDate(value) {
  if (!value) return "N/A";
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "N/A";
  return date.toLocaleString();
}

function formatNum(value) {
  return Number(value || 0).toLocaleString();
}

function userLabel(user) {
  return user?.username || user?.full_name || user?.email || `User #${user?.id}`;
}

export default function AdminGodEyes() {
  const toast = useToast();
  const [users, setUsers] = useState([]);
  const [totals, setTotals] = useState(null);
  const [pagination, setPagination] = useState(null);
  const [selected, setSelected] = useState(null);
  const [detail, setDetail] = useState(null);
  const [search, setSearch] = useState("");
  const [status, setStatus] = useState("");
  const [risk, setRisk] = useState("");
  const [filters, setFilters] = useState({ search: "", status: "", risk: "" });
  const [loading, setLoading] = useState(true);
  const [detailLoading, setDetailLoading] = useState(false);
  const [savingBlock, setSavingBlock] = useState(false);
  const [error, setError] = useState("");

  const shownTotals = useMemo(
    () =>
      users.reduce(
        (acc, user) => {
          acc.logins += Number(user.login_count || 0);
          acc.visits += Number(user.visit_count || 0);
          acc.blocked += user.is_blocked ? 1 : 0;
          acc.risky += Number(user.same_device_accounts || 0) >= 3 ? 1 : 0;
          return acc;
        },
        { logins: 0, visits: 0, blocked: 0, risky: 0 }
      ),
    [users]
  );

  const loadUsers = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      const data = await getGodEyesUsers({
        search: filters.search || undefined,
        status: filters.status || undefined,
        risk: filters.risk || undefined,
        limit: 80,
      });
      setUsers(data?.users || []);
      setTotals(data?.totals || null);
      setPagination(data?.pagination || null);
    } catch (err) {
      setError(err?.response?.data?.message || "Unable to load God Eyes.");
    } finally {
      setLoading(false);
    }
  }, [filters]);

  useEffect(() => {
    loadUsers();
  }, [loadUsers]);

  const loadDetail = async (user) => {
    if (!user?.id) return;
    setSelected(user);
    setDetailLoading(true);
    try {
      const data = await getGodEyesUser(user.id);
      setDetail(data);
      setSelected(data?.user || user);
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to load user activity.");
    } finally {
      setDetailLoading(false);
    }
  };

  const applyFilters = (event) => {
    event.preventDefault();
    setFilters({ search: search.trim(), status, risk });
  };

  const toggleBlock = async () => {
    if (!selected?.id || savingBlock) return;
    const nextBlocked = !selected.is_blocked;
    const reason = nextBlocked ? window.prompt("Reason for blocking this user?", "") || "" : "";
    setSavingBlock(true);
    try {
      await setGodEyesUserBlocked(selected.id, nextBlocked, reason);
      const nextUser = { ...selected, is_blocked: nextBlocked ? 1 : 0 };
      setSelected(nextUser);
      setDetail((prev) => (prev ? { ...prev, user: nextUser } : prev));
      setUsers((prev) =>
        prev.map((user) => (user.id === selected.id ? { ...user, is_blocked: nextBlocked ? 1 : 0 } : user))
      );
      toast.success(nextBlocked ? "User blocked" : "User unblocked");
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to update block status.");
    } finally {
      setSavingBlock(false);
    }
  };

  return (
    <div className={styles.page}>
      <AdminNavbar />

      <main className={styles.main}>
        <AdminPageHeader
          kicker="Admin Security"
          title="God Eyes"
          description="Monitor account creation signals, user visits, logins, device matches, IP matches, and block suspicious accounts."
          onRefresh={loadUsers}
          refreshing={loading}
          error={error}
          onRetry={loadUsers}
        />

        <section className={styles.statsGrid}>
          <div className={styles.statBox}>
            <FaUsers />
            <span>Total users</span>
            <strong>{formatNum(totals?.total_users || pagination?.total || users.length)}</strong>
          </div>
          <div className={styles.statBox}>
            <FaSignInAlt />
            <span>Logins shown</span>
            <strong>{formatNum(shownTotals.logins)}</strong>
          </div>
          <div className={styles.statBox}>
            <FaMousePointer />
            <span>Visits shown</span>
            <strong>{formatNum(shownTotals.visits)}</strong>
          </div>
          <div className={styles.statBox}>
            <FaShieldAlt />
            <span>Device risks</span>
            <strong>{formatNum(shownTotals.risky)}</strong>
          </div>
        </section>

        <form className={styles.filters} onSubmit={applyFilters}>
          <label>
            <span>Search</span>
            <div className={styles.searchBox}>
              <FaSearch />
              <input
                value={search}
                onChange={(event) => setSearch(event.target.value)}
                placeholder="User, email, IP, wallet, game ID, device"
              />
            </div>
          </label>

          <label>
            <span>Status</span>
            <select value={status} onChange={(event) => setStatus(event.target.value)}>
              <option value="">All</option>
              <option value="active">Active</option>
              <option value="blocked">Blocked</option>
              <option value="admin">Admins</option>
            </select>
          </label>

          <label>
            <span>Risk</span>
            <select value={risk} onChange={(event) => setRisk(event.target.value)}>
              <option value="">All</option>
              <option value="device">3+ same device</option>
              <option value="ip">3+ same IP</option>
            </select>
          </label>

          <button type="submit" className={styles.primaryBtn} disabled={loading}>
            <FaSearch />
            <span>Search</span>
          </button>
        </form>

        <section className={styles.contentGrid}>
          <div className={styles.panel}>
            <div className={styles.panelHead}>
              <div>
                <p className={styles.kicker}>Live Directory</p>
                <h2>{loading ? "Loading users" : `${users.length} users shown`}</h2>
              </div>
              <FaEye />
            </div>

            <div className={styles.userList}>
              {loading ? (
                <div className={styles.emptyState}>Loading activity...</div>
              ) : users.length ? (
                users.map((user) => (
                  <button
                    key={user.id}
                    type="button"
                    className={`${styles.userRow} ${selected?.id === user.id ? styles.userRowActive : ""}`}
                    onClick={() => loadDetail(user)}
                  >
                    <span className={styles.avatar}>{String(userLabel(user)).slice(0, 1).toUpperCase()}</span>
                    <span className={styles.userMeta}>
                      <strong>{userLabel(user)}</strong>
                      <small>{user.email}</small>
                      <small>Last seen: {formatDate(user.last_seen_at || user.last_activity_at)}</small>
                    </span>
                    <span className={styles.userFlags}>
                      {user.is_blocked ? <span className={styles.blockedPill}>Blocked</span> : <span className={styles.okPill}>Active</span>}
                      {Number(user.same_device_accounts || 0) >= 3 ? (
                        <span className={styles.riskPill}>{user.same_device_accounts} device</span>
                      ) : null}
                    </span>
                    <span className={styles.rowStats}>
                      <span>{formatNum(user.login_count)} logins</span>
                      <span>{formatNum(user.visit_count)} visits</span>
                    </span>
                  </button>
                ))
              ) : (
                <div className={styles.emptyState}>No users match the filters.</div>
              )}
            </div>
          </div>

          <div className={styles.panel}>
            <div className={styles.panelHead}>
              <div>
                <p className={styles.kicker}>User Breakdown</p>
                <h2>{selected ? userLabel(selected) : "Select a user"}</h2>
              </div>
              {selected ? (
                <button
                  type="button"
                  className={selected.is_blocked ? styles.primaryBtn : styles.dangerBtn}
                  onClick={toggleBlock}
                  disabled={savingBlock}
                >
                  {selected.is_blocked ? <FaCheckCircle /> : <FaBan />}
                  <span>{savingBlock ? "Saving..." : selected.is_blocked ? "Unblock" : "Block"}</span>
                </button>
              ) : null}
            </div>

            {!selected ? (
              <div className={styles.emptyState}>Open a user to see logins, visits, IPs, device links, and recent activity.</div>
            ) : detailLoading ? (
              <div className={styles.emptyState}>Loading user breakdown...</div>
            ) : (
              <>
                <section className={styles.breakdownGrid}>
                  <div><span>Role</span><strong>{selected.role}</strong></div>
                  <div><span>COP points</span><strong>{formatNum(selected.cop_point)}</strong></div>
                  <div><span>Logins</span><strong>{formatNum(detail?.stats?.login_count)}</strong></div>
                  <div><span>Visits</span><strong>{formatNum(detail?.stats?.visit_count)}</strong></div>
                  <div><span>Different IPs</span><strong>{formatNum(detail?.stats?.distinct_ips)}</strong></div>
                  <div><span>Different devices</span><strong>{formatNum(detail?.stats?.distinct_devices)}</strong></div>
                </section>

                <section className={styles.infoGrid}>
                  <div><span>Email</span><strong>{selected.email}</strong></div>
                  <div><span>Full name</span><strong>{selected.full_name || "N/A"}</strong></div>
                  <div><span>Game ID</span><strong>{selected.game_id || "N/A"}</strong></div>
                  <div><span>Wallet</span><strong>{selected.wallet_address || "N/A"}</strong></div>
                  <div><span>Register IP</span><strong>{selected.registration_ip || "N/A"}</strong></div>
                  <div><span>Device key</span><strong>{selected.registration_device_key || "N/A"}</strong></div>
                  <div><span>Created</span><strong>{formatDate(selected.created_at)}</strong></div>
                  <div><span>Last login</span><strong>{formatDate(selected.last_login_at)}</strong></div>
                </section>

                <section className={styles.splitGrid}>
                  <div className={styles.subPanel}>
                    <div className={styles.subHead}>
                      <FaMobileAlt />
                      <h3>Related Accounts</h3>
                    </div>
                    <div className={styles.compactList}>
                      {detail?.relatedUsers?.length ? (
                        detail.relatedUsers.map((user) => (
                          <button key={user.id} type="button" onClick={() => loadDetail(user)}>
                            <strong>{userLabel(user)}</strong>
                            <span>{user.registration_device_key === selected.registration_device_key ? "same device" : "same IP"}</span>
                          </button>
                        ))
                      ) : (
                        <div className={styles.miniEmpty}>No related accounts found.</div>
                      )}
                    </div>
                  </div>

                  <div className={styles.subPanel}>
                    <div className={styles.subHead}>
                      <FaMousePointer />
                      <h3>Top Pages</h3>
                    </div>
                    <div className={styles.compactList}>
                      {detail?.topPages?.length ? (
                        detail.topPages.map((page) => (
                          <div key={page.path}>
                            <strong>{page.path}</strong>
                            <span>{formatNum(page.visits)} visits · {formatDate(page.last_visit_at)}</span>
                          </div>
                        ))
                      ) : (
                        <div className={styles.miniEmpty}>No page visits recorded.</div>
                      )}
                    </div>
                  </div>
                </section>

                <section className={styles.activityPanel}>
                  <div className={styles.subHead}>
                    <FaEye />
                    <h3>Recent Activity</h3>
                  </div>
                  <div className={styles.activityList}>
                    {detail?.recentActivity?.length ? (
                      detail.recentActivity.map((item) => (
                        <div key={item.id} className={styles.activityRow}>
                          <span className={styles.eventPill}>{item.event_type}</span>
                          <strong>{item.path || "N/A"}</strong>
                          <span>{item.ip_address || "No IP"} · {formatDate(item.created_at)}</span>
                        </div>
                      ))
                    ) : (
                      <div className={styles.miniEmpty}>No activity recorded.</div>
                    )}
                  </div>
                </section>
              </>
            )}
          </div>
        </section>
      </main>
    </div>
  );
}
