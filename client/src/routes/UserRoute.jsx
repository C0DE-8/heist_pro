import React from "react";
import { Navigate, Outlet, useLocation } from "react-router-dom";
import { getStoredRole, getStoredToken } from "../lib/auth";

export default function UserRoute() {
  const loc = useLocation();
  const token = getStoredToken();
  const role = getStoredRole();

  if (!token) {
    return <Navigate to="/login" replace state={{ from: loc.pathname }} />;
  }

  // user-only route
  if (role === "admin") {
    return <Navigate to="/admin-dashboard" replace />;
  }

  return <Outlet />;
}
