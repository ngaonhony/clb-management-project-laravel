import { defineStore } from "pinia";
import { getEvents, getEventById } from "../services/event";
import { getUserEvents } from "../services/userEvent";

export const useEventStore = defineStore("event", {
  state: () => ({
    events: [],
    isLoading: false,
    error: null,
    lastFetched: null,
    selectedEvent: null,
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

    // Getter để lấy events đã được filter
    filteredEvents: (state) => {
      let filtered = [...state.events]

      if (state.filters.searchQuery) {
        const query = state.filters.searchQuery.toLowerCase()
        filtered = filtered.filter(event => 
          event.name.toLowerCase().includes(query) ||
          event.description.toLowerCase().includes(query)
        )
      }

      if (state.filters.category) {
        filtered = filtered.filter(event => 
          event.category.id === state.filters.category
        )
      }

      if (state.filters.location) {
        filtered = filtered.filter(event => 
          event.location === state.filters.location
        )
      }

      if (state.filters.sortBy) {
        switch (state.filters.sortBy) {
          case 'date':
            filtered.sort((a, b) => new Date(a.start_date) - new Date(b.start_date))
            break
          case 'name':
            filtered.sort((a, b) => a.name.localeCompare(b.name))
            break
        }
      }

      return filtered
    }
  },

  actions: {
    // Action để fetch events
    async fetchEvents(forceRefresh = false) {
      // Kiểm tra cache
      if (!forceRefresh && !this.needsRefresh && this.events.length > 0) {
        console.log('Using cached events data');
        return this.events;
      }

      this.isLoading = true;
      this.error = null;

      try {
        console.log('Fetching fresh events data');
        const data = await getEvents();
        
        if (Array.isArray(data)) {
          this.events = data;
          this.lastFetched = Date.now();
          return this.events;
        } else {
          throw new Error('Invalid data format received from API');
        }
      } catch (err) {
        this.error = err.message || 'Failed to fetch events';
        console.error('Error fetching events:', err);
        throw err; // Re-throw để component có thể xử lý
      } finally {
        this.isLoading = false;
      }
    },

    // Action để fetch một event cụ thể
    async fetchEventById(id) {
      // Kiểm tra cache
      const existingEvent = this.events.find(e => e.id === id);
      if (existingEvent && !this.needsRefresh) {
        console.log('Using cached event data');
        this.selectedEvent = existingEvent;
        return existingEvent;
      }

      this.isLoading = true;
      this.error = null;

      try {
        console.log('Fetching fresh event data');
        const data = await getEventById(id);
        
        if (data) {
          this.selectedEvent = data;
          // Cập nhật cache nếu event chưa có trong list
          if (!existingEvent) {
            this.events.push(data);
          }
          return data;
        }
        throw new Error('Event not found');
      } catch (err) {
        this.error = err.message || `Failed to fetch event with id ${id}`;
        console.error('Error fetching event:', err);
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
    },

    // Action để fetch user events
    async fetchUserEvents(userId) {
      try {
        return await getUserEvents(userId);
      } catch (err) {
        throw new Error(`Failed to fetch user events: ${err.message}`);
      }
    }
  }
});
