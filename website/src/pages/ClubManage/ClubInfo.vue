<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Left Sidebar -->

    <!-- Main Content -->
    <div class="ml-16">
      <!-- Header -->
      <div class="bg-white border-b px-8 py-4 flex items-center">
        <ChevronLeftIcon class="w-5 h-5 mr-2" />
        <h1 class="text-xl font-medium">Thông tin CLB</h1>
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
                  <img v-if="logoPreview" :src="logoPreview" class="w-32 h-32 mx-auto mb-2 object-cover rounded-lg" />
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
                  <UploadIcon class="w-8 h-8 mx-auto mb-2 text-gray-400" />
                  <p class="text-sm text-gray-500">Tải nhiều ảnh lên</p>
                </div>
                <p class="text-xs text-gray-500 mt-1">
                  * Có thể tải lên nhiều ảnh cùng lúc.
                </p>
              </div>
            </div>

            <!-- Image Gallery -->
            <div v-if="imagesPreview.length > 0" class="mt-6">
              <h3 class="font-medium mb-4">Ảnh đã tải lên</h3>
              <div class="grid grid-cols-4 gap-4">
                <div v-for="(image, index) in imagesPreview" :key="image.id" class="relative group">
                  <img :src="image.url" class="w-full h-32 object-cover rounded-lg" />
                  <button
                    @click="removeImage(index)"
                    class="absolute top-2 right-2 bg-red-500 text-white p-1 rounded-full opacity-0 group-hover:opacity-100 transition-opacity">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                      <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
                    </svg>
                  </button>
                </div>
              </div>
            </div>

            <div class="grid grid-cols-2 gap-6">
              <div>
                <label class="block mb-2">
                  Tên CLB
                  <span class="text-red-500">*</span>
                </label>
                <input type="text" v-model="form.name"
                  class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  :placeholder="form.name || 'Nhập tên CLB'" />
              </div>

              <div>
                <label class="block mb-2">
                  Danh mục
                  <span class="text-red-500">*</span>
                </label>
                <select v-model="form.category_id"
                  class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                  <option value="">Chọn danh mục</option>
                  <option v-for="category in categoryStore.clubCategories" 
                          :key="category.id" 
                          :value="category.id">
                    {{ category.name }}
                  </option>
                </select>
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
              <textarea v-model="form.description" rows="4"
                class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                :placeholder="form.description ||
          'Mô tả hoạt động và giới thiệu về CLB hiện tại'
          "></textarea>
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
                <input type="email" v-model="form.contact_email"
                  class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  :placeholder="form.contact_email || 'Nhập email liên hệ'" />
              </div>

              <div>
                <label class="block mb-2">
                  Số điện thoại
                  <span class="text-red-500">*</span>
                </label>
                <input type="tel" v-model="form.contact_phone"
                  class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  :placeholder="form.contact_phone || 'Nhập số điện thoại'" />
              </div>

              <div>
                <label class="block mb-2">
                  Địa chỉ
                  <span class="text-red-500">*</span>
                </label>
                <input type="text" v-model="form.contact_address"
                  class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  :placeholder="form.contact_address || 'Nhập địa chỉ'" />
              </div>

              <div>
                <label class="block mb-2">
                  Tỉnh / Thành phố
                  <span class="text-red-500">*</span>
                </label>
                <input type="text" v-model="form.province"
                  class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  :placeholder="form.province || 'Nhập tỉnh/thành phố'" />
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
                  <input type="text" v-model="form.facebook_link"
                    class="flex-1 px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    :placeholder="form.facebook_link || 'Nhập đường dẫn Facebook'
          " />
                </div>
                <div class="flex items-center gap-4">
                  <div class="w-32 flex items-center gap-2">
                    <img :src="socials[1].icon" alt="Zalo" class="w-8 h-8" />
                    <span>Zalo</span>
                  </div>
                  <input type="text" v-model="form.zalo_link"
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
            <button type="button" 
                    class="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600"
                    @click="handleSubmit">
              Lưu thông tin
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import ClubService from '../../services/club'
import { useCategoryStore } from '../../stores/categoryStore'
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

const form = ref({
  name: '',
  category_id: '',
  description: '',
  contact_email: '',
  contact_phone: '',
  contact_address: '',
  province: '',
  facebook_link: '',
  zalo_link: '',
  logo: null,
  images: [],
  deleted_image_ids: []
})

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
    // Fetch categories first
    await categoryStore.fetchCategories()
    
    const clubId = route.params.id
    if (clubId) {
      const clubData = await ClubService.getClubById(clubId)
      form.value = {
        name: clubData.name,
        category_id: clubData.category_id,
        description: clubData.description,
        contact_email: clubData.contact_email,
        contact_phone: clubData.contact_phone,
        contact_address: clubData.contact_address,
        province: clubData.province,
        facebook_link: clubData.facebook_link || '',
        zalo_link: clubData.zalo_link || '',
        logo: null,
        images: [],
        deleted_image_ids: []
      }

      // Set logo preview if exists
      const logoImage = clubData.backgroundImages?.find(img => img.is_logo === 1)
      if (logoImage) {
        logoPreview.value = logoImage.url
      }

      // Set other images preview
      const otherImages = clubData.backgroundImages?.filter(img => img.is_logo === 0) || []
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

const handleSubmit = async () => {
  try {
    // Validate email format
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    if (!emailRegex.test(form.value.contact_email)) {
      toast.error('Email không đúng định dạng')
      return
    }

    const clubId = route.params.id
    if (!clubId) {
      toast.error('Không tìm thấy ID của CLB')
      return
    }

    // Create form data with proper type conversion
    const formData = {
      name: form.value.name || '',
      category_id: form.value.category_id,
      description: form.value.description || '',
      contact_email: form.value.contact_email,
      contact_phone: form.value.contact_phone || '',
      contact_address: form.value.contact_address || '',
      province: form.value.province || '',
      facebook_link: form.value.facebook_link || '',
      zalo_link: form.value.zalo_link || '',
      logo: form.value.logo,
      images: form.value.images,
      deleted_image_ids: form.value.deleted_image_ids
    }

    // Update club
    const response = await ClubService.updateClub(clubId, formData)
    
    if (response.data) {
      toast.success('Thông tin CLB đã được cập nhật thành công!')
      
      // Update form data with response
      const updatedClubData = response.data
      form.value = {
        name: updatedClubData.name,
        category_id: updatedClubData.category_id,
        description: updatedClubData.description,
        contact_email: updatedClubData.contact_email,
        contact_phone: updatedClubData.contact_phone,
        contact_address: updatedClubData.contact_address || '',
        province: updatedClubData.province || 'province',
        facebook_link: updatedClubData.facebook_link || 'facebook_link',
        zalo_link: updatedClubData.zalo_link || 'zalo_link',
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
    }
  } catch (error) {
    console.error('Error in handleSubmit:', error)
    if (error.response?.status === 422) {
      const validationErrors = error.response.data.errors
      const errorMessages = Object.values(validationErrors).flat().join('\n')
      toast.error('Lỗi xác thực:\n' + errorMessages)
    } else {
      toast.error('Không thể cập nhật thông tin CLB. Vui lòng thử lại.')
    }
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
</script>

<style scoped>
/* Add any additional styles here */
</style>
