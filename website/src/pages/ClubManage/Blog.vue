<template>
    <div class="p-6 bg-gray-50 min-h-screen">
        <!-- Header -->
        <div class="flex justify-between items-center mb-8">
            <h1 class="text-xl font-medium">Quản lý Blog</h1>
            <div class="flex gap-3">
                <button class="p-2">
                    <MessageCircleIcon class="w-6 h-6" />
                </button>
                <button class="p-2">
                    <BellIcon class="w-6 h-6" />
                </button>
                <div class="w-10 h-10 rounded-full bg-yellow-400 flex items-center justify-center">
                    <UserIcon class="w-6 h-6 text-white" />
                </div>
            </div>
        </div>

        <!-- Search and Filters -->
        <div class="pb-4 space-y-4">
            <div class="flex items-center space-x-4">
                <div class="flex-1 relative">
                    <SearchIcon class="w-5 h-5 absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" />
                    <input type="text" placeholder="Tìm kiếm Blog"
                        class="w-full pl-10 pr-4 py-2 rounded-lg border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
                <div class="relative">
                    <select
                        class="appearance-none px-4 py-2 pr-8 rounded-lg border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500">
                        <option>Tất cả</option>
                    </select>
                    <ChevronDownIcon
                        class="w-5 h-5 absolute right-2 top-1/2 transform -translate-y-1/2 text-gray-400 pointer-events-none" />
                </div>
                <button class="p-2 border rounded-lg">
                    <ArrowUpDownIcon class="w-5 h-5" />
                </button>
                <button @click="openModal" class="flex items-center space-x-2 px-4 py-2 bg-black text-white rounded-lg">
                    <PlusIcon class="w-5 h-5" />
                    <span>Tạo Blog</span>
                </button>
            </div>
        </div>

        <!-- Blog List -->
        <div class="bg-white rounded-lg max-h-auto">
            <div class="flex flex-wrap gap-4 items-center justify-center p-4">
                <div v-for="blog in blogs" :key="blog.id" class="w-9/12 bg-white rounded-lg shadow">
                    <!-- Header -->
                    <div class="p-4 border-b flex items-center relative">
                        <div class="flex items-center space-x-3">
                            <img :src="Image2" alt="Movie Comparison" class="w-10 h-10 bg-gray-300 rounded-full" />
                            <div>
                                <h2 class="font-semibold text-gray-800">CLB Name</h2>
                                <p class="text-xs text-gray-500">12 tháng 12 lúc 18:54</p>
                            </div>
                        </div>
                        <button @click="toggleDropdown($event, blog.id)" class="p-2 ml-auto dropdown-trigger">
                            <MoreVerticalIcon class="w-5 h-5" />
                        </button>

                        <!-- Dropdown Menu -->
                        <div v-if="openDropdownId === blog.id" ref="dropdownMenu"
                            class="absolute bg-white rounded-lg shadow-lg border border-gray-200 py-1 z-50 dropdown-menu"
                            :style="{ top: `${dropdownPosition.top}px`, left: `${dropdownPosition.left}px` }">
                            <button v-for="(option, index) in options" :key="index"
                                class="w-full px-4 py-2.5 flex items-center gap-3 hover:bg-gray-50 transition-colors"
                                :class="{ 'text-red-500 hover:text-red-600': option.danger }">
                                <component :is="option.icon" class="w-5 h-5" />
                                <span class="text-sm">{{ option.label }}</span>
                            </button>
                        </div>
                    </div>

                    <!-- Content -->
                    <div class="p-2">
                        <p class="text-gray-800 mb-4">
                            {{ blog.title }}
                        </p>
                        <!-- Image -->
                        <div class="rounded-lg overflow-hidden mb-4">
                            <img :src="blog.image" alt="Movie Comparison" class="w-full max-h-80 object-contain" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Modal -->
        <ModalCreate :isOpen="isModalOpen" @close="closeModal" />
    </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue';
import ModalCreate from '../../components/ClubManage/BlogManage/ModalCreate.vue';

import {
    ChevronLeftIcon,
    MessageCircleIcon,
    BellIcon,
    UserIcon,
    SearchIcon,
    ChevronDownIcon,
    ArrowUpDownIcon,
    PlusIcon,
    CheckCircleIcon,
    MoreVerticalIcon,
    Trash2,
    Eye,
    Users,
    PenSquare,
    Plus,
} from 'lucide-vue-next';

import Image1 from '../../assets/1.webp';
import Image2 from '../../assets/2.webp';
import Image3 from '../../assets/3.webp';
import Image4 from '../../assets/4.webp';
import Image5 from '../../assets/5.webp';

const blogs = [
    {
        id: 1,
        image: Image1,
        title: 'Lorem eget venenatis vestibulum odio egestas bibendum urna...',
    },
    {
        id: 2,
        image: Image2,
        title: 'Elementum dignissim tristique pellentesque eleifend posuere.',
    },
    {
        id: 3,
        image: Image3,
        title: 'Porta aliquet sed viverra fringilla.',
    },
    {
        id: 4,
        image: Image4,
        title: 'Non vitae tristique in sed aenean consectetur.',
    },
    {
        id: 5,
        image: Image5,
        title: 'Massa leo scelerisque bibendum eu commodo at vestibulum.',
    }
];

const isModalOpen = ref(false);
const openModal = () => isModalOpen.value = true;
const closeModal = () => isModalOpen.value = false;

const options = [
    {
        label: 'Chỉnh sửa Blog',
        icon: PenSquare
    },
    {
        label: 'Xóa Blog',
        icon: Trash2,
        danger: true
    }
];

const openDropdownId = ref(null);
const dropdownMenu = ref(null);
const dropdownPosition = ref({ top: 0, left: 0 });

const toggleDropdown = (event, blogId) => {
    if (openDropdownId.value === blogId) {
        openDropdownId.value = null;
    } else {
        openDropdownId.value = blogId;
        const rect = event.target.getBoundingClientRect();
        dropdownPosition.value = {
            top: rect.bottom - rect.top + 8,
            left: rect.right - rect.left + 450
        };
    }
};

const handleClickOutside = (event) => {
    if (openDropdownId.value !== null &&
        !event.target.closest('.dropdown-trigger') &&
        !event.target.closest('.dropdown-menu')) {
        openDropdownId.value = null;
    }
};

onMounted(() => {
    document.addEventListener('click', handleClickOutside);
});

onBeforeUnmount(() => {
    document.removeEventListener('click', handleClickOutside);
});
</script>

<style scoped>
/* Add any scoped styles here if needed */
</style>