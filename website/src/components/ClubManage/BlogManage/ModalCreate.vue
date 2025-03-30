<template>
    <!-- Main modal -->
    <div v-show="isOpen" tabindex="-1" aria-hidden="true"
        class="fixed top-0 left-0 right-0 z-50 flex items-center justify-center w-full h-full bg-black/50">
        <div class="relative w-full max-w-lg max-h-[90vh] bg-white rounded-lg shadow-lg dark:bg-gray-80">
            <!-- Modal header -->
            <div class="flex items-center justify-between p-4 border-b rounded-t dark:border-gray-700">
                <h3 class="text-lg font-semibold text-gray-900 dark:text-black">
                    Tạo Blog
                </h3>
                <button type="button" @click="closeModal"
                    class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 flex justify-center items-center dark:hover:bg-gray-700 dark:hover:text-white">
                    <svg class="w-3 h-3" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 14">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M1 1l6 6m0 0l6 6m-6-6l6-6m-6 6L1 1" />
                    </svg>
                    <span class="sr-only">Close modal</span>
                </button>
            </div>

            <!-- Modal body -->
            <div class="flex flex-col max-h-[500px] overflow-hidden">
                <form @submit.prevent="handleSubmit" class="p-4 flex-grow overflow-auto">
                    <!-- Title Input -->
                    <div class="mb-4">
                        <label for="title" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">Tiêu đề</label>
                        <input type="text" id="title" v-model="formData.title" required
                            class="w-full px-3 py-2 border rounded-lg text-sm focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-50 dark:border-gray-600 dark:text-black">
                    </div>

                    <!-- Category Select -->
                    <div class="mb-4">
                        <label for="category" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">Danh mục</label>
                        <select id="category" v-model="formData.category_id" required
                            class="w-full px-3 py-2 border rounded-lg text-sm focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-50 dark:border-gray-600 dark:text-black">
                            <option value="">Chọn danh mục</option>
                            <option v-for="category in categories" :key="category.id" :value="category.id">
                                {{ category.name }}
                            </option>
                        </select>
                    </div>

                    <!-- Description Input -->
                    <div class="mb-4">
                        <label for="description" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">Mô tả ngắn</label>
                        <textarea id="description" v-model="formData.description" rows="2"
                            class="w-full px-3 py-2 border rounded-lg text-sm focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-50 dark:border-gray-600 dark:text-black"></textarea>
                    </div>

                    <!-- Content Input -->
                    <div class="mb-4">
                        <label for="content" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">Nội dung</label>
                        <textarea id="content" v-model="formData.content" required rows="4"
                            class="w-full px-3 py-2 border rounded-lg text-sm focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-50 dark:border-gray-600 dark:text-black"></textarea>
                    </div>

                    <!-- Image Upload -->
                    <div class="mb-4">
                        <label class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">Ảnh bìa</label>
                        <div class="flex items-center justify-center relative w-full h-[200px] border-2 border-dashed border-gray-300 rounded-lg hover:bg-gray-50 transition-colors">
                            <input type="file" id="image" @change="handleImageUpload" accept="image/*" class="hidden" />
                            
                            <div v-if="imagePreview" class="flex items-center justify-center p-1 w-full h-full">
                                <img :src="imagePreview" class="max-w-full max-h-full object-contain rounded-lg" alt="Preview" />
                                <button @click="removeImage" type="button"
                                    class="absolute top-1 right-1 bg-white rounded-full p-1 shadow-md hover:bg-gray-100">
                                    <XIcon class="w-4 h-4 text-gray-600" />
                                </button>
                            </div>

                            <label v-else for="image" class="flex flex-col items-center justify-center w-full h-full cursor-pointer">
                                <UploadIcon class="w-6 h-6 text-gray-400 mb-2" />
                                <span class="text-sm text-gray-500">Thêm ảnh</span>
                            </label>
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" :disabled="isSubmitting"
                        class="w-full px-4 py-2 text-sm font-medium text-center text-white bg-blue-600 rounded-lg hover:bg-blue-700 focus:outline-none focus:ring-4 focus:ring-blue-300 disabled:opacity-50 disabled:cursor-not-allowed">
                        {{ isSubmitting ? 'Đang tạo...' : 'Tạo Blog' }}
                    </button>
                </form>
            </div>
        </div>
    </div>
</template>

<script>
import { ref, onMounted, computed } from 'vue';
import { UploadIcon, XIcon } from 'lucide-vue-next';
import { useBlogStore } from '../../../stores/blogStore';
import { useCategoryStore } from '../../../stores/categoryStore';
import { useRoute } from 'vue-router';

export default {
    props: {
        isOpen: {
            type: Boolean,
            default: false
        }
    },
    emits: ['close'],
    setup(props, { emit }) {
        const route = useRoute();
        const blogStore = useBlogStore();
        const categoryStore = useCategoryStore();
        const isSubmitting = ref(false);
        const imageFile = ref(null);
        const imagePreview = ref(null);

        const formData = ref({
            title: '',
            club_id: parseInt(route.params.id),
            description: '',
            category_id: '',
            content: '',
            view_count: 0
        });

        // Add computed property for blog categories
        const categories = computed(() => categoryStore.blogCategories);

        const handleImageUpload = (event) => {
            const file = event.target.files[0];
            if (file) {
                imageFile.value = file;
                imagePreview.value = URL.createObjectURL(file);
            }
        };

        const removeImage = () => {
            imageFile.value = null;
            imagePreview.value = null;
        };

        const handleSubmit = async () => {
            isSubmitting.value = true;
            try {
                const formDataToSend = new FormData();
                Object.keys(formData.value).forEach(key => {
                    formDataToSend.append(key, formData.value[key]);
                });
                
                if (imageFile.value) {
                    formDataToSend.append('image', imageFile.value);
                }

                await blogStore.createBlog(formDataToSend);
                emit('close');
            } catch (error) {
                console.error('Error creating blog:', error);
            } finally {
                isSubmitting.value = false;
            }
        };

        onMounted(async () => {
            await categoryStore.fetchCategories();
        });

        return {
            formData,
            imageFile,
            imagePreview,
            categories,
            isSubmitting,
            handleImageUpload,
            removeImage,
            handleSubmit,
            closeModal: () => emit('close')
        };
    }
};
</script>

<style scoped>
.grid {
    display: grid;
    grid-template-columns: repeat(1, 1fr);
    gap: 1rem;
}

img {
    border: 1px solid #ddd;
    width: 100%;
    height: 100%;
    object-fit: cover;
}
</style>
