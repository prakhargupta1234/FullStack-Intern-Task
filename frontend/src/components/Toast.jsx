import React, { useEffect } from 'react';
import { CheckCircle2, AlertCircle, X, Info } from 'lucide-react';

export const Toast = ({ message, type = 'success', onClose, duration = 4000 }) => {
  useEffect(() => {
    if (!message) return;
    const timer = setTimeout(() => {
      onClose();
    }, duration);
    return () => clearTimeout(timer);
  }, [message, duration, onClose]);

  if (!message) return null;

  const isSuccess = type === 'success';
  const isError = type === 'error';

  return (
    <div
      role="alert"
      id="app-toast"
      className={`fixed top-5 right-5 z-50 flex items-start gap-3 p-4 rounded-xl shadow-xl border backdrop-blur-md max-w-md w-full transition-all duration-300 transform translate-y-0 ${
        isSuccess
          ? 'bg-emerald-50/95 border-emerald-300 text-emerald-900'
          : isError
          ? 'bg-rose-50/95 border-rose-300 text-rose-900'
          : 'bg-slate-50/95 border-slate-300 text-slate-900'
      }`}
    >
      <div className="shrink-0 mt-0.5">
        {isSuccess && <CheckCircle2 className="w-5 h-5 text-emerald-600" />}
        {isError && <AlertCircle className="w-5 h-5 text-rose-600" />}
        {!isSuccess && !isError && <Info className="w-5 h-5 text-slate-600" />}
      </div>

      <div className="flex-1 text-sm font-medium leading-5">
        {message}
      </div>

      <button
        onClick={onClose}
        id="toast-close-button"
        className="shrink-0 p-1 text-slate-400 hover:text-slate-600 rounded-lg hover:bg-black/5 transition-colors"
        aria-label="Close notification"
      >
        <X className="w-4 h-4" />
      </button>
    </div>
  );
};

export default Toast;
