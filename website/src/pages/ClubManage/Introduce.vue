<template>
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Header -->
        <div class="flex justify-between items-center mb-8">
            <h1 class="text-xl font-semibold">Quản lý Trang đại diện</h1>
            <div class="flex gap-3">
                <button class="px-4 py-2 border rounded-lg flex items-center gap-2">
                    <FileTextIcon class="w-4 h-4" />
                    Xem bản nháp
                </button>   
                <button @click="openModal" class="px-4 py-2 bg-black text-white rounded-lg flex items-center gap-2">
                    <PenIcon class="w-4 h-4" />
                    Tạo Trang đại diện
                </button>
            </div>
        </div>
        <!-- Hero Section -->
    <div class="container mx-auto px-4 py-8">
      <div class="flex items-start gap-8">
        <div class="max-w-6xl mx-auto flex">
                <!-- Thông tin câu lạc bộ -->
                <div class="w-1/2 p-8">
                    <h2 class="text-3xl font-bold mb-6">Tên Câu Lạc Bộ</h2>
                    <div class="flex mb-4">
                        <div class="mr-8">
                            <p class="text-3xl font-bold text-blue-500">10+</p>
                            <p class="text-gray-500">Năm phát triển</p>
                        </div>
                        <div>
                            <p class="text-3xl font-bold text-blue-500">15</p>
                            <p class="text-gray-500">Chương trình</p>
                        </div>
                    </div>
                    <div class="flex">
                        <div class="mr-8">
                            <p class="text-3xl font-bold text-blue-500">50+</p>
                            <p class="text-gray-500">Thành viên</p>
                        </div>
                        <div>
                            <p class="text-3xl font-bold text-blue-500">5</p>
                            <p class="text-gray-500">Giảng viên cố vấn</p>
                        </div>
                    </div>
                </div>

                <!-- Ảnh đại diện -->
                <div class="w-1/2 grid grid-cols-3 gap-4 p-4">
                    <img v-for="n in 6" :key="n" src="../../assets/1.webp" class="rounded-lg object-cover"
                        alt="Club Image" />
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
                        Văn hoá, Nghệ thuật
                    </span>
                </div>
                <p class="text-gray-600 mb-8">
                    Với tầm nhìn phát triển CLB trở thành một CLB nghệ thuật lớn mạnh cả trong và ngoài phạm vi trường
                    đại học...
                </p>

            </div>
      </div>
    </section>

    <!-- Past Events -->
    <section class="py-12">
      <div class="container mx-auto px-4">
        <h2 class="text-xl font-semibold mb-6">Sự kiện đã tổ chức</h2>
        <div class="grid md:grid-cols-3 gap-8">
          <div class="bg-white rounded-lg overflow-hidden shadow-lg">
            <img 
              src="../../assets/1.webp" 
              alt="Event"
              class="w-full h-48 object-cover"
            />
            <div class="p-6">
              <span class="text-sm text-blue-500">Sự kiện Talkshow</span>
              <h3 class="text-xl font-semibold mt-2">Liveshow Ngồi Ngắm Ngày Thơ</h3>
              <p class="text-gray-600 mt-2">
                Một buổi liveshow âm nhạc và thơ ca đặc sắc...
              </p>
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
        <button class="bg-blue-500 text-white px-4 py-2 rounded-lg mb-8">
          Xem thêm
        </button>
        
        <div class="grid grid-cols-2 md:grid-cols-5 gap-4">
          <div v-for="member in managementTeam" :key="member.id" class="text-center">
            <img 
              :src="member.avatar" 
              :alt="member.name"
              class="w-32 h-32 rounded-lg mx-auto mb-2 object-cover"
            />
            <h3 class="font-medium">{{ member.name }}</h3>
            <p class="text-sm text-gray-500">{{ member.role }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Contact Form -->
    <section class="py-12 bg-gray-50">
  <div class="container mx-auto px-4">
    <div class="max-w-4xl mx-auto grid md:grid-cols-2 gap-8 bg-gradient-to-r bg-gradient-to-b from-blue-600 to-blue-200 rounded-lg p-8 text-white">
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
        <input 
          type="text"
          placeholder="Khánh Nguyễn"
          class="w-full px-4 py-2 border border-gray-300 rounded-lg text-gray-800 placeholder-gray-500"
        />
        <input 
          type="tel"
          placeholder="0334567890"
          class="w-full px-4 py-2 border border-gray-300 rounded-lg text-gray-800 placeholder-gray-500"
        />
        <input 
          type="email"
          placeholder="21520147@gm.uit.edu.vn"
          class="w-full px-4 py-2 border border-gray-300 rounded-lg text-gray-800 placeholder-gray-500"
        />
        <textarea 
          rows="4"
          placeholder="Nội dung"
          class="w-full px-4 py-2 border border-gray-300 rounded-lg text-gray-800 placeholder-gray-500"
        ></textarea>
        <button type="submit" class="bg-white border border-gray-300 text-blue-600 px-6 py-2 rounded-lg hover:bg-gray-100">
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
        <button class="block mx-auto bg-blue-500 text-white px-4 py-2 rounded-lg mb-12">
          Đăng ký thành viên
        </button>

        <!-- Testimonials -->
        <div class="grid md:grid-cols-3 gap-8">
          <div v-for="testimonial in testimonials" :key="testimonial.id" class="text-center">
            <div class="text-6xl text-gray-200 mb-4">"</div>
            <img 
              :src="testimonial.avatar" 
              :alt="testimonial.name"
              class="w-20 h-20 mx-auto mb-4"
            />
            <p class="text-gray-600 mb-4">{{ testimonial.quote }}</p>
            <h3 class="font-medium">{{ testimonial.name }}</h3>
            <p class="text-sm text-gray-500">{{ testimonial.role }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Club Photos -->
    <section class="py-12">
      <div class="container mx-auto px-4">
        <h2 class="text-xl font-semibold mb-6">Hình ảnh hoạt động CLB</h2>
        <div class="grid grid-cols-3 gap-4">
          <img 
            src="../../assets/1.webp" 
            alt="Activity 1"
            class="w-full h-64 object-cover rounded-lg"
          />
          <img 
            src="../../assets/1.webp" 
            alt="Activity 2"
            class="w-full h-64 object-cover rounded-lg"
          />
        </div>
      </div>
    </section>

        <!-- Modal -->
        <ModalCreateIntro :isOpen="isModalOpen" @close="closeModal" />
    </div>
</template>

<script setup>
import { ref } from 'vue';
import ModalCreateIntro from '../../components/ClubManage/IntroManage/ModalCreate.vue';
import {
    FileTextIcon,
    PenIcon,
    TargetIcon,
    PaletteIcon,
    GraduationCapIcon
} from 'lucide-vue-next'

const isModalOpen = ref(false);

function openModal() {
    isModalOpen.value = true;
}

function closeModal() {
    isModalOpen.value = false;
}
</script>

<style scoped>
header button {
    transition: background-color 0.3s;
}

header button:hover {
    background-color: #f3f4f6;
}
</style>