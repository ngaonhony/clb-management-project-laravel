<template>
    <header class="text-white shadow-md bg-white">
    <div class="container mx-auto flex justify-between items-center py-3">
      <!-- Logo -->
      <router-link to="/" class="flex items-center">
        <img src="../assets/vaa.svg" alt="Logo" class="h-10 mr-3" />
        <div>
          <h1 class="font-bold text-lg" style="color: #b3995d">
            HỌC VIỆN HÀNG KHÔNG VIỆT NAM
          </h1>
          <p class="text-sm font-light" style="color: #b3995d">
            VIETNAM AVIATION ACADEMY
          </p>
        </div>
      </router-link>

      <!-- Navigation -->
      <nav class="flex items-center space-x-8">
        <div class="relative group">
          <button class="hover:text-gray-300 flex items-center text-black">
            Câu lạc bộ
            <svg
              class="w-4 h-4 ml-1"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="currentColor">
              <path d="M12 16l-6-6h12l-6 6z" />
            </svg>
          </button>
          <!-- Dropdown -->
          <div
            class="absolute left-0 mt-2 bg-white text-black shadow-md rounded hidden group-hover:block w-40">
            <ul>
              <li class="hover:bg-gray-100 px-4 py-2"><a href="#">CLB 1</a></li>
              <li class="hover:bg-gray-100 px-4 py-2"><a href="#">CLB 2</a></li>
            </ul>
          </div>
        </div>
        <router-link to="/event" class="hover:text-gray-300 text-black">
          Sự kiện
        </router-link>
        <router-link to="/blog-list-page" class="hover:text-gray-300 text-black">
          Bài viết
        </router-link>
      </nav>

      <!-- User Actions -->
      <div class="flex items-center space-x-4">
        <router-link v-if="isLoggedIn" to="/manage-club-page">
          <button class="flex items-center bg-white border-solid border-2 px-4 py-2 rounded hover:bg-gray-200 text-black">
            Quản lý CLB
          </button>
        </router-link>
        <button>
          <svg
            class="w-6 h-6 text-black hover:text-gray-300"
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            fill="currentColor">
            <path
              d="M12 22c5.523 0 10-4.477 10-10S17.523 2 12 2 2 6.477 2 12s4.477 10 10 10zm-1-7h2v2h-2v-2zm0-8h2v6h-2V7z" />
          </svg>
        </button>
        <DropDownMenu :options="dropdownOptions" @select="handleSelect">
          <template #trigger>
            <img
              :src="userAvatar"
              :alt="isLoggedIn ? 'User Avatar' : 'Default Avatar'"
              class="w-8 h-8 hover:opacity-75 rounded-full object-cover" />
          </template>
        </DropDownMenu>
      </div>
    </div>
    <div>
  </div>
  </header>
</template>

<script>
import { ref, computed, onMounted } from 'vue';
import Image1 from "../assets/avatar.jpg";
import DropDownMenu from "../components/DropDownMenu.vue";
import { UserRoundPen, LogOut, User } from "lucide-vue-next";
import { useAuthStore } from '../stores/authStore';
import { useRouter } from 'vue-router';

export default {
  name: "HeaderComponent",
  components: {
    DropDownMenu,
  },
  setup() {
    const authStore = useAuthStore();
    const router = useRouter();
    
    // Khởi tạo store khi component được mount
    onMounted(() => {
      authStore.initializeStore();
    });
    
    const userAvatar = computed(() => {
      return authStore.userAvatar || Image1;
    });

    const isLoggedIn = computed(() => {
      return authStore.isAuthenticated;
    });
    
    return { authStore, router, userAvatar, isLoggedIn };
  },
  data() {
    return {
      Image1,
      dropdownOptions: [],
    };
  },
  watch: {
    isLoggedIn: {
      immediate: true,
      handler(newValue) {
        this.updateDropdownOptions(newValue);
      },
    },
  },
  methods: {
    updateDropdownOptions(isLoggedIn) {
      if (isLoggedIn) {
        this.dropdownOptions = [
          { label: "Trang Cá Nhân", icon: UserRoundPen },
          { label: "Đăng Xuất", icon: LogOut },
        ];
      } else {
        this.dropdownOptions = [{ label: "Đăng Nhập", icon: User }];
      }
    },
    async handleSelect(option) {
      if (option.label === "Trang Cá Nhân") {
        this.$router.push("/profile");
      } else if (option.label === "Đăng Xuất") {
        try {
          await this.authStore.logout();
          await this.$router.push("/login");
          window.location.reload();
        } catch (error) {
          console.error('Lỗi khi đăng xuất:', error);
        }
      } else if (option.label === "Đăng Nhập") {
        this.$router.push("/login");
      }
    },
  },
};
</script>

