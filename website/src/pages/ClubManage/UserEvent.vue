<template>
    <div class="p-6 bg-gray-50 min-h-screen">
        <!-- Header -->
        <div class="flex justify-between items-center mb-8">
            <div>
                <h1 class="text-xl font-semibold">Quản lý nguời tham gia sự kiện</h1>
                <p class="text-gray-500 mt-1">{{ eventName }}</p>
            </div>
            <button @click="goBack" class="flex items-center gap-2 px-4 py-2 text-gray-700 hover:bg-gray-100 rounded-lg transition-all">
                <ArrowLeftIcon class="w-5 h-5" />
                <span>Quay lại</span>
            </button>
        </div>

        <!-- Loading State -->
        <div v-if="loading" class="flex justify-center items-center py-8">
            <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500"></div>
        </div>

        <!-- Error State -->
        <div v-else-if="error" class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4">
            {{ error }}
        </div>

        <!-- Member List -->
        <div v-else class="bg-white rounded-lg p-6">
            <!-- Search and Filter -->
            <div class="flex gap-4 mb-4">
                <div class="flex-1 relative">
                    <SearchIcon class="w-5 h-5 absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" />
                    <input type="text" placeholder="Tìm kiếm thành viên" 
                           class="w-full pl-10 pr-4 py-2 border rounded-lg">
                </div>
                <button class="px-4 py-2 border rounded-lg flex items-center gap-2">
                    <FilterIcon class="w-4 h-4" />
                    Lọc theo
                </button>
            </div>

            <!-- Empty State -->
            <div v-if="members.length === 0" class="text-center py-8 text-gray-500">
                Chưa có thành viên nào tham gia sự kiện này
            </div>

            <!-- Table -->
            <table v-else class="w-full">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="text-left py-3 px-4">Thành viên</th>
                        <th class="text-left py-3 px-4">Thông tin Liên hệ</th>
                        <th class="text-left py-3 px-4">Trạng thái</th>
                        <th class="text-left py-3 px-4"></th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="member in members" :key="member.id" class="border-b">
                        <td class="py-4 px-4">
                            <div class="flex items-center gap-3">
                                <img :src="member.avatar" alt="" class="w-10 h-10 rounded-full">
                                <div>
                                    <span class="font-medium">{{ member.name }}</span>
                                    <p class="text-sm text-gray-500">{{ member.role }}</p>
                                </div>
                            </div>
                        </td>
                        <td class="py-4 px-4">
                            <div>
                                <p class="text-gray-500">{{ member.phone }}</p>
                                <p class="text-gray-500">{{ member.email }}</p>
                            </div>
                        </td>
                        <td class="py-4 px-4">
                            <span class="px-2 py-1 bg-green-100 text-green-800 rounded-full text-sm">
                                Đã tham gia
                            </span>
                        </td>
                        <td class="py-4 px-4">
                            <div class="flex gap-2">
                                <button class="p-2 hover:bg-gray-100 rounded-lg">
                                    <MessageSquareIcon class="w-4 h-4" />
                                </button>
                                <button class="p-2 hover:bg-gray-100 rounded-lg text-red-500">
                                    <Trash2Icon class="w-4 h-4" />
                                </button>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</template>

<script>
import {
    PlusIcon,
    SearchIcon,
    FilterIcon,
    MessageSquareIcon,
    Trash2Icon,
    ArrowLeftIcon
} from 'lucide-vue-next';

export default {
    components: {
        PlusIcon,
        SearchIcon,
        FilterIcon,
        MessageSquareIcon,
        Trash2Icon,
        ArrowLeftIcon
    },
    data() {
        return {
            eventName: '',
            eventId: null,
            members: [],
            loading: false,
            error: null,
            clubId: null
        }
    },
    methods: {
        async fetchUserEvents() {
            try {
                this.loading = true;
                const response = await getUserEvents(this.eventId);
                if (response && Array.isArray(response)) {
                    this.members = response.map(user => ({
                        id: user.id,
                        name: user.username,
                        phone: user.phone || 'Chưa cập nhật',
                        email: user.email,
                        avatar: user.background_images && user.background_images.length > 0 
                            ? user.background_images[0].image_url 
                            : 'https://ui-avatars.com/api/?name=' + encodeURIComponent(user.username)
                    }));
                    this.eventName = `Danh sách người tham gia - Event #${this.eventId}`;
                } else {
                    throw new Error('Dữ liệu không hợp lệ');
                }
            } catch (error) {
                this.error = error.message;
                console.error('Error fetching user events:', error);
            } finally {
                this.loading = false;
            }
        },
        goBack() {
            this.$router.push(`/club/${this.clubId}/quan-ly-su-kien`);
        }
    },
    async created() {
        this.eventId = this.$route.params.id;
        this.clubId = localStorage.getItem('currentClubId');
        await this.fetchUserEvents();
    }
}
</script>