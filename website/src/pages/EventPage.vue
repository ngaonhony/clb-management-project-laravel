<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Loading State -->
    <div v-if="eventStore.isLoading" class="flex justify-center items-center min-h-screen">
      <div class="animate-spin rounded-full h-32 w-32 border-b-2 border-blue-500"></div>
    </div>

    <!-- Error State -->
    <div v-else-if="eventStore.error" class="flex justify-center items-center min-h-screen">
      <div class="text-center">
        <p class="text-red-500 text-xl mb-4">{{ eventStore.error }}</p>
        <button @click="fetchEvent" class="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600">
          Thử lại
        </button>
      </div>
    </div>

    <!-- Content when data is loaded -->
    <main v-else class="max-w-7xl mx-auto px-4 py-8">
      <div class="bg-white rounded-lg shadow-lg overflow-hidden">
        <div class="p-8">
          <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div class="md:col-span-2 space-y-6">
              <section>
                <h2 class="text-2xl font-bold mb-4">
                  {{ event?.name }}
                </h2>
                <div class="flex items-center space-x-4">
                  <div class="relative w-16 h-16">
                    <div v-if="clubLogo.loading" class="absolute inset-0 flex items-center justify-center bg-gray-100 rounded-full">
                      <div class="animate-spin h-6 w-6 border-2 border-blue-500 rounded-full border-t-transparent"></div>
                    </div>
                    <img
                      v-if="clubLogo.url"
                      :src="clubLogo.url"
                      alt="Club Logo"
                      class="h-16 w-16 rounded-full object-cover transition-opacity duration-300"
                      :class="{ 'opacity-0': clubLogo.loading }"
                      @load="handleImageLoad('clubLogo')"
                      @error="handleImageError('clubLogo')" />
                  </div>
                  <div>
                    <h3 class="text-lg font-semibold">
                      {{ event?.club?.name }}
                    </h3>
                    <p class="text-gray-600">Đơn vị tổ chức</p>
                  </div>
                </div>
              </section>
              <section>
                <h2 class="text-2xl font-bold mb-4">Nội dung chi tiết</h2>
                <div class="prose max-w-none">
                  {{ event?.content || 'Chưa có nội dung chi tiết' }}
                </div>
              </section>
            </div>

            <div class="space-y-6">
              <div class="relative h-80">
                <div class="relative w-full h-full">
                  <div v-if="eventImage.loading" class="absolute inset-0 flex items-center justify-center bg-gray-100 rounded-lg">
                    <div class="animate-spin h-8 w-8 border-2 border-blue-500 rounded-full border-t-transparent"></div>
                  </div>
                  <img
                    v-if="eventImage.url"
                    :src="eventImage.url"
                    :alt="event?.name"
                    class="w-full h-full object-cover rounded-lg transition-opacity duration-300"
                    :class="{ 'opacity-0': eventImage.loading }"
                    @load="handleImageLoad('eventImage')"
                    @error="handleImageError('eventImage')" />
                </div>
                <div class="absolute inset-0 bg-black bg-opacity-50 flex items-center justify-center rounded-lg">
                  <div class="text-center text-white p-4">
                    <span class="inline-block px-3 py-1 bg-blue-500 text-white rounded-full text-sm mb-4">
                      {{ event?.status }}
                    </span>
                    <h1 class="text-2xl font-bold mb-2">
                      {{ event?.name }}
                    </h1>
                    <p class="text-lg">{{ event?.club?.name }}</p>
                  </div>
                </div>
              </div>

              <div class="bg-gray-50 p-6 rounded-lg space-y-4">
                <h3 class="text-lg font-semibold mb-4">Thông tin Event</h3>
                <div class="space-y-4">
                  <div class="flex items-start space-x-3">
                    <ClockIcon class="h-5 w-5 text-gray-500 mt-0.5" />
                    <div>
                      <h4 class="font-medium">Ngày bắt đầu</h4>
                      <p class="text-gray-600">{{ formatDate(event?.start_date) }}</p>
                    </div>
                  </div>
                  <div class="flex items-start space-x-3">
                    <ClockIcon class="h-5 w-5 text-gray-500 mt-0.5" />
                    <div>
                      <h4 class="font-medium">Ngày kết thúc</h4>
                      <p class="text-gray-600">{{ formatDate(event?.end_date) }}</p>
                    </div>
                  </div>
                  <div class="flex items-start space-x-3">
                    <MapPinIcon class="h-5 w-5 text-gray-500 mt-0.5" />
                    <div>
                      <h4 class="font-medium">Địa điểm</h4>
                      <p class="text-gray-600">{{ event?.location }}</p>
                    </div>
                  </div>
                  <div class="flex items-start space-x-3">
                    <UsersIcon class="h-5 w-5 text-gray-500 mt-0.5" />
                    <div>
                      <h4 class="font-medium">Số lượng tham gia</h4>
                      <p class="text-gray-600">{{ event?.registered_participants }}/{{ event?.max_participants }} người đăng ký</p>
                    </div>
                  </div>
                </div>

                <button
                  @click="handleRegistration"
                  :disabled="isJoining || registrationStatus === 'pending' || registrationStatus === 'approved'"
                  class="w-full py-2 px-4 rounded-lg transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                  :class="{
                    'bg-blue-600 text-white hover:bg-blue-700': !registrationStatus || registrationStatus === 'rejected',
                    'bg-yellow-500 text-white': registrationStatus === 'pending',
                    'bg-green-500 text-white': registrationStatus === 'approved',
                    'opacity-75 cursor-not-allowed': isJoining
                  }"
                >
                  <span v-if="isJoining">Đang xử lý...</span>
                  <span v-else-if="registrationStatus === 'pending'">Đang chờ duyệt</span>
                  <span v-else-if="registrationStatus === 'approved'">Đã tham gia sự kiện</span>
                  <span v-else>Đăng ký tham gia</span>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import Image1 from '../assets/1.webp';
import { MapPinIcon, PhoneIcon, MailIcon, ClockIcon, UsersIcon } from "lucide-vue-next";
import { ref, onMounted, computed, watch, onUnmounted } from 'vue';
import { useEventStore } from "../stores/eventStore";
import { useRoute, useRouter } from "vue-router";
import { storeToRefs } from 'pinia';
import { useJoinRequestStore } from "../stores/joinRequestStore";

const eventStore = useEventStore();
const joinRequestStore = useJoinRequestStore();
const route = useRoute();
const router = useRouter();
const id = computed(() => route.params.id);

// Reactive references for images with loading states
const clubLogo = ref({ url: null, loading: false, error: false });
const eventImage = ref({ url: null, loading: false, error: false });
const event = computed(() => eventStore.selectedEvent);

// Thêm state cho trạng thái đăng ký
const registrationStatus = ref(null);
const isJoining = ref(false);
const pollingInterval = ref(null);

// Handle image loading states
const handleImageLoad = (type) => {
  if (type === 'clubLogo') {
    clubLogo.value.loading = false;
  } else if (type === 'eventImage') {
    eventImage.value.loading = false;
  }
};

const handleImageError = (type) => {
  if (type === 'clubLogo') {
    clubLogo.value.error = true;
    clubLogo.value.loading = false;
    clubLogo.value.url = Image1;
  } else if (type === 'eventImage') {
    eventImage.value.error = true;
    eventImage.value.loading = false;
    eventImage.value.url = Image1;
  }
};

// Format date with memoization
const dateFormatter = new Intl.DateTimeFormat('vi-VN', {
  year: 'numeric',
  month: '2-digit',
  day: '2-digit',
  hour: '2-digit',
  minute: '2-digit'
});

const formatDate = (dateString) => {
  if (!dateString) return 'Chưa cập nhật';
  return dateFormatter.format(new Date(dateString));
};

// Watch for event changes to update images
watch(() => event.value, (newEvent) => {
  if (newEvent) {
    // Update club logo
    if (newEvent.club?.background_images?.[0]?.image_url) {
      clubLogo.value = {
        url: newEvent.club.background_images[0].image_url,
        loading: true,
        error: false
      };
    }
    
    // Update event image
    if (newEvent.background_images?.[0]?.image_url) {
      eventImage.value = {
        url: newEvent.background_images[0].image_url,
        loading: true,
        error: false
      };
    }
  }
}, { immediate: true });

const fetchEvent = async () => {
  try {
    await eventStore.fetchEventById(id.value);
  } catch (error) {
    console.error('Error fetching event:', error);
  }
};

// Hàm kiểm tra trạng thái đăng ký
const checkRegistrationStatus = async (forceRefresh = false) => {
  try {
    // Fetch user requests
    await joinRequestStore.fetchUserRequests(forceRefresh);
    
    // Get status for current event
    const status = joinRequestStore.getEventRequestStatus(id.value);
    registrationStatus.value = status;

    // Nếu đang chờ duyệt, tiếp tục polling
    if (status === 'pending' && !pollingInterval.value) {
      startPolling();
    } else if (status !== 'pending' && pollingInterval.value) {
      stopPolling();
    }
  } catch (error) {
    console.error('Error checking registration status:', error);
    registrationStatus.value = null;
  }
};

// Hàm bắt đầu polling
const startPolling = () => {
  pollingInterval.value = setInterval(() => {
    checkRegistrationStatus(true); // Force refresh khi polling
  }, 30000); // Poll mỗi 30 giây
};

// Hàm dừng polling
const stopPolling = () => {
  if (pollingInterval.value) {
    clearInterval(pollingInterval.value);
    pollingInterval.value = null;
  }
};

// Cập nhật hàm handleRegistration
const handleRegistration = async () => {
  if (isJoining.value) return;
  
  try {
    isJoining.value = true;
    
    // Kiểm tra đăng nhập
    const user = JSON.parse(localStorage.getItem('user'));
    if (!user) {
      localStorage.setItem('redirectAfterLogin', router.currentRoute.value.fullPath);
      router.push('/login');
      return;
    }

    // Tạo yêu cầu đăng ký
    await joinRequestStore.createJoinRequest(null, id.value);
    registrationStatus.value = 'pending';
    startPolling(); // Bắt đầu polling sau khi đăng ký
    alert('Đăng ký thành công! Vui lòng chờ phê duyệt.');
  } catch (error) {
    console.error('Error registering for event:', error);
    alert(error.message);
  } finally {
    isJoining.value = false;
  }
};

onMounted(() => {
  fetchEvent();
  checkRegistrationStatus();
});

// Cleanup
onUnmounted(() => {
  stopPolling();
});
</script>

<style>
.prose {
  @apply text-gray-600 leading-relaxed;
}
.prose p {
  @apply mb-4;
}
img {
  object-fit: cover;
}

/* Add image loading animation */
img {
  transition: opacity 0.3s ease-in-out;
}
img[src] {
  opacity: 1;
}
img:not([src]) {
  opacity: 0;
}

/* Add hover effects */
button {
  transition: all 0.2s ease-in-out;
}
button:hover {
  transform: translateY(-1px);
}
button:active {
  transform: translateY(0);
}
</style>