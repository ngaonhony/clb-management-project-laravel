<template>
    <!-- Main modal -->
    <Teleport to="body">
        <transition name="fade">
            <div v-if="isOpen" class="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center overflow-y-auto p-4">
                <transition name="slide-up">
                    <div v-if="isOpen" class="bg-white rounded-xl shadow-xl w-full max-w-4xl max-h-[90vh] flex flex-col">
                        <!-- Header -->
                        <div class="flex items-center justify-between border-b border-gray-200 px-6 py-4">
                            <h2 class="text-xl font-semibold">Tạo sự kiện</h2>
                            <button @click="closeModal" class="text-gray-500 hover:text-gray-700">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-x">
                                    <path d="M18 6 6 18"/>
                                    <path d="m6 6 12 12"/>
                                </svg>
                            </button>
                        </div>

                        <!-- Form Content -->
                        <div class="overflow-y-auto flex-1 p-6">
                            <form @submit.prevent="handleSubmit">
                                <!-- Image Upload Section -->
                                <div class="bg-white rounded-lg border border-gray-200 p-4 mb-6">
                                    <div class="flex justify-between items-center mb-2">
                                        <h2 class="text-blue-500 font-medium">Ảnh bìa Sự kiện</h2>
                                        <span class="text-gray-500 text-sm">0/1</span>
                                    </div>
                                    <div class="border border-gray-200 rounded-lg p-4 flex flex-col items-center justify-center h-60">
                                        <!-- Preview Image -->
                                        <div v-if="images[0].preview" class="relative w-full h-full">
                                            <img :src="images[0].preview" class="w-full h-full object-contain rounded-lg" alt="Preview" />
                                            <button @click.prevent="removeImage(0)" class="absolute top-2 right-2 bg-white rounded-full p-1 shadow-md hover:bg-gray-100">
                                                <XIcon class="w-5 h-5 text-gray-600" />
                                            </button>
                                        </div>
                                        
                                        <!-- Upload Placeholder -->
                                        <template v-else>
                                            <div class="text-blue-500 mb-4">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-cloud-upload">
                                                    <path d="M4 14.899A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 2.5 8.242"/>
                                                    <path d="M12 12v9"/>
                                                    <path d="m16 16-4-4-4 4"/>
                                                </svg>
                                            </div>
                                            <p class="text-gray-700 mb-1">Kéo và Thả ảnh vào đây</p>
                                            <p class="text-gray-500 text-sm mb-4">hoặc</p>
                                            <input type="file" id="file-upload" @change="handleImageUpload($event, 0)" accept="image/*" class="hidden" />
                                            <label for="file-upload" class="border border-gray-300 rounded px-4 py-2 text-sm flex items-center gap-2 cursor-pointer">
                                                <span class="text-lg">+</span> Chọn ảnh
                                            </label>
                                        </template>
                                    </div>
                                    <p v-if="errors.image" class="mt-1 text-sm text-red-500">{{ errors.image }}</p>
                                </div>

                                <!-- Basic Information Section -->
                                <div class="bg-white rounded-lg border border-gray-200 p-4 mb-6">
                                    <div class="flex justify-between items-center mb-4">
                                        <h2 class="text-blue-500 font-medium">Thông tin cơ bản</h2>
                                        <span class="text-gray-500 text-sm">0/3</span>
                                    </div>
                                    
                                    <div class="mb-4">
                                        <label class="block text-gray-700 mb-2">Tên sự kiện <span class="text-red-500">*</span></label>
                                        <input 
                                            type="text" 
                                            v-model="formData.name"
                                            placeholder="Nhập tên sự kiện" 
                                            class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-1 focus:ring-blue-500"
                                            :class="{'border-red-500': errors.name}"
                                        >
                                        <p v-if="errors.name" class="mt-1 text-sm text-red-500">{{ errors.name }}</p>
                                    </div>
                                    
                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                        <div>
                                            <label class="block text-gray-700 mb-2">Loại sự kiện <span class="text-red-500">*</span></label>
                                            <div class="relative">
                                                <select 
                                                    v-model="formData.category_id"
                                                    class="w-full border border-gray-300 rounded-md px-3 py-2 appearance-none focus:outline-none focus:ring-1 focus:ring-blue-500"
                                                    :class="{'border-red-500': errors.category}"
                                                >
                                                    <option value="">Chọn loại sự kiện</option>
                                                    <option v-for="category in categories" :key="category.id" :value="category.id">
                                                        {{ category.name }}
                                                    </option>
                                                </select>
                                                <div class="absolute inset-y-0 right-0 flex items-center px-2 pointer-events-none">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-chevron-down">
                                                        <path d="m6 9 6 6 6-6"/>
                                                    </svg>
                                                </div>
                                                <p v-if="errors.category" class="mt-1 text-sm text-red-500">{{ errors.category }}</p>
                                            </div>
                                        </div>
                                        <div>
                                            <label class="block text-gray-700 mb-2">Quy mô tổ chức</label>
                                            <input 
                                                type="number" 
                                                v-model="formData.max_participants"
                                                placeholder="Nhập số lượng người tham gia" 
                                                class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-1 focus:ring-blue-500"
                                            >
                                        </div>
                                    </div>
                                </div>

                                <!-- Date and Time Section -->
                                <div class="bg-white rounded-lg border border-gray-200 p-4 mb-6">
                                    <div class="flex justify-between items-center mb-4">
                                        <h2 class="text-blue-500 font-medium">Thời gian, Địa điểm</h2>
                                        <span class="text-gray-500 text-sm">1/5</span>
                                    </div>
                                    
                                    <div class="mb-6">
                                        <h3 class="text-gray-700 font-medium mb-3">Thời gian</h3>
                                        
                                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-3">
                                            <div>
                                                <label class="block text-gray-700 mb-2 text-sm">Thời gian bắt đầu <span class="text-red-500">*</span></label>
                                                <input 
                                                    type="datetime-local" 
                                                    v-model="formData.start_date"
                                                    class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-1 focus:ring-blue-500"
                                                    :class="{'border-red-500': errors.start_date}"
                                                >
                                                <p v-if="errors.start_date" class="mt-1 text-sm text-red-500">{{ errors.start_date }}</p>
                                            </div>
                                            <div>
                                                <label class="block text-gray-700 mb-2 text-sm">Thời gian kết thúc <span class="text-red-500">*</span></label>
                                                <input 
                                                    type="datetime-local" 
                                                    v-model="formData.end_date"
                                                    class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-1 focus:ring-blue-500"
                                                    :class="{'border-red-500': errors.end_date}"
                                                >
                                                <p v-if="errors.end_date" class="mt-1 text-sm text-red-500">{{ errors.end_date }}</p>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div>
                                        <h3 class="text-gray-700 font-medium mb-3">Địa điểm</h3>
                                        
                                        <div class="grid grid-cols-1 md:grid-cols-1 gap-4">
                                            <div>
                                                <label class="block text-gray-700 mb-2 text-sm">Địa điểm <span class="text-red-500">*</span></label>
                                                <div class="relative">
                                                    <div class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none text-gray-400">
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-map-pin">
                                                            <path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/>
                                                            <circle cx="12" cy="10" r="3"/>
                                                        </svg>
                                                    </div>
                                                    <input 
                                                        type="text" 
                                                        v-model="formData.location"
                                                        placeholder="Nhập tên địa điểm" 
                                                        class="w-full border border-gray-300 rounded-md pl-10 pr-3 py-2 focus:outline-none focus:ring-1 focus:ring-blue-500"
                                                        :class="{'border-red-500': errors.location}"
                                                    >
                                                    <p v-if="errors.location" class="mt-1 text-sm text-red-500">{{ errors.location }}</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Description Section -->
                                <div class="bg-white rounded-lg border border-gray-200 p-4 mb-6">
                                    <div class="flex justify-between items-center mb-4">
                                        <h2 class="text-blue-500 font-medium">Mô tả sự kiện</h2>
                                        <div class="bg-green-100 rounded-full w-6 h-6 flex items-center justify-center">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-check text-green-600">
                                                <path d="M20 6 9 17l-5-5"/>
                                            </svg>
                                        </div>
                                    </div>
                                    
                                    <textarea 
                                        v-model="formData.content"
                                        placeholder="Nhập nội dung..." 
                                        class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-1 focus:ring-blue-500 h-32 mb-2"
                                    ></textarea>
                                    
                                    <div class="flex border-t pt-2">
                                        <button type="button" class="text-gray-500 mr-3">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-bold">
                                                <path d="M14 12a4 4 0 0 0 0-8H6v8"/>
                                                <path d="M15 20a4 4 0 0 0 0-8H6v8Z"/>
                                            </svg>
                                        </button>
                                        <button type="button" class="text-gray-500 mr-3">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-italic">
                                                <line x1="19" x2="10" y1="4" y2="4"/>
                                                <line x1="14" x2="5" y1="20" y2="20"/>
                                                <line x1="15" x2="9" y1="4" y2="20"/>
                                            </svg>
                                        </button>
                                        <button type="button" class="text-gray-500 mr-3">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-underline">
                                                <path d="M6 4v6a6 6 0 0 0 12 0V4"/>
                                                <line x1="4" x2="20" y1="20" y2="20"/>
                                            </svg>
                                        </button>
                                        <button type="button" class="text-gray-500 mr-3">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-list">
                                                <line x1="8" x2="21" y1="6" y2="6"/>
                                                <line x1="8" x2="21" y1="12" y2="12"/>
                                                <line x1="8" x2="21" y1="18" y2="18"/>
                                                <line x1="3" x2="3.01" y1="6" y2="6"/>
                                                <line x1="3" x2="3.01" y1="12" y2="12"/>
                                                <line x1="3" x2="3.01" y1="18" y2="18"/>
                                            </svg>
                                        </button>
                                        <button type="button" class="text-gray-500 mr-3">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-list-ordered">
                                                <line x1="10" x2="21" y1="6" y2="6"/>
                                                <line x1="10" x2="21" y1="12" y2="12"/>
                                                <line x1="10" x2="21" y1="18" y2="18"/>
                                                <path d="M4 6h1v4"/>
                                                <path d="M4 10h2"/>
                                                <path d="M6 18H4c0-1 2-2 2-3s-1-1.5-2-1"/>
                                            </svg>
                                        </button>
                                        <button type="button" class="text-gray-500">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-link">
                                                <path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"/>
                                                <path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"/>
                                            </svg>
                                        </button>
                                    </div>
                                </div>

                                <!-- Error message -->
                                <div v-if="error" class="mt-6 p-4 bg-red-100 border border-red-400 text-red-700 rounded-lg">
                                    {{ error }}
                                </div>
                            </form>
                        </div>

                        <!-- Footer -->
                        <div class="border-t border-gray-200 px-6 py-4 flex justify-end">
                            <button 
                                @click="closeModal" 
                                class="px-4 py-2 border border-gray-300 rounded-md mr-2 hover:bg-gray-50"
                            >
                                Hủy
                            </button>
                            <button 
                                @click="handleSubmit"
                                :disabled="isLoading"
                                class="px-4 py-2 bg-blue-500 text-white rounded-md hover:bg-blue-600 disabled:opacity-50 disabled:cursor-not-allowed"
                            >
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
                    </div>
                </transition>
            </div>
        </transition>
    </Teleport>
</template>

<script>
import { UploadIcon, XIcon } from 'lucide-vue-next'
import { useEventStore } from '../../../stores/eventStore'
import { useCategoryStore } from '../../../stores/categoryStore'

export default {
    components: {
        UploadIcon,
        XIcon
    },
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
            this.errors = {};
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
        async handleSubmit() {
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
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

.slide-up-enter-active,
.slide-up-leave-active {
  transition: transform 0.3s ease, opacity 0.3s ease;
}

.slide-up-enter-from,
.slide-up-leave-to {
  transform: translateY(20px);
  opacity: 0;
}

img {
  border: 1px solid #ddd;
  width: 100%;
  height: 100%;
  object-fit: cover;
}
</style>