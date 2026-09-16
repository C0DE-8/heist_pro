-- Payouts now use the full configured coin value. Preserve completed history,
-- but bring requests still awaiting review up to the fee-free amount.
UPDATE payout_requests
SET amount_ngn = ROUND((cop_points / coin_rate_unit) * coin_rate_price, 2)
WHERE status = 'pending'
  AND coin_rate_unit > 0
  AND coin_rate_price > 0;
