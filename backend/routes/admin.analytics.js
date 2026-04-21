const express = require("express");
const { pool } = require("../conf/db");
const { authenticateToken, authenticateAdmin } = require("../middleware/auth");

const router = express.Router();

router.use(authenticateToken, authenticateAdmin);

function parseExcludedUserIds(value) {
  const raw = Array.isArray(value) ? value.join(",") : String(value || "");
  return [
    ...new Set(
      raw
        .split(",")
        .map((item) => Number(item.trim()))
        .filter((item) => Number.isInteger(item) && item > 0)
    ),
  ];
}

function excludedSql(alias, excludedUserIds) {
  if (!excludedUserIds.length) return { sql: "", params: [] };
  return {
    sql: ` AND ${alias}.id NOT IN (${excludedUserIds.map(() => "?").join(", ")})`,
    params: excludedUserIds,
  };
}

async function getUserCoinAnalysis(excludedUserIds) {
  const exclusion = excludedSql("u", excludedUserIds);

  const [[allBalances]] = await pool.query(
    `SELECT
       COUNT(*) AS total_users,
       COALESCE(SUM(cop_point), 0) AS total_user_coin_balance,
       COUNT(CASE WHEN cop_point > 0 THEN 1 END) AS users_holding_coins
     FROM users`
  );

  const [[filteredBalances]] = await pool.query(
    `SELECT
       COUNT(*) AS included_users,
       COALESCE(SUM(u.cop_point), 0) AS filtered_user_coin_balance,
       COUNT(CASE WHEN u.cop_point > 0 THEN 1 END) AS included_users_holding_coins
     FROM users u
     WHERE 1 = 1 ${exclusion.sql}`,
    exclusion.params
  );

  let excludedBalances = { excluded_users: 0, excluded_user_coin_balance: 0 };
  if (excludedUserIds.length) {
    [[excludedBalances]] = await pool.query(
      `SELECT
         COUNT(*) AS excluded_users,
         COALESCE(SUM(cop_point), 0) AS excluded_user_coin_balance
       FROM users
       WHERE id IN (${excludedUserIds.map(() => "?").join(", ")})`,
      excludedUserIds
    );
  }

  const [users] = await pool.query(
    `SELECT id, email, username, full_name, role, is_verified, is_blocked,
            wallet_address, game_id, cop_point, created_at
     FROM users
     ORDER BY cop_point DESC, created_at DESC`
  );

  return {
    summary: {
      total_users: Number(allBalances.total_users || 0),
      total_user_coin_balance: Number(allBalances.total_user_coin_balance || 0),
      users_holding_coins: Number(allBalances.users_holding_coins || 0),
      included_users: Number(filteredBalances.included_users || 0),
      filtered_user_coin_balance: Number(filteredBalances.filtered_user_coin_balance || 0),
      included_users_holding_coins: Number(filteredBalances.included_users_holding_coins || 0),
      excluded_users: Number(excludedBalances.excluded_users || 0),
      excluded_user_coin_balance: Number(excludedBalances.excluded_user_coin_balance || 0),
      excluded_user_ids: excludedUserIds,
    },
    users: users.map((user) => ({
      ...user,
      cop_point: Number(user.cop_point || 0),
      included_in_calculation: !excludedUserIds.includes(Number(user.id)),
    })),
  };
}

async function getHeistAnalysis() {
  const [heists] = await pool.query(
    `SELECT
       h.id,
       h.name,
       h.status,
       h.ticket_price,
       h.prize_cop_points,
       h.winner_user_id,
       winner.username AS winner_username,
       COUNT(DISTINCT hp.id) AS participant_count,
       COUNT(DISTINCT hs.id) AS submission_count,
       (COUNT(DISTINCT hp.id) * h.ticket_price) AS ticket_revenue,
       CASE
         WHEN h.status = 'completed' AND h.winner_user_id IS NOT NULL THEN h.prize_cop_points
         ELSE 0
       END AS prize_payout,
       ((COUNT(DISTINCT hp.id) * h.ticket_price) -
         CASE
           WHEN h.status = 'completed' AND h.winner_user_id IS NOT NULL THEN h.prize_cop_points
           ELSE 0
         END
       ) AS profit_loss,
       h.created_at,
       h.updated_at
     FROM heist h
     LEFT JOIN heist_participants hp ON hp.heist_id = h.id
     LEFT JOIN heist_submissions hs ON hs.heist_id = h.id AND hs.status = 'submitted'
     LEFT JOIN users winner ON winner.id = h.winner_user_id
     GROUP BY h.id
     ORDER BY h.created_at DESC, h.id DESC`
  );

  const summary = heists.reduce(
    (acc, heist) => {
      const revenue = Number(heist.ticket_revenue || 0);
      const payout = Number(heist.prize_payout || 0);
      const profit = Number(heist.profit_loss || 0);

      acc.total_heists += 1;
      acc.completed_heists += heist.status === "completed" ? 1 : 0;
      acc.active_heists += ["hold", "started"].includes(heist.status) ? 1 : 0;
      acc.pending_heists += heist.status === "pending" ? 1 : 0;
      acc.cancelled_heists += heist.status === "cancelled" ? 1 : 0;
      acc.total_participants += Number(heist.participant_count || 0);
      acc.total_ticket_revenue += revenue;
      acc.total_prize_payouts += payout;
      acc.total_profit_loss += profit;
      return acc;
    },
    {
      total_heists: 0,
      completed_heists: 0,
      active_heists: 0,
      pending_heists: 0,
      cancelled_heists: 0,
      total_participants: 0,
      total_ticket_revenue: 0,
      total_prize_payouts: 0,
      total_profit_loss: 0,
    }
  );

  return {
    summary,
    heists: heists.map((heist) => ({
      ...heist,
      ticket_price: Number(heist.ticket_price || 0),
      prize_cop_points: Number(heist.prize_cop_points || 0),
      participant_count: Number(heist.participant_count || 0),
      submission_count: Number(heist.submission_count || 0),
      ticket_revenue: Number(heist.ticket_revenue || 0),
      prize_payout: Number(heist.prize_payout || 0),
      profit_loss: Number(heist.profit_loss || 0),
    })),
  };
}

async function getTransactionCoinSummary() {
  const [[payins]] = await pool.query(
    `SELECT
       COALESCE(SUM(CASE WHEN status = 'approved' THEN coin_amount ELSE 0 END), 0) AS approved_payin_coins,
       COALESCE(SUM(CASE WHEN status = 'pending' THEN coin_amount ELSE 0 END), 0) AS pending_payin_coins,
       COALESCE(SUM(CASE WHEN status = 'rejected' THEN coin_amount ELSE 0 END), 0) AS rejected_payin_coins
     FROM manual_payin_requests`
  );

  const [[payouts]] = await pool.query(
    `SELECT
       COALESCE(SUM(CASE WHEN status = 'approved' THEN cop_points ELSE 0 END), 0) AS approved_payout_coins,
       COALESCE(SUM(CASE WHEN status = 'pending' THEN cop_points ELSE 0 END), 0) AS pending_payout_coins,
       COALESCE(SUM(CASE WHEN status = 'rejected' THEN cop_points ELSE 0 END), 0) AS rejected_payout_coins
     FROM payout_requests`
  );

  const [[affiliateRewards]] = await pool.query(
    `SELECT
       COALESCE(SUM(CASE WHEN p.is_completed = 1 THEN t.reward_cop_points ELSE 0 END), 0)
         AS affiliate_rewards_paid
     FROM affiliate_task_progress p
     JOIN affiliate_tasks t ON t.id = p.task_id`
  );

  return {
    approved_payin_coins: Number(payins.approved_payin_coins || 0),
    pending_payin_coins: Number(payins.pending_payin_coins || 0),
    rejected_payin_coins: Number(payins.rejected_payin_coins || 0),
    approved_payout_coins: Number(payouts.approved_payout_coins || 0),
    pending_payout_coins: Number(payouts.pending_payout_coins || 0),
    rejected_payout_coins: Number(payouts.rejected_payout_coins || 0),
    affiliate_rewards_paid: Number(affiliateRewards.affiliate_rewards_paid || 0),
  };
}

async function getAnalytics(excludedUserIds) {
  const [coinAnalysis, heistAnalysis, transactions] = await Promise.all([
    getUserCoinAnalysis(excludedUserIds),
    getHeistAnalysis(),
    getTransactionCoinSummary(),
  ]);

  const platformHeistBalance =
    heistAnalysis.summary.total_ticket_revenue - heistAnalysis.summary.total_prize_payouts;

  const estimatedPlatformCoinBalance = platformHeistBalance - transactions.affiliate_rewards_paid;
  const overallSystemBalance =
    coinAnalysis.summary.filtered_user_coin_balance + estimatedPlatformCoinBalance;

  return {
    generated_at: new Date().toISOString(),
    exclusions: {
      user_ids: excludedUserIds,
      excluded_user_count: coinAnalysis.summary.excluded_users,
      excluded_user_coin_balance: coinAnalysis.summary.excluded_user_coin_balance,
    },
    coins: coinAnalysis,
    heists: heistAnalysis,
    platform: {
      total_coins_held_by_users: coinAnalysis.summary.total_user_coin_balance,
      filtered_coins_held_by_users: coinAnalysis.summary.filtered_user_coin_balance,
      total_heist_ticket_inflow: heistAnalysis.summary.total_ticket_revenue,
      total_heist_prize_outflow: heistAnalysis.summary.total_prize_payouts,
      total_heist_profit_loss: heistAnalysis.summary.total_profit_loss,
      affiliate_reward_outflow: transactions.affiliate_rewards_paid,
      estimated_platform_coin_balance: estimatedPlatformCoinBalance,
      overall_system_balance: overallSystemBalance,
      transaction_coin_summary: transactions,
      reconciliation: [
        {
          label: "User balances counted",
          amount: coinAnalysis.summary.filtered_user_coin_balance,
          direction: "asset",
        },
        {
          label: "Heist ticket inflow",
          amount: heistAnalysis.summary.total_ticket_revenue,
          direction: "inflow",
        },
        {
          label: "Heist prize payouts",
          amount: heistAnalysis.summary.total_prize_payouts,
          direction: "outflow",
        },
        {
          label: "Affiliate rewards",
          amount: transactions.affiliate_rewards_paid,
          direction: "outflow",
        },
      ],
    },
  };
}

router.get("/", async (req, res) => {
  try {
    const excludedUserIds = parseExcludedUserIds(req.query.excluded_user_ids);
    const analytics = await getAnalytics(excludedUserIds);
    return res.json(analytics);
  } catch (err) {
    console.error("admin analytics error:", err);
    return res.status(500).json({ message: "Error fetching analytics" });
  }
});

router.get("/users", async (req, res) => {
  try {
    const excludedUserIds = parseExcludedUserIds(req.query.excluded_user_ids);
    const coins = await getUserCoinAnalysis(excludedUserIds);
    return res.json({ coins });
  } catch (err) {
    console.error("admin user coin analytics error:", err);
    return res.status(500).json({ message: "Error fetching user coin analytics" });
  }
});

router.get("/heists", async (req, res) => {
  try {
    const heists = await getHeistAnalysis();
    return res.json({ heists });
  } catch (err) {
    console.error("admin heist analytics error:", err);
    return res.status(500).json({ message: "Error fetching heist analytics" });
  }
});

module.exports = router;
