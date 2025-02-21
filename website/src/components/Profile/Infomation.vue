<template>
  <div class="flex justify-center items-center min-h-screen bg-gray-50">
    <div class="bg-white p-8 rounded-lg shadow-lg w-full max-w-md">
      <div class="flex flex-col items-center">
        <div class="relative">
          <img
            :src="profile?.backgroundImages?.[0]?.image_url || defaultAvatar"
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
        <div class="mb-4">
          <span class="font-semibold">Email:</span>
          <p class="text-gray-700">{{ profile.email }}</p>
        </div>
        <div class="mb-4">
          <span class="font-semibold">Số điện thoại:</span>
          <div v-if="editMode.phone" class="flex items-center mt-2">
            <input
              v-model="editableData.phone"
              class="flex-grow mr-2 p-2 border rounded"
            />
            <button @click="saveEdit('phone')" class="bg-indigo-500 text-white px-3 py-1 rounded">Lưu</button>
            <!-- <button @click="cancelEdit('phone')" class="ml-2 bg-gray-300 px-3 py-1 rounded">
              <X class="w-4 h-4" />
            </button> -->
          </div>
          <div v-else class="flex justify-between items-center">
            <p class="text-gray-700">{{ profile.phone }}</p>
            <Pencil class="w-5 h-5 text-indigo-500 cursor-pointer" @click="editField('phone')" />
          </div>
        </div>
        <div class="mb-4">
          <span class="font-semibold">Mô tả:</span>
          <div v-if="editMode.description" class="mt-2">
            <textarea
              v-model="editableData.description"
              class="w-full p-2 border rounded mb-2"
              rows="3"
            ></textarea>
            <div class="flex justify-end">
              <button @click="saveEdit('description')" class="bg-indigo-500 text-white px-3 py-1 rounded">Lưu</button>
              <!-- <button @click="cancelEdit('description')" class="ml-2 bg-gray-300 px-3 py-1 rounded">
                <X class="w-4 h-4" />
              </button> -->
            </div>
          </div>
          <div v-else class="flex justify-between items-start">
            <p class="text-gray-700">{{ profile.description }}</p>
            <Pencil class="w-5 h-5 text-indigo-500 cursor-pointer" @click="editField('description')" />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted, computed } from "vue";
import { useAuthStore } from "../../stores/authStore.js";
import { Pencil, Camera } from "lucide-vue-next";
import defaultAvatar from "../../assets/1.webp";

export default {
  components: { Pencil, Camera },
  setup() {
    const authStore = useAuthStore();
    const profile = computed(() => authStore.user);
    const fileInput = ref(null);

    const editMode = ref({
      phone: false,
      description: false,
    });

    const editableData = ref({
      phone: "",
      description: "",
    });

    onMounted(() => {
      authStore.fetchUserInfo();
    });

    const editField = (field) => {
      editMode.value[field] = true;
      editableData.value[field] = profile.value[field] || "";
    };

    const saveEdit = async (field) => {
      try {
        await authStore.updateUserInfo({ [field]: editableData.value[field] });
        editMode.value[field] = false;
      } catch (error) {
        console.error("Lỗi khi cập nhật:", error);
      }
    };

    const triggerFileInput = () => {
      fileInput.value.click();
    };

    const onFileSelected = async (event) => {
      const file = event.target.files[0];
      if (file) {
        try {
          const formData = new FormData();
          formData.append("image", file);

          await authStore.uploadAvatar(formData);
          alert("Cập nhật ảnh đại diện thành công!");
        } catch (error) {
          console.error("Lỗi khi tải ảnh lên:", error);
        }
      }
    };

    return {
      profile,
      editMode,
      editableData,
      editField,
      saveEdit,
      fileInput,
      triggerFileInput,
      onFileSelected,
      defaultAvatar,
    };
  },
};
</script>
