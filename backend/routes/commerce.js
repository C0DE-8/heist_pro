const crypto = require("crypto");
const express = require("express");
const { pool } = require("../conf/db");
const { authenticateToken } = require("../middleware/auth");

const router = express.Router();
router.use(authenticateToken);

const NIGERIA_STATES = new Set([
  "Abia", "Adamawa", "Akwa Ibom", "Anambra", "Bauchi", "Bayelsa", "Benue", "Borno", "Cross River", "Delta", "Ebonyi", "Edo", "Ekiti", "Enugu", "Federal Capital Territory (FCT)", "Gombe", "Imo", "Jigawa", "Kaduna", "Kano", "Katsina", "Kebbi", "Kogi", "Kwara", "Lagos", "Nasarawa", "Niger", "Ogun", "Ondo", "Osun", "Oyo", "Plateau", "Rivers", "Sokoto", "Taraba", "Yobe", "Zamfara",
]);

function validateAddress(input = {}) {
  const phone = String(input.phone_number || "").trim();
  const address = String(input.detailed_address || "").trim();
  const state = String(input.state || "").trim();
  const latitude = Number(input.latitude);
  const longitude = Number(input.longitude);
  const accuracy = input.location_accuracy === undefined || input.location_accuracy === null ? null : Number(input.location_accuracy);
  const capturedAt = new Date(input.location_captured_at || "");
  if (!/^[+0-9][0-9\s()-]{6,30}$/.test(phone)) return { error: "Enter a valid phone number" };
  if (address.length < 10 || address.length > 1000) return { error: "Enter a detailed delivery address" };
  if (!NIGERIA_STATES.has(state)) return { error: "Select a valid Nigerian state" };
  if (!Number.isFinite(latitude) || latitude < -90 || latitude > 90 || !Number.isFinite(longitude) || longitude < -180 || longitude > 180) return { error: "Capture a valid current location" };
  if (accuracy !== null && (!Number.isFinite(accuracy) || accuracy < 0)) return { error: "Invalid location accuracy" };
  if (Number.isNaN(capturedAt.getTime())) return { error: "Capture your current location" };
  return { value: { phone_number: phone, detailed_address: address, state, latitude, longitude, location_accuracy: accuracy, location_captured_at: capturedAt } };
}

async function getCart(userId) {
  const [items] = await pool.query(
    `SELECT ci.id, e.id AS entitlement_id, e.heist_id, e.product_id, e.status,
            p.name AS product_name, p.description AS product_description, h.name AS heist_name,
            (SELECT image_path FROM product_images WHERE product_id = p.id ORDER BY is_primary DESC, sort_order, id LIMIT 1) AS primary_image
     FROM carts c JOIN cart_items ci ON ci.cart_id = c.id
     JOIN product_win_entitlements e ON e.id = ci.entitlement_id
     JOIN products p ON p.id = e.product_id JOIN heist h ON h.id = e.heist_id
     WHERE c.user_id = ? AND c.status = 'active' ORDER BY ci.created_at DESC`,
    [userId]
  );
  return items;
}

router.get("/cart", async (req, res) => {
  try { return res.json({ items: await getCart(req.user.userId) }); }
  catch (err) { console.error("cart error:", err); return res.status(500).json({ message: "Error fetching cart" }); }
});

router.get("/product-wins", async (req, res) => {
  try {
    const [rewards] = await pool.query(
      `SELECT e.id AS entitlement_id, e.status, e.heist_id, h.name AS heist_name, p.id AS product_id,
              p.name AS product_name, p.description AS product_description,
              (SELECT image_path FROM product_images WHERE product_id = p.id ORDER BY is_primary DESC, sort_order, id LIMIT 1) AS primary_image
       FROM product_win_entitlements e JOIN heist h ON h.id = e.heist_id JOIN products p ON p.id = e.product_id
       WHERE e.user_id = ? AND e.status IN ('available','in_cart') ORDER BY e.created_at DESC`,
      [req.user.userId]
    );
    return res.json({ rewards });
  } catch (err) { return res.status(500).json({ message: "Error fetching product wins" }); }
});

router.post("/cart/items", async (req, res) => {
  const entitlementId = Number(req.body.entitlement_id);
  let conn;
  try {
    conn = await pool.getConnection(); await conn.beginTransaction();
    const [[entitlement]] = await conn.query("SELECT * FROM product_win_entitlements WHERE id = ? AND user_id = ? FOR UPDATE", [entitlementId, req.user.userId]);
    if (!entitlement) { await conn.rollback(); return res.status(404).json({ message: "Product reward not found" }); }
    if (entitlement.status === "ordered") { await conn.rollback(); return res.status(409).json({ message: "This reward has already been checked out" }); }
    if (entitlement.status === "cancelled") { await conn.rollback(); return res.status(409).json({ message: "This reward is unavailable" }); }
    let [[cart]] = await conn.query("SELECT id FROM carts WHERE user_id = ? AND status = 'active' ORDER BY id DESC LIMIT 1 FOR UPDATE", [req.user.userId]);
    if (!cart) { const [created] = await conn.query("INSERT INTO carts (user_id) VALUES (?)", [req.user.userId]); cart = { id: created.insertId }; }
    await conn.query("INSERT IGNORE INTO cart_items (cart_id, entitlement_id) VALUES (?, ?)", [cart.id, entitlementId]);
    await conn.query("UPDATE product_win_entitlements SET status = 'in_cart' WHERE id = ?", [entitlementId]);
    await conn.commit();
    return res.status(201).json({ message: "Product added to cart" });
  } catch (err) { if (conn) await conn.rollback(); console.error("cart add error:", err); return res.status(500).json({ message: "Error adding product to cart" }); }
  finally { conn?.release(); }
});

router.delete("/cart/items/:id", async (req, res) => {
  let conn;
  try {
    conn = await pool.getConnection(); await conn.beginTransaction();
    const [[item]] = await conn.query(`SELECT ci.id, ci.entitlement_id FROM cart_items ci JOIN carts c ON c.id = ci.cart_id WHERE ci.id = ? AND c.user_id = ? AND c.status = 'active' FOR UPDATE`, [Number(req.params.id), req.user.userId]);
    if (!item) { await conn.rollback(); return res.status(404).json({ message: "Cart item not found" }); }
    await conn.query("DELETE FROM cart_items WHERE id = ?", [item.id]);
    await conn.query("UPDATE product_win_entitlements SET status = 'available' WHERE id = ? AND status = 'in_cart'", [item.entitlement_id]);
    await conn.commit(); return res.json({ message: "Product removed from cart" });
  } catch (err) { if (conn) await conn.rollback(); return res.status(500).json({ message: "Error removing cart item" }); }
  finally { conn?.release(); }
});

router.get("/addresses", async (req, res) => {
  try { const [addresses] = await pool.query("SELECT * FROM user_delivery_addresses WHERE user_id = ? ORDER BY updated_at DESC", [req.user.userId]); return res.json({ addresses }); }
  catch (err) { return res.status(500).json({ message: "Error fetching addresses" }); }
});

router.post("/addresses", async (req, res) => {
  const parsed = validateAddress(req.body); if (parsed.error) return res.status(400).json({ message: parsed.error });
  const a = parsed.value;
  try {
    const [result] = await pool.query(`INSERT INTO user_delivery_addresses (user_id, phone_number, detailed_address, state, latitude, longitude, location_accuracy, location_captured_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)`, [req.user.userId, a.phone_number, a.detailed_address, a.state, a.latitude, a.longitude, a.location_accuracy, a.location_captured_at]);
    const [[address]] = await pool.query("SELECT * FROM user_delivery_addresses WHERE id = ?", [result.insertId]);
    return res.status(201).json({ message: "Address saved", address });
  } catch (err) { return res.status(500).json({ message: "Error saving address" }); }
});

router.delete("/addresses/:id", async (req, res) => {
  try { const [result] = await pool.query("DELETE FROM user_delivery_addresses WHERE id = ? AND user_id = ?", [Number(req.params.id), req.user.userId]); if (!result.affectedRows) return res.status(404).json({ message: "Address not found" }); return res.json({ message: "Address deleted" }); }
  catch (err) { return res.status(500).json({ message: "Error deleting address" }); }
});

router.post("/checkout", async (req, res) => {
  let conn;
  try {
    conn = await pool.getConnection(); await conn.beginTransaction();
    const [[user]] = await conn.query("SELECT id, full_name, username FROM users WHERE id = ? FOR UPDATE", [req.user.userId]);
    let address;
    if (req.body.address_id) {
      [[address]] = await conn.query("SELECT * FROM user_delivery_addresses WHERE id = ? AND user_id = ?", [Number(req.body.address_id), req.user.userId]);
      if (!address) { await conn.rollback(); return res.status(404).json({ message: "Saved address not found" }); }
    } else {
      const parsed = validateAddress(req.body.address); if (parsed.error) { await conn.rollback(); return res.status(400).json({ message: parsed.error }); }
      address = parsed.value;
      if (req.body.save_address) {
        const [saved] = await conn.query(`INSERT INTO user_delivery_addresses (user_id, phone_number, detailed_address, state, latitude, longitude, location_accuracy, location_captured_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)`, [req.user.userId, address.phone_number, address.detailed_address, address.state, address.latitude, address.longitude, address.location_accuracy, address.location_captured_at]);
        address.id = saved.insertId;
      }
    }
    const [[cart]] = await conn.query("SELECT id FROM carts WHERE user_id = ? AND status = 'active' ORDER BY id DESC LIMIT 1 FOR UPDATE", [req.user.userId]);
    if (!cart) { await conn.rollback(); return res.status(400).json({ message: "Your cart is empty" }); }
    const [items] = await conn.query(`SELECT ci.id cart_item_id, e.*, p.name product_name, p.description product_description, h.name heist_name FROM cart_items ci JOIN product_win_entitlements e ON e.id = ci.entitlement_id JOIN products p ON p.id = e.product_id JOIN heist h ON h.id = e.heist_id WHERE ci.cart_id = ? AND e.user_id = ? AND e.status = 'in_cart' FOR UPDATE`, [cart.id, req.user.userId]);
    if (!items.length) { await conn.rollback(); return res.status(400).json({ message: "Your cart has no eligible products" }); }
    const reference = `CPU-${Date.now().toString(36).toUpperCase()}-${crypto.randomBytes(3).toString("hex").toUpperCase()}`;
    const [orderResult] = await conn.query(`INSERT INTO orders (order_reference, user_id, recipient_name, phone_number, detailed_address, state, latitude, longitude, location_accuracy, location_captured_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`, [reference, req.user.userId, user.full_name || user.username, address.phone_number, address.detailed_address, address.state, address.latitude, address.longitude, address.location_accuracy, address.location_captured_at]);
    for (const item of items) {
      const [images] = await conn.query("SELECT image_path, is_primary, sort_order FROM product_images WHERE product_id = ? ORDER BY is_primary DESC, sort_order, id", [item.product_id]);
      await conn.query(`INSERT INTO order_items (order_id, entitlement_id, heist_id, product_id, product_name, product_description, primary_image_path, gallery_json) VALUES (?, ?, ?, ?, ?, ?, ?, ?)`, [orderResult.insertId, item.id, item.heist_id, item.product_id, item.product_name, item.product_description, images[0]?.image_path || null, JSON.stringify(images)]);
    }
    await conn.query("UPDATE product_win_entitlements SET status = 'ordered' WHERE id IN (?)", [items.map((item) => item.id)]);
    await conn.query("DELETE FROM cart_items WHERE cart_id = ?", [cart.id]);
    await conn.query("UPDATE carts SET status = 'checked_out' WHERE id = ?", [cart.id]);
    await conn.commit(); return res.status(201).json({ message: "Order placed", order: { id: orderResult.insertId, order_reference: reference, status: "pending" } });
  } catch (err) { if (conn) await conn.rollback(); console.error("checkout error:", err); return res.status(500).json({ message: "Error placing order" }); }
  finally { conn?.release(); }
});

router.get("/orders", async (req, res) => {
  try {
    const [orders] = await pool.query(`SELECT o.*, COUNT(oi.id) item_count FROM orders o LEFT JOIN order_items oi ON oi.order_id = o.id WHERE o.user_id = ? GROUP BY o.id ORDER BY o.created_at DESC`, [req.user.userId]);
    return res.json({ orders });
  } catch (err) { return res.status(500).json({ message: "Error fetching orders" }); }
});

router.get("/orders/:id", async (req, res) => {
  try {
    const [[order]] = await pool.query("SELECT * FROM orders WHERE id = ? AND user_id = ?", [Number(req.params.id), req.user.userId]);
    if (!order) return res.status(404).json({ message: "Order not found" });
    const [items] = await pool.query("SELECT * FROM order_items WHERE order_id = ?", [order.id]);
    return res.json({ order: { ...order, items } });
  } catch (err) { return res.status(500).json({ message: "Error fetching order" }); }
});

module.exports = router;
