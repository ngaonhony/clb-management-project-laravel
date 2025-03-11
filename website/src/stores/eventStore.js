import { defineStore } from "pinia";
import { ref } from "vue";
import {
  getEvents,
  getEventById,
  getClbEvent,
} from "../services/event";
import { getUserEvents } from "../services/userEvent";

export const useEventStore = defineStore("event", () => {
  // Danh sách Event
  const events = ref([]);
  // Thông tin event chi tiết
  const selectedEvent = ref(null);
  const isLoading = ref(false);
  const error = ref(null);

  // Actions
  const fetchEvents = async () => {
    isLoading.value = true;
    error.value = null;
    try {
      events.value = await getEvents();
    } catch (err) {
      error.value = "Failed to fetch events";
    } finally {
      isLoading.value = false;
    }
  };

  const fetchEventById = async (id) => {
    isLoading.value = true;
    error.value = null;
    try {
      selectedEvent.value = await getEventById(id);
    } catch (err) {
      error.value = `Failed to fetch event with ID ${id}`;
    } finally {
      isLoading.value = false;
    }
  };

  const fetchUserEvent = async (id) => {
    try {
      return await getUserEvents(id);
    } catch (err) {
      throw new Error(`Failed to fetch user events: ${err.message}`);
    }
  };

  const fetchEventClb = async (id) => {
    isLoading.value = true;
    error.value = null;
    try {
      const response = await getClbEvent(id); // Gọi API
      events.value = response; // Gán dữ liệu vào events
      console.log("Data from API:", response); // Kiểm tra dữ liệu từ API
    } catch (err) {
      error.value = `Failed to fetch events: ${err.message}`;
      throw new Error(`Failed to fetch Clb Event: ${err.message}`);
    } finally {
      isLoading.value = false;
    }
  };

  return {
    events,
    selectedEvent,
    isLoading,
    error,
    fetchEventById,
    fetchEvents,
    fetchUserEvent,
    fetchEventClb,
  };
});
