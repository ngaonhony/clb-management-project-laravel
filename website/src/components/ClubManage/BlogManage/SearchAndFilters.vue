<template>
    <div class="pb-4 space-y-4">
        <div class="flex items-center space-x-4">
            <div class="flex-1 relative">
                <SearchIcon class="w-5 h-5 absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" />
                <input type="text" placeholder="Tìm kiếm Blog"
                    class="w-full pl-10 pr-4 py-2 rounded-lg border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>
            <div class="relative">
                <select
                    class="appearance-none px-4 py-2 pr-8 rounded-lg border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500">
                    <option>Tất cả</option>
                </select>
                <ChevronDownIcon
                    class="w-5 h-5 absolute right-2 top-1/2 transform -translate-y-1/2 text-gray-400 pointer-events-none" />
            </div>
            <button class="p-2 border rounded-lg">
                <ArrowUpDownIcon class="w-5 h-5" />
            </button>
            <button @click="$emit('openModal')" class="flex items-center space-x-2 px-4 py-2 bg-black text-white rounded-lg">
                <PlusIcon class="w-5 h-5" />
                <span>Tạo Blog</span>
            </button>
        </div>
    </div>
</template>

<script setup>
import { SearchIcon, ChevronDownIcon, ArrowUpDownIcon, PlusIcon } from 'lucide-vue-next';
</script>

<style scoped>
/* Add scoped styles here if needed */
</style>
