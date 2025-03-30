<template>
    <!-- Main modal -->
    <div v-show="isOpen" tabindex="-1" aria-hidden="true"
        class="fixed top-0 left-0 right-0 z-50 flex items-center justify-center w-full h-full bg-black/50">
        <div class="relative w-full max-w-lg max-h-[90vh] bg-white rounded-lg shadow-lg dark:bg-gray-80">
            <!-- Modal header -->
            <div class="flex items-center justify-between p-4 border-b rounded-t dark:border-gray-700">
                <h3 class="text-lg font-semibold text-gray-900 dark:text-black">
                    Tạo Sự Kiện
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

            <!-- Modal body with fixed height and scrollable content -->
            <div class="flex flex-col max-h-[80vh] overflow-hidden">
                <!-- Form Section -->
                <form class="p-6 flex-grow overflow-auto" @submit.prevent="handleSubmit">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <!-- Left Column -->
                        <div class="space-y-6">
                            <!-- Event Name -->
                            <div>
                                <label for="name" class="block mb-2 text-sm font-medium text-gray-900">
                                    Tên Sự Kiện <span class="text-red-500">*</span>
                                </label>
                                <input type="text" id="name" 
                                    class="w-full px-4 py-2.5 border rounded-lg text-sm focus:ring-blue-500 focus:border-blue-500 bg-white"
                                    :class="{'border-red-500': errors.name}"
                                    v-model="formData.name"
                                    placeholder="Nhập tên sự kiện...">
                                <p v-if="errors.name" class="mt-1 text-sm text-red-500">{{ errors.name }}</p>
                            </div>

                            <!-- Location -->
                            <div>
                                <label for="location" class="block mb-2 text-sm font-medium text-gray-900">
                                    Địa Điểm <span class="text-red-500">*</span>
                                </label>
                                <input type="text" id="location"
                                    class="w-full px-4 py-2.5 border rounded-lg text-sm focus:ring-blue-500 focus:border-blue-500 bg-white"
                                    :class="{'border-red-500': errors.location}"
                                    v-model="formData.location"
                                    placeholder="Nhập địa điểm...">
                                <p v-if="errors.location" class="mt-1 text-sm text-red-500">{{ errors.location }}</p>
                            </div>

                            <!-- Category -->
                            <div>
                                <label for="category" class="block mb-2 text-sm font-medium text-gray-900">
                                    Thể Loại <span class="text-red-500">*</span>
                                </label>
                                <select id="category"
                                    class="w-full px-4 py-2.5 border rounded-lg text-sm focus:ring-blue-500 focus:border-blue-500 bg-white"
                                    :class="{'border-red-500': errors.category}"
                                    v-model="formData.category_id">
                                    <option value="">Chọn thể loại</option>
                                    <option v-for="category in categories" :key="category.id" :value="category.id">
                                        {{ category.name }}
                                    </option>
                                </select>
                                <p v-if="errors.category" class="mt-1 text-sm text-red-500">{{ errors.category }}</p>
                            </div>

                            <!-- Description -->
                            <div>
                                <label for="description" class="block mb-2 text-sm font-medium text-gray-900">
                                    Mô tả
                                </label>
                                <textarea id="description" rows="4"
                                    class="w-full px-4 py-2.5 border rounded-lg text-sm focus:ring-blue-500 focus:border-blue-500 bg-white resize-none"
                                    v-model="formData.content"
                                    placeholder="Nhập mô tả sự kiện..."></textarea>
                            </div>
                        </div>

                        <!-- Right Column -->
                        <div class="space-y-6">
                            <!-- Image Upload -->
                            <div>
                                <label class="block mb-2 text-sm font-medium text-gray-900">
                                    Hình ảnh <span class="text-red-500">*</span>
                                </label>
                                <div class="relative">
                                    <div class="flex items-center justify-center w-full h-[200px] border-2 border-dashed border-gray-300 rounded-lg hover:bg-gray-50 transition-colors">
                                        <input type="file" id="file-upload" @change="handleImageUpload($event, 0)"
                                            accept="image/*" class="hidden" />

                                        <!-- Preview Image -->
                                        <div v-if="images[0].preview" class="relative w-full h-full">
                                            <img :src="images[0].preview"
                                                class="w-full h-full object-contain rounded-lg" alt="Preview" />
                                            <button @click.prevent="removeImage(0)"
                                                class="absolute top-2 right-2 bg-white rounded-full p-1 shadow-md hover:bg-gray-100">
                                                <XIcon class="w-5 h-5 text-gray-600" />
                                            </button>
                                        </div>

                                        <!-- Upload Placeholder -->
                                        <label v-else for="file-upload"
                                            class="flex flex-col items-center justify-center w-full h-full cursor-pointer">
                                            <UploadIcon class="w-8 h-8 text-gray-400 mb-2" />
                                            <span class="text-sm text-gray-500">Click để tải ảnh lên</span>
                                            <span class="text-xs text-gray-400 mt-1">PNG, JPG hoặc GIF</span>
                                        </label>
                                    </div>
                                </div>
                                <p v-if="errors.image" class="mt-1 text-sm text-red-500">{{ errors.image }}</p>
                            </div>

                            <!-- Date and Time -->
                            <div class="space-y-4">
                                <div>
                                    <label for="start_date" class="block mb-2 text-sm font-medium text-gray-900">
                                        Thời Gian Bắt Đầu <span class="text-red-500">*</span>
                                    </label>
                                    <input type="datetime-local" id="start_date"
                                        class="w-full px-4 py-2.5 border rounded-lg text-sm focus:ring-blue-500 focus:border-blue-500 bg-white"
                                        :class="{'border-red-500': errors.start_date}"
                                        v-model="formData.start_date">
                                    <p v-if="errors.start_date" class="mt-1 text-sm text-red-500">{{ errors.start_date }}</p>
                                </div>

                                <div>
                                    <label for="end_date" class="block mb-2 text-sm font-medium text-gray-900">
                                        Thời Gian Kết Thúc <span class="text-red-500">*</span>
                                    </label>
                                    <input type="datetime-local" id="end_date"
                                        class="w-full px-4 py-2.5 border rounded-lg text-sm focus:ring-blue-500 focus:border-blue-500 bg-white"
                                        :class="{'border-red-500': errors.end_date}"
                                        v-model="formData.end_date">
                                    <p v-if="errors.end_date" class="mt-1 text-sm text-red-500">{{ errors.end_date }}</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Error message -->
                    <div v-if="error" class="mt-6 p-4 bg-red-100 border border-red-400 text-red-700 rounded-lg">
                        {{ error }}
                    </div>

                    <!-- Submit Button -->
                    <div class="mt-6 flex justify-end space-x-3">
                        <button type="button" @click="closeModal"
                            class="px-6 py-2.5 text-sm font-medium text-gray-700 bg-gray-100 rounded-lg hover:bg-gray-200 focus:outline-none focus:ring-2 focus:ring-gray-300">
                            Hủy
                        </button>
                        <button type="submit" :disabled="isLoading"
                            class="px-6 py-2.5 text-sm font-medium text-white bg-blue-600 rounded-lg hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-300 disabled:opacity-50 disabled:cursor-not-allowed">
                            <span v-if="isLoading" class="flex items-center">
                                <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                                </svg>
                                Đang tạo...
                            </span>
                            <span v-else>Tạo sự kiện</span>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</template>

<script>
import { UploadIcon, XIcon } from 'lucide-vue-next'
import { useEventStore } from '../../../stores/eventStore'
import { useCategoryStore } from '../../../stores/categoryStore'

export default {
    props: {
        isOpen: {
            type: Boolean,
            default: false
        },
        clubId: {
            type: [String, Number],
            required: true
        }
    },
    emits: ['close', 'eventCreated'],
    data() {
        return {
            images: Array.from({ length: 1 }, () => ({ file: null, preview: null })),
            formData: {
                club_id: parseInt(this.clubId),
                category_id: '',
                name: '',
                start_date: '',
                end_date: '',
                location: '',
                max_participants: 1,
                content: '',
                status: 'active',
                logo: null
            },
            errors: {},
            isLoading: false,
            error: null,
            categories: []
        };
    },
    async created() {
        // Fetch categories when component is created
        const categoryStore = useCategoryStore();
        await categoryStore.fetchCategories();
        this.categories = categoryStore.eventCategories;
    },
    methods: {
        closeModal() {
            this.$emit('close');
            // Reset form data
            this.formData = {
                club_id: parseInt(this.clubId),
                category_id: '',
                name: '',
                start_date: '',
                end_date: '',
                location: '',
                max_participants: 1,
                content: '',
                status: 'active',
                logo: null
            };
            this.images = Array.from({ length: 1 }, () => ({ file: null, preview: null }));
            this.error = null;
        },
        handleImageUpload(event, index) {
            const file = event.target.files[0];
            if (file) {
                this.images[index].file = file;
                this.images[index].preview = URL.createObjectURL(file);
                this.formData.logo = file; // Set the logo in formData
            }
        },
        removeImage(index) {
            this.images[index].file = null;
            this.images[index].preview = null;
            this.formData.logo = null; // Clear the logo in formData
            // Reset file input
            const fileInput = document.getElementById('file-upload');
            if (fileInput) fileInput.value = '';
        },
        validateForm() {
            this.errors = {};
            
            if (!this.formData.name?.trim()) {
                this.errors.name = 'Vui lòng nhập tên sự kiện';
            }
            
            if (!this.formData.location?.trim()) {
                this.errors.location = 'Vui lòng nhập địa điểm';
            }
            
            if (!this.formData.category_id) {
                this.errors.category = 'Vui lòng chọn thể loại';
            }
            
            if (!this.formData.start_date) {
                this.errors.start_date = 'Vui lòng chọn thời gian bắt đầu';
            }
            
            if (!this.formData.end_date) {
                this.errors.end_date = 'Vui lòng chọn thời gian kết thúc';
            }
            
            if (!this.formData.logo) {
                this.errors.image = 'Vui lòng tải lên hình ảnh';
            }

            return Object.keys(this.errors).length === 0;
        },
        async handleSubmit(e) {
            if (!this.validateForm()) {
                return;
            }

            this.isLoading = true;
            this.error = null;

            try {
                const eventStore = useEventStore();
                const response = await eventStore.createEvent(this.formData);
                this.$emit('eventCreated', response);
                this.closeModal();
            } catch (error) {
                this.error = error.message || 'Có lỗi xảy ra khi tạo sự kiện';
            } finally {
                this.isLoading = false;
            }
        }
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
