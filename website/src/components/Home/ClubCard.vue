<template>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- Các thẻ ClubCard -->
    <div
      v-for="club in clbs"
      :key="club.id"
      class="bg-white rounded-2xl shadow-lg overflow-hidden flex flex-col md:flex-row mb-6 transition-transform transform hover:scale-105">
      <!-- Nội dung bên trái -->
      <div class="pt-6 pr-6 pl-6 pb-4 flex-1">
        <div class="flex items-start gap-4">
          <!-- <div
            class="w-16 h-16 rounded-lg overflow-hidden rounded-2xl shadow-lg relative">
            <img
              :src="club.img"
              :alt="club.name"
              class="w-full h-full object-cover object-center rounded-2xl" />
          </div> -->

          <div class="flex-1">
            <span
              class="inline-block px-3 py-1 bg-green-100 text-green-700 text-sm font-medium rounded-full mb-2">
              {{ club.category_id }}
            </span>
            <h2 class="text-2xl font-bold text-gray-800 mb-2">
              {{ club.name }}
            </h2>
            <p class="text-gray-600 text-sm leading-relaxed mb-4">
              {{ club.description }}
            </p>
            <div class="flex items-center gap-4 text-sm text-gray-500">
              <div class="flex items-center gap-1">
                <MapPinIcon class="w-4 h-4 text-gray-400" />
                <span>{{ club.location }}</span>
              </div>
              <div class="flex items-center gap-1">
                <UsersIcon class="w-4 h-4 text-gray-400" />
                <span>{{ club.member_count }} thành viên</span>
              </div>
            </div>
          </div>
        </div>

        <router-link :to="`/clb/${club.id}`" class="mt-6 w
        -80 py-2 text-center border border-gray-300 text-gray-700 font-medium rounded
        -lg shadow-sm hover:bg-gray-200 transition-all duration-300 mx-auto block"> Chi tiết </router-link>
      </div>

      <!-- Hình ảnh bên phải -->
      <div class="w-full md:w-[400px] lg:h-[250px] relative overflow-hidden">
  <img
    :src="club.background_images[0]?.image_url"
    alt="Club background"
    class="w-full h-full object-cover" />
</div>
    </div>

    <!-- Nút Xem Thêm với đường kẻ -->
    <div class="flex items-center justify-center mt-10">
      <div class="border-t border-gray-300 w-full max-w-4xl"></div>
      <button
        class="mx-4 w-80 border p-2 rounded-lg hover:bg-gray-200 flex items-center justify-center text-gray-700">
        Xem Thêm
        <ChevronDown class="ml-2" />
      </button>
      <div class="border-t border-gray-300 w-full max-w-4xl"></div>
    </div>
  </div>
</template>

<script setup>
import { MapPinIcon, UsersIcon, ChevronDown } from "lucide-vue-next";
import { ref, onMounted } from 'vue';
import { useCLBStore } from "../../stores/clubStore";

const clbStore = useCLBStore();
const { clbs, isLoading, error, fetchClbs } = clbStore;

onMounted(() => {
  fetchClbs();
});

</script>
