import React, { useCallback, useEffect, useState } from "react";
import { FiMapPin, FiTrash2 } from "react-icons/fi";
import { useNavigate } from "react-router-dom";
import Header from "../../components/Header/Header";
import Footer from "../../components/Footer/Footer";
import SkeletonGrid from "../../components/SkeletonGrid/SkeletonGrid";
import CustomSelect from "../../components/CustomSelect/CustomSelect";
import { checkout, deleteAddress, getCart, getSavedAddresses } from "../../lib/commerce";
import { getUserProfile } from "../../lib/users";
import { NIGERIA_STATES } from "../../lib/nigeriaStates";
import styles from "./Commerce.module.css";

const emptyAddress = { phone_number: "", detailed_address: "", state: "", latitude: "", longitude: "", location_accuracy: "", location_captured_at: "" };
export default function Checkout() {
  const navigate = useNavigate(); const [items, setItems] = useState([]); const [addresses, setAddresses] = useState([]); const [selected, setSelected] = useState(""); const [form, setForm] = useState(emptyAddress); const [name, setName] = useState(""); const [save, setSave] = useState(false); const [loading, setLoading] = useState(true); const [locating, setLocating] = useState(false); const [busy, setBusy] = useState(false); const [error, setError] = useState("");
  const load = useCallback(async () => { setLoading(true); try { const [cartData, addressData, profile] = await Promise.all([getCart(), getSavedAddresses(), getUserProfile()]); setItems(cartData.items || []); setAddresses(addressData.addresses || []); setName(profile?.user?.full_name || profile?.user?.username || ""); } catch (err) { setError(err?.response?.data?.message || "Unable to load checkout."); } finally { setLoading(false); } }, []);
  useEffect(() => { load(); }, [load]);
  const locate = () => {
    if (!window.isSecureContext) { setError("Location access requires HTTPS or localhost."); return; }
    if (!navigator.geolocation) { setError("Location is not supported by this device."); return; }
    setLocating(true); setError("");
    navigator.geolocation.getCurrentPosition((position) => { setForm((prev) => ({ ...prev, latitude: position.coords.latitude, longitude: position.coords.longitude, location_accuracy: position.coords.accuracy, location_captured_at: new Date(position.timestamp).toISOString() })); setLocating(false); }, (err) => { const messages = { 1: "Location permission was denied. Allow location access and try again.", 2: "Your current location is unavailable. Try again outdoors or with location services enabled.", 3: "Location request timed out. Please try again." }; setError(messages[err.code] || "Unable to capture location."); setLocating(false); }, { enableHighAccuracy: true, timeout: 15000, maximumAge: 0 });
  };
  const removeAddress = async (id) => { if (!window.confirm("Delete this saved address?")) return; try { await deleteAddress(id); if (String(selected) === String(id)) setSelected(""); await load(); } catch (err) { setError(err?.response?.data?.message || "Unable to delete address."); } };
  const submit = async (event) => { event.preventDefault(); if (!items.length) return; setBusy(true); setError(""); try { const data = await checkout(selected ? { address_id: Number(selected) } : { address: form, save_address: save }); navigate(`/orders/${data.order.id}`, { replace: true }); } catch (err) { setError(err?.response?.data?.message || "Unable to place order."); } finally { setBusy(false); } };
  return <div className={styles.page}><Header /><main className={styles.main}><div className={styles.heading}><FiMapPin /><div><p>Delivery</p><h1>Checkout</h1></div></div>
    {error ? <div className={styles.error}>{error}</div> : null}
    {loading ? <SkeletonGrid count={3} /> : <form className={styles.checkout} onSubmit={submit}>
      <section className={styles.panel}><h2>Recipient</h2><label><span>Full name</span><input value={name} readOnly /></label></section>
      {addresses.length ? <section className={styles.panel}><h2>Saved addresses</h2><div className={styles.addresses}>{addresses.map((address) => <div className={selected === String(address.id) ? styles.addressSelected : styles.address} key={address.id}><button type="button" onClick={() => setSelected(String(address.id))}><strong>{address.state}</strong><span>{address.detailed_address}</span><small>{address.phone_number}</small></button><button type="button" className={styles.deleteAddress} onClick={() => removeAddress(address.id)} aria-label="Delete saved address"><FiTrash2 /></button></div>)}</div><button type="button" className={styles.link} onClick={() => setSelected("")}>Use a new address</button></section> : null}
      {!selected ? <section className={styles.panel}><h2>Delivery information</h2><label><span>Phone number</span><input required value={form.phone_number} onChange={(e) => setForm({ ...form, phone_number: e.target.value })} inputMode="tel" /></label><label><span>Detailed delivery address</span><textarea required minLength="10" value={form.detailed_address} onChange={(e) => setForm({ ...form, detailed_address: e.target.value })} placeholder="House number, street, area, landmark" /></label><CustomSelect label="State" required value={form.state} options={NIGERIA_STATES} onChange={(state) => setForm({ ...form, state })} />
        <div className={styles.location}><button type="button" onClick={locate} disabled={locating}><FiMapPin /> {locating ? "Reading location..." : form.latitude ? "Update current location" : "Use current location"}</button>{form.latitude ? <small>Location captured · accuracy about {Math.round(Number(form.location_accuracy || 0))} m</small> : <small>Your device will ask for location permission.</small>}</div>
        <label className={styles.check}><input type="checkbox" checked={save} onChange={(e) => setSave(e.target.checked)} /> Save this address</label>
      </section> : null}
      <section className={styles.panel}><h2>Review ({items.length})</h2>{items.map((item) => <div className={styles.review} key={item.id}><span>{item.product_name}</span><small>{item.heist_name}</small></div>)}</section>
      <button className={styles.primary} disabled={busy || !items.length || (!selected && !form.latitude)}>{busy ? "Placing order..." : "Place order"}</button>
    </form>}</main><Footer /></div>;
}
