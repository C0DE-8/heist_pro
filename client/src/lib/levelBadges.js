import beginnerImg from "../assets/levels/1_beginner.png";
import rookieImg from "../assets/levels/2_rookie.png";
import hustlerImg from "../assets/levels/3_Hustler.png";
import raiderImg from "../assets/levels/4_Raider.png";
import specialistImg from "../assets/levels/5_Specialist.png";
import eliteImg from "../assets/levels/6_Elite.png";
import mastermindImg from "../assets/levels/7_Mastermind.png";
import legendImg from "../assets/levels/8_Legend.png";

const BADGE_IMAGES = {
  beginner: beginnerImg,
  rookie: rookieImg,
  hustler: hustlerImg,
  raider: raiderImg,
  specialist: specialistImg,
  elite: eliteImg,
  mastermind: mastermindImg,
  legend: legendImg,
};

export function getBadgeImage(levelOrBadge) {
  const badgeName = String(
    levelOrBadge?.badge_name || levelOrBadge?.name || levelOrBadge || "beginner"
  ).toLowerCase();
  return BADGE_IMAGES[badgeName] || beginnerImg;
}

export function formatLevelName(level) {
  if (!level) return "Beginner I";
  const badge = level.badge_name || level.name || "Beginner";
  const roman = level.roman_label || "I";
  return `${badge} ${roman}`;
}

export function formatNumber(value) {
  const n = Number(value);
  return Number.isFinite(n) ? n.toLocaleString() : "0";
}

export function formatDate(value) {
  if (!value) return "Not available";
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "Not available";
  return date.toLocaleString([], {
    month: "short",
    day: "numeric",
    hour: "numeric",
    minute: "2-digit",
  });
}
