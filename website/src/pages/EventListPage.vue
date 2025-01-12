<template>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- Hero Section -->
    <div class="text-center py-12">
      <div class="container mx-auto px-4">
        <h1 class="text-4xl font-bold mb-4 text-gray-800">Khám phá</h1>
        <h2 class="text-3xl font-bold text-gray-600">17 Sự kiện hấp dẫn</h2>
      </div>
    </div>

    <!-- Category Icons -->
    <div class="container mx-auto px-4 py-8">
      <div class="flex justify-center gap-8 flex-wrap">
        <div v-for="category in categories" :key="category.name" class="text-center">
          <div class="w-16 h-16 rounded-full bg-lime-100 flex items-center justify-center mx-auto mb-2 shadow-md">
            <component :is="category.icon" class="w-8 h-8 text-lime-600" />
          </div>
          <div class="text-sm">
            <div class="font-medium text-gray-800">{{ category.name }}</div>
            <div class="text-gray-600">{{ category.subtext }}</div>
          </div>
        </div>
      </div>
    </div>

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
      <div class="space-y-16 lg:space-y-20 mt-16 md:mt-20">
        <div v-for="event in events" :key="event.id"
          class="w-full grid grid-cols-12 gap-4 md:gap-10 cursor-pointer h-[300px] transition-transform transform hover:scale-105"
          @click="goToEventDetail(event.id)">
          <div class="col-span-12 md:col-span-5 overflow-hidden rounded-2xl shadow-lg relative">
            <img :src="event.image" :alt="event.name" class="w-full h-full object-cover object-center rounded-2xl" />
          </div>
          <div class="col-span-12 md:col-span-7 flex flex-col justify-between p-4 bg-white rounded-2xl shadow-md">
            <div class="flex flex-col h-full justify-between">
              <div class="flex justify-between items-center mb-2">
                <div class="text-sm font-medium px-2 py-1 rounded-md w-max bg-accent-red-600 text-base-white">
                  {{ event.category.name }}
                </div>
              </div>
              <h3 class="text-xl font-semibold text-gray-800">
                {{ event.name }}
              </h3>
              <div class="flex items-center text-gray-600 mb-2">
                <UserIcon class="w-4 h-4 mr-2" />
                <span class="text-lg">{{ event.club.name }}</span>
              </div>
              <div class="flex items-center text-gray-600 mb-2">
                <MapPinIcon class="w-4 h-4 mr-2" />
                <span class="text-lg">{{ event.location }}</span>
              </div>
            </div>
            <router-link :to="`/event/${event.id}`">
              <button class="mt-4 w-40 bg-blue-600 text-white py-4 hover:bg-blue-700 transition-colors rounded-lg">
                Đăng ký
              </button>
          </router-link>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router';
import { ref, onMounted } from 'vue';
import { useEventStore } from "../stores/eventStore";

const router = useRouter();
import {
  BookOpenIcon,
  UserIcon,
  MapPinIcon,
  SearchIcon,
  UtensilsIcon,
  HeartIcon,
  UsersIcon,
  CalendarIcon,
} from "lucide-vue-next";

const eventStore = useEventStore();
const {events, isLoading, error, fetchEvents} = eventStore;

onMounted(() => {
  fetchEvents();
})

const categories = ref([
  { name: "Workshop", subtext: "Học tập", icon: BookOpenIcon },
  { name: "Âm nhạc", subtext: "Tiết tấu", icon: BookOpenIcon },
  { name: "Ẩm thực", subtext: "Trải nghiệm", icon: UtensilsIcon },
  { name: "Thể thao", subtext: "Sức khỏe", icon: HeartIcon },
  { name: "Sở thích", subtext: "Giải trí", icon: BookOpenIcon },
  { name: "Hoạt động", subtext: "Cộng đồng", icon: UsersIcon },
  { name: "Văn hóa", subtext: "Lễ hội", icon: CalendarIcon },
  { name: "Nghề nghiệp", subtext: "Định hướng", icon: BookOpenIcon },
]);

// const events = ref([
//   {
//     id: 1,
//     title: 'Workshop "Data-driven Marketing"',
//     category: "Hoạt động, Cộng đồng",
//     organizer: "Marketing UEL Club",
//     location:
//       "Số 669, Quốc lộ 1A, Phường Linh Xuân, Thủ Đức, Thành phố Hồ Chí Minh",
//     image:
//       "https://leaderbook.com/_next/image?url=https%3A%2F%2Fedus3.leaderbook.com%2Fprod%2Fupload%2Fimg%2F673c4ea96aec6a0053467f02-Proposal.png&w=384&q=75",
//   },
//   {
//     id: 2,
//     title: 'Hội thảo "Khởi Nghiệp Thành Công"',
//     category: "Workshop, Kinh doanh",
//     organizer: "Câu lạc bộ Khởi nghiệp",
//     location: "Số 123, Đường ABC, Quận 1, TP. Hồ Chí Minh",
//     image:
//       "https://leaderbook.com/_next/image?url=https%3A%2F%2Fedus3.leaderbook.com%2Fprod%2Fupload%2Fimg%2F66d95561ad98c90053039ed4-Vi%C3%A1%C2%BB%C2%87t%20Anh.JPG-1.png&w=384&q=75",
//   },
//   {
//     id: 3,
//     title: "Lễ hội Âm nhạc Mùa Hè",
//     category: "Âm nhạc, Giải trí",
//     organizer: "Nhà tài trợ EventX",
//     location: "Công viên B, Quận 2, TP. Hồ Chí Minh",
//     image:
//       "https://leaderbook.com/_next/image?url=https%3A%2F%2Fedus3.leaderbook.com%2Fprod%2Fupload%2Fimg%2F66e0286a39d87f0051b00295-1_16x9.png&w=384&q=75",
//   },
// ]);
// const goToEventDetail = (id) => {
//   router.push({ path: `/detail-event-page` });
// }
</script>

<style>
/* Add any additional styles here */
.bg-accent-red-600 {
  background-color: #dc2626;
  /* Adjust this color as needed */
}

.text-base-white {
  color: #ffffff;
  /* Adjust this color as needed */
}
</style>
