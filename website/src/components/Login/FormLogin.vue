<template>
    <div class="min-h-screen flex items-center justify-center ">
      <div class="w-full max-w-sm p-6 space-y-6 bg-gray-50 rounded-lg shadow-lg">
        <!-- Header -->
        <h1 class="text-xl font-semibold text-center text-gray-800">
          Đăng Nhập
        </h1>
  
        <!-- Login Form -->
        <form @submit.prevent="handleSubmit" class="space-y-4">
          <!-- Username Input -->
          <div class="relative">
            <input
              type="text"
              v-model="formData.email"
              placeholder="Email"
              class="w-full px-8 py-2 border border-gray-300 rounded focus:border-blue-500 focus:outline-none text-gray-700"
              required
            />
            <UserIcon class="w-4 h-4 text-gray-400 absolute left-3 top-1/2 transform -translate-y-1/2" />
          </div>
  
          <!-- Password Input -->
          <div class="relative">
            <input
              type="password"
              v-model="formData.password"
              placeholder="Mật Khẩu"
              class="w-full px-8 py-2 border border-gray-300 rounded focus:border-blue-500 focus:outline-none text-gray-700"
              required
            />
            <LockIcon class="w-4 h-4 text-gray-400 absolute left-3 top-1/2 transform -translate-y-1/2" />
          </div>
  
          <!-- Login Button -->
          <button
            type="submit"
            class="w-full py-2 px-4 text-white rounded bg-blue-500 hover:bg-blue-600 transition-all"
          >
            Đăng Nhập
          </button>
  
          <!-- Sign Up Link -->
          <div class="text-center mt-4">
            <p class="text-gray-500 text-sm">Chưa có tài khoản?</p>
            <router-link to="/register" class="text-blue-500 font-semibold hover:underline">
              Đăng Ký
            </router-link>
          </div>
        </form>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref } from 'vue'
  import { UserIcon, LockIcon } from 'lucide-vue-next'
  import { login } from '../../services/auth'
  import { useRouter } from "vue-router";

  const router = useRouter();

  const formData = ref({
    email: "",
    password: "",
  })

  const errorMessage = ref("");
  const successMessage = ref("");
  
  const handleSubmit = async () => {
    try {
      errorMessage.value = "";
      const response = await login(formData.value);
      successMessage.value = "Đăng nhập thành công!";

      await new Promise(resolve => setTimeout(resolve, 300));
      router.push("/");
    } catch (error) {
      errorMessage.value = error.response?.data?.message || error.message;
    }
  }
  </script>
  