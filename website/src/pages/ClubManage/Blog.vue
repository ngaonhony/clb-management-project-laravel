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
        <SearchAndFilters @openModal="openModal" />

        <!-- Blog List -->
        <BlogList :blogs="blogs" :options="options" />
        <!-- Modal -->
        <ModalCreate :isOpen="isModalOpen" @close="closeModal" />
    </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue';
import ModalCreate from '../../components/ClubManage/BlogManage/ModalCreate.vue';
import BlogList from '../../components/ClubManage/BlogManage/BlogList.vue';
import SearchAndFilters from '../../components/ClubManage/BlogManage/SearchAndFilters.vue';

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