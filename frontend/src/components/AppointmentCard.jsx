import React from 'react';
import { Calendar, Clock, Edit2, CheckCircle, Ban } from 'lucide-react';
import StatusBadge from './StatusBadge';

const formatDisplayTime = (timeStr) => {
  if (!timeStr) return '';
  const parts = timeStr.split(':');
  if (parts.length < 2) return timeStr;
  let hour = parseInt(parts[0], 10);
  const minute = parts[1];
  const ampm = hour >= 12 ? 'PM' : 'AM';
  hour = hour % 12;
  hour = hour ? hour : 12;
  return `${hour}:${minute} ${ampm}`;
};

const formatDisplayDate = (dateStr) => {
  if (!dateStr) return '';
  try {
    const [year, month, day] = dateStr.split('-').map(Number);
    const d = new Date(year, month - 1, day);
    return d.toLocaleDateString(undefined, {
      weekday: 'short',
      month: 'short',
      day: 'numeric',
      year: 'numeric',
    });
  } catch {
    return dateStr;
  }
};

export const AppointmentCard = ({
  appointment,
  onEdit,
  onComplete,
  onCancel,
}) => {
  const { id, title, description, date, start_time, end_time, status } = appointment;

  const isScheduled = status === 'Scheduled';
  const isCompleted = status === 'Completed';
  const isCancelled = status === 'Cancelled';

  return (
    <div
      id={`appointment-card-${id}`}
      className={`group relative rounded-2xl border transition-all duration-200 flex flex-col justify-between overflow-hidden ${
        isCancelled
          ? 'bg-slate-50/60 border-slate-200/60 opacity-85 hover:opacity-100'
          : isCompleted
          ? 'bg-white border-emerald-100 shadow-sm hover:shadow-md hover:border-emerald-200'
          : 'bg-white border-slate-200/90 shadow-sm hover:shadow-md hover:border-blue-200'
      }`}
    >
      <div
        className={`h-1.5 w-full ${
          isScheduled
            ? 'bg-gradient-to-r from-blue-500 to-indigo-500'
            : isCompleted
            ? 'bg-gradient-to-r from-emerald-400 to-teal-500'
            : 'bg-slate-300'
        }`}
      />

      <div className="p-5 flex-1 flex flex-col">
        <div className="flex items-start justify-between gap-3 mb-2.5">
          <h3
            className={`text-base font-semibold leading-snug line-clamp-2 ${
              isCancelled ? 'text-slate-500 line-through' : 'text-slate-900'
            }`}
          >
            {title}
          </h3>
          <div className="shrink-0">
            <StatusBadge status={status} />
          </div>
        </div>

        <p className="text-xs text-slate-600 leading-relaxed mb-4 line-clamp-3 flex-1">
          {description || (
            <span className="text-slate-400 italic">No description provided</span>
          )}
        </p>

        <div className="pt-3 border-t border-slate-100 space-y-1.5 text-xs text-slate-600">
          <div className="flex items-center gap-2">
            <Calendar className="w-3.5 h-3.5 text-slate-400 shrink-0" />
            <span className="font-medium text-slate-700">{formatDisplayDate(date)}</span>
          </div>
          <div className="flex items-center gap-2">
            <Clock className="w-3.5 h-3.5 text-slate-400 shrink-0" />
            <span className="font-mono text-slate-700">
              {formatDisplayTime(start_time)} – {formatDisplayTime(end_time)}
            </span>
          </div>
        </div>
      </div>

      <div className="px-5 py-3 bg-slate-50/70 border-t border-slate-100 flex items-center justify-end gap-2">
        {!isCancelled && (
          <button
            type="button"
            id={`btn-edit-${id}`}
            onClick={() => onEdit(appointment)}
            className="inline-flex items-center gap-1.5 px-2.5 py-1.5 text-xs font-medium text-slate-700 hover:text-slate-900 hover:bg-slate-200/70 rounded-lg transition-colors cursor-pointer"
            title="Edit appointment"
          >
            <Edit2 className="w-3.5 h-3.5 text-slate-500" />
            Edit
          </button>
        )}

        {isScheduled && (
          <button
            type="button"
            id={`btn-complete-${id}`}
            onClick={() => onComplete(id)}
            className="inline-flex items-center gap-1.5 px-2.5 py-1.5 text-xs font-medium text-emerald-700 hover:text-emerald-800 bg-emerald-50 hover:bg-emerald-100/80 border border-emerald-200/80 rounded-lg transition-colors cursor-pointer"
            title="Mark appointment as completed"
          >
            <CheckCircle className="w-3.5 h-3.5 text-emerald-600" />
            Complete
          </button>
        )}

        {!isCancelled && (
          <button
            type="button"
            id={`btn-cancel-${id}`}
            onClick={() => onCancel(appointment)}
            className="inline-flex items-center gap-1.5 px-2.5 py-1.5 text-xs font-medium text-rose-700 hover:text-rose-800 hover:bg-rose-50 rounded-lg transition-colors cursor-pointer"
            title="Cancel appointment"
          >
            <Ban className="w-3.5 h-3.5 text-rose-500" />
            Cancel
          </button>
        )}

        {isCancelled && (
          <span className="text-[11px] text-slate-400 italic py-1">
            Slot released
          </span>
        )}
      </div>
    </div>
  );
};

export default AppointmentCard;
