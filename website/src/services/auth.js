import apiClient from "../utils/apiClient";
import { useAuthStore } from "../stores/authStore";
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

    localStorage.setItem("accessToken", response.data.access_token);

    const authStore = useAuthStore();
    authStore.setUserId(response.data.user.id);

    return response.data;
  } catch (error) {
    throw new Error(
      "Lỗi khi đăng nhập: " + error.response?.data?.message || error.message
    );
  }
};
