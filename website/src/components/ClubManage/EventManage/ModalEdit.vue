<template>
    <div v-show="isOpen" class="fixed top-0 left-0 right-0 z-50 flex items-center justify-center w-full h-full bg-black/50">
      <div class="relative w-full max-w-2xl mx-4 bg-white rounded-lg shadow-lg">
        <div class="flex items-center justify-between p-4 border-b rounded-t">
          <h3 class="text-lg font-semibold text-gray-900">Chỉnh Sửa Sự Kiện</h3>
          <button @click="closeModal" class="text-gray-400 hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 flex justify-center items-center">
            <XIcon class="w-3 h-3" />
            <span class="sr-only">Close modal</span>
          </button>
        </div>
        <div class="flex flex-col max-h-[70vh] overflow-y-auto p-4">
          <form @submit.prevent="handleSubmit">
            <div class="mb-4">
              <label for="name" class="block mb-2 text-sm font-medium text-gray-900">Tên Sự Kiện</label>
              <input v-model="localEventData.name" type="text" id="name" placeholder="Tên Sự Kiện..." required
                class="w-full px-3 py-2 border rounded-lg text-sm focus:ring-blue-500 focus:border-blue-500" />
            </div>
            <div class="mb-4 flex flex-col md:flex-row gap-4">
              <div class="flex-1">
                <label class="block mb-2 text-sm font-medium text-gray-900">Hình ảnh</label>
                <div class="relative w-full h-48 border-2 border-dashed border-gray-300 rounded-lg hover:bg-gray-50">
                  <input type="file" id="file-upload" @change="handleImageUpload" accept="image/*" class="hidden" />
                  <div v-if="localImages[0]?.preview" class="flex items-center justify-center p-1 w-full h-full">
                    <img :src="localImages[0].preview" class="max-w-full max-h-full object-contain rounded-lg" alt="Preview" />
                    <button @click="removeImage(0)" class="absolute top-1 right-1 bg-white rounded-full p-1 shadow-md hover:bg-gray-100">
                      <XIcon class="w-4 h-4 text-gray-600" />
                    </button>
                  </div>
                  <label v-else for="file-upload" class="flex flex-col items-center justify-center w-full h-full cursor-pointer">
                    <UploadIcon class="w-6 h-6 text-gray-400 mb-2" />
                    <span class="text-sm text-gray-500">Thêm ảnh</span>
                  </label>
                </div>
              </div>
              <div class="flex-1">
                <div class="mb-4">
                  <label class="block mb-2 text-sm font-medium text-gray-900">Địa Điểm</label>
                  <input v-model="localEventData.location" type="text" id="location" placeholder="Nhập địa điểm..." required
                    class="w-full px-3 py-2 border rounded-lg text-sm focus:ring-blue-500 focus:border-blue-500" />
                </div>
                <div class="mb-4">
                  <label class="block mb-2 text-sm font-medium text-gray-900">Thể Loại</label>
                  <select v-model="localEventData.category" id="category" required
                    class="w-full px-3 py-2 border rounded-lg text-sm focus:ring-blue-500 focus:border-blue-500">
                    <option value="Học thuật">Học thuật</option>
                    <option value="Giải trí">Giải trí</option>
                    <option value="Thể thao">Thể thao</option>
                  </select>
                </div>
                <div class="mb-4">
                  <label class="block mb-2 text-sm font-medium text-gray-900">Thời Gian Bắt Đầu</label>
                  <input v-model="localEventData.start_date" type="datetime-local" id="time" required
                    class="w-full px-3 py-2 border rounded-lg text-sm focus:ring-blue-500 focus:border-blue-500" />
                </div>
                <div class="mb-4">
                  <label class="block mb-2 text-sm font-medium text-gray-900">Số Lượng Người Tham Gia Tối Đa</label>
                  <input v-model.number="localEventData.max_participants" type="number" id="max_participants" placeholder="Nhập số lượng..." required
                    class="w-full px-3 py-2 border rounded-lg text-sm focus:ring-blue-500 focus:border-blue-500" />
                </div>
              </div>
            </div>
            <button type="submit" class="w-full px-4 py-2 text-sm font-medium text-white bg-blue-600 rounded-lg hover:bg-blue-700 focus:ring-4 focus:ring-blue-300">
              Cập nhật
            </button>
          </form>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  import { ref, watch } from 'vue';
  import { UploadIcon, XIcon } from 'lucide-vue-next';
  
  export default {
    components: { UploadIcon, XIcon },
    props: {
    isOpen: Boolean,
    eventData: {
        type: Object,
        default: () => ({
        name: '',
        location: '',
        category: '',
        start_date: '',
        max_participants: '',
        background_images: [],
        }),
    },
    images: {
        type: Array,
        default: () => [],
    },
    methods: {
        handleSubmit() {
        this.$emit('submit', this.eventData); 
        },
    },
    },
    setup(props, { emit }) {
      const localEventData = ref({ ...props.eventData });
      const localImages = ref([...props.images]);
  
      watch(() => props.eventData, (newVal) => {
        localEventData.value = { ...newVal };
      });
      watch(() => props.images, (newVal) => {
        localImages.value = [...newVal];
      });
  
      const handleImageUpload = (event) => {
        const file = event.target.files[0];
        if (file) {
          const reader = new FileReader();
          reader.onload = (e) => {
            localImages.value[0] = { preview: e.target.result };
          };
          reader.readAsDataURL(file);
        }
      };
  
      const removeImage = (index) => {
        localImages.value[index] = { preview: null };
      };
  
      const handleSubmit = () => {
        emit('submit', { ...localEventData.value, images: localImages.value });
      };
  
      return {
        localEventData,
        localImages,
        handleImageUpload,
        removeImage,
        handleSubmit,
        closeModal: () => emit('close'),
      };
    },
  };
  </script>