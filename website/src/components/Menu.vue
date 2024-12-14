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
                <!-- Dashboard -->
                <li>
                    <router-link to="/clb/dashboard" class="flex items-center px-4 py-2 hover:bg-gray-100 rounded-lg"
                        :class="{ 'text-blue-600 bg-sky-500/5': currentRoute === 'dashboard', 'text-gray-700': currentRoute !== 'dashboard' }">
                        <HomeIcon class="w-5 h-5 mr-3"
                            :class="{ 'text-blue-600': currentRoute === 'dashboard', 'text-gray-700': currentRoute !== 'dashboard' }" />
                        <span>Dashboard</span>
                    </router-link>
                </li>

                <!-- Club Info -->
                <li>
                    <router-link to="#" class="flex items-center px-4 py-2 hover:bg-gray-100 rounded-lg"
                        :class="{ 'text-blue-600': currentRoute === 'club-info', 'text-gray-700': currentRoute !== 'club-info' }">
                        <InfoIcon class="w-5 h-5 mr-3"
                            :class="{ 'text-blue-600': currentRoute === 'club-info', 'text-gray-700': currentRoute !== 'club-info' }" />
                        <span>Thông tin CLB</span>
                    </router-link>
                </li>

                <!-- Layout Grid -->
                <li>
                    <router-link to="/clb/quan-ly-trang-dai-dien"
                        class="flex items-center px-4 py-2 hover:bg-gray-100 rounded-lg"
                        :class="{ 'text-blue-600 bg-sky-500/5': currentRoute === 'introduce', 'text-gray-700': currentRoute !== 'introduce' }">
                        <LayoutGridIcon class="w-5 h-5 mr-3"
                            :class="{ 'text-blue-600': currentRoute === 'introduce', 'text-gray-700': currentRoute !== 'introduce' }" />
                        <span>Quản lý Trang đại diện</span>
                    </router-link>
                </li>

                <!-- Member Management -->
                <li>
                    <router-link to="/clb/quan-ly-thanh-vien"
                        class="flex items-center px-4 py-2 hover:bg-gray-100 rounded-lg"
                        :class="{ 'text-blue-600 bg-sky-500/5': currentRoute === 'member', 'text-gray-700': currentRoute !== 'member' }">
                        <UsersIcon class="w-5 h-5 mr-3"
                            :class="{ 'text-blue-600': currentRoute === 'member', 'text-gray-700': currentRoute !== 'member' }" />
                        <span>Quản lý Thành viên</span>
                    </router-link>
                </li>

                <!-- Event Management -->
                <li>
                    <button @click="toggleEventMenu"
                        class="w-full flex items-center px-4 py-2 hover:bg-gray-100 rounded-lg"
                        :class="{ 'text-blue-600': currentRoute === 'events', 'text-gray-700': currentRoute !== 'events' }">
                        <CalendarIcon class="w-5 h-5 mr-3"
                            :class="{ 'text-blue-600': currentRoute === 'events', 'text-gray-700': currentRoute !== 'events' }" />
                        <span>Quản lý Sự kiện</span>
                        <ChevronDownIcon class="w-4 h-4 ml-auto transition-transform duration-200"
                            :class="{ 'rotate-180': isEventMenuOpen }" />
                    </button>
                </li>
            </ul>
        </nav>
    </aside>
</template>

<script setup>
import { computed } from 'vue';
import { useRoute } from 'vue-router';
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

const route = useRoute();

const currentRoute = computed(() => route.name);

</script>
