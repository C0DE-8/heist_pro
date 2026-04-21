const dotenv = require("dotenv");
const { notifyAdmins } = require("../services/telegram");

dotenv.config({ quiet: true });

async function main() {
  const token = process.env.TELEGRAM_BOT_TOKEN;
  const chatIds = (process.env.TELEGRAM_ADMIN_CHAT_IDS || "")
    .split(",")
    .map((id) => id.trim())
    .filter(Boolean);

  if (!token || !chatIds.length) {
    console.error("Telegram is not configured. Check TELEGRAM_BOT_TOKEN and TELEGRAM_ADMIN_CHAT_IDS.");
    process.exitCode = 1;
    return;
  }

  const now = new Date().toLocaleString();
  await notifyAdmins(
    `<b>CopUpBid Telegram Test</b>\n\n` +
      `<b>Status:</b> Bot notification test sent\n` +
      `<b>Admin Chats:</b> ${chatIds.length}\n` +
      `<b>Time:</b> ${now}`
  );

  console.log(`Telegram test sent to ${chatIds.length} admin chat(s).`);
}

main().catch((err) => {
  console.error("Telegram test failed:", err.message);
  process.exitCode = 1;
});
