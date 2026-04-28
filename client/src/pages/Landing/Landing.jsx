import React, { useEffect, useRef } from "react";
import { Link } from "react-router-dom";
import {
  FiArrowRight,
  FiCheckCircle,
  FiClock,
  FiCreditCard,
  FiDownload,
  FiSmartphone,
  FiSmile,
  FiTarget,
  FiTrendingUp,
  FiUsers,
  FiZap,
} from "react-icons/fi";
import Header from "../../components/Header/Header";
import Footer from "../../components/Footer/Footer";
import appApk from "../../assets/app/copupbid-2.0.apk";
import styles from "./Landing.module.css";

function useScrollReveal() {
  const rootRef = useRef(null);

  useEffect(() => {
    const root = rootRef.current;
    if (!root) return undefined;

    const nodes = root.querySelectorAll("[data-reveal]");
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add(styles.isVisible);
            observer.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.18, rootMargin: "0px 0px -8% 0px" }
    );

    nodes.forEach((node) => observer.observe(node));

    return () => observer.disconnect();
  }, []);

  return rootRef;
}

const stats = [
  { label: "Game Mode", value: "True / False" },
  { label: "Tie Breaker", value: "Fastest Time" },
  { label: "Reward", value: "CopUpCoin" },
];

const steps = [
  {
    icon: <FiCreditCard />,
    title: "Fund your wallet",
    text: "Buy CopUpCoin from your account page and keep your game balance ready.",
  },
  {
    icon: <FiTarget />,
    title: "Join a heist",
    text: "Pick an available heist, pay the entry fee, and start when the game opens.",
  },
  {
    icon: <FiZap />,
    title: "Answer fast",
    text: "Choose True or False, submit your run, and climb the leaderboard by score and speed.",
  },
];

const features = [
  "True/False gameplay only",
  "Prize paid in CopUpCoin",
  "Affiliate tasks and referral links",
  "Wallet pay-in and payout tracking",
];

export default function Landing() {
  const rootRef = useScrollReveal();

  return (
    <div className={styles.page} ref={rootRef}>
      <Header />

      <main>
        <section className={styles.hero}>
          <div className={styles.shapeField} aria-hidden="true">
            <span className={`${styles.shape} ${styles.shapeOne}`} />
            <span className={`${styles.shape} ${styles.shapeTwo}`} />
            <span className={`${styles.shape} ${styles.shapeThree}`} />
            <span className={`${styles.shape} ${styles.shapeFour}`} />
            <span className={`${styles.shape} ${styles.shapeFive}`} />
            <span className={`${styles.shape} ${styles.shapeSix}`} />
          </div>

          <div className={styles.heroInner}>
            <div className={styles.heroCopy} data-reveal>
              <p className={styles.kicker}>CopupBid Heist Arena</p>
              <h1>Play fast. Think sharper. Win CopUpCoin.</h1>
              <p>
                Enter bright True/False heists where every correct answer matters and speed decides
                the tight races.
              </p>

              <div className={styles.heroActions}>
                <Link className={styles.primaryBtn} to="/register">
                  Start Playing
                  <FiArrowRight />
                </Link>
                <Link className={styles.ghostBtn} to="/login">
                  Login
                </Link>
              </div>
            </div>

            <div className={styles.jokerPanel} data-reveal>
              <div className={styles.marqueeLane} aria-hidden="true">
                <span>TRUE</span>
                <span>FALSE</span>
                <span>APRIL FOOL</span>
                <span>HEIST</span>
              </div>

              <div className={`${styles.marqueeLane} ${styles.marqueeLaneReverse}`} aria-hidden="true">
                <span>FAST</span>
                <span>SMART</span>
                <span>JOKER MODE</span>
                <span>WIN</span>
              </div>

              <div className={styles.jokerCard} aria-hidden="true">
                <span className={styles.jokerCorner}>J</span>
                <span className={`${styles.jokerCorner} ${styles.jokerCornerBottom}`}>J</span>
                <div className={styles.jokerFace}>
                  <FiSmile />
                </div>
                <strong>Joker Round</strong>
                <p>April Fool's energy, real leaderboard pressure.</p>
              </div>

              <div className={styles.floatingChips} aria-hidden="true">
                <span>TRUE</span>
                <span>FALSE</span>
                <span>?</span>
                <span>CP</span>
              </div>
            </div>
          </div>
        </section>

        <section className={styles.stats}>
          {stats.map((item, index) => (
            <article
              className={styles.statCard}
              key={item.label}
              data-reveal
              style={{ "--delay": `${index * 80}ms` }}
            >
              <span>{item.label}</span>
              <strong>{item.value}</strong>
            </article>
          ))}
        </section>

        <section className={styles.section}>
          <div className={styles.sectionHead} data-reveal>
            <p className={styles.kicker}>How It Moves</p>
            <h2>A wallet game flow that feels instant.</h2>
          </div>

          <div className={styles.stepGrid}>
            {steps.map((step, index) => (
              <article
                className={styles.stepCard}
                key={step.title}
                data-reveal
                style={{ "--delay": `${index * 110}ms` }}
              >
                <div className={styles.stepIcon}>{step.icon}</div>
                <span>0{index + 1}</span>
                <h3>{step.title}</h3>
                <p>{step.text}</p>
              </article>
            ))}
          </div>
        </section>

        <section className={`${styles.section} ${styles.split}`}>
          <div className={styles.featurePanel} data-reveal>
            <p className={styles.kicker}>Why It Works</p>
            <h2>Simple rules. Bright feedback. Clear rewards.</h2>
            <p>
              CopupBid keeps the game focused: join a heist, answer True or False, submit your run,
              and let the leaderboard settle the winner.
            </p>
            <div className={styles.featureList}>
              {features.map((feature) => (
                <span key={feature}>
                  <FiCheckCircle />
                  {feature}
                </span>
              ))}
            </div>
          </div>

          <div className={styles.motionPanel} data-reveal>
            <div className={styles.tileStack} aria-hidden="true">
              <div className={styles.answerTile}>
                <FiTrendingUp />
                <strong>TRUE</strong>
              </div>
              <div className={styles.answerTile}>
                <FiClock />
                <strong>00:41</strong>
              </div>
              <div className={styles.answerTile}>
                <FiUsers />
                <strong>REF</strong>
              </div>
            </div>
          </div>
        </section>

        <section className={styles.downloadSection} data-reveal>
          <div className={styles.downloadCard}>
            <div>
              <p className={styles.kicker}>Android App</p>
              <h2>Download CopupBid for Android.</h2>
              <p>
                Install the latest Android build and keep CopUpCoin, heists, referrals, and wallet
                actions within reach.
              </p>

              <div className={styles.downloadMeta}>
                <span>
                  <FiSmartphone />
                  Direct APK install
                </span>
                <span>
                  <FiCheckCircle />
                  Version 2.0
                </span>
              </div>
            </div>

            <a className={styles.primaryBtn} href={appApk} download="copupbid-2.0.apk">
              Download APK
              <FiDownload />
            </a>
          </div>
        </section>

        <section className={styles.cta} data-reveal>
          <div>
            <p className={styles.kicker}>Ready</p>
            <h2>Open your first heist.</h2>
            <p>Create an account, fund your wallet, and start chasing the next CopUpCoin prize.</p>
          </div>
          <Link className={styles.primaryBtn} to="/register">
            Create Account
            <FiArrowRight />
          </Link>
        </section>
      </main>

      <Footer />
    </div>
  );
}
