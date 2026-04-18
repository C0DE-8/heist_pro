import React from "react";
import Header from "../../components/Header/Header";
import Footer from "../../components/Footer/Footer";
import styles from "./Legal.module.css";

export default function Privacy() {
  return (
    <div className={styles.page}>
      <Header />

      <main className={styles.main}>
        <section className={styles.hero}>
          <p className={styles.kicker}>Privacy</p>
          <h1>Privacy Policy</h1>
          <p>
            This policy describes the information CopupBid uses to run accounts, wallet actions,
            heists, affiliate links, transaction requests, and platform support.
          </p>
          <div className={styles.metaRow}>
            <span className={styles.pill}>Issue date: 2024</span>
            <span className={styles.pill}>Platform: CopupBid</span>
          </div>
        </section>

        <section className={styles.grid}>
          <article className={styles.panel}>
            <h2>Information We Use</h2>
            <p>
              CopupBid may use account details, profile details, login state, wallet balances,
              heist participation, submitted answers, affiliate activity, and transaction records
              to provide the platform.
            </p>
          </article>

          <article className={styles.panel}>
            <h2>Payment and Payout Data</h2>
            <p>
              Pay-in and payout requests can include amounts, account details, proof images,
              approval status, and rejection reasons. This information is used to process and
              audit transactions.
            </p>
          </article>

          <article className={styles.panel}>
            <h2>Gameplay Data</h2>
            <p>
              Heist submissions, answer timing, scores, leaderboard position, and winner records
              are used to calculate rankings, show results, and award CopUpCoin prizes.
            </p>
          </article>

          <article className={styles.panel}>
            <h2>Referral Data</h2>
            <p>
              Referral codes, affiliate links, referral joins, clicks, task progress, and reward
              status may be tracked to support affiliate rewards and prevent duplicate or
              self-referral abuse.
            </p>
          </article>

          <article className={`${styles.panel} ${styles.wide}`}>
            <h2>Security and Retention</h2>
            <ul>
              <li>Authentication tokens are used to keep signed-in users connected to protected features.</li>
              <li>Records may be kept as needed for account history, transaction review, security, and dispute handling.</li>
              <li>Access to admin transaction and user management tools is restricted to authorized admins.</li>
              <li>Users should keep their account credentials private and report suspicious activity.</li>
            </ul>
          </article>
        </section>
      </main>

      <Footer />
    </div>
  );
}
