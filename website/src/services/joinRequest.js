import apiClient from "../utils/apiClient";

const API_URL = "/join-requests";

class JoinRequestService {
  async getAllJoinRequests() {
    const response = await apiClient.get(API_URL);
    return response.data;
  }

  async getJoinRequestById(id) {
    const response = await apiClient.get(`${API_URL}/${id}`);
    return response.data;
  }

  async createJoinRequest(clubId) {
    const user = JSON.parse(localStorage.getItem('user'));
    if (!user || !user.id) {
      throw new Error('Vui lòng đăng nhập để đăng ký tham gia CLB');
    }

    const requestData = {
      club_id: clubId,
      user_id: user.id
    };
    
    const response = await apiClient.post(API_URL, requestData);
    return response.data;
  }

  async updateJoinRequest(id, requestData) {
    const response = await apiClient.patch(`${API_URL}/${id}`, requestData);
    return response.data;
  }

  async deleteJoinRequest(id) {
    const response = await apiClient.delete(`${API_URL}/${id}`);
    return response.data;
  }

  // Get join request status
  async getClubJoinStatus(clubId) {
    try {
      const user = JSON.parse(localStorage.getItem('user'));
      if (!user || !user.id) {
        throw new Error('Vui lòng đăng nhập để xem trạng thái');
      }

      const response = await apiClient.get(`${API_URL}/status/${clubId}?user_id=${user.id}`);
      return response.data;
    } catch (error) {
      throw error.response?.data || error.message;
    }
  }
}

export default new JoinRequestService();
