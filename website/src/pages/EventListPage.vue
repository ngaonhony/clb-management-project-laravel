<template>
  <div class="relative overflow-hidden min-h-screen bg-gradient-to-br from-lime-50 to-yellow-50">
    <!-- Enhanced Dynamic Background with Blob Animations -->
    <div class="absolute inset-0 overflow-hidden">
      <!-- Decorative Blobs -->
      <div class="absolute top-0 left-0 w-64 h-64 bg-lime-200 rounded-full mix-blend-multiply filter blur-xl opacity-20 animate-blob"></div>
      <div class="absolute top-0 right-0 w-64 h-64 bg-yellow-200 rounded-full mix-blend-multiply filter blur-xl opacity-20 animate-blob animation-delay-2000"></div>
      <div class="absolute -bottom-8 left-20 w-64 h-64 bg-green-200 rounded-full mix-blend-multiply filter blur-xl opacity-20 animate-blob animation-delay-4000"></div>

      <!-- Flowing Background Animation -->
      <div class="absolute inset-0">
        <!-- Main Flow -->
        <div class="absolute inset-0 bg-gradient-to-r from-lime-400/20 via-lime-300/20 to-lime-400/20 animate-flow"></div>
        <!-- Secondary Flows -->
        <div class="absolute inset-0 bg-gradient-to-r from-lime-300/10 via-lime-400/10 to-lime-300/10 animate-flow-slow"></div>
        <div class="absolute inset-0 bg-gradient-to-r from-lime-500/10 via-lime-400/10 to-lime-500/10 animate-flow-slower"></div>
      </div>

      <!-- Enhanced Wave Pattern -->
      <div class="absolute inset-0">
        <div class="wave"></div>
        <div class="wave wave-delayed"></div>
        <div class="wave wave-delayed-2"></div>
      </div>

      <!-- Enhanced Particle Effects -->
      <div class="absolute inset-0">
        <div class="particles lime-particles"></div>
      </div>
    </div>

    <!-- Main Content -->
    <div class="relative z-10">
      <!-- Hero Section -->
      <div class="text-center py-12 pt-20">
        <div class="container mx-auto px-4">
          <div class="text-center mb-12 relative" data-aos="fade-down">
            <div class="absolute top-0 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-64 h-1 bg-gradient-to-r from-transparent via-lime-400 to-transparent"></div>
            
            <h1 class="text-4xl md:text-5xl font-bold mb-4 text-gray-900 relative glow-text-strong animate-gradient">
              Khám phá
              <div class="absolute top-0 left-0 w-8 h-8 border-t-2 border-l-2 border-lime-400 transform -translate-x-4 -translate-y-4"></div>
              <div class="absolute top-0 right-0 w-8 h-8 border-t-2 border-r-2 border-lime-400 transform translate-x-4 -translate-y-4"></div>
            </h1>
            <h2 class="text-2xl md:text-3xl font-bold text-lime-600 glow-text-strong">
              17 Sự kiện hấp dẫn
            </h2>
            <div class="absolute bottom-0 left-1/2 transform -translate-x-1/2 translate-y-1/2 w-40 h-1 bg-gradient-to-r from-transparent via-lime-400 to-transparent"></div>
          </div>
      </div>
    </div>

    <!-- Category Icons -->
    <div class="container mx-auto px-4 py-8">
        <div class="grid grid-cols-4 md:grid-cols-8 gap-6 mb-12">
          <div v-for="(category, index) in categories" 
               :key="category.name" 
               class="flex flex-col items-center gap-3 group category-icon-effect"
               :data-aos="index % 2 === 0 ? 'fade-right' : 'fade-left'"
               :data-aos-delay="100 * index">
            <div class="relative w-16 h-16 rounded-xl border-[3px] border-lime-300 bg-white backdrop-blur-sm flex items-center justify-center transition-all duration-500 group-hover:bg-white group-hover:border-lime-500 group-hover:scale-110 group-hover:shadow-glow-lime-strong overflow-hidden">
              <div class="absolute inset-0 bg-gradient-to-br from-lime-50 to-white opacity-50 group-hover:opacity-100 transition-opacity duration-500"></div>
              <div class="absolute inset-0 border-[3px] border-transparent group-hover:border-lime-400 rounded-xl animate-border-flow"></div>
              <component :is="category.icon" class="w-7 h-7 text-lime-500 group-hover:text-lime-600 transition-all duration-500 transform group-hover:scale-110 relative z-10 stroke-[2.5]" />
          </div>
            <div class="text-sm text-center">
              <div class="font-medium text-gray-900 group-hover:text-lime-500 transition-colors duration-300">{{ category.name }}</div>
            <div class="text-gray-600">{{ category.subtext }}</div>
            </div>
        </div>
      </div>
    </div>

    <!-- Search Section -->
    <div class="container mx-auto px-4 py-6">
        <div class="flex flex-col md:flex-row gap-4" data-aos="fade-up">
          <div class="relative flex-1 group">
            <div class="absolute -inset-0.5 bg-gradient-to-r from-lime-400 to-lime-600 rounded-lg blur opacity-0 group-hover:opacity-50 transition duration-500"></div>
            <div class="relative flex items-center">
              <div class="absolute left-4 flex items-center justify-center w-6 h-6 rounded-full transition-all duration-300 group-hover:bg-lime-100 group-hover:scale-110">
                <SearchIcon class="w-5 h-5 text-lime-400 group-hover:text-lime-500 transition-all duration-300 transform group-hover:rotate-12 stroke-[2.5]" />
              </div>
            <input type="text" placeholder="Tìm kiếm Sự kiện"
                class="w-full pl-12 pr-4 py-3 rounded-lg border-[3px] border-lime-300 bg-white backdrop-blur-sm focus:border-lime-500 focus:outline-none focus:ring-2 focus:ring-lime-400/50 transition-all duration-300 shadow-soft-lime hover:shadow-glow-lime-strong text-gray-900 placeholder-gray-500 hover:border-lime-400 input-focus-effect" />
            </div>
          </div>
          
          <div class="flex gap-4 flex-wrap">
            <div class="relative group">
              <div class="absolute -inset-0.5 bg-gradient-to-r from-lime-600 to-lime-400 rounded-lg blur opacity-0 group-hover:opacity-50 transition duration-500"></div>
              <div class="relative">
                <select class="appearance-none pl-4 pr-12 py-3 rounded-lg border-[3px] border-lime-300 bg-white backdrop-blur-sm focus:border-lime-500 focus:outline-none focus:ring-2 focus:ring-lime-400/50 transition-all duration-300 shadow-soft-lime hover:shadow-glow-lime-strong cursor-pointer text-gray-900 hover:border-lime-400">
          <option>Loại sự kiện</option>
        </select>
                <ChevronDownIcon class="absolute right-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-lime-400 group-hover:text-lime-500 transition-colors duration-300 pointer-events-none" />
              </div>
            </div>
            
            <div class="relative group">
              <div class="absolute -inset-0.5 bg-gradient-to-r from-lime-600 to-lime-400 rounded-lg blur opacity-0 group-hover:opacity-50 transition duration-500"></div>
              <div class="relative">
                <select class="appearance-none pl-4 pr-12 py-3 rounded-lg border-[3px] border-lime-300 bg-white backdrop-blur-sm focus:border-lime-500 focus:outline-none focus:ring-2 focus:ring-lime-400/50 transition-all duration-300 shadow-soft-lime hover:shadow-glow-lime-strong cursor-pointer text-gray-900 hover:border-lime-400">
          <option>Khu vực</option>
        </select>
                <ChevronDownIcon class="absolute right-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-lime-400 group-hover:text-lime-500 transition-colors duration-300 pointer-events-none" />
              </div>
            </div>
            
            <div class="relative group">
              <div class="absolute -inset-0.5 bg-gradient-to-r from-lime-600 to-lime-400 rounded-lg blur opacity-0 group-hover:opacity-50 transition duration-500"></div>
              <div class="relative">
                <select class="appearance-none pl-4 pr-12 py-3 rounded-lg border-[3px] border-lime-300 bg-white backdrop-blur-sm focus:border-lime-500 focus:outline-none focus:ring-2 focus:ring-lime-400/50 transition-all duration-300 shadow-soft-lime hover:shadow-glow-lime-strong cursor-pointer text-gray-900 hover:border-lime-400">
          <option>Sắp xếp theo</option>
        </select>
                <ChevronDownIcon class="absolute right-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-lime-400 group-hover:text-lime-500 transition-colors duration-300 pointer-events-none" />
              </div>
            </div>
          </div>
        </div>
    </div>

    <!-- Events List -->
    <div class="container mx-auto px-4 py-8">
        <div class="space-y-8 mt-8">
        <div v-for="(event, index) in events" 
             :key="event.id"
             class="bg-white/90 backdrop-blur-md rounded-2xl shadow-soft-lime hover:shadow-glow-lime-strong overflow-hidden flex flex-col md:flex-row mb-6 transition-all duration-300 group cursor-pointer"
             :data-aos="index % 2 === 0 ? 'fade-left' : 'fade-right'"
             :data-aos-delay="200 + (index * 100)"
             @click="goToEventDetail(event.id)">
            <!-- Left Content -->
            <div class="pt-6 pr-6 pl-6 pb-4 flex-1">
              <div class="flex items-start gap-4">
                <div class="flex-1">
                  <span class="inline-block px-3 py-1 bg-lime-100 text-gray-900 text-sm font-medium rounded-full mb-2">
                    {{ event.category.name }}
                  </span>
                  <h2 class="text-2xl font-bold text-gray-900 mb-2 group-hover:text-lime-500 transition-colors duration-300">
                    {{ event.name }}
                  </h2>
                  <div class="flex items-center gap-4 text-sm text-gray-900">
                    <div class="flex items-center gap-1">
                      <UserIcon class="w-4 h-4 text-lime-400" />
                      <span>{{ event.club.name }}</span>
                    </div>
                    <div class="flex items-center gap-1">
                      <MapPinIcon class="w-4 h-4 text-lime-400" />
                      <span>{{ event.location }}</span>
                    </div>
          </div>
                </div>
              </div>

              <router-link 
                :to="`/event/${event.id}`" 
                class="mt-6 w-80 py-2.5 text-center border-[3px] border-lime-300 text-gray-900 font-medium rounded-lg shadow-soft-lime hover:shadow-glow-lime-strong hover:bg-gradient-to-r hover:from-lime-500 hover:to-lime-600 hover:text-white hover:border-lime-500 transition-all duration-500 mx-auto block hover:scale-105"
              >
                Chi tiết
              </router-link>
              </div>

            <!-- Right Image -->
            <div class="w-full md:w-[400px] lg:h-[250px] relative overflow-hidden">
              <div class="absolute inset-0 bg-gradient-to-t from-black/50 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500 z-10"></div>
              <img
                :src="event.background_images[0]?.image_url"
                alt="Event background"
                class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-125"
              />
            </div>
          </div>

          <!-- Enhanced Load More Button -->
          <div class="flex items-center justify-center mt-10 max-w-4xl mx-auto" data-aos="fade-up">
            <div class="flex-1 h-px bg-gradient-to-r from-transparent via-lime-200 to-transparent"></div>
            <button class="mx-8 px-8 py-2.5 rounded-lg bg-white/90 backdrop-blur-sm border-[3px] border-lime-300 text-gray-900 hover:text-white hover:border-lime-500 hover:bg-gradient-to-r hover:from-lime-500 hover:to-lime-600 transition-all duration-500 shadow-soft-lime hover:shadow-glow-lime-strong flex items-center justify-center font-medium min-w-[160px] hover:scale-105">
              Xem Thêm
              <ChevronDown class="ml-2 w-4 h-4 text-lime-400 group-hover:text-white" />
              </button>
            <div class="flex-1 h-px bg-gradient-to-r from-transparent via-lime-200 to-transparent"></div>
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
import AOS from 'aos'
import 'aos/dist/aos.css'

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
  ChevronDownIcon,
  ChevronDown,
} from "lucide-vue-next";

const eventStore = useEventStore();
const {events, isLoading, error, fetchEvents} = eventStore;

onMounted(() => {
  fetchEvents();
  AOS.init({
    duration: 1000,
    easing: 'ease-in-out',
    once: true,
    mirror: false
  })
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

</script>

<style scoped>
/* Base Animations */
@keyframes rotate {
    from { transform: rotate(0deg); }
    to { transform: rotate(360deg); }
}

@keyframes pulse {
    0%, 100% { transform: scale(1) translate(-25%, 25%); opacity: 0.5; }
    50% { transform: scale(1.1) translate(-25%, 25%); opacity: 0.7; }
}

@keyframes float {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-20px); }
}

/* Flow Animations */
@keyframes flow {
    0% { transform: translateX(-50%); }
    100% { transform: translateX(50%); }
}

.animate-flow {
    animation: flow 15s linear infinite;
}

.animate-flow-slow {
    animation: flow 20s linear infinite;
}

.animate-flow-slower {
    animation: flow 25s linear infinite;
}

/* Wave Animation */
@keyframes wave {
    0% { transform: translateX(-100%) translateY(0) rotate(0); }
    50% { transform: translateX(0) translateY(-20px) rotate(1deg); }
    100% { transform: translateX(100%) translateY(0) rotate(0); }
}

.wave {
    position: absolute;
    width: 200%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(132, 204, 22, 0.1), transparent);
    animation: wave 8s linear infinite;
}

.wave-delayed {
    animation-delay: -4s;
    opacity: 0.7;
}

.wave-delayed-2 {
    animation-delay: -6s;
    opacity: 0.5;
}

/* Blob Animation */
@keyframes blob {
    0%, 100% {
        transform: translate(0, 0) scale(1);
    }
    25% {
        transform: translate(20px, -20px) scale(1.1);
    }
    50% {
        transform: translate(0, 20px) scale(1);
    }
    75% {
        transform: translate(-20px, -20px) scale(0.9);
    }
}

.animate-blob {
    animation: blob 10s infinite;
}

.animation-delay-2000 {
    animation-delay: 2s;
}

.animation-delay-4000 {
    animation-delay: 4s;
}

/* Particles */
.particles {
    position: absolute;
    width: 100%;
    height: 100%;
    background: radial-gradient(circle at center,
        rgba(255, 255, 255, 0.1) 0%,
        transparent 60%);
    animation: particle-pulse 4s ease-in-out infinite;
}

@keyframes particle-pulse {
    0%, 100% { opacity: 0.3; }
    50% { opacity: 0.7; }
}

.lime-particles {
    background: radial-gradient(circle at center,
        rgba(132, 204, 22, 0.1) 0%,
        transparent 60%);
}

/* Shadow Effects */
.shadow-soft-lime {
    box-shadow: 0 4px 6px -1px rgba(132, 204, 22, 0.1),
                0 2px 4px -1px rgba(132, 204, 22, 0.06);
}

.shadow-glow-lime-strong {
    box-shadow: 
        0 0 15px rgba(132, 204, 22, 0.4),
        0 0 30px rgba(132, 204, 22, 0.2),
        inset 0 0 10px rgba(132, 204, 22, 0.1);
}

/* Text Effects */
.glow-text-strong {
    text-shadow: 
        0 0 10px rgba(132, 204, 22, 0.3),
        0 0 20px rgba(132, 204, 22, 0.2),
        0 0 30px rgba(132, 204, 22, 0.1),
        2px 2px 2px rgba(0, 0, 0, 0.1);
    position: relative;
    z-index: 1;
}

/* Border Animation */
@keyframes border-flow {
    0% { clip-path: inset(0 0 98% 0); }
    25% { clip-path: inset(0 0 0 98%); }
    50% { clip-path: inset(98% 0 0 0); }
    75% { clip-path: inset(0 98% 0 0); }
    100% { clip-path: inset(0 0 98% 0); }
}

.animate-border-flow {
    animation: border-flow 4s linear infinite;
}

/* Input and Button Effects */
input:focus, select:focus {
    transform: translateY(-1px);
    box-shadow: 
        0 0 0 2px rgba(132, 204, 22, 0.1),
        0 0 20px rgba(132, 204, 22, 0.2);
}

input:hover, select:hover {
    transform: translateY(-1px);
}

/* Button Hover Animation */
@keyframes gradient-shift {
    0% { background-position: 0% 50%; }
    50% { background-position: 100% 50%; }
    100% { background-position: 0% 50%; }
}

button:hover {
    background-size: 200% 200%;
    animation: gradient-shift 3s ease infinite;
}

/* Category Icon Effects */
.category-icon-effect {
    transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
}

.category-icon-effect:hover {
    transform: translateY(-5px) scale(1.1);
    box-shadow: 
        0 0 20px rgba(132, 204, 22, 0.3),
        0 0 40px rgba(132, 204, 22, 0.2);
}

/* Custom Scrollbar */
::-webkit-scrollbar {
    width: 8px;
}

::-webkit-scrollbar-track {
    background: #f1f1f1;
}

::-webkit-scrollbar-thumb {
    background: linear-gradient(to bottom, #84cc16, #65a30d);
    border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
    background: linear-gradient(to bottom, #65a30d, #84cc16);
}

/* Smooth Scrolling */
html {
    scroll-behavior: smooth;
}
</style>
