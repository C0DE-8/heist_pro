import { useEffect } from "react";
import { useLocation } from "react-router-dom";

const SITE_URL = "https://copupbid.top";
const SITE_NAME = "CopUpBid";
const DEFAULT_IMAGE = `${SITE_URL}/copupcoin.png`;
const SOCIAL_LINKS = [
  "https://vt.tiktok.com/ZS9o4VgCV/",
  "https://youtube.com/@copup-bid?si=l0llj5q5Zux-Irox",
  "https://wa.link/3dukka",
  "https://chat.whatsapp.com/FKzdQCCXxuFIU0gFuKko3g?mode=gi_t",
];

const DEFAULT_SEO = {
  title: "CopUpBid - Bid, Win, Trade, and Earn CopUpCoin",
  description:
    "CopUpBid is an online bidding and reward platform where users join heists, win deals, trade CopUpCoin, earn referral rewards, and track winners.",
  keywords:
    "CopUpBid, CopUpCoin, online bidding, bid and win, auction rewards, heist game, referral rewards, trade CopUpCoin, winners, Nigeria deals",
  type: "website",
  robots: "index, follow",
};

const ROUTE_SEO = [
  {
    match: (path) => path === "/",
    title: "CopUpBid - Where Deals Meet Dreams",
    description:
      "Join CopUpBid to bid, play heists, win prizes, earn rewards, and use CopUpCoin across the platform.",
    keywords:
      "CopUpBid, CopUpBid app, CopUpCoin, online bidding platform, win prizes online, bid deals, reward app",
  },
  {
    match: (path) => path === "/register",
    title: "Create Your CopUpBid Account",
    description:
      "Sign up for CopUpBid and start bidding, earning rewards, joining heists, and trading CopUpCoin.",
    keywords:
      "CopUpBid register, create CopUpBid account, sign up CopUpBid, CopUpCoin wallet",
  },
  {
    match: (path) => path === "/login",
    title: "Login to CopUpBid",
    description:
      "Access your CopUpBid wallet, heists, rewards, referrals, trades, and bidding account.",
    keywords: "CopUpBid login, CopUpBid account, CopUpCoin wallet login",
    robots: "noindex, follow",
  },
  {
    match: (path) => path === "/support",
    title: "CopUpBid Support",
    description:
      "Contact CopUpBid support for help with accounts, payments, CopUpCoin, heists, bidding, and rewards.",
    keywords:
      "CopUpBid support, CopUpBid help, CopUpCoin support, bidding support, payment support",
  },
  {
    match: (path) => path === "/privacy",
    title: "CopUpBid Privacy Policy",
    description:
      "Read the CopUpBid privacy policy to understand how account, payment, and platform data is handled.",
    keywords: "CopUpBid privacy policy, privacy, account data, payment data",
  },
  {
    match: (path) => path === "/terms",
    title: "CopUpBid Terms and Conditions",
    description:
      "Read the CopUpBid terms covering bidding, payments, rewards, CopUpCoin, accounts, and platform rules.",
    keywords: "CopUpBid terms, terms and conditions, CopUpCoin rules, bidding rules",
  },
  {
    match: (path) => path === "/how-to-play",
    title: "How to Play on CopUpBid",
    description:
      "Learn how CopUpBid heists, bids, rewards, winners, referrals, and CopUpCoin features work.",
    keywords:
      "how to play CopUpBid, CopUpBid heist, bid guide, CopUpCoin guide, online rewards guide",
  },
  {
    match: (path) => path === "/winners",
    title: "CopUpBid Winners",
    description:
      "See CopUpBid winners and prize results from completed heists and bidding activities.",
    keywords: "CopUpBid winners, prize winners, heist winners, bidding results",
  },
  {
    match: (path) => path === "/heist" || path.startsWith("/heist/"),
    title: "CopUpBid Heists",
    description:
      "Join CopUpBid heists, compete for prizes, answer challenges, and track leaderboard results.",
    keywords:
      "CopUpBid heist, heist game, online challenge, win prizes, leaderboard, CopUpCoin",
  },
  {
    match: (path) => path === "/trade",
    title: "Trade CopUpCoin on CopUpBid",
    description:
      "Send and receive CopUpCoin instantly inside CopUpBid with wallet transfer history.",
    keywords: "trade CopUpCoin, send CopUpCoin, CopUpBid wallet, coin transfer",
    robots: "noindex, follow",
  },
  {
    match: (path) => path === "/affiliate-dashboard",
    title: "CopUpBid Affiliate Dashboard",
    description:
      "View CopUpBid affiliate balance, referral performance, Tile status, estimated earnings, and affiliate tools.",
    keywords:
      "CopUpBid affiliate dashboard, affiliate earnings, referral network, CopUpCoin balance",
    robots: "noindex, follow",
  },
  {
    match: (path) => path === "/affiliate" || path === "/affiliate/plans",
    title: "CopUpBid Affiliate Tile Earnings",
    description:
      "Track CopUpBid Affiliate Tile levels, monthly referral-network ticket activity, targets, and estimated CopUpCoin earnings.",
    keywords:
      "CopUpBid affiliate, affiliate tiles, tile earnings, ticket targets, CopUpCoin earnings",
    robots: "noindex, follow",
  },
  {
    match: (path) => path === "/referral" || path === "/affiliate/referral",
    title: "CopUpBid Referral Tools",
    description:
      "Share CopUpBid referral links, manage referred users, generate heist links, and track referral reward progress.",
    keywords:
      "CopUpBid referral, referral links, referred users, heist links, CopUpCoin referral rewards",
    robots: "noindex, follow",
  },
  {
    match: (path) => path === "/affiliate/how-it-works",
    title: "How CopUpBid Affiliate Earnings Work",
    description:
      "Learn how CopUpBid affiliate Tile plans, referral networks, ticket targets, and performance payouts work.",
    keywords:
      "CopUpBid affiliate guide, affiliate how it works, Tile plans, referral payouts",
    robots: "noindex, follow",
  },
  {
    match: (path) =>
      path.startsWith("/dashboard") ||
      path.startsWith("/account") ||
      path.startsWith("/profile") ||
      path.startsWith("/payment-result") ||
      path.startsWith("/admin") ||
      path.startsWith("/forgot-password") ||
      path.startsWith("/reset-password"),
    robots: "noindex, nofollow",
  },
];

function getRouteSeo(pathname) {
  const routeSeo = ROUTE_SEO.find((route) => route.match(pathname)) || {};
  return { ...DEFAULT_SEO, ...routeSeo };
}

function setMeta(attribute, key, content) {
  if (!content) return;

  let tag = document.head.querySelector(`meta[${attribute}="${key}"]`);
  if (!tag) {
    tag = document.createElement("meta");
    tag.setAttribute(attribute, key);
    document.head.appendChild(tag);
  }

  tag.setAttribute("content", content);
}

function setLink(rel, href) {
  let tag = document.head.querySelector(`link[rel="${rel}"]`);
  if (!tag) {
    tag = document.createElement("link");
    tag.setAttribute("rel", rel);
    document.head.appendChild(tag);
  }

  tag.setAttribute("href", href);
}

function setJsonLd(id, data) {
  let tag = document.getElementById(id);
  if (!tag) {
    tag = document.createElement("script");
    tag.id = id;
    tag.type = "application/ld+json";
    document.head.appendChild(tag);
  }

  tag.textContent = JSON.stringify(data);
}

export default function SEO() {
  const { pathname } = useLocation();

  useEffect(() => {
    const seo = getRouteSeo(pathname);
    const canonicalUrl = `${SITE_URL}${pathname === "/" ? "" : pathname}`;

    document.documentElement.lang = "en";
    document.title = seo.title;

    setMeta("name", "description", seo.description);
    setMeta("name", "keywords", seo.keywords);
    setMeta("name", "robots", seo.robots);
    setMeta("name", "author", SITE_NAME);
    setMeta("name", "theme-color", "#10b981");
    setMeta("name", "application-name", SITE_NAME);

    setMeta("property", "og:site_name", SITE_NAME);
    setMeta("property", "og:title", seo.title);
    setMeta("property", "og:description", seo.description);
    setMeta("property", "og:type", seo.type);
    setMeta("property", "og:url", canonicalUrl);
    setMeta("property", "og:image", DEFAULT_IMAGE);

    setMeta("name", "twitter:card", "summary_large_image");
    setMeta("name", "twitter:title", seo.title);
    setMeta("name", "twitter:description", seo.description);
    setMeta("name", "twitter:image", DEFAULT_IMAGE);

    setLink("canonical", canonicalUrl);

    setJsonLd("organization-schema", {
      "@context": "https://schema.org",
      "@type": "Organization",
      name: SITE_NAME,
      url: SITE_URL,
      logo: DEFAULT_IMAGE,
      email: "Support@copupbid.top",
      sameAs: SOCIAL_LINKS,
    });

    setJsonLd("website-schema", {
      "@context": "https://schema.org",
      "@type": "WebSite",
      name: SITE_NAME,
      url: SITE_URL,
      description: DEFAULT_SEO.description,
      publisher: {
        "@type": "Organization",
        name: SITE_NAME,
      },
    });
  }, [pathname]);

  return null;
}
