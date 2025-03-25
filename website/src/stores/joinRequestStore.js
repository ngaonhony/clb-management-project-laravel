import { defineStore } from "pinia";
import JoinRequestService from "../services/joinRequest";

export const useJoinRequestStore = defineStore("joinRequest", {
  state: () => ({
    joinRequests: [],
    selectedRequest: null,
    isLoading: false,
    error: null,
    userRequests: [],
    cache: {
      requests: new Map(),
      lastFetched: null,
      cacheTimeout: 5 * 60 * 1000, // 5 minutes
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
  },

  actions: {
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
        this.userRequests.push(data); // Add to user requests
        this.cache.requests.clear(); // Clear cache on create
        return data;
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
        const data = await JoinRequestService.getEventJoinStatus(eventId);
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
        this.cache.requests.clear(); // Clear cache on update
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
        this.cache.requests.clear(); // Clear cache on delete
      } catch (error) {
        this.error = error.message;
        throw error;
      } finally {
        this.isLoading = false;
      }
    },

    async checkEventParticipation(eventId, forceRefresh = false) {
      const cacheKey = `participation_${eventId}`;
      if (!forceRefresh && this.cache.requests.has(cacheKey)) {
        const cached = this.cache.requests.get(cacheKey);
        if (Date.now() - cached.timestamp < this.cache.cacheTimeout) {
          this.participationStatus = cached.data;
          return cached.data;
        }
      }

      this.isLoading = true;
      this.error = null;

      try {
        const data = await JoinRequestService.checkEventParticipation(eventId);
        this.participationStatus = data;
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

    // Cache management
    clearCache() {
      this.cache.requests.clear();
      this.cache.lastFetched = null;
    },
  },
});
