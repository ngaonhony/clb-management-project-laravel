import { defineStore } from "pinia";
import { ref } from "vue";
import { getCategories, getCategoryById } from "../services/category";

export const useCategoryStore = defineStore("category", () => {
  // State
  const categories = ref([]); // Danh sách danh mục
  const selectedCategory = ref(null); // Danh mục được chọn
  const isLoading = ref(false);
  const error = ref(null);

  // Action: Lấy danh sách danh mục
  const fetchCategories = async () => {
    isLoading.value = true;
    error.value = null;
    try {
      const data = await getCategories();
      categories.value = data; // Cập nhật danh sách danh mục
    } catch (err) {
      error.value = "Failed to fetch categories";
    } finally {
      isLoading.value = false;
    }
  };

  // Action: Lấy chi tiết danh mục theo ID
  const fetchCategoryById = async (id) => {
    isLoading.value = true;
    error.value = null;
    try {
      const data = await getCategoryById(id);
      selectedCategory.value = data; // Lưu thông tin danh mục vào state
    } catch (err) {
      error.value = `Failed to fetch category with ID ${id}`;
    } finally {
      isLoading.value = false;
    }
  };

  return {
    categories,
    selectedCategory,
    isLoading,
    error,
    fetchCategories,
    fetchCategoryById,
  };
});