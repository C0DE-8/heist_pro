import React from "react";
import { Link } from "react-router-dom";
import styles from "./Footer.module.css";
import coinImg from "../../assets/copupcoin.png";

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
      </div>

      <div className={styles.copy}>© CopUpBid • Shop powered by CopUpCoin</div>
    </footer>
  );
}
