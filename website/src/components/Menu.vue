<template>
    <aside class="w-64 h-screen bg-white border-r border-gray-200 flex flex-col fixed">
        <div class="p-4 flex items-center gap-2">
            <div class="w-8 h-8 rounded-full flex items-center justify-center">
                <img src="../assets/vaa.svg" alt="Logo" class="h-10 mr-3" />
            </div>
            <span class="font-semibold text-gray-800">VAA</span>
        </div>

        <nav class="flex-1 px-2 py-4">
            <ul class="space-y-1">
                <li>
                    <a href="#" class="flex items-center px-4 py-2 text-gray-700 hover:bg-gray-100 rounded-lg"
                        :class="{ 'bg-gray-100': currentRoute === 'dashboard' }">
                        <HomeIcon class="w-5 h-5 mr-3" />
                        <span>Dashboard</span>
                    </a>
                </li>

                <li>
                    <a href="#" class="flex items-center px-4 py-2 text-gray-700 hover:bg-gray-100 rounded-lg"
                        :class="{ 'bg-gray-100': currentRoute === 'club-info' }">
                        <InfoIcon class="w-5 h-5 mr-3" />
                        <span>Thông tin CLB</span>
                    </a>
                </li>

                <li>
                    <a href="#" class="flex items-center px-4 py-2 text-gray-700 hover:bg-gray-100 rounded-lg"
                        :class="{ 'bg-gray-100': currentRoute === 'representative' }">
                        <LayoutGridIcon class="w-5 h-5 mr-3" />
                        <span>Quản lý Trạng đại diện</span>
                    </a>
                </li>

                <!-- Member Management -->
                <li>
                    <a href="#" class="flex items-center px-4 py-2 text-gray-700 hover:bg-gray-100 rounded-lg"
                        :class="{ 'bg-gray-100': currentRoute === 'members' }">
                        <UsersIcon class="w-5 h-5 mr-3" />
                        <span>Quản lý Thành viên</span>
                    </a>
                </li>

                <!-- Event Management -->
                <li>
                    <button @click="toggleEventMenu"
                        class="w-full flex items-center px-4 py-2 text-gray-700 hover:bg-gray-100 rounded-lg"
                        :class="{ 'bg-gray-100': currentRoute === 'events' }">
                        <CalendarIcon class="w-5 h-5 mr-3" />
                        <span>Quản lý Sự kiện</span>
                        <ChevronDownIcon class="w-4 h-4 ml-auto transition-transform duration-200"
                            :class="{ 'rotate-180': isEventMenuOpen }" />
                    </button>
                </li>
            </ul>
        </nav>

        <!-- User Profile Section -->
        <div class="border-t border-gray-200 p-4">
            <div class="flex items-center gap-3">
                <div class="w-8 h-8 rounded-full bg-gray-200 flex items-center justify-center">
                    <UserIcon class="w-5 h-5 text-gray-500" />
                </div>
                <div class="flex-1">
                    <p class="text-sm text-gray-800 truncate">CLB Giải điệu Trẻ mãi k...</p>
                </div>
                <ChevronUpIcon class="w-4 h-4 text-gray-400" />
            </div>
        </div>
    </aside>
</template>

<script setup>
import { ref } from 'vue'
import {
    HomeIcon,
    InfoIcon,
    LayoutGridIcon,
    UsersIcon,
    CalendarIcon,
    ChevronDownIcon,
    ChevronUpIcon,
    UserIcon
} from 'lucide-vue-next'

const currentRoute = ref('dashboard')
const isEventMenuOpen = ref(false)

const toggleEventMenu = () => {
    isEventMenuOpen.value = !isEventMenuOpen.value
}
</script>