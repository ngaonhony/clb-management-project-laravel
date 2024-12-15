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
            <div class="flex flex-col max-h-[500px] overflow-hidden">
                <!-- Form Section -->
                <form class="p-4 flex-grow overflow-auto">
                    <!-- Input -->
                    <div class="mb-4">
                        <label for="name" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">Tên Sự
                            Kiện</label>
                        <input type="text" id="name" placeholder="Tên Sự Kiện..."
                            class="w-full px-3 py-2 border rounded-lg text-sm focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-50 dark:border-gray-600 dark:text-black">
                    </div>

                    <!-- Input file images with scrollable area -->
                    <div class="mb-4">
                        <div class="flex gap-4">
                            <!-- Left Section for Image Upload -->
                            <div class="mb-4">
                                <label class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">Hình
                                    ảnh</label>
                                <div
                                    class="flex items-center justify-center relative w-[250px] h-[200px] border-2 border-dashed border-gray-300 rounded-lg hover:bg-gray-50 transition-colors">

                                    <input type="file" id="file-upload" @change="handleImageUpload($event, 0)"
                                        accept="image/*" class="hidden" />

                                    <!-- Preview Image -->
                                    <div v-if="images[0].preview"
                                        class="flex items-center justify-center p-1 w-full h-full">
                                        <img :src="images[0].preview"
                                            class="max-w-full max-h-full object-contain rounded-lg" alt="Preview" />
                                        <button @click="removeImage(0)"
                                            class="absolute top-1 right-1 bg-white rounded-full p-1 shadow-md hover:bg-gray-100">
                                            <XIcon class="w-4 h-4 text-gray-600" />
                                        </button>
                                    </div>

                                    <!-- Upload Placeholder -->
                                    <label v-else for="file-upload"
                                        class="flex flex-col items-center justify-center w-full h-full cursor-pointer">
                                        <UploadIcon class="w-6 h-6 text-gray-400 mb-2" />
                                        <span class="text-sm text-gray-500">Thêm ảnh</span>
                                    </label>
                                </div>
                            </div>

                            <!-- Right Section for Location, Category, Time -->
                            <div class="flex flex-col justify-between">
                                <div class="mb-4">
                                    <label class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">Địa
                                        Điểm</label>
                                    <input type="text" id="location" placeholder="Nhập địa điểm..."
                                        class="w-full px-3 py-2 border rounded-lg text-sm focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-50 dark:border-gray-600 dark:text-black" />
                                </div>

                                <div class="mb-4">
                                    <label class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">Thể
                                        Loại</label>
                                    <select type="text" id="category"
                                        class="w-full px-3 py-2 border rounded-lg text-sm focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-50 dark:border-gray-600 dark:text-black">
                                        <option value="volvo">Học thuật</option>
                                    </select>
                                </div>

                                <div class="mb-4">
                                    <label class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">Thời
                                        Gian</label>
                                    <input type="datetime-local" id="time"
                                        class="w-full px-3 py-2 border rounded-lg text-sm focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-50 dark:border-gray-600 dark:text-black" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit"
                        class="w-full px-4 py-2 text-sm font-medium text-center text-white bg-blue-600 rounded-lg hover:bg-blue-700 focus:outline-none focus:ring-4 focus:ring-blue-300">
                        Tạo
                    </button>
                </form>
            </div>
        </div>
    </div>
</template>

<script>
import { UploadIcon, XIcon } from 'lucide-vue-next'
export default {
    props: {
        isOpen: {
            type: Boolean,
            default: false
        }
    },
    emits: ['close'],
    data() {
        return {
            images: Array.from({ length: 1 }, () => ({ file: null, preview: null }))
        };
    },
    methods: {
        closeModal() {
            this.$emit('close');
        },
        handleImageUpload(event, index) {
            const file = event.target.files[0];
            if (file) {
                this.images[index].file = file;
                this.images[index].preview = URL.createObjectURL(file);
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
