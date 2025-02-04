import apiClient from "../utils/apiClient";

export const register = async (userData) => {
  try {
    const response = await apiClient.post("/users", userData);
    return response.data;
  } catch (error) {
    throw new Error(
      "Lỗi khi đăng ký người dùng: " + error.response?.data?.message ||
        error.message
    );
  }
};
