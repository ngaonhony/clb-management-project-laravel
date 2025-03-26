<template>
    <div class="flex flex-wrap gap-4 items-center justify-center p-4">
        <div v-if="filteredBlogs.length === 0" class="w-full text-center py-12">
            <div class="flex flex-col items-center">
                <InboxIcon class="w-16 h-16 text-gray-400 mb-4" />
                <h3 class="text-lg font-medium text-gray-900 mb-2">Chưa có bài viết nào</h3>
                <p class="text-gray-500">Hãy tạo bài viết mới để chia sẻ thông tin với mọi người</p>
            </div>
        </div>
        <div v-else v-for="blog in filteredBlogs" :key="blog.id" class="w-9/12 bg-white rounded-lg shadow">
            <!-- Header -->
            <div class="p-4 border-b flex items-center relative">
                <div class="flex items-center space-x-3">
                    <img 
                        :src="getClubLogo(blog.club?.background_images)" 
                        alt="Club Logo" 
                        class="w-10 h-10 bg-gray-300 rounded-full object-cover" 
                    />
                    <div>
                        <h2 class="font-semibold text-gray-800">{{ blog.club?.name }}</h2>
                        <p class="text-xs text-gray-500">{{ formatDate(blog.created_at) }}</p>
                    </div>
                </div>
                <DropDownMenu v-if="showActions" :options="dropdownOptions" @select="(option) => handleSelect(option, blog)">
                    <template #trigger>
                        <button class="p-2 ml-auto dropdown-trigger">
                            <MoreVerticalIcon class="w-5 h-5" />
                        </button>
                    </template>
                </DropDownMenu>
            </div>

            <!-- Content -->
            <div class="p-2">
                <p class="text-gray-800 mb-2 font-bold">
                    {{ blog.title }}
                </p>
                <p class="text-gray-600">{{ blog.content }}</p>
                <!-- Image -->
                <div v-if="blog.background_images?.length > 0" class="rounded-lg overflow-hidden mb-4">
                    <img :src="blog.background_images[0].image_url" :alt="blog.title" class="w-full max-h-80 object-contain" />
                </div>
            </div>
        </div>

        <!-- Edit Modal -->
        <ModalEdit 
            v-if="isEditModalOpen" 
            :isOpen="isEditModalOpen" 
            :blog="selectedBlog"
            @close="closeEditModal"
        />

        <!-- Delete Confirmation Modal -->
        <div v-if="isDeleteModalOpen" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
            <div class="bg-white rounded-lg p-6 max-w-md w-full mx-4">
                <h3 class="text-lg font-semibold mb-4">Xác nhận xóa</h3>
                <p class="text-gray-600 mb-6">Bạn có chắc chắn muốn xóa blog này?</p>
                <div class="flex justify-end gap-4">
                    <button 
                        @click="closeDeleteModal" 
                        class="px-4 py-2 text-gray-600 hover:text-gray-800"
                    >
                        Hủy
                    </button>
                    <button 
                        @click="confirmDelete" 
                        class="px-4 py-2 bg-red-500 text-white rounded hover:bg-red-600"
                    >
                        Xóa
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { MoreVerticalIcon, PenSquare, Trash2, InboxIcon } from 'lucide-vue-next';
import DropDownMenu from '../../DropDownMenu.vue';
import ModalEdit from './ModalEdit.vue';
import { storeToRefs } from 'pinia';
import { useBlogStore } from '../../../stores/blogStore';

export default {
    components: {
        DropDownMenu,
        MoreVerticalIcon,
        ModalEdit,
        InboxIcon
    },
    props: {
        showActions: {
            type: Boolean,
            default: false
        }
    },
    setup() {
        const blogStore = useBlogStore();
        const { filteredBlogs } = storeToRefs(blogStore);
        return { filteredBlogs, blogStore };
    },
    data() {
        return {
            dropdownOptions: [
                { label: "Chỉnh sửa Blog", icon: PenSquare },
                { label: "Xóa Blog", icon: Trash2, danger: true },
            ],
            isEditModalOpen: false,
            isDeleteModalOpen: false,
            selectedBlog: null
        };
    },
    methods: {
        formatDate(dateString) {
            if (!dateString) return '';
            const date = new Date(dateString);
            return date.toLocaleDateString('vi-VN', {
                year: 'numeric',
                month: 'long',
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            });
        },
        getClubLogo(images) {
            if (!images) return 'https://via.placeholder.com/40';
            const logo = images.find(img => img.is_logo === 1);
            return logo ? logo.image_url : 'https://via.placeholder.com/40';
        },
        handleSelect(option, blog) {
            this.selectedBlog = blog;
            if (option.label === "Chỉnh sửa Blog") {
                this.openEditModal();
            } else if (option.label === "Xóa Blog") {
                this.openDeleteModal();
            }
        },
        openEditModal() {
            this.isEditModalOpen = true;
        },
        closeEditModal() {
            this.isEditModalOpen = false;
            this.selectedBlog = null;
        },
        openDeleteModal() {
            this.isDeleteModalOpen = true;
        },
        closeDeleteModal() {
            this.isDeleteModalOpen = false;
            this.selectedBlog = null;
        },
        async confirmDelete() {
            if (!this.selectedBlog) return;
            try {
                await this.blogStore.deleteBlog(this.selectedBlog.id);
                this.closeDeleteModal();
            } catch (error) {
                console.error('Error deleting blog:', error);
                // Handle error (show notification, etc.)
            }
        }
    }
}
</script>
