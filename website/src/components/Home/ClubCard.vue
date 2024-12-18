<!-- ClubCard.vue -->
<template>
   <div class="px-40 pb-10">
  <!-- Các thẻ ClubCard -->
  <div
    v-for="club in clubs"
    :key="club.id"
    class="bg-white rounded-xl shadow-lg overflow-hidden flex flex-col md:flex-row mb-4"
  >
    <!-- Nội dung bên trái -->
    <div class="pt-6 pr-6 pl-6 pb-2 flex-1">
      <div class="flex items-start gap-4">
        <div class="w-16 h-16 rounded-lg overflow-hidden flex-shrink-0 shadow-sm">
          <img :src="club.img" :alt="club.name" class="w-full h-full object-cover" />
        </div>

        <div class="flex-1">
          <span class="inline-block px-3 py-1 bg-green-100 text-green-700 text-sm font-medium rounded-full mb-2">
            {{ club.category }}
          </span>
          <h2 class="text-2xl font-bold text-gray-800 mb-2">{{ club.name }}</h2>
          <p class="text-gray-600 text-sm leading-relaxed mb-4">
            {{ club.description }}
          </p>
          <div class="flex items-center gap-4 text-sm text-gray-500">
            <div class="flex items-center gap-1">
              <MapPinIcon class="w-4 h-4 text-gray-400" />
              <span>{{ club.location }}</span>
            </div>
            <div class="flex items-center gap-1">
              <UsersIcon class="w-4 h-4 text-gray-400" />
              <span>{{ club.members }} thành viên</span>
            </div>
          </div>
        </div>
      </div>

      <button
        class="mt-6 w-80 py-2 text-center border text-gray-700 font-medium rounded-lg shadow-sm hover:bg-gray-200 transition-all duration-300 mx-auto block"
      >
        Chi tiết
      </button>
    </div>

    <!-- Hình ảnh bên phải -->
    <div class="w-full md:w-[500px] lg:h-[270px] relative overflow-hidden">
      <img
        :src="club.background"
        alt="Club background"
        class="w-full h-full object-cover rounded-lg"
      />
    </div>
  </div>

  <!-- Nút Xem Thêm với đường kẻ -->
  <div class="flex items-center justify-center mt-10">
    <div class="border-t border-gray-300 w-full max-w-4xl"></div>
    <button
      class="mx-4 w-80 border p-2 rounded-lg hover:bg-gray-200 flex items-center justify-center text-gray-700"
    >
      Xem Thêm
      <ChevronDown class="ml-2" />
    </button>
    <div class="border-t border-gray-300 w-full max-w-4xl"></div>
  </div>
</div>
</template>
  
  <script setup>
  import Img1 from "../../assets/1.webp";
  import Img2 from "../../assets/2.webp";
  import Img3 from "../../assets/3.webp";

  import { MapPinIcon, UsersIcon, ChevronDown } from "lucide-vue-next";
  
  defineProps({
    club: Object, // Truyền dữ liệu một câu lạc bộ qua prop
  });
  
  const clubs = [
    {
      id: 1,
      name: "Minishow Len",
      img: Img1,
      background: Img3,
      category: "Nghệ thuật, Sáng tạo",
      description: `"LEN" - hành trình cảm xúc qua những thanh âm du dương. Sự mềm mại, ấm áp len lỏi vào từng cung bậc.`,
      location: "Hà Nội",
      members: 15,
    },
    {
      id: 2,
      name: "Tech Club",
      img: Img2,
      background: Img1,
      category: "Công nghệ, Lập trình",
      description: `"Tech Club" là không gian sáng tạo và học hỏi dành cho các lập trình viên và nhà phát triển trẻ.`,
      location: "TP. Hồ Chí Minh",
      members: 25,
    },
    {
      id: 3,
      name: "Sports Hub",
      img: Img3,
      background: Img2,
      category: "Thể thao, Sức khỏe",
      description: `"Sports Hub" mang đến các hoạt động thể thao đầy năng lượng và thử thách bản thân.`,
      location: "Đà Nẵng",
      members: 20,
    },
  ];
  </script>
  