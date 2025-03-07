import apiClient from "../utils/apiClient";

const API_URL = '/departments';

class DepartmentService {
    async getAllDepartments() {
        const response = await apiClient.get(API_URL);
        return response.data;
    }

    async getDepartmentById(id) {
        const response = await apiClient.get(`${API_URL}/${id}`);
        return response.data;
    }

    async createDepartment(departmentData) {
        const response = await apiClient.post(API_URL, departmentData);
        return response.data;
    }

    async updateDepartment(id, departmentData) {
        const response = await apiClient.patch(`${API_URL}/${id}`, departmentData);
        return response.data;
    }

    async deleteDepartment(id) {
        const response = await apiClient.delete(`${API_URL}/${id}`);
        return response.data;
    }
}

export default new DepartmentService(); 