import { defineStore } from "pinia";
import { ref } from "vue";
import { getEvents, getEventById } from "../services/event";

export const useEventStore = defineStore("event", () => {
  // Danh sach Event
  const events = ref([]);
  // Thong tin event chi tiet
  const selectedEvent = ref(null);
  const isLoading = ref(false);
  const error = ref(null);

  // Actions
  const fetchEvents = async () => {
    isLoading.value = true;
    error.value = null;
    try {
      const data = await getEvents();
      events.value = data;
    } catch (err) {
      error.value = "Failed to fetch Events";
    } finally {
      isLoading.data = false;
    }
  };

  const fetchEventById = async (id) => {
    isLoading.value = true;
    error.value = null;
    try {
      const data = await getEventById(id);
      console.log(data);
      selectedEvent.value = data; // Lưu thông tin CLB vào state
    } catch (err) {
      error.value = `Failed to fetch event with ID $ ${id}`;
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
  };
});
