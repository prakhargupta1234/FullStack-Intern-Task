import React, { useState, useEffect } from 'react';
import { Clock, Calendar, Type, AlignLeft, AlertCircle } from 'lucide-react';

export const AppointmentForm = ({
  initialData = null,
  onSubmit,
  onCancel,
  isSubmitting = false,
  serverError = null,
}) => {
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    date: '',
    start_time: '',
    end_time: '',
  });

  const [fieldErrors, setFieldErrors] = useState({});

  useEffect(() => {
    if (initialData) {
      const formatTimeInput = (t) => (t && t.length >= 5 ? t.substring(0, 5) : t || '');
      setFormData({
        title: initialData.title || '',
        description: initialData.description || '',
        date: initialData.date ? String(initialData.date) : '',
        start_time: formatTimeInput(initialData.start_time),
        end_time: formatTimeInput(initialData.end_time),
      });
    } else {
      const today = new Date().toISOString().split('T')[0];
      setFormData({
        title: '',
        description: '',
        date: today,
        start_time: '10:00',
        end_time: '11:00',
      });
    }
    setFieldErrors({});
  }, [initialData]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));

    if (fieldErrors[name]) {
      setFieldErrors((prev) => ({ ...prev, [name]: null }));
    }
  };

  const validate = () => {
    const errors = {};

    if (!formData.title.trim()) {
      errors.title = 'Title is required.';
    }

    if (!formData.date) {
      errors.date = 'Date is required.';
    }

    if (!formData.start_time) {
      errors.start_time = 'Start time is required.';
    }

    if (!formData.end_time) {
      errors.end_time = 'End time is required.';
    }

    if (formData.start_time && formData.end_time) {
      if (formData.end_time <= formData.start_time) {
        errors.end_time = 'End time must be after start time.';
      }
    }

    setFieldErrors(errors);
    return Object.keys(errors).length === 0;
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!validate()) return;

    const normalizeTimeToSeconds = (t) => (t.length === 5 ? `${t}:00` : t);

    onSubmit({
      title: formData.title.trim(),
      description: formData.description.trim() || null,
      date: formData.date,
      start_time: normalizeTimeToSeconds(formData.start_time),
      end_time: normalizeTimeToSeconds(formData.end_time),
    });
  };

  const isEdit = Boolean(initialData && initialData.id);

  return (
    <form onSubmit={handleSubmit} className="space-y-4" noValidate id="appointment-form">
      {serverError && (
        <div
          id="form-server-error"
          className="p-3.5 bg-rose-50 border border-rose-200 rounded-xl flex items-start gap-2.5 text-rose-800 text-sm animate-shake"
        >
          <AlertCircle className="w-4 h-4 text-rose-600 mt-0.5 shrink-0" />
          <div className="font-medium">{serverError}</div>
        </div>
      )}

      <div>
        <label htmlFor="form-title" className="block text-xs font-semibold text-slate-700 uppercase tracking-wider mb-1.5">
          Title <span className="text-rose-500">*</span>
        </label>
        <div className="relative">
          <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-slate-400">
            <Type className="w-4 h-4" />
          </div>
          <input
            type="text"
            id="form-title"
            name="title"
            value={formData.title}
            onChange={handleChange}
            placeholder="e.g., Sprint Planning, Client Review"
            className={`w-full pl-10 pr-3 py-2 text-sm bg-slate-50 focus:bg-white border rounded-xl outline-none transition-all ${
              fieldErrors.title ? 'border-rose-400 bg-rose-50/20 focus:border-rose-500' : 'border-slate-200 focus:border-blue-500'
            }`}
            autoFocus
          />
        </div>
        {fieldErrors.title && (
          <p className="mt-1 text-xs text-rose-600 font-medium" id="error-title">
            {fieldErrors.title}
          </p>
        )}
      </div>

      <div>
        <label htmlFor="form-description" className="block text-xs font-semibold text-slate-700 uppercase tracking-wider mb-1.5">
          Description <span className="text-slate-400 font-normal normal-case">(Optional)</span>
        </label>
        <div className="relative">
          <div className="absolute top-2.5 left-3.5 pointer-events-none text-slate-400">
            <AlignLeft className="w-4 h-4" />
          </div>
          <textarea
            id="form-description"
            name="description"
            rows="3"
            value={formData.description}
            onChange={handleChange}
            placeholder="Add relevant notes, agenda, or video call links..."
            className="w-full pl-10 pr-3 py-2 text-sm bg-slate-50 focus:bg-white border border-slate-200 focus:border-blue-500 rounded-xl outline-none transition-all resize-none"
          />
        </div>
      </div>

      <div>
        <label htmlFor="form-date" className="block text-xs font-semibold text-slate-700 uppercase tracking-wider mb-1.5">
          Date <span className="text-rose-500">*</span>
        </label>
        <div className="relative">
          <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-slate-400">
            <Calendar className="w-4 h-4" />
          </div>
          <input
            type="date"
            id="form-date"
            name="date"
            value={formData.date}
            onChange={handleChange}
            className={`w-full pl-10 pr-3 py-2 text-sm bg-slate-50 focus:bg-white border rounded-xl outline-none transition-all ${
              fieldErrors.date ? 'border-rose-400 bg-rose-50/20 focus:border-rose-500' : 'border-slate-200 focus:border-blue-500'
            }`}
          />
        </div>
        {fieldErrors.date && (
          <p className="mt-1 text-xs text-rose-600 font-medium" id="error-date">
            {fieldErrors.date}
          </p>
        )}
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
        <div>
          <label htmlFor="form-start-time" className="block text-xs font-semibold text-slate-700 uppercase tracking-wider mb-1.5">
            Start Time <span className="text-rose-500">*</span>
          </label>
          <div className="relative">
            <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-slate-400">
              <Clock className="w-4 h-4" />
            </div>
            <input
              type="time"
              id="form-start-time"
              name="start_time"
              value={formData.start_time}
              onChange={handleChange}
              className={`w-full pl-10 pr-3 py-2 text-sm bg-slate-50 focus:bg-white border rounded-xl outline-none transition-all ${
                fieldErrors.start_time ? 'border-rose-400 bg-rose-50/20 focus:border-rose-500' : 'border-slate-200 focus:border-blue-500'
              }`}
            />
          </div>
          {fieldErrors.start_time && (
            <p className="mt-1 text-xs text-rose-600 font-medium" id="error-start-time">
              {fieldErrors.start_time}
            </p>
          )}
        </div>

        <div>
          <label htmlFor="form-end-time" className="block text-xs font-semibold text-slate-700 uppercase tracking-wider mb-1.5">
            End Time <span className="text-rose-500">*</span>
          </label>
          <div className="relative">
            <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-slate-400">
              <Clock className="w-4 h-4" />
            </div>
            <input
              type="time"
              id="form-end-time"
              name="end_time"
              value={formData.end_time}
              onChange={handleChange}
              className={`w-full pl-10 pr-3 py-2 text-sm bg-slate-50 focus:bg-white border rounded-xl outline-none transition-all ${
                fieldErrors.end_time ? 'border-rose-400 bg-rose-50/20 focus:border-rose-500' : 'border-slate-200 focus:border-blue-500'
              }`}
            />
          </div>
          {fieldErrors.end_time && (
            <p className="mt-1 text-xs text-rose-600 font-medium" id="error-end-time">
              {fieldErrors.end_time}
            </p>
          )}
        </div>
      </div>

      <div className="pt-4 flex items-center justify-end gap-3 border-t border-slate-100 mt-5">
        <button
          type="button"
          id="modal-cancel-button"
          onClick={onCancel}
          disabled={isSubmitting}
          className="px-4 py-2 text-sm font-medium text-slate-700 bg-slate-100 hover:bg-slate-200 rounded-xl transition-colors disabled:opacity-50 cursor-pointer"
        >
          Cancel
        </button>
        <button
          type="submit"
          id="modal-submit-button"
          disabled={isSubmitting}
          className="px-5 py-2 text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 rounded-xl transition-all shadow-md shadow-blue-500/20 disabled:opacity-50 flex items-center gap-2 cursor-pointer"
        >
          {isSubmitting ? (
            <>
              <span className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin"></span>
              <span>{isEdit ? 'Updating...' : 'Creating...'}</span>
            </>
          ) : (
            <span>{isEdit ? 'Update Appointment' : 'Create Appointment'}</span>
          )}
        </button>
      </div>
    </form>
  );
};

export default AppointmentForm;
