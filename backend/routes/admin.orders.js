const express = require("express");
const { pool } = require("../conf/db");
const { authenticateToken, authenticateAdmin } = require("../middleware/auth");
const router = express.Router();
router.use(authenticateToken, authenticateAdmin);

router.get("/", async (req, res) => {
  try {
    const [orders] = await pool.query(`SELECT o.*, u.username, u.email, COUNT(oi.id) AS item_count,
      GROUP_CONCAT(oi.product_name ORDER BY oi.id SEPARATOR ', ') AS product_names,
      GROUP_CONCAT(oi.heist_id ORDER BY oi.id SEPARATOR ',') AS heist_ids
      FROM orders o JOIN users u ON u.id = o.user_id LEFT JOIN order_items oi ON oi.order_id = o.id GROUP BY o.id ORDER BY o.created_at DESC`);
    return res.json({ orders });
  } catch (err) { console.error("admin orders error:", err); return res.status(500).json({ message: "Error fetching orders" }); }
});

router.patch("/:id/status", async (req, res) => {
  const statuses = ["pending", "processing", "shipped", "delivered"];
  const status = String(req.body.status || "");
  if (!statuses.includes(status)) return res.status(400).json({ message: "Invalid order status" });
  try {
    const [[order]] = await pool.query("SELECT status FROM orders WHERE id = ?", [Number(req.params.id)]);
    if (!order) return res.status(404).json({ message: "Order not found" });
    const transitions = { pending: ["pending", "processing"], processing: ["processing", "shipped"], shipped: ["shipped", "delivered"], delivered: ["delivered"] };
    if (!transitions[order.status]?.includes(status)) return res.status(409).json({ message: `Order cannot move from ${order.status} to ${status}` });
    const [result] = await pool.query("UPDATE orders SET status = ? WHERE id = ?", [status, Number(req.params.id)]);
    if (!result.affectedRows) return res.status(404).json({ message: "Order not found" });
    return res.json({ message: "Order status updated" });
  } catch (err) { return res.status(500).json({ message: "Error updating order" }); }
});
module.exports = router;
