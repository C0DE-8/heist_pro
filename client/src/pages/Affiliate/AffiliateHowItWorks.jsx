import React from "react";
import { useNavigate } from "react-router-dom";
import { FiArrowLeft, FiCheckCircle, FiTarget, FiTrendingUp, FiUsers } from "react-icons/fi";
import Header from "../../components/Header/Header";
import Footer from "../../components/Footer/Footer";
import styles from "./Affiliate.module.css";

export default function AffiliateHowItWorks() {
  const navigate = useNavigate();

  const steps = [
    {
      icon: <FiUsers />,
      title: "Bring referred users",
      text: "Share your referral link. Users who register with your code become part of your affiliate network.",
    },
    {
      icon: <FiTarget />,
      title: "Join one Tile plan",
      text: "You can earn from one active Tile plan at a time. You may qualify by referrals or pay the plan price with coins.",
    },
    {
      icon: <FiTrendingUp />,
      title: "Ticket activity counts",
      text: "When referred users buy heist tickets, those tickets count toward your monthly Tile target.",
    },
    {
      icon: <FiCheckCircle />,
      title: "Earn by performance",
      text: "Your estimated payout is based on the percentage of the Tile target reached for the current month.",
    },
  ];

  return (
    <div className={styles.page}>
      <Header />

      <main className={styles.main}>
        <div className={styles.topBar}>
          <button type="button" className={styles.backBtn} onClick={() => navigate("/affiliate-dashboard")}>
            <FiArrowLeft />
            <span>Affiliate Dashboard</span>
          </button>
        </div>

        <section className={styles.hero}>
          <div>
            <p className={styles.kicker}>Affiliate Guide</p>
            <h1>How Tile earnings work.</h1>
            <p>
              Your dashboard tracks referrals, network tickets, active Tile level, and estimated
              monthly earnings in CopUpCoin and naira value.
            </p>
          </div>
          <div className={styles.heroBadge}>
            <FiTarget />
            <span>One active Tile</span>
          </div>
        </section>

        <section className={styles.progressPanel}>
          {steps.map((step) => (
            <article className={styles.taskCard} key={step.title}>
              <div className={styles.taskTop}>
                <div>
                  <span className={styles.planLevel}>{step.icon} Step</span>
                  <h3>{step.title}</h3>
                </div>
              </div>
              <small>{step.text}</small>
            </article>
          ))}
        </section>
      </main>

      <Footer />
    </div>
  );
}
