import React from "react";
import Header from "../../components/Header/Header";
import Footer from "../../components/Footer/Footer";
import styles from "./Legal.module.css";

export default function Support() {
  return (
    <div className={styles.page}>
      <Header />

      <main className={styles.main}>
        <section className={styles.hero}>
          <p className={styles.kicker}>Support</p>
          <h1>Need help?</h1>
          <p>
            Contact CopupBid support for help with your account, wallet balance, pay-in requests,
            payout requests, heist entries, leaderboard results, or affiliate links.
          </p>
        </section>

        <section className={styles.contactCard}>
          <div>
            <p className={styles.kicker}>Contact Email</p>
            <h2>Support@copupbid.top</h2>
            <p>
              Include your username, the heist or transaction you are asking about, and a clear
              description of the issue so support can review it faster.
            </p>
          </div>

          <a className={styles.emailLink} href="mailto:Support@copupbid.top">
            Email Support
          </a>
        </section>

        <section className={styles.grid}>
          <article className={styles.panel}>
            <h2>Wallet Help</h2>
            <p>
              For pay-in or payout issues, include the amount, date submitted, and any receipt or
              bank details connected to the request.
            </p>
          </article>

          <article className={styles.panel}>
            <h2>Heist Help</h2>
            <p>
              For heist issues, include the heist name, what happened when you joined or played,
              and whether you already submitted your answers.
            </p>
          </article>
        </section>
      </main>

      <Footer />
    </div>
  );
}
