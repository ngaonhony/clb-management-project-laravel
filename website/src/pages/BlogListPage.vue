<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Main Content -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <div class="flex flex-col lg:flex-row gap-8">
        <!-- Sidebar -->
        <div class="lg:w-64 flex-shrink-0">
          <div class="bg-white rounded-lg shadow p-6">
            <h2 class="text-lg font-semibold text-gray-900 mb-4">Danh mục</h2>
            <nav class="space-y-2">
              <a 
                v-for="category in categories" 
                :key="category.id"
                :href="category.href"
                :class="[
                  'block px-3 py-2 rounded-md text-base font-medium',
                  category.current ? 'bg-blue-50 text-blue-600' : 'text-gray-900 hover:bg-gray-50'
                ]"
              >
                {{ category.name }}
              </a>
            </nav>
          </div>
        </div>

        <!-- Blog Posts Grid -->
        <div class="flex-1">
          <h1 class="text-2xl font-bold text-gray-900 mb-6">Tin tức</h1>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <article
        v-for="post in posts"
        :key="post.id"
        class="flex flex-col rounded-lg shadow-lg overflow-hidden transform transition-transform duration-300 hover:scale-105"
      >
        <div class="relative shrink-0 h-[180px] md:h-[250px] w-full">
          <img :src="post.imageUrl" :alt="post.title" class="h-full w-full object-cover" />
        </div>
        <div :class="['flex-1 bg-white p-6', post.bgColor]">
          <div class="flex-1">
            <a :href="post.href" class="block mt-2">
              <p class="text-xl font-semibold text-gray-900">{{ post.title }}</p>
              <p class="mt-3 text-base text-gray-500">{{ post.excerpt }}</p>
            </a>
          </div>
          <div class="mt-6 flex items-center">
            <div class="flex space-x-1 text-sm text-gray-500">
              <CalendarIcon class="h-5 w-5" />
              <time :datetime="post.datetime">{{ post.date }}</time>
            </div>
          </div>
        </div>
      </article>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { CalendarIcon } from 'lucide-vue-next'

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
</script>

<style scoped>
/* Add any component-specific styles here */
</style>

