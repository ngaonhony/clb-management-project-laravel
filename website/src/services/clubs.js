import axios from "axios";

const apiClient = axios.create({
  baseURL: "http://127.0.0.1:8000/api",
  headers: {
    "Content-Type": "application/json",
  },
});

// Hàm lấy danh sách các CLB
export const getCLBs = async () => {
  try {
    const response = await apiClient.get("/clubs");
    return response.data;
  } catch (error) {
    throw new Error("Lỗi khi lấy danh sách CLB: " + error.message);
  }
};

// Hàm lấy chi tiết CLB theo ID
export const getClbById = async (id) => {
  try {
    const response = await apiClient.get(`/clubs/${id}`);
    return response.data;
  } catch (error) {
    throw new Error("Lỗi khi lấy chi tiết CLB: " + error.message);
  }
};
