# User Level Progress And Coupon Reward Flow

## Goal

Build a user progress system where players earn XP from normal CopUpBid activity, move through badge ranks, and receive coupon codes when they level up. Users can see their progress bar on user-facing pages, redeem earned codes in the redeem section, and admins can manage the level rules, rewards, assets, and audit history.

## XP Sources

Users earn XP from these events:

- Playing a heist game.
- Winning a heist.
- Logging in daily.
- Referring other users.
- Making a deposit.
- Making a withdrawal.

Each XP event must be recorded once with a clear source, source id, XP amount, and timestamp so the backend can prevent duplicate rewards.

## Badge And Level Structure

There are 8 badges. Each badge has 5 levels inside it.

Example naming:

- Beginner I
- Beginner II
- Beginner III
- Beginner IV
- Beginner V

The full ladder should follow the same pattern for all 8 badges:

| Badge Order | Badge Name | Levels |
| --- | --- | --- |
| 1 | Beginner | I, II, III, IV, V |
| 2 | Rookie | I, II, III, IV, V |
| 3 | Hustler | I, II, III, IV, V |
| 4 | Raider | I, II, III, IV, V |
| 5 | Specialist | I, II, III, IV, V |
| 6 | Elite | I, II, III, IV, V |
| 7 | Mastermind | I, II, III, IV, V |
| 8 | Legend | I, II, III, IV, V |

Total progression levels: 40.

Final badge names can be changed before implementation, but the backend should store them as configurable data (sql) instead of hardcoding them only in the frontend.

## User Flow

1. User signs in.
2. Backend checks daily check-in XP eligibility after login.
3. User profile/dashboard receives current XP, current badge, current level, next level XP target, progress percentage, and unclaimed coupon rewards.
4. If the user has not checked in today, the dashboard shows a daily check-in prompt.
5. User clicks the check-in prompt to claim today's XP.
6. After claim, the prompt changes to a check-in-tomorrow state and does not show again until the next day.
7. User plays heist, wins heist, refers another user, deposits, or withdraws.
8. Backend records the XP event.
9. Backend recalculates the user level.
10. If the user crossed one or more levels, backend creates coupon reward records for each earned level.
11. User sees a progress bar update and a level-up/reward state.
12. User opens redeem section.
13. User copies or redeems the earned coupon code.
14. Backend marks coupon reward as claimed/redeemed and writes an audit record.

## Backend Build Checklist

- [x] Add a new level/progress service: `backend/services/levelProgress.service.js`.
- [x] Add a user-facing route file: `backend/routes/user.levels.js`.
- [x] Add an admin route file: `backend/routes/admin.levels.js`.
- [x] Register routes in `backend/server.js`.
- [x] Add helper methods for awarding XP:
  - [x] `awardXp(userId, source, sourceId, amount, metadata)`
  - [x] `getUserProgress(userId)`
  - [x] level-up detection inside `awardXp`
  - [x] level coupon reward creation inside `awardXp`
  - [x] `claimLevelReward(userId, rewardId)`
  - [x] `redeemLevelRewardCode(userId, code)`
- [x] Make XP awarding idempotent by using unique keys per source event.
- [x] Connect heist play XP inside existing heist submit/play flow.
- [x] Connect heist win XP inside existing heist winner/completion flow.
- [x] Connect daily check-in XP to an explicit user claim endpoint after login.
- [x] Connect referral XP inside existing claimed referral reward flow.
- [x] Connect deposit XP inside Flutterwave success and manual pay-in approval flows.
- [x] Connect withdrawal XP inside transaction payout approved/completed flow.
- [x] Return progress data in user profile API responses.
- [x] Add backend validation so users cannot claim another user's coupon.
- [x] Add backend validation so coupon rewards cannot be claimed twice.
- [x] Add admin audit logs for XP adjustments and coupon status changes.

## SQL And Migration Checklist

Created migration:

`backend/migrations/20260830_user_level_progress.sql`

Suggested tables:

- [x] `level_badges`
  - Badge names, order, image path, active status.
- [x] `level_definitions`
  - One row per badge level, XP required, coupon reward configuration.
- [x] `xp_source_rules`
  - Configurable XP values for login, heist play, heist win, referral, deposit, withdrawal, and admin adjustment.
- [x] `user_xp_totals`
  - Current total XP and current level for each user.
- [x] `user_xp_events`
  - Immutable XP ledger for heist play, heist win, login, referral, deposit, and withdrawal.
- [x] `user_level_rewards`
  - Coupon rewards earned by level-up events.
- [x] `level_admin_audit_logs`
  - Admin audit history for XP adjustments and reward status changes.

Important indexes:

- [x] Unique event key on `user_xp_events(user_id, source, source_id)`.
- [x] Index `user_xp_events(user_id, created_at)`.
- [x] Unique level reward key on `user_level_rewards(user_id, level_definition_id)`.
- [x] Index `user_level_rewards(user_id, status)`.

Decision needed during build:

- [x] Use level-specific reward codes in `user_level_rewards`, and redeem them into the existing CopUp Jr balance/ledger from `backend/services/promo.service.js`.
- [x] Apply the migration to the local database. Applied to `heist_pro`: 8 badges, 40 levels, and 7 XP rules.

## API Checklist

User APIs:

- [x] `GET /api/users/progress`
  - Returns total XP, badge, level, progress percentage, next level target, recent XP events, and unclaimed rewards.
- [x] `GET /api/users/progress/levels`
  - Returns the user's progress plus all level definitions.
- [x] `POST /api/users/progress/daily-check-in`
  - Claims today's daily check-in XP only if the user has not already claimed it for the current database date.
- [x] `GET /api/users/progress/rewards`
  - Returns all earned level coupon rewards.
- [x] `POST /api/users/progress/rewards/:id/claim`
  - Claims or reveals an earned coupon reward.
- [x] `POST /api/users/progress/rewards/redeem-code`
  - Redeems an earned level coupon code into CopUp Jr balance.
- [x] Existing promo redeem endpoint stays available for entering promo codes manually.

Admin APIs:

- [x] `GET /api/admin/levels/summary`
- [x] `GET /api/admin/levels/badges`
- [x] `POST /api/admin/levels/badges`
- [x] `PATCH /api/admin/levels/badges/:id`
- [x] `GET /api/admin/levels/definitions`
- [x] `POST /api/admin/levels/definitions`
- [x] `PATCH /api/admin/levels/definitions/:id`
- [x] `GET /api/admin/levels/xp-rules`
- [x] `PATCH /api/admin/levels/xp-rules/:source`
- [x] `GET /api/admin/levels/users/:userId`
- [x] `POST /api/admin/levels/users/:userId/adjust-xp`
  - Supports adding or removing XP with a required admin reason.
- [x] `GET /api/admin/levels/rewards`
- [x] `PATCH /api/admin/levels/rewards/:id`

## Frontend User Checklist

- [x] Add API helpers in `client/src/lib/levels.js`.
- [x] Add a reusable progress component: `LevelProgressBar`.
- [x] Add badge display UI with badge image, badge name, roman numeral level, and total XP.
- [x] Show progress on user dashboard/home/profile/account/payment result/heist result.
- [x] Add recent XP event list so users know why their progress changed.
- [x] Add reward claim/redeem state after a new coupon is earned.
- [x] Add reward list to the redeem section.
- [x] Add clear statuses:
  - [x] Earned
  - [x] Claimed
  - [x] Redeemed
  - [x] Expired
- [x] Keep manual promo code redeem support working with the existing heist promo balance flow.
- [x] Add mobile responsive styling for the progress bar and badge cards.

## Frontend User Pages Needed

Add these user-facing pages/components so normal users can see progress, rewards, and coupon activity.

| Page | Route | Suggested File | Purpose |
| --- | --- | --- | --- |
| Dashboard progress widget | `/dashboard` | Update `client/src/pages/Home/Home.jsx` | Show current badge, level, XP progress bar, next reward, and latest XP events on the main user dashboard. |
| Profile progress summary | `/profile` | Update `client/src/pages/Profile/Profile.jsx` | Show full badge name, current level, total XP, joined heists, won heists, and lifetime earned rewards. |
| Rewards/Redeem page | `/rewards` or `/redeem` | New `client/src/pages/Rewards/Rewards.jsx` | Show earned level coupons, manual promo code redeem form, claimed/redeemed status, and CopUp Jr balance. |
| Level history page | `/levels` | New `client/src/pages/Levels/Levels.jsx` | Show all 40 levels, locked/unlocked states, badge images, XP targets, and coupon reward per level. |
| XP activity page | `/xp-activity` | New `client/src/pages/LevelActivity/LevelActivity.jsx` | Show a ledger of daily check-in, heist play, heist win, referral, deposit, withdrawal, and admin adjustment XP events. |
| Heist result level-up state | `/heist/:id/result` | Update `client/src/pages/Heist/HeistResult.jsx` | Show XP earned from the completed heist and any level-up coupon reward. |
| Payment result XP state | `/payment-result` | Update `client/src/pages/PaymentResult/PaymentResult.jsx` | Show XP earned from completed deposit if the transaction qualifies. |
| Account reward shortcut | `/account` | Update `client/src/pages/Account/Account.jsx` | Add shortcut to rewards/redeem and show unclaimed reward count. |

Reusable user components:

- [x] `client/src/components/LevelProgressBar/LevelProgressBar.jsx`
- [x] `client/src/components/LevelProgressBar/LevelProgressBar.module.css`
- [x] `client/src/components/BadgeLevelCard/BadgeLevelCard.jsx`
- [x] `client/src/components/BadgeLevelCard/BadgeLevelCard.module.css`
- [x] `client/src/components/LevelRewardList/LevelRewardList.jsx`
- [x] `client/src/components/LevelRewardList/LevelRewardList.module.css`
- [x] `client/src/components/XpEventList/XpEventList.jsx`
- [x] `client/src/components/XpEventList/XpEventList.module.css`
- [x] `client/src/components/DailyCheckInPrompt/DailyCheckInPrompt.jsx`
- [x] `client/src/components/DailyCheckInPrompt/DailyCheckInPrompt.module.css`

User route entries to add in `client/src/App.jsx`:

- [x] `<Route path="/rewards" element={<Rewards />} />`
- [x] `<Route path="/redeem" element={<Rewards />} />`
- [x] `<Route path="/levels" element={<Levels />} />`
- [x] `<Route path="/xp-activity" element={<LevelActivity />} />`

Navigation updates:

- [x] Add Rewards/Redeem link to the user header/menu.
- [x] Add Levels link to the user header/menu.
- [x] Add a small unclaimed coupon badge/count inside the level progress widget if rewards are waiting.
- [x] Keep affiliate users able to see their level progress unless the product decides affiliate progress should be separate.

## Frontend Admin Checklist

- [x] Add admin navigation entry for Levels/Rewards.
- [x] Build badge management screen.
- [x] Build level XP configuration screen.
- [x] Build coupon reward configuration screen.
- [x] Build user progress lookup screen.
- [x] Build manual XP adjustment action with reason field.
- [x] Build earned coupon audit table.
- [x] Add image path field for badge icons.

## Frontend Admin Pages Needed

Add these admin pages so admins can configure the whole level system without database edits.

| Page | Route | Suggested File | Purpose |
| --- | --- | --- | --- |
| Level dashboard | `/admin/levels` | New `client/src/pages/admin/AdminLevels/AdminLevels.jsx` | Overview of total users in level system, XP issued, rewards earned, rewards claimed, and recent level-ups. |
| Badge manager | `/admin/levels/badges` | Same page with tab, or `AdminLevelBadges.jsx` | Create/edit the 8 badges, badge order, names, images, and active status. |
| Level rules manager | `/admin/levels/rules` | Same page with tab, or `AdminLevelRules.jsx` | Configure all 40 levels, XP required, badge mapping, roman numeral label, and level reward. |
| XP source rules | `/admin/levels/xp-rules` | Same page with tab, or `AdminXpRules.jsx` | Configure XP amounts for login, heist play, heist win, referral, deposit, and withdrawal. |
| Reward manager | `/admin/levels/rewards` | Same page with tab, or `AdminLevelRewards.jsx` | View generated coupon rewards, filter by status, expire/disable rewards, and inspect claim history. |
| User progress lookup | `/admin/levels/users` | Same page with tab, or `AdminUserLevels.jsx` | Search users, view badge/level/XP ledger, unclaimed coupons, and reward history. |
| Manual XP adjustment | Inside user progress lookup | Modal/component | Add or remove XP with admin reason, then write audit log. |
| Badge image upload | Inside badge manager | Modal/component | Upload or assign badge image paths with preview and fallback validation. |

Reusable admin components:

- [x] `client/src/pages/admin/AdminLevels/AdminLevels.jsx`
- [x] `client/src/pages/admin/AdminLevels/AdminLevels.module.css`
- [x] Badge editor built inside `AdminLevels.jsx`.
- [x] Level rule editor built inside `AdminLevels.jsx`.
- [x] XP rule editor built inside `AdminLevels.jsx`.
- [x] Reward audit table built inside `AdminLevels.jsx`.
- [x] User level lookup built inside `AdminLevels.jsx`.

Admin route entries to add in `client/src/App.jsx`:

- [x] `<Route path="/admin/levels" element={<AdminLevels />} />`
- [x] `<Route path="/admin/levels/badges" element={<AdminLevels />} />`
- [x] `<Route path="/admin/levels/rules" element={<AdminLevels />} />`
- [x] `<Route path="/admin/levels/xp-rules" element={<AdminLevels />} />`
- [x] `<Route path="/admin/levels/rewards" element={<AdminLevels />} />`
- [x] `<Route path="/admin/levels/users" element={<AdminLevels />} />`

Admin navigation updates:

- [x] Add Levels/Rewards item to `client/src/components/admin/Navbar.jsx`.
- [x] Show quick counters on the admin level dashboard:
  - [x] Users with XP.
  - [x] Total XP.
  - [x] Rewards earned.
  - [x] Rewards redeemed.
- [ ] Add filters for user, badge, level, reward status, XP source, and date range.

## Images And Assets Checklist

- [x] Create or collect 8 badge images.
- [x] Store badge images in `client/src/assets/levels`.
- [x] Use consistent dimensions for badges in frontend components.
- [x] Add fallback badge image if an image path is missing.
- [x] Confirm images render in production build assets.

## XP Rules To Confirm

These values should be finalized before implementation:

| Event | Suggested XP | Duplicate Rule |
| --- | ---: | --- |
| Daily check-in | 10 | Once per user per calendar day after the user clicks the check-in prompt |
| Play heist | 15 | Once per user per heist submission |
| Win heist | 100 | Once per user per won heist |
| Referral signup | 50 | Once per referred user |
| Deposit | 1 XP per fixed amount | Once per completed deposit transaction |
| Withdrawal | 1 XP per fixed amount | Once per completed withdrawal transaction |

Open product decisions:

- [ ] Exact XP per event.
- [ ] Exact XP needed for each of the 40 levels.
- [ ] Coupon value per level.
- [ ] Whether every level gives a coupon or only selected milestone levels.
- [ ] Whether coupons are auto-created unique codes or selected from an admin-created pool.
- [ ] Whether coupon rewards expire.
- [ ] Whether withdrawal XP should reward all withdrawals or only completed/approved withdrawals.

## Build Order

1. Add SQL migration for badges, levels, XP ledger, totals, and rewards.
2. Seed the 8 badges and 40 level definitions.
3. Build backend level progress service.
4. Add user progress and reward routes.
5. Add admin level and reward routes.
6. Wire XP events into login, heist, referral, deposit, and withdrawal flows.
7. Add frontend API helpers.
8. Add user progress bar, badge display, and reward list.
9. Add admin management screens.
10. Add badge images and fallback image handling.
11. Test XP duplicate protection, level-up rewards, coupon claiming, and admin adjustments.

## Verification Checklist Before Push

- [ ] Existing auth login still works.
- [ ] Existing heist join/play/submit flow still works.
- [ ] Existing heist promo code redeem flow still works.
- [ ] Existing deposit callback flow still works.
- [ ] Existing withdrawal flow still works.
- [ ] User progress API returns correct progress after each XP event.
- [ ] Duplicate XP events do not double-credit users.
- [ ] Level-up creates coupon rewards correctly.
- [ ] User cannot claim another user's reward.
- [ ] Admin can view and adjust progress.
- [ ] Frontend progress bar is accurate and responsive.
- [x] Production build passes.
