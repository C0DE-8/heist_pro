import React, { useCallback, useEffect, useState } from "react";
import { FiArrowRight, FiShoppingCart, FiTrash2 } from "react-icons/fi";
import { useNavigate } from "react-router-dom";
import Header from "../../components/Header/Header";
import Footer from "../../components/Footer/Footer";
import SkeletonGrid from "../../components/SkeletonGrid/SkeletonGrid";
import { addCartItem, getCart, getProductWins, removeCartItem } from "../../lib/commerce";
import { imgUrl } from "../../lib/api";
import styles from "./Commerce.module.css";

export default function Cart() {
  const navigate = useNavigate();
  const [items, setItems] = useState([]); const [rewards, setRewards] = useState([]); const [loading, setLoading] = useState(true); const [error, setError] = useState("");
  const load = useCallback(async () => { setLoading(true); setError(""); try { const [data, wins] = await Promise.all([getCart(), getProductWins()]); setItems(data.items || []); setRewards((wins.rewards || []).filter((reward) => reward.status === "available")); } catch (err) { setError(err?.response?.data?.message || "Unable to load cart."); } finally { setLoading(false); } }, []);
  useEffect(() => { load(); }, [load]);
  const remove = async (id) => { try { await removeCartItem(id); await load(); } catch (err) { setError(err?.response?.data?.message || "Unable to remove product."); } };
  return <div className={styles.page}><Header /><main className={styles.main}>
    <div className={styles.heading}><FiShoppingCart /><div><p>Won products</p><h1>Your cart</h1></div></div>
    {error ? <div className={styles.error}>{error}</div> : null}
    {rewards.length ? <section className={styles.panel}><h2>Product rewards ready to claim</h2>{rewards.map((reward) => <div className={styles.review} key={reward.entitlement_id}><span>{reward.product_name} · {reward.heist_name}</span><button type="button" className={styles.link} onClick={async()=>{await addCartItem(reward.entitlement_id);await load();}}>Add to cart</button></div>)}</section> : null}
    {loading ? <SkeletonGrid count={2} /> : items.length ? <>
      <div className={styles.items}>{items.map((item) => <article className={styles.item} key={item.id}>
        <img src={imgUrl(item.primary_image)} alt={item.product_name} />
        <div><small>Won from {item.heist_name}</small><h2>{item.product_name}</h2><p>{item.product_description}</p></div>
        <button type="button" className={styles.iconButton} onClick={() => remove(item.id)} aria-label={`Remove ${item.product_name}`}><FiTrash2 /></button>
      </article>)}</div>
      <button type="button" className={styles.primary} onClick={() => navigate("/checkout")}>Continue to checkout <FiArrowRight /></button>
    </> : <div className={styles.empty}><FiShoppingCart /><h2>Your cart is empty</h2><p>Products you win from Product Heists can be added here.</p><button onClick={() => navigate("/heist")}>Browse Heists</button></div>}
  </main><Footer /></div>;
}
