<template>
    <div class="min-h-screen bg-gray-50"> 
      <!-- Main Content -->
      <div class="ml-16">
        <!-- Header -->
        <div class="bg-white border-b px-8 py-4 flex justify-between items-center">
          <h1 class="text-xl font-medium">Dashboard</h1>
          <div class="w-8 h-8 bg-gray-200 rounded-full"></div>
        </div>
  
        <!-- Content -->
        <div class="p-8">
          <h2 class="text-2xl font-semibold mb-6">Chào mừng, Khánh Nguyên 👋</h2>
  
          <!-- Warning Banner -->
          <div class="bg-orange-50 border border-orange-200 rounded-lg p-4 mb-6">
            <div class="flex items-start">
              <AlertTriangleIcon class="w-5 h-5 text-orange-500 mt-0.5 mr-2" />
              <div>
                <p class="font-medium text-orange-800">Hồ sơ CLB còn thiếu (0/3 hoàn tất)</p>
                <p class="text-orange-700 text-sm">Hoàn thiện các bước cuối cùng bên dưới để Câu Lạc Bộ của bạn đi vào hoạt động</p>
              </div>
            </div>
          </div>
  
          <!-- Action Cards -->
          <div class="grid grid-cols-3 gap-6 mb-8">
            <div class="bg-green-50 rounded-lg p-6">
              <h3 class="font-medium mb-2">Bổ sung Thông tin</h3>
              <p class="text-sm text-gray-600 mb-4">Thông tin cơ bản của Câu Lạc Bộ</p>
              <router-link to="/clb/update-info-club">
              <button class="bg-black text-white px-4 py-2 rounded-lg text-sm">Bắt đầu</button></router-link>
            </div>
  
            <div class="bg-blue-50 rounded-lg p-6">
              <h3 class="font-medium mb-2">Tạo Trang đại diện</h3>
              <p class="text-sm text-gray-600 mb-4">Trang đại diện của CLB và công khai trang</p>
              <button class="bg-black text-white px-4 py-2 rounded-lg text-sm">Bắt đầu</button>
            </div>
  
            <div class="bg-purple-50 rounded-lg p-6">
              <h3 class="font-medium mb-2">Thêm Thành viên</h3>
              <p class="text-sm text-gray-600 mb-4">Tạo phòng ban để quản lý thông tin thành viên</p>
              <button class="bg-black text-white px-4 py-2 rounded-lg text-sm">Bắt đầu</button>
            </div>
          </div>
  
          <!-- Main Sections -->
          <div class="grid grid-cols-3 gap-6">
            <!-- Events Section -->
            <div class="col-span-2 bg-white border rounded-lg p-6">
              <div class="flex justify-between items-center mb-8">
                <h3 class="font-medium">Sự kiện</h3>
              </div>
              
              <div class="flex flex-col items-center justify-center py-12">
                <!-- <img src="/placeholder.svg?height=200&width=200" alt="No events" class="mb-4" /> -->
                <p class="font-medium mb-2">Chưa có sự kiện nào</p>
                <p class="text-sm text-gray-500 mb-4">Tạo sự kiện để thu hút các nhà tài trợ</p>
                <button class="flex items-center bg-black text-white px-4 py-2 rounded-lg text-sm">
                  <PlusIcon class="w-4 h-4 mr-2" />
                  Tạo Sự kiện
                </button>
              </div>
            </div>
  
            <!-- Members Section -->
            <div class="bg-white border rounded-lg p-6">
              <div class="flex justify-between items-center mb-6">
                <h3 class="font-medium">Thành viên</h3>
                <button class="p-1 hover:bg-gray-100 rounded">
                  <PlusIcon class="w-5 h-5" />
                </button>
              </div>
  
              <div class="flex items-center space-x-3">
                <div class="w-8 h-8 bg-gray-200 rounded-full"></div>
                <div>
                  <p class="text-sm font-medium">ngaonhony</p>
                  <p class="text-xs text-gray-500">Chỗ cho thuê phòng đẹp 2</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { 
    HomeIcon,
    UsersIcon,
    FolderIcon,
    AlertTriangleIcon,
    PlusIcon
  } from 'lucide-vue-next'
  </script>
  
  <style scoped>
  .grid {
    display: grid;
  }
  </style>