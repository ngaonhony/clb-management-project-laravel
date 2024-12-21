<template>
    <!-- Blog List -->
    <BlogList :blogs="blogs" :options="options" />

</template>

<script setup>

import BlogList from '../components/ClubManage/BlogManage/BlogList.vue';
import Image1 from '../assets/1.webp';
import Image2 from '../assets/2.webp';
import Image3 from '../assets/3.webp';
import Image4 from '../assets/4.webp';
import Image5 from '../assets/5.webp';

const blogs = [
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
];

</script>