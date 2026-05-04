import React, { useCallback, useEffect, useMemo, useState } from "react";
import {
  FaCheck,
  FaCoins,
  FaCopy,
  FaCreditCard,
  FaSave,
  FaTimes,
  FaWallet,
} from "react-icons/fa";
import AdminNavbar from "../../../components/admin/Navbar";
import AdminPageHeader from "../../../components/admin/AdminPageHeader";
import Modal from "../../../components/ui/Modal";
import { ToastProvider, useToast } from "../../../components/ui/Toaster";
import {
  getAdminPayins,
  getAdminPayouts,
  getTransactionSettings,
  reviewPayin,
  reviewPayout,
  updateCoinRate,
  updatePaymentInfo,
} from "../../../lib/adminTransactions";
import { imgUrl } from "../../../lib/api";
import styles from "./AdminTransactions.module.css";

const EMPTY_PAYMENT = {
  account_name: "",
  account_number: "",
  account_type: "bank_transfer",
  bank_name: "",
  instructions: "",
};

const EMPTY_RATE = {
  unit: "1",
  price: "100",
  currency: "NGN",
};

const STATUS_OPTIONS = ["all", "pending", "approved", "rejected"];

function formatNum(value) {
  const n = Number(value);
  return Number.isFinite(n) ? n.toLocaleString() : "0";
}

function formatMoney(value, currency = "NGN") {
  const n = Number(value);
  if (!Number.isFinite(n)) return `${currency} 0`;
  return `${currency} ${n.toLocaleString(undefined, { maximumFractionDigits: 2 })}`;
}

function formatDate(value) {
  if (!value) return "Not reviewed";
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "Not reviewed";
  return date.toLocaleString([], {
    month: "short",
    day: "numeric",
    hour: "numeric",
    minute: "2-digit",
  });
}

function statusClass(status) {
  const key = String(status || "pending").toLowerCase();
  if (key === "approved") return styles.approved;
  if (key === "rejected") return styles.rejected;
  return styles.pending;
}

function AdminTransactionsPage() {
  const toast = useToast();
  const [paymentForm, setPaymentForm] = useState(EMPTY_PAYMENT);
  const [rateForm, setRateForm] = useState(EMPTY_RATE);
  const [payins, setPayins] = useState([]);
  const [payouts, setPayouts] = useState([]);
  const [payinFilter, setPayinFilter] = useState("pending");
  const [payoutFilter, setPayoutFilter] = useState("pending");
  const [loading, setLoading] = useState(true);
  const [busy, setBusy] = useState(false);
  const [reviewingId, setReviewingId] = useState("");
  const [error, setError] = useState("");
  const [reasons, setReasons] = useState({});
  const [receiptPreview, setReceiptPreview] = useState(null);

  const activeRate = useMemo(
    () => ({
      unit: Number(rateForm.unit || 1),
      price: Number(rateForm.price || 0),
      currency: rateForm.currency || "NGN",
    }),
    [rateForm]
  );

  const stats = useMemo(
    () => ({
      pendingPayins: payins.filter((item) => item.status === "pending").length,
      pendingPayouts: payouts.filter((item) => item.status === "pending").length,
      payinCoins: payins
        .filter((item) => item.status === "approved")
        .reduce((sum, item) => sum + Number(item.coin_amount || 0), 0),
      payoutCoins: payouts
        .filter((item) => item.status === "approved")
        .reduce((sum, item) => sum + Number(item.cop_points || 0), 0),
    }),
    [payins, payouts]
  );

  const loadSettings = useCallback(async () => {
    const data = await getTransactionSettings();
    const payment = data?.payment_account;
    const rate = data?.coin_rate;

    if (payment) {
      setPaymentForm({
        account_name: payment.account_name || "",
        account_number: payment.account_number || "",
        account_type: payment.account_type || "bank_transfer",
        bank_name: payment.bank_name || "",
        instructions: payment.instructions || "",
      });
    }

    if (rate) {
      setRateForm({
        unit: String(rate.unit || 1),
        price: String(rate.price || 100),
        currency: rate.currency || "NGN",
      });
    }
  }, []);

  const loadPayins = useCallback(async () => {
    const data = await getAdminPayins(payinFilter === "all" ? "" : payinFilter);
    setPayins(Array.isArray(data?.payins) ? data.payins : []);
  }, [payinFilter]);

  const loadPayouts = useCallback(async () => {
    const data = await getAdminPayouts(payoutFilter === "all" ? "" : payoutFilter);
    setPayouts(Array.isArray(data?.payouts) ? data.payouts : []);
  }, [payoutFilter]);

  const loadAll = useCallback(async () => {
    setLoading(true);
    setError("");

    try {
      await Promise.all([loadSettings(), loadPayins(), loadPayouts()]);
    } catch (err) {
      console.error("Load transactions error:", err);
      setError(err?.response?.data?.message || "Unable to load transactions.");
    } finally {
      setLoading(false);
    }
  }, [loadPayins, loadPayouts, loadSettings]);

  useEffect(() => {
    loadAll();
  }, [loadAll]);

  const savePaymentInfo = async (event) => {
    event.preventDefault();
    if (busy) return;

    setBusy(true);
    try {
      await updatePaymentInfo(paymentForm);
      toast.success("Payment info saved");
      await loadSettings();
    } catch (err) {
      console.error("Save payment info error:", err);
      toast.error(err?.response?.data?.message || "Unable to save payment info.");
    } finally {
      setBusy(false);
    }
  };

  const saveCoinRate = async (event) => {
    event.preventDefault();
    if (busy) return;

    setBusy(true);
    try {
      await updateCoinRate({
        unit: Number(rateForm.unit),
        price: Number(rateForm.price),
        currency: rateForm.currency,
      });
      toast.success("Coin rate saved");
      await loadSettings();
    } catch (err) {
      console.error("Save coin rate error:", err);
      toast.error(err?.response?.data?.message || "Unable to save coin rate.");
    } finally {
      setBusy(false);
    }
  };

  const setReason = (type, id, value) => {
    setReasons((prev) => ({ ...prev, [`${type}:${id}`]: value }));
  };

  const getReason = (type, id) => reasons[`${type}:${id}`] || "";

  const handlePayinReview = async (item, status) => {
    if (reviewingId) return;
    const reason = getReason("payin", item.id);
    if (status === "rejected" && !reason.trim()) {
      toast.warn("Add a rejection reason first");
      return;
    }

    setReviewingId(`payin:${item.id}`);
    try {
      await reviewPayin(item.id, {
        status,
        reason,
        admin_note: status === "approved" ? "Payment confirmed" : "",
      });
      toast.success(status === "approved" ? "Pay-in approved" : "Pay-in rejected");
      await loadPayins();
    } catch (err) {
      console.error("Review payin error:", err);
      toast.error(err?.response?.data?.message || "Unable to review pay-in.");
    } finally {
      setReviewingId("");
    }
  };

  const handlePayoutReview = async (item, status) => {
    if (reviewingId) return;
    const reason = getReason("payout", item.id);
    if (status === "rejected" && !reason.trim()) {
      toast.warn("Add a rejection reason first");
      return;
    }

    setReviewingId(`payout:${item.id}`);
    try {
      await reviewPayout(item.id, {
        status,
        reason,
        admin_note: status === "approved" ? "Payout completed" : "",
      });
      toast.success(status === "approved" ? "Payout approved" : "Payout rejected");
      await loadPayouts();
    } catch (err) {
      console.error("Review payout error:", err);
      toast.error(err?.response?.data?.message || "Unable to review payout.");
    } finally {
      setReviewingId("");
    }
  };

  const copyPayoutNumber = async (accountNumber) => {
    if (!accountNumber) return;

    try {
      await navigator.clipboard.writeText(String(accountNumber));
      toast.success("Account number copied");
    } catch (err) {
      console.error("Copy payout number error:", err);
      toast.error("Unable to copy account number");
    }
  };

  return (
    <div className={styles.page}>
      <AdminNavbar />

      <main className={styles.main}>
        <AdminPageHeader
          kicker="Transactions"
          title="Pay-in and payout control"
          description="Manage manual bank payment details, coin rate, incoming pay-ins, and user withdrawal requests from one admin workspace."
          onRefresh={loadAll}
          refreshing={loading}
          error={error}
          onRetry={loadAll}
        />

        <section className={styles.statsGrid}>
          <div className={styles.statCard}>
            <span>Rate</span>
            <strong>
              {formatNum(activeRate.unit)} CP = {formatMoney(activeRate.price, activeRate.currency)}
            </strong>
            <small>Visible to users</small>
          </div>
          <div className={styles.statCard}>
            <span>Pending pay-ins</span>
            <strong>{loading ? "..." : formatNum(stats.pendingPayins)}</strong>
            <small>{formatNum(stats.payinCoins)} CP approved in this view</small>
          </div>
          <div className={styles.statCard}>
            <span>Pending payouts</span>
            <strong>{loading ? "..." : formatNum(stats.pendingPayouts)}</strong>
            <small>{formatNum(stats.payoutCoins)} CP paid in this view</small>
          </div>
        </section>

        <section className={styles.settingsGrid}>
          <form className={styles.panel} onSubmit={savePaymentInfo}>
            <div className={styles.panelHead}>
              <div>
                <p className={styles.kicker}>Pay-in Details</p>
                <h2>Account users will pay into</h2>
              </div>
              <FaCreditCard />
            </div>

            <div className={styles.formGrid}>
              <label>
                <span>Account name</span>
                <input
                  value={paymentForm.account_name}
                  onChange={(e) =>
                    setPaymentForm((prev) => ({ ...prev, account_name: e.target.value }))
                  }
                  placeholder="CopUp Limited"
                />
              </label>
              <label>
                <span>Account number</span>
                <input
                  value={paymentForm.account_number}
                  onChange={(e) =>
                    setPaymentForm((prev) => ({ ...prev, account_number: e.target.value }))
                  }
                  placeholder="0123456789"
                />
              </label>
              <label>
                <span>Account type</span>
                <input
                  value={paymentForm.account_type}
                  onChange={(e) =>
                    setPaymentForm((prev) => ({ ...prev, account_type: e.target.value }))
                  }
                  placeholder="bank_transfer"
                />
              </label>
              <label>
                <span>Bank name</span>
                <input
                  value={paymentForm.bank_name}
                  onChange={(e) =>
                    setPaymentForm((prev) => ({ ...prev, bank_name: e.target.value }))
                  }
                  placeholder="Access Bank"
                />
              </label>
              <label className={styles.fullField}>
                <span>Instructions</span>
                <textarea
                  value={paymentForm.instructions}
                  onChange={(e) =>
                    setPaymentForm((prev) => ({ ...prev, instructions: e.target.value }))
                  }
                  placeholder="Use your username as payment narration."
                />
              </label>
            </div>

            <button type="submit" className={styles.primaryBtn} disabled={busy}>
              <FaSave />
              <span>{busy ? "Saving..." : "Save payment info"}</span>
            </button>
          </form>

          <form className={styles.panel} onSubmit={saveCoinRate}>
            <div className={styles.panelHead}>
              <div>
                <p className={styles.kicker}>Coin Rate</p>
                <h2>Set CopUpCoin value</h2>
              </div>
              <FaCoins />
            </div>

            <div className={styles.ratePreview}>
              <span>{formatNum(activeRate.unit)} CP</span>
              <strong>=</strong>
              <span>{formatMoney(activeRate.price, activeRate.currency)}</span>
            </div>

            <div className={styles.formGrid}>
              <label>
                <span>Coin unit</span>
                <input
                  type="number"
                  min="1"
                  value={rateForm.unit}
                  onChange={(e) => setRateForm((prev) => ({ ...prev, unit: e.target.value }))}
                />
              </label>
              <label>
                <span>Price</span>
                <input
                  type="number"
                  min="1"
                  step="0.01"
                  value={rateForm.price}
                  onChange={(e) => setRateForm((prev) => ({ ...prev, price: e.target.value }))}
                />
              </label>
              <label>
                <span>Currency</span>
                <input
                  value={rateForm.currency}
                  onChange={(e) =>
                    setRateForm((prev) => ({ ...prev, currency: e.target.value.toUpperCase() }))
                  }
                />
              </label>
            </div>

            <button type="submit" className={styles.primaryBtn} disabled={busy}>
              <FaSave />
              <span>{busy ? "Saving..." : "Save coin rate"}</span>
            </button>
          </form>
        </section>

        <section className={styles.transactionGrid}>
          <TransactionPanel
            title="Pay-in Requests"
            kicker="Incoming"
            icon={<FaWallet />}
            filter={payinFilter}
            onFilter={setPayinFilter}
            loading={loading}
            emptyText="No pay-in requests found."
          >
            {payins.map((item) => (
              <article key={item.id} className={styles.requestCard}>
                <div className={styles.requestTop}>
                  <span className={`${styles.statusBadge} ${statusClass(item.status)}`}>
                    {item.status}
                  </span>
                  <strong>{formatMoney(item.amount_ngn)}</strong>
                </div>
                <h3>{item.username || item.email || `User #${item.user_id}`}</h3>
                <p>{formatNum(item.coin_amount)} CP credit request</p>
                <dl className={styles.metaList}>
                  <div>
                    <dt>Reference</dt>
                    <dd>{item.proof_reference || "Not provided"}</dd>
                  </div>
                  <div>
                    <dt>Created</dt>
                    <dd>{formatDate(item.created_at)}</dd>
                  </div>
                </dl>
                {item.proof_url ? (
                  <button
                    type="button"
                    className={styles.receiptPreview}
                    onClick={() =>
                      setReceiptPreview({
                        url: imgUrl(item.proof_url),
                        title: item.username || item.email || `User #${item.user_id}`,
                      })
                    }
                  >
                    <img src={imgUrl(item.proof_url)} alt="Payment receipt" />
                    <span>Open receipt</span>
                  </button>
                ) : null}
                {item.status === "pending" ? (
                  <ReviewControls
                    type="payin"
                    item={item}
                    reason={getReason("payin", item.id)}
                    onReason={setReason}
                    onApprove={() => handlePayinReview(item, "approved")}
                    onReject={() => handlePayinReview(item, "rejected")}
                    busy={reviewingId === `payin:${item.id}`}
                  />
                ) : (
                  <ReviewedNote item={item} />
                )}
              </article>
            ))}
          </TransactionPanel>

          <TransactionPanel
            title="Payout Requests"
            kicker="Outgoing"
            icon={<FaWallet />}
            filter={payoutFilter}
            onFilter={setPayoutFilter}
            loading={loading}
            emptyText="No payout requests found."
          >
            {payouts.map((item) => (
              <article key={item.id} className={styles.requestCard}>
                <div className={styles.requestTop}>
                  <span className={`${styles.statusBadge} ${statusClass(item.status)}`}>
                    {item.status}
                  </span>
                  <strong>{formatNum(item.cop_points)} CP</strong>
                </div>
                <h3>{item.username || item.email || `User #${item.user_id}`}</h3>
                <p>{formatMoney(item.amount_ngn)} payout after 10% fee</p>
                <dl className={styles.metaList}>
                  <div>
                    <dt>Account</dt>
                    <dd>{item.account_name}</dd>
                  </div>
                  <div>
                    <dt>Number</dt>
                    <dd className={styles.copyValue}>
                      <span>{item.account_number}</span>
                      <button
                        type="button"
                        onClick={() => copyPayoutNumber(item.account_number)}
                        title="Copy account number"
                        aria-label="Copy account number"
                      >
                        <FaCopy />
                      </button>
                    </dd>
                  </div>
                  <div>
                    <dt>Type</dt>
                    <dd>{item.account_type}</dd>
                  </div>
                  <div>
                    <dt>Bank</dt>
                    <dd>{item.bank_name || "Not set"}</dd>
                  </div>
                </dl>
                {item.status === "pending" ? (
                  <ReviewControls
                    type="payout"
                    item={item}
                    reason={getReason("payout", item.id)}
                    onReason={setReason}
                    onApprove={() => handlePayoutReview(item, "approved")}
                    onReject={() => handlePayoutReview(item, "rejected")}
                    busy={reviewingId === `payout:${item.id}`}
                  />
                ) : (
                  <ReviewedNote item={item} />
                )}
              </article>
            ))}
          </TransactionPanel>
        </section>
      </main>

      <Modal
        open={Boolean(receiptPreview)}
        title="Payment receipt"
        subtitle={receiptPreview?.title || "Uploaded proof"}
        size="xl"
        onClose={() => setReceiptPreview(null)}
      >
        {receiptPreview?.url ? (
          <div className={styles.receiptModalBody}>
            <img src={receiptPreview.url} alt="Payment receipt preview" />
          </div>
        ) : null}
      </Modal>
    </div>
  );
}

function TransactionPanel({
  title,
  kicker,
  icon,
  filter,
  onFilter,
  loading,
  emptyText,
  children,
}) {
  const hasRows = React.Children.count(children) > 0;

  return (
    <section className={styles.panel}>
      <div className={styles.panelHead}>
        <div>
          <p className={styles.kicker}>{kicker}</p>
          <h2>{title}</h2>
        </div>
        {icon}
      </div>

      <div className={styles.filters}>
        {STATUS_OPTIONS.map((status) => (
          <button
            key={status}
            type="button"
            className={filter === status ? styles.activeFilter : ""}
            onClick={() => onFilter(status)}
          >
            {status}
          </button>
        ))}
      </div>

      <div className={styles.requestList}>
        {loading ? <div className={styles.emptyState}>Loading requests...</div> : null}
        {!loading && hasRows ? children : null}
        {!loading && !hasRows ? <div className={styles.emptyState}>{emptyText}</div> : null}
      </div>
    </section>
  );
}

function ReviewControls({ type, item, reason, onReason, onApprove, onReject, busy }) {
  return (
    <div className={styles.reviewBox}>
      <textarea
        value={reason}
        onChange={(e) => onReason(type, item.id, e.target.value)}
        placeholder="Reason is required when rejecting."
      />
      <div className={styles.reviewActions}>
        <button type="button" className={styles.approveBtn} onClick={onApprove} disabled={busy}>
          <FaCheck />
          <span>{busy ? "Working..." : "Approve"}</span>
        </button>
        <button type="button" className={styles.rejectBtn} onClick={onReject} disabled={busy}>
          <FaTimes />
          <span>Reject</span>
        </button>
      </div>
    </div>
  );
}

function ReviewedNote({ item }) {
  return (
    <div className={styles.reviewedNote}>
      <span>Reviewed {formatDate(item.reviewed_at)}</span>
      {item.rejection_reason ? <strong>{item.rejection_reason}</strong> : null}
      {item.admin_note ? <em>{item.admin_note}</em> : null}
    </div>
  );
}

export default function AdminTransactions() {
  return (
    <ToastProvider>
      <AdminTransactionsPage />
    </ToastProvider>
  );
}
