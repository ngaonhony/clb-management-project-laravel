import apiClient from "../utils/apiClient";

const API_URL = '/blogs';

class BlogService {
    async getAllBlogs() {
        const response = await apiClient.get(API_URL);
        return response.data;
    }

    async getBlogById(id) {
        const response = await apiClient.get(`${API_URL}/${id}`);
        return response.data;
    }

    async createBlog(blogData) {
        const response = await apiClient.post(API_URL, blogData, {
            headers: {
                'Content-Type': 'multipart/form-data'
            }
        });
        return response.data;
    }

    async updateBlog(id, blogData) {
        const response = await apiClient.post(`${API_URL}/${id}`, blogData, {
            headers: {
                'Content-Type': 'multipart/form-data'
            }
        });
        return response.data;
    }

    async deleteBlog(id) {
        const response = await apiClient.delete(`${API_URL}/${id}`);
        return response.data;
    }
}

export default new BlogService(); 