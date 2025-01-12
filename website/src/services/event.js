import axios from "axios";

const apiClient = axios.create({
  baseURL: "http://127.0.0.1:8000/api",
  headers: {
    "Content-Type": "application/json",
  },
});

// Hàm lấy danh sách các Event
export const getEvents = async () => {
  try {
    const response = await apiClient.get("/events");
    return response.data;
  } catch (error) {
    throw new Error("Lỗi khi lấy danh sách Event: " + error.message);
  }
};

// Hàm lấy chi tiết Event theo ID
export const getEventById = async (id) => {
  try {
    const response = await apiClient.get(`/events/${id}`);
    return response.data;
  } catch (error) {
    throw new Error("Lỗi khi lấy chi tiết Event: " + error.message);
  }
};
