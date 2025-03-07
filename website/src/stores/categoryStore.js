import { defineStore } from "pinia";
import { ref } from "vue";
import { getCategories, getCategoryById } from "../services/category";

export const useCategoryStore = defineStore("category", {
  state: () => ({
    categories: [
      { id: 1, name: 'Học thuật, Chuyên môn', value: 'academic' },
      { id: 2, name: 'Nghệ thuật, Sáng tạo', value: 'art' },
      { id: 3, name: 'Thể thao', value: 'sport' },
      { id: 4, name: 'Tình nguyện', value: 'volunteer' },
      { id: 5, name: 'Văn hóa', value: 'culture' },
      { id: 6, name: 'Công nghệ', value: 'technology' }
    ],
    selectedCategory: null,
    isLoading: false,
    error: null
  }),
  getters: {
    getCategoryById: (state) => (id) => {
      return state.categories.find(cat => cat.id === id)
    },
    getCategoryByValue: (state) => (value) => {
      return state.categories.find(cat => cat.value === value)
    }
  },
  actions: {
    // Action: Lấy danh sách danh mục
    async fetchCategories() {
      this.isLoading = true;
      this.error = null;
      try {
        const data = await getCategories();
        this.categories = data; // Cập nhật danh sách danh mục
      } catch (err) {
        this.error = "Failed to fetch categories";
      } finally {
        this.isLoading = false;
      }
    },

    // Action: Lấy chi tiết danh mục theo ID
    async fetchCategoryById(id) {
      this.isLoading = true;
      this.error = null;
      try {
        const data = await getCategoryById(id);
        this.selectedCategory = data; // Lưu thông tin danh mục vào state
      } catch (err) {
        this.error = `Failed to fetch category with ID ${id}`;
      } finally {
        this.isLoading = false;
      }
    }
  }
});