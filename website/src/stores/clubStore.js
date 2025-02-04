import { defineStore } from "pinia";
import { ref } from "vue";
import { getCLBs, getClbById } from "../services/clubs";

export const useCLBStore = defineStore("clb", () => {
  // State
  const clbs = ref([]); // Danh sách CLB
  const selectedClb = ref(null); // Thông tin CLB chi tiết
  const isLoading = ref(false);
  const error = ref(null);

  // Actions
  const fetchClbs = async () => {
    isLoading.value = true;
    error.value = null;
    try {
      const data = await getCLBs();
      clbs.value = data;
    } catch (err) {
      error.value = "Failed to fetch clubs";
    } finally {
      isLoading.value = false;
    }
  };

  const fetchClbById = async (id) => {
    isLoading.value = true;
    error.value = null;
    try {
      const data = await getClbById(id);
      console.log(data);
      selectedClb.value = data; // Lưu thông tin CLB vào state
    } catch (err) {
      error.value = `Failed to fetch club with ID ${id}`;
    } finally {
      isLoading.value = false;
    }
  };

  return {
    clbs,
    selectedClb,
    isLoading,
    error,
    fetchClbs,
    fetchClbById,
  };
});
