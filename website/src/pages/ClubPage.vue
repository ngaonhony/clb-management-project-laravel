<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Hero Section -->
    <div class="bg-white">
      <div class="max-w-7xl mx-auto py-16 px-4">
        <div class="text-center">
          <h1 class="text-4xl font-bold text-gray-900 mb-8">
            {{ clubStore.selectedClub?.name || 'Đang tải...' }}
          </h1>
          <div class="grid grid-cols-2 md:grid-cols-4 gap-8 max-w-3xl mx-auto">
            <div class="text-center">
              <div class="text-3xl font-bold text-blue-600">10</div>
              <div class="text-sm text-gray-500">Năm phát triển</div>
            </div>
            <div class="text-center">
              <div class="text-3xl font-bold text-blue-600">15</div>
              <div class="text-sm text-gray-500">Chương trình</div>
            </div>
            <div class="text-center">
              <div class="text-3xl font-bold text-blue-600">{{ clubStore.selectedClub?.member_count || 'Đang tải...' }}</div>
              <div class="text-sm text-gray-500">Thành viên</div>
            </div>
            <div class="text-center">
              <div class="text-3xl font-bold text-blue-600">20</div>
              <div class="text-sm text-gray-500">Nhà tài trợ</div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Mission Section -->
    <div class="bg-gray-50 py-16">
      <div class="max-w-7xl mx-auto px-4">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div class="md:col-span-2">
            <h2 class="text-3xl font-bold mb-4">Sứ mệnh</h2>
            <h3 class="text-xl font-semibold mb-2">Chúng tôi là ai</h3>
            <p class="text-gray-600 mb-4">– {{ clubStore.selectedClub?.category_id || 'Đang tải...' }}</p>
            <p class="text-gray-600 mb-8">
              {{ clubStore.selectedClub?.description || 'Đang tải...' }}
            </p>
            <button class="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700">
              Liên hệ tài trợ
            </button>
          </div>
          <div>
            <h3 class="text-xl font-bold mb-4">Nhà tài trợ</h3>
            <div class="grid grid-cols-2 gap-4">
              <div v-for="i in 6" :key="i" class="bg-white p-4 rounded-lg shadow">
                <img :src="Image5" 
                     :alt="`Sponsor ${i}`" 
                     class="w-full h-auto" 
                     loading="lazy" />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div> mô

    <!-- Featured Event -->
    <div class="bg-white py-16">
      <div class="max-w-7xl mx-auto px-4">
        <div class="bg-gradient-to-r from-blue-600 to-indigo-600 rounded-2xl overflow-hidden">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-8 p-8">
            <div class="text-white">
              <h2 class="text-4xl font-bold mb-2">MUSIC EST</h2>
              <p class="text-blue-100 mb-4">Âm nhạc, Tiệc tùng</p>
              <h3 class="text-2xl font-semibold mb-4">Music Event</h3>
              <p class="text-blue-100 mb-8">
                Dưới đây là đoạn mô tả sự kiện Âm nhạc, bạn có thể điền đoạn mô tả event của mình ở ô này
              </p>
              <div class="grid grid-cols-2 gap-4">
                <div class="bg-blue-500/50 rounded-lg p-4">
                  <div class="text-3xl font-bold">10</div>
                  <div class="text-sm text-blue-100">Đội tham dự</div>
                </div>
                <div class="bg-blue-500/50 rounded-lg p-4">
                  <div class="text-3xl font-bold">5</div>
                  <div class="text-sm text-blue-100">Tiếng</div>
                </div>
                <div class="bg-blue-500/50 rounded-lg p-4">
                  <div class="text-3xl font-bold">10.000</div>
                  <div class="text-sm text-blue-100">Khán giả</div>
                </div>
                <div class="bg-blue-500/50 rounded-lg p-4">
                  <div class="text-3xl font-bold">2.000.000</div>
                  <div class="text-sm text-blue-100">Số tiền gây quỹ</div>
                </div>
              </div>
            </div>
            <div class="relative">
              <img 
                :src="Image4" 
                alt="Music Event" 
                class="rounded-lg w-full h-full object-cover" 
                loading="lazy" />
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Management Team -->
    <div class="bg-gray-50 py-16">
      <div class="max-w-7xl mx-auto px-4">
        <h2 class="text-3xl font-bold mb-4">Ban quản trị Câu Lạc Bộ</h2>
        <p class="text-gray-600 mb-8">
          Đây là phần giới thiệu về Ban quản trị của CLB. Bạn có thể nhập một đoạn giới thiệu ngắn về ban quản trị ở ô này. 
          Ở bên dưới bạn có thể thêm hình, tên từng người trong ban quản trị kèm với phần mô tả vị trí mà họ đảm nhận.
        </p>
        <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-8">
          <div v-for="member in management" :key="member.name" class="text-center">
            <img 
              :src="Image3" 
              :alt="member.name" 
              class="w-24 h-24 rounded-full mx-auto mb-4" 
              loading="lazy" />
            <h3 class="font-semibold">{{ member.name }}</h3>
            <p class="text-sm text-gray-500">{{ member.position }}</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Contact Form -->
    <div class="bg-white py-16">
      <div class="max-w-3xl mx-auto px-4">
        <h2 class="text-3xl font-bold mb-8 text-center">Liên hệ tài trợ</h2>
        <p class="text-gray-600 mb-8 text-center">
          Đây là nội dung mô tả cho phần thông tin CLB. Bạn có thể chỉnh sửa nội dung này nhằm kêu gọi liên hệ 
          từ sinh viên và các doanh nghiệp muốn tài trợ cho câu lạc bộ.
        </p>
        <div class="text-center mb-8">
          <p class="text-gray-600">contact@loremipsum.com</p>
          <p class="text-gray-600">0123.456.789</p>
        </div>
        <form class="space-y-6">
          <div>
            <input type="text" placeholder="Tên cá nhân/tổ chức" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-blue-500 focus:border-transparent" />
          </div>
          <div>
            <input type="tel" placeholder="Số điện thoại" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-blue-500 focus:border-transparent" />
          </div>
          <div>
            <input type="email" placeholder="Email" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-blue-500 focus:border-transparent" />
          </div>
          <div>
            <textarea placeholder="Nội dung" rows="4" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-blue-500 focus:border-transparent"></textarea>
          </div>
          <div>
            <button type="submit" class="w-full bg-blue-600 text-white py-3 rounded-lg hover:bg-blue-700">
              Gửi
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- Members Section -->
    <div class="bg-gray-50 py-16">
      <div class="max-w-7xl mx-auto px-4">
        <h2 class="text-3xl font-bold mb-4">Thành viên Câu Lạc Bộ</h2>
        <p class="text-gray-600 mb-8">
          Đây là phần thông tin chia sẻ từ thành viên tham gia hoạt động cho câu lạc bộ. Bạn có thể tổng hợp một số 
          chia sẻ nổi bật của các thành viên để giúp người dung hiểu hơn về hoạt động câu lạc bộ của bạn.
        </p>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8 mb-8">
          <div v-for="member in members" :key="member.name" class="bg-white p-6 rounded-lg shadow-lg">
            <div class="flex items-center mb-4">
              <img 
                :src="Image2" 
                :alt="member.name" 
                class="w-12 h-12 rounded-full" 
                loading="lazy" />
              <div class="ml-4">
                <h3 class="font-semibold">{{ member.name }}</h3>
                <p class="text-sm text-gray-500">{{ member.position }}</p>
              </div>
            </div>
            <p class="text-gray-600">{{ member.testimonial }}</p>
          </div>
        </div>
        <div class="text-center">
          <button class="bg-blue-600 text-white px-8 py-3 rounded-lg hover:bg-blue-700">
            Đăng ký thành viên
          </button>
        </div>
      </div>
    </div>

    <!-- Similar Clubs -->
    <div class="bg-white py-16">
      <div class="max-w-7xl mx-auto px-4">
        <h2 class="text-3xl font-bold mb-8">Các Câu Lạc Bộ tương tự</h2>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div v-for="club in similarClubs" :key="club.name" class="bg-gray-50 rounded-lg p-6">
            <div class="flex items-start space-x-4">
              <img 
                :src="Image1" 
                :alt="club.name" 
                class="w-16 h-16 rounded-lg" 
                loading="lazy" />
              <div>
                <h3 class="font-semibold">{{ club.name }}</h3>
                <p class="text-sm text-gray-500">{{ club.category }}</p>
                <p class="text-sm text-gray-500">{{ club.location }} • {{ club.members }} thành viên</p>
                <p v-if="club.events" class="text-sm text-gray-500">Đã tổ chức {{ club.events }} sự kiện</p>
              </div>
            </div>
          </div>
        </div>
        <div class="text-center mt-8">
          <a href="#" class="text-blue-600 hover:text-blue-700 font-medium">
            Tất cả Câu Lạc Bộ →
          </a>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { MailIcon } from 'lucide-vue-next';
import Image1 from "../assets/1.webp";
import Image2 from "../assets/2.webp";
import Image3 from "../assets/3.webp";
import Image4 from "../assets/4.webp";
import Image5 from "../assets/5.webp";

import { ref, onMounted } from 'vue';
import { useClubStore } from "../stores/clubStore";
import { useRoute } from "vue-router";

const management = [
  { name: 'Long', position: 'Chủ tịch CLB' },
  { name: 'Lan', position: 'Trưởng ban Truyền thông' },
  { name: 'Ngân', position: 'Trưởng ban Vận hành' },
  { name: 'Tuấn', position: 'Trưởng ban Đối ngoại' },
  { name: 'Mai', position: 'Trưởng ban Dự án' }
]

const members = [
  { 
    name: 'Hoa',
    position: 'Mar-Com Team Lead 2023',
    testimonial: 'Đây là đoạn điền thông tin, chia sẻ, cảm nghĩ của thành viên trong quá trình tham gia câu lạc bộ'
  },
  {
    name: 'Thành',
    position: 'Thành viên mới 2024',
    testimonial: 'Đây là đoạn điền thông tin, chia sẻ, cảm nghĩ của thành viên khi mới tham gia câu lạc bộ'
  },
  {
    name: 'Hoàng',
    position: 'Trưởng BTC Event',
    testimonial: 'Chia sẻ từ các thành viên về môi trường, văn hóa câu lạc bộ hiện tại'
  }
]

const similarClubs = [
  {
    name: 'Trường Làng Trong Phố',
    shortName: 'TLTP',
    category: 'Nghệ thuật, Sáng tạo',
    location: 'Hà Nội',
    members: '6'
  },
  {
    name: 'PIC - Phan Dinh Phung Instrument Club',
    shortName: 'PIC',
    category: 'Nghệ thuật, Sáng tạo',
    location: 'Hà Nội',
    members: '98',
    events: '10'
  },
  {
    name: 'Southern Universities Debating Companionship',
    shortName: 'SUDC',
    category: 'Học thuật, Chuyên môn',
    location: 'Hồ Chí Minh',
    members: '30',
    events: '1'
  }
]

const clubStore = useClubStore();
const route = useRoute();
const id = route.params.id;

onMounted(async () => {
  try {
    await clubStore.fetchClubById(id);
  } catch (error) {
    console.error('Error fetching club:', error);
  }
});

</script>