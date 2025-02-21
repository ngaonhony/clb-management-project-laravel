import apiClient from "../utils/apiClient";

export const getInfo = async (id) => {
  try {
    const response = await apiClient.get(`users/${id}`);
    return response.data;
  } catch (error) {
    throw new Error(
      "Lỗi khi get thong tin người dùng: " + error.response?.data?.message ||
        error.message
    );
  }
};

export const updateInfo = async (id, data) => {
  try {
    const response = await apiClient.patch(`users/${id}`, data);
    return response.data;
  } catch (error) {
    throw new Error(
      "Lỗi khi cap nhat thong tin người dùng: " +
        error.response?.data?.message || error.message
    );
  }
};
