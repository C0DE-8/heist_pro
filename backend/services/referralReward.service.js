async function ensureReferralSettings(db) {
  await db.query(
    `INSERT INTO admin_referral_settings
      (id, is_enabled, required_heist_joins, reward_cop_points, reset_version)
     VALUES (1, 0, 3, 1, 1)
     ON DUPLICATE KEY UPDATE id = id`
  );

  const [[settings]] = await db.query(
    `SELECT
       id,
       is_enabled,
       required_heist_joins,
       reward_cop_points,
       reset_version,
       updated_by,
       last_reset_by,
       last_reset_at,
       created_at,
       updated_at
     FROM admin_referral_settings
     WHERE id = 1
     LIMIT 1 FOR UPDATE`
  );

  return normalizeSettings(settings);
}

function normalizeSettings(settings) {
  if (!settings) return null;
  return {
    ...settings,
    is_enabled: Boolean(Number(settings.is_enabled)),
    required_heist_joins: Number(settings.required_heist_joins || 0),
    reward_cop_points: Number(settings.reward_cop_points || 0),
    reset_version: Number(settings.reset_version || 1),
  };
}

async function applyReferralRewardJoin(db, referredUserId, heistId) {
  const settings = await ensureReferralSettings(db);

  const [[relation]] = await db.query(
    `SELECT referrer_id
     FROM referrals
     WHERE referred_id = ?
     LIMIT 1`,
    [referredUserId]
  );

  if (!relation) {
    return {
      settings,
      tracked: false,
      reason: "not_referred",
      awarded: [],
      progress: null,
    };
  }

  if (!settings.is_enabled) {
    return {
      settings,
      tracked: false,
      reason: "disabled",
      awarded: [],
      progress: null,
    };
  }

  await db.query(
    `INSERT INTO referral_reward_progress
      (reset_version, referrer_id, referred_user_id, joined_heists, last_joined_heist_id, last_joined_at)
     VALUES (?, ?, ?, 1, ?, NOW())
     ON DUPLICATE KEY UPDATE
       referrer_id = VALUES(referrer_id),
       last_joined_heist_id = VALUES(last_joined_heist_id),
       last_joined_at = VALUES(last_joined_at),
       joined_heists = IF(rewarded_at IS NULL, joined_heists + 1, joined_heists)`,
    [settings.reset_version, relation.referrer_id, referredUserId, heistId]
  );

  const [[progress]] = await db.query(
    `SELECT
       id,
       reset_version,
       referrer_id,
       referred_user_id,
       joined_heists,
       rewarded_at,
       awarded_cop_points,
       last_joined_heist_id,
       last_joined_at,
       created_at,
       updated_at
     FROM referral_reward_progress
     WHERE reset_version = ? AND referred_user_id = ?
     LIMIT 1 FOR UPDATE`,
    [settings.reset_version, referredUserId]
  );

  return {
    settings,
    tracked: true,
    reason: null,
    awarded: [],
    progress: progress
      ? {
          ...progress,
          joined_heists: Number(progress.joined_heists || 0),
          awarded_cop_points: Number(progress.awarded_cop_points || 0),
          is_claimable:
            !progress.rewarded_at &&
            Number(progress.joined_heists || 0) >= Number(settings.required_heist_joins || 0),
          is_rewarded: Boolean(progress.rewarded_at),
        }
      : null,
  };
}

async function claimReferralReward(db, referrerId, referredUserId) {
  const settings = await ensureReferralSettings(db);
  if (!settings.is_enabled) {
    throw new Error("Referral reward system is currently disabled");
  }

  const [[progress]] = await db.query(
    `SELECT
       id,
       referrer_id,
       referred_user_id,
       joined_heists,
       rewarded_at,
       awarded_cop_points
     FROM referral_reward_progress
     WHERE reset_version = ?
       AND referrer_id = ?
       AND referred_user_id = ?
     LIMIT 1 FOR UPDATE`,
    [settings.reset_version, referrerId, referredUserId]
  );

  if (!progress) {
    throw new Error("Referral progress not found");
  }
  if (progress.rewarded_at) {
    throw new Error("Reward already claimed for this referred user");
  }
  if (Number(progress.joined_heists || 0) < Number(settings.required_heist_joins || 0)) {
    throw new Error("This referred user has not reached the required heist goal");
  }

  await db.query("UPDATE users SET cop_point = cop_point + ? WHERE id = ?", [
    settings.reward_cop_points,
    referrerId,
  ]);
  await db.query(
    `UPDATE referral_reward_progress
     SET rewarded_at = NOW(),
         awarded_cop_points = ?
     WHERE id = ? AND rewarded_at IS NULL`,
    [settings.reward_cop_points, progress.id]
  );

  return {
    progress_id: Number(progress.id),
    referred_user_id: Number(progress.referred_user_id),
    joined_heists: Number(progress.joined_heists || 0),
    awarded_cop_points: Number(settings.reward_cop_points),
  };
}

module.exports = {
  ensureReferralSettings,
  normalizeSettings,
  applyReferralRewardJoin,
  claimReferralReward,
};
