import axios from 'axios';
import { API_URL } from '../config';

class FeedbackService {
    async getAllFeedbacks() {
        try {
            const response = await axios.get(`${API_URL}/feedbacks`);
            return response.data;
        } catch (error) {
            throw error;
        }
    }

    async getFeedback(id) {
        try {
            const response = await axios.get(`${API_URL}/feedbacks/${id}`);
            return response.data;
        } catch (error) {
            throw error;
        }
    }

    async createFeedback(feedbackData) {
        try {
            const response = await axios.post(`${API_URL}/feedbacks`, feedbackData);
            return response.data;
        } catch (error) {
            throw error;
        }
    }

    async updateFeedback(id, feedbackData) {
        try {
            const response = await axios.patch(`${API_URL}/feedbacks/${id}`, feedbackData);
            return response.data;
        } catch (error) {
            throw error;
        }
    }

    async deleteFeedback(id) {
        try {
            const response = await axios.delete(`${API_URL}/feedbacks/${id}`);
            return response.data;
        } catch (error) {
            throw error;
        }
    }
}

export default new FeedbackService();