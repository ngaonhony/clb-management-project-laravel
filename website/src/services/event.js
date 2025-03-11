import apiClient from "../utils/apiClient";

export const createEvent = async (eventData) => {
  const formData = new FormData();
  formData.append("name", eventData.name);
  formData.append("location", eventData.location);
  formData.append("category_id", eventData.category_id);
  formData.append("club_id", eventData.club_id);
  formData.append("start_date", eventData.start_date);
  formData.append("end_date", eventData.end_date);
  if (eventData.image) {
    formData.append("image", eventData.image);
  }

  try {
    const response = await apiClient.post("/events", formData, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });
    return response.data;
  } catch (error) {
    throw new Error("Lỗi Create Event: " + error.message);
  }
};

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

// Lay Event cua CLB
export const getClbEvent = async (id) => {
  try {
    const response = await apiClient.get(`/events/club/${id}`);
    return response.data;
  } catch (error) {
    throw new Error("Lỗi khi lấy Event cua CLB: " + error.message);
  }
};

export const updateEvent = async (id, eventData) => {
  const formData = new FormData();
  formData.append("name", eventData.name);
  formData.append("location", eventData.location);
  formData.append("category_id", eventData.category_id);
  formData.append("club_id", eventData.club_id);
  formData.append("start_date", eventData.start_date);
  formData.append("end_date", eventData.end_date);
  if (eventData.image) {
    formData.append("image", eventData.image);
  }

  try {
    const response = await apiClient.patch(`/events/${id}`, formData, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });
    return response.data;
  } catch (error) {
    throw new Error("Lỗi Create Event: " + error.message);
  }
};

export const deleteEvent = async (id) => {
  try {
    return await apiClient.delete(`/events/${id}`);
  } catch (error) {
    throw new Error("Lỗi khi xoa Event: " + error.message);
  }
};
