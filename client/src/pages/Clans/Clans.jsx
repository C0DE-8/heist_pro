import React, { useCallback, useEffect, useMemo, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { FiRefreshCw, FiSearch, FiShield, FiUsers } from "react-icons/fi";
import Header from "../../components/Header/Header";
import Footer from "../../components/Footer/Footer";
import { useToast } from "../../components/Toast/ToastContext";
import { imgUrl } from "../../lib/api";
import {
  createClan,
  decideClanRequest,
  getClan,
  getClanRequests,
  getClans,
  joinClan,
  leaveClan,
  removeClanMember,
  updateClan,
  updateClanMemberRole,
  uploadClanImages,
} from "../../lib/clans";
import styles from "./Clans.module.css";

function formatNum(value) {
  const n = Number(value);
  return Number.isFinite(n) ? n.toLocaleString() : "0";
}

function formatDate(value) {
  if (!value) return "Not set";
  const date = new Date(value);
  return Number.isNaN(date.getTime()) ? "Not set" : date.toLocaleString();
}

function firstLetter(value) {
  return String(value || "C").trim().slice(0, 1).toUpperCase();
}

function clanImageSrc(value) {
  const text = String(value || "");
  if (/^(blob:|data:|https?:\/\/)/i.test(text)) return text;
  return imgUrl(text);
}

function ClanSkeleton() {
  return (
    <article className={styles.skeletonCard}>
      <div className={styles.skeletonGlow} />
      <span className={styles.skeletonBanner} />
      <span className={styles.skeletonLogo} />
      <span className={styles.skeletonLine} />
      <span className={styles.skeletonLineShort} />
      <span className={styles.skeletonPill} />
    </article>
  );
}

const emptyForm = {
  name: "",
  description: "",
  logo_url: "",
  banner_url: "",
  join_policy: "request",
};

export default function Clans() {
  const { clanId } = useParams();
  const navigate = useNavigate();
  const toast = useToast();
  const [clans, setClans] = useState([]);
  const [detail, setDetail] = useState(null);
  const [requests, setRequests] = useState([]);
  const [q, setQ] = useState("");
  const [form, setForm] = useState(emptyForm);
  const [editForm, setEditForm] = useState(emptyForm);
  const [createPreview, setCreatePreview] = useState({ logo_url: "", banner_url: "" });
  const [editPreview, setEditPreview] = useState({ logo_url: "", banner_url: "" });
  const [showCreate, setShowCreate] = useState(false);
  const [editing, setEditing] = useState(false);
  const [loading, setLoading] = useState(true);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState("");

  const selectedClanId = Number(clanId || detail?.clan?.id || 0);
  const clan = detail?.clan || null;
  const members = Array.isArray(detail?.members) ? detail.members : [];
  const myMembership = detail?.my_membership || null;
  const isMember = myMembership?.status === "active";
  const isLeader = myMembership?.role === "leader";
  const canManage = ["leader", "co_leader"].includes(myMembership?.role);

  const filteredClans = useMemo(() => clans, [clans]);

  const loadClans = useCallback(async () => {
    const data = await getClans(q ? { q } : {});
    setClans(data.clans || []);
  }, [q]);

  const loadDetail = useCallback(async () => {
    if (!clanId) {
      setDetail(null);
      return;
    }
    const data = await getClan(clanId);
    setDetail(data);
    setEditForm({
      name: data.clan?.name || "",
      description: data.clan?.description || "",
      logo_url: data.clan?.logo_url || "",
      banner_url: data.clan?.banner_url || "",
      join_policy: data.clan?.join_policy || "request",
    });
    setEditPreview({
      logo_url: data.clan?.logo_url || "",
      banner_url: data.clan?.banner_url || "",
    });
    if (["leader", "co_leader"].includes(data.my_membership?.role)) {
      const requestData = await getClanRequests(clanId);
      setRequests(requestData.requests || []);
    } else {
      setRequests([]);
    }
  }, [clanId]);

  const loadPage = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      await Promise.all([loadClans(), loadDetail()]);
    } catch (err) {
      console.error("Clan page load error:", err);
      setError(err?.response?.data?.message || "Unable to load clans.");
    } finally {
      setLoading(false);
    }
  }, [loadClans, loadDetail]);

  useEffect(() => {
    loadPage();
  }, [loadPage]);

  const submitCreate = async (event) => {
    event.preventDefault();
    setBusy(true);
    try {
      const data = await createClan(form);
      toast.success("Clan created.");
      setForm(emptyForm);
      setCreatePreview({ logo_url: "", banner_url: "" });
      setShowCreate(false);
      await loadClans();
      navigate(`/clans/${data.clan.id}`);
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to create clan.");
    } finally {
      setBusy(false);
    }
  };

  const submitEdit = async (event) => {
    event.preventDefault();
    setBusy(true);
    try {
      await updateClan(selectedClanId, editForm);
      toast.success("Clan updated.");
      setEditing(false);
      await loadPage();
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to update clan.");
    } finally {
      setBusy(false);
    }
  };

  const doJoin = async () => {
    setBusy(true);
    try {
      const result = await joinClan(selectedClanId);
      toast.success(result.message || "Clan request sent.");
      await loadPage();
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to join clan.");
    } finally {
      setBusy(false);
    }
  };

  const doLeave = async () => {
    setBusy(true);
    try {
      await leaveClan(selectedClanId);
      toast.success("Left clan.");
      await loadPage();
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to leave clan.");
    } finally {
      setBusy(false);
    }
  };

  const decideRequest = async (requestId, decision) => {
    setBusy(true);
    try {
      await decideClanRequest(selectedClanId, requestId, decision);
      toast.success(decision === "approve" ? "Request approved." : "Request rejected.");
      await loadDetail();
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to update request.");
    } finally {
      setBusy(false);
    }
  };

  const setRole = async (memberId, role) => {
    setBusy(true);
    try {
      await updateClanMemberRole(selectedClanId, memberId, role);
      toast.success("Role updated.");
      await loadDetail();
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to update role.");
    } finally {
      setBusy(false);
    }
  };

  const kickMember = async (memberId) => {
    setBusy(true);
    try {
      await removeClanMember(selectedClanId, memberId);
      toast.success("Member removed.");
      await loadDetail();
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to remove member.");
    } finally {
      setBusy(false);
    }
  };

  const updateForm = (setter, field) => (event) => {
    setter((prev) => ({ ...prev, [field]: event.target.value }));
  };

  const uploadImage = async ({ file, type, setter, previewSetter, clanName }) => {
    if (!file) return;
    const previewUrl = URL.createObjectURL(file);
    const field = type === "logo" ? "logo_url" : "banner_url";
    previewSetter((prev) => ({ ...prev, [field]: previewUrl }));
    setBusy(true);
    try {
      const result = await uploadClanImages({ [type]: file }, { clanName });
      const uploadedPath = result?.[field];
      if (!uploadedPath) throw new Error("Upload did not return an image path");
      setter((prev) => ({ ...prev, [field]: uploadedPath }));
      previewSetter((prev) => ({ ...prev, [field]: uploadedPath }));
      toast.success(type === "logo" ? "Logo uploaded." : "Banner uploaded.");
    } catch (err) {
      toast.error(err?.response?.data?.message || "Unable to upload image.");
      previewSetter((prev) => ({ ...prev, [field]: "" }));
    } finally {
      setBusy(false);
    }
  };

  const ImagePicker = ({ label, type, value, onChange }) => (
    <label className={styles.imagePicker}>
      <span className={styles.pickerTop}>
        <span>{label}</span>
        <span className={styles.chooseFile}>Choose image</span>
      </span>
      <input
        type="file"
        accept="image/png,image/jpeg,image/jpg,image/webp,image/gif"
        onChange={(event) => onChange(event.target.files?.[0] || null)}
      />
      <div className={`${styles.previewBox} ${type === "banner" ? styles.bannerPreview : ""}`}>
        {value ? <img src={clanImageSrc(value)} alt={`${label} preview`} /> : <strong>{type === "logo" ? "Logo" : "Banner"}</strong>}
      </div>
      <small>Saved with the clan name and a unique suffix.</small>
    </label>
  );

  return (
    <div className={styles.page}>
      <Header />
      <main className={styles.main}>
        <section className={styles.top}>
          <div>
            <p className={styles.eyebrow}>Clan System</p>
            <h1 className={styles.title}>Build a crew. Win quests together.</h1>
            <p className={styles.subtitle}>
              Create or join a clan, compete in heist quests, and share clan rewards equally with active members.
            </p>
          </div>
          <button type="button" className={styles.primaryBtn} onClick={() => setShowCreate((v) => !v)}>
            <FiShield /> {showCreate ? "Close" : "Create Clan"}
          </button>
        </section>

        {error ? <div className={styles.error}>{error}</div> : null}
        {showCreate ? (
          <section className={styles.panel}>
            <h2 className={styles.sectionTitle}>Create clan</h2>
            <form className={styles.form} onSubmit={submitCreate}>
              <label>
                Name
                <input value={form.name} onChange={updateForm(setForm, "name")} placeholder="Night Raiders" required />
              </label>
              <label>
                Description
                <textarea value={form.description} onChange={updateForm(setForm, "description")} placeholder="What makes this clan different?" />
              </label>
              <label>
                Join policy
                <select value={form.join_policy} onChange={updateForm(setForm, "join_policy")}>
                  <option value="request">Request to join</option>
                  <option value="open">Open</option>
                  <option value="invite_only">Invite only</option>
                  <option value="closed">Closed</option>
                </select>
              </label>
              <div className={styles.imageGrid}>
                <ImagePicker
                  label="Logo"
                  type="logo"
                  value={createPreview.logo_url || form.logo_url}
                  onChange={(file) => uploadImage({ file, type: "logo", setter: setForm, previewSetter: setCreatePreview, clanName: form.name })}
                />
                <ImagePicker
                  label="Banner"
                  type="banner"
                  value={createPreview.banner_url || form.banner_url}
                  onChange={(file) => uploadImage({ file, type: "banner", setter: setForm, previewSetter: setCreatePreview, clanName: form.name })}
                />
              </div>
              <button type="submit" className={styles.primaryBtn} disabled={busy}>Create clan</button>
            </form>
          </section>
        ) : null}

        <section className={styles.grid}>
          <div className={styles.panel}>
            <div className={styles.toolbar}>
              <input className={styles.search} value={q} onChange={(e) => setQ(e.target.value)} placeholder="Search clans" />
              <button type="button" className={styles.iconBtn} onClick={loadPage} title="Refresh">
                <FiRefreshCw />
              </button>
            </div>
            <div className={styles.list}>
              {loading ? (
                [0, 1, 2].map((item) => <ClanSkeleton key={item} />)
              ) : filteredClans.length ? filteredClans.map((item) => (
                <article className={styles.card} key={item.id}>
                  <div className={styles.banner}>
                    {item.banner_url ? <img className={styles.bannerImg} src={clanImageSrc(item.banner_url)} alt="" /> : null}
                  </div>
                  <button type="button" className={styles.clanButton} onClick={() => navigate(`/clans/${item.id}`)}>
                    <div className={styles.clanHead}>
                      <div className={styles.logo}>
                        {item.logo_url ? <img src={clanImageSrc(item.logo_url)} alt="" /> : firstLetter(item.name)}
                      </div>
                      <div>
                        <h3 className={styles.name}>{item.name}</h3>
                        <p className={styles.meta}>{formatNum(item.member_count)} members • {item.join_policy}</p>
                      </div>
                    </div>
                    <p className={styles.desc}>{item.description || "No description yet."}</p>
                    <div className={styles.chips}>
                      <span className={styles.chip}>Leader: {item.leader_full_name || item.leader_username}</span>
                      <span className={styles.chip}>{item.status}</span>
                    </div>
                  </button>
                </article>
              )) : <p className={styles.empty}>No clans found.</p>}
            </div>
          </div>

          <div className={styles.stack}>
            {clan ? (
              <section className={styles.detailPanel}>
                <div className={styles.detailTop}>
                  <div>
                    <h2 className={styles.sectionTitle}>{clan.name}</h2>
                    <p className={styles.meta}>{formatNum(clan.member_count)} members • Leader: {clan.leader_name}</p>
                  </div>
                  <div className={styles.logo}>
                    {clan.logo_url ? <img src={clanImageSrc(clan.logo_url)} alt="" /> : firstLetter(clan.name)}
                  </div>
                </div>
                <p className={styles.desc}>{clan.description || "No description yet."}</p>
                <div className={styles.actions}>
                  {!isMember ? (
                    <button type="button" className={styles.primaryBtn} onClick={doJoin} disabled={busy}>
                      {clan.join_policy === "open" ? "Join Clan" : "Request Join"}
                    </button>
                  ) : myMembership?.role !== "leader" ? (
                    <button type="button" className={styles.dangerBtn} onClick={doLeave} disabled={busy}>Leave Clan</button>
                  ) : null}
                  {canManage ? (
                    <button type="button" className={styles.secondaryBtn} onClick={() => setEditing((v) => !v)}>
                      Edit Clan
                    </button>
                  ) : null}
                </div>
              </section>
            ) : (
              <section className={styles.detailPanel}>
                <p className={styles.empty}><FiSearch /> Select a clan to view details.</p>
              </section>
            )}

            {editing && clan ? (
              <section className={styles.detailPanel}>
                <h3 className={styles.sectionTitle}>Edit clan</h3>
                <form className={styles.form} onSubmit={submitEdit}>
                  <label>Name<input value={editForm.name} onChange={updateForm(setEditForm, "name")} /></label>
                  <label>Description<textarea value={editForm.description} onChange={updateForm(setEditForm, "description")} /></label>
                  <label>Join policy
                    <select value={editForm.join_policy} onChange={updateForm(setEditForm, "join_policy")}>
                      <option value="request">Request</option>
                      <option value="open">Open</option>
                      <option value="invite_only">Invite only</option>
                      <option value="closed">Closed</option>
                    </select>
                  </label>
                  <div className={styles.imageGrid}>
                    <ImagePicker
                      label="Logo"
                      type="logo"
                      value={editPreview.logo_url || editForm.logo_url}
                      onChange={(file) => uploadImage({ file, type: "logo", setter: setEditForm, previewSetter: setEditPreview, clanName: editForm.name || clan?.name })}
                    />
                    <ImagePicker
                      label="Banner"
                      type="banner"
                      value={editPreview.banner_url || editForm.banner_url}
                      onChange={(file) => uploadImage({ file, type: "banner", setter: setEditForm, previewSetter: setEditPreview, clanName: editForm.name || clan?.name })}
                    />
                  </div>
                  <button className={styles.primaryBtn} disabled={busy}>Save</button>
                </form>
              </section>
            ) : null}

            {canManage && requests.length ? (
              <section className={styles.detailPanel}>
                <h3 className={styles.sectionTitle}>Join requests</h3>
                <div className={styles.stack}>
                  {requests.map((request) => (
                    <div className={styles.quest} key={request.id}>
                      <strong>{request.display_name}</strong>
                      <p className={styles.meta}>{request.message || "No message"}</p>
                      <div className={styles.actions}>
                        <button className={styles.secondaryBtn} onClick={() => decideRequest(request.id, "approve")} disabled={busy}>Approve</button>
                        <button className={styles.dangerBtn} onClick={() => decideRequest(request.id, "reject")} disabled={busy}>Reject</button>
                      </div>
                    </div>
                  ))}
                </div>
              </section>
            ) : null}

            {clan ? (
              <section className={styles.detailPanel}>
                <h3 className={styles.sectionTitle}><FiUsers /> Members</h3>
                <table className={styles.table}>
                  <thead><tr><th>Name</th><th>Role</th><th>Joined</th><th /></tr></thead>
                  <tbody>
                    {members.filter((m) => m.status === "active").map((member) => (
                      <tr key={member.id}>
                        <td>{member.display_name}</td>
                        <td>{member.role}</td>
                        <td>{formatDate(member.joined_at)}</td>
                        <td>
                          {isLeader && member.role !== "leader" ? (
                            <div className={styles.actions}>
                              <select value={member.role} onChange={(e) => setRole(member.id, e.target.value)} disabled={busy}>
                                <option value="member">Member</option>
                                <option value="elder">Elder</option>
                                <option value="co_leader">Co-Leader</option>
                              </select>
                              <button type="button" className={styles.dangerBtn} onClick={() => kickMember(member.id)} disabled={busy}>Remove</button>
                            </div>
                          ) : null}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </section>
            ) : null}

            {clan ? (
              <section className={styles.detailPanel}>
                <h3 className={styles.sectionTitle}>Clan quests</h3>
                <p className={styles.desc}>
                  Clan quests now have their own board with participating clans, live win counts, and standings.
                </p>
                <div className={styles.actions}>
                  <button type="button" className={styles.primaryBtn} onClick={() => navigate("/clan-quests")}>
                    Open quest board
                  </button>
                </div>
              </section>
            ) : null}
          </div>
        </section>
      </main>
      <Footer />
    </div>
  );
}
