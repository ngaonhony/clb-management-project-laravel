import { defineStore } from "pinia";
import { login } from "../services/auth";
import UserService from "../services/user";

export const useAuthStore = defineStore("auth", {
  state: () => ({
    user: JSON.parse(localStorage.getItem("user")) || null,
    accessToken: localStorage.getItem("access_token") || null,
    isAuthenticated: !!localStorage.getItem("access_token"),
  }),

  getters: {
    currentUser: (state) => state.user,
    userAvatar: (state) => state.user?.backgroundImages?.[0]?.image_url || null,
  },

  actions: {
    async loginUser(userData) {
      try {
        const data = await login(userData);
        this.user = data.user;
        this.accessToken = data.access_token;
        this.isAuthenticated = true;
        localStorage.setItem("access_token", this.accessToken);
        localStorage.setItem("user", JSON.stringify(this.user));
        return data;
      } catch (error) {
        throw error;
      }
    },

    async fetchUserInfo() {
      if (!this.accessToken) {
        console.warn("Không có accessToken, không thể lấy thông tin người dùng.");
        return;
      }
      try {
        const userData = await UserService.getUserById(this.user?.id);
        this.user = { ...userData };
        localStorage.setItem("user", JSON.stringify(this.user));
        return userData;
      } catch (error) {
        console.error("Lỗi khi lấy thông tin người dùng:", error);
        throw error;
      }
    },

    async updateUserInfo(userData) {
      if (!this.accessToken) {
        throw new Error("Không có accessToken, không thể cập nhật thông tin người dùng.");
      }
      try {
        const updatedUser = await UserService.updateUser(this.user.id, userData);
        const freshUserData = await UserService.getUserById(this.user.id);
        this.user = { ...freshUserData };
        localStorage.setItem("user", JSON.stringify(this.user));
        return freshUserData;
      } catch (error) {
        throw error;
      }
    },

    initializeStore() {
      const token = localStorage.getItem("access_token");
      const user = localStorage.getItem("user");
      if (token && user) {
        this.accessToken = token;
        this.user = JSON.parse(user);
        this.isAuthenticated = true;
      }
    },

    async logout() {
      this.user = null;
      this.accessToken = null;
      this.isAuthenticated = false;
      localStorage.removeItem("access_token");
      localStorage.removeItem("user");
    },
  },
});
