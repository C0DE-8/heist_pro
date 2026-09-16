import React, { useState } from "react";
import { FaExclamationTriangle } from "react-icons/fa";
import Modal from "../ui/Modal";
import styles from "./AdminDialog.module.css";

export default function AdminDialog({ dialog, onCancel, onConfirm }) {
  if (!dialog) return null;

  return (
    <AdminDialogContent
      key={dialog.id}
      dialog={dialog}
      onCancel={onCancel}
      onConfirm={onConfirm}
    />
  );
}

function AdminDialogContent({ dialog, onCancel, onConfirm }) {
  const [value, setValue] = useState(dialog.initialValue ?? "");

  const isPrompt = dialog.kind === "prompt";
  const destructive = dialog.tone === "danger";

  return (
    <Modal
      open
      size="sm"
      title={dialog.title || (isPrompt ? "Enter details" : "Confirm action")}
      subtitle={dialog.subtitle}
      onClose={onCancel}
      footer={
        <>
          <button type="button" className={styles.cancelBtn} onClick={onCancel}>
            {dialog.cancelLabel || "Cancel"}
          </button>
          <button
            type="button"
            className={destructive ? styles.dangerBtn : styles.confirmBtn}
            onClick={() => onConfirm(isPrompt ? value : true)}
            disabled={isPrompt && dialog.required !== false && !String(value).trim()}
          >
            {dialog.confirmLabel || (destructive ? "Delete" : "Confirm")}
          </button>
        </>
      }
    >
      <div className={styles.content}>
        <div className={destructive ? styles.dangerIcon : styles.icon}>
          <FaExclamationTriangle />
        </div>
        <div>
          {dialog.message ? <p>{dialog.message}</p> : null}
          {isPrompt ? (
            <label className={styles.field}>
              <span>{dialog.label || "Value"}</span>
              <input
                type={dialog.inputType || "text"}
                value={value}
                min={dialog.min}
                max={dialog.max}
                placeholder={dialog.placeholder || ""}
                onChange={(event) => setValue(event.target.value)}
                onKeyDown={(event) => {
                  if (event.key === "Enter" && (dialog.required === false || String(value).trim())) {
                    event.preventDefault();
                    onConfirm(value);
                  }
                }}
                autoFocus
              />
            </label>
          ) : null}
        </div>
      </div>
    </Modal>
  );
}
