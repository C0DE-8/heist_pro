// backend/services/telegram.js
const axios = require("axios");

function getAdminChatIds() {
  return (process.env.TELEGRAM_ADMIN_CHAT_IDS || "")
    .split(",")
    .map((id) => id.trim())
    .filter(Boolean);
}

async function telegramPost(method, payload) {
  const token = process.env.TELEGRAM_BOT_TOKEN;
  if (!token) {
    console.warn("Telegram bot token is not configured");
    return null;
  }

  const url = `https://api.telegram.org/bot${token}/${method}`;
  const { data } = await axios.post(url, payload);
  return data;
}

async function notifyAdmins(message, options = {}) {
  try {
    const ids = getAdminChatIds();

    if (!process.env.TELEGRAM_BOT_TOKEN || !ids.length) {
      console.warn("Telegram not configured properly");
      return;
    }

    await Promise.all(
      ids.map(chatId =>
        telegramPost("sendMessage", {
            chat_id: chatId,
            text: message,
            parse_mode: "HTML",
            ...options,
          })
          .catch(err => {
            console.error(
              "Telegram send error:",
              err.response?.data || err.message
            );
          })
      )
    );
  } catch (e) {
    console.error("notifyAdmins error:", e.message);
  }
}

module.exports = { getAdminChatIds, notifyAdmins, telegramPost };
