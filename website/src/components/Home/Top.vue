<template>
    <div class="max-w-6xl mx-auto px-4 py-8">
        <!-- Header -->
        <div class="text-center mb-12">
            <h1 class="text-3xl md:text-4xl font-bold mb-2">
                Khám phá 369 Câu Lạc Bộ
            </h1>
            <h2 class="text-2xl md:text-3xl font-bold">
                phù hợp với bạn!
            </h2>
        </div>

        <!-- Category Icons -->
        <div class="grid grid-cols-4 md:grid-cols-8 gap-4 mb-8">
            <div
                v-for="(category, index) in categories"
                :key="index"
                class="flex flex-col items-center gap-2 group"
            >
                <div
                class="w-16 h-16 rounded-full border-2 flex items-center justify-center transition-colors duration-300 group-hover:bg-orange-100 group-hover:border-orange-500"
                style="color: #CE536B;"
                >
                <component
                    :is="category.icon"
                    class="w-6 h-6 text-gray-600 group-hover:text-orange-500 transition-colors duration-300"
                />
                </div>
                <span class="text-xs text-center group-hover:text-orange-500 transition-colors duration-300">
                {{ category.name }}
                </span>
            </div>
            </div>


        <!-- Search and Filter -->
        <div class="flex gap-4 mb-8">
            <div class="relative flex-1">
                <SearchIcon class="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
                <input type="text" placeholder="Tìm kiếm Câu Lạc Bộ"
                    class="w-full pl-10 pr-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500">
            </div>
            <div class="relative">
                <select
                    class="appearance-none bg-white border rounded-lg px-4 py-2 pr-8 focus:outline-none focus:ring-2 focus:ring-orange-500">
                    <option>Sắp xếp theo</option>
                    <option>Mới nhất</option>
                    <option>Phổ biến</option>
                </select>
                <ChevronDownIcon class="absolute right-2 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
            </div>
        </div>
       
    </div>
</template>

<script setup>
import {
    SearchIcon,
    ChevronDownIcon,
    BookOpenIcon,
    CloudIcon,
    HandshakeIcon,
    GlobeIcon,
    GamepadIcon,
    Palette,
    Megaphone,
    Dumbbell,
} from 'lucide-vue-next'

const categories = [
    { name: 'Học thuật, Chuyên môn', icon: BookOpenIcon },
    { name: 'Nghệ thuật, Sáng tạo', icon: Palette},
    { name: 'Truyền thông, Báo trí', icon: Megaphone },
    { name: 'Thể thao, Sức khỏe', icon: Dumbbell },
    { name: 'Kỹ năng, Giá trị', icon: CloudIcon },
    { name: 'Tình nguyện, Cộng đồng', icon: HandshakeIcon },
    { name: 'Ngoại ngữ, Văn hóa', icon: GlobeIcon },
    { name: 'Thể thao, Giải trí', icon: GamepadIcon },
];
</script>