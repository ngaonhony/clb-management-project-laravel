<template>
  <div class="relative inline-block">
     <!-- Slot cho button -->
     <button @click="toggleDropdown">
      <slot name="trigger">
        <span class="px-4 py-2 bg-gray-200 rounded-lg">Open</span>
      </slot>
    </button>

    <div
      v-if="isDropdownOpen"
      class="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg z-10">
      <ul>
        <li
          v-for="(item, index) in options"
          :key="index"
          @click="selectOption(item)"
          class="px-4 py-2 hover:bg-gray-100 flex items-center cursor-pointer text-black">
          <component
            :is="item.icon"
            class="w-5 h-5 text-black mr-3" />
          {{ item.label }}
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
import {
  User,
  Settings,
  LogOut,
  HelpCircle,
} from 'lucide-vue-next';

export default {
  props: {
    imageSrc: String,
    options: {
      type: Array,
      default: () => [
        { label: "Profile", icon: User },
        { label: "Settings", icon: Settings },
        { label: "Logout", icon: LogOut },
      ],
    },
  },
  data() {
    return {
      isDropdownOpen: false,
    };
  },
  methods: {
    toggleDropdown() {
      this.isDropdownOpen = !this.isDropdownOpen;
    },
    selectOption(item) {
      this.$emit("select", item);
      this.isDropdownOpen = false;
    },
  },
};
</script>
