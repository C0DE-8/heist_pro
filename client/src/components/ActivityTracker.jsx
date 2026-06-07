import { useEffect } from "react";
import { useLocation } from "react-router-dom";
import { recordVisit } from "../lib/activity";

export default function ActivityTracker() {
  const location = useLocation();

  useEffect(() => {
    const path = `${location.pathname}${location.search || ""}` || "/";
    recordVisit(path).catch(() => {});
  }, [location.pathname, location.search]);

  return null;
}
