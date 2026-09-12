import React, { useState } from "react";
import { imgUrl } from "../../lib/api";
import styles from "./ProductGallery.module.css";

export default function ProductGallery({ product }) {
  const images = product?.images || [];
  const [active, setActive] = useState(0);
  if (!images.length) return null;
  const selected = images[Math.min(active, images.length - 1)];
  return <div className={styles.gallery}>
    <img className={styles.main} src={imgUrl(selected.image_path)} alt={`${product.name} view ${active + 1}`} />
    {images.length > 1 ? <div className={styles.thumbs} aria-label={`${product.name} image gallery`}>{images.map((image, index) => <button type="button" key={image.id} className={index === active ? styles.active : ""} onClick={() => setActive(index)} aria-label={`Show image ${index + 1}`}><img src={imgUrl(image.image_path)} alt="" /></button>)}</div> : null}
  </div>;
}
