<template>
    <div class="p-6 bg-gray-50 min-h-screen">
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
        <section class="bg-gray-200 py-10">
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
        </section>

        <!-- Chúng tôi là ai -->
        <section class="bg-white py-10 p-6">
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