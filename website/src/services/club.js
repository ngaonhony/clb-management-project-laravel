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
        const errorMessages = Object.values(validationErrors).flat().join(", ");
        throw new Error("Lỗi xác thực: " + errorMessages);
      }
      throw new Error("Không thể tạo câu lạc bộ: " + error.message);
    }
  }

  async updateClub(id, clubData) {
    try {
      const formData = new FormData();
      
      // Add basic club data with proper type conversion
      Object.keys(clubData).forEach(key => {
        if (key !== 'logo' && key !== 'images' && key !== 'deleted_image_ids') {
          // Convert null/undefined to empty string for text fields
          const value = clubData[key] === null || clubData[key] === undefined ? '' : clubData[key];
          formData.append(key, value);
        }
      });

      // Add logo if exists
      if (clubData.logo) {
        formData.append('logo', clubData.logo);
      }

      // Add images if exists
      if (clubData.images && clubData.images.length > 0) {
        clubData.images.forEach(image => {
          formData.append('images[]', image);
        });
      }

      // Add deleted image IDs if exists
      if (clubData.deleted_image_ids && clubData.deleted_image_ids.length > 0) {
        formData.append('deleted_image_ids', clubData.deleted_image_ids.join(','));
      }

      // Log form data for debugging
      for (let pair of formData.entries()) {
        console.log(pair[0] + ': ' + pair[1]);
      }

      const response = await apiClient.post(`${API_URL}/${id}`, formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      });
      return response;
    } catch (error) {
      if (error.response?.status === 422) {
        // Validation error
        const validationErrors = error.response.data.errors;
        const errorMessages = Object.values(validationErrors).flat().join(", ");
        throw new Error("Lỗi xác thực: " + errorMessages);
      }
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

  async getClubsOfUser(userId) {
    try {
      const response = await apiClient.get(`${API_URL}/user/${userId}`);
      return response.data;
    } catch (error) {
      throw new Error(
        "Không thể tải danh sách câu lạc bộ của người dùng: " + error.message
      );
    }
  }
}

export default new ClubService();
