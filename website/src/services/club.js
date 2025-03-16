import apiClient from "../utils/apiClient";

const API_URL = "/clubs";

class ClubService {
  async getAllClubs() {
    const response = await apiClient.get(API_URL);
    return response.data;
  }

  async getClubById(id) {
    const response = await apiClient.get(`${API_URL}/${id}`);
    return response.data;
  }

  async createClub(clubData) {
    const response = await apiClient.post(API_URL, clubData);
    return response.data;
  }

  async updateClub(id, clubData) {
    const response = await apiClient.patch(`${API_URL}/${id}`, clubData);
    return response.data;
  }

  async deleteClub(id) {
    const response = await apiClient.delete(`${API_URL}/${id}`);
    return response.data;
  }

  async uploadLogo(clubId, formData) {
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
  }

  async uploadCover(clubId, formData) {
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
  }

  async getClubsOfUser(userId) {
    const response = await apiClient.get(`${API_URL}/user/${userId}`);
    return response.data;
  }

}

export default new ClubService();
