import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";


// Auth Pages
import Login from "./pages/Auth/Login/Login";
import Register from "./pages/Auth/Register/Register";
import ForgotPassword from "./pages/Auth/ForgotPassword/ForgotPassword";
import ResetPassword from "./pages/Auth/ResetPassword/ResetPassword";

// Admin
import AdminDashboard from "./pages/admin/AdminDashboard/AdminDashboard";


// Protected Routes
import AdminRoute from "./routes/AdminRoute";
import UserRoute from "./routes/UserRoute";

// 404
import NotFound from "./pages/NotFound/NotFound";
import AdminHeists from "./pages/admin/AdminHeists/AdminHeists";
import Profile from "./pages/Profile/Profile";
import PaymentResult from "./pages/PaymentResult/PaymentResult";
import ComingSoon from "./pages/ComingSoon/ComingSoon";
import Heist from "./pages/Heist/Heist";
import HeistPlay from "./pages/Heist/HeistPlay";
import HeistResult from "./pages/Heist/HeistResult";
import HeistLeaderboard from "./pages/Heist/HeistLeaderboard";
import ReferralJoinPage from "./pages/heists/ReferralJoinPage";

import Trade from "./pages/Trade/Trade";
import Affiliate from "./pages/Affiliate/Affiliate";
import Winner from "./pages/Winner/Winner";
import HowItWork from "./pages/Support/HowItWork";
import Home from "./pages/Home/Home";
import Account from "./pages/Account/Account";


export default function App() {
  return (
    <Router>
      <Routes>
        {/* ================= AUTH ROUTES ================= */}
        <Route path="/" element={<Login />} />
       <Route path="/login" element={<Login />} />
        <Route path="/register" element={<Register />} />
        <Route path="/forgot-password" element={<ForgotPassword />} />
        <Route path="/reset-password" element={<ResetPassword />} />
        <Route path="/heists/:id/ref/:code" element={<ReferralJoinPage />} />

        {/* ================= USER ROUTES (Protected) ================= */}

        <Route element={<UserRoute />}>
          <Route path="/dashboard" element={<Home />} />
        </Route>

        <Route element={<UserRoute />}>
          <Route path="/account" element={<Account />} />
        </Route>

         <Route element={<UserRoute />}>
          <Route path="/profile" element={<Profile />} />
        </Route>

        <Route element={<UserRoute />}>
          <Route path="/payment-result" element={<PaymentResult />} />
        </Route>


         <Route element={<UserRoute />}>
          <Route path="/heist" element={<Heist />} />
        </Route>

        <Route element={<UserRoute />}>
          <Route path="/heist/:id" element={<HeistPlay />} />
        </Route>

        <Route element={<UserRoute />}>
          <Route path="/heist/:id/result" element={<HeistResult />} />
        </Route>

        <Route element={<UserRoute />}>
          <Route path="/heist/:id/leaderboard" element={<HeistLeaderboard />} />
        </Route>

         <Route element={<UserRoute />}>
          <Route path="/trade" element={<Trade />} />
        </Route>


        <Route element={<UserRoute />}>
          <Route path="/affiliate" element={<Affiliate />} />
        </Route>

        <Route element={<UserRoute />}>
          <Route path="/winners" element={<Winner />} />
        </Route>

        <Route element={<UserRoute />}>
          <Route path="/how-to-play" element={<HowItWork />} />
        </Route>

        {/* ================= ADMIN ROUTES (Protected) ================= */}
        <Route element={<AdminRoute />}>
          <Route path="/admin-dashboard" element={<AdminDashboard />} />
        </Route>


         <Route element={<AdminRoute />}>
          <Route path="/admin/heists" element={<AdminHeists />} />
        </Route>

       

        {/* ================= 404 FALLBACK ================= */}
        <Route path="*" element={<NotFound />} />
        <Route path="/coming-soon" element={<ComingSoon />} />
      </Routes>
    </Router>
  );
}
