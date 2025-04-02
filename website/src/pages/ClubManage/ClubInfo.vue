<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Main Content -->
    <div class="ml-16">
      <!-- Header -->
      <div class="bg-white border-b px-8 py-4 flex items-center justify-between">
        <div class="flex items-center">
          <ChevronLeftIcon class="w-5 h-5 mr-2" />
          <h1 class="text-xl font-medium">Thông tin CLB</h1>
        </div>
        <button 
          @click="toggleEditMode" 
          class="px-4 py-2 rounded-lg"
          :class="isEditing ? 'bg-gray-500 text-white' : 'bg-blue-500 text-white'"
        >
          {{ isEditing ? 'Hủy chỉnh sửa' : 'Chỉnh sửa' }}
        </button>
      </div>

      <!-- Form Content -->
      <div class="max-w-4xl mx-auto py-8 px-4">
        <form @submit.prevent="handleSubmit" ref="clubForm">
          <!-- Basic Information -->
          <div class="mb-8">
            <h2 class="text-xl text-blue-600 font-medium mb-6">
              Thông tin cơ bản
            </h2>

            <div class="grid grid-cols-2 gap-6 mb-6">
              <div>
                <label class="block mb-2">
                  Logo Câu Lạc Bộ
                  <span class="text-red-500">*</span>
                </label>
                <div
                  class="border-2 border-dashed border-gray-300 rounded-lg p-4 text-center cursor-pointer hover:border-blue-500 transition-colors"
                  @click="triggerLogoUpload">
                  <input type="file" ref="logoInput" @change="handleLogoUpload" accept="image/*" class="hidden" />
                  <div v-if="logoPreview" class="relative">
                    <img :src="logoPreview" class="w-32 h-32 mx-auto mb-2 object-cover rounded-lg" />
                    <button
                      @click.stop="removeLogo"
                      class="absolute top-2 right-2 bg-red-500 text-white p-1 rounded-full opacity-0 group-hover:opacity-100 transition-opacity">
                      <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
                      </svg>
                    </button>
                  </div>
                  <template v-else>
                    <UploadIcon class="w-8 h-8 mx-auto mb-2 text-gray-400" />
                    <p class="text-sm text-gray-500">Tải logo lên</p>
                  </template>
                </div>
                <p class="text-xs text-gray-500 mt-1">
                  * Khuyến khích sử dụng ảnh 100x100px để hiển thị tốt nhất.
                </p>
              </div>

              <div>
                <label class="block mb-2">
                  Ảnh khác của CLB
                </label>
                <div
                  class="border-2 border-dashed border-gray-300 rounded-lg p-4 text-center cursor-pointer hover:border-blue-500 transition-colors"
                  @click="triggerImagesUpload">
                  <input type="file" ref="imagesInput" @change="handleImagesUpload" accept="image/*" multiple class="hidden" />
                  <div v-if="imagesPreview.length > 0" class="relative">
                    <div class="grid grid-cols-2 gap-4">
                      <div v-for="(image, index) in imagesPreview" :key="image.id" class="relative group">
                        <img :src="image.url" class="w-32 h-32 mx-auto mb-2 object-cover rounded-lg" />
                        <button
                          @click.stop="removeImage(index)"
                          class="absolute top-2 right-2 bg-red-500 text-white p-1 rounded-full opacity-0 group-hover:opacity-100 transition-opacity">
                          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                            <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
                          </svg>
                        </button>
                      </div>
                    </div>
                  </div>
                  <template v-else>
                    <UploadIcon class="w-8 h-8 mx-auto mb-2 text-gray-400" />
                    <p class="text-sm text-gray-500">Tải nhiều ảnh lên</p>
                  </template>
                </div>
                <p class="text-xs text-gray-500 mt-1">
                  * Có thể tải lên nhiều ảnh cùng lúc.
                </p>
              </div>
            </div>

            <div class="grid grid-cols-2 gap-6">
              <div>
                <label class="block mb-2">
                  Tên CLB
                  <span class="text-red-500">*</span>
                </label>
                <div class="w-full px-3 py-2 border rounded-lg" :class="{'bg-gray-50': !isEditing}">
                  <input v-if="isEditing" type="text" v-model="form.name" class="w-full bg-white" placeholder="Nhập tên CLB" />
                  <template v-else>{{ selectedClub?.name || 'Chưa có thông tin' }}</template>
                </div>
                </div>

                <div>
                <label class="block mb-2">
                  Danh mục
                  <span class="text-red-500">*</span>
                </label>
                <div class="w-full px-3 py-2 border rounded-lg" :class="{'bg-gray-50': !isEditing}">
                  <select v-if="isEditing" v-model="form.category_id" class="w-full bg-white">
                    <option v-for="category in categoryStore.categories" :key="category.id" :value="category.id">{{ category.name }}</option>
                  </select>
                  <template v-else>{{ categoryStore.getCategoryName(selectedClub?.category_id) || 'Chưa có thông tin' }}</template>
                </div>
                </div>
            </div>
          </div>

          <!-- Description -->
          <div class="mb-8">
            <h2 class="text-xl text-blue-600 font-medium mb-6">
              Mô tả / Giới thiệu Câu Lạc Bộ
            </h2>
            <div>
              <label class="block mb-2">
                Giới thiệu CLB
                <span class="text-red-500">*</span>
              </label>
              <div class="w-full px-3 py-2 border rounded-lg" :class="{'bg-gray-50': !isEditing}">
                <textarea v-if="isEditing" v-model="form.description" rows="4" class="w-full bg-white resize-none" placeholder="Nhập giới thiệu CLB"></textarea>
                <template v-else>{{ selectedClub?.description || 'Chưa có thông tin' }}</template>
              </div>
            </div>
          </div>

          <!-- Contact Information -->
          <div class="mb-8">
            <h2 class="text-xl text-blue-600 font-medium mb-6">
              Thông tin liên hệ
            </h2>

            <div class="grid grid-cols-2 gap-6">
              <div>
                <label class="block mb-2">
                  Email liên hệ
                  <span class="text-red-500">*</span>
                </label>
                <div class="w-full px-3 py-2 border rounded-lg" :class="{'bg-gray-50': !isEditing}">
                  <input v-if="isEditing" type="email" v-model="form.contact_email" class="w-full bg-white" placeholder="Nhập email liên hệ" />
                  <template v-else>{{ selectedClub?.contact_email || 'Chưa có thông tin' }}</template>
                </div>
              </div>

              <div>
                <label class="block mb-2">
                  Số điện thoại
                  <span class="text-red-500">*</span>
                </label>
                <div class="w-full px-3 py-2 border rounded-lg" :class="{'bg-gray-50': !isEditing}">
                  <input v-if="isEditing" type="tel" v-model="form.contact_phone" class="w-full bg-white" placeholder="Nhập số điện thoại" />
                  <template v-else>{{ selectedClub?.contact_phone || 'Chưa có thông tin' }}</template>
                </div>
              </div>

              <div>
                <label class="block mb-2">
                  Địa chỉ
                  <span class="text-red-500">*</span>
                </label>
                <div class="w-full px-3 py-2 border rounded-lg" :class="{'bg-gray-50': !isEditing}">
                  <input v-if="isEditing" type="text" v-model="form.contact_address" class="w-full bg-white" placeholder="Nhập địa chỉ" />
                  <template v-else>{{ selectedClub?.contact_address || 'Chưa có thông tin' }}</template>
                </div>
              </div>

              <div>
                <label class="block mb-2">
                  Tỉnh / Thành phố
                  <span class="text-red-500">*</span>
                </label>
                <div class="w-full px-3 py-2 border rounded-lg" :class="{'bg-gray-50': !isEditing}">
                  <input v-if="isEditing" type="text" v-model="form.province" class="w-full bg-white" placeholder="Nhập tỉnh/thành phố" />
                  <template v-else>{{ selectedClub?.province || 'Chưa có thông tin' }}</template>
                </div>
              </div>
            </div>

            <!-- Social Media -->
            <div class="mt-6">
              <h3 class="font-medium mb-4">Mạng xã hội</h3>

              <div class="space-y-4">
                <div class="flex items-center gap-4">
                  <div class="w-32 flex items-center gap-2">
                    <img :src="socials[0].icon" alt="Facebook" class="w-8 h-8" />
                    <span>Facebook</span>
                  </div>
                  <input type="text" v-model="form.facebook_link" :disabled="!isEditing"
                    class="flex-1 px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    :placeholder="form.facebook_link || 'Nhập đường dẫn Facebook'
          " />
                </div>
                <div class="flex items-center gap-4">
                  <div class="w-32 flex items-center gap-2">
                    <img :src="socials[1].icon" alt="Zalo" class="w-8 h-8" />
                    <span>Zalo</span>
                  </div>
                  <input type="text" v-model="form.zalo_link" :disabled="!isEditing"
                    class="flex-1 px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    :placeholder="form.zalo_link || 'Nhập đường dẫn Zalo'" />
                </div>
              </div>
            </div>
          </div>

          <!-- Form Actions -->
          <div class="flex justify-between pt-6 border-t">
            <button type="button" class="px-4 py-2 text-gray-600 hover:text-gray-800" @click="goToDashboard">
              Về Dashboard
            </button>
            <button v-if="isEditing" 
                    type="submit" 
                    class="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600"
                    @click.prevent="submitForm">
              Lưu thông tin
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { storeToRefs } from 'pinia'
import ClubService from '../../services/club'
import { useCategoryStore } from '../../stores/categoryStore'
import { useClubStore } from '../../stores/clubStore'
import {
  HomeIcon,
  UsersIcon,
  FolderIcon,
  ChevronLeftIcon,
  UploadIcon
} from 'lucide-vue-next'
import { toast } from '../../plugins/toast'

const route = useRoute()
const router = useRouter()
const categoryStore = useCategoryStore()
const clubForm = ref(null)

const clubStore = useClubStore()
const { selectedClub } = storeToRefs(clubStore)

const isEditing = ref(false)

const form = computed(() => ({
  name: selectedClub.value?.name || '',
  category_id: selectedClub.value?.category_id || '',
  description: selectedClub.value?.description || '',
  contact_email: selectedClub.value?.contact_email || '',
  contact_phone: selectedClub.value?.contact_phone || '',
  contact_address: selectedClub.value?.contact_address || '',
  province: selectedClub.value?.province || '',
  facebook_link: selectedClub.value?.facebook_link || '',
  zalo_link: selectedClub.value?.zalo_link || '',
  logo: null,
  images: [],
  deleted_image_ids: []
}))

const logoPreview = ref(null)
const imagesPreview = ref([])
const logoInput = ref(null)
const imagesInput = ref(null)

const socials = [
  { id: 'facebook', name: 'Facebook', icon: 'https://th.bing.com/th/id/R.83e3cc297106767114f2c060f7f5fcbb?rik=FkFOcs3CThcCJQ&pid=ImgRaw&r=0' },
  { id: 'zalo', name: 'Zalo', icon: 'https://th.bing.com/th/id/OIP.-kImg-7dr-QEfCzb17cbEAHaHa?w=175&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7' },
]

onMounted(async () => {
  try {
    await categoryStore.fetchCategories()
    
    const clubId = route.params.id
    if (clubId) {
      await clubStore.fetchClubById(clubId)
      
      // Set logo preview if exists
      const logoImage = selectedClub.value?.backgroundImages?.find(img => img.is_logo === 1)
      if (logoImage) {
        logoPreview.value = logoImage.url
      }

      // Set other images preview
      const otherImages = selectedClub.value?.backgroundImages?.filter(img => img.is_logo === 0) || []
      imagesPreview.value = otherImages.map(img => ({
        id: img.id,
        url: img.url
      }))
    }
  } catch (error) {
    console.error('Error fetching club data:', error)
    toast.error('Không thể tải thông tin câu lạc bộ')
  }
})

const handleLogoUpload = (event) => {
  const file = event.target.files[0]
  if (file) {
    // Validate file type
    if (!file.type.startsWith('image/')) {
      toast.error('Vui lòng chọn một file ảnh')
      return
    }

    // Validate file size (max 2MB)
    if (file.size > 2 * 1024 * 1024) {
      toast.error('Kích thước ảnh không được vượt quá 2MB')
      return
    }

    form.value.logo = file
    logoPreview.value = URL.createObjectURL(file)
  }
}

const handleImagesUpload = (event) => {
  const files = Array.from(event.target.files)
  if (files.length > 0) {
    // Validate files
    for (const file of files) {
      if (!file.type.startsWith('image/')) {
        toast.error('Vui lòng chọn các file ảnh')
        return
      }
      if (file.size > 2 * 1024 * 1024) {
        toast.error('Kích thước ảnh không được vượt quá 2MB')
        return
      }
    }

    // Add new images to form
    form.value.images = [...form.value.images, ...files]
    
    // Add previews
    files.forEach(file => {
      imagesPreview.value.push({
        id: Date.now() + Math.random(), // Temporary ID for preview
        url: URL.createObjectURL(file)
      })
    })
  }
}

const removeImage = (index) => {
  const image = imagesPreview.value[index]
  if (image.id) {
    // If it's an existing image (has ID), add to deleted_image_ids
    form.value.deleted_image_ids.push(image.id)
  }
  
  // Remove from previews and form
  imagesPreview.value.splice(index, 1)
  form.value.images.splice(index, 1)
}

const toggleEditMode = () => {
  if (isEditing.value) {
    // Reset form when canceling edit
    form.value = {
      name: selectedClub.value?.name || '',
      category_id: selectedClub.value?.category_id || '',
      description: selectedClub.value?.description || '',
      contact_email: selectedClub.value?.contact_email || '',
      contact_phone: selectedClub.value?.contact_phone || '',
      contact_address: selectedClub.value?.contact_address || '',
      province: selectedClub.value?.province || '',
      facebook_link: selectedClub.value?.facebook_link || '',
      zalo_link: selectedClub.value?.zalo_link || '',
      logo: null,
      images: [],
      deleted_image_ids: []
    }
  }
  isEditing.value = !isEditing.value
}

const handleSubmit = async () => {
  console.log('Form submit triggered');
  console.log('Current form data:', form.value);
  
  // Check if form exists
  if (!clubForm.value) {
    console.error('Form reference not found');
    return;
  }

  try {
    // Validate required fields and ensure they are not empty strings
    const requiredFields = {
      name: form.value.name?.trim(),
      category_id: form.value.category_id,
      description: form.value.description?.trim(),
      contact_email: form.value.contact_email?.trim(),
      contact_phone: form.value.contact_phone?.trim(),
      contact_address: form.value.contact_address?.trim(),
      province: form.value.province?.trim()
    };

    console.log('Required fields:', requiredFields);

    const emptyFields = Object.entries(requiredFields)
      .filter(([_, value]) => !value)
      .map(([key]) => key);

    if (emptyFields.length > 0) {
      console.error('Empty required fields:', emptyFields);
      toast.error(`Vui lòng điền đầy đủ các trường: ${emptyFields.join(', ')}`)
      return
    }

    // Validate email format
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    if (!emailRegex.test(form.value.contact_email)) {
      console.error('Invalid email format');
      toast.error('Email không đúng định dạng')
      return
    }

    const clubId = route.params.id;
    console.log('Club ID:', clubId);

    // Send form data directly without creating new FormData
    console.log('Sending form data to service:', form.value);
    const response = await ClubService.updateClub(clubId, form.value);
    console.log('Update response:', response);

    if (response.data) {
      toast.success('Thông tin CLB đã được cập nhật thành công!')
      // Reload the form data to show updated information
      const updatedClubData = await ClubService.getClubById(clubId)
      
      // Update form with new data
      form.value = {
        name: updatedClubData.name,
        category_id: updatedClubData.category_id,
        description: updatedClubData.description,
        contact_email: updatedClubData.contact_email,
        contact_phone: updatedClubData.contact_phone,
        contact_address: updatedClubData.contact_address,
        province: updatedClubData.province,
        facebook_link: updatedClubData.facebook_link || '',
        zalo_link: updatedClubData.zalo_link || '',
        logo: null,
        images: [],
        deleted_image_ids: []
      }

      // Update previews
      const logoImage = updatedClubData.backgroundImages?.find(img => img.is_logo === 1)
      if (logoImage) {
        logoPreview.value = logoImage.url
      }

      const otherImages = updatedClubData.backgroundImages?.filter(img => img.is_logo === 0) || []
      imagesPreview.value = otherImages.map(img => ({
        id: img.id,
        url: img.url
      }))

      // Exit edit mode
      isEditing.value = false;
    } else {
      toast.error('Không thể cập nhật thông tin CLB. Vui lòng thử lại.')
    }
  } catch (error) {
    console.error('Error in handleSubmit:', error);
    if (error.response?.status === 422) {
      const validationErrors = error.response.data.errors
      const errorMessages = Object.values(validationErrors).flat().join('\n')
      toast.error('Lỗi xác thực:\n' + errorMessages)
    } else {
      toast.error('Không thể cập nhật thông tin CLB. Vui lòng thử lại.')
    }
  }
}

// Add a method to manually submit the form
const submitForm = () => {
  if (clubForm.value) {
    clubForm.value.requestSubmit();
  } else {
    handleSubmit();
  }
}

const goToDashboard = () => {
  router.push('/dashboard')
}

const triggerLogoUpload = () => {
  logoInput.value.click()
}

const triggerImagesUpload = () => {
  imagesInput.value.click()
}

const removeLogo = () => {
  form.value.logo = null;
  logoPreview.value = null;
}
</script>

<style scoped>
/* Add any additional styles here */
</style>
