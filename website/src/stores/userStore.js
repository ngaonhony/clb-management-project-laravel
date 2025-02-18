// import { defineStore } from "pinia";
// import { ref } from "vue";
// import { getInfo } from "../services/user";

// export const useUserStore = defineStore("user", {
//   state: () => ({
//     user: null,
//     loading: false,
//     error: null,
//   }),
//   actions: {
//     async fetchUser(id) {
//       if (!id) {
//         console.warn("ID không hợp lệ, không thể fetch thông tin người dùng.");
//         return;
//       }

//       this.loading = true;
//       this.error = null;
//       try {
//         console.log(`Fetching user data for ID: ${id}`);
//         const data = await getInfo(id);
//         this.user = data;
//       } catch (error) {
//         this.error = error.message;
//         console.error("Lỗi khi lấy thông tin user:", error);
//       } finally {
//         this.loading = false;
//       }
//     },
//   },
// });
