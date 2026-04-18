import React, { useMemo, useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  FiCheckCircle,
  FiCopy,
  FiCreditCard,
  FiDownload,
  FiHelpCircle,
  FiTarget,
  FiUsers,
  FiZap,
} from "react-icons/fi";
import Header from "../../components/Header/Header";
import Footer from "../../components/Footer/Footer";
import styles from "./HowItWork.module.css";

function Step({ number, title, text }) {
  return (
    <div className={styles.step}>
      <span>{number}</span>
      <div>
        <strong>{title}</strong>
        <p>{text}</p>
      </div>
    </div>
  );
}

export default function HowItWork() {
  const navigate = useNavigate();
  const [copied, setCopied] = useState(false);

  const quickFacts = useMemo(
    () => [
      { label: "Game type", value: "True / False Heists" },
      { label: "Reward", value: "CopUpCoin balance" },
      { label: "Ranking", value: "Correct answers, then speed" },
    ],
    []
  );

  const copySummary = async () => {
    try {
      await navigator.clipboard.writeText(
        "CopUp Heist: buy coins, join a True/False heist, answer fast, and win CopUpCoin rewards."
      );
      setCopied(true);
      setTimeout(() => setCopied(false), 1400);
    } catch {
      setCopied(false);
    }
  };

  return (
    <div className={styles.page}>
      <Header />

      <main className={styles.main}>
        <section className={styles.hero}>
          <div>
            <p className={styles.kicker}>How To Play</p>
            <h1>Win CopUpCoin with True/False Heists.</h1>
            <p>
              Fund your wallet, join a heist, answer every question, and climb the leaderboard.
              Winners are ranked by correct answers first, then fastest total time.
            </p>
          </div>

          <div className={styles.heroActions}>
            <button type="button" className={styles.primaryBtn} onClick={() => navigate("/heist")}>
              <FiTarget />
              <span>Open Heists</span>
            </button>
            <button type="button" className={styles.ghostBtn} onClick={copySummary}>
              <FiCopy />
              <span>{copied ? "Copied!" : "Copy Summary"}</span>
            </button>
          </div>
        </section>

        <section className={styles.factGrid}>
          {quickFacts.map((fact) => (
            <div className={styles.factCard} key={fact.label}>
              <span>{fact.label}</span>
              <strong>{fact.value}</strong>
            </div>
          ))}
        </section>

        <section className={styles.grid}>
          <article className={styles.panel}>
            <div className={styles.panelHead}>
              <div>
                <p className={styles.kicker}>Wallet</p>
                <h2>Get CopUpCoin</h2>
              </div>
              <FiCreditCard />
            </div>

            <div className={styles.steps}>
              <Step
                number="1"
                title="Choose coins"
                text="Go to Account, enter the number of coins you want, and the system calculates the exact NGN amount."
              />
              <Step
                number="2"
                title="Transfer exact amount"
                text="Use the generated pay-in details and copy the amount or account number to avoid transfer mistakes."
              />
              <Step
                number="3"
                title="Upload receipt"
                text="Submit your receipt. Once confirmed, your CopUpCoin balance is credited automatically."
              />
            </div>
          </article>

          <article className={styles.panel}>
            <div className={styles.panelHead}>
              <div>
                <p className={styles.kicker}>Heist</p>
                <h2>Play the game</h2>
              </div>
              <FiZap />
            </div>

            <div className={styles.steps}>
              <Step
                number="1"
                title="Join a heist"
                text="Pick an available heist and pay the ticket price from your CopUpCoin balance."
              />
              <Step
                number="2"
                title="Answer True or False"
                text="Each question has only two choices. Correct answers matter most, but speed breaks ties."
              />
              <Step
                number="3"
                title="Submit your run"
                text="When you finish, submit your answers to lock your score and view the leaderboard."
              />
            </div>
          </article>

          <article className={styles.panel}>
            <div className={styles.panelHead}>
              <div>
                <p className={styles.kicker}>Leaderboard</p>
                <h2>How winners rank</h2>
              </div>
              <FiCheckCircle />
            </div>

            <div className={styles.rankBox}>
              <div>
                <span>1</span>
                <strong>Correct answers</strong>
                <p>More correct answers always rank higher.</p>
              </div>
              <div>
                <span>2</span>
                <strong>Total time</strong>
                <p>If correct counts tie, the faster total time wins.</p>
              </div>
              <div>
                <span>3</span>
                <strong>Submit time</strong>
                <p>If both are tied, the earlier submission ranks higher.</p>
              </div>
            </div>
          </article>

          <article className={styles.panel}>
            <div className={styles.panelHead}>
              <div>
                <p className={styles.kicker}>Affiliate</p>
                <h2>Share and earn</h2>
              </div>
              <FiUsers />
            </div>

            <div className={styles.steps}>
              <Step
                number="1"
                title="Generate your link"
                text="Open the Affiliate page and generate a link for any available heist."
              />
              <Step
                number="2"
                title="Bring players"
                text="When another user joins through your link, it can count toward active affiliate tasks."
              />
              <Step
                number="3"
                title="Earn task rewards"
                text="When you complete a task target, the reward is credited to your CopUpCoin balance."
              />
            </div>
          </article>
        </section>

        <section className={styles.footerPanel}>
          <FiDownload />
          <div>
            <h2>Withdrawals</h2>
            <p>
              You can request payouts from the Account page. Withdrawal requests reserve the coins
              while pending, and rejected requests return the coins to your balance.
            </p>
          </div>
        </section>

        <section className={styles.helpPanel}>
          <FiHelpCircle />
          <div>
            <h2>Need a simple start?</h2>
            <p>Go to Account, buy coins, then open Heists and join one that is available.</p>
          </div>
          <button type="button" className={styles.primaryBtn} onClick={() => navigate("/account")}>
            <FiCreditCard />
            <span>Open Account</span>
          </button>
        </section>
      </main>

      <Footer />
    </div>
  );
}
