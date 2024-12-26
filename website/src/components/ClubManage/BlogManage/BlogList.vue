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
                <DropDownMenu :options="dropdownOptions" @select="handleSelect">
                    <template #trigger>
                        <button class="p-2 ml-auto dropdown-trigger">
                            <MoreVerticalIcon class="w-5 h-5" />
                        </button>
                    </template>
                </DropDownMenu>
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

<script>
import { MoreVerticalIcon, PenSquare,Trash2 } from 'lucide-vue-next';
import DropDownMenu from '../../DropDownMenu.vue';
import Image1 from '../../../assets/1.webp';
import Image2 from '../../../assets/2.webp';
import Image3 from '../../../assets/3.webp';
import Image4 from '../../../assets/4.webp';
import Image5 from '../../../assets/5.webp';


export default {
    components: {
    DropDownMenu,
    MoreVerticalIcon
    },
    data() {
    return {
      isModalOpen: false,
      openDropdownId: null,
      blogs: [
        {
        id: 1,
        image: Image1,
        title: 'Lorem eget venenatis vestibulum odio egestas bibendum urna...',
        },
        {
        id: 2,
        image: Image2,
        title: 'Elementum dignissim tristique pellentesque eleifend posuere.',
        },
        {
        id: 3,
        image: Image3,
        title: 'Porta aliquet sed viverra fringilla.',
        },
        {
        id: 4,
        image: Image4,
        title: 'Non vitae tristique in sed aenean consectetur.',
        },
        {
        id: 5,
        image: Image5,
        title: 'Massa leo scelerisque bibendum eu commodo at vestibulum.',
        }
      ],
      dropdownOptions: [
        { label: "Chỉnh sửa Blog", icon: PenSquare },
        { label: "Xóa Blog", icon: Trash2,  danger: true},
      ]
    };
  },
}

</script>
