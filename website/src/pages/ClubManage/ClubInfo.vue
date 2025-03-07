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
          <form @submit.prevent="handleSubmit">
            <!-- Basic Information -->
            <div class="mb-8">
              <h2 class="text-xl text-blue-600 font-medium mb-6">Thông tin cơ bản</h2>
              
              <div class="grid grid-cols-2 gap-6 mb-6">
                <div>
                  <label class="block mb-2">
                    Logo Câu Lạc Bộ
                    <span class="text-red-500">*</span>
                  </label>
                  <div 
                    class="border-2 border-dashed border-gray-300 rounded-lg p-4 text-center cursor-pointer hover:border-blue-500 transition-colors"
                    @click="triggerLogoUpload"
                  >
                    <input 
                      type="file" 
                      ref="logoInput" 
                      @change="handleLogoUpload" 
                      accept="image/*" 
                      class="hidden" 
                    />
                    <img 
                      v-if="logoPreview" 
                      :src="logoPreview" 
                      class="w-32 h-32 mx-auto mb-2 object-cover rounded-lg"
                    />
                    <template v-else>
                      <UploadIcon class="w-8 h-8 mx-auto mb-2 text-gray-400" />
                      <p class="text-sm text-gray-500">Tải ảnh lên</p>
                    </template>
                  </div>
                  <p class="text-xs text-gray-500 mt-1">* Khuyến khích sử dụng ảnh 100x100px để hiển thị tốt nhất.</p>
                </div>
                
                <div>
                  <label class="block mb-2">
                    Ảnh bìa Câu Lạc Bộ
                    <span class="text-red-500">*</span>
                  </label>
                  <div 
                    class="border-2 border-dashed border-gray-300 rounded-lg p-4 text-center cursor-pointer hover:border-blue-500 transition-colors"
                    @click="triggerCoverUpload"
                  >
                    <input 
                      type="file" 
                      ref="coverInput" 
                      @change="handleCoverUpload" 
                      accept="image/*" 
                      class="hidden" 
                    />
                    <img 
                      v-if="coverPreview" 
                      :src="coverPreview" 
                      class="w-full h-32 mx-auto mb-2 object-cover rounded-lg"
                    />
                    <template v-else>
                      <UploadIcon class="w-8 h-8 mx-auto mb-2 text-gray-400" />
                      <p class="text-sm text-gray-500">Tải ảnh lên</p>
                    </template>
                  </div>
                  <p class="text-xs text-gray-500 mt-1">* Khuyến khích sử dụng ảnh có độ phân giải tối thiểu 1440x900px.</p>
                </div>
              </div>
  
              <div class="grid grid-cols-2 gap-6">
                <div>
                  <label class="block mb-2">
                    Tên CLB *
                    <span class="text-red-500">*</span>
                  </label>
                  <input 
                    type="text"
                    v-model="form.name"
                    class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    placeholder="Chỗ cho thuê phòng đẹp 2"
                  />
                </div>
  
                <div>
                  <label class="block mb-2">
                    Lĩnh vực hoạt động *
                    <span class="text-red-500">*</span>
                  </label>
                  <select 
                    v-model="form.field"
                    class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  >
                    <option>Học thuật, Chuyên môn</option>
                  </select>
                </div>
  
                <div>
                  <label class="block mb-2">
                    Ngày thành lập *
                    <span class="text-red-500">*</span>
                  </label>
                  <input 
                    type="date"
                    v-model="form.foundedDate"
                    class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  />
                </div>
  
                <div>
                  <label class="block mb-2">
                    Số lượng thành viên *
                    <span class="text-red-500">*</span>
                  </label>
                  <input 
                    type="number"
                    v-model="form.memberCount"
                    class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  />
                </div>
              </div>
            </div>
  
            <!-- Description -->
            <div class="mb-8">
              <h2 class="text-xl text-blue-600 font-medium mb-6">Mô tả / Giới thiệu Câu Lạc Bộ</h2>
              <div>
                <label class="block mb-2">
                  Giới thiệu CLB *
                  <span class="text-red-500">*</span>
                </label>
                <textarea
                  v-model="form.description"
                  rows="4"
                  class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="Nhập mô tả hoạt động và giới thiệu về CLB"
                ></textarea>
              </div>
            </div>
  
            <!-- Contact Information -->
            <div class="mb-8">
              <h2 class="text-xl text-blue-600 font-medium mb-6">Thông tin liên hệ</h2>
              
              <div class="grid grid-cols-2 gap-6">
                <div>
                  <label class="block mb-2">
                    Email liên hệ *
                    <span class="text-red-500">*</span>
                  </label>
                  <input 
                    type="email"
                    v-model="form.email"
                    class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    placeholder="nguyengiakhanhqqq@gmail.com"
                  />
                </div>
  
                <div>
                  <label class="block mb-2">
                    Hotline *
                    <span class="text-red-500">*</span>
                  </label>
                  <input 
                    type="tel"
                    v-model="form.phone"
                    class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    placeholder="Nhập số Hotline"
                  />
                  <button type="button" class="text-blue-600 text-sm mt-2">+ Thêm số Hotline</button>
                </div>
  
                <div>
                  <label class="block mb-2">
                    Địa chỉ liên hệ *
                    <span class="text-red-500">*</span>
                  </label>
                  <input 
                    type="text"
                    v-model="form.address"
                    class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    placeholder="Nhập địa chỉ cụ thể"
                  />
                </div>
  
                <div>
                  <label class="block mb-2">
                    Tỉnh / Thành *
                    <span class="text-red-500">*</span>
                  </label>
                  <select 
                    v-model="form.city"
                    class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  >
                    <option>Chọn Tỉnh thành</option>
                  </select>
                </div>
              </div>
  
              <!-- Social Media -->
              <div class="mt-6">
                <h3 class="font-medium mb-4">Mạng xã hội</h3>
                
                <div class="space-y-4">
                  <div v-for="social in socials" :key="social.name" class="flex items-center gap-4">
                    <div class="w-32 flex items-center gap-2">
                      <img :src="social.icon" :alt="social.name" class="w-8 h-8" />
                      <span>{{ social.name }}</span>
                    </div>
                    <input 
                      type="text"
                      v-model="form.socials[social.id]"
                      class="flex-1 px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                      :placeholder="`Nhập link ${social.name}`"
                    />
                  </div>
                </div>
              </div>
            </div>
  
            <!-- Form Actions -->
            <div class="flex justify-between pt-6 border-t">
              <button 
                type="button"
                class="px-4 py-2 text-gray-600 hover:text-gray-800"
                @click="goToDashboard"
              >
                Về Dashboard
              </button>
              <button 
                type="submit"
                class="px-4 py-2 bg-gray-100 rounded-lg text-gray-600 hover:bg-gray-200"
              >
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
  import { 
    HomeIcon,
    UsersIcon,
    FolderIcon,
    ChevronLeftIcon,
    UploadIcon
  } from 'lucide-vue-next'
  
  const route = useRoute()
  const router = useRouter()
  
  const form = ref({
    name: '',
    field: '',
    foundedDate: '',
    memberCount: 0,
    description: '',
    email: '',
    phone: '',
    address: '',
    city: '',
    socials: {},
    logo: null,
    cover: null
  })
  
  const logoPreview = ref(null)
  const coverPreview = ref(null)
  const logoInput = ref(null)
  const coverInput = ref(null)
  
  const socials = [
    { id: 'facebook', name: 'Facebook', icon: 'https://th.bing.com/th/id/R.83e3cc297106767114f2c060f7f5fcbb?rik=FkFOcs3CThcCJQ&pid=ImgRaw&r=0' },
    { id: 'zalo', name: 'Zalo', icon: 'https://th.bing.com/th/id/OIP.-kImg-7dr-QEfCzb17cbEAHaHa?w=175&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7' },
  ]
  
  onMounted(async () => {
    try {
      // Get club ID from route params
      const clubId = route.params.id
      if (clubId) {
        const clubData = await ClubService.getClubById(clubId)
        form.value = {
          ...clubData,
          socials: clubData.socials || {}
        }
        if (clubData.logo) {
          logoPreview.value = clubData.logo
        }
        if (clubData.cover) {
          coverPreview.value = clubData.cover
        }
      }
    } catch (error) {
      console.error('Error fetching club data:', error)
      alert('Failed to load club information')
    }
  })
  
  const handleLogoUpload = (event) => {
    const file = event.target.files[0]
    if (file) {
      // Validate file type
      if (!file.type.startsWith('image/')) {
        alert('Please select an image file')
        return
      }
      
      // Validate file size (max 2MB)
      if (file.size > 2 * 1024 * 1024) {
        alert('Image size should not exceed 2MB')
        return
      }

      form.value.logo = file
      logoPreview.value = URL.createObjectURL(file)
    }
  }
  
  const handleCoverUpload = (event) => {
    const file = event.target.files[0]
    if (file) {
      // Validate file type
      if (!file.type.startsWith('image/')) {
        alert('Please select an image file')
        return
      }
      
      // Validate file size (max 5MB)
      if (file.size > 5 * 1024 * 1024) {
        alert('Image size should not exceed 5MB')
        return
      }

      form.value.cover = file
      coverPreview.value = URL.createObjectURL(file)
    }
  }
  
  const handleSubmit = async () => {
    try {
      const clubId = route.params.id
      
      // First update basic info
      await ClubService.updateClub(clubId, {
        name: form.value.name,
        field: form.value.field,
        foundedDate: form.value.foundedDate,
        memberCount: form.value.memberCount,
        description: form.value.description,
        email: form.value.email,
        phone: form.value.phone,
        address: form.value.address,
        city: form.value.city,
        socials: form.value.socials
      })

      // Then handle logo upload if changed
      if (form.value.logo && form.value.logo instanceof File) {
        const logoFormData = new FormData()
        logoFormData.append('logo', form.value.logo)
        await ClubService.uploadLogo(clubId, logoFormData)
      }

      // Then handle cover upload if changed
      if (form.value.cover && form.value.cover instanceof File) {
        const coverFormData = new FormData()
        coverFormData.append('cover', form.value.cover)
        await ClubService.uploadCover(clubId, coverFormData)
      }

      alert('Club information updated successfully!')
    } catch (error) {
      console.error('Error updating club:', error)
      alert('Failed to update club information. Please try again.')
    }
  }
  
  const goToDashboard = () => {
    router.push('/dashboard')
  }
  
  const triggerLogoUpload = () => {
    logoInput.value.click()
  }
  
  const triggerCoverUpload = () => {
    coverInput.value.click()
  }
  </script>

<style scoped>
/* Add any additional styles here */
</style>