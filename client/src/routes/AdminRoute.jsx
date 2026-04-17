import React from "react";
import { Navigate, Outlet, useLocation } from "react-router-dom";
import { getStoredRole, getStoredToken } from "../lib/auth";

export default function AdminRoute() {
  const loc = useLocation();
  const token = getStoredToken();
  const role = getStoredRole();

  if (!token) {
    return <Navigate to="/login" replace state={{ from: loc.pathname }} />;
  }

  if (role !== "admin") {
    return <Navigate to="/" replace />;
  }

  return <Outlet />;
}
