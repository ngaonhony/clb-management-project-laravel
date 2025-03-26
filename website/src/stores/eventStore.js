import { defineStore } from "pinia";
import EventService from "../services/event";

export const useEventStore = defineStore("event", {
  state: () => ({
    events: [],
    selectedEvent: null,
    isLoading: false,
    error: null,
    filters: {
      category: null,
      location: null,
      sortBy: null,
      searchQuery: "",
    },
    pagination: {
      currentPage: 1,
      perPage: 10,
      total: 0,
    },
    cache: {
      events: new Map(),
      lastFetched: null,
      cacheTimeout: 5 * 60 * 1000, // 5 minutes
    },
  }),

  getters: {
    filteredEvents: (state) => {
      const filtered = state.events.filter((event) => {
        const matchesSearch =
          !state.filters.searchQuery ||
          event.name.toLowerCase().includes(state.filters.searchQuery.toLowerCase()) ||
          event.description?.toLowerCase().includes(state.filters.searchQuery.toLowerCase());

        const matchesCategory =
          !state.filters.category ||
          event.category.id === state.filters.category;

        const matchesLocation =
          !state.filters.location ||
          event.location === state.filters.location;

        return matchesSearch && matchesCategory && matchesLocation;
      });

      // Apply sorting
      if (state.filters.sortBy) {
        filtered.sort((a, b) => {
          switch (state.filters.sortBy) {
            case "date":
              return new Date(a.start_date) - new Date(b.start_date);
            case "name":
              return a.name.localeCompare(b.name);
            default:
              return 0;
          }
        });
      }

      // Apply pagination
      const start = (state.pagination.currentPage - 1) * state.pagination.perPage;
      const end = start + state.pagination.perPage;
      return filtered.slice(start, end);
    },

    isCacheValid: (state) => {
      if (!state.cache.lastFetched) return false;
      return Date.now() - state.cache.lastFetched < state.cache.cacheTimeout;
    },
  },

  actions: {
    async fetchEvents(forceRefresh = false) {
      if (!forceRefresh && this.isCacheValid) {
        return this.events;
      }

      this.isLoading = true;
      this.error = null;

      try {
        const data = await EventService.getEvents();
        this.events = data;
        this.cache.events.set('all', data);
        this.cache.lastFetched = Date.now();
        this.pagination.total = data.length;
        return data;
      } catch (error) {
        this.error = error.message;
        throw error;
      } finally {
        this.isLoading = false;
      }
    },

    async fetchEventById(id, forceRefresh = false) {
      const cacheKey = `event_${id}`;
      if (!forceRefresh && this.cache.events.has(cacheKey)) {
        const cachedEvent = this.cache.events.get(cacheKey);
        if (Date.now() - cachedEvent.timestamp < this.cache.cacheTimeout) {
          this.selectedEvent = cachedEvent.data;
          return cachedEvent.data;
        }
      }

      this.isLoading = true;
      this.error = null;

      try {
        const data = await EventService.getEventById(id);
        this.selectedEvent = data;
        
        // Update cache
        this.cache.events.set(cacheKey, {
          data,
          timestamp: Date.now()
        });

        // Update in events array if exists
        const index = this.events.findIndex((e) => e.id === id);
        if (index !== -1) {
          this.events[index] = data;
        } else {
          this.events.push(data);
        }

        return data;
      } catch (error) {
        this.error = error.message;
        throw error;
      } finally {
        this.isLoading = false;
      }
    },

    async fetchClubEvents(clubId, forceRefresh = false) {
      const cacheKey = `club_${clubId}`;
      if (!forceRefresh && this.cache.events.has(cacheKey)) {
        const cachedEvents = this.cache.events.get(cacheKey);
        if (Date.now() - cachedEvents.timestamp < this.cache.cacheTimeout) {
          this.events = cachedEvents.data;
          return cachedEvents.data;
        }
      }

      this.isLoading = true;
      this.error = null;

      try {
        const data = await EventService.getEventClub(clubId);
        this.events = data;
        
        // Update cache
        this.cache.events.set(cacheKey, {
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

    async createEvent(eventData) {
      this.isLoading = true;
      this.error = null;

      try {
        const data = await EventService.createEvent(eventData);
        this.events.push(data);
        this.cache.events.clear(); // Clear cache on create
        return data;
      } catch (error) {
        this.error = error.message;
        throw error;
      } finally {
        this.isLoading = false;
      }
    },

    async updateEvent(id, eventData) {
      this.isLoading = true;
      this.error = null;

      try {
        const data = await EventService.updateEvent(id, eventData);
        const index = this.events.findIndex((e) => e.id === id);
        if (index !== -1) {
          this.events[index] = data;
        }
        if (this.selectedEvent?.id === id) {
          this.selectedEvent = data;
        }
        this.cache.events.clear(); // Clear cache on update
        return data;
      } catch (error) {
        this.error = error.message;
        throw error;
      } finally {
        this.isLoading = false;
      }
    },

    async deleteEvent(id) {
      this.isLoading = true;
      this.error = null;

      try {
        await EventService.deleteEvent(id);
        this.events = this.events.filter((e) => e.id !== id);
        if (this.selectedEvent?.id === id) {
          this.selectedEvent = null;
        }
        this.cache.events.clear(); // Clear cache on delete
      } catch (error) {
        this.error = error.message;
        throw error;
      } finally {
        this.isLoading = false;
      }
    },

    // Filter actions
    setFilter(filterType, value) {
      this.filters[filterType] = value;
      this.pagination.currentPage = 1; // Reset to first page when filters change
    },

    resetFilters() {
      this.filters = {
        category: null,
        location: null,
        sortBy: null,
        searchQuery: "",
      };
      this.pagination.currentPage = 1;
    },

    // Pagination actions
    setPage(page) {
      this.pagination.currentPage = page;
    },

    setPerPage(perPage) {
      this.pagination.perPage = perPage;
      this.pagination.currentPage = 1;
    },

    // Cache management
    clearCache() {
      this.cache.events.clear();
      this.cache.lastFetched = null;
    },
  },
});
