import React from 'react';
import { Calendar, Filter, X, RotateCcw } from 'lucide-react';

export const AppointmentFilters = ({
  filterDate,
  filterStatus,
  onDateChange,
  onStatusChange,
  onClearFilters,
  totalCount,
}) => {
  const hasActiveFilters = Boolean(filterDate || (filterStatus && filterStatus !== 'All'));

  return (
    <div className="bg-white border border-slate-200/80 rounded-2xl p-4 sm:p-5 shadow-sm mb-6 transition-all">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        {/* Left Side: Filter Form Controls */}
        <div className="flex flex-wrap items-center gap-3">
          {/* Date Picker */}
          <div className="relative min-w-[180px] flex-1 sm:flex-initial">
            <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-slate-400">
              <Calendar className="w-4 h-4" />
            </div>
            <input
              type="date"
              id="filter-date-input"
              value={filterDate}
              onChange={(e) => onDateChange(e.target.value)}
              className="w-full pl-10 pr-3 py-2 text-sm bg-slate-50 hover:bg-slate-100/80 focus:bg-white border border-slate-200 focus:border-blue-500 rounded-xl outline-none transition-all text-slate-800"
              aria-label="Filter appointments by date"
            />
          </div>

          {/* Status Dropdown */}
          <div className="relative min-w-[160px] flex-1 sm:flex-initial">
            <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-slate-400">
              <Filter className="w-4 h-4" />
            </div>
            <select
              id="filter-status-select"
              value={filterStatus}
              onChange={(e) => onStatusChange(e.target.value)}
              className="w-full pl-10 pr-8 py-2 text-sm bg-slate-50 hover:bg-slate-100/80 focus:bg-white border border-slate-200 focus:border-blue-500 rounded-xl outline-none transition-all text-slate-800 cursor-pointer appearance-none"
              aria-label="Filter appointments by status"
            >
              <option value="All">All Statuses</option>
              <option value="Scheduled">Scheduled</option>
              <option value="Completed">Completed</option>
              <option value="Cancelled">Cancelled</option>
            </select>
            <div className="absolute inset-y-0 right-0 pr-3 flex items-center pointer-events-none text-slate-400 text-xs">
              ▼
            </div>
          </div>

          {/* Clear Filters Button */}
          {hasActiveFilters && (
            <button
              type="button"
              id="clear-filters-button"
              onClick={onClearFilters}
              className="inline-flex items-center gap-1.5 px-3 py-2 text-sm font-medium text-slate-600 hover:text-slate-900 bg-slate-100 hover:bg-slate-200 rounded-xl transition-all cursor-pointer"
            >
              <RotateCcw className="w-3.5 h-3.5" />
              Clear Filters
            </button>
          )}
        </div>

        {/* Right Side: Appointment Counter */}
        <div className="flex items-center gap-2 text-xs font-semibold text-slate-500">
          <span>Showing</span>
          <span className="px-2 py-0.5 rounded-md bg-blue-50 text-blue-700 border border-blue-200 font-mono text-xs">
            {totalCount}
          </span>
          <span>{totalCount === 1 ? 'appointment' : 'appointments'}</span>
          {hasActiveFilters && (
            <span className="inline-flex items-center gap-1 text-blue-600 bg-blue-50/50 px-2 py-0.5 rounded text-[11px] font-medium border border-blue-100">
              Filtered
            </span>
          )}
        </div>
      </div>
    </div>
  );
};

export default AppointmentFilters;
