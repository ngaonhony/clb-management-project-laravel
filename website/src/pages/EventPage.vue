<template>
  <div class="min-h-screen bg-gray-50">
    <main class="max-w-7xl mx-auto px-4 py-8">
      <div class="bg-white rounded-lg shadow-lg overflow-hidden">
        <div class="p-8">
          <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div class="md:col-span-2 space-y-6">
              <section>
                <h2 class="text-2xl font-bold mb-4">
                  <!-- Workshop "Data-driven Marketing" -->
                  {{ eventStore.selectedEvent?.name || 'Đang tải...'  }}

                </h2>
                <div class="flex items-center space-x-4">
                  <img
                     :src="Image1"
                    alt="Marketing UEL Club Logo"
                    class="h-16 w-16 rounded-full object-cover" />
                  <div>
                    <h3 class="text-lg font-semibold">
                      <!-- Marketing UEL Club -->
                      {{ eventStore.selectedEvent?.club.name || 'Đang tải...'  }}

                    </h3>
                    <p class="text-gray-600">Đơn vị tổ chức</p>
                  </div>
                </div>
              </section>
              <section>
                <h2 class="text-2xl font-bold mb-4">Nội dung chi tiết</h2>
                <div class="prose max-w-none">
                  {{ eventStore.selectedEvent?.content || 'Đang tải...'  }}

                </div>
              </section>
            </div>

            <div class="space-y-6">
              <div class="relative h-80">
                <img
                   :src="Image2"
                  alt="Data-driven Marketing Workshop Banner"
                  class="w-full h-full object-cover" />
                <div
                  class="absolute inset-0 bg-black bg-opacity-50 flex items-center justify-center">
                  <div class="text-center text-white">
                    <h1 class="text-4xl font-bold mb-4">
                      {{ eventStore.selectedEvent?.name || 'Đang tải...'  }}
                    </h1>
                    <p class="text-xl">{{ eventStore.selectedEvent?.club.name || 'Đang tải...'  }}
                    </p>
                  </div>
                </div>
              </div>

              <div class="bg-gray-50 p-6 rounded-lg space-y-4">
                <h3 class="text-lg font-semibold mb-4">Thông tin Event</h3>
                <div class="space-y-2">
                  <div class="flex items-start space-x-3">
                    <ClockIcon class="h-5 w-5 text-gray-500 mt-0.5" />
                    <div>
                      <h4 class="font-medium">Ngày bắt đầu</h4>
                      <p class="text-gray-600">{{ eventStore.selectedEvent?.start_date || 'Đang tải...'  }}
                      </p>
                    </div>
                  </div>
                  <div class="flex items-start space-x-3">
                    <ClockIcon class="h-5 w-5 text-gray-500 mt-0.5" />
                    <div>
                      <h4 class="font-medium">Ngày kết thúc</h4>
                      <p class="text-gray-600">{{ eventStore.selectedEvent?.end_date || 'Đang tải...'  }}</p>
                    </div>
                  </div>
                  <div class="flex items-start space-x-3">
                    <MapPinIcon class="h-5 w-5 text-gray-500 mt-0.5" />
                    <div>
                      <h4 class="font-medium">Địa điểm</h4>
                      <p class="text-gray-600">{{ eventStore.selectedEvent?.location || 'Đang tải...'  }}</p>
                    </div>
                  </div>
                  <div class="flex items-start space-x-3">
                    <UsersIcon class="h-5 w-5 text-gray-500 mt-0.5" />
                    <div>
                      <p class="text-gray-600">{{ eventStore.selectedEvent?.registered_participants || 'Đang tải...'  }} người sẽ tham gia sự kiện này</p>
                    </div>
                  </div>
                </div>

                <button
                  class="w-full bg-blue-600 text-white py-2 px-4 rounded-lg hover:bg-blue-700 transition-colors">
                  Đăng ký
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
import Image2 from '../assets/2.webp';
import { MapPinIcon, PhoneIcon, MailIcon, ClockIcon, UsersIcon } from "lucide-vue-next";
import { ref, onMounted } from 'vue';
import { useEventStore } from "../stores/eventStore";
import { useRoute } from "vue-router";

const eventStore = useEventStore();
const route = useRoute();
const id = route.params.id;

onMounted(() => {
  eventStore.fetchEventById(id);
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
  object-fit: cover; /* Ensures images cover their containers */
}
</style>