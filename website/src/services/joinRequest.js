import apiClient from "../utils/apiClient";

const API_URL = "/join-requests";

class JoinRequestService {
  async getAllJoinRequests() {
    try {
      const response = await apiClient.get(API_URL);
      return response.data;
    } catch (error) {
      throw new Error(
        error.response?.data?.message ||
          "Không thể lấy danh sách yêu cầu tham gia"
      );
    }
  }

  async getJoinRequestById(id) {
    try {
      const response = await apiClient.get(`${API_URL}/${id}`);
      return response.data;
    } catch (error) {
      throw new Error(
        error.response?.data?.message ||
          "Không thể lấy thông tin yêu cầu tham gia"
      );
    }
  }

  async createJoinRequest(clubId = null, eventId = null) {
    try {
      const user = JSON.parse(localStorage.getItem("user"));
      if (!user || !user.id) {
        throw new Error("Vui lòng đăng nhập để đăng ký tham gia");
      }

      // Kiểm tra xem có truyền đúng một trong hai ID không
      if (!clubId && !eventId) {
        throw new Error("Vui lòng cung cấp ID của CLB hoặc sự kiện");
      }
      if (clubId && eventId) {
        throw new Error(
          "Chỉ được phép đăng ký tham gia CLB hoặc sự kiện, không phải cả hai"
        );
      }

      const requestData = {
        user_id: user.id,
        type: clubId ? "club" : "event",
        ...(clubId ? { club_id: clubId } : { event_id: eventId }),
      };

      const response = await apiClient.post(API_URL, requestData);
      return response.data;
    } catch (error) {
      throw new Error(
        error.response?.data?.message || "Không thể tạo yêu cầu tham gia"
      );
    }
  }

  async updateJoinRequest(id, requestData) {
    try {
      const response = await apiClient.patch(`${API_URL}/${id}`, requestData);
      return response.data;
    } catch (error) {
      throw new Error(
        error.response?.data?.message || "Không thể cập nhật yêu cầu tham gia"
      );
    }
  }

  async deleteJoinRequest(id) {
    try {
      const response = await apiClient.delete(`${API_URL}/${id}`);
      return response.data;
    } catch (error) {
      throw new Error(
        error.response?.data?.message || "Không thể xóa yêu cầu tham gia"
      );
    }
  }

  async getUserRequests() {
    try {
      const user = JSON.parse(localStorage.getItem("user"));
      if (!user || !user.id) {
        throw new Error("Vui lòng đăng nhập để xem yêu cầu tham gia");
      }

      const response = await apiClient.get(`${API_URL}/user/${user.id}`);
      return response.data;
    } catch (error) {
      throw new Error(
        error.response?.data?.message ||
          "Không thể lấy danh sách yêu cầu tham gia của người dùng"
      );
    }
  }

  // Thêm hàm mới để kiểm tra trạng thái đăng ký sự kiện
  async getEventJoinStatus(eventId) {
    try {
      const user = JSON.parse(localStorage.getItem("user"));
      if (!user || !user.id) {
        throw new Error("Vui lòng đăng nhập để xem trạng thái");
      }

      const response = await apiClient.get(
        `${API_URL}/check-event/${user.id}/${eventId}`
      );
      return response.data;
    } catch (error) {
      throw new Error(
        error.response?.data?.message ||
          "Không thể lấy trạng thái đăng ký sự kiện"
      );
    }
  }

  async checkEventParticipation(eventId) {
    try {
      const user = JSON.parse(localStorage.getItem("user"));
      if (!user || !user.id) {
        throw new Error("Vui lòng đăng nhập để kiểm tra trạng thái tham gia");
      }

      const response = await apiClient.get(
        `${API_URL}/check-event/${user.id}/${eventId}`
      );
      return response.data;
    } catch (error) {
      throw new Error(
        error.response?.data?.message ||
          "Không thể kiểm tra trạng thái tham gia"
      );
    }
  }

  async getClubJoinStatus(clubId) {
    try {
      const user = JSON.parse(localStorage.getItem("user"));
      if (!user || !user.id) {
        throw new Error("Vui lòng đăng nhập để kiểm tra trạng thái tham gia");
      }

      const response = await apiClient.get(
        `${API_URL}/check-club/${user.id}/${clubId}`
      );
      return response.data;
    } catch (error) {
      throw new Error(
        error.response?.data?.message ||
          "Không thể kiểm tra trạng thái tham gia CLB"
      );
    }
  }
}

export default new JoinRequestService();
