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
      console.log('Preparing FormData for club update:', clubData);
      const formData = new FormData();

      // Add basic info
      Object.keys(clubData).forEach(key => {
        if (key !== 'logo' && key !== 'images' && key !== 'deleted_image_ids') {
          formData.append(key, clubData[key] || '');
        }
      });

      // Add logo if exists
      if (clubData.logo) {
        console.log('Adding logo to FormData');
        formData.append('logo', clubData.logo);
      }

      // Add images if exists
      if (clubData.images && clubData.images.length > 0) {
        console.log('Adding images to FormData');
        clubData.images.forEach(image => {
          formData.append('images[]', image);
        });
      }

      // Add deleted image IDs if exists
      if (clubData.deleted_image_ids && clubData.deleted_image_ids.length > 0) {
        console.log('Adding deleted image IDs to FormData');
        formData.append('deleted_image_ids', clubData.deleted_image_ids.join(','));
      }

      // Log FormData entries for debugging
      console.log('FormData entries before sending:');
      for (let pair of formData.entries()) {
        console.log(pair[0] + ':', pair[1]);
      }

      const response = await apiClient.post(`${API_URL}/${id}`, formData, {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      });
      
      console.log('Update club response:', response.data);
      return response;
    } catch (error) {
      console.error('Error in updateClub:', error);
      if (error.response?.status === 422) {
        throw error;
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
      throw new Error("Không thể tải danh sách câu lạc bộ của người dùng: " + error.message);
    }
  }
}

export default new ClubService();
