import apiClient from "../utils/apiClient";

const API_URL = '/users';

// Individual API functions
export const getInfo = async (id) => {
    const response = await apiClient.get(`${API_URL}/${id}`);
    return response.data;
};

export const updateInfo = async (id, data) => {
    const response = await apiClient.patch(`${API_URL}/${id}`, data);
    return response.data;
};

// UserService class
class UserService {
    async getAllUsers() {
        const response = await apiClient.get(API_URL);
        return response.data;
    }

    async getUserById(id) {
        return getInfo(id);
    }

    async createUser(userData) {
        const response = await apiClient.post(API_URL, userData);
        return response.data;
    }

    async updateUser(id, userData) {
        return updateInfo(id, userData);
    }

    async deleteUser(id) {
        const response = await apiClient.delete(`${API_URL}/${id}`);
        return response.data;
    }

    async uploadAvatar(userId, formData) {
        const response = await apiClient.post(`${API_URL}/${userId}/avatar`, formData, {
            headers: {
                'Content-Type': 'multipart/form-data'
            }
        });
        return response.data;
    }

    async updateProfile(id, profileData) {
        const response = await apiClient.patch(`${API_URL}/${id}/profile`, profileData);
        return response.data;
    }
}

export default new UserService();
