import apiClient from "../utils/apiClient";

export const getUserEvents = async (id) => {
  try {
    const response = await apiClient.get(`user-events/${id}`);
    return response.data;
  } catch (error) {
    throw new Error(
      "Lỗi khi get su kien người dùng tham gia: " + error.response?.data?.message ||
        error.message
    );
  }
};
