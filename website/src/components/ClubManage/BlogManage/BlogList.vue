<template>
    <div class="flex flex-wrap gap-4 items-center justify-center p-4">
        <div v-for="blog in blogs" :key="blog.id" class="w-9/12 bg-white rounded-lg shadow">
            <!-- Header -->
            <div class="p-4 border-b flex items-center relative">
                <div class="flex items-center space-x-3">
                    <img :src="blog.image" alt="Movie Comparison" class="w-10 h-10 bg-gray-300 rounded-full" />
                    <div>
                        <h2 class="font-semibold text-gray-800">CLB Name</h2>
                        <p class="text-xs text-gray-500">12 tháng 12 lúc 18:54</p>
                    </div>
                </div>
                <button @click="toggleDropdown($event, blog.id)" class="p-2 ml-auto dropdown-trigger">
                    <MoreVerticalIcon class="w-5 h-5" />
                </button>

                <!-- Dropdown Menu -->
                <div v-if="openDropdownId === blog.id" ref="dropdownMenu"
                    class="absolute bg-white rounded-lg shadow-lg border border-gray-200 py-1 z-50 dropdown-menu"
                    :style="{ top: `${dropdownPosition.top}px`, left: `${dropdownPosition.left}px` }">
                    <button v-for="(option, index) in options" :key="index"
                        class="w-full px-4 py-2.5 flex items-center gap-3 hover:bg-gray-50 transition-colors"
                        :class="{ 'text-red-500 hover:text-red-600': option.danger }">
                        <component :is="option.icon" class="w-5 h-5" />
                        <span class="text-sm">{{ option.label }}</span>
                    </button>
                </div>
            </div>

            <!-- Content -->
            <div class="p-2">
                <p class="text-gray-800 mb-4">
                    {{ blog.title }}
                </p>
                <!-- Image -->
                <div class="rounded-lg overflow-hidden mb-4">
                    <img :src="blog.image" alt="Movie Comparison" class="w-full max-h-80 object-contain" />
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref } from 'vue';
import { MoreVerticalIcon } from 'lucide-vue-next';

const props = defineProps({
    blogs: {
        type: Array,
        required: true,
    },
    options: {
        type: Array,
        required: true,
    },
});

const openDropdownId = ref(null);
const dropdownPosition = ref({ top: 0, left: 0 });

const toggleDropdown = (event, blogId) => {
    if (openDropdownId.value === blogId) {
        openDropdownId.value = null;
    } else {
        openDropdownId.value = blogId;
        const rect = event.target.getBoundingClientRect();
        dropdownPosition.value = {
            top: rect.bottom - rect.top + 8,
            left: rect.right - rect.left + 450,
        };
    }
};
</script>
