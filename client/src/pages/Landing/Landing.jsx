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
import copupGif from "../../assets/copup.gif";
import flowerImg from "../../assets/flower.png";
import flowerFlowingImg from "../../assets/flower-flowing.png";
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
  { label: "True/False Format", value: "Sharp Decisions" },
  { label: "Fastest Wins Ties", value: "Speed Matters" },
  { label: "Reward Drop", value: "CopUpCoin" },
];

const steps = [
  {
    icon: <FiCreditCard />,
    title: "Load up for May",
    text: "Buy CopUpCoin from your account page and keep your balance ready for fresh heists and faster runs.",
  },
  {
    icon: <FiTarget />,
    title: "Join the drop",
    text: "Pick an active heist, pay the entry fee, and jump in the moment the round opens.",
  },
  {
    icon: <FiZap />,
    title: "Think fast. Win faster.",
    text: "Choose True or False, submit your run, and push up the leaderboard with clean answers and quick timing.",
  },
];

const features = [
  "True/False gameplay with fast rounds",
  "CopUpCoin prizes for winning runs",
  "Affiliate tasks and referral growth",
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
            <img src={flowerFlowingImg} alt="" className={styles.flowingFlower} />
            <img src={flowerImg} alt="" className={styles.cornerFlower} />
          </div>

          <div className={styles.heroInner}>
            <div className={styles.heroCopy} data-reveal>
              <p className={styles.kicker}>May Heist Drop</p>
              <div className={styles.wordmark} aria-label="CopUpBid">
                <span>CopUpB</span>
                <span className={styles.wordmarkI}>
                  ı
                  <img src={copupGif} alt="" className={styles.wordmarkGif} />
                </span>
                <span>d</span>
              </div>
              <h1>May Your Success Bloom.</h1>
              <p>
                This May, think fast, answer smart, and win CopUpCoin in bright True/False heists
                where speed can still break the tightest race.
              </p>

              <div className={styles.heroPills} aria-label="May campaign highlights">
                <span>Fresh Month. Fresh Heists. Fresh Wins.</span>
                <span>May The Fastest Mind Win.</span>
                <span>May Rewards Are Waiting.</span>
              </div>

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
              <img src={flowerImg} alt="" className={styles.panelFlower} />
              <div className={styles.marqueeLane} aria-hidden="true">
                <span>TRUE</span>
                <span>FALSE</span>
                <span>MAY DROP</span>
                <span>BLOOM</span>
                <span>HEIST</span>
              </div>

              <div
                className={`${styles.marqueeLane} ${styles.marqueeLaneReverse}`}
                aria-hidden="true"
              >
                <span>FAST</span>
                <span>SMART</span>
                <span>MAY MODE</span>
                <span>BLOOM</span>
                <span>WIN</span>
              </div>

              <div className={styles.jokerCard} aria-hidden="true">
                <span className={styles.jokerCorner}>J</span>
                <span className={`${styles.jokerCorner} ${styles.jokerCornerBottom}`}>J</span>
                <div className={styles.jokerFace}>
                  <FiSmile />
                </div>
                <strong>Bloom Mode</strong>
                <p>May momentum starts here. Fresh energy, real leaderboard pressure.</p>
              </div>

              <div className={styles.floatingChips} aria-hidden="true">
                <span>TRUE</span>
                <span>FALSE</span>
                <span>BLOOM</span>
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
            <p className={styles.kicker}>May Momentum Starts Here</p>
            <h2>Bloom fast. Answer smart. Win CopUpCoin.</h2>
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
            <p className={styles.kicker}>Fresh Month. Fresh Wins.</p>
            <h2>New month. New heist. New reward.</h2>
            <p>
              CopupBid keeps the heist flow sharp: join the round, answer True or False, submit
              your run, and let fast thinking and faster timing decide the winner.
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
              <p className={styles.kicker}>May Rewards Are Waiting</p>
              <h2>Download CopupBid for Android.</h2>
              <p>
                Install the latest Android build and keep heists, CopUpCoin rewards, referrals, and
                wallet actions within reach all month long.
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
            <p className={styles.kicker}>Your May Winning Streak Starts Now</p>
            <h2>Bloom into victory.</h2>
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
