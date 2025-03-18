import apiClient from "../utils/apiClient";

const API_URL = "/clubs";

class ClubService {
  async getAllClubs() {
    try {
      const response = await apiClient.get(API_URL);
      return response.data;
    } catch (error) {
      throw new Error("Không thể tải danh sách câu lạc bộ: " + error.message);
    }
  }

  async getClubById(id) {
    try {
      const response = await apiClient.get(`${API_URL}/${id}`);
      return response.data;
    } catch (error) {
      throw new Error("Không thể tải thông tin câu lạc bộ: " + error.message);
    }
  }

  async createClub(clubData) {
    try {
      const response = await apiClient.post(API_URL, clubData);
      return response.data;
    } catch (error) {
      if (error.response?.status === 422) {
        // Validation error
        const validationErrors = error.response.data.errors;
        const errorMessages = Object.values(validationErrors).flat().join(', ');
        throw new Error("Lỗi xác thực: " + errorMessages);
      }
      throw new Error("Không thể tạo câu lạc bộ: " + error.message);
    }
  }

  async updateClub(id, clubData) {
    try {
      const response = await apiClient.patch(`${API_URL}/${id}`, clubData);
      return response.data;
    } catch (error) {
      throw new Error("Không thể cập nhật câu lạc bộ: " + error.message);
    }
  }

  async deleteClub(id) {
    try {
      const response = await apiClient.delete(`${API_URL}/${id}`);
      return response.data;
    } catch (error) {
      throw new Error("Không thể xóa câu lạc bộ: " + error.message);
    }
  }

  async uploadLogo(clubId, formData) {
    try {
      const response = await apiClient.post(
        `${API_URL}/${clubId}/logo`,
        formData,
        {
          headers: {
            "Content-Type": "multipart/form-data",
          },
        }
      );
      return response.data;
    } catch (error) {
      throw new Error("Không thể tải lên logo: " + error.message);
    }
  }

  async uploadCover(clubId, formData) {
    try {
      const response = await apiClient.post(
        `${API_URL}/${clubId}/cover`,
        formData,
        {
          headers: {
            "Content-Type": "multipart/form-data",
          },
        }
      );
      return response.data;
    } catch (error) {
      throw new Error("Không thể tải lên ảnh bìa: " + error.message);
    }
  }

  async getClubsOfUser(userId) {
    try {
      const response = await apiClient.get(`${API_URL}/user/${userId}`);
      return response.data;
    } catch (error) {
      throw new Error("Không thể tải danh sách câu lạc bộ của người dùng: " + error.message);
    }
  }
}

export default new ClubService();
