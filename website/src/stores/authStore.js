import { defineStore } from "pinia";
import { login } from "../services/auth";
import { getInfo, updateInfo } from "../services/user";

export const useAuthStore = defineStore("auth", {
  state: () => ({
    user: JSON.parse(localStorage.getItem("user")) || null,
    accessToken: localStorage.getItem("accessToken") || null,
    isAuthenticated: !!localStorage.getItem("accessToken"),
    token: null,
  }),

  actions: {
    async loginUser(userData) {
      try {
        const data = await login(userData);
        this.user = data.user;
        this.accessToken = data.access_token;
        this.isAuthenticated = true;
        localStorage.setItem("accessToken", this.accessToken);
        localStorage.setItem("user", JSON.stringify(this.user));
        return data;
      } catch (error) {
        throw error;
      }
    },

    async fetchUserInfo() {
      if (!this.accessToken) {
        console.warn(
          "Không có accessToken, không thể lấy thông tin người dùng."
        );
        return;
      }
      try {
        const userData = await getInfo(this.user?.id);
        this.user = userData;
        localStorage.setItem("user", JSON.stringify(this.user));
      } catch (error) {
        console.error("Lỗi khi lấy thông tin người dùng:", error);
      }
    },

    async updateUserInfo(userData) {
      if (!this.accessToken) {
        console.warn(
          "Không có accessToken, không thể cập nhật thông tin người dùng."
        );
        return;
      }
      try {
        const updatedUser = await updateInfo(this.user.id, userData);
        this.user = updatedUser;
        localStorage.setItem("user", JSON.stringify(this.user));
        return updatedUser;
      } catch (error) {
        throw error;
      }
    },

    checkAuth() {
      const token = localStorage.getItem("accessToken");
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
      localStorage.removeItem("accessToken");
      localStorage.removeItem("user");
      this.token = null;
    },

    setToken(token) {
      this.token = token;
    },
  },
});
