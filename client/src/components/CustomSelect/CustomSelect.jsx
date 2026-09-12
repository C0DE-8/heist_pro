import React, { useEffect, useMemo, useRef, useState } from "react";
import styles from "./CustomSelect.module.css";

export default function CustomSelect({ label, value, options, onChange, placeholder = "Search or select", required = false }) {
  const ref = useRef(null);
  const [open, setOpen] = useState(false);
  const [search, setSearch] = useState("");
  const filtered = useMemo(() => options.filter((option) => option.toLowerCase().includes(search.toLowerCase())), [options, search]);
  useEffect(() => {
    const close = (event) => { if (!ref.current?.contains(event.target)) setOpen(false); };
    document.addEventListener("mousedown", close); return () => document.removeEventListener("mousedown", close);
  }, []);
  return (
    <div className={styles.field} ref={ref}>
      <label htmlFor="custom-state-select">{label}</label>
      <input id="custom-state-select" value={open ? search : value} placeholder={placeholder} required={required}
        role="combobox" aria-expanded={open} aria-controls="custom-state-options" aria-autocomplete="list" autoComplete="off"
        onFocus={() => { setSearch(value || ""); setOpen(true); }} onChange={(event) => { setSearch(event.target.value); onChange(""); setOpen(true); }} />
      {open ? <div className={styles.options} id="custom-state-options" role="listbox">
        {filtered.length ? filtered.map((option) => <button type="button" key={option} role="option" aria-selected={value === option}
          className={value === option ? styles.selected : styles.option}
          onMouseDown={(event) => { event.preventDefault(); onChange(option); setSearch(option); setOpen(false); }}>{option}</button>)
          : <div className={styles.empty}>No matching option.</div>}
      </div> : null}
    </div>
  );
}
