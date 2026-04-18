import React from "react";
import Header from "../../components/Header/Header";
import Footer from "../../components/Footer/Footer";
import styles from "./Legal.module.css";

export default function Terms() {
  return (
    <div className={styles.page}>
      <Header />

      <main className={styles.main}>
        <section className={styles.hero}>
          <p className={styles.kicker}>Terms</p>
          <h1>Terms of Use</h1>
          <p>
            These terms explain how CopupBid users access wallet features, True/False heists,
            affiliate rewards, pay-ins, and payouts on the platform.
          </p>
          <div className={styles.metaRow}>
            <span className={styles.pill}>Issue date: 2024</span>
            <span className={styles.pill}>Platform: CopupBid</span>
          </div>
        </section>

        <section className={styles.grid}>
          <article className={styles.panel}>
            <h2>Account Use</h2>
            <p>
              You are responsible for keeping your login details secure and for activity that
              happens through your account. Information submitted to CopupBid must be accurate and
              must not be used to mislead other users or the platform.
            </p>
          </article>

          <article className={styles.panel}>
            <h2>Wallet and Coins</h2>
            <p>
              CopUpCoin balances are used inside CopupBid for heist entry, rewards, affiliate task
              rewards, and payout requests. Coin rates, pay-in details, and transaction decisions
              may be updated by the platform when needed.
            </p>
          </article>

          <article className={styles.panel}>
            <h2>Heists and Ranking</h2>
            <p>
              Heists are True/False games. Entry fees are deducted from the user balance when a
              user joins. Winners are ranked by correct answers first, then total time, then
              submission time. Final rewards are credited after the heist is completed.
            </p>
          </article>

          <article className={styles.panel}>
            <h2>Affiliate Rewards</h2>
            <p>
              Affiliate rewards may be available for active heists. Self-referrals, duplicate
              referrals, or attempts to manipulate referral tracking are not allowed. Rewards are
              counted only according to active task rules.
            </p>
          </article>

          <article className={`${styles.panel} ${styles.wide}`}>
            <h2>Transactions and Platform Control</h2>
            <ul>
              <li>Pay-in requests may require proof of payment before coins are credited.</li>
              <li>Payout requests may be reviewed, approved, rejected, or delayed for verification.</li>
              <li>Rejected transactions may include a reason where applicable.</li>
              <li>CopupBid may restrict accounts that abuse gameplay, payments, referrals, or security rules.</li>
            </ul>
          </article>
        </section>
      </main>

      <Footer />
    </div>
  );
}
