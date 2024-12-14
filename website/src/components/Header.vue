<template>
    <header class="text-white shadow-md" style="background-color: #002244;">
        <div class="container mx-auto flex justify-between items-center py-3 ">
            <!-- Logo -->
            <div class="flex items-center">
                <img src="../assets/vaa.svg" alt="Logo" class="h-10 mr-3" />
                <div>
                    <h1 class="font-bold text-lg">HỌC VIỆN HÀNG KHÔNG VIỆT NAM</h1>
                    <p class="text-sm font-light">VIETNAM AVIATION ACADEMY</p>
                </div>
            </div>

            <!-- Navigation -->
            <nav class="flex items-center space-x-8">
                <div class="relative group">
                    <button class="hover:text-gray-300 flex items-center">
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
                <div class="relative group">
                    <button class="hover:text-gray-300 flex items-center">
                        Nhà tài trợ
                        <svg class="w-4 h-4 ml-1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
                            fill="currentColor">
                            <path d="M12 16l-6-6h12l-6 6z" />
                        </svg>
                    </button>
                    <!-- Dropdown -->
                    <div
                        class="absolute left-0 mt-2 bg-white text-black shadow-md rounded hidden group-hover:block w-40">
                        <ul>
                            <li class="hover:bg-gray-100 px-4 py-2"><a href="#">Sponsor 1</a></li>
                            <li class="hover:bg-gray-100 px-4 py-2"><a href="#">Sponsor 2</a></li>
                        </ul>
                    </div>
                </div>
                <a href="#" class="hover:text-gray-300">Sự kiện</a>
                <a href="#" class="hover:text-gray-300">Bài viết</a>
            </nav>

            <!-- User Actions -->
            <div class="flex items-center space-x-4">
                <button class="flex items-center bg-white text-blue-900 px-4 py-2 rounded hover:bg-gray-200">
                    Quản lý CLB
                </button>
                <button>
                    <svg class="w-6 h-6 text-white hover:text-gray-300" xmlns="http://www.w3.org/2000/svg"
                        viewBox="0 0 24 24" fill="currentColor">
                        <path
                            d="M12 22c5.523 0 10-4.477 10-10S17.523 2 12 2 2 6.477 2 12s4.477 10 10 10zm-1-7h2v2h-2v-2zm0-8h2v6h-2V7z" />
                    </svg>
                </button>
                <button>
                    <svg class="w-8 h-8 text-white hover:text-gray-300" xmlns="http://www.w3.org/2000/svg"
                        viewBox="0 0 24 24" fill="currentColor">
                        <circle cx="12" cy="12" r="10" />
                        <path d="M12 14a3 3 0 110-6 3 3 0 010 6z" />
                    </svg>
                </button>
            </div>
        </div>
    </header>
</template>

<script>
export default {
    name: "HeaderComponent",
};
</script>
