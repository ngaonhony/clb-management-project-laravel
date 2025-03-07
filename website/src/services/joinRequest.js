import apiClient from "../utils/apiClient";

const API_URL = '/join-requests';

class JoinRequestService {
    async getAllJoinRequests() {
        const response = await apiClient.get(API_URL);
        return response.data;
    }

    async getJoinRequestById(id) {
        const response = await apiClient.get(`${API_URL}/${id}`);
        return response.data;
    }

    async createJoinRequest(requestData) {
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
}

export default new JoinRequestService(); 