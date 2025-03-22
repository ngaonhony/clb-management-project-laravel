<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Loading State -->
    <div v-if="loading" class="flex justify-center items-center min-h-screen">
      <div class="animate-spin rounded-full h-32 w-32 border-b-2 border-blue-500"></div>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="flex justify-center items-center min-h-screen">
      <div class="text-center">
        <p class="text-red-500 text-xl mb-4">{{ error }}</p>
        <button @click="fetchClub" class="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600">
          Thử lại
        </button>
      </div>
    </div>

    <!-- Content when data is loaded -->
    <template v-else>
      <!-- Hero Section -->
      <div class="container mx-auto px-4 py-8">
        <div class="flex items-start gap-8">
          <div class="max-w-6xl mx-auto flex">
            <!-- Thông tin câu lạc bộ -->
            <div class="w-1/2 p-8">
              <h2 class="text-3xl font-bold mb-6">{{ club?.name || 'Loading...' }}</h2>
              <div class="flex mb-4">
                <div class="mr-8">
                  <p class="text-3xl font-bold text-blue-500">{{ club?.founded_year || '0' }}+</p>
                  <p class="text-gray-500">Năm phát triển</p>
                </div>
                <div>
                  <p class="text-3xl font-bold text-blue-500">{{ club?.total_events || '0' }}</p>
                  <p class="text-gray-500">Chương trình</p>
                </div>
              </div>
              <div class="flex">
                <div class="mr-8">
                  <p class="text-3xl font-bold text-blue-500">{{ club?.member_count || '0' }}+</p>
                  <p class="text-gray-500">Thành viên</p>
                </div>
                <div>
                  <p class="text-3xl font-bold text-blue-500">{{ club?.advisor_count || '0' }}</p>
                  <p class="text-gray-500">Giảng viên cố vấn</p>
                </div>
              </div>
            </div>

            <!-- Ảnh đại diện -->
            <div class="w-1/2 grid grid-cols-3 gap-4 p-4">
              <img 
                v-for="(image, index) in (club?.background_images || [])" 
                :key="index" 
                :src="image.image_url" 
                class="rounded-lg object-cover w-full h-full" 
                alt="Club Image" 
              />
              <!-- Fallback images if not enough club images -->
              <template>
                <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
                  <div 
                    v-for="(image, index) in displayImages" 
                    :key="index" 
                    class="aspect-square overflow-hidden rounded-lg"
                  >
                    <img 
                      :src="image.url || image" 
                      :alt="`Club Image ${index + 1}`"
                      class="w-full h-full object-cover rounded-lg"
                    />
                  </div>
                </div>
              </template>
            </div>
          </div>
        </div>
      </div>

      <!-- About Section -->
      <section class="py-12 bg-gray-50">
        <div class="container mx-auto px-4">
          <div class="max-w-6xl mx-auto">
            <h2 class="text-3xl font-bold mb-4">Chúng tôi là ai</h2>
            <div class="flex gap-4 mb-6">
              <span class="px-4 py-2 bg-blue-50 text-blue-600 rounded-full text-sm flex items-center gap-2">
                <PaletteIcon class="w-4 h-4" />
                {{ club?.category.name || 'Loading...' }}
              </span>
            </div>
            <p class="text-gray-600 mb-8">
              {{ club?.description || 'Chưa có mô tả' }}
            </p>

          </div>
        </div>
      </section>

      <!-- Past Events -->
      <section class="py-12">
        <div class="container mx-auto px-4">
          <h2 class="text-xl font-semibold mb-6">Sự kiện đã tổ chức</h2>
          <div class="grid md:grid-cols-3 gap-8">
            <div v-for="event in club?.events" :key="event.id" class="bg-white rounded-lg overflow-hidden shadow-lg">
              <img 
                :src="event.background_images?.[0]?.image_url || '../assets/1.webp'" 
                :alt="event.name" 
                class="w-full h-48 object-cover" 
              />
              <div class="p-6">
                <div class="flex justify-between items-center mb-2">
                  <span class="text-sm text-blue-500">{{ event.status }}</span>
                  <span class="text-sm text-gray-500">{{ formatDate(event.start_date) }}</span>
                </div>
                <h3 class="text-xl font-semibold mt-2 line-clamp-2">{{ event.name }}</h3>
                <p class="text-gray-600 mt-2 line-clamp-3">
                  {{ event.content || 'Chưa có mô tả' }}
                </p>
                <div class="mt-4 flex items-center justify-between">
                  <div class="flex items-center text-sm text-gray-500">
                    <span class="mr-4">
                      <i class="fas fa-map-marker-alt mr-1"></i>
                      {{ event.location }}
                    </span>
                    <span>
                      <i class="fas fa-users mr-1"></i>
                      {{ event.registered_participants }}/{{ event.max_participants }}
                    </span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Management Team -->
      <section class="py-12 bg-gray-50">
        <div class="container mx-auto px-4">
          <h2 class="text-xl font-semibold mb-6">Ban quản trị Câu Lạc Bộ</h2>
          <p class="text-gray-600 mb-6">Những người đứng sau sự thành công của CLB</p>
          <Slider />
          <!-- <button class="bg-blue-500 text-white px-4 py-2 rounded-lg mb-8">
            Xem thêm
          </button> -->

          <div class="grid grid-cols-2 md:grid-cols-5 gap-4">
            <div v-for="member in managementTeam" :key="member.id" class="text-center">
              <img :src="member.avatar" :alt="member.name" class="w-32 h-32 rounded-lg mx-auto mb-2 object-cover" />
              <h3 class="font-medium">{{ member.name }}</h3>
              <p class="text-sm text-gray-500">{{ member.role }}</p>
            </div>
          </div>
        </div>
      </section>

      <!-- Contact Form -->
      <section class="py-12 bg-gray-50">
        <div class="container mx-auto px-4">
          <div
            class="max-w-4xl mx-auto grid md:grid-cols-2 gap-8 bg-gradient-to-r bg-gradient-to-b from-blue-600 to-blue-200 rounded-lg p-8 text-white">
            <div>
              <h2 class="text-xl font-semibold mb-4">Liên hệ tài trợ</h2>
              <p class="mb-4">
                Hãy để lại thông tin để chúng tôi có thể liên hệ với bạn
              </p>
              <div class="space-y-2">
                <p>nguyengiakhanhqqq@gmail.com</p>
                <p>0338365247</p>
              </div>
              <div class="mt-4">
                <FacebookIcon class="w-6 h-6" />
              </div>
            </div>

            <form class="space-y-4 bg-white rounded-lg p-6 shadow-md">
              <input type="text" placeholder="Khánh Nguyễn"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg text-gray-800 placeholder-gray-500" />
              <input type="tel" placeholder="0334567890"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg text-gray-800 placeholder-gray-500" />
              <input type="email" placeholder="21520147@gm.uit.edu.vn"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg text-gray-800 placeholder-gray-500" />
              <textarea rows="4" placeholder="Nội dung"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg text-gray-800 placeholder-gray-500"></textarea>
              <button type="submit"
                class="bg-white border border-gray-300 text-blue-600 px-6 py-2 rounded-lg hover:bg-gray-100">
                Gửi
              </button>
            </form>
          </div>
        </div>
      </section>

      <!-- Club Members -->
      <section class="py-12 bg-gray-50">
        <div class="container mx-auto px-4">
          <h2 class="text-xl font-semibold text-center mb-2">Thành viên Câu Lạc Bộ</h2>
          <p class="text-gray-600 text-center mb-8">Cùng lắng nghe họ nói gì về CLB</p>
          <Comment />
          <button 
            @click="handleJoinRequest" 
            :disabled="isJoining || joinStatus === 'pending' || joinStatus === 'accepted'"
            class="block mx-auto px-4 py-2 rounded-lg mb-12"
            :class="{
              'bg-blue-500 text-white hover:bg-blue-600': !joinStatus || joinStatus === 'rejected',
              'bg-yellow-500 text-white': joinStatus === 'pending',
              'bg-green-500 text-white': joinStatus === 'accepted',
              'opacity-75 cursor-not-allowed': isJoining
            }"
          >
            <span v-if="isJoining">Đang xử lý...</span>
            <span v-else-if="joinStatus === 'pending'">Đang chờ duyệt</span>
            <span v-else-if="joinStatus === 'accepted'">Đã là thành viên</span>
            <span v-else>Đăng ký thành viên</span>
          </button>

          <!-- Testimonials -->
          <div class="grid md:grid-cols-3 gap-8">
            <div v-for="testimonial in testimonials" :key="testimonial.id" class="text-center">
              <div class="text-6xl text-gray-200 mb-4">"</div>
              <img :src="testimonial.avatar" :alt="testimonial.name" class="w-20 h-20 mx-auto mb-4" />
              <p class="text-gray-600 mb-4">{{ testimonial.quote }}</p>
              <h3 class="font-medium">{{ testimonial.name }}</h3>
              <p class="text-sm text-gray-500">{{ testimonial.role }}</p>
            </div>
          </div>
        </div>
      </section>
    </template>
  </div>
</template>

<script setup>

import { ref, onMounted, computed } from 'vue';
import { useClubStore } from "../stores/clubStore";
import { useDepartmentStore } from "../stores/departmentStore";
import { useRoute, useRouter } from "vue-router";
import { storeToRefs } from 'pinia';
import joinRequestService from '../services/joinRequest';
import Slider from '../components/ClubManage/Slider.vue';
import Comment from '../components/ClubManage/Comment.vue';


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
const departmentStore = useDepartmentStore();
const route = useRoute();
const router = useRouter();
const id = route.params.id;

// Get reactive state from store
const { selectedClub: club, isLoading: loading, error } = storeToRefs(clubStore);
const { clubDepartments } = storeToRefs(departmentStore);

const isJoining = ref(false);
const joinStatus = ref(null);
const joinError = ref(null);

const isAuthenticated = computed(() => {
  const user = localStorage.getItem('user');
  return !!user;
});

const handleJoinRequest = async () => {
  if (isJoining.value) return;
  
  if (!isAuthenticated.value) {
    // Lưu current URL để redirect sau khi đăng nhập
    localStorage.setItem('redirectAfterLogin', router.currentRoute.value.fullPath);
    router.push('/login');
    return;
  }
  
  try {
    isJoining.value = true;
    joinError.value = null;
    
    if (!id) {
      throw new Error('Không tìm thấy thông tin CLB');
    }

    await joinRequestService.createJoinRequest(id);
    joinStatus.value = 'pending';
    alert('Đăng ký thành công! Vui lòng chờ phê duyệt.');
  } catch (error) {
    console.error('Error joining club:', error);
    
    if (error.message === 'Vui lòng đăng nhập để đăng ký tham gia CLB') {
      localStorage.setItem('redirectAfterLogin', router.currentRoute.value.fullPath);
      router.push('/login');
      return;
    }
    
    joinError.value = error.message || 'Có lỗi xảy ra khi đăng ký. Vui lòng thử lại sau.';
    alert(joinError.value);
  } finally {
    isJoining.value = false;
  }
};

const checkJoinStatus = async () => {
  if (!isAuthenticated.value) {
    joinStatus.value = null;
    return;
  }

  try {
    const response = await joinRequestService.getClubJoinStatus(id);
    joinStatus.value = response.status;
  } catch (error) {
    console.error('Error checking join status:', error);
    joinError.value = error.message;
    joinStatus.value = null;
  }
};

const fetchClub = async () => {
  try {
    await clubStore.fetchClubById(id);
  } catch (error) {
    console.error('Error fetching club:', error);
  }
};

onMounted(() => {
  fetchClub();
  checkJoinStatus();
  departmentStore.fetchClubDepartments(id);
});

// Format date function
const formatDate = (dateString) => {
  if (!dateString) return '';
  const date = new Date(dateString);
  return new Intl.DateTimeFormat('vi-VN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  }).format(date);
};

</script>