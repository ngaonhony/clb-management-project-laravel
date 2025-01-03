<template>
  <div class="p-6 bg-gray-50 min-h-screen">
    <!-- Header -->
    <div class="flex justify-between items-center mb-8">
      <h1 class="text-xl font-medium">Quản lý Blog</h1>
      <div class="flex gap-3">
        <button class="p-2">
          <MessageCircleIcon class="w-6 h-6" />
        </button>
        <button class="p-2">
          <BellIcon class="w-6 h-6" />
        </button>
        <div
          class="w-10 h-10 rounded-full bg-yellow-400 flex items-center justify-center"
        >
          <UserIcon class="w-6 h-6 text-white" />
        </div>
      </div>
    </div>

    <!-- Search and Filters -->
    <SearchAndFilters @openModal="openModal" />

    <!-- Blog List -->
    <BlogList />
    <!-- Modal -->
    <ModalCreate :isOpen="isModalOpen" @close="closeModal" />
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from "vue";
import ModalCreate from "../../components/ClubManage/BlogManage/ModalCreate.vue";
import BlogList from "../../components/ClubManage/BlogManage/BlogList.vue";
import SearchAndFilters from "../../components/ClubManage/BlogManage/SearchAndFilters.vue";

import { MessageCircleIcon, BellIcon, UserIcon } from "lucide-vue-next";

const isModalOpen = ref(false);
const openModal = () => (isModalOpen.value = true);
const closeModal = () => (isModalOpen.value = false);
</script>

<style scoped>
/* Add any scoped styles here if needed */
</style>
