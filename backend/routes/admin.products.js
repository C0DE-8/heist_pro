const express = require("express");
const fs = require("fs");
const path = require("path");
const { pool } = require("../conf/db");
const { authenticateToken, authenticateAdmin } = require("../middleware/auth");
const { upload, uploadsDir } = require("../middleware/upload");

const router = express.Router();
router.use(authenticateToken, authenticateAdmin);

function productUpload(req, res, next) {
  upload.array("images", 12)(req, res, (err) => {
    if (err) return res.status(400).json({ message: err.message || "Product image upload failed" });
    next();
  });
}

async function getProduct(db, id) {
  const [[product]] = await db.query("SELECT * FROM products WHERE id = ? LIMIT 1", [id]);
  if (!product) return null;
  const [images] = await db.query(
    "SELECT id, image_path, is_primary, sort_order FROM product_images WHERE product_id = ? ORDER BY is_primary DESC, sort_order ASC, id ASC",
    [id]
  );
  return { ...product, primary_image: images.find((image) => Number(image.is_primary))?.image_path || images[0]?.image_path || null, images };
}

router.get("/", async (req, res) => {
  try {
    const search = String(req.query.search || "").trim();
    const params = [];
    const where = search ? "WHERE p.name LIKE ? OR p.sku LIKE ?" : "";
    if (search) params.push(`%${search}%`, `%${search}%`);
    const [rows] = await pool.query(
      `SELECT p.*, (SELECT pi.image_path FROM product_images pi WHERE pi.product_id = p.id ORDER BY pi.is_primary DESC, pi.sort_order ASC, pi.id ASC LIMIT 1) AS primary_image,
              (SELECT COUNT(*) FROM heist h WHERE h.product_id = p.id) AS heist_count
       FROM products p ${where} ORDER BY p.is_active DESC, p.updated_at DESC`,
      params
    );
    return res.json({ products: rows });
  } catch (err) {
    console.error("admin products list error:", err);
    return res.status(500).json({ message: "Error fetching products" });
  }
});

router.get("/:id", async (req, res) => {
  try {
    const product = await getProduct(pool, Number(req.params.id));
    if (!product) return res.status(404).json({ message: "Product not found" });
    return res.json({ product });
  } catch (err) {
    return res.status(500).json({ message: "Error fetching product" });
  }
});

router.post("/", productUpload, async (req, res) => {
  const name = String(req.body.name || "").trim();
  if (!name) return res.status(400).json({ message: "Product name is required" });
  if (!req.files?.length) return res.status(400).json({ message: "At least one product image is required" });
  let conn;
  try {
    conn = await pool.getConnection();
    await conn.beginTransaction();
    const [result] = await conn.query(
      "INSERT INTO products (name, description, sku, is_active, created_by, updated_by) VALUES (?, ?, ?, ?, ?, ?)",
      [name.slice(0, 180), String(req.body.description || "").trim() || null, String(req.body.sku || "").trim() || null, req.body.is_active === "0" ? 0 : 1, req.user.userId, req.user.userId]
    );
    const primaryIndex = Math.max(0, Math.min(Number(req.body.primary_index || 0), req.files.length - 1));
    const values = req.files.map((file, index) => [result.insertId, `/uploads/${file.filename}`, index === primaryIndex ? 1 : 0, index]);
    await conn.query("INSERT INTO product_images (product_id, image_path, is_primary, sort_order) VALUES ?", [values]);
    await conn.commit();
    return res.status(201).json({ message: "Product saved", product: await getProduct(pool, result.insertId) });
  } catch (err) {
    if (conn) await conn.rollback();
    req.files?.forEach((file) => fs.unlink(file.path, () => {}));
    if (err?.code === "ER_DUP_ENTRY") return res.status(409).json({ message: "That SKU already exists" });
    console.error("admin product create error:", err);
    return res.status(500).json({ message: "Error saving product" });
  } finally {
    conn?.release();
  }
});

router.patch("/:id", productUpload, async (req, res) => {
  const productId = Number(req.params.id);
  let conn;
  try {
    conn = await pool.getConnection();
    await conn.beginTransaction();
    const [[existing]] = await conn.query("SELECT * FROM products WHERE id = ? FOR UPDATE", [productId]);
    if (!existing) { await conn.rollback(); return res.status(404).json({ message: "Product not found" }); }
    const name = req.body.name === undefined ? existing.name : String(req.body.name).trim();
    if (!name) { await conn.rollback(); return res.status(400).json({ message: "Product name is required" }); }
    await conn.query(
      "UPDATE products SET name = ?, description = ?, sku = ?, is_active = ?, updated_by = ? WHERE id = ?",
      [name.slice(0, 180), req.body.description === undefined ? existing.description : String(req.body.description).trim() || null, req.body.sku === undefined ? existing.sku : String(req.body.sku).trim() || null, req.body.is_active === undefined ? existing.is_active : Number(req.body.is_active) ? 1 : 0, req.user.userId, productId]
    );
    const removeIds = String(req.body.remove_image_ids || "").split(",").map(Number).filter(Boolean);
    if (removeIds.length) await conn.query(`DELETE FROM product_images WHERE product_id = ? AND id IN (${removeIds.map(() => "?").join(",")})`, [productId, ...removeIds]);
    if (req.files?.length) {
      const [[maxRow]] = await conn.query("SELECT COALESCE(MAX(sort_order), -1) AS max_order FROM product_images WHERE product_id = ?", [productId]);
      const values = req.files.map((file, index) => [productId, `/uploads/${file.filename}`, 0, Number(maxRow.max_order) + index + 1]);
      await conn.query("INSERT INTO product_images (product_id, image_path, is_primary, sort_order) VALUES ?", [values]);
      const newPrimaryIndex = Number(req.body.new_primary_index);
      if (Number.isInteger(newPrimaryIndex) && newPrimaryIndex >= 0 && newPrimaryIndex < req.files.length) {
        const primaryPath = `/uploads/${req.files[newPrimaryIndex].filename}`;
        await conn.query("UPDATE product_images SET is_primary = (image_path = ?) WHERE product_id = ?", [primaryPath, productId]);
      }
    }
    const primaryId = Number(req.body.primary_image_id || 0);
    if (primaryId) {
      const [[image]] = await conn.query("SELECT id FROM product_images WHERE id = ? AND product_id = ?", [primaryId, productId]);
      if (image) await conn.query("UPDATE product_images SET is_primary = (id = ?) WHERE product_id = ?", [primaryId, productId]);
    }
    const [[count]] = await conn.query("SELECT COUNT(*) total, SUM(is_primary) primary_count FROM product_images WHERE product_id = ?", [productId]);
    if (!Number(count.total)) { await conn.rollback(); return res.status(400).json({ message: "A product must have at least one image" }); }
    if (!Number(count.primary_count)) await conn.query("UPDATE product_images SET is_primary = 1 WHERE product_id = ? ORDER BY sort_order, id LIMIT 1", [productId]);
    await conn.commit();
    return res.json({ message: "Product updated", product: await getProduct(pool, productId) });
  } catch (err) {
    if (conn) await conn.rollback();
    req.files?.forEach((file) => fs.unlink(file.path, () => {}));
    if (err?.code === "ER_DUP_ENTRY") return res.status(409).json({ message: "That SKU already exists" });
    console.error("admin product update error:", err);
    return res.status(500).json({ message: "Error updating product" });
  } finally { conn?.release(); }
});

router.delete("/:id", async (req, res) => {
  try {
    const productId = Number(req.params.id);
    const [[usage]] = await pool.query("SELECT COUNT(*) total FROM heist WHERE product_id = ?", [productId]);
    if (Number(usage.total)) {
      await pool.query("UPDATE products SET is_active = 0, updated_by = ? WHERE id = ?", [req.user.userId, productId]);
      return res.json({ message: "Product is used by a Heist and was archived" });
    }
    const product = await getProduct(pool, productId);
    if (!product) return res.status(404).json({ message: "Product not found" });
    await pool.query("DELETE FROM products WHERE id = ?", [productId]);
    product.images.forEach((image) => {
      const filename = path.basename(image.image_path);
      fs.unlink(path.join(uploadsDir, filename), () => {});
    });
    return res.json({ message: "Product deleted" });
  } catch (err) {
    console.error("admin product delete error:", err);
    return res.status(500).json({ message: "Error deleting product" });
  }
});

module.exports = router;
