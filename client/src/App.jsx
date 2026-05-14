import React from "react";
import { BrowserRouter as Router, Navigate, Routes, Route } from "react-router-dom";
import BackgroundMusic from "./components/BackgroundMusic/BackgroundMusic";
import SEO from "./components/SEO/SEO";


// Auth Pages
import Login from "./pages/Auth/Login/Login";
import Register from "./pages/Auth/Register/Register";
import ForgotPassword from "./pages/Auth/ForgotPassword/ForgotPassword";
import ResetPassword from "./pages/Auth/ResetPassword/ResetPassword";
import Landing from "./pages/Landing/Landing";

// Admin
import AdminDashboard from "./pages/admin/AdminDashboard/AdminDashboard";
import AdminTransactions from "./pages/admin/AdminTransactions/AdminTransactions";
import AdminProfile from "./pages/admin/AdminProfile/AdminProfile";
import AdminUsers from "./pages/admin/AdminUsers/AdminUsers";
import AdminAnalytics from "./pages/admin/AdminAnalytics/AdminAnalytics";
import AdminReferral from "./pages/admin/AdminReferral/AdminReferral";
import AdminNotifications from "./pages/admin/AdminNotifications/AdminNotifications";


// Protected Routes
import AdminRoute from "./routes/AdminRoute";
import UserRoute from "./routes/UserRoute";
import AffiliateRoute from "./routes/AffiliateRoute";

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
import AffiliateDashboard from "./pages/Affiliate/AffiliateDashboard";
import AffiliateHowItWorks from "./pages/Affiliate/AffiliateHowItWorks";
import Referral from "./pages/Affiliate/Referral";
import Winner from "./pages/Winner/Winner";
import HowItWork from "./pages/Support/HowItWork";
import Privacy from "./pages/Support/Privacy";
import Support from "./pages/Support/Support";
import Terms from "./pages/Support/Terms";
import Home from "./pages/Home/Home";
import Account from "./pages/Account/Account";


export default function App() {
  return (
    <Router>
      <SEO />
      <BackgroundMusic />
      <Routes>
        {/* ================= AUTH ROUTES ================= */}
        <Route path="/" element={<Landing />} />
        <Route path="/login" element={<Login />} />
        <Route path="/register" element={<Register />} />
        <Route path="/affiliate-register" element={<Register />} />
        <Route path="/forgot-password" element={<ForgotPassword />} />
        <Route path="/reset-password" element={<ResetPassword />} />
        <Route path="/heists/:id/ref/:code" element={<ReferralJoinPage />} />
        <Route path="/privacy" element={<Privacy />} />
        <Route path="/terms" element={<Terms />} />
        <Route path="/support" element={<Support />} />

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
          <Route path="/winners" element={<Winner />} />
        </Route>

        <Route element={<UserRoute />}>
          <Route path="/how-to-play" element={<HowItWork />} />
        </Route>

        {/* ================= AFFILIATE ROUTES (Protected) ================= */}
        <Route element={<AffiliateRoute />}>
          <Route path="/affiliate-dashboard" element={<AffiliateDashboard />} />
          <Route path="/affiliate/plans" element={<Affiliate />} />
          <Route path="/affiliate/referral" element={<Referral />} />
          <Route path="/affiliate/trade" element={<Trade />} />
          <Route path="/affiliate/how-it-works" element={<AffiliateHowItWorks />} />
          <Route path="/affiliate" element={<Navigate to="/affiliate/plans" replace />} />
          <Route path="/referral" element={<Navigate to="/affiliate/referral" replace />} />
        </Route>

        {/* ================= ADMIN ROUTES (Protected) ================= */}
        <Route element={<AdminRoute />}>
          <Route path="/admin-dashboard" element={<AdminDashboard />} />
        </Route>

        <Route element={<AdminRoute />}>
          <Route path="/admin/profile" element={<AdminProfile />} />
        </Route>

        <Route element={<AdminRoute />}>
          <Route path="/admin/users" element={<AdminUsers />} />
        </Route>

        <Route element={<AdminRoute />}>
          <Route path="/admin/analytics" element={<AdminAnalytics />} />
        </Route>

        <Route element={<AdminRoute />}>
          <Route path="/admin/referral" element={<AdminReferral />} />
        </Route>

        <Route element={<AdminRoute />}>
          <Route path="/admin/notifications" element={<AdminNotifications />} />
        </Route>


         <Route element={<AdminRoute />}>
          <Route path="/admin/heists" element={<AdminHeists />} />
        </Route>

        <Route element={<AdminRoute />}>
          <Route path="/admin/transactions" element={<AdminTransactions />} />
        </Route>

        <Route element={<AdminRoute />}>
          <Route path="/admin/coins" element={<AdminTransactions />} />
        </Route>

        <Route element={<AdminRoute />}>
          <Route path="/admin/payouts" element={<AdminTransactions />} />
        </Route>

       

        {/* ================= 404 FALLBACK ================= */}
        <Route path="/coming-soon" element={<ComingSoon />} />
        <Route path="*" element={<NotFound />} />
      </Routes>
    </Router>
  );
}
