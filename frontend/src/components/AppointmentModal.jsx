import React, { useEffect } from 'react';
import { X, CalendarPlus, Edit3 } from 'lucide-react';
import AppointmentForm from './AppointmentForm';

export const AppointmentModal = ({
  isOpen,
  onClose,
  initialData = null,
  onSubmit,
  isSubmitting = false,
  serverError = null,
}) => {
  useEffect(() => {
    const handleKeyDown = (e) => {
      if (e.key === 'Escape' && isOpen && !isSubmitting) {
        onClose();
      }
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [isOpen, isSubmitting, onClose]);

  if (!isOpen) return null;

  const isEdit = Boolean(initialData && initialData.id);

  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/50 backdrop-blur-sm animate-fade-in"
      id="appointment-modal-overlay"
      onClick={(e) => {
        if (e.target === e.currentTarget && !isSubmitting) onClose();
      }}
    >
      <div
        className="w-full max-w-lg bg-white rounded-2xl shadow-2xl border border-slate-200 overflow-hidden transform transition-all"
        role="dialog"
        aria-modal="true"
        aria-labelledby="modal-title"
      >
        {/* Modal Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-slate-100 bg-slate-50/50">
          <div className="flex items-center gap-3">
            <div className={`p-2 rounded-xl ${isEdit ? 'bg-amber-100 text-amber-700' : 'bg-blue-100 text-blue-700'}`}>
              {isEdit ? <Edit3 className="w-5 h-5" /> : <CalendarPlus className="w-5 h-5" />}
            </div>
            <div>
              <h2 id="modal-title" className="text-base font-semibold text-slate-900">
                {isEdit ? 'Edit Appointment' : 'Add New Appointment'}
              </h2>
              <p className="text-xs text-slate-500">
                {isEdit ? 'Update appointment time and information' : 'Schedule a new slot for the team'}
              </p>
            </div>
          </div>
          <button
            type="button"
            id="modal-header-close-button"
            onClick={onClose}
            disabled={isSubmitting}
            className="p-1.5 text-slate-400 hover:text-slate-600 rounded-lg hover:bg-slate-100 transition-colors disabled:opacity-50"
            aria-label="Close modal"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Modal Body */}
        <div className="p-6">
          <AppointmentForm
            initialData={initialData}
            onSubmit={onSubmit}
            onCancel={onClose}
            isSubmitting={isSubmitting}
            serverError={serverError}
          />
        </div>
      </div>
    </div>
  );
};

export default AppointmentModal;
