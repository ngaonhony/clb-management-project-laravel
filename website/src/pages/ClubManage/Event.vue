<template>
  <div class="p-6 bg-gray-50 min-h-screen">
    <!-- Header -->
    <div class="flex justify-between items-center mb-8">
      <h1 class="text-xl font-medium">Quản lý Sự kiện</h1>
      <div class="flex gap-3">
        <button class="p-2">
          <MessageCircleIcon class="w-6 h-6" />
        </button>
        <button class="p-2">
          <BellIcon class="w-6 h-6" />
        </button>
        <div class="w-10 h-10 rounded-full bg-yellow-400 flex items-center justify-center">
          <UserIcon class="w-6 h-6 text-white" />
        </div>
      </div>
    </div>

    <!-- Search and Filters -->
    <SearchAndFilters @openModal="openModal" />

    <!-- Event List -->
    <div class="bg-white rounded-lg p-6">
      <table class="w-full border-collapse border border-gray-200">
        <thead class="bg-gray-50">
          <tr>
            <th class="border border-gray-300 text-left py-3 px-4">Event</th>
            <th class="border border-gray-300 text-left py-3 px-4">Thời gian</th>
            <th class="border border-gray-300 text-left py-3 px-4">Trạng thái</th>
            <th class="border border-gray-300 py-3 px-4"></th>
          </tr>
        </thead>
        <tbody class="divide-y">
          <tr v-for="event in events" :key="event.id" class="hover:bg-gray-50">
            <!-- Event -->
            <td class="border border-gray-300 py-4 px-4">
              <div class="flex items-center space-x-3" v-for="(image, index) in event.background_images" :key="index">
                <img :src="image.image_url" class="w-20 h-18 object-cover rounded" />
                <div>
                  <h3 class="font-medium">{{ event.name }}</h3>
                  <p class="text-sm text-gray-500">{{ event.location }}</p>
                </div>
              </div>
            </td>
            <!-- Time -->
            <td class="border border-gray-300 py-4 px-4">
              <div>
                <p class="font-medium">{{ event.start_date }}</p>
                <p class="text-sm text-gray-500">{{ event.end_date }}</p>
              </div>
            </td>
            <!-- Status -->
            <td class="border border-gray-300 py-4 px-4">
              <span :class="getStatusClass(event.status)">
                {{ event.status }}
              </span>
            </td>
            <!-- Actions -->
            <td class="border border-gray-300 py-4 px-2 relative">
              <DropDownMenu :options="dropdownOptions" @select="(option) => handleSelect(option, event.id)">
                <template #trigger>
                  <button class="p-2 dropdown-trigger">
                    <MoreVerticalIcon class="w-5 h-5" />
                  </button>
                </template>
              </DropDownMenu>

            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <!-- Modals -->
    <ModalCreate :isOpen="isModalOpen" @close="closeModal" @eventCreated="handleEventCreated" />
    <ModalUpdate 
      :isOpen="isUpdateModalOpen" 
      :eventData="selectedEvent" 
      @close="closeUpdateModal" 
      @eventUpdated="handleEventUpdated" 
    />
    
    <!-- Error Alert -->
    <div v-if="error" class="fixed bottom-4 right-4 bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded">
        {{ error }}
        <button @click="error = null" class="ml-2 font-bold">&times;</button>
    </div>
  </div>
</template>

<script>
import ModalCreate from '../../components/ClubManage/EventManage/ModalCreate.vue';
import ModalUpdate from '../../components/ClubManage/EventManage/ModalUpdate.vue';
import SearchAndFilters from '../../components/ClubManage/EventManage/SearchAndFilters.vue';
import DropDownMenu from "../../components/DropDownMenu.vue";

import {
  MoreVerticalIcon,
  Eye,
  Users,
  PenSquare,
  Trash2
} from 'lucide-vue-next';

import { useEventStore } from '../../stores/eventStore';
import EventService from "../../services/event"

export default {
  name: "HeaderComponent",
  components: {
    ModalCreate,
    ModalUpdate,
    SearchAndFilters,
    DropDownMenu,
    MoreVerticalIcon,
  },
  data() {
    return {
      isModalOpen: false,
      isUpdateModalOpen: false,
      selectedEvent: null,
      openDropdownId: null,
      events: [],
      error: null,
      dropdownOptions: [
        { label: "Xem Sự kiện", icon: Eye, action: 'view' },
        { label: "Danh sách đăng ký", icon: Users, action: 'list' },
        { label: "Chỉnh sửa sự kiện", icon: PenSquare, action: 'edit' },
        { label: "Xóa sự kiện", icon: Trash2, danger: true, action: 'delete' }
      ]
    };
  },
  computed: {
    clubId() {
      return this.$route.params.id;
    }
  },
  methods: {
    openModal() {
      this.isModalOpen = true;
    },
    closeModal() {
      this.isModalOpen = false;
    },
    getStatusClass(status) {
      const classes = {
        'Đang diễn ra': 'px-3 py-1 rounded-full bg-green-100 text-green-800 text-sm',
        'Sắp diễn ra': 'px-3 py-1 rounded-full bg-orange-100 text-orange-800 text-sm',
        'Bản nháp': 'px-3 py-1 rounded-full bg-purple-100 text-purple-800 text-sm',
        'Đã kết thúc': 'px-3 py-1 rounded-full bg-gray-100 text-gray-800 text-sm'
      };
      return classes[status] || '';
    },
    openUpdateModal(event) {
      this.selectedEvent = { ...event };
      this.isUpdateModalOpen = true;
    },
    closeUpdateModal() {
      this.isUpdateModalOpen = false;
      this.selectedEvent = null;
    },
    handleSelect(option, eventId) {
      console.log("Selected:", option.label, "for event ID:", eventId);

      switch (option.action) {
        case 'view':
          this.$router.push(`/event/${eventId}`);
          break;
        case 'list':
          localStorage.setItem('currentClubId', this.clubId);
          this.$router.push(`/event/${eventId}/users`);
          break;
        case 'edit':
          const eventToEdit = this.events.find(e => e.id === eventId);
          if (eventToEdit) {
            this.openUpdateModal(eventToEdit);
          }
          break;
        case 'delete':
          this.handleDeleteEvent(eventId);
          break;
        default:
          console.log("No action defined for this option");
      }
    },
    handleClickOutside(event) {
      if (this.openDropdownId !== null &&
        !event.target.closest('.dropdown-trigger') &&
        !event.target.closest('.dropdown-menu')) {
        this.openDropdownId = null;
      }
    },

    async handleEventCreated(newEvent) {
      try {
        await this.fetchClubEvents(this.clubId);
      } catch (error) {
        this.error = 'Không thể cập nhật danh sách sự kiện';
        console.error('Error refreshing events:', error);
      }
    },

    async fetchClubEvents(clubId) {
      const eventStore = useEventStore();
      try {
        this.events = await eventStore.fetchClubEvents(clubId);
        this.error = null;
      } catch (error) {
        this.error = 'Không thể tải danh sách sự kiện';
        console.error('Failed to fetch club events:', error);
      }
    },

    async handleEventUpdated(updatedEvent) {
      try {
        await this.fetchClubEvents(this.clubId);
      } catch (error) {
        this.error = 'Không thể cập nhật danh sách sự kiện';
        console.error('Error refreshing events:', error);
      }
    },

    async handleDeleteEvent(eventId) {
      try {
        if (!confirm('Bạn có chắc chắn muốn xóa sự kiện này không?')) {
          return;
        }

        await EventService.deleteEvent(eventId);
        await this.fetchClubEvents(this.clubId);
        
        this.error = null;
        alert('Xóa sự kiện thành công!');
      } catch (error) {
        this.error = 'Lỗi khi xóa sự kiện: ' + error.message;
        console.error('Error deleting event:', error);
      }
    },

  },

  mounted() {
    document.addEventListener('click', this.handleClickOutside);
    this.fetchClubEvents(this.clubId);
  },

  beforeUnmount() {
    document.removeEventListener('click', this.handleClickOutside);
  }
};
</script>


<style scoped></style>