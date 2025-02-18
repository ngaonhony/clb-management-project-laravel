<template>
  <div class="flex justify-center items-center min-h-screen bg-gray-50">
    <div class="bg-white p-8 rounded-lg shadow-lg w-full max-w-md">
      <div class="flex flex-col items-center">
        <div class="relative">
          <img
            :src="profile.image"
            alt="Profile Picture"
            class="w-32 h-32 rounded-full mb-4 border-4 border-indigo-500 cursor-pointer hover:opacity-50 transition-opacity duration-300"
            @click="triggerFileInput"
          />
          <div class="absolute bottom-0 right-0 bg-indigo-500 rounded-full p-2 cursor-pointer" @click="triggerFileInput">
            <Camera class="w-5 h-5 text-white" />
          </div>
        </div>
        <input
          type="file"
          ref="fileInput"
          @change="onFileSelected"
          accept="image/*"
          class="hidden"
        />
        <h2 class="text-2xl font-bold flex items-center gap-2">
          {{ profile.name }}
        </h2>
        <p class="text-gray-500">{{ profile.studentId }}</p>
      </div>
      <div class="mt-6">
        <div class="mb-4 flex justify-between items-center">
          <div>
            <span class="font-semibold">Email:</span>
            <p class="text-gray-700">{{ profile.email }}</p>
          </div>
        </div>
        <div class="mb-4 flex justify-between items-center">
          <div>
            <span class="font-semibold">Số điện thoại:</span>
            <p class="text-gray-700">{{ profile.phone }}</p>
          </div>
          <Pencil class="w-5 h-5 text-indigo-500 cursor-pointer" @click="editField('phone')" />
        </div>
        <div class="mb-4 flex justify-between items-center">
          <div>
            <span class="font-semibold">Mô tả:</span>
            <p class="text-gray-700">{{ profile.description }}</p>
          </div>
          <Pencil class="w-5 h-5 text-indigo-500 cursor-pointer" @click="editField('description')" />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref } from "vue";
import Image1 from "../../assets/1.webp";
import { Pencil, Camera } from "lucide-vue-next";
import { useUserStore } from "../../stores/userStore";
import { useAuthStore } from "../../stores/authStore";

export default {
  components: {
    Pencil,
    Camera,
  },
  setup() {
    const authStore = useAuthStore();
    const userStore = useUserStore();
    
    // Lấy dữ liệu user từ store
    const userId = authStore.userId;
    const userData = userStore.fetchUser(userId) || {}; 

    const fileInput = ref(null);
    const profile = ref({
      image: userData.image || Image1,
      name: userData.name || "Error",
      studentId: userData.studentId || "MSV123456",
      email: userData.email || "nguyenvana@example.com",
      phone: userData.phone || "0123-456-789",
      description:
        userData.description ||
        "Sinh viên năm 3 ngành CNTT, yêu thích lập trình web và mobile.",
    });

    const triggerFileInput = () => {
      fileInput.value.click();
    };

    const onFileSelected = (event) => {
      const file = event.target.files[0];
      if (file) {
        const reader = new FileReader();
        reader.onload = (e) => {
          profile.value.image = e.target.result;
        };
        reader.readAsDataURL(file);
      }
    };

    const editField = (field) => {
      const newValue = prompt(`Chỉnh sửa ${field}:`, profile.value[field]);
      if (newValue !== null) {
        profile.value[field] = newValue;
      }
    };

    return {
      fileInput,
      profile,
      triggerFileInput,
      onFileSelected,
      editField,
    };
  },
};
</script>
