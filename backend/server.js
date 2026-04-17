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

dotenv.config();

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


const PORT = Number(process.env.PORT || 4000);
app.listen(PORT, () => console.log(`API listening on http://localhost:${PORT}`));
