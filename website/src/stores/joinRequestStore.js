import { defineStore } from 'pinia';
import JoinRequestService from '../services/joinRequest';

export const useJoinRequestStore = defineStore('joinRequest', {
    state: () => ({
        joinRequests: [],
        currentJoinRequest: null,
        loading: false,
        error: null
    }),

    getters: {
        getJoinRequestById: (state) => (id) => {
            return state.joinRequests.find(request => request.id === id);
        }
    },

    actions: {
        async fetchJoinRequests() {
            this.loading = true;
            try {
                const data = await JoinRequestService.getAllJoinRequests();
                this.joinRequests = data;
                this.error = null;
            } catch (error) {
                this.error = error.message;
                console.error('Error fetching join requests:', error);
            } finally {
                this.loading = false;
            }
        },

        async fetchJoinRequestById(id) {
            this.loading = true;
            try {
                const data = await JoinRequestService.getJoinRequestById(id);
                this.currentJoinRequest = data;
                this.error = null;
            } catch (error) {
                this.error = error.message;
                console.error('Error fetching join request:', error);
            } finally {
                this.loading = false;
            }
        },

        async createJoinRequest(requestData) {
            this.loading = true;
            try {
                const data = await JoinRequestService.createJoinRequest(requestData);
                this.joinRequests.push(data);
                this.error = null;
                return data;
            } catch (error) {
                this.error = error.message;
                console.error('Error creating join request:', error);
                throw error;
            } finally {
                this.loading = false;
            }
        },

        async updateJoinRequest(id, requestData) {
            this.loading = true;
            try {
                const data = await JoinRequestService.updateJoinRequest(id, requestData);
                const index = this.joinRequests.findIndex(request => request.id === id);
                if (index !== -1) {
                    this.joinRequests[index] = data;
                }
                this.error = null;
                return data;
            } catch (error) {
                this.error = error.message;
                console.error('Error updating join request:', error);
                throw error;
            } finally {
                this.loading = false;
            }
        },

        async deleteJoinRequest(id) {
            this.loading = true;
            try {
                await JoinRequestService.deleteJoinRequest(id);
                this.joinRequests = this.joinRequests.filter(request => request.id !== id);
                this.error = null;
            } catch (error) {
                this.error = error.message;
                console.error('Error deleting join request:', error);
                throw error;
            } finally {
                this.loading = false;
            }
        }
    }
}); 