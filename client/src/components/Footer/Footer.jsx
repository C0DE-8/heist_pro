import React from "react";
import { Link } from "react-router-dom";
import { FaTiktok, FaWhatsapp, FaYoutube } from "react-icons/fa6";
import styles from "./Footer.module.css";
import coinImg from "../../assets/copupcoin.png";

const socialLinks = [
  {
    label: "TikTok",
    href: "https://vt.tiktok.com/ZS9o4VgCV/",
    icon: FaTiktok,
  },
  {
    label: "YouTube",
    href: "https://youtube.com/@copup-bid?si=l0llj5q5Zux-Irox",
    icon: FaYoutube,
  },
  {
    label: "WhatsApp",
    href: "https://wa.link/3dukka",
    icon: FaWhatsapp,
  },
  {
    label: "WhatsApp Group",
    href: "https://chat.whatsapp.com/FKzdQCCXxuFIU0gFuKko3g?mode=gi_t",
    icon: FaWhatsapp,
  },
];

export default function Footer() {
  return (
    <footer className={styles.footer}>
      <div className={styles.inner}>
        <div className={styles.brand}>
          <img src={coinImg} alt="CopUpCoin" className={styles.logo} />
          <div>
            <div className={styles.title}>CopUpBid</div>
            <div className={styles.sub}>Where Deals Meet Dreams</div>
          </div>
        </div>

        <div className={styles.links}>
          <Link to="/privacy">Privacy</Link>
          <Link to="/terms">Terms</Link>
          <Link to="/support">Support</Link>
        </div>

        <div className={styles.socials} aria-label="Social links">
          {socialLinks.map(({ label, href, icon: Icon }) => (
            <a
              key={label}
              href={href}
              target="_blank"
              rel="noreferrer"
              aria-label={label}
              title={label}
            >
              {React.createElement(Icon, { "aria-hidden": "true" })}
              <span>{label}</span>
            </a>
          ))}
        </div>
      </div>

      <div className={styles.copy}>© CopUpBid • Shop powered by CopUpCoin</div>
    </footer>
  );
}
