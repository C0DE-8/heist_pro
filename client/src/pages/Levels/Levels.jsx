import React, { useCallback, useEffect, useMemo, useState } from "react";
import { RefreshCw } from "lucide-react";
import Header from "../../components/Header/Header";
import Footer from "../../components/Footer/Footer";
import BadgeLevelCard from "../../components/BadgeLevelCard/BadgeLevelCard";
import LevelProgressBar from "../../components/LevelProgressBar/LevelProgressBar";
import { getUserLevels } from "../../lib/levels";
import styles from "../Rewards/Rewards.module.css";
import gridStyles from "./Levels.module.css";

export default function Levels() {
  const [progress, setProgress] = useState(null);
  const [levels, setLevels] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const currentOrder = Number(progress?.current_level?.level_order || 1);

  const groupedLevels = useMemo(() => {
    return levels.reduce((groups, level) => {
      const name = level.badge_name || "Badge";
      if (!groups[name]) groups[name] = [];
      groups[name].push(level);
      return groups;
    }, {});
  }, [levels]);

  const loadLevels = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      const data = await getUserLevels();
      setProgress(data.progress);
      setLevels(data.levels);
    } catch (err) {
      setError(err?.response?.data?.message || "Unable to load levels.");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadLevels();
  }, [loadLevels]);

  return (
    <div className={styles.page}>
      <Header />
      <main className={styles.main}>
        <section className={styles.hero}>
          <div>
            <p className={styles.kicker}>Levels</p>
            <h1>Badge ladder</h1>
            <p>{loading ? "Loading levels..." : `${levels.length} levels across 8 badges`}</p>
          </div>
          <button type="button" className={styles.refreshBtn} onClick={loadLevels} disabled={loading}>
            <RefreshCw size={16} />
          </button>
        </section>

        {error ? <div className={styles.errorBox}>{error}</div> : null}

        <LevelProgressBar
          progress={progress}
          onLevels={() => window.location.assign("/levels")}
          onRewards={() => window.location.assign("/rewards")}
        />

        <div className={gridStyles.groups}>
          {Object.entries(groupedLevels).map(([badgeName, badgeLevels]) => (
            <section className={styles.panel} key={badgeName}>
              <div className={styles.panelHead}>
                <div>
                  <h2>{badgeName}</h2>
                  <p>I, II, III, IV, V</p>
                </div>
              </div>
              <div className={gridStyles.grid}>
                {badgeLevels.map((level) => (
                  <BadgeLevelCard
                    key={level.id}
                    level={level}
                    currentOrder={currentOrder}
                  />
                ))}
              </div>
            </section>
          ))}
        </div>
      </main>
      <Footer />
    </div>
  );
}
