<template>
  <div class="relative overflow-hidden min-h-screen bg-gradient-to-br from-yellow-50 to-amber-50">
    <!-- Enhanced Dynamic Background with Blob Animations -->
    <div class="absolute inset-0 overflow-hidden">
      <!-- Decorative Blobs with Enhanced Animation -->
      <div class="absolute top-0 left-0 w-72 h-72 bg-yellow-200 rounded-full mix-blend-multiply filter blur-xl opacity-20 animate-blob transform-gpu"></div>
      <div class="absolute top-0 right-0 w-72 h-72 bg-amber-200 rounded-full mix-blend-multiply filter blur-xl opacity-20 animate-blob animation-delay-2000 transform-gpu"></div>
      <div class="absolute -bottom-8 left-20 w-72 h-72 bg-orange-200 rounded-full mix-blend-multiply filter blur-xl opacity-20 animate-blob animation-delay-4000 transform-gpu"></div>

      <!-- Enhanced Flowing Background Animation -->
      <div class="absolute inset-0">
        <div class="absolute inset-0 bg-gradient-to-r from-yellow-400/20 via-yellow-300/20 to-yellow-400/20 animate-flow transform-gpu"></div>
        <div class="absolute inset-0 bg-gradient-to-r from-yellow-300/10 via-yellow-400/10 to-yellow-300/10 animate-flow-slow transform-gpu"></div>
        <div class="absolute inset-0 bg-gradient-to-r from-yellow-500/10 via-yellow-400/10 to-yellow-500/10 animate-flow-slower transform-gpu"></div>
      </div>

      <!-- Enhanced Wave Pattern -->
      <div class="absolute inset-0 transform-gpu">
        <div class="wave"></div>
        <div class="wave wave-delayed"></div>
        <div class="wave wave-delayed-2"></div>
      </div>

      <!-- Enhanced Particle Effects -->
      <div class="absolute inset-0">
        <div class="particles yellow-particles"></div>
      </div>
    </div>

    <!-- Main Content with Enhanced Animations -->
    <div class="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <!-- Enhanced Title Section -->
      <div class="relative mb-12 text-center" data-aos="fade-down" data-aos-delay="100">
        <div class="absolute top-0 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-64 h-1 bg-gradient-to-r from-transparent via-yellow-400 to-transparent animate-pulse"></div>
        <h1 class="text-4xl font-bold text-gray-900 glow-text-strong relative inline-block animate-gradient">
          Tin tức
          <div class="absolute top-0 left-0 w-6 h-6 border-t-2 border-l-2 border-yellow-400 transform -translate-x-3 -translate-y-3 animate-border-flow"></div>
          <div class="absolute top-0 right-0 w-6 h-6 border-t-2 border-r-2 border-yellow-400 transform translate-x-3 -translate-y-3 animate-border-flow animation-delay-500"></div>
        </h1>
        <div class="absolute bottom-0 left-1/2 transform -translate-x-1/2 translate-y-1/2 w-40 h-1 bg-gradient-to-r from-transparent via-yellow-400 to-transparent animate-pulse"></div>
      </div>

      <div class="flex flex-col lg:flex-row gap-12">
        <!-- Enhanced Sidebar -->
        <div class="lg:w-72 flex-shrink-0" data-aos="fade-right" data-aos-delay="200">
          <div class="bg-white/90 backdrop-blur-sm rounded-xl shadow-lg hover:shadow-2xl transition-all duration-500 group transform-gpu hover:-translate-y-1">
            <div class="p-8">
              <h2 class="text-xl font-semibold text-gray-900 mb-6 relative">
                Danh mục
                <div class="absolute bottom-0 left-0 w-full h-0.5 bg-gradient-to-r from-yellow-400 to-amber-400 transform scale-x-0 group-hover:scale-x-100 transition-transform duration-500"></div>
              </h2>
              <nav class="space-y-3">
                <a 
                  v-for="(category, index) in categories" 
                  :key="category.id"
                  :href="category.href"
                  :class="[
                    'block px-4 py-3 rounded-lg text-base font-medium transition-all duration-300 transform-gpu hover:scale-105',
                    category.current ? 'bg-yellow-50 text-yellow-600' : 'text-gray-900 hover:bg-yellow-50/50'
                  ]"
                  :data-aos="'fade-left'"
                  :data-aos-delay="200 + (index * 100)"
                >
                  {{ category.name }}
                </a>
              </nav>
            </div>
          </div>
        </div>

        <!-- Enhanced Blog Posts Grid -->
        <div class="flex-1">
          <div class="bg-white/90 backdrop-blur-sm rounded-2xl shadow-xl p-8 transition-all duration-500 hover:shadow-2xl transform-gpu">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
              <article
                v-for="(post, index) in posts"
                :key="post.id"
                class="flex flex-col rounded-xl shadow-lg overflow-hidden transform-gpu transition-all duration-500 hover:-translate-y-2 bg-white backdrop-blur-sm group hover:shadow-2xl"
                :data-aos="index % 2 === 0 ? 'fade-up' : 'fade-up'"
                :data-aos-delay="300 + (index * 150)"
              >
                <div class="relative shrink-0 h-[200px] md:h-[250px] w-full overflow-hidden">
                  <div class="absolute inset-0 bg-gradient-to-br from-yellow-400/20 to-amber-400/20 opacity-0 group-hover:opacity-100 transition-opacity duration-500"></div>
                  <img :src="post.imageUrl" :alt="post.title" 
                    class="h-full w-full object-cover transition-transform duration-700 group-hover:scale-125" />
                  <div class="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent opacity-0 group-hover:opacity-100 transition-all duration-500"></div>
                </div>
                <div :class="['flex-1 p-8 relative overflow-hidden', post.bgColor]">
                  <div class="absolute inset-0 bg-gradient-to-br from-white/50 to-yellow-50/50 opacity-0 group-hover:opacity-100 transition-opacity duration-500"></div>
                  <div class="relative z-10">
                    <div class="flex-1">
                      <a :href="post.href" class="block transition-all duration-300">
                        <p class="text-xl font-semibold text-gray-900 mb-4 group-hover:text-yellow-600 transition-colors duration-300 transform-gpu group-hover:translate-x-2">{{ post.title }}</p>
                        <p class="text-base text-gray-500 group-hover:text-gray-600 transition-colors duration-300">{{ post.excerpt }}</p>
                      </a>
                    </div>
                    <div class="mt-8 flex items-center transform-gpu transition-all duration-300 group-hover:translate-x-2">
                      <div class="flex space-x-2 text-sm text-gray-500 group-hover:text-yellow-600 transition-colors duration-300">
                        <CalendarIcon class="h-5 w-5 animate-pulse" />
                        <time :datetime="post.datetime">{{ post.date }}</time>
                      </div>
                    </div>
                  </div>
                </div>
              </article>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { CalendarIcon } from 'lucide-vue-next'
import { onMounted } from 'vue'
import AOS from 'aos'
import 'aos/dist/aos.css'

const categories = [
  { id: 1, name: 'Tin tức', href: '#', current: true },
  { id: 2, name: 'Thông tin tuyển sinh', href: '#', current: false },
  { id: 3, name: 'Tư vấn chọn khối thi', href: '#', current: false },
  { id: 4, name: 'Tư vấn chọn ngành', href: '#', current: false },
]

const posts = [
  {
    id: 1,
    title: 'Khối A14 có những ngành nào, các trường khối A14 hiện nay',
    href: '#',
    imageUrl: 'https://leaderbook.com/_next/image?url=https%3A%2F%2Fghost.leaderbook.com%2Fcontent%2Fimages%2F2024%2F12%2Fkhoi-a11-gom-nhung-nganh-nao-mon-nao-truong-nao.jpg&w=640&q=75',
    excerpt: 'Khối A14 là một tổ hợp môn mới được đưa và hệ thống giáo dục tại Việt Nam gồm 3 môn Toán, Khoa học tự nhiên và Địa...',
    datetime: '2024-12-20',
    date: '20/12/2024',
    bgColor: 'bg-orange-50'
  },
  {
    id: 2,
    title: 'Khối A12 gồm những môn gì? Các trường và các ngành xét khối A12',
    href: '#',
    imageUrl: 'https://leaderbook.com/_next/image?url=https%3A%2F%2Fghost.leaderbook.com%2Fcontent%2Fimages%2F2024%2F12%2Fkhoi-a10-gom-nhung-nganh-nao-truong-nao.jpg&w=640&q=75',
    excerpt: 'Khối A12 là một tổ hợp môn thi mới, mở rộng từ khối A truyền thống trong hệ thống giáo dục tại Việt Nam. Tổ hợp A12 gồm...',
    datetime: '2024-12-20',
    date: '20/12/2024',
    bgColor: 'bg-purple-50'
  },
  {
    id: 3,
    title: 'Khối A11 học ngành gì? Khối A11 gồm những trường nào',
    href: '#',
    imageUrl: 'https://leaderbook.com/_next/image?url=https%3A%2F%2Fghost.leaderbook.com%2Fcontent%2Fimages%2F2024%2F12%2Fkhoi-a08-gom-nhung-nganh-nao.jpg&w=640&q=75',
    excerpt: 'Việc lựa chọn khối thi và ngành học phù hợp là một bước quan trọng trên con đường chinh phục nghề nghiệp trong...',
    datetime: '2024-12-19',
    date: '19/12/2024',
    bgColor: 'bg-rose-50'
  },
  {
    id: 4,
    title: 'Khối A10 học ngành gì, các trường xét khối A10',
    href: '#',
    imageUrl: 'https://leaderbook.com/_next/image?url=https%3A%2F%2Fghost.leaderbook.com%2Fcontent%2Fimages%2F2024%2F12%2Fkhoi-a06-gom-nhung-nganh-nao-truong-nao.jpg&w=640&q=75',
    excerpt: 'Khối A10 là một trong những tổ hợp môn được nhiều học sinh và phụ huynh quan tâm khi tìm hiểu về cơ hội học tập và định...',
    datetime: '2024-12-18',
    date: '18/12/2024',
    bgColor: 'bg-green-50'
  }
]

onMounted(() => {
  AOS.init({
    duration: 1200,
    easing: 'ease-out-cubic',
    once: false,
    mirror: true,
    anchorPlacement: 'top-bottom'
  })
})
</script>

<style scoped>
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

@keyframes wave {
    0% { transform: translateX(-100%) translateY(0) rotate(0); }
    50% { transform: translateX(0) translateY(-20px) rotate(1deg); }
    100% { transform: translateX(100%) translateY(0) rotate(0); }
}

.wave {
    position: absolute;
    width: 200%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(234, 179, 8, 0.1), transparent);
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

.yellow-particles {
    background: radial-gradient(circle at center,
        rgba(234, 179, 8, 0.1) 0%,
        transparent 60%);
}

/* Enhanced Title Styles */
.glow-text-strong {
    text-shadow: 
        0 0 10px rgba(234, 179, 8, 0.3),
        0 0 20px rgba(234, 179, 8, 0.2),
        0 0 30px rgba(234, 179, 8, 0.1),
        2px 2px 2px rgba(0, 0, 0, 0.1);
    position: relative;
    z-index: 1;
}

h1.glow-text-strong::before {
    content: '';
    position: absolute;
    inset: -10px -20px;
    background: radial-gradient(circle at center, rgba(255, 255, 255, 0.9) 0%, transparent 70%);
    z-index: -1;
    opacity: 0.8;
}

/* Enhanced Animations */
@keyframes border-flow {
    0% { border-color: rgba(234, 179, 8, 0.4); }
    50% { border-color: rgba(234, 179, 8, 1); }
    100% { border-color: rgba(234, 179, 8, 0.4); }
}

.animate-border-flow {
    animation: border-flow 2s ease-in-out infinite;
}

.animation-delay-500 {
    animation-delay: 0.5s;
}

@keyframes blob {
    0%, 100% {
        transform: translate(0, 0) scale(1) rotate(0deg);
    }
    25% {
        transform: translate(20px, -20px) scale(1.1) rotate(5deg);
    }
    50% {
        transform: translate(0, 20px) scale(1) rotate(0deg);
    }
    75% {
        transform: translate(-20px, -20px) scale(0.9) rotate(-5deg);
    }
}

.animate-blob {
    animation: blob 15s infinite cubic-bezier(0.4, 0, 0.2, 1);
}

@keyframes gradient {
    0% { background-position: 0% 50%; }
    50% { background-position: 100% 50%; }
    100% { background-position: 0% 50%; }
}

.animate-gradient {
    background-size: 200% auto;
    animation: gradient 4s linear infinite;
}

/* Enhanced Hover Effects */
.hover-lift {
    transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.hover-lift:hover {
    transform: translateY(-5px);
}

/* Enhanced Card Styles */
.card-shadow {
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
    transition: box-shadow 0.3s ease-in-out;
}

.card-shadow:hover {
    box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
}

/* Smooth Scrolling */
html {
    scroll-behavior: smooth;
}

/* Custom Scrollbar */
::-webkit-scrollbar {
    width: 8px;
}

::-webkit-scrollbar-track {
    background: linear-gradient(to bottom, #fef3c7, #fff7ed);
}

::-webkit-scrollbar-thumb {
    background: linear-gradient(to bottom, #fbbf24, #f59e0b);
    border-radius: 4px;
    transition: all 0.3s ease;
}

::-webkit-scrollbar-thumb:hover {
    background: linear-gradient(to bottom, #f59e0b, #d97706);
}
</style>

