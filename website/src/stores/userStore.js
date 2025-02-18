import { defineStore } from "pinia";
import { ref } from "vue";
import { getInfo } from "../services/user";

export const useUserStore = defineStore("user", {
  state: () => ({
    user: null,
    loading: false,
    error: null,
  }),
  actions: {
    async fetchUser(id) {
      this.loading = true;
      this.error = null;
      try {
        const data = await getInfo({}, id);
        this.user = data;
      } catch (error) {
        this.error = error.message;
      } finally {
        this.loading = false;
      }
    },
  },
});
