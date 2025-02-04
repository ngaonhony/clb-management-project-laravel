<template>
  <div class="min-h-screen flex items-center justify-center ">
    <div class="w-full max-w-sm p-6 space-y-6 bg-gray-50 rounded-lg shadow-lg">
      <!-- Header -->
      <h1 class="text-xl font-semibold text-center text-gray-800">Đăng Ký</h1>
 <!-- Success Message -->
      <p v-if="successMessage" class="text-green-500 text-sm text-center">
        {{ successMessage }}
      </p>
      <!-- Registration Form -->
      <form @submit.prevent="handleSubmit" class="space-y-4">
        <!-- Username Input -->
        <div class="relative">
          <input
            type="text"
            v-model="formData.username"
            placeholder="Username"
            class="w-full px-8 py-2 border border-gray-300 rounded focus:border-blue-500 focus:outline-none text-gray-700"
            required
          />
          <UserIcon class="w-4 h-4 text-gray-400 absolute left-3 top-1/2 transform -translate-y-1/2" />
        </div>

        <!-- Email Input -->
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

        <!-- Phone Input -->
        <div class="relative">
          <input
            type="text"
            v-model="formData.phone"
            placeholder="Số Điện Thoại"
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

        <!-- Repeat Password Input -->
        <div class="relative">
          <input
            type="password"
            v-model="repeatPassword"
            placeholder="Nhập Lại Mật Khẩu"
            class="w-full px-8 py-2 border border-gray-300 rounded focus:border-blue-500 focus:outline-none text-gray-700"
            required
          />
          <RectangleEllipsis class="w-4 h-4 text-gray-400 absolute left-3 top-1/2 transform -translate-y-1/2" />
        </div>

        <!-- Error Message -->
        <p v-if="errorMessage" class="text-red-500 text-sm">{{ errorMessage }}</p>

        <!-- Register Button -->
        <button
          type="submit"
          class="w-full py-2 px-4 text-white rounded bg-blue-500 hover:bg-blue-600 transition-all"
        >
          Đăng Ký
        </button>

        <!-- Sign In Link -->
        <div class="text-center mt-4">
          <p class="text-gray-500 text-sm">Đã có tài khoản?</p>
          <router-link to="/login" class="text-blue-500 font-semibold hover:underline">
            Đăng Nhập
          </router-link>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";
import { UserIcon, LockIcon, RectangleEllipsis } from "lucide-vue-next";
import { register } from "../../services/auth";
import { useRouter } from "vue-router";

const router = useRouter();

const formData = ref({
  username: "",
  email: "",
  password: "",
  phone: "",
});

const repeatPassword = ref("");
const errorMessage = ref("");
const successMessage = ref("");

const handleSubmit = async () => {
  if (formData.value.password !== repeatPassword.value) {
    errorMessage.value = "Mật khẩu không khớp!";
    return;
  }

  try {
    errorMessage.value = "";
    const response = await register(formData.value);
    console.log("Đăng ký thành công:", response);
    successMessage.value = "Đăng ký thành công! Bạn sẽ được chuyển hướng đến trang đăng nhập.";

    console.log("Chuyển hướng đến trang đăng nhập...");
    await new Promise(resolve => setTimeout(resolve, 300));
    router.push("/login");
  } catch (error) {
    errorMessage.value = error.response?.data?.message || error.message;
  }
};
</script>
