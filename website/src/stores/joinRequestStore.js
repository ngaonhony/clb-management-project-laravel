import { defineStore } from "pinia";
import JoinRequestService from "../services/joinRequest";

export const useJoinRequestStore = defineStore("joinRequest", {
  state: () => ({
    joinRequests: [],
    selectedRequest: null,
    isLoading: false,
    error: null,
    userRequests: [],
    participationStatus: null,
    cache: {
      requests: new Map(),
      lastFetched: null,
      cacheTimeout: 5 * 60 * 1000, // 5 phút
    },
  }),

  getters: {
    isCacheValid: (state) => {
      if (!state.cache.lastFetched) return false;
      return Date.now() - state.cache.lastFetched < state.cache.cacheTimeout;
    },

    getEventRequestStatus: (state) => (eventId) => {
      const request = state.userRequests.find(
        (req) => req.event_id === eventId && req.type === "event"
      );
      return request ? request.status : null;
    },

    getApprovedClubMembers: (state) => (clubId) => {
      return state.joinRequests.filter(
        (req) => req.club_id === clubId && req.status === "approved" && req.type === "club"
      );
    },
  },

  actions: {
    async fetchClubMembers(clubId, forceRefresh = false) {
      const cacheKey = `club_members_${clubId}`;
      if (!forceRefresh && this.cache.requests.has(cacheKey)) {
        const cached = this.cache.requests.get(cacheKey);
        if (Date.now() - cached.timestamp < this.cache.cacheTimeout) {
          this.joinRequests = cached.data;
          return cached.data;
        }
      }

      this.isLoading = true;
      this.error = null;
  
      try {
          const data = await JoinRequestService.getClubRequests(clubId);
          this.joinRequests = data;
          this.cache.requests.set(cacheKey, {
            data,
            timestamp: Date.now()
          });
          return data;
      } catch (error) {
          this.error = error.message;
          throw error;
      } finally {
          this.isLoading = false;
      }
  },

    async fetchUserRequests(forceRefresh = false) {
      const cacheKey = 'user_requests';
      if (!forceRefresh && this.cache.requests.has(cacheKey)) {
        const cached = this.cache.requests.get(cacheKey);
        if (Date.now() - cached.timestamp < this.cache.cacheTimeout) {
          this.userRequests = cached.data;
          return cached.data;
        }
      }

      this.isLoading = true;
      this.error = null;

      try {
        const data = await JoinRequestService.getUserRequests();
        this.userRequests = data;
        this.cache.requests.set(cacheKey, {
          data,
          timestamp: Date.now()
        });
        return data;
      } catch (error) {
        this.error = error.message;
        throw error;
      } finally {
        this.isLoading = false;
      }
    },

    async createJoinRequest(clubId = null, eventId = null) {
      this.isLoading = true;
      this.error = null;

      try {
        const data = await JoinRequestService.createJoinRequest(clubId, eventId);
        this.joinRequests.push(data);
        this.userRequests.push(data);
        this.cache.requests.clear(); // Xóa cache khi tạo yêu cầu mới
        return data;
      } catch (error) {
        this.error = error.message;
        throw error;
      } finally {
        this.isLoading = false;
      }
    },

    async updateJoinRequest(id, requestData) {
      this.isLoading = true;
      this.error = null;

      try {
        const data = await JoinRequestService.updateJoinRequest(id, requestData);
        const index = this.joinRequests.findIndex((r) => r.id === id);
        if (index !== -1) {
          this.joinRequests[index] = data;
        }
        if (this.selectedRequest?.id === id) {
          this.selectedRequest = data;
        }
        this.cache.requests.clear(); // Xóa cache khi cập nhật yêu cầu
        return data;
      } catch (error) {
        this.error = error.message;
        throw error;
      } finally {
        this.isLoading = false;
      }
    },

    async deleteJoinRequest(id) {
      this.isLoading = true;
      this.error = null;

      try {
        await JoinRequestService.deleteJoinRequest(id);
        this.joinRequests = this.joinRequests.filter((r) => r.id !== id);
        if (this.selectedRequest?.id === id) {
          this.selectedRequest = null;
        }
        this.cache.requests.clear(); // Xóa cache khi xóa yêu cầu
      } catch (error) {
        this.error = error.message;
        throw error;
      } finally {
        this.isLoading = false;
      }
    },

    async getEventJoinStatus(eventId, forceRefresh = false) {
      const cacheKey = `event_status_${eventId}`;
      if (!forceRefresh && this.cache.requests.has(cacheKey)) {
        const cached = this.cache.requests.get(cacheKey);
        if (Date.now() - cached.timestamp < this.cache.cacheTimeout) {
          return cached.data;
        }
      }

      this.isLoading = true;
      this.error = null;

      try {
        const data = await JoinRequestService.checkEventStatus(eventId);
        this.cache.requests.set(cacheKey, {
          data,
          timestamp: Date.now()
        });
        return data;
      } catch (error) {
        this.error = error.message;
        throw error;
      } finally {
        this.isLoading = false;
      }
    },

    async getClubJoinStatus(clubId, forceRefresh = false) {
      const cacheKey = `club_status_${clubId}`;
      if (!forceRefresh && this.cache.requests.has(cacheKey)) {
        const cached = this.cache.requests.get(cacheKey);
        if (Date.now() - cached.timestamp < this.cache.cacheTimeout) {
          return cached.data;
        }
      }

      this.isLoading = true;
      this.error = null;

      try {
        const data = await JoinRequestService.checkClubStatus(clubId);
        this.cache.requests.set(cacheKey, {
          data,
          timestamp: Date.now()
        });
        return data;
      } catch (error) {
        this.error = error.message;
        throw error;
      } finally {
        this.isLoading = false;
      }
    },

    // Quản lý cache
    clearCache() {
      this.cache.requests.clear();
      this.cache.lastFetched = null;
    },
  },
});