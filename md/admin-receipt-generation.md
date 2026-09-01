# Admin Receipt Generation

## Goal

Add an admin-only page for creating marketing payout receipt previews. The page lets an admin enter beneficiary bank details, verifies the account name through the existing Flutterwave account resolve flow, then renders a receipt UI based on the backup references in `backup/ui/`.

## Reference UI

- `backup/ui/photo_2026-09-01 06.48.49.jpeg`: dark transfer-success screen with amount, beneficiary, bank, date, and progress states.
- `backup/ui/photo_2026-09-01 06.48.52.jpeg`: Moniepoint-style debit receipt with business/sender, beneficiary, institution, narration, session ID, and transaction reference.

## Scope

- Add a protected admin route at `/admin/receipts`.
- Add an admin navigation item for receipts.
- Reuse the existing Flutterwave client helpers:
  - `getFlutterwaveBanks()`
  - `resolveFlutterwaveAccount({ account_bank, account_number })`
- Require the admin to select a bank and verify a 10-digit account number before the beneficiary name is used.
- Let admin edit marketing receipt fields:
  - amount
  - business/sender name
  - narration
  - transaction date/time
  - session ID
  - transaction reference
  - visual template
- Provide copy/print actions for the generated receipt.

## Non-Goals

- This page must not move real money.
- This page must not approve or reject withdrawal requests.
- This page must not write transaction, payout, or wallet records unless a later backend audit/history feature is requested.

## Acceptance Checklist

- [x] Admin can open `/admin/receipts`.
- [x] Admin can load/search Nigerian banks from Flutterwave.
- [x] Admin can verify account number and auto-fill the real account name.
- [x] Receipt preview clearly shows the verified beneficiary name, selected bank, amount, date, narration, session ID, and transaction reference.
- [x] Admin can switch between the success-screen and debit-receipt visual styles.
- [x] Build passes for the React client.
