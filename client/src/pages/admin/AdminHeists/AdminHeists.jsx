import React, { useCallback, useEffect, useMemo, useState } from "react";
import {
  FaPlus,
  FaRedoAlt,
  FaSave,
  FaTrash,
  FaTrophy,
  FaUsers,
} from "react-icons/fa";
import AdminNavbar from "../../../components/admin/Navbar";
import Modal from "../../../components/ui/Modal";
import { ToastProvider, useToast } from "../../../components/ui/Toaster";
import {
  addAdminQuestionBankQuestions,
  assignAdminHeistQuestions,
  createAdminAffiliateTask,
  createAdminHeist,
  deleteAdminAffiliateTask,
  deleteAdminHeistQuestion,
  deleteAdminQuestionBankQuestion,
  finalizeAdminHeist,
  getAdminAffiliateTaskProgress,
  getAdminHeist,
  getAdminAffiliateTasks,
  getAdminHeistQuestions,
  getAdminHeists,
  getAdminQuestionBank,
  updateAdminAffiliateTask,
  updateAdminHeistStatus,
} from "../../../lib/adminHeists";
import styles from "./AdminHeists.module.css";

const EMPTY_HEIST = {
  name: "",
  description: "",
  min_users: "3",
  ticket_price: "0",
  prize_cop_points: "0",
  questions_per_session: "0",
  countdown_duration_minutes: "10",
  starts_at: "",
  ends_at: "",
};

const EMPTY_QUESTION = {
  question_text: "",
  correct_answer: "true",
  sort_order: "1",
};

const EMPTY_TASK = {
  required_joins: "1",
  reward_cop_points: "0",
  is_active: true,
};

function formatNum(value) {
  const n = Number(value);
  return Number.isFinite(n) ? n.toLocaleString() : "0";
}

function formatDate(value) {
  if (!value) return "Not set";
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "Not set";
  return date.toLocaleString([], {
    month: "short",
    day: "numeric",
    hour: "numeric",
    minute: "2-digit",
  });
}

function formatDurationMinutes(value) {
  const minutes = Number(value);
  if (!Number.isFinite(minutes) || minutes <= 0) return "Not set";
  if (minutes < 60) return `${minutes} min`;
  const hours = Math.floor(minutes / 60);
  const rem = minutes % 60;
  return rem ? `${hours}h ${rem}m` : `${hours}h`;
}

function formatTimerWindow(heist) {
  if (!heist) return "Not scheduled";
  if (heist.countdown_ends_at) return `Ends ${formatDate(heist.countdown_ends_at)}`;
  if (heist.ends_at) return `Closes ${formatDate(heist.ends_at)}`;
  if (heist.starts_at) return `Starts ${formatDate(heist.starts_at)}`;
  return "No timer set";
}

function AdminHeistsPage() {
  const toast = useToast();

  const [heists, setHeists] = useState([]);
  const [detailHeist, setDetailHeist] = useState(null);
  const [selectedId, setSelectedId] = useState(null);
  const [questions, setQuestions] = useState([]);
  const [questionBank, setQuestionBank] = useState([]);
  const [questionBankSummary, setQuestionBankSummary] = useState(null);
  const [tasks, setTasks] = useState([]);
  const [progress, setProgress] = useState([]);
  const [participants, setParticipants] = useState([]);
  const [loading, setLoading] = useState(true);
  const [busy, setBusy] = useState(false);
  const [detailLoading, setDetailLoading] = useState(false);
  const [error, setError] = useState("");
  const [createModalOpen, setCreateModalOpen] = useState(false);
  const [questionsModalOpen, setQuestionsModalOpen] = useState(false);
  const [taskModalOpen, setTaskModalOpen] = useState(false);

  const [createForm, setCreateForm] = useState(EMPTY_HEIST);
  const [questionRows, setQuestionRows] = useState([
    { ...EMPTY_QUESTION, sort_order: "1" },
    { ...EMPTY_QUESTION, sort_order: "2" },
    { ...EMPTY_QUESTION, sort_order: "3" },
  ]);
  const [taskForm, setTaskForm] = useState(EMPTY_TASK);
  const [statusValue, setStatusValue] = useState("pending");
  const [sessionQuestionCount, setSessionQuestionCount] = useState("0");

  const selectedHeist = useMemo(
    () => heists.find((heist) => Number(heist.id) === Number(selectedId)) || null,
    [heists, selectedId]
  );

  const activeDetailHeist = useMemo(() => {
    if (Number(detailHeist?.id) === Number(selectedId)) return detailHeist;
    return selectedHeist;
  }, [detailHeist, selectedHeist, selectedId]);

  const totals = useMemo(
    () => ({
      all: heists.length,
      pending: heists.filter((h) => h.status === "pending").length,
      started: heists.filter((h) => h.status === "started").length,
      completed: heists.filter((h) => h.status === "completed").length,
    }),
    [heists]
  );

  const activeHeists = useMemo(
    () => heists.filter((heist) => heist.status !== "completed"),
    [heists]
  );

  const completedHeists = useMemo(
    () => heists.filter((heist) => heist.status === "completed"),
    [heists]
  );

  const loadHeists = useCallback(async () => {
    setLoading(true);
    setError("");

    try {
      const data = await getAdminHeists();
      const rows = Array.isArray(data?.heists) ? data.heists : [];
      setHeists(rows);
      setSelectedId((current) => {
        if (current) return current;
        return rows.find((heist) => heist.status !== "completed")?.id || rows[0]?.id || null;
      });
    } catch (err) {
      console.error("Load admin heists error:", err);
      setError(err?.response?.data?.message || "Unable to load heists.");
    } finally {
      setLoading(false);
    }
  }, []);

  const loadQuestionBank = useCallback(async () => {
    try {
      const data = await getAdminQuestionBank();
      setQuestionBank(Array.isArray(data?.questions) ? data.questions : []);
      setQuestionBankSummary(data?.summary || null);
    } catch (err) {
      console.error("Load question bank error:", err);
      toast.error(err?.response?.data?.message || "Unable to load question bank.");
    }
  }, [toast]);

  const loadSelectedDetails = useCallback(async () => {
    if (!selectedId) {
      setDetailHeist(null);
      setQuestions([]);
      setTasks([]);
      setProgress([]);
      setParticipants([]);
      return;
    }

    setDetailLoading(true);
    try {
      const [heistData, questionData, taskData, progressData] = await Promise.all([
        getAdminHeist(selectedId),
        getAdminHeistQuestions(selectedId),
        getAdminAffiliateTasks(selectedId),
        getAdminAffiliateTaskProgress(selectedId),
      ]);

      setDetailHeist(heistData?.heist || null);
      setQuestions(Array.isArray(questionData?.questions) ? questionData.questions : []);
      setTasks(Array.isArray(taskData?.tasks) ? taskData.tasks : []);
      setProgress(Array.isArray(progressData?.progress) ? progressData.progress : []);
      setParticipants(Array.isArray(heistData?.participants) ? heistData.participants : []);
    } catch (err) {
      console.error("Load heist details error:", err);
      toast.error(err?.response?.data?.message || "Unable to load heist details.");
    } finally {
      setDetailLoading(false);
    }
  }, [selectedId, toast]);

  useEffect(() => {
    loadHeists();
    loadQuestionBank();
  }, [loadHeists, loadQuestionBank]);

  useEffect(() => {
    if (activeDetailHeist?.status) setStatusValue(activeDetailHeist.status);
  }, [activeDetailHeist?.status]);

  useEffect(() => {
    if (activeDetailHeist) {
      setSessionQuestionCount(String(activeDetailHeist.questions_per_session || 0));
    }
  }, [activeDetailHeist]);

  useEffect(() => {
    loadSelectedDetails();
  }, [loadSelectedDetails]);

  const updateCreateForm = (event) => {
    const { name, value } = event.target;
    setCreateForm((prev) => ({ ...prev, [name]: value }));
  };

  const createHeist = async (event) => {
    event.preventDefault();
    if (busy) return;
    if (!createForm.name.trim()) {
      toast.warn("Heist name is required");
      return;
    }

    setBusy(true);
    try {
      const payload = {
        ...createForm,
        min_users: Number(createForm.min_users || 1),
        ticket_price: Number(createForm.ticket_price || 0),
        prize_cop_points: Number(createForm.prize_cop_points || 0),
        questions_per_session: Number(createForm.questions_per_session || 0),
        question_count: Number(createForm.questions_per_session || 0),
        countdown_duration_minutes: Number(createForm.countdown_duration_minutes || 10),
        starts_at: createForm.starts_at || null,
        ends_at: createForm.ends_at || null,
      };

      const data = await createAdminHeist(payload);
      toast.success("Heist created");
      setCreateForm(EMPTY_HEIST);
      setCreateModalOpen(false);
      await Promise.all([loadHeists(), loadQuestionBank()]);
      if (data?.heist_id) setSelectedId(data.heist_id);
    } catch (err) {
      console.error("Create heist error:", err);
      toast.error(err?.response?.data?.message || "Unable to create heist.");
    } finally {
      setBusy(false);
    }
  };

  const updateQuestion = (index, key, value) => {
    setQuestionRows((prev) =>
      prev.map((row, rowIndex) => (rowIndex === index ? { ...row, [key]: value } : row))
    );
  };

  const addQuestionRow = () => {
    setQuestionRows((prev) => [
      ...prev,
      { ...EMPTY_QUESTION, sort_order: String(prev.length + 1) },
    ]);
  };

  const removeQuestionRow = (index) => {
    setQuestionRows((prev) => prev.filter((_, rowIndex) => rowIndex !== index));
  };

  const addQuestions = async (event) => {
    event.preventDefault();
    if (busy) return;

    const payload = questionRows
      .map((row, index) => ({
        question_text: row.question_text.trim(),
        correct_answer: row.correct_answer,
        sort_order: Number(row.sort_order || index + 1),
      }))
      .filter((row) => row.question_text);

    if (!payload.length) {
      toast.warn("Add at least one question");
      return;
    }

    setBusy(true);
    try {
      await addAdminQuestionBankQuestions(payload);
      toast.success("Questions added to bank");
      setQuestionRows([{ ...EMPTY_QUESTION, sort_order: String(questions.length + 1) }]);
      setQuestionsModalOpen(false);
      await loadQuestionBank();
    } catch (err) {
      console.error("Add questions error:", err);
      toast.error(err?.response?.data?.message || "Unable to add questions.");
    } finally {
      setBusy(false);
    }
  };

  const updateStatus = async () => {
    if (!selectedId || busy || !statusValue) return;

    setBusy(true);
    try {
      await updateAdminHeistStatus(selectedId, statusValue);
      toast.success("Status updated");
      await loadHeists();
    } catch (err) {
      console.error("Update heist status error:", err);
      toast.error(err?.response?.data?.message || "Unable to update status.");
    } finally {
      setBusy(false);
    }
  };

  const saveSessionQuestionCount = async () => {
    if (!selectedId || busy) return;
    const count = Number(sessionQuestionCount);
    if (!Number.isInteger(count) || count < 0) {
      toast.warn("Questions per session must be 0 or greater");
      return;
    }

    setBusy(true);
    try {
      await assignAdminHeistQuestions(selectedId, count);
      toast.success("Question bank assigned");
      await Promise.all([loadHeists(), loadSelectedDetails(), loadQuestionBank()]);
    } catch (err) {
      console.error("Update question session count error:", err);
      toast.error(err?.response?.data?.message || "Unable to update question session count.");
    } finally {
      setBusy(false);
    }
  };

  const finalizeHeist = async () => {
    if (!selectedId || busy) return;
    const ok = window.confirm("Finalize this heist and award the winner?");
    if (!ok) return;

    setBusy(true);
    try {
      const data = await finalizeAdminHeist(selectedId);
      toast.success(
        data?.winner
          ? `Winner awarded ${formatNum(data.awarded_points)} CP`
          : "Heist finalized without submitted winner"
      );
      await Promise.all([loadHeists(), loadSelectedDetails()]);
    } catch (err) {
      console.error("Finalize heist error:", err);
      toast.error(err?.response?.data?.message || "Unable to finalize heist.");
    } finally {
      setBusy(false);
    }
  };

  const deleteQuestion = async (question) => {
    if (!selectedId || !question?.id || busy) return;
    const ok = window.confirm("Delete this question from the heist?");
    if (!ok) return;

    setBusy(true);
    try {
      await deleteAdminHeistQuestion(selectedId, question.id);
      toast.success("Question deleted");
      await Promise.all([loadSelectedDetails(), loadHeists()]);
    } catch (err) {
      console.error("Delete question error:", err);
      toast.error(err?.response?.data?.message || "Unable to delete question.");
    } finally {
      setBusy(false);
    }
  };

  const deleteBankQuestion = async (question) => {
    if (!question?.id || busy) return;
    const ok = window.confirm("Delete this unused bank question?");
    if (!ok) return;

    setBusy(true);
    try {
      await deleteAdminQuestionBankQuestion(question.id);
      toast.success("Bank question deleted");
      await loadQuestionBank();
    } catch (err) {
      console.error("Delete bank question error:", err);
      toast.error(err?.response?.data?.message || "Unable to delete bank question.");
    } finally {
      setBusy(false);
    }
  };

  const unusedBankCount = Number(questionBankSummary?.unused || 0);

  const createTask = async (event) => {
    event.preventDefault();
    if (!selectedId || busy) return;

    setBusy(true);
    try {
      await createAdminAffiliateTask(selectedId, {
        required_joins: Number(taskForm.required_joins || 1),
        reward_cop_points: Number(taskForm.reward_cop_points || 0),
        is_active: taskForm.is_active,
      });
      toast.success("Affiliate task created");
      setTaskForm(EMPTY_TASK);
      setTaskModalOpen(false);
      await loadSelectedDetails();
    } catch (err) {
      console.error("Create affiliate task error:", err);
      toast.error(err?.response?.data?.message || "Unable to create affiliate task.");
    } finally {
      setBusy(false);
    }
  };

  const toggleTask = async (task) => {
    if (!selectedId || !task?.id || busy) return;

    setBusy(true);
    try {
      await updateAdminAffiliateTask(selectedId, task.id, {
        is_active: !Number(task.is_active),
      });
      toast.success("Affiliate task updated");
      await loadSelectedDetails();
    } catch (err) {
      console.error("Update affiliate task error:", err);
      toast.error(err?.response?.data?.message || "Unable to update affiliate task.");
    } finally {
      setBusy(false);
    }
  };

  const deleteTask = async (task) => {
    if (!selectedId || !task?.id || busy) return;
    const ok = window.confirm("Delete this affiliate task?");
    if (!ok) return;

    setBusy(true);
    try {
      await deleteAdminAffiliateTask(selectedId, task.id);
      toast.success("Affiliate task deleted");
      await loadSelectedDetails();
    } catch (err) {
      console.error("Delete affiliate task error:", err);
      toast.error(err?.response?.data?.message || "Unable to delete affiliate task.");
    } finally {
      setBusy(false);
    }
  };

  return (
    <div className={styles.page}>
      <AdminNavbar />
      <main className={styles.main}>
        <section className={styles.hero}>
          <div>
            <p className={styles.kicker}>Admin Heists</p>
            <h1>Heist control room</h1>
            <p>Create True/False heists, assign unused bank questions, start countdowns, finalize winners, and track affiliate tasks.</p>
          </div>
          <button type="button" className={styles.refreshBtn} onClick={loadHeists} disabled={loading || busy}>
            <FaRedoAlt />
            <span>{loading ? "Loading..." : "Refresh"}</span>
          </button>
        </section>

        {error ? (
          <div className={styles.errorBox}>
            <span>{error}</span>
            <button type="button" onClick={loadHeists}>Retry</button>
          </div>
        ) : null}

        <section className={styles.statsGrid}>
          <div>
            <span>Total</span>
            <strong>{formatNum(totals.all)}</strong>
          </div>
          <div>
            <span>Pending</span>
            <strong>{formatNum(totals.pending)}</strong>
          </div>
          <div>
            <span>Started</span>
            <strong>{formatNum(totals.started)}</strong>
          </div>
          <div>
            <span>Completed</span>
            <strong>{formatNum(totals.completed)}</strong>
          </div>
          <div>
            <span>Unused bank</span>
            <strong>{formatNum(unusedBankCount)}</strong>
          </div>
        </section>

        <section className={styles.workspace}>
          <section className={styles.mainPanel}>
            <div className={styles.panelHead}>
              <div>
                <p className={styles.kicker}>Manage</p>
                <h2>Active Heists</h2>
              </div>
              <button
                type="button"
                className={styles.primaryBtn}
                onClick={() => setCreateModalOpen(true)}
                disabled={busy}
              >
                <FaPlus />
                <span>New heist</span>
              </button>
            </div>

            <div className={styles.heistGrid}>
              {loading ? (
                <div className={styles.emptyState}>Loading heists...</div>
              ) : activeHeists.length ? (
                activeHeists.map((heist) => (
                  <button
                    type="button"
                    key={heist.id}
                    className={`${styles.heistCard} ${Number(selectedId) === Number(heist.id) ? styles.selectedCard : ""}`}
                    onClick={() => setSelectedId(heist.id)}
                  >
                    <span className={styles.status}>{heist.status}</span>
                    <strong>{heist.name}</strong>
                    <small>
                      {formatNum(heist.prize_cop_points)} CP prize · {formatNum(heist.total_questions)} assigned questions
                    </small>
                    <span className={styles.cardStats}>
                      <em>{formatNum(heist.total_participants)} players</em>
                      <em>{formatNum(heist.total_submissions)} submissions</em>
                      <em>{formatTimerWindow(heist)}</em>
                    </span>
                  </button>
                ))
              ) : (
                <div className={styles.emptyState}>No active heists.</div>
              )}
            </div>
          </section>
        </section>

        <section className={styles.workspace}>
          <section className={styles.mainPanel}>
            <div className={styles.panelHead}>
              <div>
                <p className={styles.kicker}>Archive</p>
                <h2>Completed Heists</h2>
              </div>
              <span className={styles.status}>{formatNum(completedHeists.length)} completed</span>
            </div>

            <div className={styles.heistGrid}>
              {loading ? (
                <div className={styles.emptyState}>Loading completed heists...</div>
              ) : completedHeists.length ? (
                completedHeists.map((heist) => (
                  <button
                    type="button"
                    key={heist.id}
                    className={`${styles.heistCard} ${Number(selectedId) === Number(heist.id) ? styles.selectedCard : ""}`}
                    onClick={() => setSelectedId(heist.id)}
                  >
                    <span className={styles.status}>{heist.status}</span>
                    <strong>{heist.name}</strong>
                    <small>
                      {formatNum(heist.prize_cop_points)} CP prize · {formatNum(heist.total_questions)} assigned questions
                    </small>
                    <span className={styles.cardStats}>
                      <em>{formatNum(heist.total_participants)} players</em>
                      <em>{formatNum(heist.total_submissions)} submissions</em>
                      <em>{formatTimerWindow(heist)}</em>
                    </span>
                  </button>
                ))
              ) : (
                <div className={styles.emptyState}>No completed heists yet.</div>
              )}
            </div>
          </section>
        </section>

        {activeDetailHeist ? (
          <section className={styles.detailGrid}>
            <article className={styles.detailPanel}>
              <div className={styles.panelHead}>
                <div>
                  <p className={styles.kicker}>Selected</p>
                  <h2>{activeDetailHeist.name}</h2>
                </div>
                <FaTrophy />
              </div>

              {activeDetailHeist.description ? (
                <p className={styles.detailCopy}>{activeDetailHeist.description}</p>
              ) : null}

              <div className={styles.metaGrid}>
                <div><span>Status</span><strong>{activeDetailHeist.status}</strong></div>
                <div><span>Prize</span><strong>{formatNum(activeDetailHeist.prize_cop_points)} CP</strong></div>
                <div><span>Ticket</span><strong>{formatNum(activeDetailHeist.ticket_price)} CP</strong></div>
                <div><span>Min users</span><strong>{formatNum(activeDetailHeist.min_users)}</strong></div>
                <div><span>Participants</span><strong>{formatNum(activeDetailHeist.total_participants)}</strong></div>
                <div><span>Joined only</span><strong>{formatNum(activeDetailHeist.joined_participants)}</strong></div>
                <div><span>Submitted</span><strong>{formatNum(activeDetailHeist.submitted_participants)}</strong></div>
                <div><span>Assigned questions</span><strong>{formatNum(activeDetailHeist.total_questions)}</strong></div>
                <div>
                  <span>Question target</span>
                  <strong>
                    {Number(activeDetailHeist.questions_per_session) > 0
                      ? formatNum(activeDetailHeist.questions_per_session)
                      : "All"}
                  </strong>
                </div>
                <div><span>Countdown</span><strong>{formatDurationMinutes(activeDetailHeist.countdown_duration_minutes)}</strong></div>
                <div><span>Timer start</span><strong>{formatDate(activeDetailHeist.countdown_started_at)}</strong></div>
                <div><span>Timer end</span><strong>{formatDate(activeDetailHeist.countdown_ends_at)}</strong></div>
                <div><span>Starts at</span><strong>{formatDate(activeDetailHeist.starts_at)}</strong></div>
                <div><span>Ends at</span><strong>{formatDate(activeDetailHeist.ends_at)}</strong></div>
                <div><span>Winner</span><strong>{activeDetailHeist.winner_full_name || activeDetailHeist.winner_username || "Not decided"}</strong></div>
                <div><span>Created by</span><strong>{activeDetailHeist.created_by_full_name || activeDetailHeist.created_by_username || "Unknown"}</strong></div>
                <div><span>Created</span><strong>{formatDate(activeDetailHeist.created_at)}</strong></div>
              </div>

              <div className={styles.statusBox}>
                <input
                  type="number"
                  min="0"
                  max={questions.length + unusedBankCount || undefined}
                  value={sessionQuestionCount}
                  onChange={(event) => setSessionQuestionCount(event.target.value)}
                  aria-label="Questions per session"
                  title="Assign unused bank questions to this heist."
                />
                <button type="button" className={styles.softBtn} onClick={saveSessionQuestionCount} disabled={busy}>
                  Assign questions
                </button>
                <select value={statusValue} onChange={(event) => setStatusValue(event.target.value)}>
                  <option value="pending">pending</option>
                  <option value="hold">hold</option>
                  <option value="started">started</option>
                  <option value="completed">completed</option>
                  <option value="cancelled">cancelled</option>
                </select>
                <button type="button" className={styles.softBtn} onClick={updateStatus} disabled={busy}>
                  Update status
                </button>
                <button type="button" className={styles.finalizeBtn} onClick={finalizeHeist} disabled={busy}>
                  Finalize winner
                </button>
              </div>
            </article>

            <article className={styles.detailPanel}>
              <div className={styles.panelHead}>
                <div>
                  <p className={styles.kicker}>Players</p>
                  <h2>Joined users</h2>
                </div>
                <FaUsers />
              </div>

              <div className={styles.rows}>
                {detailLoading ? (
                  <div className={styles.emptyState}>Loading participants...</div>
                ) : participants.length ? (
                  participants.map((participant) => (
                    <div className={styles.dataRow} key={participant.id}>
                      <span>
                        <strong>{participant.full_name || participant.username}</strong>
                        <small>
                          @{participant.username}
                          {participant.email ? ` · ${participant.email}` : ""}
                        </small>
                        <small>
                          Joined {formatDate(participant.joined_at)}
                          {participant.affiliate_username
                            ? ` · referred by ${participant.affiliate_full_name || participant.affiliate_username}`
                            : ""}
                        </small>
                        {participant.submission_id ? (
                          <small>
                            Score {formatNum(participant.correct_count)}/{formatNum(
                              Number(participant.correct_count || 0) +
                                Number(participant.wrong_count || 0) +
                                Number(participant.unanswered_count || 0)
                            )} · {formatNum(participant.score_percent)}% · {formatNum(participant.total_time_seconds)}s
                          </small>
                        ) : null}
                      </span>
                      <div className={styles.rowActions}>
                        <em>{participant.status}</em>
                        {participant.submission_status ? <em>{participant.submission_status}</em> : null}
                      </div>
                    </div>
                  ))
                ) : (
                  <div className={styles.emptyState}>No joined users yet.</div>
                )}
              </div>
            </article>

            <article className={styles.detailPanel}>
              <div className={styles.panelHead}>
                <div>
                  <p className={styles.kicker}>Questions</p>
                  <h2>Assigned question set</h2>
                </div>
                <button
                  type="button"
                  className={styles.primaryBtn}
                  onClick={() => setQuestionsModalOpen(true)}
                  disabled={busy}
                >
                  <FaPlus />
                  <span>Add bank questions</span>
                </button>
              </div>

              <div className={styles.rows}>
                {detailLoading ? (
                  <div className={styles.emptyState}>Loading questions...</div>
                ) : questions.length ? (
                  questions.map((question) => (
                    <div className={styles.dataRow} key={question.id}>
                      <span>
                        <strong>{question.question_text}</strong>
                        <small>Order is shuffled per player · {question.is_active ? "active" : "inactive"}</small>
                      </span>
                      <div className={styles.rowActions}>
                        <em>{question.correct_answer}</em>
                        <button type="button" onClick={() => deleteQuestion(question)} disabled={busy}>
                          <FaTrash />
                        </button>
                      </div>
                    </div>
                  ))
                ) : (
                  <div className={styles.emptyState}>No questions yet.</div>
                )}
              </div>
            </article>

            <article className={styles.detailPanel}>
              <div className={styles.panelHead}>
                <div>
                  <p className={styles.kicker}>Bank</p>
                  <h2>Question bank</h2>
                </div>
                <button
                  type="button"
                  className={styles.softBtn}
                  onClick={loadQuestionBank}
                  disabled={busy}
                >
                  Refresh bank
                </button>
              </div>

              <div className={styles.metaGrid}>
                <div><span>Total</span><strong>{formatNum(questionBankSummary?.total)}</strong></div>
                <div><span>Unused</span><strong>{formatNum(questionBankSummary?.unused)}</strong></div>
                <div><span>Assigned</span><strong>{formatNum(questionBankSummary?.assigned)}</strong></div>
              </div>

              <div className={styles.rows}>
                {questionBank.length ? (
                  questionBank.slice(0, 12).map((question) => (
                    <div className={styles.dataRow} key={question.id}>
                      <span>
                        <strong>{question.question_text}</strong>
                        <small>
                          {question.usage_status === "unused"
                            ? "unused"
                            : `assigned to ${question.heist_name || "heist"}`}
                        </small>
                      </span>
                      <div className={styles.rowActions}>
                        <em>{question.correct_answer}</em>
                        {question.usage_status === "unused" ? (
                          <button type="button" onClick={() => deleteBankQuestion(question)} disabled={busy}>
                            <FaTrash />
                          </button>
                        ) : null}
                      </div>
                    </div>
                  ))
                ) : (
                  <div className={styles.emptyState}>No bank questions yet.</div>
                )}
              </div>
            </article>

            <article className={styles.detailPanel}>
              <div className={styles.panelHead}>
                <div>
                  <p className={styles.kicker}>Affiliate</p>
                  <h2>Reward tasks</h2>
                </div>
                <button
                  type="button"
                  className={styles.primaryBtn}
                  onClick={() => setTaskModalOpen(true)}
                  disabled={busy}
                >
                  <FaPlus />
                  <span>Create task</span>
                </button>
              </div>

              <div className={styles.rows}>
                {tasks.length ? (
                  tasks.map((task) => (
                    <div className={styles.dataRow} key={task.id}>
                      <span>
                        <strong>{formatNum(task.required_joins)} joins</strong>
                        <small>{formatNum(task.reward_cop_points)} CP reward</small>
                      </span>
                      <div className={styles.rowActions}>
                        <button type="button" onClick={() => toggleTask(task)}>
                          {Number(task.is_active) ? "Active" : "Inactive"}
                        </button>
                        <button type="button" onClick={() => deleteTask(task)}><FaTrash /></button>
                      </div>
                    </div>
                  ))
                ) : (
                  <div className={styles.emptyState}>No affiliate tasks yet.</div>
                )}
              </div>
            </article>

            <article className={styles.detailPanel}>
              <div className={styles.panelHead}>
                <div>
                  <p className={styles.kicker}>Progress</p>
                  <h2>Affiliate progress</h2>
                </div>
                <FaUsers />
              </div>

              <div className={styles.rows}>
                {progress.length ? (
                  progress.map((row, index) => (
                    <div className={styles.dataRow} key={`${row.task_id}-${row.progress_id || index}`}>
                      <span>
                        <strong>{row.username || "No progress yet"}</strong>
                        <small>
                          {formatNum(row.current_joins)} / {formatNum(row.required_joins)} joins · {formatNum(row.reward_cop_points)} CP
                        </small>
                      </span>
                      <em>{row.is_completed ? "complete" : "open"}</em>
                    </div>
                  ))
                ) : (
                  <div className={styles.emptyState}>No progress yet.</div>
                )}
              </div>
            </article>
          </section>
        ) : null}

        <Modal
          open={createModalOpen}
          title="Create heist"
          subtitle="Set the entry price, prize, player target, and countdown."
          size="lg"
          onClose={() => !busy && setCreateModalOpen(false)}
          disableClose={busy}
          footer={
            <>
              <button type="button" className={styles.softBtn} onClick={() => setCreateModalOpen(false)} disabled={busy}>
                Cancel
              </button>
              <button type="submit" form="create-heist-form" className={styles.primaryBtn} disabled={busy}>
                <FaSave />
                <span>{busy ? "Saving..." : "Create heist"}</span>
              </button>
            </>
          }
        >
          <form id="create-heist-form" className={`${styles.form} ${styles.modalForm}`} onSubmit={createHeist}>
            <label className={styles.field}>
              <span>Name</span>
              <input name="name" value={createForm.name} onChange={updateCreateForm} placeholder="Weekend Heist" />
            </label>

            <label className={styles.field}>
              <span>Description</span>
              <textarea
                name="description"
                value={createForm.description}
                onChange={updateCreateForm}
                placeholder="Fast true/false run for CopUpCoin rewards."
              />
            </label>

            <div className={styles.twoCol}>
              <label className={styles.field}>
                <span>Min users</span>
                <input type="number" name="min_users" min="1" value={createForm.min_users} onChange={updateCreateForm} />
              </label>
              <label className={styles.field}>
                <span>Ticket CP</span>
                <input type="number" name="ticket_price" min="0" value={createForm.ticket_price} onChange={updateCreateForm} />
              </label>
            </div>

            <div className={styles.twoCol}>
              <label className={styles.field}>
                <span>Prize CP</span>
                <input type="number" name="prize_cop_points" min="0" value={createForm.prize_cop_points} onChange={updateCreateForm} />
              </label>
              <label className={styles.field}>
                <span>Questions per session</span>
                <input
                  type="number"
                  name="questions_per_session"
                  min="0"
                  value={createForm.questions_per_session}
                  onChange={updateCreateForm}
                  placeholder="0 means all questions"
                />
              </label>
            </div>

            <div className={styles.twoCol}>
              <label className={styles.field}>
                <span>Countdown minutes</span>
                <input
                  type="number"
                  name="countdown_duration_minutes"
                  min="1"
                  value={createForm.countdown_duration_minutes}
                  onChange={updateCreateForm}
                />
              </label>
            </div>

            <div className={styles.twoCol}>
              <label className={styles.field}>
                <span>Starts at</span>
                <input type="datetime-local" name="starts_at" value={createForm.starts_at} onChange={updateCreateForm} />
              </label>
              <label className={styles.field}>
                <span>Ends at</span>
                <input type="datetime-local" name="ends_at" value={createForm.ends_at} onChange={updateCreateForm} />
              </label>
            </div>
          </form>
        </Modal>

        <Modal
          open={questionsModalOpen}
          title="Add bank questions"
          subtitle="Add True/False questions to the reusable bank. Assigning a heist will consume unused bank questions."
          size="xl"
          onClose={() => !busy && setQuestionsModalOpen(false)}
          disableClose={busy}
          footer={
            <>
              <button type="button" className={styles.softBtn} onClick={addQuestionRow} disabled={busy}>
                Add row
              </button>
              <button type="button" className={styles.softBtn} onClick={() => setQuestionsModalOpen(false)} disabled={busy}>
                Cancel
              </button>
              <button type="submit" form="add-questions-form" className={styles.primaryBtn} disabled={busy}>
                Save to bank
              </button>
            </>
          }
        >
          <form id="add-questions-form" className={`${styles.form} ${styles.modalForm}`} onSubmit={addQuestions}>
            {questionRows.map((row, index) => (
              <div className={styles.questionRow} key={`question-${index}`}>
                <input
                  value={row.question_text}
                  onChange={(event) => updateQuestion(index, "question_text", event.target.value)}
                  placeholder={`Question ${index + 1}`}
                />
                <select
                  value={row.correct_answer}
                  onChange={(event) => updateQuestion(index, "correct_answer", event.target.value)}
                >
                  <option value="true">true</option>
                  <option value="false">false</option>
                </select>
                <input
                  type="number"
                  min="1"
                  value={row.sort_order}
                  onChange={(event) => updateQuestion(index, "sort_order", event.target.value)}
                />
                <button type="button" onClick={() => removeQuestionRow(index)} disabled={questionRows.length <= 1 || busy}>
                  <FaTrash />
                </button>
              </div>
            ))}
          </form>
        </Modal>

        <Modal
          open={taskModalOpen}
          title="Create affiliate task"
          subtitle={activeDetailHeist ? `Reward users for referring joins to ${activeDetailHeist.name}.` : "Select a heist first."}
          size="md"
          onClose={() => !busy && setTaskModalOpen(false)}
          disableClose={busy}
          footer={
            <>
              <button type="button" className={styles.softBtn} onClick={() => setTaskModalOpen(false)} disabled={busy}>
                Cancel
              </button>
              <button type="submit" form="create-task-form" className={styles.primaryBtn} disabled={busy || !activeDetailHeist}>
                Create task
              </button>
            </>
          }
        >
          <form id="create-task-form" className={`${styles.taskForm} ${styles.modalForm}`} onSubmit={createTask}>
            <label className={styles.field}>
              <span>Required joins</span>
              <input
                type="number"
                min="1"
                value={taskForm.required_joins}
                onChange={(event) => setTaskForm((prev) => ({ ...prev, required_joins: event.target.value }))}
              />
            </label>
            <label className={styles.field}>
              <span>Reward CP</span>
              <input
                type="number"
                min="1"
                value={taskForm.reward_cop_points}
                onChange={(event) => setTaskForm((prev) => ({ ...prev, reward_cop_points: event.target.value }))}
              />
            </label>
            <label className={styles.checkField}>
              <input
                type="checkbox"
                checked={taskForm.is_active}
                onChange={(event) => setTaskForm((prev) => ({ ...prev, is_active: event.target.checked }))}
              />
              <span>Active</span>
            </label>
          </form>
        </Modal>
      </main>
    </div>
  );
}

export default function AdminHeists() {
  return (
    <ToastProvider>
      <AdminHeistsPage />
    </ToastProvider>
  );
}
