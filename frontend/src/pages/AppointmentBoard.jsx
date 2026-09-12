import React, { useState, useEffect, useCallback } from 'react';
import { Plus, Calendar, Clock, RefreshCw, AlertTriangle } from 'lucide-react';
import appointmentApi, { extractErrorMessage } from '../services/appointmentApi';
import AppointmentCard from '../components/AppointmentCard';
import AppointmentModal from '../components/AppointmentModal';
import AppointmentFilters from '../components/AppointmentFilters';
import ConfirmModal from '../components/ConfirmModal';
import Toast from '../components/Toast';

export const AppointmentBoard = () => {
  // Appointments state
  const [appointments, setAppointments] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);

  // Filters state
  const [filterDate, setFilterDate] = useState('');
  const [filterStatus, setFilterStatus] = useState('All');

  // Modal states
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingAppointment, setEditingAppointment] = useState(null);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [formServerError, setFormServerError] = useState(null);

  // Cancellation confirm modal state
  const [cancelModalAppointment, setCancelModalAppointment] = useState(null);
  const [isCancelling, setIsCancelling] = useState(false);

  // Toast notification state
  const [toast, setToast] = useState({ message: '', type: 'success' });

  const showToast = (message, type = 'success') => {
    setToast({ message, type });
  };

  const closeToast = () => {
    setToast({ message: '', type: 'success' });
  };

  // Fetch appointments from backend with active query params
  const loadAppointments = useCallback(async () => {
    setIsLoading(true);
    setError(null);
    try {
      const data = await appointmentApi.getAll({
        date: filterDate || undefined,
        status: filterStatus !== 'All' ? filterStatus : undefined,
      });
      setAppointments(data);
    } catch (err) {
      const msg = extractErrorMessage(err);
      setError(msg);
      showToast(msg, 'error');
    } finally {
      setIsLoading(false);
    }
  }, [filterDate, filterStatus]);

  useEffect(() => {
    loadAppointments();
  }, [loadAppointments]);

  // Keyboard shortcut: Press 'N' to open Add Appointment modal (when not focused in an input)
  useEffect(() => {
    const handleGlobalKeyDown = (e) => {
      const activeTag = document.activeElement?.tagName?.toLowerCase();
      if (activeTag === 'input' || activeTag === 'textarea' || activeTag === 'select') {
        return;
      }
      if ((e.key === 'n' || e.key === 'N') && !isModalOpen && !cancelModalAppointment) {
        e.preventDefault();
        handleOpenAddModal();
      }
    };
    window.addEventListener('keydown', handleGlobalKeyDown);
    return () => window.removeEventListener('keydown', handleGlobalKeyDown);
  }, [isModalOpen, cancelModalAppointment]);

  // Handlers for Add / Edit Modal
  const handleOpenAddModal = () => {
    setEditingAppointment(null);
    setFormServerError(null);
    setIsModalOpen(true);
  };

  const handleOpenEditModal = (appointment) => {
    setEditingAppointment(appointment);
    setFormServerError(null);
    setIsModalOpen(true);
  };

  const handleCloseModal = () => {
    if (isSubmitting) return;
    setIsModalOpen(false);
    setEditingAppointment(null);
    setFormServerError(null);
  };

  const handleFormSubmit = async (formData) => {
    setIsSubmitting(true);
    setFormServerError(null);

    try {
      if (editingAppointment && editingAppointment.id) {
        await appointmentApi.update(editingAppointment.id, formData);
        showToast('Appointment updated successfully.', 'success');
      } else {
        await appointmentApi.create(formData);
        showToast('Appointment created successfully.', 'success');
      }
      setIsModalOpen(false);
      setEditingAppointment(null);
      await loadAppointments();
    } catch (err) {
      const msg = extractErrorMessage(err);
      setFormServerError(msg);
      showToast(msg, 'error');
    } finally {
      setIsSubmitting(false);
    }
  };

  // Handler for Complete Appointment
  const handleComplete = async (id) => {
    try {
      await appointmentApi.complete(id);
      showToast('Appointment marked as completed.', 'success');
      await loadAppointments();
    } catch (err) {
      const msg = extractErrorMessage(err);
      showToast(msg, 'error');
    }
  };

  // Handlers for Cancel Appointment
  const handlePromptCancel = (appointment) => {
    setCancelModalAppointment(appointment);
  };

  const handleCloseCancelModal = () => {
    if (isCancelling) return;
    setCancelModalAppointment(null);
  };

  const handleConfirmCancel = async () => {
    if (!cancelModalAppointment) return;
    setIsCancelling(true);
    try {
      await appointmentApi.cancel(cancelModalAppointment.id);
      showToast('Appointment cancelled successfully.', 'success');
      setCancelModalAppointment(null);
      await loadAppointments();
    } catch (err) {
      const msg = extractErrorMessage(err);
      showToast(msg, 'error');
    } finally {
      setIsCancelling(false);
    }
  };

  // Clear filters
  const handleClearFilters = () => {
    setFilterDate('');
    setFilterStatus('All');
  };

  const hasActiveFilters = Boolean(filterDate || (filterStatus && filterStatus !== 'All'));

  return (
    <div className="min-h-screen bg-gradient-to-b from-slate-50 via-slate-100/60 to-slate-200/50">
      {/* Toast Notification Container */}
      <Toast
        message={toast.message}
        type={toast.type}
        onClose={closeToast}
      />

      {/* Main Container */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 sm:py-10">
        {/* Header Section */}
        <header className="mb-8">
          <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 pb-6 border-b border-slate-200/80">
            <div>
              <div className="flex items-center gap-2 mb-1">
                <div className="p-2 bg-blue-600 text-white rounded-xl shadow-md shadow-blue-500/20">
                  <Calendar className="w-5 h-5" />
                </div>
                <h1 className="text-2xl sm:text-3xl font-bold text-slate-900 tracking-tight" id="main-header-title">
                  Appointment Board
                </h1>
              </div>
              <p className="text-sm text-slate-600">
                Manage your team's appointments efficiently
              </p>
            </div>

            <div className="flex items-center gap-3">
              <button
                type="button"
                onClick={loadAppointments}
                id="refresh-button"
                className="p-2.5 text-slate-600 hover:text-slate-900 bg-white hover:bg-slate-50 border border-slate-200 rounded-xl transition-colors shadow-sm"
                title="Refresh appointments"
                aria-label="Refresh appointments"
              >
                <RefreshCw className={`w-4 h-4 ${isLoading ? 'animate-spin text-blue-600' : ''}`} />
              </button>

              <button
                type="button"
                id="add-appointment-button"
                onClick={handleOpenAddModal}
                className="inline-flex items-center gap-2 px-4 py-2.5 bg-blue-600 hover:bg-blue-700 text-white text-sm font-semibold rounded-xl transition-all shadow-md shadow-blue-500/20 hover:shadow-lg hover:shadow-blue-500/30 cursor-pointer"
              >
                <Plus className="w-4 h-4" />
                <span>Add Appointment</span>
                <kbd className="hidden sm:inline-block ml-1 px-1.5 py-0.5 text-[10px] font-mono bg-blue-700/50 rounded border border-blue-400/30 text-blue-100 font-normal">
                  N
                </kbd>
              </button>
            </div>
          </div>
        </header>

        {/* Filters Bar */}
        <AppointmentFilters
          filterDate={filterDate}
          filterStatus={filterStatus}
          onDateChange={setFilterDate}
          onStatusChange={setFilterStatus}
          onClearFilters={handleClearFilters}
          totalCount={appointments.length}
        />

        {/* Content Area: Loading, Error, Empty, or Cards Grid */}
        <main>
          {isLoading ? (
            /* Loading State / Skeleton Grid */
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5" id="loading-state">
              {[1, 2, 3, 4, 5, 6].map((i) => (
                <div
                  key={i}
                  className="bg-white border border-slate-200 rounded-2xl p-5 shadow-sm animate-pulse space-y-4"
                >
                  <div className="flex justify-between items-center">
                    <div className="h-5 bg-slate-200 rounded w-2/3"></div>
                    <div className="h-5 bg-slate-200 rounded-full w-20"></div>
                  </div>
                  <div className="space-y-2">
                    <div className="h-3 bg-slate-100 rounded w-full"></div>
                    <div className="h-3 bg-slate-100 rounded w-4/5"></div>
                  </div>
                  <div className="pt-3 border-t border-slate-100 space-y-2">
                    <div className="h-3 bg-slate-200 rounded w-1/2"></div>
                    <div className="h-3 bg-slate-200 rounded w-1/3"></div>
                  </div>
                </div>
              ))}
            </div>
          ) : error ? (
            /* Error State */
            <div
              id="error-state"
              className="bg-rose-50 border border-rose-200 rounded-2xl p-8 text-center max-w-lg mx-auto shadow-sm"
            >
              <AlertTriangle className="w-10 h-10 text-rose-500 mx-auto mb-3" />
              <h3 className="text-base font-semibold text-rose-900 mb-1">
                Unable to load appointments
              </h3>
              <p className="text-sm text-rose-700 mb-4">{error}</p>
              <button
                type="button"
                id="error-retry-button"
                onClick={loadAppointments}
                className="px-4 py-2 bg-rose-600 hover:bg-rose-700 text-white text-xs font-semibold rounded-xl transition-colors shadow-sm"
              >
                Retry Connection
              </button>
            </div>
          ) : appointments.length === 0 ? (
            /* Empty State */
            <div
              id="empty-state"
              className="bg-white border border-slate-200 rounded-2xl p-12 text-center max-w-lg mx-auto shadow-sm"
            >
              <div className="w-12 h-12 bg-blue-50 text-blue-600 rounded-2xl flex items-center justify-center mx-auto mb-4 border border-blue-100">
                <Clock className="w-6 h-6" />
              </div>
              <h3 className="text-base font-semibold text-slate-900 mb-1">
                {hasActiveFilters ? 'No appointments match your filters.' : 'No appointments found.'}
              </h3>
              <p className="text-sm text-slate-500 mb-6">
                {hasActiveFilters
                  ? 'Try selecting a different date or status, or clear all filters.'
                  : 'Get started by scheduling the first appointment for your team.'}
              </p>

              {hasActiveFilters ? (
                <button
                  type="button"
                  id="empty-clear-filters-button"
                  onClick={handleClearFilters}
                  className="px-4 py-2 text-sm font-medium text-slate-700 bg-slate-100 hover:bg-slate-200 rounded-xl transition-colors"
                >
                  Clear Filters
                </button>
              ) : (
                <button
                  type="button"
                  id="empty-add-appointment-button"
                  onClick={handleOpenAddModal}
                  className="inline-flex items-center gap-2 px-4 py-2 text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 rounded-xl transition-colors shadow-sm"
                >
                  <Plus className="w-4 h-4" />
                  Add Appointment
                </button>
              )}
            </div>
          ) : (
            /* Appointments Grid */
            <div
              className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5"
              id="appointments-grid"
            >
              {appointments.map((appointment) => (
                <AppointmentCard
                  key={appointment.id}
                  appointment={appointment}
                  onEdit={handleOpenEditModal}
                  onComplete={handleComplete}
                  onCancel={handlePromptCancel}
                />
              ))}
            </div>
          )}
        </main>
      </div>

      {/* Add / Edit Appointment Modal */}
      <AppointmentModal
        isOpen={isModalOpen}
        onClose={handleCloseModal}
        initialData={editingAppointment}
        onSubmit={handleFormSubmit}
        isSubmitting={isSubmitting}
        serverError={formServerError}
      />

      {/* Cancel Confirmation Dialog */}
      <ConfirmModal
        isOpen={Boolean(cancelModalAppointment)}
        title="Cancel Appointment"
        message={`Are you sure you want to cancel "${cancelModalAppointment?.title}"? The record will remain visible as Cancelled, and its time slot will become available for new bookings.`}
        confirmText="Yes, Cancel Appointment"
        onConfirm={handleConfirmCancel}
        onCancel={handleCloseCancelModal}
        isSubmitting={isCancelling}
      />
    </div>
  );
};

export default AppointmentBoard;
