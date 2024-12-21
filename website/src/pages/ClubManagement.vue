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
                    <div v-for="club in clubs" :key="club.id"
                        class="bg-white rounded-lg border p-6 transition-transform transform hover:scale-105">
                        <router-link to="/clb">
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
import { ref } from 'vue'
import {
    BellIcon,
    UserCircleIcon,
    PlusIcon,
    MoreVerticalIcon
} from 'lucide-vue-next'

const clubs = ref([
    {
        id: 1,
        name: 'Chỗ cho thuê phòng đẹp 2',
        description: '',
        image: 'https://leaderbook.com/_next/image?url=https%3A%2F%2Fedus3.leaderbook.com%2Fprod%2Fupload%2Fimg%2F66d95561ad98c90053039ed4-Vi%C3%A1%C2%BB%C2%87t%20Anh.JPG-1.png&w=384&q=75',
        tags: ['Học thuật, Chuyên môn', 'Quản trị viên']
    },
    {
        id: 2,
        name: 'Chỗ cho thuê phòng đẹp',
        description: 'hihi',
        image: 'https://leaderbook.com/_next/image?url=https%3A%2F%2Fedus3.leaderbook.com%2Fprod%2Fupload%2Fimg%2F66d95561ad98c90053039ed4-Vi%C3%A1%C2%BB%C2%87t%20Anh.JPG-1.png&w=384&q=75',
        tags: ['Nghệ thuật, Sáng tạo', 'Quản trị viên']
    }
])

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
