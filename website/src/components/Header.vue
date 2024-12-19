<template>
    <header class="text-white shadow-md bg-white">
        <div class="container mx-auto flex justify-between items-center py-3 ">
            <!-- Logo -->
        <router-link to="/">
            <div class="flex items-center">
                <img src="../assets/vaa.svg" alt="Logo" class="h-10 mr-3" />
                <div>
                    <h1 class="font-bold text-lg" style="color: #B3995D">HỌC VIỆN HÀNG KHÔNG VIỆT NAM</h1>
                    <p class="text-sm font-light" style="color: #B3995D">VIETNAM AVIATION ACADEMY</p>
                </div>
            </div>
        </router-link>

            <!-- Navigation -->
            <nav class="flex items-center space-x-8">
                <div class="relative group">
                    <button class="hover:text-gray-300 flex items-center text-black">
                        Câu lạc bộ
                        <svg class="w-4 h-4 ml-1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
                            fill="currentColor">
                            <path d="M12 16l-6-6h12l-6 6z" />
                        </svg>
                    </button>
                    <!-- Dropdown -->
                    <div
                        class="absolute left-0 mt-2 bg-white text-black shadow-md rounded hidden group-hover:block w-40">
                        <ul>
                            <li class="hover:bg-gray-100 px-4 py-2"><a href="#">CLB 1</a></li>
                            <li class="hover:bg-gray-100 px-4 py-2"><a href="#">CLB 2</a></li>
                        </ul>
                    </div>
                </div>
                
                <router-link to="/event" class="hover:text-gray-300 text-black">Sự kiện</router-link>
                <router-link to="/blog" class="hover:text-gray-300 text-black">Bài viết</router-link>
            </nav>

            <!-- User Actions -->
            <div class="flex items-center space-x-4">
                <router-link to="/quan-ly-clb">
                    <button
                        class="flex items-center bg-white border-solid border-2 px-4 py-2 rounded hover:bg-gray-200 text-black	">
                        Quản lý CLB
                    </button>
                </router-link>
                <button>
                    <Bell class="w-6 h-6 text-black hover:text-gray-300" />
                </button>
                <button>
                    <img :src="Image1" alt="Button Icon" class="w-8 h-8 hover:opacity-75 rounded-full" />
                </button>
            </div>
        </div>
    </header>
</template>

<script>
import Image1 from '../assets/1.webp';
import { computed } from 'vue';
import { useRoute } from 'vue-router';
import {Bell} from 'lucide-vue-next';
export default {
    name: "HeaderComponent",
    components: {
        Bell,
    },
    data() {
        return {
            Image1,
        };
    },
};

const route = useRoute();

const currentRoute = computed(() => route.name);

</script>
