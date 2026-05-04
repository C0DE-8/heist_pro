import React, { useEffect, useMemo, useState } from "react";
import { NavLink, useLocation, useNavigate } from "react-router-dom";
import styles from "./Navbar.module.css";
import { getAdminProfile } from "../../lib/admin";
import { clearAuthSession } from "../../lib/auth";

// react-icons
import {
  FaBars,
  FaTimes,
  FaTachometerAlt,
  FaUsers,
  FaFlask,
  FaWallet,
  FaCoins,
  FaChartLine,
  FaUserCog,
  FaSignOutAlt,
  FaGift,
} from "react-icons/fa";

export default function AdminNavbar({ admin: adminProp }) {
  const navigate = useNavigate();
  const location = useLocation();

  const [loadedAdmin, setLoadedAdmin] = useState(null);
  const [menuOpen, setMenuOpen] = useState(false);
  const admin = adminProp || loadedAdmin;

  const navItems = useMemo(
    () => [
      { to: "/admin-dashboard", label: "Dashboard", icon: <FaTachometerAlt /> },
      { to: "/admin/users", label: "Users", icon: <FaUsers /> },
      { to: "/admin/analytics", label: "Analytics", icon: <FaChartLine /> },
      { to: "/admin/referral", label: "Referral", icon: <FaGift /> },
      { to: "/admin/heists", label: "Heists", icon: <FaFlask /> },
      { to: "/admin/transactions", label: "Transactions", icon: <FaWallet /> },
      { to: "/admin/coins", label: "Coins", icon: <FaCoins /> },
      { to: "/admin/profile", label: "Profile", icon: <FaUserCog /> },
    ],
    []
  );

  useEffect(() => {
    if (adminProp) return undefined;

    let mounted = true;
    getAdminProfile()
      .then((data) => {
        if (mounted) setLoadedAdmin(data?.admin || null);
      })
      .catch(() => {});
    return () => {
      mounted = false;
    };
  }, [adminProp]);

  useEffect(() => {
    setMenuOpen(false);
  }, [location.pathname]);

  useEffect(() => {
    if (!menuOpen) return undefined;

    const previousOverflow = document.body.style.overflow;
    document.body.style.overflow = "hidden";

    return () => {
      document.body.style.overflow = previousOverflow;
    };
  }, [menuOpen]);

  const logout = () => {
    clearAuthSession();
    navigate("/login");
  };

  const adminName = admin?.full_name || admin?.username || admin?.email || "Admin";

  return (
    <div className={styles.wrap}>
      <div className={styles.bar}>
        <div className={styles.left}>
          <button
            className={styles.brandBtn}
            onClick={() => navigate("/admin-dashboard")}
            title="Admin Dashboard"
            type="button"
          >
            <span className={styles.brandDot} />
            <span className={styles.brandText}>CopupBid Admin</span>
          </button>

          {/* Desktop nav */}
          <nav className={styles.nav}>
            {navItems.map((i) => (
              <NavLink
                key={i.to}
                to={i.to}
                end={i.to === "/admin-dashboard"}
                className={({ isActive }) => (isActive ? styles.active : styles.link)}
              >
                {i.label}
              </NavLink>
            ))}
          </nav>
        </div>

        <div className={styles.right}>
          {admin ? (
            <div className={styles.adminBadge}>
              <div className={styles.avatar}>
                {String(adminName || "A")
                  .trim()
                  .slice(0, 1)
                  .toUpperCase()}
              </div>
              <div className={styles.adminMeta}>
                <div className={styles.adminName}>{adminName}</div>
                <div className={styles.adminRole}>{admin.role}</div>
              </div>
            </div>
          ) : null}

          {/* Desktop buttons */}
          <div className={styles.desktopActions}>
            <button className={styles.logoutBtn} onClick={logout} type="button">
              Logout
            </button>
          </div>

          {/* Mobile menu toggle */}
          <button
            className={styles.mobileMenuBtn}
            onClick={() => setMenuOpen((v) => !v)}
            aria-label={menuOpen ? "Close menu" : "Open menu"}
            type="button"
          >
            {menuOpen ? <FaTimes /> : <FaBars />}
          </button>
        </div>
      </div>

      <div className={`${styles.mobileOverlay} ${menuOpen ? styles.mobileOverlayOpen : ""}`}>
        <button
          type="button"
          className={styles.mobileBackdrop}
          aria-label="Close menu"
          onClick={() => setMenuOpen(false)}
        />

        <aside className={`${styles.mobilePanel} ${menuOpen ? styles.mobilePanelOpen : ""}`}>
          <div className={styles.mobilePanelInner}>
            <div className={styles.mobilePanelHead}>
              <button
                className={styles.brandBtn}
                onClick={() => navigate("/admin-dashboard")}
                title="Admin Dashboard"
                type="button"
              >
                <span className={styles.brandDot} />
                <span className={styles.brandText}>CopupBid Admin</span>
              </button>

              <button
                className={styles.mobileCloseBtn}
                onClick={() => setMenuOpen(false)}
                aria-label="Close menu"
                type="button"
              >
                <FaTimes />
              </button>
            </div>

            {admin ? (
              <div className={styles.mobileAdminBadge}>
                <div className={styles.avatar}>
                  {String(adminName || "A")
                    .trim()
                    .slice(0, 1)
                    .toUpperCase()}
                </div>
                <div className={styles.adminMeta}>
                  <div className={styles.adminName}>{adminName}</div>
                  <div className={styles.adminRole}>{admin.role}</div>
                </div>
              </div>
            ) : null}

            <div className={styles.mobileLinks}>
              {navItems.map((i) => (
                <NavLink
                  key={i.to}
                  to={i.to}
                  end={i.to === "/admin-dashboard"}
                  onClick={() => setMenuOpen(false)}
                  className={({ isActive }) =>
                    isActive ? styles.mobileLinkActive : styles.mobileLink
                  }
                >
                  <span className={styles.mobileIcon}>{i.icon}</span>
                  <span className={styles.mobileLabel}>{i.label}</span>
                </NavLink>
              ))}
            </div>

            <div className={styles.mobileActions}>
              <button className={styles.mobileLogoutBtn} onClick={logout} type="button">
                <FaSignOutAlt /> <span>Logout</span>
              </button>
            </div>
          </div>
        </aside>
      </div>
    </div>
  );
}
