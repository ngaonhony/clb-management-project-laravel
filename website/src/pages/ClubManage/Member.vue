<template>
    <div class="p-6 bg-gray-50 min-h-screen">
        <!-- Header -->
        <div class="flex justify-between items-center mb-8">
            <h1 class="text-xl font-semibold">Quản lý Thành viên</h1>
            <div class="flex gap-3">
                <button @click="goToWaitingList"
                    class="flex items-center px-4 py-2 bg-white border rounded-lg gap-2 hover:bg-gray-50 transition-colors">
                    <span>Danh sách chờ</span>
                    <span v-if="pendingCount > 0" class="bg-blue-100 text-blue-800 text-xs px-2 py-0.5 rounded-full">
                        {{ pendingCount.toString().padStart(2, '0') }}
                    </span>
                </button>
                <button @click="showCreateDepartmentModal = true"
                    class="px-4 py-2 bg-white border rounded-lg hover:bg-gray-50 transition-colors">
                    Tạo phòng ban
                </button>
                <button
                    @click="showInviteModal = true"
                    class="px-4 py-2 bg-black text-white rounded-lg flex items-center gap-2 hover:bg-gray-900 transition-colors">
                    <PlusIcon class="w-4 h-4" />
                    Mời tham gia
                </button>
            </div>
        </div>

        <!-- Department Cards -->
        <div class="bg-white rounded-lg p-6 mb-6">
            <h2 class="text-lg font-medium mb-4">Quản lý Phòng ban</h2>
            <div class="grid grid-cols-2 gap-4">
                <div v-for="dept in departments" :key="dept.id" class="p-4 border rounded-lg flex items-center gap-4">
                    <div class="w-10 h-10 rounded-lg bg-blue-50 flex items-center justify-center">
                        <component :is="dept.icon || UserIcon" class="w-5 h-5 text-blue-500" />
                    </div>
                    <div class="flex-1">
                        <h3 class="font-medium">{{ dept.name }}</h3>
                        <p class="text-sm text-gray-500">Trưởng phòng: {{ dept.user?.username || 'Chưa có trưởng phòng' }}</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Member List -->
        <div class="bg-white rounded-lg p-6">
            <div class="flex gap-4 border-b mb-4">
                <button class="px-4 py-2 text-blue-500 border-b-2 border-blue-500">
                    Tất cả
                </button>
            </div>

            <div class="flex gap-4 mb-4">
                <div class="flex-1 relative">
                    <SearchIcon class="w-5 h-5 absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" />
                    <input type="text" v-model="searchTerm" @input="handleSearch" placeholder="Tìm kiếm" class="w-full pl-12 pr-10 py-2 border rounded-lg">
                    <ChevronDownIcon @click="toggleUserList" class="w-5 h-5 absolute right-3 top-1/2 transform -translate-y-1/2 cursor-pointer" :class="{ 'transform rotate-180': showUserList }" />
                    
                    <div v-if="showUserList && filteredMembers.length" class="absolute z-10 w-full top-full left-0 mt-1 bg-white border rounded-md shadow-lg max-h-48 overflow-auto">
                        <div v-for="member in filteredMembers" :key="member.id" @click="selectUserFromSearch(member)" class="p-2 hover:bg-gray-100 cursor-pointer flex items-center gap-2">
                            <img :src="member.avatar" alt="" class="w-8 h-8 rounded-full">
                            <div>
                                <div class="font-medium">{{ member.name }}</div>
                                <div class="text-sm text-gray-500">
                                    <div>{{ member.email }}</div>
                                    <div>{{ member.phone }}</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <button class="px-4 py-2 border rounded-lg flex items-center gap-2">
                    <FilterIcon class="w-4 h-4" />
                    Lọc theo
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

            <!-- Empty State -->
            <div v-else-if="members.length === 0" class="text-center py-8 text-gray-500">
                Chưa có thành viên nào
            </div>

            <!-- Table -->
            <table v-else class="w-full">
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
                            <div v-if="member.role !== 'Chủ Câu Lạc Bộ'" class="flex gap-2">
                                <button 
                                    @click="deleteJoinRequest(member.id)"
                                    class="p-2 hover:bg-gray-100 rounded-lg text-red-500 hover:text-red-600">
                                    <TrashIcon class="w-4 h-4" />
                                </button>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- Modal Tạo Phòng Ban -->
        <div v-if="showCreateDepartmentModal"
            class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center">
            <div class="bg-white rounded-lg p-6 w-1/2 max-h-[80vh] overflow-y-auto">
                <h2 class="text-xl font-semibold mb-2">Tạo phòng ban</h2>
                <p class="text-gray-600 mb-6">Quản lý danh sách thông tin thành viên theo từng phòng ban</p>

                <form @submit.prevent="createDepartment">
                    <div class="mb-6">
                        <label class="block text-sm font-medium text-gray-700 mb-1">
                            Tên phòng ban, bộ phận <span class="text-red-500">*</span>
                        </label>
                        <input v-model="newDepartment.name" type="text" required
                            class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                    </div>

                    <div class="mb-6">
                        <label class="block text-sm font-medium text-gray-700 mb-1">
                            Trưởng phòng ban <span class="text-red-500">*</span>
                        </label>
                        <div class="relative">
                            <input v-model="searchLeader" type="text" placeholder="Tìm kiếm thành viên..." 
                                class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
                                @input="filterMembers"
                                @focus="filterMembers()">
                            <ChevronDownIcon @click="toggleMemberList" class="w-5 h-5 absolute right-3 top-1/2 transform -translate-y-1/2 cursor-pointer" :class="{ 'transform rotate-180': showMemberList }" />
                            <div v-if="showMemberList && filteredMembers.length"
                                class="absolute z-10 w-full mt-1 bg-white border rounded-md shadow-lg max-h-48 overflow-auto">
                                <div v-for="member in filteredMembers" :key="member.id" @click="selectMember(member)"
                                    class="p-2 hover:bg-gray-100 cursor-pointer flex items-center gap-2">
                                    <div>
                                        <div class="font-medium">{{ member.name }}</div>
                                        <div class="text-sm text-gray-500">{{ member.email }}</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="mb-6">
                        <label class="block text-sm font-medium text-gray-700 mb-1">
                            Chức năng, nhiệm vụ <span class="text-red-500">*</span>
                        </label>
                        <textarea v-model="newDepartment.description" rows="4" required
                            class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"></textarea>
                    </div>

                    <!-- Permissions Component -->
                    <div class="permissions-container mb-6">
                        <h1 class="text-xl font-medium text-gray-700 mb-6">Phân quyền phòng ban</h1>

                        <div class="mb-4">
                            <h2 class="text-base font-medium text-gray-600">Cấu hình quyền quản trị thông tin</h2>
                        </div>

                        <!-- Thông tin câu lạc bộ -->
                        <div class="border rounded-lg p-4 mb-4">
                            <div class="flex items-center justify-between">
                                <div>
                                    <div class="text-base text-gray-700">Thông tin câu lạc bộ</div>
                                    <div class="text-sm text-gray-500">Thêm, xóa & sửa các thông tin cơ bản của Câu Lạc
                                        Bộ</div>
                                </div>
                                <label class="switch">
                                    <input type="checkbox" v-model="newDepartment.manage_clubs">
                                    <span class="slider round"></span>
                                </label>
                            </div>
                        </div>

                        <!-- Quản lý Trang -->
                        <div class="border rounded-lg p-4 mb-4">
                            <div class="flex items-center justify-between">
                                <div>
                                    <div class="text-base text-gray-700">Quản lý Trang</div>
                                    <div class="text-sm text-gray-500">Chỉnh sửa, cập nhật các thông tin có tại Trang
                                        đại diện của Câu Lạc Bộ</div>
                                </div>
                                <label class="switch">
                                    <input type="checkbox" v-model="newDepartment.manage_blogs">
                                    <span class="slider round"></span>
                                </label>
                            </div>
                        </div>

                        <!-- Quản lý sự kiện -->
                        <div class="border rounded-lg p-4 mb-4">
                            <div class="flex items-center justify-between">
                                <div>
                                    <div class="text-base text-gray-700">Quản lý sự kiện</div>
                                    <div class="text-sm text-gray-500">Cập nhật và tạo mới các sự kiện cho câu lạc bộ
                                    </div>
                                </div>
                                <label class="switch">
                                    <input type="checkbox" v-model="newDepartment.manage_events">
                                    <span class="slider round"></span>
                                </label>
                            </div>
                        </div>

                        <!-- Quản lý thành viên -->
                        <div class="border rounded-lg p-4 mb-4">
                            <div class="flex items-center justify-between">
                                <div>
                                    <div class="text-base text-gray-700">Quản lý thành viên</div>
                                    <div class="text-sm text-gray-500">Cập nhật thông tin thành viên</div>
                                </div>
                                <label class="switch">
                                    <input type="checkbox" v-model="newDepartment.manage_members">
                                    <span class="slider round"></span>
                                </label>
                            </div>
                        </div>

                        <!-- Quản lý phản hồi -->
                        <div class="border rounded-lg p-4 mb-4">
                            <div class="flex items-center justify-between">
                                <div>
                                    <div class="text-base text-gray-700">Quản lý phản hồi</div>
                                    <div class="text-sm text-gray-500">Xem và phản hồi các ý kiến, đánh giá từ thành viên</div>
                                </div>
                                <label class="switch">
                                    <input type="checkbox" v-model="newDepartment.manage_feedback">
                                    <span class="slider round"></span>
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="flex justify-end gap-3">
                        <button type="button" @click="showCreateDepartmentModal = false"
                            class="px-4 py-2 bg-gray-100 rounded-lg hover:bg-gray-200 transition-colors">
                            Hủy
                        </button>
                        <button type="submit"
                            :disabled="isCreating"
                            class="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors disabled:opacity-50 disabled:cursor-not-allowed">
                            <span v-if="isCreating" class="flex items-center gap-2">
                                <div class="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
                                Đang tạo...
                            </span>
                            <span v-else>Tạo phòng ban</span>
                        </button>
                    </div>
                </form>
            </div>
        </div>
        <!-- Modal Mời Thành Viên -->
        <div v-if="showInviteModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-[1000]">
            <div class="bg-white rounded-lg w-full max-w-[550px] shadow-lg overflow-hidden">
                <div class="flex justify-between items-center p-4 border-b">
                    <h2 class="text-xl font-semibold text-gray-800">Mời thành viên</h2>
                    <button @click="showInviteModal = false" class="text-gray-600 hover:text-gray-800">
                        <XIcon class="w-5 h-5" />
                    </button>
                </div>
                
                <div class="p-5">
                    <p class="text-gray-600 text-sm mb-5">
                        Gửi lời mời đến người dùng đã đăng ký tài khoản trở thành thành viên của <strong>{{ clubStore.selectedClub?.name }}</strong>
                    </p>
                    
                    <div class="relative mb-8">
                        <input 
                            v-model="inviteEmail"
                            type="email" 
                            placeholder="Nhập email người dùng" 
                            class="w-full px-3 py-3 border rounded-md pr-10"
                            :disabled="isInviting"
                        />
                        <div v-if="inviteError" class="text-red-500 text-sm mt-2">
                            {{ inviteError }}
                        </div>
                    </div>
                </div>
                
                <div class="flex justify-end gap-3 p-4 border-t">
                    <button 
                        @click="showInviteModal = false"
                        class="px-5 py-2.5 border rounded-md hover:bg-gray-50 font-medium">
                        Huỷ bỏ
                    </button>
                    <button 
                        @click="sendInvitation"
                        :disabled="isInviting || !inviteEmail"
                        class="px-5 py-2.5 bg-gray-900 text-white rounded-md hover:bg-gray-800 font-medium disabled:opacity-50 disabled:cursor-not-allowed">
                        <span v-if="isInviting" class="flex items-center gap-2">
                            <div class="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
                            Đang gửi...
                        </span>
                        <span v-else>Gửi lời mời</span>
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import {
    PlusIcon,
    SearchIcon,
    FilterIcon,
    TrashIcon,
    XIcon,
    ChevronDownIcon,
    UserIcon
} from 'lucide-vue-next'
import { useToast } from 'vue-toastification'
import departmentService from '../../services/department'
import { useJoinRequestStore } from '../../stores/joinRequestStore'
import { useClubStore } from '../../stores/clubStore'
import { useDepartmentStore } from '../../stores/departmentStore'

const toast = useToast()
const router = useRouter()
const route = useRoute()
const clubStore = useClubStore()

// Get club ID from route params
const clubId = computed(() => route.params.id)
const goToWaitingList = () => {
    router.push(`/club/${clubId.value}/danh-sach-cho`)
}
// Modal state
const showCreateDepartmentModal = ref(false)
const isCreating = ref(false)
const newDepartment = ref({
    name: '',
    user_id: '',
    description: '',
    manage_clubs: false,
    manage_blogs: false,
    manage_events: false,
    manage_members: false,
    manage_feedback: false
})

const joinRequestStore = useJoinRequestStore()


// Member.vue
const members = ref([])
const loading = ref(false)
const error = ref(null)
const isLoading = ref(false)

const deleteJoinRequest = async (id) => {
    if (!confirm('Bạn có chắc chắn muốn xóa thành viên này?')) {
        return
    }
    isLoading.value = true
    error.value = null

    try {
        await joinRequestStore.deleteJoinRequest(id)
        toast.success('Xóa thành viên thành công')
    } catch (err) {
        error.value = err.message
        toast.error('Có lỗi xảy ra khi xóa thành viên')
    } finally {
        isLoading.value = false
    }
}

const departmentStore = useDepartmentStore()
const departments = ref([])

const fetchMembers = async () => {
    try {
        loading.value = true
        error.value = null
        
        await joinRequestStore.fetchClubRequests(clubId.value)
        await clubStore.fetchClubById(clubId.value)
        
        const clubOwner = clubStore.selectedClub
        const approvedMembers = joinRequestStore.joinRequests.filter(request => request.status === 'approved')
        
        // Log dữ liệu join request
        console.log('Dữ liệu Join Request:', {
            tổng_số_yêu_cầu: joinRequestStore.joinRequests.length,
            thành_viên_đã_duyệt: approvedMembers.length,
            danh_sách_thành_viên: approvedMembers.map(request => ({
                id: request.id,
                user_id: request.user.id,
                tên: request.user.username,
                email: request.user.email,
                số_điện_thoại: request.user.phone,
                vai_trò: request.role,
                phòng_ban: request.name || 'Thành Viên'
            }))
        })
        
        // Tạo mảng members với chủ câu lạc bộ ở đầu
        members.value = [
            {
                id: clubOwner.user.id,
                name: clubOwner.user.username,
                email: clubOwner.user.email,
                phone: clubOwner.user.phone,
                role: 'Chủ Câu Lạc Bộ',
                department: clubOwner.department || 'Ban Điều Hành',
                avatar: clubOwner.user.avatar || 'https://via.placeholder.com/40'
            }
        ]
        
        // Thêm các thành viên đã được phê duyệt
        if (Array.isArray(approvedMembers)) {
            members.value.push(...approvedMembers.map(request => ({
                id: request.id,
                user_id: request.user.id,
                name: request.user.username,
                email: request.user.email,
                phone: request.user.phone,
                role: request.role,
                department: request.name || 'Thành Viên',
                avatar: request.user.avatar || 'https://via.placeholder.com/40'
            })))
        }
    } catch (error) {
        console.error('Error fetching members:', error)
        error.value = 'Có lỗi xảy ra khi tải danh sách thành viên'
    } finally {
        loading.value = false
    }
}

// Initialize data
onMounted(async () => {
    await fetchMembers()
    try {
        const response = await departmentStore.fetchClubDepartments(clubId.value)
        departments.value = response
        console.log('Departments data:', departments.value)
    } catch (error) {
        console.error('Error fetching departments:', error)
    }
})

// Pending members count (you might want to get this from an API)
const pendingCount = ref(1)
const showInviteModal = ref(false)
const inviteEmail = ref('')
const isInviting = ref(false)
const inviteError = ref('')

const sendInvitation = async () => {
    if (!inviteEmail.value) {
        inviteError.value = 'Vui lòng nhập email người dùng'
        return
    }
    if (!inviteEmail.value.match(/^[^\s@]+@[^\s@]+\.[^\s@]+$/)) {
        inviteError.value = 'Email không hợp lệ'
        return
    }
    isInviting.value = true
    inviteError.value = ''
    
    try {
        await joinRequestStore.inviteUser({
            email: inviteEmail.value,
            club_id: clubId.value
        })
        
        toast.success('Đã gửi lời mời thành công!')
        showInviteModal.value = false
        inviteEmail.value = ''
    } catch (error) {
        inviteError.value = error.message || 'Có lỗi xảy ra khi gửi lời mời'
        toast.error(inviteError.value)
    } finally {
        isInviting.value = false
    }
}

// Function to create new department
const createDepartment = async () => {
    try {
        isCreating.value = true;
        error.value = null;

        // Kiểm tra dữ liệu bắt buộc
        if (!newDepartment.value.name || !newDepartment.value.user_id || !newDepartment.value.description) {
            throw new Error('Vui lòng điền đầy đủ thông tin bắt buộc');
        }

        // Thêm club_id vào dữ liệu
        const departmentData = {
            ...newDepartment.value,
            club_id: clubId.value
        };

        console.log('Dữ liệu gửi đi:', departmentData);

        const response = await departmentService.createDepartment(departmentData);
        toast.success('Tạo phòng ban thành công');
        showCreateDepartmentModal.value = false;

        // Reset form
        newDepartment.value = {
            name: '',
            user_id: '',
            description: '',
            manage_clubs: false,
            manage_blogs: false,
            manage_events: false,
            manage_members: false
        };
    } catch (err) {
        console.error('Lỗi tạo phòng ban:', err);
        error.value = err.response?.data?.message || err.message;
        toast.error(error.value);
    } finally {
        isCreating.value = false;
    }
};
const searchLeader = ref('')
const filteredMembers = ref([])

// Function to filter members based on search input
const filterMembers = () => {
    if (!searchLeader.value) {
        filteredMembers.value = members.value.filter(member => member.role !== 'Chủ Câu Lạc Bộ')
        return
    }
    const searchTerm = searchLeader.value.toLowerCase()
    filteredMembers.value = members.value.filter(member =>
        member.role !== 'Chủ Câu Lạc Bộ' &&
        (member.name.toLowerCase().includes(searchTerm) ||
        member.email.toLowerCase().includes(searchTerm) ||
        member.phone.toLowerCase().includes(searchTerm))
    )
}

// Function to handle member selection
const selectMember = (member) => {
    newDepartment.value.user_id = member.user_id
    searchLeader.value = member.name
    filteredMembers.value = []
}

const searchTerm = ref('')
const showUserList = ref(false)

const handleSearch = () => {
    if (!searchTerm.value) {
        showUserList.value = false
        filteredMembers.value = []
        return
    }
    showUserList.value = true
    const searchValue = searchTerm.value.toLowerCase()
    filteredMembers.value = members.value.filter(member =>
        member.name.toLowerCase().includes(searchValue) ||
        member.email.toLowerCase().includes(searchValue) ||
        member.phone.toLowerCase().includes(searchValue)
    )
}

const toggleUserList = () => {
    showUserList.value = !showUserList.value
    if (showUserList.value) {
        filteredMembers.value = members.value
    } else {
        filteredMembers.value = []
    }
}

const selectUserFromSearch = (member) => {
    searchTerm.value = member.name
    showUserList.value = false
    // Điền thông tin thành viên vào form
    if (newDepartment) {
        newDepartment.value.user_id = member.user_id
        newDepartment.value.name = member.name
    }
}

// Add these to your script section
const showMemberList = ref(false)

const toggleMemberList = () => {
    showMemberList.value = !showMemberList.value
    if (showMemberList.value) {
        filterMembers()
    } else {
        filteredMembers.value = []
    }
}
</script>
<style scoped>
.grid {
    display: grid;
}

/* Add hover and transition effects */
.transition-colors {
    transition: all 0.3s ease;
}

.hover\:bg-gray-50:hover {
    background-color: rgb(249, 250, 251);
}

.hover\:bg-gray-900:hover {
    background-color: rgb(17, 24, 39);
}

/* Toggle Switch Styling */
.switch {
    position: relative;
    display: inline-block;
    width: 48px;
    height: 24px;
}

.switch input {
    opacity: 0;
    width: 0;
    height: 0;
}

.slider {
    position: absolute;
    cursor: pointer;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: #ccc;
    transition: .4s;
}

.slider:before {
    position: absolute;
    content: "";
    height: 18px;
    width: 18px;
    left: 3px;
    bottom: 3px;
    background-color: white;
    transition: .4s;
}

input:checked+.slider {
    background-color: #10b981;
}

input:focus+.slider {
    box-shadow: 0 0 1px #10b981;
}

input:checked+.slider:before {
    transform: translateX(24px);
}

/* Rounded sliders */
.slider.round {
    border-radius: 34px;
}

.slider.round:before {
    border-radius: 50%;
}
</style>

