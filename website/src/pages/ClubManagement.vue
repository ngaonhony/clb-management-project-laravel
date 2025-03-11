<template>
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

        <!-- Main Content -->
        <div class="container mx-auto px-4 py-8">
            <div class="flex justify-between items-center mb-6">
                <div>
                    <h1 class="text-2xl font-bold text-blue-600 mb-2">Câu lạc bộ của tôi</h1>
                    <p class="text-gray-600">
                        Quản lý danh sách các CLB mà bạn đã
                        <span class="font-medium">Tạo</span> hoặc đã
                        <span class="font-medium">Tham gia</span>
                    </p>
                </div>
            </div>

            <div class="flex gap-8">
                <!-- Sidebar -->
                <div class="w-64 flex-shrink-0">
                    <div class="bg-white rounded-lg border">
                        <div class="p-4 bg-blue-50 border-b rounded-t-lg">
                            <span class="font-medium">Quản lý Câu lạc bộ</span>
                        </div>
                    </div>
                </div>

                <!-- Club Cards -->
                <div class="flex-1 space-y-6">
                    <div v-for="club in userClubs" :key="club.id"
                        class="bg-white rounded-lg border p-6 transition-transform transform hover:scale-105">
                        <router-link :to="`/clb/dashboard/${club.id}`" @click="clbStore.setCurrentClb(club.id)">
                            <div class="flex">
                                <div class="w-80 h-48 bg-gray-100 rounded-lg overflow-hidden">
                                    <!-- Tăng kích thước hình ảnh -->
                                    <img :src="club.image" :alt="club.name" class="w-full h-full object-cover" />
                                </div>
                                <div class="flex-1 ml-6">
                                    <div class="flex items-start justify-between">
                                        <div>
                                            <div class="flex gap-2 mb-2">
                                                <span v-for="tag in club.tags" :key="tag"
                                                    class="px-3 py-1 rounded-full text-xs" :class="getTagClass(tag)">
                                                    {{ tag }}
                                                </span>
                                            </div>
                                            <h3 class="text-2xl font-semibold mb-2">{{ club.name }}</h3>
                                            <p class="text-gray-600 text-lg">{{ club.description }}</p>
                                        </div>
                                        <div class="flex items-center">

                                            <button
                                                class="px-4 py-2 text-gray-600 hover:bg-gray-50 rounded-md border border-gray-300 hover:border-gray-400">
                                                Quản lý
                                            </button>
                                            <MoreVerticalIcon class="h-6 w-6 text-gray-400 ml-2" />
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </router-link>
                     </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import {
    BellIcon,
    UserCircleIcon,
    PlusIcon,
    MoreVerticalIcon
} from 'lucide-vue-next'
import  {useAuthStore}  from "../stores/authStore";
import {useCLBStore} from "../stores/clubStore";

const authStore = useAuthStore();
const clbStore = useCLBStore();

const userClubs = computed(() => authStore.user?.clubs || []);

const getTagClass = (tag) => {
    const classes = {
        'Học thuật, Chuyên môn': 'bg-green-100 text-green-800',
        'Nghệ thuật, Sáng tạo': 'bg-purple-100 text-purple-800',
        'Quản trị viên': 'bg-gray-100 text-gray-800'
    }
    return classes[tag] || 'bg-gray-100 text-gray-800'
}
</script>

<style scoped>
.container {
    max-width: 1280px;
}
</style>
