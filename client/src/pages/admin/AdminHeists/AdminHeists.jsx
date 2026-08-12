import React, { useCallback, useEffect, useMemo, useState } from "react";
import { NavLink, useLocation } from "react-router-dom";
import {
  FaChevronLeft,
  FaChevronRight,
  FaEdit,
  FaPlus,
  FaRedoAlt,
  FaSave,
  FaTrash,
  FaTrophy,
  FaUsers,
} from "react-icons/fa";
import AdminNavbar from "../../../components/admin/Navbar";
import AdminPageHeader from "../../../components/admin/AdminPageHeader";
import Modal from "../../../components/ui/Modal";
import { ToastProvider, useToast } from "../../../components/ui/Toaster";
import {
  addAdminQuestionBankQuestions,
  assignAdminHeistQuestions,
  createAdminAffiliateTask,
  createAdminDemoUser,
  createAdminHeistDemoUser,
  createAdminHeistContent,
  createAdminHeist,
  createAdminPromoCode,
  deleteAdminAffiliateTask,
  deleteAdminHeistDemoUser,
  deleteAdminHeistContent,
  deleteAdminHeistQuestion,
  deleteAdminPromoCode,
  deleteAdminQuestionBankQuestion,
  expireAdminPromoCode,
  finalizeAdminHeist,
  getAdminAutoHeistSettings,
  getAdminAffiliateTaskProgress,
  getAdminDemoUsers,
  getAdminHeist,
  getAdminHeistContentBank,
  getAdminAffiliateTasks,
  getAdminHeistQuestions,
  getAdminHeists,
  getAdminPromoCodes,
  getAdminQuestionBank,
  runAdminAutoHeist,
  updateAdminAutoHeistSettings,
  updateAdminHeist,
  updateAdminAffiliateTask,
  updateAdminDemoUser,
  updateAdminHeistStatus,
  updateAdminPromoCode,
} from "../../../lib/adminHeists";
import styles from "./AdminHeists.module.css";

const EMPTY_HEIST = {
  name: "",
  description: "",
  min_users: "3",
  max_users: "",
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

const EMPTY_CONTENT = {
  name: "",
  description: "",
  is_active: true,
};

const EMPTY_TASK = {
  required_joins: "1",
  reward_cop_points: "0",
  is_active: true,
};

const EMPTY_AUTO_HEIST = {
  is_enabled: false,
  min_users: "3",
  max_users: "",
  ticket_price: "0",
  prize_cop_points: "0",
  questions_per_session: "3",
  countdown_duration_minutes: "10",
};

const EMPTY_PROMO_CODE = {
  code: "",
  copup_jr_amount: "1",
  max_redemptions: "",
  expires_at: "",
  is_active: true,
};

const EMPTY_DEMO_USER = {
  demo_user_id: "",
  display_name: "",
  correct_count: "0",
  wrong_count: "0",
  unanswered_count: "0",
  total_time_seconds: "60",
  submitted_at: "",
};

const HEISTS_PER_PAGE = 6;

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

function toDateTimeLocalValue(value) {
  if (!value) return "";
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "";

  const pad = (part) => String(part).padStart(2, "0");
  return [
    date.getFullYear(),
    pad(date.getMonth() + 1),
    pad(date.getDate()),
  ].join("-") + `T${pad(date.getHours())}:${pad(date.getMinutes())}`;
}

function heistToForm(heist) {
  return {
    name: heist?.name || "",
    description: heist?.description || "",
    min_users: String(heist?.min_users ?? "1"),
    max_users: heist?.max_users ? String(heist.max_users) : "",
    ticket_price: String(heist?.ticket_price ?? "0"),
    prize_cop_points: String(heist?.prize_cop_points ?? "0"),
    questions_per_session: String(heist?.questions_per_session ?? "0"),
    countdown_duration_minutes: String(heist?.countdown_duration_minutes ?? "10"),
    starts_at: toDateTimeLocalValue(heist?.starts_at),
    ends_at: toDateTimeLocalValue(heist?.ends_at),
  };
}

function autoHeistToForm(settings) {
  return {
    is_enabled: Boolean(Number(settings?.is_enabled || 0)),
    min_users: String(settings?.min_users ?? "1"),
    max_users: settings?.max_users ? String(settings.max_users) : "",
    ticket_price: String(settings?.ticket_price ?? "0"),
    prize_cop_points: String(settings?.prize_cop_points ?? "0"),
    questions_per_session: String(settings?.questions_per_session ?? "0"),
    countdown_duration_minutes: String(settings?.countdown_duration_minutes ?? "10"),
  };
}

function pageCountFor(total) {
  return Math.max(1, Math.ceil(Number(total || 0) / HEISTS_PER_PAGE));
}

function paginateRows(rows, page) {
  const start = (page - 1) * HEISTS_PER_PAGE;
  return rows.slice(start, start + HEISTS_PER_PAGE);
}

function normalizeMaxUsers(value) {
  const maxUsers = Number(value || 0);
  return Number.isFinite(maxUsers) && maxUsers > 0 ? maxUsers : null;
}

function formatCapacity(heist) {
  const total = formatNum(heist?.total_participants);
  const maxUsers = Number(heist?.max_users || 0);
  return maxUsers > 0 ? `${total}/${formatNum(maxUsers)} players` : `${total} players`;
}

function AdminHeistsPage() {
  const toast = useToast();
  const location = useLocation();

  const [heists, setHeists] = useState([]);
  const [detailHeist, setDetailHeist] = useState(null);
  const [selectedId, setSelectedId] = useState(null);
  const [questions, setQuestions] = useState([]);
  const [questionBank, setQuestionBank] = useState([]);
  const [questionBankSummary, setQuestionBankSummary] = useState(null);
  const [contentBank, setContentBank] = useState([]);
  const [contentBankSummary, setContentBankSummary] = useState(null);
  const [tasks, setTasks] = useState([]);
  const [progress, setProgress] = useState([]);
  const [participants, setParticipants] = useState([]);
  const [demoUsers, setDemoUsers] = useState([]);
  const [demoUserBank, setDemoUserBank] = useState([]);
  const [promoCodes, setPromoCodes] = useState([]);
  const [promoSummary, setPromoSummary] = useState(null);
  const [loading, setLoading] = useState(true);
  const [busy, setBusy] = useState(false);
  const [detailLoading, setDetailLoading] = useState(false);
  const [error, setError] = useState("");
  const [createModalOpen, setCreateModalOpen] = useState(false);
  const [editModalOpen, setEditModalOpen] = useState(false);
  const [questionsModalOpen, setQuestionsModalOpen] = useState(false);
  const [contentModalOpen, setContentModalOpen] = useState(false);
  const [taskModalOpen, setTaskModalOpen] = useState(false);

  const [createForm, setCreateForm] = useState(EMPTY_HEIST);
  const [editForm, setEditForm] = useState(EMPTY_HEIST);
  const [questionRows, setQuestionRows] = useState([
    { ...EMPTY_QUESTION, sort_order: "1" },
    { ...EMPTY_QUESTION, sort_order: "2" },
    { ...EMPTY_QUESTION, sort_order: "3" },
  ]);
  const [taskForm, setTaskForm] = useState(EMPTY_TASK);
  const [contentForm, setContentForm] = useState(EMPTY_CONTENT);
  const [autoHeistForm, setAutoHeistForm] = useState(EMPTY_AUTO_HEIST);
  const [promoForm, setPromoForm] = useState(EMPTY_PROMO_CODE);
  const [demoUserForm, setDemoUserForm] = useState(EMPTY_DEMO_USER);
  const [demoBankName, setDemoBankName] = useState("");
  const [statusValue, setStatusValue] = useState("pending");
  const [sessionQuestionCount, setSessionQuestionCount] = useState("0");
  const [activePage, setActivePage] = useState(1);
  const [completedPage, setCompletedPage] = useState(1);
  const pageMode = location.pathname.endsWith("/content-bank")
    ? "content"
    : location.pathname.endsWith("/question-bank")
      ? "questions"
      : location.pathname.endsWith("/promo-codes")
        ? "promo"
        : location.pathname.endsWith("/archive")
          ? "archive"
          : "main";
  const isMainPage = pageMode === "main";
  const isContentPage = pageMode === "content";
  const isQuestionBankPage = pageMode === "questions";
  const isPromoPage = pageMode === "promo";
  const isArchivePage = pageMode === "archive";

  const selectedHeist = useMemo(
    () => heists.find((heist) => Number(heist.id) === Number(selectedId)) || null,
    [heists, selectedId]
  );

  const activeDetailHeist = useMemo(() => {
    if (Number(detailHeist?.id) === Number(selectedId)) return detailHeist;
    return selectedHeist;
  }, [detailHeist, selectedHeist, selectedId]);

  const demoQuestionLimit = useMemo(
    () => Math.max(Number(activeDetailHeist?.total_questions || 0), questions.length),
    [activeDetailHeist?.total_questions, questions.length]
  );

  const demoAnswerTotal = useMemo(
    () =>
      Number(demoUserForm.correct_count || 0) +
      Number(demoUserForm.wrong_count || 0) +
      Number(demoUserForm.unanswered_count || 0),
    [demoUserForm.correct_count, demoUserForm.wrong_count, demoUserForm.unanswered_count]
  );

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

  const activePageCount = useMemo(() => pageCountFor(activeHeists.length), [activeHeists.length]);
  const completedPageCount = useMemo(
    () => pageCountFor(completedHeists.length),
    [completedHeists.length]
  );

  const pagedActiveHeists = useMemo(
    () => paginateRows(activeHeists, activePage),
    [activeHeists, activePage]
  );

  const pagedCompletedHeists = useMemo(
    () => paginateRows(completedHeists, completedPage),
    [completedHeists, completedPage]
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

  const loadContentBank = useCallback(async () => {
    try {
      const data = await getAdminHeistContentBank();
      setContentBank(Array.isArray(data?.items) ? data.items : []);
      setContentBankSummary(data?.summary || null);
    } catch (err) {
      console.error("Load heist content bank error:", err);
      toast.error(err?.response?.data?.message || "Unable to load heist content bank.");
    }
  }, [toast]);

  const loadAutoHeistSettings = useCallback(async () => {
    try {
      const data = await getAdminAutoHeistSettings();
      setAutoHeistForm(autoHeistToForm(data?.settings));
    } catch (err) {
      console.error("Load auto heist settings error:", err);
      toast.error(err?.response?.data?.message || "Unable to load auto heist settings.");
    }
  }, [toast]);

  const loadPromoCodes = useCallback(async () => {
    try {
      const data = await getAdminPromoCodes();
      setPromoCodes(Array.isArray(data?.codes) ? data.codes : []);
      setPromoSummary(data?.summary || null);
    } catch (err) {
      console.error("Load promo codes error:", err);
      toast.error(err?.response?.data?.message || "Unable to load promo codes.");
    }
  }, [toast]);

  const loadDemoUserBank = useCallback(async () => {
    try {
      const data = await getAdminDemoUsers();
      setDemoUserBank(Array.isArray(data?.demo_users) ? data.demo_users : []);
    } catch (err) {
      console.error("Load demo user bank error:", err);
      toast.error(err?.response?.data?.message || "Unable to load demo users.");
    }
  }, [toast]);

  const loadSelectedDetails = useCallback(async () => {
    if (!selectedId) {
      setDetailHeist(null);
      setQuestions([]);
      setTasks([]);
      setProgress([]);
      setParticipants([]);
      setDemoUsers([]);
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
      setDemoUsers(Array.isArray(heistData?.demo_submissions) ? heistData.demo_submissions : []);
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
    loadContentBank();
    loadAutoHeistSettings();
    loadDemoUserBank();
    loadPromoCodes();
  }, [loadHeists, loadQuestionBank, loadContentBank, loadAutoHeistSettings, loadDemoUserBank, loadPromoCodes]);

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

  useEffect(() => {
    setActivePage((current) => Math.min(current, activePageCount));
  }, [activePageCount]);

  useEffect(() => {
    setCompletedPage((current) => Math.min(current, completedPageCount));
  }, [completedPageCount]);

  useEffect(() => {
    if (!isArchivePage || !completedHeists.length) return;
    const selectedIsCompleted = completedHeists.some(
      (heist) => Number(heist.id) === Number(selectedId)
    );
    if (!selectedIsCompleted) setSelectedId(completedHeists[0].id);
  }, [completedHeists, isArchivePage, selectedId]);

  const updateCreateForm = (event) => {
    const { name, value } = event.target;
    setCreateForm((prev) => ({ ...prev, [name]: value }));
  };

  const updateEditForm = (event) => {
    const { name, value } = event.target;
    setEditForm((prev) => ({ ...prev, [name]: value }));
  };

  const updateContentForm = (event) => {
    const { name, type, checked, value } = event.target;
    setContentForm((prev) => ({ ...prev, [name]: type === "checkbox" ? checked : value }));
  };

  const updateAutoHeistForm = (event) => {
    const { name, type, checked, value } = event.target;
    setAutoHeistForm((prev) => ({ ...prev, [name]: type === "checkbox" ? checked : value }));
  };

  const updatePromoForm = (event) => {
    const { name, type, checked, value } = event.target;
    setPromoForm((prev) => ({
      ...prev,
      [name]: type === "checkbox" ? checked : name === "code" ? value.toUpperCase() : value,
    }));
  };

  const updateDemoUserForm = (event) => {
    const { name, value } = event.target;
    setDemoUserForm((prev) => {
      if (name === "demo_user_id") {
        const selectedDemoUser = demoUserBank.find((user) => Number(user.id) === Number(value));
        return {
          ...prev,
          demo_user_id: value,
          display_name: selectedDemoUser?.display_name || "",
        };
      }
      return { ...prev, [name]: value };
    });
  };

  const applyContentTemplate = (mode, contentId) => {
    const item = contentBank.find((entry) => Number(entry.id) === Number(contentId));
    if (!item) return;
    const updater = mode === "edit" ? setEditForm : setCreateForm;
    updater((prev) => ({
      ...prev,
      name: item.name || "",
      description: item.description || "",
    }));
  };

  const openEditModal = () => {
    if (!activeDetailHeist) return;
    setEditForm(heistToForm(activeDetailHeist));
    setEditModalOpen(true);
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
        max_users: normalizeMaxUsers(createForm.max_users),
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

  const updateHeist = async (event) => {
    event.preventDefault();
    if (!selectedId || busy) return;
    if (!editForm.name.trim()) {
      toast.warn("Heist name is required");
      return;
    }

    setBusy(true);
    try {
      await updateAdminHeist(selectedId, {
        ...editForm,
        min_users: Number(editForm.min_users || 1),
        max_users: normalizeMaxUsers(editForm.max_users),
        ticket_price: Number(editForm.ticket_price || 0),
        prize_cop_points: Number(editForm.prize_cop_points || 0),
        questions_per_session: Number(editForm.questions_per_session || 0),
        countdown_duration_minutes: Number(editForm.countdown_duration_minutes || 10),
        starts_at: editForm.starts_at || null,
        ends_at: editForm.ends_at || null,
      });
      toast.success("Heist updated");
      setEditModalOpen(false);
      await Promise.all([loadHeists(), loadSelectedDetails()]);
    } catch (err) {
      console.error("Update heist error:", err);
      toast.error(err?.response?.data?.message || "Unable to update heist.");
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

  const createDemoUser = async (event) => {
    event.preventDefault();
    if (!selectedId || busy) return;
    if (!demoUserForm.demo_user_id) {
      toast.warn("Select a demo user first.");
      return;
    }
    if (demoQuestionLimit <= 0) {
      toast.warn("Assign questions to this heist before adding demo players.");
      return;
    }
    if (demoAnswerTotal > demoQuestionLimit) {
      toast.warn(`Demo answers cannot be more than ${demoQuestionLimit} question(s).`);
      return;
    }

    setBusy(true);
    try {
      await createAdminHeistDemoUser(selectedId, {
        demo_user_id: Number(demoUserForm.demo_user_id),
        display_name: demoUserForm.display_name.trim(),
        correct_count: Number(demoUserForm.correct_count || 0),
        wrong_count: Number(demoUserForm.wrong_count || 0),
        unanswered_count: Number(demoUserForm.unanswered_count || 0),
        total_time_seconds: Number(demoUserForm.total_time_seconds || 0),
        submitted_at: demoUserForm.submitted_at || null,
      });
      toast.success("Demo player added");
      setDemoUserForm(EMPTY_DEMO_USER);
      await loadSelectedDetails();
    } catch (err) {
      console.error("Create demo player error:", err);
      toast.error(err?.response?.data?.message || "Unable to add demo player.");
    } finally {
      setBusy(false);
    }
  };

  const createDemoBankUser = async () => {
    const displayName = demoBankName.trim();
    if (!displayName || busy) return;

    setBusy(true);
    try {
      const data = await createAdminDemoUser({ display_name: displayName });
      toast.success("Demo user saved");
      setDemoBankName("");
      await loadDemoUserBank();
      if (data?.demo_user?.id) {
        setDemoUserForm((prev) => ({
          ...prev,
          demo_user_id: String(data.demo_user.id),
          display_name: data.demo_user.display_name,
        }));
      }
    } catch (err) {
      console.error("Create demo bank user error:", err);
      toast.error(err?.response?.data?.message || "Unable to save demo user.");
    } finally {
      setBusy(false);
    }
  };

  const toggleDemoBankUser = async (demoUser) => {
    if (!demoUser?.id || busy) return;

    setBusy(true);
    try {
      await updateAdminDemoUser(demoUser.id, { is_active: !Number(demoUser.is_active) });
      toast.success("Demo user updated");
      await loadDemoUserBank();
    } catch (err) {
      console.error("Update demo bank user error:", err);
      toast.error(err?.response?.data?.message || "Unable to update demo user.");
    } finally {
      setBusy(false);
    }
  };

  const renameDemoBankUser = async (demoUser) => {
    if (!demoUser?.id || busy) return;
    const nextName = window.prompt("Update demo user name", demoUser.display_name);
    if (nextName === null) return;
    const displayName = nextName.trim();
    if (!displayName || displayName === demoUser.display_name) return;

    setBusy(true);
    try {
      await updateAdminDemoUser(demoUser.id, { display_name: displayName });
      toast.success("Demo user renamed");
      await loadDemoUserBank();
      await loadSelectedDetails();
    } catch (err) {
      console.error("Rename demo bank user error:", err);
      toast.error(err?.response?.data?.message || "Unable to rename demo user.");
    } finally {
      setBusy(false);
    }
  };

  const deleteDemoUser = async (demoUser) => {
    if (!selectedId || !demoUser?.id || busy) return;
    const ok = window.confirm("Delete this demo leaderboard player?");
    if (!ok) return;

    setBusy(true);
    try {
      await deleteAdminHeistDemoUser(selectedId, demoUser.id);
      toast.success("Demo player deleted");
      await loadSelectedDetails();
    } catch (err) {
      console.error("Delete demo player error:", err);
      toast.error(err?.response?.data?.message || "Unable to delete demo player.");
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

  const createContent = async (event) => {
    event.preventDefault();
    if (busy) return;
    if (!contentForm.name.trim() || !contentForm.description.trim()) {
      toast.warn("Name and description are required");
      return;
    }

    setBusy(true);
    try {
      await createAdminHeistContent({
        name: contentForm.name.trim(),
        description: contentForm.description.trim(),
        is_active: contentForm.is_active,
      });
      toast.success("Heist content saved");
      setContentForm(EMPTY_CONTENT);
      setContentModalOpen(false);
      await loadContentBank();
    } catch (err) {
      console.error("Create heist content error:", err);
      toast.error(err?.response?.data?.message || "Unable to save heist content.");
    } finally {
      setBusy(false);
    }
  };

  const deleteContent = async (item) => {
    if (!item?.id || busy) return;
    const ok = window.confirm("Delete this heist name and description from the bank?");
    if (!ok) return;

    setBusy(true);
    try {
      await deleteAdminHeistContent(item.id);
      toast.success("Heist content deleted");
      await loadContentBank();
    } catch (err) {
      console.error("Delete heist content error:", err);
      toast.error(err?.response?.data?.message || "Unable to delete heist content.");
    } finally {
      setBusy(false);
    }
  };

  const saveAutoHeistSettings = async (event) => {
    event.preventDefault();
    if (busy) return;

    setBusy(true);
    try {
      const data = await updateAdminAutoHeistSettings({
        is_enabled: autoHeistForm.is_enabled,
        min_users: Number(autoHeistForm.min_users || 1),
        max_users: normalizeMaxUsers(autoHeistForm.max_users),
        ticket_price: Number(autoHeistForm.ticket_price || 0),
        prize_cop_points: Number(autoHeistForm.prize_cop_points || 0),
        questions_per_session: Number(autoHeistForm.questions_per_session || 0),
        countdown_duration_minutes: Number(autoHeistForm.countdown_duration_minutes || 10),
      });
      setAutoHeistForm(autoHeistToForm(data?.settings));
      toast.success("Auto heist settings saved");
    } catch (err) {
      console.error("Save auto heist settings error:", err);
      toast.error(err?.response?.data?.message || "Unable to save auto heist settings.");
    } finally {
      setBusy(false);
    }
  };

  const runAutoHeistNow = async () => {
    if (busy) return;

    setBusy(true);
    try {
      const data = await runAdminAutoHeist();
      toast.success(data?.heist_id ? `Auto heist created #${data.heist_id}` : "Auto heist created");
      await Promise.all([loadHeists(), loadQuestionBank()]);
      if (data?.heist_id) setSelectedId(data.heist_id);
    } catch (err) {
      console.error("Run auto heist error:", err);
      const message = err?.response?.data?.reason
        ? `${err.response.data.message}: ${err.response.data.reason}`
        : err?.response?.data?.message || "Unable to create auto heist.";
      toast.error(message);
    } finally {
      setBusy(false);
    }
  };

  const unusedBankCount = Number(questionBankSummary?.unused || 0);
  const activeContentCount = Number(contentBankSummary?.active || 0);
  const activePromoCount = Number(promoSummary?.active || 0);

  const createPromoCode = async (event) => {
    event.preventDefault();
    if (busy) return;
    if (!promoForm.code.trim()) {
      toast.warn("Promo code is required");
      return;
    }

    setBusy(true);
    try {
      await createAdminPromoCode({
        code: promoForm.code.trim(),
        copup_jr_amount: Number(promoForm.copup_jr_amount || 0),
        max_redemptions: promoForm.max_redemptions ? Number(promoForm.max_redemptions) : null,
        expires_at: promoForm.expires_at || null,
        is_active: promoForm.is_active,
      });
      toast.success("Promo code created");
      setPromoForm(EMPTY_PROMO_CODE);
      await loadPromoCodes();
    } catch (err) {
      console.error("Create promo code error:", err);
      toast.error(err?.response?.data?.message || "Unable to create promo code.");
    } finally {
      setBusy(false);
    }
  };

  const editPromoCode = async (promoCode) => {
    if (!promoCode?.id || busy) return;
    const code = window.prompt("Promo code", promoCode.code);
    if (code === null) return;
    const amount = window.prompt("CopUp Jr amount", String(promoCode.copup_jr_amount || 1));
    if (amount === null) return;
    const maxRedemptions = window.prompt(
      "Max redemptions, blank for unlimited",
      promoCode.max_redemptions === null ? "" : String(promoCode.max_redemptions || "")
    );
    if (maxRedemptions === null) return;
    const expiresAt = window.prompt(
      "Expires at as YYYY-MM-DD HH:mm, blank for no expiry",
      promoCode.expires_at ? String(promoCode.expires_at).slice(0, 16).replace("T", " ") : ""
    );
    if (expiresAt === null) return;

    setBusy(true);
    try {
      await updateAdminPromoCode(promoCode.id, {
        code: code.trim(),
        copup_jr_amount: Number(amount || 0),
        max_redemptions: maxRedemptions.trim() ? Number(maxRedemptions) : null,
        expires_at: expiresAt.trim() || null,
      });
      toast.success("Promo code updated");
      await loadPromoCodes();
    } catch (err) {
      console.error("Update promo code error:", err);
      toast.error(err?.response?.data?.message || "Unable to update promo code.");
    } finally {
      setBusy(false);
    }
  };

  const togglePromoCode = async (promoCode) => {
    if (!promoCode?.id || busy) return;

    setBusy(true);
    try {
      await updateAdminPromoCode(promoCode.id, { is_active: !Number(promoCode.is_active) });
      toast.success("Promo code updated");
      await loadPromoCodes();
    } catch (err) {
      console.error("Toggle promo code error:", err);
      toast.error(err?.response?.data?.message || "Unable to update promo code.");
    } finally {
      setBusy(false);
    }
  };

  const expirePromoCode = async (promoCode) => {
    if (!promoCode?.id || busy) return;
    const ok = window.confirm("Expire this promo code now?");
    if (!ok) return;

    setBusy(true);
    try {
      await expireAdminPromoCode(promoCode.id);
      toast.success("Promo code expired");
      await loadPromoCodes();
    } catch (err) {
      console.error("Expire promo code error:", err);
      toast.error(err?.response?.data?.message || "Unable to expire promo code.");
    } finally {
      setBusy(false);
    }
  };

  const deletePromoCode = async (promoCode) => {
    if (!promoCode?.id || busy) return;
    const ok = window.confirm("Delete this promo code?");
    if (!ok) return;

    setBusy(true);
    try {
      await deleteAdminPromoCode(promoCode.id);
      toast.success("Promo code deleted");
      await loadPromoCodes();
    } catch (err) {
      console.error("Delete promo code error:", err);
      toast.error(err?.response?.data?.message || "Unable to delete promo code.");
    } finally {
      setBusy(false);
    }
  };

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

  const renderPagination = ({ page, pageCount, total, onPageChange }) => {
    if (loading || total <= HEISTS_PER_PAGE) return null;

    return (
      <div className={styles.pagination}>
        <button
          type="button"
          onClick={() => onPageChange(Math.max(1, page - 1))}
          disabled={page <= 1}
          aria-label="Previous heists page"
        >
          <FaChevronLeft />
        </button>
        <span>
          Page {formatNum(page)} of {formatNum(pageCount)}
        </span>
        <button
          type="button"
          onClick={() => onPageChange(Math.min(pageCount, page + 1))}
          disabled={page >= pageCount}
          aria-label="Next heists page"
        >
          <FaChevronRight />
        </button>
      </div>
    );
  };

  const renderDemoPlayersPanel = () => (
    <article className={styles.detailPanel}>
      <div className={styles.panelHead}>
        <div>
          <p className={styles.kicker}>Marketing</p>
          <h2>Demo leaderboard players</h2>
        </div>
        <span className={styles.status}>{formatNum(demoUsers.length)} demo</span>
      </div>

      <form className={styles.demoUserForm} onSubmit={createDemoUser}>
        <label className={styles.field}>
          <span>Demo user</span>
          <select
            name="demo_user_id"
            value={demoUserForm.demo_user_id}
            onChange={updateDemoUserForm}
          >
            <option value="">Select demo user</option>
            {demoUserBank
              .filter((demoUser) => Number(demoUser.is_active))
              .map((demoUser) => (
                <option value={demoUser.id} key={demoUser.id}>
                  {demoUser.display_name}
                </option>
              ))}
          </select>
        </label>
        <label className={styles.field}>
          <span>Add to list</span>
          <input
            value={demoBankName}
            onChange={(event) => setDemoBankName(event.target.value)}
            placeholder="Maya Stone"
          />
        </label>
        <button type="button" className={styles.softBtn} onClick={createDemoBankUser} disabled={busy || !demoBankName.trim()}>
          <FaPlus />
          <span>Save user</span>
        </button>
        <label className={styles.field}>
          <span>Correct</span>
          <input type="number" name="correct_count" min="0" max={demoQuestionLimit || undefined} value={demoUserForm.correct_count} onChange={updateDemoUserForm} />
        </label>
        <label className={styles.field}>
          <span>Wrong</span>
          <input type="number" name="wrong_count" min="0" max={demoQuestionLimit || undefined} value={demoUserForm.wrong_count} onChange={updateDemoUserForm} />
        </label>
        <label className={styles.field}>
          <span>Unanswered</span>
          <input type="number" name="unanswered_count" min="0" max={demoQuestionLimit || undefined} value={demoUserForm.unanswered_count} onChange={updateDemoUserForm} />
        </label>
        <label className={styles.field}>
          <span>Time seconds</span>
          <input type="number" name="total_time_seconds" min="0" value={demoUserForm.total_time_seconds} onChange={updateDemoUserForm} />
        </label>
        <label className={styles.field}>
          <span>Submitted at</span>
          <input type="datetime-local" name="submitted_at" value={demoUserForm.submitted_at} onChange={updateDemoUserForm} />
        </label>
        <button type="submit" className={styles.primaryBtn} disabled={busy || !selectedId || !demoUserForm.demo_user_id || demoQuestionLimit <= 0 || demoAnswerTotal > demoQuestionLimit}>
          <FaPlus />
          <span>Add to heist</span>
        </button>
      </form>
      <p className={styles.softNote}>
        {demoQuestionLimit > 0
          ? `${formatNum(demoAnswerTotal)} of ${formatNum(demoQuestionLimit)} question slots used for this demo player.`
          : "Assign questions before adding demo players."}
      </p>

      <div className={styles.rows}>
        {demoUserBank.length ? (
          <div className={styles.demoBankStrip}>
            {demoUserBank.slice(0, 8).map((demoUser) => (
              <span className={styles.demoChipGroup} key={demoUser.id}>
                <button
                  type="button"
                  className={Number(demoUser.is_active) ? styles.demoChip : styles.demoChipOff}
                  onClick={() => toggleDemoBankUser(demoUser)}
                  disabled={busy}
                  title={Number(demoUser.is_active) ? "Click to hide from picker" : "Click to show in picker"}
                >
                  {demoUser.display_name}
                </button>
                <button type="button" className={styles.iconMiniBtn} onClick={() => renameDemoBankUser(demoUser)} disabled={busy}>
                  <FaEdit />
                </button>
              </span>
            ))}
          </div>
        ) : null}
        {demoUsers.length ? (
          demoUsers.map((demoUser) => (
            <div className={styles.dataRow} key={demoUser.id}>
              <span>
                <strong>{demoUser.display_name}</strong>
                <small>
                  {formatNum(demoUser.correct_count)} correct · {formatNum(demoUser.wrong_count)} wrong · {formatNum(demoUser.total_time_seconds)}s
                </small>
                <small>Submitted {formatDate(demoUser.submitted_at)}</small>
              </span>
              <div className={styles.rowActions}>
                <em>demo</em>
                <button type="button" onClick={() => deleteDemoUser(demoUser)} disabled={busy}>
                  <FaTrash />
                </button>
              </div>
            </div>
          ))
        ) : (
          <div className={styles.emptyState}>No demo players yet.</div>
        )}
      </div>
    </article>
  );

  return (
    <div className={styles.page}>
      <AdminNavbar />
      <main className={styles.main}>
        <AdminPageHeader
          kicker="Admin Heists"
          title={
            isContentPage
              ? "Name and description bank"
              : isQuestionBankPage
                ? "Question bank"
                : isPromoPage
                  ? "Promo codes"
                  : isArchivePage
                    ? "Completed heists"
                    : "Heist control room"
          }
          description={
            isContentPage
              ? "Manage reusable heist names and descriptions."
              : isQuestionBankPage
                ? "Manage reusable True/False questions for heists."
                : isPromoPage
                  ? "Create CopUp Jr promo codes for heist-only entry credits."
                  : isArchivePage
                    ? "Review completed heists and past results."
                    : "Create True/False heists, assign unused bank questions, start countdowns, finalize winners, and track affiliate tasks."
          }
          onRefresh={loadHeists}
          refreshing={loading || busy}
          refreshingLabel="Loading..."
          error={error}
          onRetry={loadHeists}
        />

        <nav className={styles.subNav} aria-label="Heist admin sections">
          <NavLink to="/admin/heists" end className={({ isActive }) => (isActive ? styles.subNavActive : styles.subNavLink)}>
            Manage heists
          </NavLink>
          <NavLink to="/admin/heists/content-bank" className={({ isActive }) => (isActive ? styles.subNavActive : styles.subNavLink)}>
            Name bank
          </NavLink>
          <NavLink to="/admin/heists/question-bank" className={({ isActive }) => (isActive ? styles.subNavActive : styles.subNavLink)}>
            Question bank
          </NavLink>
          <NavLink to="/admin/heists/promo-codes" className={({ isActive }) => (isActive ? styles.subNavActive : styles.subNavLink)}>
            Promo codes
          </NavLink>
          <NavLink to="/admin/heists/archive" className={({ isActive }) => (isActive ? styles.subNavActive : styles.subNavLink)}>
            Archive
          </NavLink>
        </nav>

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
          <div>
            <span>Content bank</span>
            <strong>{formatNum(activeContentCount)}</strong>
          </div>
          <div>
            <span>Promo codes</span>
            <strong>{formatNum(activePromoCount)}</strong>
          </div>
        </section>

        {isContentPage ? (
          <section className={styles.detailPanel}>
            <div className={styles.panelHead}>
              <div>
                <p className={styles.kicker}>Bank</p>
                <h2>Name and description bank</h2>
              </div>
              <button
                type="button"
                className={styles.primaryBtn}
                onClick={() => setContentModalOpen(true)}
                disabled={busy}
              >
                <FaPlus />
                <span>Add content</span>
              </button>
            </div>

            <div className={styles.metaGrid}>
              <div><span>Total</span><strong>{formatNum(contentBankSummary?.total)}</strong></div>
              <div><span>Active</span><strong>{formatNum(contentBankSummary?.active)}</strong></div>
              <div><span>Inactive</span><strong>{formatNum(contentBankSummary?.inactive)}</strong></div>
            </div>

            <div className={styles.rowsWide}>
              {contentBank.length ? (
                contentBank.map((item) => (
                  <div className={styles.dataRow} key={item.id}>
                    <span>
                      <strong>{item.name}</strong>
                      <small>{item.description}</small>
                    </span>
                    <div className={styles.rowActions}>
                      <em>{item.is_active ? "active" : "inactive"}</em>
                      <button type="button" onClick={() => deleteContent(item)} disabled={busy}>
                        <FaTrash />
                      </button>
                    </div>
                  </div>
                ))
              ) : (
                <div className={styles.emptyState}>No saved heist content yet.</div>
              )}
            </div>
          </section>
        ) : null}

        {isQuestionBankPage ? (
          <section className={styles.detailPanel}>
            <div className={styles.panelHead}>
              <div>
                <p className={styles.kicker}>Bank</p>
                <h2>Question bank</h2>
              </div>
              <div className={styles.inlineActions}>
                <button
                  type="button"
                  className={styles.primaryBtn}
                  onClick={() => setQuestionsModalOpen(true)}
                  disabled={busy}
                >
                  <FaPlus />
                  <span>Add questions</span>
                </button>
                <button type="button" className={styles.softBtn} onClick={loadQuestionBank} disabled={busy} aria-label="Refresh question bank" title="Refresh question bank">
                  <FaRedoAlt />
                </button>
              </div>
            </div>

            <div className={styles.metaGrid}>
              <div><span>Total</span><strong>{formatNum(questionBankSummary?.total)}</strong></div>
              <div><span>Unused</span><strong>{formatNum(questionBankSummary?.unused)}</strong></div>
              <div><span>Assigned</span><strong>{formatNum(questionBankSummary?.assigned)}</strong></div>
            </div>

            <div className={styles.rowsWide}>
              {questionBank.length ? (
                questionBank.map((question) => (
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
          </section>
        ) : null}

        {isPromoPage ? (
          <section className={styles.detailPanel}>
            <div className={styles.panelHead}>
              <div>
                <p className={styles.kicker}>CopUp Jr</p>
                <h2>Promo codes</h2>
              </div>
              <button type="button" className={styles.softBtn} onClick={loadPromoCodes} disabled={busy} aria-label="Refresh promo codes" title="Refresh promo codes">
                <FaRedoAlt />
              </button>
            </div>

            <div className={styles.metaGrid}>
              <div><span>Total</span><strong>{formatNum(promoSummary?.total)}</strong></div>
              <div><span>Active</span><strong>{formatNum(promoSummary?.active)}</strong></div>
              <div><span>Redemptions</span><strong>{formatNum(promoSummary?.redemptions)}</strong></div>
            </div>

            <form className={styles.promoForm} onSubmit={createPromoCode}>
              <label className={styles.field}>
                <span>Code</span>
                <input name="code" value={promoForm.code} onChange={updatePromoForm} placeholder="HEISTJR" />
              </label>
              <label className={styles.field}>
                <span>CopUp Jr amount</span>
                <input type="number" name="copup_jr_amount" min="1" value={promoForm.copup_jr_amount} onChange={updatePromoForm} />
              </label>
              <label className={styles.field}>
                <span>Max uses</span>
                <input type="number" name="max_redemptions" min="1" value={promoForm.max_redemptions} onChange={updatePromoForm} placeholder="Unlimited" />
              </label>
              <label className={styles.field}>
                <span>Expires at</span>
                <input type="datetime-local" name="expires_at" value={promoForm.expires_at} onChange={updatePromoForm} />
              </label>
              <label className={styles.checkField}>
                <input type="checkbox" name="is_active" checked={promoForm.is_active} onChange={updatePromoForm} />
                <span>Active</span>
              </label>
              <button type="submit" className={styles.primaryBtn} disabled={busy}>
                <FaPlus />
                <span>Create code</span>
              </button>
            </form>

            <div className={styles.rowsWide}>
              {promoCodes.length ? (
                promoCodes.map((promoCode) => {
                  const expired = promoCode.expires_at && new Date(promoCode.expires_at).getTime() <= Date.now();
                  const maxUses = promoCode.max_redemptions ? formatNum(promoCode.max_redemptions) : "Unlimited";
                  return (
                    <div className={styles.dataRow} key={promoCode.id}>
                      <span>
                        <strong>{promoCode.code}</strong>
                        <small>
                          {formatNum(promoCode.copup_jr_amount)} CopUp Jr · {formatNum(promoCode.redemption_count)} / {maxUses} used
                        </small>
                        <small>
                          {promoCode.expires_at ? `Expires ${formatDate(promoCode.expires_at)}` : "No expiry"} · created {formatDate(promoCode.created_at)}
                        </small>
                      </span>
                      <div className={styles.rowActions}>
                        <em>{Number(promoCode.is_active) && !expired ? "active" : expired ? "expired" : "inactive"}</em>
                        <button type="button" onClick={() => editPromoCode(promoCode)} disabled={busy}>
                          <FaEdit />
                        </button>
                        <button type="button" onClick={() => togglePromoCode(promoCode)} disabled={busy}>
                          {Number(promoCode.is_active) ? "Disable" : "Enable"}
                        </button>
                        <button type="button" onClick={() => expirePromoCode(promoCode)} disabled={busy || expired}>
                          Expire
                        </button>
                        <button type="button" onClick={() => deletePromoCode(promoCode)} disabled={busy}>
                          <FaTrash />
                        </button>
                      </div>
                    </div>
                  );
                })
              ) : (
                <div className={styles.emptyState}>No promo codes yet.</div>
              )}
            </div>
          </section>
        ) : null}

        {isMainPage ? (
          <>
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
                pagedActiveHeists.map((heist) => (
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
                      <em>{formatCapacity(heist)}</em>
                      <em>users {formatNum(heist.total_submissions)}</em>
                      <em>demo {formatNum(heist.total_demo_submissions)}</em>
                      <em>{formatTimerWindow(heist)}</em>
                    </span>
                  </button>
                ))
              ) : (
                <div className={styles.emptyState}>No active heists.</div>
              )}
            </div>
            {renderPagination({
              page: activePage,
              pageCount: activePageCount,
              total: activeHeists.length,
              onPageChange: setActivePage,
            })}
          </section>
        </section>

        <section className={styles.detailPanel}>
          <div className={styles.panelHead}>
            <div>
              <p className={styles.kicker}>Automation</p>
              <h2>Auto make heist</h2>
            </div>
            <label className={styles.switchField}>
              <input
                type="checkbox"
                name="is_enabled"
                checked={autoHeistForm.is_enabled}
                onChange={updateAutoHeistForm}
              />
              <span>{autoHeistForm.is_enabled ? "On" : "Off"}</span>
            </label>
          </div>

          <form className={styles.autoHeistForm} onSubmit={saveAutoHeistSettings}>
            <label className={styles.field}>
              <span>Min users</span>
              <input type="number" name="min_users" min="1" value={autoHeistForm.min_users} onChange={updateAutoHeistForm} />
            </label>
            <label className={styles.field}>
              <span>Max users</span>
              <input type="number" name="max_users" min="0" value={autoHeistForm.max_users} onChange={updateAutoHeistForm} placeholder="Blank for unlimited" />
            </label>
            <label className={styles.field}>
              <span>Ticket CP</span>
              <input type="number" name="ticket_price" min="0" value={autoHeistForm.ticket_price} onChange={updateAutoHeistForm} />
            </label>
            <label className={styles.field}>
              <span>Prize CP</span>
              <input type="number" name="prize_cop_points" min="0" value={autoHeistForm.prize_cop_points} onChange={updateAutoHeistForm} />
            </label>
            <label className={styles.field}>
              <span>Questions per session</span>
              <input type="number" name="questions_per_session" min="0" value={autoHeistForm.questions_per_session} onChange={updateAutoHeistForm} />
            </label>
            <label className={styles.field}>
              <span>Countdown minutes</span>
              <input type="number" name="countdown_duration_minutes" min="1" value={autoHeistForm.countdown_duration_minutes} onChange={updateAutoHeistForm} />
            </label>
            <div className={styles.autoHeistActions}>
              <button type="submit" className={styles.primaryBtn} disabled={busy}>
                <FaSave />
                <span>{busy ? "Saving..." : "Save auto heist"}</span>
              </button>
              <button type="button" className={styles.softBtn} onClick={runAutoHeistNow} disabled={busy}>
                Make one now
              </button>
            </div>
          </form>
        </section>

        {activeDetailHeist ? (
          <section className={styles.detailGrid}>
            <article className={styles.detailPanel}>
              <div className={styles.panelHead}>
                <div>
                  <p className={styles.kicker}>Selected</p>
                  <h2>{activeDetailHeist.name}</h2>
                </div>
                <div className={styles.inlineActions}>
                  <button type="button" className={styles.softBtn} onClick={openEditModal} disabled={busy}>
                    <FaEdit />
                    <span>Edit</span>
                  </button>
                  <FaTrophy />
                </div>
              </div>

              {activeDetailHeist.description ? (
                <p className={styles.detailCopy}>{activeDetailHeist.description}</p>
              ) : null}

              <div className={styles.metaGrid}>
                <div><span>Status</span><strong>{activeDetailHeist.status}</strong></div>
                <div><span>Prize</span><strong>{formatNum(activeDetailHeist.prize_cop_points)} CP</strong></div>
                <div><span>Ticket</span><strong>{formatNum(activeDetailHeist.ticket_price)} CP</strong></div>
                <div><span>Min users</span><strong>{formatNum(activeDetailHeist.min_users)}</strong></div>
                <div><span>Max users</span><strong>{activeDetailHeist.max_users ? formatNum(activeDetailHeist.max_users) : "Unlimited"}</strong></div>
                <div><span>Participants</span><strong>{formatNum(activeDetailHeist.total_participants)}</strong></div>
                <div><span>Demo users</span><strong>{formatNum(activeDetailHeist.total_demo_submissions)}</strong></div>
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

            {renderDemoPlayersPanel()}

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
          </>
        ) : null}

        {isArchivePage ? (
          <>
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
                    pagedCompletedHeists.map((heist) => (
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
                          <em>{formatCapacity(heist)}</em>
                          <em>users {formatNum(heist.total_submissions)}</em>
                          <em>demo {formatNum(heist.total_demo_submissions)}</em>
                          <em>{formatTimerWindow(heist)}</em>
                        </span>
                      </button>
                    ))
                  ) : (
                    <div className={styles.emptyState}>No completed heists yet.</div>
                  )}
                </div>
                {renderPagination({
                  page: completedPage,
                  pageCount: completedPageCount,
                  total: completedHeists.length,
                  onPageChange: setCompletedPage,
                })}
              </section>
            </section>
            {activeDetailHeist?.status === "completed" ? (
              <section className={styles.detailGrid}>
                {renderDemoPlayersPanel()}
              </section>
            ) : completedHeists.length ? (
              <section className={styles.detailPanel}>
                <div className={styles.emptyState}>Select a completed heist to add demo leaderboard players.</div>
              </section>
            ) : null}
          </>
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
              <span>Use saved name and description</span>
              <select
                defaultValue=""
                onChange={(event) => {
                  applyContentTemplate("create", event.target.value);
                  event.target.value = "";
                }}
              >
                <option value="">Select from content bank</option>
                {contentBank
                  .filter((item) => item.is_active)
                  .map((item) => (
                    <option key={item.id} value={item.id}>
                      {item.name}
                    </option>
                  ))}
              </select>
            </label>

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
                <span>Max users</span>
                <input
                  type="number"
                  name="max_users"
                  min="0"
                  value={createForm.max_users}
                  onChange={updateCreateForm}
                  placeholder="0 or blank for unlimited"
                />
              </label>
            </div>

            <div className={styles.twoCol}>
              <label className={styles.field}>
                <span>Ticket CP</span>
                <input type="number" name="ticket_price" min="0" value={createForm.ticket_price} onChange={updateCreateForm} />
              </label>
              <label className={styles.field}>
                <span>Prize CP</span>
                <input type="number" name="prize_cop_points" min="0" value={createForm.prize_cop_points} onChange={updateCreateForm} />
              </label>
            </div>

            <div className={styles.twoCol}>
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
          open={editModalOpen}
          title="Update heist"
          subtitle={activeDetailHeist ? `Edit ${activeDetailHeist.name}.` : "Select a heist first."}
          size="lg"
          onClose={() => !busy && setEditModalOpen(false)}
          disableClose={busy}
          footer={
            <>
              <button type="button" className={styles.softBtn} onClick={() => setEditModalOpen(false)} disabled={busy}>
                Cancel
              </button>
              <button type="submit" form="edit-heist-form" className={styles.primaryBtn} disabled={busy || !activeDetailHeist}>
                <FaSave />
                <span>{busy ? "Saving..." : "Update heist"}</span>
              </button>
            </>
          }
        >
          <form id="edit-heist-form" className={`${styles.form} ${styles.modalForm}`} onSubmit={updateHeist}>
            <label className={styles.field}>
              <span>Use saved name and description</span>
              <select
                defaultValue=""
                onChange={(event) => {
                  applyContentTemplate("edit", event.target.value);
                  event.target.value = "";
                }}
              >
                <option value="">Select from content bank</option>
                {contentBank
                  .filter((item) => item.is_active)
                  .map((item) => (
                    <option key={item.id} value={item.id}>
                      {item.name}
                    </option>
                  ))}
              </select>
            </label>

            <label className={styles.field}>
              <span>Name</span>
              <input name="name" value={editForm.name} onChange={updateEditForm} placeholder="Weekend Heist" />
            </label>

            <label className={styles.field}>
              <span>Description</span>
              <textarea
                name="description"
                value={editForm.description}
                onChange={updateEditForm}
                placeholder="Fast true/false run for CopUpCoin rewards."
              />
            </label>

            <div className={styles.twoCol}>
              <label className={styles.field}>
                <span>Min users</span>
                <input type="number" name="min_users" min="1" value={editForm.min_users} onChange={updateEditForm} />
              </label>
              <label className={styles.field}>
                <span>Max users</span>
                <input
                  type="number"
                  name="max_users"
                  min="0"
                  value={editForm.max_users}
                  onChange={updateEditForm}
                  placeholder="0 or blank for unlimited"
                />
              </label>
            </div>

            <div className={styles.twoCol}>
              <label className={styles.field}>
                <span>Ticket CP</span>
                <input type="number" name="ticket_price" min="0" value={editForm.ticket_price} onChange={updateEditForm} />
              </label>
              <label className={styles.field}>
                <span>Prize CP</span>
                <input type="number" name="prize_cop_points" min="0" value={editForm.prize_cop_points} onChange={updateEditForm} />
              </label>
            </div>

            <div className={styles.twoCol}>
              <label className={styles.field}>
                <span>Questions per session</span>
                <input
                  type="number"
                  name="questions_per_session"
                  min="0"
                  value={editForm.questions_per_session}
                  onChange={updateEditForm}
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
                  value={editForm.countdown_duration_minutes}
                  onChange={updateEditForm}
                />
              </label>
            </div>

            <div className={styles.twoCol}>
              <label className={styles.field}>
                <span>Starts at</span>
                <input type="datetime-local" name="starts_at" value={editForm.starts_at} onChange={updateEditForm} />
              </label>
              <label className={styles.field}>
                <span>Ends at</span>
                <input type="datetime-local" name="ends_at" value={editForm.ends_at} onChange={updateEditForm} />
              </label>
            </div>
          </form>
        </Modal>

        <Modal
          open={contentModalOpen}
          title="Add heist content"
          subtitle="Save reusable heist names and descriptions for future heists."
          size="md"
          onClose={() => !busy && setContentModalOpen(false)}
          disableClose={busy}
          footer={
            <>
              <button type="button" className={styles.softBtn} onClick={() => setContentModalOpen(false)} disabled={busy}>
                Cancel
              </button>
              <button type="submit" form="add-content-form" className={styles.primaryBtn} disabled={busy}>
                Save content
              </button>
            </>
          }
        >
          <form id="add-content-form" className={`${styles.form} ${styles.modalForm}`} onSubmit={createContent}>
            <label className={styles.field}>
              <span>Name</span>
              <input
                name="name"
                value={contentForm.name}
                onChange={updateContentForm}
                placeholder="Weekend Heist"
              />
            </label>
            <label className={styles.field}>
              <span>Description</span>
              <textarea
                name="description"
                value={contentForm.description}
                onChange={updateContentForm}
                placeholder="Fast true/false run for CopUpCoin rewards."
              />
            </label>
            <label className={styles.checkField}>
              <input
                type="checkbox"
                name="is_active"
                checked={contentForm.is_active}
                onChange={updateContentForm}
              />
              <span>Active</span>
            </label>
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
