import React, { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { useNavigate } from "react-router-dom";
import { FiMessageCircle, FiRefreshCw, FiSend, FiShield, FiTrash2, FiUsers } from "react-icons/fi";
import Header from "../../components/Header/Header";
import Footer from "../../components/Footer/Footer";
import { useToast } from "../../components/Toast/ToastContext";
import Modal from "../../components/ui/Modal";
import { imgUrl } from "../../lib/api";
import { deleteClanChatMessage, getClanChat, getMyClan, sendClanChat } from "../../lib/clans";
import styles from "./MyClan.module.css";
import m1Img from "../../assets/m1.png";
import m2Img from "../../assets/m2.png";
import m3Img from "../../assets/m3.png";
import m4Img from "../../assets/m4.png";

const fallbackAvatars = [m1Img, m2Img, m3Img, m4Img];

function formatDate(value) {
  if (!value) return "";
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "";
  return date.toLocaleString([], { month: "short", day: "numeric", hour: "numeric", minute: "2-digit" });
}

function formatNum(value) {
  const n = Number(value);
  return Number.isFinite(n) ? n.toLocaleString() : "0";
}

function initial(value) {
  return String(value || "C").trim().slice(0, 1).toUpperCase();
}

function avatarSrc(userId, profileUrl) {
  if (profileUrl) return imgUrl(profileUrl);
  const index = Math.abs(Number(userId || 0)) % fallbackAvatars.length;
  return fallbackAvatars[index];
}

function Skeleton() {
  return (
    <div className={styles.skeleton}>
      <span />
      <span />
      <span />
    </div>
  );
}

function ChatSkeleton() {
  return (
    <div className={styles.chatSkeletonWrap}>
      {[0, 1, 2, 3].map((item) => (
        <div className={`${styles.chatSkeleton} ${item % 2 ? styles.chatSkeletonMine : ""}`} key={item}>
          <span />
          <span />
        </div>
      ))}
    </div>
  );
}

export default function MyClan() {
  const navigate = useNavigate();
  const toast = useToast();
  const chatEndRef = useRef(null);
  const [data, setData] = useState(null);
  const [messages, setMessages] = useState([]);
  const [message, setMessage] = useState("");
  const [loading, setLoading] = useState(true);
  const [chatLoading, setChatLoading] = useState(false);
  const [chatOpen, setChatOpen] = useState(false);
  const [sending, setSending] = useState(false);
  const [deletingId, setDeletingId] = useState(null);
  const [selectedMessageId, setSelectedMessageId] = useState(null);
  const [error, setError] = useState("");

  const clan = data?.clan || null;
  const members = useMemo(() => (Array.isArray(data?.members) ? data.members : []), [data?.members]);
  const myMembership = data?.my_membership || null;
  const myUserId = Number(myMembership?.user_id || 0);
  const canModerateChat = ["leader", "co_leader"].includes(myMembership?.role);

  const loadChat = useCallback(async (clanId) => {
    if (!clanId) {
      setMessages([]);
      return;
    }
    setChatLoading(true);
    try {
      const result = await getClanChat(clanId);
      setMessages(Array.isArray(result?.messages) ? result.messages : []);
    } catch (err) {
      console.warn("Clan chat load error:", err);
      setMessages([]);
    } finally {
      setChatLoading(false);
    }
  }, []);

  const loadPage = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      const result = await getMyClan();
      setData(result);
      await loadChat(result?.clan?.id);
    } catch (err) {
      console.error("My clan load error:", err);
      setError(err?.response?.data?.message || "Unable to load your clan.");
    } finally {
      setLoading(false);
    }
  }, [loadChat]);

  useEffect(() => {
    loadPage();
  }, [loadPage]);

  useEffect(() => {
    chatEndRef.current?.scrollIntoView({ behavior: "smooth", block: "end" });
  }, [messages]);

  const submitMessage = async (event) => {
    event.preventDefault();
    const text = message.trim();
    if (!text || !clan?.id) return;
    setSending(true);
    try {
      const result = await sendClanChat(clan.id, text);
      setMessages(Array.isArray(result?.messages) ? result.messages : []);
      setMessage("");
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to send message.");
    } finally {
      setSending(false);
    }
  };

  const openChat = async () => {
    setChatOpen(true);
    setSelectedMessageId(null);
    await loadChat(clan?.id);
  };

  const deleteMessage = async (messageId) => {
    if (!clan?.id || !messageId) return;
    setDeletingId(messageId);
    try {
      const result = await deleteClanChatMessage(clan.id, messageId);
      setMessages(Array.isArray(result?.messages) ? result.messages : []);
      setSelectedMessageId(null);
      toast.success("Message deleted.");
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to delete message.");
    } finally {
      setDeletingId(null);
    }
  };

  return (
    <div className={styles.page}>
      <Header />
      <main className={styles.main}>
        {loading ? (
          <Skeleton />
        ) : error ? (
          <section className={styles.panel}>
            <h1>My Clan</h1>
            <p>{error}</p>
            <button type="button" className={styles.primaryBtn} onClick={loadPage}>Try again</button>
          </section>
        ) : !clan ? (
          <section className={styles.hero}>
            <div>
              <p className={styles.kicker}>My Clan</p>
              <h1>You are not in a clan yet.</h1>
              <p>Join a clan or create one to unlock the clan chat and quest teamwork.</p>
            </div>
            <button type="button" className={styles.primaryBtn} onClick={() => navigate("/clans")}>
              Find clans
            </button>
          </section>
        ) : (
          <>
            <section className={styles.hero}>
              <div className={styles.banner}>
                {clan.banner_url ? <img src={imgUrl(clan.banner_url)} alt="" /> : null}
              </div>
              <div className={styles.heroContent}>
                <div className={styles.logo}>
                  {clan.logo_url ? <img src={imgUrl(clan.logo_url)} alt="" /> : initial(clan.name)}
                </div>
                <div>
                  <p className={styles.kicker}>My Clan</p>
                  <h1>{clan.name}</h1>
                  <p>{clan.description || "No clan description yet."}</p>
                  <div className={styles.pills}>
                    <span><FiUsers /> {formatNum(clan.member_count)} members</span>
                    <span><FiShield /> Your role: {myMembership?.role || "member"}</span>
                    <button type="button" className={styles.chatOpenPill} onClick={openChat}>
                      <FiMessageCircle /> Open clan chat
                    </button>
                  </div>
                </div>
                <button type="button" className={styles.iconBtn} onClick={loadPage} aria-label="Refresh my clan" title="Refresh my clan">
                  <FiRefreshCw />
                </button>
              </div>
            </section>

            <section className={styles.grid}>
              <article className={styles.panel}>
                <div className={styles.panelHead}>
                  <h2>Members</h2>
                  <span>{formatNum(members.filter((item) => item.status === "active").length)} active</span>
                </div>
                <div className={styles.memberList}>
                  {members.filter((item) => item.status === "active").map((member) => (
                    <div className={styles.memberRow} key={member.id}>
                      <div className={styles.memberAvatar}>{initial(member.display_name)}</div>
                      <div>
                        <strong>{member.display_name}</strong>
                        <span>{member.role} · joined {formatDate(member.joined_at)}</span>
                      </div>
                    </div>
                  ))}
                </div>
              </article>

              <article className={styles.panel}>
                <div className={styles.panelHead}>
                  <h2>Clan Chat</h2>
                  <span>{formatNum(messages.length)} messages</span>
                </div>
                <div className={styles.chatPreview}>
                  <FiMessageCircle />
                  <strong>Chat with your clan members</strong>
                  <span>Your messages show on your side. Other members show opposite with their role badge.</span>
                  <button type="button" className={styles.primaryBtn} onClick={openChat}>Open chat</button>
                </div>
              </article>
            </section>

            <Modal
              open={chatOpen}
              title={`${clan.name} Chat`}
              subtitle="Clan-only messages. Cuss words are masked as ***."
              size="lg"
              onClose={() => setChatOpen(false)}
              footer={(
                <form className={styles.chatForm} onSubmit={submitMessage}>
                  <input
                    value={message}
                    onChange={(event) => setMessage(event.target.value)}
                    placeholder="Message your clan"
                    maxLength={1000}
                  />
                  <button type="submit" className={styles.sendBtn} disabled={sending || !message.trim()} aria-label="Send clan message" title="Send clan message">
                    <FiSend />
                  </button>
                </form>
              )}
            >
              <div className={styles.chatModalTop}>
                <button type="button" className={styles.iconBtn} onClick={() => loadChat(clan.id)} aria-label="Refresh clan chat" title="Refresh clan chat">
                  <FiRefreshCw />
                </button>
              </div>
              <div className={styles.chatBox}>
                {chatLoading ? (
                  <ChatSkeleton />
                ) : messages.length ? (
                  messages.map((item) => {
                    const isMine = Number(item.user_id) === myUserId;
                    const canDelete = isMine || canModerateChat;
                    const showActions = selectedMessageId === item.id;
                    return (
                      <div
                        className={`${styles.chatMessage} ${isMine ? styles.chatMine : styles.chatOther} ${showActions ? styles.chatSelected : ""}`}
                        key={item.id}
                        onClick={() => setSelectedMessageId((current) => (current === item.id ? null : item.id))}
                        role="button"
                        tabIndex={0}
                        onKeyDown={(event) => {
                          if (event.key === "Enter" || event.key === " ") {
                            event.preventDefault();
                            setSelectedMessageId((current) => (current === item.id ? null : item.id));
                          }
                        }}
                      >
                        {!isMine ? (
                          <img
                            className={styles.chatAvatar}
                            src={avatarSrc(item.user_id, item.profile_url)}
                            alt=""
                          />
                        ) : null}
                        <div className={styles.chatBubble}>
                          <div className={styles.chatTop}>
                            <span className={styles.chatName}>{isMine ? "You" : item.display_name}</span>
                            <span className={styles.roleBadge}>{item.role || "member"}</span>
                            <span className={styles.chatTime}>{formatDate(item.created_at)}</span>
                            {canDelete && showActions ? (
                              <button
                                type="button"
                                className={styles.deleteMsgBtn}
                                onClick={(event) => {
                                  event.stopPropagation();
                                  deleteMessage(item.id);
                                }}
                                disabled={deletingId === item.id}
                                aria-label="Delete message"
                                title="Delete message"
                              >
                                <FiTrash2 />
                              </button>
                            ) : null}
                          </div>
                          <p>{item.message}</p>
                        </div>
                        {isMine ? (
                          <img
                            className={styles.chatAvatar}
                            src={avatarSrc(item.user_id, item.profile_url)}
                            alt=""
                          />
                        ) : null}
                      </div>
                    );
                  })
                ) : (
                  <div className={styles.empty}>No messages yet. Start the clan chat.</div>
                )}
                <div ref={chatEndRef} />
              </div>
            </Modal>
          </>
        )}
      </main>
      <Footer />
    </div>
  );
}
