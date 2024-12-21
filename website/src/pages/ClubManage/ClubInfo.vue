<template>
    <div class="min-h-screen bg-gray-50">
      <!-- Left Sidebar -->
      <!-- <div class="fixed left-0 top-0 bottom-0 w-16 bg-white border-r flex flex-col items-center py-4">
        <div class="w-8 h-8 bg-red-500 rounded-lg mb-8"></div>
        <div class="space-y-4">
          <HomeIcon class="w-6 h-6 text-gray-400" />
          <UsersIcon class="w-6 h-6 text-gray-400" />
          <FolderIcon class="w-6 h-6 text-gray-400" />
        </div>
      </div> -->
  
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
                    Logo Câu Lạc Bộ *
                    <span class="text-red-500">*</span>
                  </label>
                  <div class="border-2 border-dashed border-gray-300 rounded-lg p-4 text-center">
                    <UploadIcon class="w-8 h-8 mx-auto mb-2 text-gray-400" />
                    <p class="text-sm text-gray-500">Tải ảnh lên</p>
                  </div>
                  <p class="text-xs text-gray-500 mt-1">* Khuyến khích sử dụng ảnh 100x100px để hiển thị tốt nhất.</p>
                </div>
                
                <div>
                  <label class="block mb-2">
                    Ảnh bìa Câu Lạc Bộ *
                    <span class="text-red-500">*</span>
                  </label>
                  <div class="border-2 border-dashed border-gray-300 rounded-lg p-4 text-center">
                    <UploadIcon class="w-8 h-8 mx-auto mb-2 text-gray-400" />
                    <p class="text-sm text-gray-500">Tải ảnh lên</p>
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
  import { ref } from 'vue'
  import { 
    HomeIcon,
    UsersIcon,
    FolderIcon,
    ChevronLeftIcon,
    UploadIcon
  } from 'lucide-vue-next'
  
  const form = ref({
    name: 'Chỗ cho thuê phòng đẹp 2',
    field: 'Học thuật, Chuyên môn',
    foundedDate: '',
    memberCount: 0,
    description: '',
    email: 'nguyengiakhanhqqq@gmail.com',
    phone: '',
    address: '',
    city: '',
    socials: {}
  })
  
  const socials = [
    { id: 'facebook', name: 'Facebook', icon: 'https://th.bing.com/th/id/R.83e3cc297106767114f2c060f7f5fcbb?rik=FkFOcs3CThcCJQ&pid=ImgRaw&r=0' },
    { id: 'zalo', name: 'Zalo', icon: 'https://th.bing.com/th/id/OIP.-kImg-7dr-QEfCzb17cbEAHaHa?w=175&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7' },
  ]
  
  const handleSubmit = () => {
    console.log('Form submitted:', form.value)
  }
  
  const goToDashboard = () => {
    console.log('Navigating to dashboard')
  }
  </script>