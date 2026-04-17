const express = require("express");
const dotenv = require("dotenv");
const cors = require("cors");
const helmet = require("helmet");
const morgan = require("morgan");
const path = require("path");
const { ping } = require("./conf/db");
const authRoutes = require("./routes/auth");
const PaymentRoutes = require("./routes/payment");
const heistRoutes = require("./routes/heists");
const adminHeistRoutes = require("./routes/admin.heists");
const { startHeistCron } = require("./jobs/heistCron");

dotenv.config({ quiet: true });

const app = express();
app.use(helmet({
  contentSecurityPolicy: false,
  crossOriginEmbedderPolicy: false,     // avoids cross-origin isolation
  crossOriginResourcePolicy: { policy: "cross-origin" }
}));


app.use(cors());
app.use(express.json({ limit: "60mb" }));
app.use(express.urlencoded({ limit: "60mb", extended: true }));
app.use(morgan("dev"));

app.use("/uploads", express.static(path.join(__dirname, "uploads")));

app.get("/", (req, res) => res.json({ ok: true, name: "CopupBid backend running 🚀 GOD-DID-ITS-AGAIN" }));
app.get("/copupbid", (req, res) => res.json({ message: "CopupBid backend running 🚀" }));

app.use("/api/auth", authRoutes);
app.use("/api/payment", PaymentRoutes);
app.use("/api/heists", heistRoutes);
app.use("/api/admin/heists", adminHeistRoutes);


app.get("/health", async (req, res) => {
  try {
    await ping();
    res.json({ status: "ok" });
  } catch {
    res.status(500).json({ status: "db_error" });
  }
});


const PORT = Number(process.env.PORT || 2000);
const server = app.listen(PORT, () => {
  console.log(`API listening on http://localhost:${PORT}`);
  if (process.env.DISABLE_HEIST_CRON !== "1") {
    startHeistCron();
  }
});

server.on("error", (err) => {
  if (err.code === "EADDRINUSE") {
    console.error(`Port ${PORT} is already in use`);
  } else {
    console.error("Server error:", err.message);
  }
  process.exit(1);
});

module.exports = app;
