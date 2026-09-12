# Heist Product Rewards, Cart, and Checkout

## Goal

Extend the existing Heist system with reusable physical products, a winner-only cart, saved Nigerian delivery addresses, location capture, checkout, and order fulfillment while preserving the current CopUpCoin cash-reward flow.

This document is the implementation checklist. Application code and database schema must not be changed until this checklist is approved.

## Implementation Status

- [x] Checklist approved and implementation started.
- [x] Standalone additive migration created without modifying old migrations.
- [x] Cash/Product Heist reward modes implemented with existing cash behavior preserved.
- [x] Product Bank create, edit, multi-image, primary-image, reuse, archive/delete, and inline-Heist creation flows implemented.
- [x] Product rewards added to public Heist cards, play, referral, result, winner, gallery, and notification surfaces.
- [x] Winner-only entitlements, persistent cart, duplicate-claim protection, and claim fallback list implemented.
- [x] Checkout, profile full-name reuse, saved/new addresses, delete address, all Nigerian states/FCT, and browser geolocation implemented.
- [x] Immutable order delivery/product snapshots, user order history/details, and admin fulfillment workflow implemented.
- [x] Backend syntax checks, focused client lint, client production build, and whitespace checks pass.
- [ ] Apply and exercise the migration against a running database; the configured database was unreachable (`ECONNREFUSED`) during local verification.
- [ ] Commit/push only when explicitly requested by the user.

## Confirmed Existing Patterns

- [x] User full name is already available from the authenticated user profile and must not be requested again at checkout.
- [x] Heists currently award `prize_cop_points` to a real winner during `finalizeHeist`.
- [x] Heist cards currently use `/assets/m2-foods.png` as the default cash-Heist image.
- [x] Admin Heist creation and editing are handled inside the existing Admin Heists page and `/api/admin/heists` routes.
- [x] The backend already serves uploaded files from `/uploads` and uses Multer-based upload patterns.
- [x] The existing custom searchable select pattern is the accessible combobox/listbox used for Nigerian banks on the Account page and Admin Receipts page. The state selector will reuse or extract this existing pattern and its styling instead of introducing another select design.
- [x] New schema work belongs in a new SQL file under `backend/migrations`; old migration files will remain unchanged.

## Decisions and Data Rules

- [ ] Add `reward_type` to Heists with only `cash` and `product` values; existing rows default to `cash`.
- [ ] Cash Heists continue awarding `prize_cop_points` exactly as they do now.
- [ ] Product Heists reference one reusable Product Bank product and do not credit the cash prize when finalized.
- [ ] A real user who wins a Product Heist receives one unique product entitlement that can be added to the cart once.
- [ ] Demo winners do not receive a product entitlement or create a fulfillable order.
- [ ] A product can be reused by multiple Heists without duplicating its Product Bank record.
- [ ] Product edits must not silently change items already checked out; order items store a product/reward snapshot.
- [ ] Cart and checkout endpoints must derive ownership from the authenticated user, never from a submitted user ID.
- [ ] Checkout requires at least one eligible, unclaimed Product Heist win and creates the order atomically to prevent duplicate claims.
- [ ] Delivery location means browser/device GPS coordinates used alongside the typed address: latitude, longitude, accuracy, and capture time.
- [ ] Location access must be requested only after a clear user action and must show useful denied, unavailable, timeout, insecure-context, and unsupported-browser messages.
- [ ] Geolocation must not replace the detailed delivery address or selected state.
- [ ] The Nigeria state list contains all 36 states plus the Federal Capital Territory (FCT) in a shared client constant.
- [ ] Saved addresses belong only to their user and can be listed, selected, created, and deleted by that user.
- [ ] Deleting a saved address must not remove or alter the address snapshot on an existing order.
- [ ] Before deleting an address, use the project's existing confirmation interaction/pattern.
- [ ] Checkout shows the authenticated user's existing full name as read-only context; it does not add a full-name input.

## Database Migration

- [ ] Create one new migration such as `backend/migrations/20260912_heist_product_checkout.sql`.
- [ ] Do not modify any existing migration or the legacy database dump.
- [ ] Create a `products` table for Product Bank fields such as name, description, SKU/reference, status, created/updated admin, and timestamps.
- [ ] Create a `product_images` table linked to products with image path, primary flag, display order, and timestamps.
- [ ] Enforce one deterministic primary image per product in application validation/transactions and ensure all products used by Heists have a primary image.
- [ ] Alter `heist` to add `reward_type` and nullable `product_id`, with an index and foreign key to Product Bank.
- [ ] Preserve all existing Heists as `cash` during migration.
- [ ] Create a product-win/entitlement table linked uniquely to the Product Heist and winning user, with lifecycle fields such as `available`, `in_cart`, and `ordered`.
- [ ] Create a `user_delivery_addresses` table containing user ID, phone number, detailed address, Nigerian state, latitude, longitude, location accuracy, location capture time, and timestamps.
- [ ] Create `carts` and `cart_items` tables (or the repository-consistent equivalent) with one active cart per user and unique entitlement/cart-item protection.
- [ ] Create `orders` and `order_items` tables with an order reference, user, fulfillment status, delivery snapshot, product snapshot, Heist/entitlement references, and timestamps.
- [ ] Add foreign keys, ownership indexes, status indexes, uniqueness constraints, and safe delete behavior for products, images, addresses, cart items, orders, and order items.
- [ ] Ensure products already referenced by a Heist/order are archived or deactivated rather than hard-deleted in a way that breaks history.
- [ ] Verify the migration runs cleanly on a copy of the current schema and preserves existing Heist data.

## Backend: Product Bank and Uploads

- [ ] Add Product Bank service/repository logic following existing backend naming and MySQL transaction patterns.
- [ ] Add admin-authenticated APIs to list/search, view, create, update, archive/restore, and safely delete eligible products.
- [ ] Add product-image upload handling by extending the existing Multer/static `/uploads` conventions.
- [ ] Validate supported image MIME types, file sizes, file counts, and empty uploads on the server.
- [ ] Support multiple product images with one explicitly selected primary image and ordered gallery images.
- [ ] Support adding, removing, reordering, and changing the primary image during product editing.
- [ ] Prevent removal of the only primary image while a product is active or assigned to a Product Heist.
- [ ] Return normalized product data with `primary_image` and ordered `images` arrays for admin and user clients.
- [ ] Remove newly uploaded files when a database operation fails where safely possible; do not remove files still referenced by another record.

## Backend: Heist Reward Modes

- [ ] Extend admin create/update validation to accept `reward_type` and `product_id`.
- [ ] Require a valid active product for `product` mode and reject a product on `cash` mode.
- [ ] Keep `prize_cop_points` validation and behavior for `cash` mode; do not award it for `product` mode.
- [ ] Let admin create a Product Bank product inline through the same Product Bank service/API and select the returned product for the Heist.
- [ ] Extend admin Heist list/detail responses with reward type and product summary/gallery.
- [ ] Extend public available, detail, completed, result, leaderboard/winner, referral, and alert data with the appropriate reward summary.
- [ ] Update `finalizeHeist` inside its existing transaction so a real Product Heist winner gets exactly one product entitlement instead of CopUpCoin.
- [ ] Keep cash winner updates, XP awards, clan progress, result ranking, cron finalization, and manual admin finalization working.
- [ ] Update winner notifications: cash winners see CopUpCoin; product winners see the product name and a link to claim/add it to cart.
- [ ] Make repeated finalization idempotent for both cash credit and product entitlement creation.

## Backend: Saved Addresses

- [ ] Add authenticated endpoints to list, create, and delete the current user's saved addresses.
- [ ] Validate phone number length/format without assuming only one Nigerian carrier format.
- [ ] Validate detailed address length and require a state from the canonical Nigeria list.
- [ ] Validate latitude (`-90..90`), longitude (`-180..180`), non-negative accuracy, and valid capture timestamp.
- [ ] Do not accept or return another user's address through ID manipulation.
- [ ] Return a clear conflict/error if an address attached to an in-progress action cannot be deleted safely.

## Backend: Cart, Checkout, and Orders

- [ ] Add authenticated endpoints to retrieve the cart, add an eligible Product Heist win, and remove a cart item.
- [ ] Verify on every cart mutation that the authenticated user is the actual Heist winner and the entitlement is not already ordered.
- [ ] Prevent cash rewards, other users' wins, demo wins, duplicate products from the same entitlement, and invalid/archived reward records from being added.
- [ ] Add an authenticated checkout endpoint accepting either a saved address ID or new validated delivery details.
- [ ] Allow checkout to optionally save a newly entered address without duplicating order-address storage.
- [ ] Execute checkout in a database transaction with locked cart/entitlement rows.
- [ ] Create the order, copy immutable delivery and product snapshots, mark entitlements ordered, and clear checked-out cart items atomically.
- [ ] Return an order confirmation/reference and make retry behavior safe against double-order creation.
- [ ] Add authenticated endpoints for the user to list and view their own orders.
- [ ] Add admin-authenticated endpoints to list/view orders and update fulfillment status using explicit allowed transitions.
- [ ] Define initial fulfillment statuses (`pending`, `processing`, `shipped`, `delivered`, `cancelled`) and record timestamps/history needed by the UI.
- [ ] Decide and document cancellation/restoration behavior before enabling admin cancellation; a cancelled product entitlement must not disappear silently.

## Client: Shared Data and Components

- [ ] Add client API helpers following the current `client/src/lib` structure for products, cart, addresses, checkout, orders, and admin Product Bank actions.
- [ ] Add a shared Nigeria states constant with all 36 states and FCT.
- [ ] Extract/reuse the existing searchable Account-page combobox/listbox as the project's custom select for state selection while preserving its keyboard and accessibility behavior.
- [ ] Reuse existing Header, Footer, Modal, Toast, loading, error, button, card, and responsive styling patterns.
- [ ] Use `imgUrl` for uploaded product images and provide a safe fallback when an image cannot load.

## Client: Product Heist Experience

- [ ] Update available Heist cards so cash rewards retain the default image and CP prize display.
- [ ] For Product Heists, display the product primary image as the main Heist image and product name as the reward instead of the default cash image/CP prize.
- [ ] Update Heist detail/play, result, leaderboard, winners, referral-preview, alerts, and other existing reward surfaces to render the correct cash or product reward.
- [ ] Add a product gallery where product details are shown, with the primary image first and accessible thumbnails/navigation for other images.
- [ ] Show an “Add to cart” action only to the authenticated real winner of an available Product Heist entitlement.
- [ ] Change the action to an appropriate cart/order state when the item is already in the cart or checked out.
- [ ] Keep all cash-Heist wording, images, CopUpCoin amounts, and behavior unchanged.

## Client: Cart and Checkout

- [ ] Add a protected cart route/page and a discoverable cart action/badge in the existing user navigation/header pattern.
- [ ] Show each won product with its primary image, product name, originating Heist, and remove action.
- [ ] Handle empty, loading, stale-item, already-ordered, and API-error states.
- [ ] Add a protected checkout route/page available only when the cart has eligible items.
- [ ] Display the current authenticated user's full name without asking them to type it again.
- [ ] Let the user choose a saved address or enter phone number, detailed address, and state.
- [ ] Use the established custom searchable select for the Nigeria state field.
- [ ] Add a clear “Use current location” action that requests browser geolocation permission and displays capture success/accuracy or a useful error.
- [ ] Require usable captured coordinates together with the entered/saved delivery information before placing the order, per the requested location flow.
- [ ] Offer “Save this address” when entering a new address.
- [ ] Let users delete saved addresses from checkout/address management and immediately update the available list.
- [ ] Show a final review of products and delivery information before “Place order.”
- [ ] Disable duplicate submission while checkout is processing and safely handle retry/idempotency responses.
- [ ] Add an order-confirmation view and user order-history/detail view using existing page structure.

## Client: Admin Product Bank and Fulfillment

- [ ] Add a Product Bank section/route within the existing Admin Heists navigation structure rather than creating a separate visual system.
- [ ] Add product search/list, create, edit, image gallery, primary-image selection, archive/restore, and safe delete controls.
- [ ] Extend Create/Edit Heist with the `cash`/`product` reward mode.
- [ ] Show Prize CP only for cash mode.
- [ ] For product mode, show a searchable Product Bank selector and product preview.
- [ ] Add an inline “Add new product” flow that saves to Product Bank, refreshes the list, and selects the new product without losing the Heist form.
- [ ] Show reward type/product information in active, completed, archived, and detail admin Heist views.
- [ ] Add an admin orders/fulfillment view using existing admin page/header/navigation patterns.
- [ ] Let admin inspect delivery details, GPS coordinates/map link, product snapshots, originating Heist, winner, and update fulfillment status.

## Security, Privacy, and Reliability

- [ ] Treat GPS coordinates, phone numbers, and addresses as private authenticated data and never expose them in public winner/Heist endpoints.
- [ ] Keep admin product/order endpoints behind both token and admin middleware.
- [ ] Use parameterized SQL, server-side enums/allowlists, input length limits, and ownership checks throughout.
- [ ] Do not trust client-provided product, winner, full-name, reward-mode, or order-status data when authoritative values exist in the database.
- [ ] Confirm browser geolocation is available only on HTTPS or localhost and show a suitable production configuration message if unavailable.
- [ ] Avoid logging complete addresses, phone numbers, coordinates, auth data, or uploaded file contents.
- [ ] Preserve historical order data even if a product, image, saved address, user display name, or Heist changes later.
- [ ] Confirm concurrent checkout/finalization calls cannot duplicate CopUpCoin credits, entitlements, or orders.

## Verification and Acceptance

- [ ] Migration applies successfully to the current database and existing Heists remain cash Heists.
- [ ] Existing cash Heist creation, joining, playing, finalization, winner notification, CopUpCoin award, results, and winners pages pass regression checks.
- [ ] Admin can create a multi-image product, choose/change its primary image, and reuse it across Product Heists.
- [ ] Admin can create a new product inline while creating a Product Heist.
- [ ] Product Heist surfaces consistently show the product primary image and name instead of the cash default image and CP prize.
- [ ] A real Product Heist winner can add the product once; non-winners and demo winners cannot.
- [ ] Cart persists through refresh/login and rejects duplicate or ineligible additions.
- [ ] Checkout never requests full name and correctly uses the authenticated profile name.
- [ ] Checkout accepts phone, detailed address, all Nigerian states/FCT through the existing custom select, and permitted current location.
- [ ] Location denial/unavailability does not crash the page and gives a clear recovery path.
- [ ] User can save, reuse, and delete an address without affecting completed orders.
- [ ] Checkout creates only one order per entitlement, clears purchased cart items, and shows confirmation/history.
- [ ] Admin can view the order and update its fulfillment status.
- [ ] Product and address ownership/tampering tests return safe authorization or validation errors.
- [ ] Responsive behavior is checked on desktop and mobile layouts.
- [ ] Focused backend route/service checks pass.
- [ ] Focused client lint passes for every changed file.
- [ ] Client production build passes (noting the repository currently warns that Node `20.19+` or `22.12+` is preferred by Vite).
- [ ] Review `git diff --check` and ensure unrelated user changes remain untouched.
- [ ] Update this document's boxes as implementation work is completed.

## Explicitly Deferred Until Requested

- [ ] Do not implement product payments, shipping-fee calculation, courier integration, live reverse geocoding, or map-provider integration unless separately approved.
- [ ] Do not commit or push changes until the user explicitly requests it.
