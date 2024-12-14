<template>
    <h1> Dashboard</h1>
</template>

<script setup>
import { ref } from 'vue'
import {
    PlusIcon,
    SearchIcon,
    FilterIcon,
    UserIcon,
    PencilIcon,
    MessageSquareIcon,
    UsersIcon
} from 'lucide-vue-next'

const departments = ref([
    {
        name: 'Ban Truyền Thông',
        members: 15,
        icon: MessageSquareIcon
    },
    {
        name: 'Ban Đối ngoại',
        members: 15,
        icon: UsersIcon
    },
    {
        name: 'Ban Điều phối',
        members: 15,
        icon: UsersIcon
    },
    {
        name: 'Ban Đối nội',
        members: 15,
        icon: UsersIcon
    }
])

const members = ref([
    {
        id: 1,
        name: 'Nguyễn Thị Nhàn',
        role: 'Thành viên',
        department: 'Ban Truyền Thông',
        phone: '0943211427',
        email: 'nhan@zm.vn',
        status: 'Đang hoạt động',
        avatar: '/placeholder.svg?height=40&width=40'
    },
    {
        id: 2,
        name: 'Chú Cá',
        role: 'Trưởng ban',
        department: 'Ban Truyền Thông',
        phone: '0943211427',
        email: 'nhan@zm.vn',
        status: 'Đang hoạt động',
        avatar: '/placeholder.svg?height=40&width=40'
    },
])
</script>