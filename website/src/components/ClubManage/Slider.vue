<template>
    <div class="flex items-center justify-center ">
      <div class="w-full max-w-7xl relative">
        <!-- Main slider container -->
        <div class="relative flex items-center justify-center gap-4 py-8">
          <!-- Navigation Arrows -->
          <button 
            @click="prevSlide" 
            class="absolute left-0 z-10 w-14 h-14 flex items-center justify-center bg-white/20 rounded-full hover:bg-white hover:text-black transition-all"
            aria-label="Previous slide"
          >
            <ChevronLeftIcon class="w-8 h-8" />
          </button>
  
          <!-- Slides -->
          <div class="flex items-center justify-center gap-4">
            <!-- Left Slide -->
            <div class="w-64 h-48 relative opacity-70 transition-all duration-500">
              <img 
                :src="slides[getPrevIndex()].image" 
                alt="Previous slide"
                class="w-full h-full object-cover rounded-lg"
              />
            </div>
  
            <!-- Center Slide (Active) -->
            <div class="w-96 h-72 relative z-10 transition-all duration-500">
              <img 
                :src="slides[currentIndex].image" 
                alt="Current slide"
                class="w-full h-full object-cover rounded-lg shadow-xl"
              />
              <div class="absolute bottom-0 left-0 right-0 bg-black bg-opacity-70 p-4 rounded-b-lg">
                <h3 class="text-[#FFA500] text-center font-medium">{{ slides[currentIndex].title }}</h3>
                <p class="text-white text-center text-sm">{{ slides[currentIndex].description }}</p>
              </div>
            </div>
  
            <!-- Right Slide -->
            <div class="w-64 h-48 relative opacity-70 transition-all duration-500">
              <img 
                :src="slides[getNextIndex()].image" 
                alt="Next slide"
                class="w-full h-full object-cover rounded-lg"
              />
            </div>
          </div>
  
          <button 
            @click="nextSlide" 
            class="absolute right-0 z-10 w-14 h-14 flex items-center justify-center bg-white/20 rounded-full hover:bg-white hover:text-black transition-all"
            aria-label="Next slide"
          >
            <ChevronRightIcon class="w-8 h-8" />
          </button>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref } from 'vue'
  import { ChevronLeftIcon, ChevronRightIcon } from 'lucide-vue-next'
  import Image1 from '../../assets/1.webp';
  import Image2 from '../../assets/2.webp';
  import Image3 from '../../assets/3.webp';
  import Image4 from '../../assets/4.webp';
  import Image5 from '../../assets/5.webp';

  
  const slides = ref([
    {
      image: Image1,
      title: 'ABC',
      description: 'Chu Nhiem CLB'
    },
    {
      image: Image2,
      title: 'DR. SMITH',
      description: 'Pho Chu Nhiem CLB'
    },
    {
      image: Image3,
      title: 'DR. JOHNSON',
      description: 'Truong Ban Doi Ngoai'
    },
  ])
  
  const currentIndex = ref(0)
  
  const nextSlide = () => {
    currentIndex.value = (currentIndex.value + 1) % slides.value.length
  }
  
  const prevSlide = () => {
    currentIndex.value = currentIndex.value === 0 
      ? slides.value.length - 1 
      : currentIndex.value - 1
  }
  
  const getNextIndex = () => {
    return (currentIndex.value + 1) % slides.value.length
  }
  
  const getPrevIndex = () => {
    return currentIndex.value === 0 
      ? slides.value.length - 1 
      : currentIndex.value - 1
  }
  </script>
  
  <style scoped>
  /* Add any additional custom styles here if needed */
  </style>