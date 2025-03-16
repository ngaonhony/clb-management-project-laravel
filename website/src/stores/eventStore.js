import { defineStore } from "pinia";
import { getEvents, getEventById } from "../services/event";
import { getUserEvents } from "../services/userEvent";
import EventService from "../services/event";

export const useEventStore = defineStore("event", {
  state: () => ({
    events: [], // Change back to array for simpler handling
    isLoading: false,
    error: null,
    lastFetched: null,
    selectedEvent: null,
    filters: {
      category: null,
      location: null,
      sortBy: null,
      searchQuery: "",
    },
  }),

  getters: {
    // Kiểm tra xem data có cần refresh không
    needsRefresh: (state) => {
      if (!state.lastFetched) return true;
      const CACHE_DURATION = 5 * 60 * 1000; // 5 minutes cache
      return Date.now() - state.lastFetched > CACHE_DURATION;
    },

    // Getter để lấy events đã được filter
    filteredEvents: (state) => {
      return state.events.filter(event => {
        const matchesSearch = !state.filters.searchQuery || 
          event.name.toLowerCase().includes(state.filters.searchQuery.toLowerCase()) ||
          event.description?.toLowerCase().includes(state.filters.searchQuery.toLowerCase());

        const matchesCategory = !state.filters.category || 
          event.category.id === state.filters.category;

        const matchesLocation = !state.filters.location || 
          event.location === state.filters.location;

        return matchesSearch && matchesCategory && matchesLocation;
      }).sort((a, b) => {
        switch (state.filters.sortBy) {
          case "date":
            return new Date(a.start_date) - new Date(b.start_date);
          case "name":
            return a.name.localeCompare(b.name);
          default:
            return 0;
        }
      });
    },
  },

  actions: {
    // Action để fetch events
    async fetchEvents(forceRefresh = false) {
      console.log('Fetching events...', { forceRefresh, needsRefresh: this.needsRefresh, currentEvents: this.events.length });
      
      if (!forceRefresh && !this.needsRefresh && this.events.length > 0) {
        console.log('Using cached events');
        return this.events;
      }

      this.isLoading = true;
      this.error = null;

      try {
        console.log('Making API call to fetch events...');
        const data = await getEvents();
        console.log('API response:', data);

        if (Array.isArray(data)) {
          this.events = data;
          this.lastFetched = Date.now();
          console.log('Events updated successfully:', this.events.length);
          return this.events;
        }
        throw new Error("Invalid data format received from API");
      } catch (err) {
        console.error("Error in fetchEvents:", err);
        this.error = err.message || "Failed to fetch events";
        throw err;
      } finally {
        this.isLoading = false;
      }
    },

    // Action để fetch một event cụ thể
    async fetchEventById(id) {
      console.log('Fetching event by ID:', id);
      const numericId = Number(id);
      const cachedEvent = this.events.find(e => e.id === numericId);
      
      if (cachedEvent && !this.needsRefresh) {
        console.log('Using cached event:', cachedEvent);
        this.selectedEvent = cachedEvent;
        return cachedEvent;
      }

      this.isLoading = true;
      this.error = null;

      try {
        console.log('Making API call to fetch event...');
        const data = await getEventById(numericId);
        console.log('API response:', data);

        if (data) {
          // Update in cache if exists
          const index = this.events.findIndex(e => e.id === numericId);
          if (index !== -1) {
            this.events[index] = data;
          } else {
            this.events.push(data);
          }
          
          this.selectedEvent = data;
          this.lastFetched = Date.now();
          return data;
        }
        throw new Error("Event not found");
      } catch (err) {
        console.error("Error in fetchEventById:", err);
        this.error = err.message || `Failed to fetch event with id ${id}`;
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
        searchQuery: "",
      };
    },

    // Action để fetch user events
    async fetchUserEvents(userId) {
      try {
        const events = await getUserEvents(userId);
        // Update cache
        events.forEach(event => {
          const index = this.events.findIndex(e => e.id === event.id);
          if (index !== -1) {
            this.events[index] = event;
          } else {
            this.events.push(event);
          }
        });
        return events;
      } catch (err) {
        console.error("Error in fetchUserEvents:", err);
        throw new Error(`Failed to fetch user events: ${err.message}`);
      }
    },

    // Action để fetch events của club
    async fetchClubEvents(clubId) {
      console.log('Fetching club events:', clubId);
      this.isLoading = true;
      this.error = null;

      try {
        const data = await EventService.getEventClub(clubId);
        console.log('Club events API response:', data);

        if (Array.isArray(data)) {
          const numericClubId = Number(clubId);
          // Remove old events for this club
          this.events = this.events.filter(e => e.club_id !== numericClubId);
          // Add new events
          this.events.push(...data);
          this.lastFetched = Date.now();
          return data;
        }
        throw new Error("No events found for this club");
      } catch (err) {
        console.error("Error in fetchClubEvents:", err);
        this.error = err.message || `Failed to fetch events for club with id ${clubId}`;
        throw err;
      } finally {
        this.isLoading = false;
      }
    },
  },
});
