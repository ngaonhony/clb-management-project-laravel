import { defineStore } from "pinia";

export const useAuthStore = defineStore("auth", {
  state: () => ({
    userId: null,
  }),
  actions: {
    setUserId(id) {
      this.userId = id;
    },
    logout() {
      this.userId = null;
    },
  },
});
