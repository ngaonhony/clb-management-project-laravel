import apiClient from "../utils/apiClient";
// import { useAuthStore } from "../stores/authStore";

const saveUserData = (data) => {
  localStorage.setItem('user', JSON.stringify(data.user));
  localStorage.setItem('access_token', data.access_token);
  // Update Authorization header for future requests
  apiClient.defaults.headers.common['Authorization'] = `Bearer ${data.access_token}`;
};

// Khôi phục trạng thái authentication khi refresh
const initializeAuth = () => {
  const token = localStorage.getItem('access_token');
  if (token) {
    apiClient.defaults.headers.common['Authorization'] = `Bearer ${token}`;
  }
};

// Gọi hàm khởi tạo khi import module
initializeAuth();

export const register = async (userData) => {
  try {
    const response = await apiClient.post("auth/register", userData);
    return response.data;
  } catch (error) {
    throw new Error(
      "Lỗi khi đăng ký người dùng: " + error.response?.data?.message ||
        error.message
    );
  }
};

export const login = async (userData) => {
  try {
    const response = await apiClient.post("auth/login", userData);
    const data = response.data;
    
    // Save user data and token
    saveUserData(data);
    
    return data;
  } catch (error) {
    console.error("Lỗi khi đăng nhập:", error);
    throw new Error(error.response?.data?.message || error.message);
  }
};

export const logout = () => {
  localStorage.removeItem('user');
  localStorage.removeItem('access_token');
  delete apiClient.defaults.headers.common['Authorization'];
};

export const getCurrentUser = () => {
  const user = localStorage.getItem('user');
  return user ? JSON.parse(user) : null;
};

export const isAuthenticated = () => {
  const token = localStorage.getItem('access_token');
  const user = getCurrentUser();
  return !!(token && user);
};
