const express = require("express");
const { authenticateToken, optionalAuthenticateToken } = require("../middleware/auth");
const fs = require("fs");
const path = require("path");
const multer = require("multer");
const {
  createClan,
  deleteClanChatMessage,
  decideJoinRequest,
  getClanDetails,
  getMyClan,
  joinClan,
  leaveClan,
  listClans,
  listJoinRequests,
  listPublicClanQuests,
  listTopClans,
  listClanChat,
  participateQuest,
  removeMember,
  sendClanChat,
  updateClan,
  updateMemberRole,
} = require("../services/clan.service");

const router = express.Router();

const clanUploadsDir = path.join(__dirname, "..", "uploads", "clans");
fs.mkdirSync(clanUploadsDir, { recursive: true });

function safeSlug(value, fallback = "clan") {
  const slug = String(value || "")
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .slice(0, 80);
  return slug || fallback;
}

function imageExt(file) {
  const fromName = path.extname(file.originalname || "").toLowerCase();
  if ([".jpg", ".jpeg", ".png", ".webp", ".gif"].includes(fromName)) return fromName;
  switch (file.mimetype) {
    case "image/jpeg":
    case "image/jpg":
      return ".jpg";
    case "image/png":
      return ".png";
    case "image/webp":
      return ".webp";
    case "image/gif":
      return ".gif";
    default:
      return "";
  }
}

const clanUpload = multer({
  storage: multer.diskStorage({
    destination: (req, file, cb) => cb(null, clanUploadsDir),
    filename: (req, file, cb) => {
      const clanName = safeSlug(req.body?.clan_name || req.body?.name, "clan");
      const kind = file.fieldname === "banner" ? "banner" : "logo";
      const unique = `${Date.now()}-${Math.round(Math.random() * 1e9)}`;
      cb(null, `${clanName}-${kind}-${unique}${imageExt(file)}`);
    },
  }),
  fileFilter: (req, file, cb) => {
    if (["image/jpeg", "image/jpg", "image/png", "image/webp", "image/gif"].includes(file.mimetype)) {
      return cb(null, true);
    }
    return cb(new Error("Only image files are allowed"), false);
  },
  limits: { fileSize: Number(process.env.MAX_UPLOAD_MB || 60) * 1024 * 1024 },
});

function sendError(res, err, fallback = "Clan request failed") {
  const message = err?.message || fallback;
  const status = /not found/i.test(message) ? 404 : /access|required|only|not an active/i.test(message) ? 403 : 400;
  return res.status(status).json({ message });
}

router.get("/", optionalAuthenticateToken, async (req, res) => {
  try {
    const clans = await listClans({ q: req.query.q, status: "active" });
    return res.json({ clans });
  } catch (err) {
    console.error("clan list error:", err);
    return res.status(500).json({ message: "Error fetching clans" });
  }
});

router.get("/quests", authenticateToken, async (req, res) => {
  try {
    const data = await listPublicClanQuests(req.user.userId);
    return res.json(data);
  } catch (err) {
    console.error("clan quests error:", err);
    return res.status(500).json({ message: "Error fetching clan quests" });
  }
});

router.get("/top", optionalAuthenticateToken, async (req, res) => {
  try {
    const clans = await listTopClans(req.query.limit);
    return res.json({ clans });
  } catch (err) {
    console.error("top clans error:", err);
    return res.status(500).json({ message: "Error fetching top clans" });
  }
});

router.get("/me", authenticateToken, async (req, res) => {
  try {
    const data = await getMyClan(req.user.userId);
    return res.json(data);
  } catch (err) {
    console.error("my clan error:", err);
    return res.status(500).json({ message: "Error fetching your clan" });
  }
});

router.post(
  "/uploads",
  authenticateToken,
  clanUpload.fields([
    { name: "logo", maxCount: 1 },
    { name: "banner", maxCount: 1 },
  ]),
  async (req, res) => {
    try {
      const logo = req.files?.logo?.[0] ? `/uploads/clans/${req.files.logo[0].filename}` : null;
      const banner = req.files?.banner?.[0] ? `/uploads/clans/${req.files.banner[0].filename}` : null;
      return res.status(201).json({ logo_url: logo, banner_url: banner });
    } catch (err) {
      console.error("clan upload error:", err);
      return res.status(400).json({ message: err?.message || "Unable to upload clan image" });
    }
  }
);

router.post("/", authenticateToken, async (req, res) => {
  try {
    const data = await createClan(req.user.userId, req.body);
    return res.status(201).json({ message: "Clan created", ...data });
  } catch (err) {
    console.error("clan create error:", err);
    return sendError(res, err, "Error creating clan");
  }
});

router.get("/:clanId", optionalAuthenticateToken, async (req, res) => {
  try {
    const clanId = Number(req.params.clanId);
    if (!clanId) return res.status(400).json({ message: "Invalid clan id" });
    const data = await getClanDetails(clanId, req.user?.userId || null);
    if (!data) return res.status(404).json({ message: "Clan not found" });
    return res.json(data);
  } catch (err) {
    console.error("clan details error:", err);
    return res.status(500).json({ message: "Error fetching clan" });
  }
});

router.get("/:clanId/chat", authenticateToken, async (req, res) => {
  try {
    const clanId = Number(req.params.clanId);
    if (!clanId) return res.status(400).json({ message: "Invalid clan id" });
    const messages = await listClanChat(clanId, req.user.userId, { limit: req.query.limit });
    return res.json({ messages });
  } catch (err) {
    console.error("clan chat list error:", err);
    return sendError(res, err, "Error fetching clan chat");
  }
});

router.post("/:clanId/chat", authenticateToken, async (req, res) => {
  try {
    const clanId = Number(req.params.clanId);
    if (!clanId) return res.status(400).json({ message: "Invalid clan id" });
    const data = await sendClanChat(clanId, req.user.userId, req.body);
    return res.status(201).json(data);
  } catch (err) {
    console.error("clan chat send error:", err);
    return sendError(res, err, "Error sending clan chat");
  }
});

router.delete("/:clanId/chat/:messageId", authenticateToken, async (req, res) => {
  try {
    const clanId = Number(req.params.clanId);
    const messageId = Number(req.params.messageId);
    if (!clanId || !messageId) return res.status(400).json({ message: "Invalid message id" });
    const data = await deleteClanChatMessage(clanId, messageId, req.user.userId);
    return res.json(data);
  } catch (err) {
    console.error("clan chat delete error:", err);
    return sendError(res, err, "Error deleting clan chat message");
  }
});

router.patch("/:clanId", authenticateToken, async (req, res) => {
  try {
    const clanId = Number(req.params.clanId);
    if (!clanId) return res.status(400).json({ message: "Invalid clan id" });
    const data = await updateClan(clanId, req.user.userId, req.body, false);
    return res.json({ message: "Clan updated", ...data });
  } catch (err) {
    console.error("clan update error:", err);
    return sendError(res, err, "Error updating clan");
  }
});

router.post("/:clanId/join", authenticateToken, async (req, res) => {
  try {
    const clanId = Number(req.params.clanId);
    if (!clanId) return res.status(400).json({ message: "Invalid clan id" });
    const data = await joinClan(req.user.userId, clanId, req.body);
    return res.json(data);
  } catch (err) {
    console.error("clan join error:", err);
    return sendError(res, err, "Error joining clan");
  }
});

router.post("/:clanId/leave", authenticateToken, async (req, res) => {
  try {
    const clanId = Number(req.params.clanId);
    if (!clanId) return res.status(400).json({ message: "Invalid clan id" });
    const data = await leaveClan(req.user.userId, clanId);
    return res.json(data);
  } catch (err) {
    console.error("clan leave error:", err);
    return sendError(res, err, "Error leaving clan");
  }
});

router.get("/:clanId/requests", authenticateToken, async (req, res) => {
  try {
    const clanId = Number(req.params.clanId);
    if (!clanId) return res.status(400).json({ message: "Invalid clan id" });
    const requests = await listJoinRequests(clanId, req.user.userId);
    return res.json({ requests });
  } catch (err) {
    console.error("clan requests error:", err);
    return sendError(res, err, "Error fetching clan requests");
  }
});

router.post("/:clanId/requests/:requestId/:decision", authenticateToken, async (req, res) => {
  try {
    const clanId = Number(req.params.clanId);
    const requestId = Number(req.params.requestId);
    const decision = req.params.decision;
    if (!clanId || !requestId || !["approve", "reject"].includes(decision)) {
      return res.status(400).json({ message: "Invalid request" });
    }
    const data = await decideJoinRequest(clanId, requestId, req.user.userId, decision);
    return res.json(data);
  } catch (err) {
    console.error("clan request decision error:", err);
    return sendError(res, err, "Error updating join request");
  }
});

router.patch("/:clanId/members/:memberId", authenticateToken, async (req, res) => {
  try {
    const clanId = Number(req.params.clanId);
    const memberId = Number(req.params.memberId);
    if (!clanId || !memberId) return res.status(400).json({ message: "Invalid member id" });
    const data = await updateMemberRole(clanId, memberId, req.user.userId, req.body?.role);
    return res.json(data);
  } catch (err) {
    console.error("clan member role error:", err);
    return sendError(res, err, "Error updating member role");
  }
});

router.delete("/:clanId/members/:memberId", authenticateToken, async (req, res) => {
  try {
    const clanId = Number(req.params.clanId);
    const memberId = Number(req.params.memberId);
    if (!clanId || !memberId) return res.status(400).json({ message: "Invalid member id" });
    const data = await removeMember(clanId, memberId, req.user.userId);
    return res.json(data);
  } catch (err) {
    console.error("clan member remove error:", err);
    return sendError(res, err, "Error removing member");
  }
});

router.post("/:clanId/quests/:questId/join", authenticateToken, async (req, res) => {
  try {
    const clanId = Number(req.params.clanId);
    const questId = Number(req.params.questId);
    if (!clanId || !questId) return res.status(400).json({ message: "Invalid quest id" });
    const data = await participateQuest(clanId, questId, req.user.userId);
    return res.json(data);
  } catch (err) {
    console.error("clan quest participate error:", err);
    return sendError(res, err, "Error joining quest");
  }
});

module.exports = router;
