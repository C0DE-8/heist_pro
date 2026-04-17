const jwt = require("jsonwebtoken");
const { pool } = require("../conf/db");

const authenticateToken = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization || "";
    const token = authHeader.startsWith("Bearer ") ? authHeader.slice(7) : null;

    if (!token) {
      return res.status(401).json({ message: "Missing Bearer token" });
    }

    const secret = process.env.JWT_SECRET;
    if (!secret) {
      return res.status(500).json({ message: "JWT secret missing" });
    }

    const payload = jwt.verify(token, secret);
    const userId = payload.userId || payload.id;
    if (!userId) return res.status(401).json({ message: "Invalid token" });

    const [rows] = await pool.query(
      "SELECT id, role, is_verified, is_blocked FROM users WHERE id = ? LIMIT 1",
      [userId]
    );
    const user = rows[0];
    if (!user) return res.status(401).json({ message: "User not found" });
    if (!user.is_verified) return res.status(403).json({ message: "Account not verified" });
    if (user.is_blocked) return res.status(403).json({ message: "Account is blocked" });

    req.user = {
      userId: user.id,
      // Kept for existing routes that already read req.user.id.
      id: user.id,
      role: user.role,
    };

    return next();
  } catch (error) {
    console.error("auth error:", error);
    if (error.name === "TokenExpiredError") {
      return res.status(401).json({ message: "Token expired" });
    }
    if (error.name === "JsonWebTokenError") {
      return res.status(401).json({ message: "Invalid token" });
    }
    return res.status(500).json({ message: "Auth error" });
  }
};

const authenticateAdmin = (req, res, next) => {
  if (req.user && req.user.role === "admin") return next();
  return res.status(403).json({ message: "Admin access required" });
};

const errorHandlingMiddleware = (err, req, res, next) => {
  console.error("error middleware:", err);

  if (err && err.name === "TokenExpiredError") {
    return res.status(401).json({ message: "Token expired" });
  }
  if (err && err.name === "JsonWebTokenError") {
    return res.status(401).json({ message: "Invalid token" });
  }

  return res.status(500).json({ message: "Internal server error" });
};

module.exports = {
  authenticateToken,
  authenticateAdmin,
  errorHandlingMiddleware,
};
