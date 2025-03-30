import { defineStore } from "pinia";
import ClubService from "../services/club";

export const useClubStore = defineStore("club", {
  state: () => ({
    clubs: [],
    selectedClub: null,
    isLoading: false,
    error: null,
    lastFetched: null,
    filters: {
      category: null,
      location: null,
      sortBy: null,
      searchQuery: ''
    }
  }),

  getters: {
    // Kiểm tra xem data có cần refresh không
    needsRefresh: (state) => {
      if (!state.lastFetched) return true
      const CACHE_DURATION = 5 * 60 * 1000 // Cache 5 phút
      return Date.now() - state.lastFetched > CACHE_DURATION
    },

    // Getter để lấy clubs đã được filter
    filteredClubs: (state) => {
      let filtered = [...state.clubs]

      // Tìm kiếm theo tên và mô tả
      if (state.filters.searchQuery) {
        const query = state.filters.searchQuery.toLowerCase().trim()
        filtered = filtered.filter(club => {
          const nameMatch = club.name?.toLowerCase().includes(query) || false
          const descMatch = club.description?.toLowerCase().includes(query) || false
          return nameMatch || descMatch
        })
      }

      // Lọc theo danh mục
      if (state.filters.category) {
        filtered = filtered.filter(club => 
          club.category_id === state.filters.category
        )
      }

      // Lọc theo địa điểm
      if (state.filters.location) {
        filtered = filtered.filter(club => 
          club.province === state.filters.location
        )
      }

      // Sắp xếp kết quả
      if (state.filters.sortBy) {
        switch (state.filters.sortBy) {
          case 'newest':
            filtered.sort((a, b) => new Date(b.created_at) - new Date(a.created_at))
            break
          case 'popular':
            filtered.sort((a, b) => b.member_count - a.member_count)
            break
          case 'name':
            filtered.sort((a, b) => a.name.localeCompare(b.name, 'vi'))
            break
        }
      }

      return filtered
    }
  },

  actions: {
    // Action để fetch clubs
    async fetchClubs(forceRefresh = false) {
      // Kiểm tra cache
      if (!forceRefresh && !this.needsRefresh && this.clubs.length > 0) {
        console.log('Using cached clubs data');
        return this.clubs;
      }

      this.isLoading = true;
      this.error = null;

      try {
        console.log('Fetching fresh clubs data');
        const data = await ClubService.getAllClubs();
        
        if (Array.isArray(data)) {
          this.clubs = data;
          this.lastFetched = Date.now();
          return this.clubs;
        } else {
          throw new Error('Invalid data format received from API');
        }
      } catch (err) {
        this.error = err.message || 'Failed to fetch clubs';
        console.error('Error fetching clubs:', err);
        throw err;
      } finally {
        this.isLoading = false;
      }
    },

    // Action để fetch một club cụ thể
    async fetchClubById(id) {
      this.isLoading = true;
      this.error = null;

      try {
        const data = await ClubService.getClubById(id);
        this.selectedClub = data;
        return data;
      } catch (err) {
        this.error = err.message;
        throw err;
      } finally {
        this.isLoading = false;
      }
    },

    // Action để tạo club mới
    async createClub(clubData) {
      this.isLoading = true;
      this.error = null;

      try {
        const newClub = await ClubService.createClub(clubData);
        this.clubs.push(newClub);
        return newClub;
      } catch (err) {
        this.error = err.message || 'Failed to create club';
        console.error('Error creating club:', err);
        throw err;
      } finally {
        this.isLoading = false;
      }
    },

    // Action để cập nhật club
    async updateClub(id, clubData) {
      this.isLoading = true;
      this.error = null;

      try {
        const updatedClub = await ClubService.updateClub(id, clubData);
        const index = this.clubs.findIndex(c => c.id === id);
        if (index !== -1) {
          this.clubs[index] = updatedClub;
        }
        if (this.selectedClub?.id === id) {
          this.selectedClub = updatedClub;
        }
        return updatedClub;
      } catch (err) {
        this.error = err.message || `Failed to update club with id ${id}`;
        console.error('Error updating club:', err);
        throw err;
      } finally {
        this.isLoading = false;
      }
    },

    // Action để xóa club
    async deleteClub(id) {
      this.isLoading = true;
      this.error = null;

      try {
        await ClubService.deleteClub(id);
        this.clubs = this.clubs.filter(c => c.id !== id);
        if (this.selectedClub?.id === id) {
          this.selectedClub = null;
        }
      } catch (err) {
        this.error = err.message || `Failed to delete club with id ${id}`;
        console.error('Error deleting club:', err);
        throw err;
      } finally {
        this.isLoading = false;
      }
    },

    // Action để lấy danh sách câu lạc bộ của người dùng
    async fetchUserClubs(userId) {
      this.isLoading = true;
      this.error = null;

      try {
        const data = await ClubService.getClubsOfUser(userId);
        this.clubs = data;
        return data;
      } catch (err) {
        this.error = err.message || 'Failed to fetch user clubs';
        console.error('Error fetching user clubs:', err);
        throw err;
      } finally {
        this.isLoading = false;
      }
    },

    // Actions cho filters
    setFilter(filterType, value) {
      this.filters[filterType] = value;
    },

    resetFilters() {
      this.filters = {
        category: null,
        location: null,
        sortBy: null,
        searchQuery: ''
      };
    }
  }
});