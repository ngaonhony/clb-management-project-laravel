<template>
    <div class="p-6 bg-gray-50 min-h-screen">
        <!-- Header -->
        <div class="flex justify-between items-center mb-8">

            <h1 class="text-xl font-medium">Quản lý Sự kiện</h1>

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
        <div class="p-4 space-y-4">
            <div class="flex items-center space-x-4">
                <div class="flex-1 relative">
                    <SearchIcon class="w-5 h-5 absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" />
                    <input type="text" placeholder="Tìm kiếm Sự kiện"
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
                    <span>Tạo Sự kiện</span>
                </button>
            </div>
        </div>

        <!-- Event List -->
        <div class="bg-white rounded-lg p-6">
            <table class="w-full border-collapse border border-gray-200">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="border border-gray-300 text-left py-3 px-4">Event</th>
                        <th class="border border-gray-300 text-left py-3 px-4">Thời gian</th>
                        <th class="border border-gray-300 text-left py-3 px-4">Proposal</th>
                        <th class="border border-gray-300 text-left py-3 px-4">Trạng thái</th>
                        <th class="border border-gray-300 py-3 px-4"></th>
                    </tr>
                </thead>
                <tbody class="divide-y">
                    <tr v-for="event in events" :key="event.id" class="hover:bg-gray-50">
                        <!-- Event -->
                        <td class="border border-gray-300 py-4 px-4">
                            <div class="flex items-center space-x-3">
                                <img :src="event.image" class="w-20 h-18 object-cover rounded" />
                                <div>
                                    <h3 class="font-medium">{{ event.title }}</h3>
                                    <p class="text-sm text-gray-500">{{ event.location }}</p>
                                </div>
                            </div>
                        </td>
                        <!-- Time -->
                        <td class="border border-gray-300 py-4 px-4">
                            <div>
                                <p class="font-medium">{{ event.time }}</p>
                                <p class="text-sm text-gray-500">{{ event.date }}</p>
                            </div>
                        </td>
                        <!-- Proposal -->
                        <td class="border border-gray-300 py-4 px-4">
                            <div v-if="event.proposal" class="flex items-center space-x-2">
                                <CheckCircleIcon class="w-5 h-5 text-green-500" />
                                <a href="#" class="text-blue-500">Xem Proposal</a>
                            </div>
                            <span v-else class="text-gray-500">Không có</span>
                        </td>
                        <!-- Status -->
                        <td class="border border-gray-300 py-4 px-4">
                            <span :class="getStatusClass(event.status)">
                                {{ event.status }}
                            </span>
                        </td>
                        <!-- Actions -->

                        <td class="border border-gray-300 py-4 px-2">
                            <div class="flex items-center space-x-4">

                                <!-- Edit Button -->
                                <button
                                    class="flex items-center justify-center w-12 h-10 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors">
                                    <Pencil class="w-5 h-5" />
                                </button>

                                <!-- Delete Button -->
                                <button
                                    class="flex items-center justify-center w-12 h-10 bg-pink-500 text-white rounded-lg hover:bg-pink-600 transition-colors">
                                    <Trash2 class="w-5 h-5" />
                                </button>

                            </div>
                        </td>


                    </tr>
                </tbody>
            </table>
        </div>
        <!-- Modal -->
        <ModalCreate :isOpen="isModalOpen" @close="closeModal" />
    </div>
</template>

<script setup>
import { ref } from 'vue';
import ModalCreate from '../../components/ClubManage/EventManage/ModalCreate.vue';
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
    Pencil
} from 'lucide-vue-next'
import Image1 from '../../assets/1.webp';
import Image2 from '../../assets/2.webp';
import Image3 from '../../assets/3.webp';
import Image4 from '../../assets/4.webp';
import Image5 from '../../assets/5.webp';


const events = [
    {
        id: 1,
        image: Image1,
        title: 'Lorem eget venenatis vestibulum odio egestas bibendum urna...',
        location: 'TP. HCM',
        time: '10:00',
        date: '10/04/2024',
        proposal: false,
        status: 'Đang diễn ra'
    },
    {
        id: 2,
        image: Image2,
        title: 'Elementum dignissim tristique pellentesque eleifend posuere.',
        location: 'TP. HCM',
        time: '10:00',
        date: '10/04/2024',
        proposal: true,
        status: 'Sắp diễn ra'
    },
    {
        id: 3,
        image: Image3,
        title: 'Porta aliquet sed viverra fringilla.',
        location: 'TP. HCM',
        time: '10:00',
        date: '10/04/2024',
        proposal: false,
        status: 'Bản nháp'
    },
    {
        id: 4,
        image: Image4,
        title: 'Non vitae tristique in sed aenean consectetur.',
        location: 'TP. HCM',
        time: '10:00',
        date: '10/04/2024',
        proposal: false,
        status: 'Đã kết thúc'
    },
    {
        id: 5,
        image: Image5,
        title: 'Massa leo scelerisque bibendum eu commodo at vestibulum.',
        location: 'TP. HCM',
        time: '10:00',
        date: '10/04/2024',
        proposal: false,
        status: 'Đã kết thúc'
    }
]

const getStatusClass = (status) => {
    const classes = {
        'Đang diễn ra': 'px-3 py-1 rounded-full bg-green-100 text-green-800 text-sm',
        'Sắp diễn ra': 'px-3 py-1 rounded-full bg-orange-100 text-orange-800 text-sm',
        'Bản nháp': 'px-3 py-1 rounded-full bg-purple-100 text-purple-800 text-sm',
        'Đã kết thúc': 'px-3 py-1 rounded-full bg-gray-100 text-gray-800 text-sm'
    }
    return classes[status] || ''
}

const isModalOpen = ref(false);

function openModal() {
    isModalOpen.value = true;
}

function closeModal() {
    isModalOpen.value = false;
}
</script>