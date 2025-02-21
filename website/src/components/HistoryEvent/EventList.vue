<template>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- Search Section -->
    <div class="container mx-auto px-4 py-6">
      <div class="flex gap-4 flex-wrap">
        <div class="flex-1 min-w-[200px]">
          <div class="relative">
            <SearchIcon class="w-5 h-5 absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" />
            <input type="text" placeholder="Tìm kiếm Sự kiện"
              class="w-full pl-10 pr-4 py-2 border rounded-md border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500" />
          </div>
        </div>
        <select class="border rounded-md px-4 py-2 bg-white border-gray-300">
          <option>Loại sự kiện</option>
        </select>
        <select class="border rounded-md px-4 py-2 bg-white border-gray-300">
          <option>Khu vực</option>
        </select>
        <select class="border rounded-md px-4 py-2 bg-white border-gray-300">
          <option>Sắp xếp theo</option>
        </select>
        <button class="px-4 py-2 bg-gray-100 rounded-md hover:bg-gray-200 transition-colors">
          Bộ lọc
        </button>
      </div>
    </div>

    <!-- Events List -->
    <div class="container mx-auto px-4 py-8">
      <div class="space-y-16 lg:space-y-20">
        <div v-for="event in events" :key="event.id"
          class="w-full grid grid-cols-12 gap-4 md:gap-10 cursor-pointer h-[300px] transition-transform transform hover:scale-105"
          @click="goToEventDetail(event.id)">
          <div class="col-span-12 md:col-span-5 overflow-hidden rounded-2xl shadow-lg relative">
            <img :src="event.event.background_images[0]?.image_url" :alt="event.event.club.name" class="w-full h-full object-cover object-center rounded-2xl" />
          </div>
          <div class="col-span-12 md:col-span-7 flex flex-col justify-between p-4 bg-white rounded-2xl shadow-md">
            <div class="flex flex-col h-full justify-between">
              <div class="flex justify-between items-center mb-2">
                <div class="text-sm font-medium px-2 py-1 rounded-md w-max bg-accent-red-600 text-base-white">
                  {{ event.event.club.category.name }}
                </div>
              </div>
              <h3 class="text-xl font-semibold text-gray-800">
                {{ event.event.name }}
              </h3>
              <div class="flex items-center text-gray-600 mb-2">
                <UserIcon class="w-4 h-4 mr-2" />
                <span class="text-lg">{{ event.event.club.name }}</span>
              </div>
              <div class="flex items-center text-gray-600 mb-2">
                <MapPinIcon class="w-4 h-4 mr-2" />
                <span class="text-lg">{{ event.event.location }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import { useAuthStore } from "../../stores/authStore";
import { useEventStore } from "../../stores/eventStore";
import { UserIcon, MapPinIcon, SearchIcon } from "lucide-vue-next";

const router = useRouter();
const events = ref([]);
const authStore = useAuthStore();
const eventStore = useEventStore();

// Lấy ID của user hiện tại
const userId = authStore.user?.id;

const fetchUserEvents = async () => {
  if (!userId) {
    console.warn("User chưa đăng nhập!");
    return;
  }
  try {
    events.value = await eventStore.fetchUserEvent(userId);
  } catch (error) {
    console.error("Lỗi khi lấy sự kiện người dùng:", error.message);
  }
};

onMounted(() => {
  fetchUserEvents();
});

const goToEventDetail = (id) => {
  router.push({ path: `/detail-event-page/${id}` });
};
</script>

  <style>
  .bg-accent-red-600 {
    background-color: #dc2626;
  }
  
  .text-base-white {
    color: #ffffff;
  }
  </style>
  