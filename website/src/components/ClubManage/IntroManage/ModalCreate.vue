<template>
    <!-- Main modal -->
    <div v-show="isOpen" tabindex="-1" aria-hidden="true"
        class="fixed top-0 left-0 right-0 z-50 flex items-center justify-center w-full h-full bg-black/50">
        <div class="relative w-full max-w-lg max-h-[90vh] bg-white rounded-lg shadow-lg dark:bg-gray-80">
            <!-- Modal header -->
            <div class="flex items-center justify-between p-4 border-b rounded-t dark:border-gray-700">
                <h3 class="text-lg font-semibold text-gray-900 dark:text-black">
                    Tạo Trang đại diện
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
                    <!-- Giới thiệu Input -->
                    <div class="mb-4">
                        <label for="name" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">Giới
                            thiệu</label>
                        <input type="text" id="name" placeholder="Giới thiệu..."
                            class="w-full px-3 py-2 border rounded-lg text-sm focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-50 dark:border-gray-600 dark:text-black">
                    </div>

                    <!-- Input file images with scrollable area -->
                    <div class="mb-4">
                        <label class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">Hình ảnh</label>
                        <div class="grid grid-cols-2 gap-4 max-h-[200px] overflow-y-auto">
                            <div v-for="(image, index) in images" :key="index" class="flex flex-col items-center">
                                <input type="file" @change="handleImageUpload($event, index)"
                                    class="block w-full text-sm text-gray-900 border border-gray-300 rounded-lg cursor-pointer dark:text-gray-400 focus:outline-none dark:bg-gray-50 dark:border-gray-600 dark:placeholder-gray-400" />
                                <img v-if="image.preview" :src="image.preview" alt="Preview"
                                    class="mt-2 w-full h-32 object-cover rounded-lg border" />
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
            images: Array.from({ length: 6 }, () => ({ file: null, preview: null }))
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
    grid-template-columns: repeat(3, 1fr);
    gap: 1rem;
}

img {
    border: 1px solid #ddd;
    width: 100%;
    height: 120px;
    object-fit: cover;
}
</style>
