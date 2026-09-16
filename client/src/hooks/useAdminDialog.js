import { useCallback, useMemo, useRef, useState } from "react";

export function useAdminDialog() {
  const [dialog, setDialog] = useState(null);
  const resolverRef = useRef(null);
  const dialogIdRef = useRef(0);

  const open = useCallback((config) => {
    if (resolverRef.current) resolverRef.current(null);
    return new Promise((resolve) => {
      resolverRef.current = resolve;
      dialogIdRef.current += 1;
      setDialog({ ...config, id: dialogIdRef.current });
    });
  }, []);

  const close = useCallback((result) => {
    const resolve = resolverRef.current;
    resolverRef.current = null;
    setDialog(null);
    resolve?.(result);
  }, []);

  const confirm = useCallback(
    (config = {}) => open({ ...config, kind: "confirm" }),
    [open]
  );
  const prompt = useCallback(
    (config = {}) => open({ ...config, kind: "prompt" }),
    [open]
  );

  return useMemo(
    () => ({
      confirm,
      prompt,
      dialogProps: {
        dialog,
        onCancel: () => close(null),
        onConfirm: close,
      },
    }),
    [close, confirm, dialog, prompt]
  );
}
