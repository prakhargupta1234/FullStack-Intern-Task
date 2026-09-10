import axios from 'axios';

const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000/api/appointments';

const apiClient = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
  timeout: 10000,
});

/**
 * Standard error message extractor
 */
export const extractErrorMessage = (error) => {
  if (error.response && error.response.data) {
    if (typeof error.response.data.detail === 'string') {
      return error.response.data.detail;
    }
    if (Array.isArray(error.response.data.detail)) {
      return error.response.data.detail.map((d) => d.msg || JSON.stringify(d)).join(', ');
    }
  }
  if (error.message) {
    if (error.code === 'ECONNABORTED') return 'Request timed out. Please check your network or server.';
    if (error.message === 'Network Error') return 'Cannot connect to backend server. Make sure FastAPI is running on port 8000.';
    return error.message;
  }
  return 'An unexpected error occurred. Please try again.';
};

export const appointmentApi = {
  /**
   * Get all appointments with optional date and status filters
   */
  getAll: async (filters = {}) => {
    const params = {};
    if (filters.date) {
      params.date = filters.date;
    }
    if (filters.status && filters.status !== 'All') {
      params.status = filters.status;
    }
    const response = await apiClient.get('', { params });
    return response.data;
  },

  /**
   * Get single appointment by ID
   */
  getById: async (id) => {
    const response = await apiClient.get(`/${id}`);
    return response.data;
  },

  /**
   * Create a new appointment
   */
  create: async (appointmentData) => {
    const response = await apiClient.post('', appointmentData);
    return response.data;
  },

  /**
   * Update an existing appointment
   */
  update: async (id, appointmentData) => {
    const response = await apiClient.put(`/${id}`, appointmentData);
    return response.data;
  },

  /**
   * Mark appointment as Completed
   */
  complete: async (id) => {
    const response = await apiClient.patch(`/${id}/complete`);
    return response.data;
  },

  /**
   * Cancel an appointment
   */
  cancel: async (id) => {
    const response = await apiClient.patch(`/${id}/cancel`);
    return response.data;
  },
};

export default appointmentApi;
