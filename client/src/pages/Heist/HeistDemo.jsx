import React, { useMemo, useState } from "react";
import { useNavigate } from "react-router-dom";
import { FiArrowLeft, FiAward, FiClock, FiTarget } from "react-icons/fi";
import Header from "../../components/Header/Header";
import Footer from "../../components/Footer/Footer";
import HeistCard from "./HeistCard";
import heistStyles from "./Heist.module.css";
import playStyles from "./HeistPlay.module.css";

const demoHeist = {
  id: "demo",
  name: "Demo Heist",
  status: "demo",
  description: "A free copy of the heist flow with preset questions, players, and results.",
  prize_cop_points: 500,
  ticket_price: 0,
  total_participants: 4,
  max_users: 5,
  image: "/assets/m2-foods.png",
};

const demoQuestions = [
  {
    id: 1,
    question_text: "A real heist requires CopUpCoin before the user can join.",
    correct_answer: true,
  },
  {
    id: 2,
    question_text: "Leaderboard rank is decided by speed before correct answers.",
    correct_answer: false,
  },
  {
    id: 3,
    question_text: "After submitting, users can compare their run on the leaderboard.",
    correct_answer: true,
  },
];

const demoRows = [
  { username: "Ada Demo", correct_count: 3, wrong_count: 0, total_time_seconds: 18 },
  { username: "Tobi Demo", correct_count: 2, wrong_count: 1, total_time_seconds: 11 },
  { username: "Mira Demo", correct_count: 2, wrong_count: 1, total_time_seconds: 24 },
  { username: "Jay Demo", correct_count: 1, wrong_count: 2, total_time_seconds: 9 },
];

function formatNum(value) {
  const n = Number(value);
  return Number.isFinite(n) ? n.toLocaleString() : "0";
}

function rankRows(rows) {
  return [...rows]
    .sort((a, b) => {
      if (b.correct_count !== a.correct_count) return b.correct_count - a.correct_count;
      return a.total_time_seconds - b.total_time_seconds;
    })
    .map((row, index) => ({ ...row, rank: index + 1, score_percent: Math.round((row.correct_count / 3) * 100) }));
}

export default function HeistDemo() {
  const navigate = useNavigate();
  const [stage, setStage] = useState("intro");
  const [currentIndex, setCurrentIndex] = useState(0);
  const [answers, setAnswers] = useState([]);
  const [startedAt, setStartedAt] = useState(null);
  const [finishedAt, setFinishedAt] = useState(null);

  const answeredCount = answers.length;
  const isComplete = answeredCount >= demoQuestions.length;
  const currentQuestion = demoQuestions[currentIndex];

  const result = useMemo(() => {
    if (!finishedAt || !startedAt) return null;

    const correctCount = answers.filter((answer) => answer.is_correct).length;
    const wrongCount = demoQuestions.length - correctCount;
    const totalTime = Math.max(1, Math.round((finishedAt - startedAt) / 1000));
    const userRow = {
      username: "You (Demo)",
      correct_count: correctCount,
      wrong_count: wrongCount,
      total_time_seconds: totalTime,
      is_user: true,
    };
    const leaderboard = rankRows([...demoRows, userRow]);
    const userRank = leaderboard.find((row) => row.is_user)?.rank || leaderboard.length;
    const winner = leaderboard[0];

    return {
      correct_count: correctCount,
      wrong_count: wrongCount,
      total_time_seconds: totalTime,
      score_percent: Math.round((correctCount / demoQuestions.length) * 100),
      leaderboard,
      userRank,
      winner,
    };
  }, [answers, finishedAt, startedAt]);

  const joinDemo = () => {
    setStage("joined");
  };

  const startDemo = () => {
    setAnswers([]);
    setCurrentIndex(0);
    setStartedAt(Date.now());
    setFinishedAt(null);
    setStage("playing");
  };

  const chooseAnswer = (value) => {
    if (!currentQuestion || stage !== "playing") return;

    const nextAnswers = [
      ...answers,
      {
        question_id: currentQuestion.id,
        answer: value,
        is_correct: value === currentQuestion.correct_answer,
      },
    ];

    setAnswers(nextAnswers);

    if (nextAnswers.length >= demoQuestions.length) {
      setFinishedAt(Date.now());
      setStage("result");
      return;
    }

    setCurrentIndex((index) => index + 1);
  };

  const resetDemo = () => {
    setStage("intro");
    setCurrentIndex(0);
    setAnswers([]);
    setStartedAt(null);
    setFinishedAt(null);
  };

  const progressPct = Math.min(100, Math.round((answeredCount / demoQuestions.length) * 100));
  const promptTitle =
    stage === "intro"
      ? "Join the demo heist for free"
      : stage === "joined"
        ? "Start the copied heist flow"
        : stage === "result"
          ? "Demo result"
          : currentQuestion?.question_text || "Question";
  const promptCopy =
    stage === "intro"
      ? "In the real heist, users need CopUpCoin to join the set heist. This simulation is free and uses preset data."
      : stage === "joined"
        ? "This start card works like the real heist, but the questions and leaderboard are fixed for the demo."
        : stage === "result"
          ? "Your score is ranked against four preset demo users."
          : "Choose True or False. Correct answers rank first, then fastest time.";

  return (
    <div className={`${playStyles.page} ${playStyles.playPage}`}>
      <Header />

      <main className={`${playStyles.main} ${playStyles.playMain}`}>
        <button type="button" className={playStyles.backBtn} onClick={() => navigate("/how-to-play")}>
          <FiArrowLeft />
          <span>How To Play</span>
        </button>

        <section className={playStyles.gameHud}>
          <button type="button" className={playStyles.avatarBtn} onClick={resetDemo}>
            <span className={playStyles.avatarFace}>D</span>
            <span className={playStyles.avatarMeta}>
              <span className={playStyles.avatarName}>Demo Heist</span>
              <span className={playStyles.avatarSub}>Free simulation</span>
            </span>
          </button>

          <div className={playStyles.hudStats}>
            <div className={`${playStyles.hudPill} ${playStyles.prizePill}`}>
              Prize <strong>{formatNum(demoHeist.prize_cop_points)} CP</strong>
            </div>
            <div className={`${playStyles.hudPill} ${playStyles.coinPill}`}>
              Demo ticket <strong>Free</strong>
            </div>
            <div className={`${playStyles.hudPill} ${playStyles.questionPill}`}>
              Questions <strong>{formatNum(answeredCount)} / {formatNum(demoQuestions.length)}</strong>
            </div>
            <div className={`${playStyles.hudPill} ${playStyles.questionPill}`}>
              Seats <strong>4 / 5</strong>
            </div>
          </div>
        </section>

        <section className={playStyles.battlePanel}>
          <div className={playStyles.scene}>
            <div className={playStyles.stars} />
            <div className={playStyles.starDrift} />
            <div className={playStyles.mist} />
            <div className={`${playStyles.trees} ${playStyles.far}`} />
            <div className={`${playStyles.trees} ${playStyles.mid}`} />
            <div className={`${playStyles.trees} ${playStyles.near}`} />
            <div className={playStyles.path} />
            <div className={playStyles.ground} />
            <div className={playStyles.enemyMini}>
              <div className={playStyles.enemyMiniTrack}>
                <div className={playStyles.enemyMiniFill} style={{ width: `${progressPct}%` }} />
              </div>
            </div>
            <div className={`${playStyles.sceneCornerName} ${playStyles.playerCorner}`}>You</div>
            <div className={`${playStyles.sceneCornerName} ${playStyles.enemyCorner}`}>
              Question {Math.min(currentIndex + 1, demoQuestions.length)}
            </div>
            <div className={`${playStyles.fighter} ${playStyles.playerFighter}`}>
              <div className={playStyles.sprite}>T</div>
            </div>
            <div className={`${playStyles.fighter} ${playStyles.enemyFighter}`}>
              <div className={playStyles.sprite}>F</div>
            </div>
          </div>
        </section>

        <section className={playStyles.gamePanel}>
          <div className={playStyles.promptHead}>
            <div>
              <h2 className={playStyles.promptTitle}>{promptTitle}</h2>
              <p className={playStyles.promptCopy}>{promptCopy}</p>
            </div>
          </div>

          {stage === "intro" ? (
            <div className={heistStyles.demoCardWrap}>
              <HeistCard heist={demoHeist} onAction={joinDemo} />
              <div className={heistStyles.demoNote}>
                <strong>Demo note</strong>
                <span>
                  The real heist charges CopUpCoin when a user joins. This copy is only to show how
                  joining, starting, answering, scoring, and leaderboard ranking work.
                </span>
              </div>
            </div>
          ) : null}

          {stage === "joined" ? (
            <div className={`${playStyles.cardGrid} ${playStyles.twoCard}`}>
              <button
                type="button"
                className={`${playStyles.playCard} ${playStyles.trueCard}`}
                onClick={startDemo}
                style={{ "--tilt": "-1.5deg" }}
              >
                <span className={playStyles.cardCorner}>GO</span>
                <span className={`${playStyles.cardCorner} ${playStyles.bottom}`}>GO</span>
                <span className={playStyles.cardGlyph}>▶</span>
                <div className={playStyles.cardBody}>
                  <span className={playStyles.cardTag}>Start</span>
                  <h4 className={playStyles.cardTitle}>Begin Demo Heist</h4>
                  <p className={playStyles.cardCopy}>Load the three preset true or false questions.</p>
                  <span className={playStyles.cardPrice}>3 questions this run</span>
                </div>
              </button>
            </div>
          ) : null}

          {stage === "playing" && !isComplete ? (
            <div className={`${playStyles.cardGrid} ${playStyles.twoCard}`}>
              <button
                type="button"
                className={`${playStyles.playCard} ${playStyles.trueCard}`}
                onClick={() => chooseAnswer(true)}
                style={{ "--tilt": "-2deg" }}
              >
                <span className={playStyles.cardCorner}>T</span>
                <span className={`${playStyles.cardCorner} ${playStyles.bottom}`}>T</span>
                <span className={playStyles.cardGlyph}>T</span>
                <div className={playStyles.cardBody}>
                  <span className={playStyles.cardTag}>Answer</span>
                  <h4 className={playStyles.cardTitle}>TRUE</h4>
                  <p className={playStyles.cardCopy}>Trust the statement.</p>
                  <span className={playStyles.cardPrice}>Question {formatNum(currentIndex + 1)}</span>
                </div>
              </button>

              <button
                type="button"
                className={`${playStyles.playCard} ${playStyles.falseCard}`}
                onClick={() => chooseAnswer(false)}
                style={{ "--tilt": "2deg" }}
              >
                <span className={playStyles.cardCorner}>F</span>
                <span className={`${playStyles.cardCorner} ${playStyles.bottom}`}>F</span>
                <span className={playStyles.cardGlyph}>F</span>
                <div className={playStyles.cardBody}>
                  <span className={playStyles.cardTag}>Answer</span>
                  <h4 className={playStyles.cardTitle}>FALSE</h4>
                  <p className={playStyles.cardCopy}>Call the statement wrong.</p>
                  <span className={playStyles.cardPrice}>Question {formatNum(currentIndex + 1)}</span>
                </div>
              </button>
            </div>
          ) : null}

          {stage === "result" && result ? (
            <div className={heistStyles.demoResultStack}>
              <div className={heistStyles.statsGrid}>
                <div>
                  <span>Correct</span>
                  <strong>{formatNum(result.correct_count)}</strong>
                </div>
                <div>
                  <span>Wrong</span>
                  <strong>{formatNum(result.wrong_count)}</strong>
                </div>
                <div>
                  <span>Time</span>
                  <strong>{formatNum(result.total_time_seconds)}s</strong>
                </div>
              </div>

              <div className={heistStyles.winnerBox}>
                <span>{result.userRank === 1 ? "You won the demo" : "Demo winner"}</span>
                <strong>
                  {result.userRank === 1
                    ? `You topped the demo users and won ${formatNum(demoHeist.prize_cop_points)} CP.`
                    : `${result.winner.username} wins the prize with ${formatNum(
                        result.winner.correct_count
                      )} correct in ${formatNum(result.winner.total_time_seconds)}s.`}
                </strong>
              </div>

              <div className={heistStyles.demoActions}>
                <button type="button" className={heistStyles.secondaryBtn} onClick={resetDemo}>
                  Try Again
                </button>
                <a className={heistStyles.secondaryBtn} href="#demo-leaderboard">
                  Leaderboard
                </a>
              </div>
            </div>
          ) : null}
        </section>

        {stage === "result" && result ? (
          <section className={heistStyles.resultPanel} id="demo-leaderboard">
            <div className={heistStyles.sectionHead}>
              <div>
                <h2>Demo Leaderboard</h2>
                <p>Preset users plus your demo run.</p>
              </div>
            </div>

            <div className={heistStyles.leaderboardTableWrap}>
              <table className={heistStyles.leaderboardTable}>
                <thead>
                  <tr>
                    <th>Rank</th>
                    <th>Player</th>
                    <th>Correct</th>
                    <th>Wrong</th>
                    <th>Score</th>
                    <th>Time</th>
                  </tr>
                </thead>
                <tbody>
                  {result.leaderboard.map((row) => (
                    <tr
                      key={`${row.rank}-${row.username}`}
                      className={row.is_user ? heistStyles.userDemoRow : undefined}
                    >
                      <td>
                        <strong>#{formatNum(row.rank)}</strong>
                      </td>
                      <td>{row.username}</td>
                      <td>
                        <FiTarget />
                        {formatNum(row.correct_count)}
                      </td>
                      <td>{formatNum(row.wrong_count)}</td>
                      <td>{formatNum(row.score_percent)}%</td>
                      <td>
                        <FiClock />
                        {formatNum(row.total_time_seconds)}s
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            <div className={heistStyles.demoActions}>
              <button type="button" className={heistStyles.secondaryBtn} onClick={() => navigate("/heist")}>
                <FiAward />
                <span>Open Real Heists</span>
              </button>
            </div>
          </section>
        ) : null}
      </main>

      <Footer />
    </div>
  );
}
