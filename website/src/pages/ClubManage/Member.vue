<template>
    <div class="p-6 bg-gray-50 min-h-screen">
        <!-- Header -->
        <div class="flex justify-between items-center mb-8">
            <h1 class="text-xl font-semibold">Quản lý Thành viên</h1>
            <div class="flex gap-3">
                <button class="flex items-center px-4 py-2 bg-white border rounded-lg gap-2">
                    <span>Danh sách chờ</span>
                    <span class="bg-gray-100 text-xs px-2 py-0.5 rounded-full">01</span>
                </button>
                <button class="px-4 py-2 bg-white border rounded-lg">
                    Tạo phòng ban
                </button>
                <button class="px-4 py-2 bg-black text-white rounded-lg flex items-center gap-2">
                    <PlusIcon class="w-4 h-4" />
                    Mời tham gia
                </button>
            </div>
        </div>

        <!-- Department Cards -->
        <div class="bg-white rounded-lg p-6 mb-6">
            <h2 class="text-lg font-medium mb-4">Quản lý Phòng ban</h2>
            <div class="grid grid-cols-2 gap-4">
                <div v-for="dept in departments" :key="dept.name" class="p-4 border rounded-lg flex items-center gap-4">
                    <div class="w-10 h-10 rounded-lg bg-blue-50 flex items-center justify-center">
                        <component :is="dept.icon" class="w-5 h-5 text-blue-500" />
                    </div>
                    <div class="flex-1">
                        <h3 class="font-medium">{{ dept.name }}</h3>
                        <p class="text-sm text-gray-500">{{ dept.members }} thành viên</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Member List -->
        <div class="bg-white rounded-lg p-6">
            <!-- Tabs -->
            <div class="flex gap-4 border-b mb-4">
                <button class="px-4 py-2 text-blue-500 border-b-2 border-blue-500">
                    Tất cả
                </button>
                <button class="px-4 py-2 text-gray-500">
                    Ban Truyền Thông
                </button>
                <button class="px-4 py-2 text-gray-500">
                    Ban Đối ngoại
                </button>
            </div>

            <!-- Search and Filter -->
            <div class="flex gap-4 mb-4">
                <div class="flex-1 relative">
                    <SearchIcon class="w-5 h-5 absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" />
                    <input type="text" placeholder="Tìm kiếm" class="w-full pl-10 pr-4 py-2 border rounded-lg">
                </div>
                <button class="px-4 py-2 border rounded-lg flex items-center gap-2">
                    <FilterIcon class="w-4 h-4" />
                    Lọc theo
                </button>
            </div>

            <!-- Table -->
            <table class="w-full">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="text-left py-3 px-4">Thành viên</th>
                        <th class="text-left py-3 px-4">Phòng ban / Chức vụ</th>
                        <th class="text-left py-3 px-4">Thông tin Liên hệ</th>
                        <th class="text-left py-3 px-4"></th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="member in members" :key="member.id" class="border-b">
                        <td class="py-4 px-4">
                            <div class="flex items-center gap-3">
                                <img :src="member.avatar" alt="" class="w-10 h-10 rounded-full">
                                <span class="font-medium">{{ member.name }}</span>
                            </div>
                        </td>
                        <td class="py-4 px-4">
                            <div>
                                <p class="font-medium">{{ member.role }}</p>
                                <p class="text-sm text-gray-500">{{ member.department }}</p>
                            </div>
                        </td>
                        <td class="py-4 px-4">
                            <div>
                                <p class="text-gray-500">{{ member.phone }}</p>
                                <p class="text-gray-500">{{ member.email }}</p>
                            </div>
                        </td>
                        <td class="py-4 px-4">
                            <div class="flex gap-2">
                                <button class="p-2 hover:bg-gray-100 rounded-lg">
                                    <UserIcon class="w-4 h-4" />
                                </button>
                                <button class="p-2 hover:bg-gray-100 rounded-lg">
                                    <PencilIcon class="w-4 h-4" />
                                </button>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</template>

<script setup>
import { ref } from 'vue'
import {
    PlusIcon,
    SearchIcon,
    FilterIcon,
    UserIcon,
    PencilIcon,
    MessageSquareIcon,
    UsersIcon
} from 'lucide-vue-next'

const departments = ref([
    {
        name: 'Ban Truyền Thông',
        members: 10,
        icon: MessageSquareIcon
    },
    {
        name: 'Ban Đối ngoại',
        members: 15,
        icon: UsersIcon
    },
])

const members = ref([
    {
        id: 1,
        name: 'Nguyễn Thị Nhàn',
        role: 'Thành viên',
        department: 'Ban Truyền Thông',
        phone: '0943211427',
        email: 'nhan@zm.vn',
        avatar: 'https://data.voh.com.vn/voh/Image/2019/09/19/phuongly0926_20190919151153.jpg'
    },
    {
        id: 2,
        name: 'Chú Cá',
        role: 'Trưởng ban',
        department: 'Ban Truyền Thông',
        phone: '0935211827',
        email: 'fish@zm.vn',
        avatar: 'https://yt3.ggpht.com/ytc/AIdro_n13floGeIEAVMn6vM5GKlvLYGtEdH96lXUp23VFlVqpQ=s88-c-k-c0x00ffffff-no-rj'
    },
])
</script>