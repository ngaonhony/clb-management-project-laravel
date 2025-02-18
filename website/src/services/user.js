import apiClient from "../utils/apiClient";

export const getInfo = async (userData, id) => {
  try {
    const response = await apiClient.post(`users/${id}`, userData);
    return response.data;
  } catch (error) {
    throw new Error(
      "Lỗi khi get thong tin người dùng: " + error.response?.data?.message ||
        error.message
    );
  }
};
