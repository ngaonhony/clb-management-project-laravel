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
                  <tr v-for="event in eventStore.events" :key="event.id" class="hover:bg-gray-50">
                      <!-- Event -->
                      <td class="border border-gray-300 py-4 px-4">
                          <div class="flex items-center space-x-3">
                              <img :src="event.background_images[0]?.image_url" alt="Helloworld" class="w-20 h-18 object-cover rounded" />
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
                        <DropDownMenu 
                          :options="dropdownOptions" 
                          @select="(option) => handleSelect(option, event.id, event)">                              <template #trigger>
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
      <!-- Modal -->
      <ModalCreate :isOpen="isModalOpen" @close="closeModal" @submit="submitEvent" />
      <ModalEdit
        :isOpen="isEditModalOpen"
        :eventData="selectedEvent"
        @close="closeEditModal"
        @submit="handleEditSubmit"
      />
  </div>
</template>

<script>
import { onMounted } from 'vue';
import ModalCreate from '../../components/ClubManage/EventManage/ModalCreate.vue';
import ModalEdit from '../../components/ClubManage/EventManage/ModalEdit.vue';
import SearchAndFilters from '../../components/ClubManage/EventManage/SearchAndFilters.vue';
import DropDownMenu from "../../components/DropDownMenu.vue";

import {
  MoreVerticalIcon,
  MessageCircleIcon,
  BellIcon,
  UserIcon,
  XIcon,
  UploadIcon,
  Eye,
  Users,
  PenSquare,
  Trash2
} from 'lucide-vue-next';

import { useCLBStore } from '../../stores/clubStore';
import { useEventStore } from '../../stores/eventStore';
import { createEvent, updateEvent, deleteEvent } from '../../services/event';

export default {
name: "HeaderComponent",
components: {
  ModalCreate,
  ModalEdit,
  SearchAndFilters,
  DropDownMenu,
  MoreVerticalIcon,
  MessageCircleIcon, 
  BellIcon, 
  UserIcon,
  XIcon, 
  UploadIcon,
},
setup() {
  const eventStore = useEventStore();
  const clbStore = useCLBStore();

  onMounted(async () => {
    await eventStore.fetchEventClb(clbStore.currentClubId);
  });

  return {
    eventStore,
  };
},
data() {
  return {
    isModalOpen: false,
    isEditModalOpen: false,
    selectedEvent: null,
    openDropdownId: null,
   dropdownOptions: [
    { label: "Xem Sự kiện", icon: Eye, action: 'view' },
    { label: "Danh sách đăng ký", icon: Users, action: 'list' },
    { label: "Chỉnh sửa sự kiện", icon: PenSquare, action: 'edit' },
    { label: "Xóa sự kiện", icon: Trash2, danger: true, action: 'delete' }
  ]
  };
},
methods: {
  async submitEvent(eventData) {
      try {
        const payload = {
          ...eventData,
          club_id: 1, 
          category_id: 1,
          end_date: '2026-07-05',
        };
        const response = await createEvent(payload);
        console.log('Event created successfully:', response);

        await this.eventStore.fetchEventClb(clbStore.currentClubId);

        this.closeModal();
      } catch (error) {
        console.error('Error creating event:', error);
      }
    },

    async handleEditSubmit(updatedEvent) {
      try {
        const response = await updateEvent(updatedEvent.id, updatedEvent);
        console.log('Event updated successfully:', response);
        await this.eventStore.fetchEventClb(this.clbStore.currentClubId);
      } catch (error) {
        console.error('Error updating event:', error);
      }
    },
  
    async handleDeleteEvent(eventId) {
      try {
        const confirmDelete = confirm("Bạn có chắc chắn muốn xóa sự kiện này?");
        if (!confirmDelete) return;

        console.log("Attempting to delete event with ID:", eventId);
        const response = await deleteEvent(eventId);
        console.log("Delete response:", response);

        alert("Xóa sự kiện thành công!");
        await this.eventStore.fetchEventClb(this.clbStore.currentClubId);
      } catch (error) {
        console.error("Lỗi khi xóa sự kiện:", error);
        alert("Xóa sự kiện thất bại: " + (error.message || error));
      }
    },

  openModal() {
    this.isModalOpen = true;
  },
  closeModal() {
    this.isModalOpen = false;
  },

  openEditModal(event) {
    this.selectedEvent = event || { // Gán giá trị mặc định nếu event là null}}
      name: '',
      location: '',
      category: '',
      start_date: '',
      max_participants: '',
      background_images: [],
    };
    this.isEditModalOpen = true;
  },

  closeEditModal() {
    this.isEditModalOpen = false;
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
  handleSelect(option, eventId, event) {
      console.log("Selected:", option.label, "for event ID:", eventId);
      
      switch(option.action) {
        case 'view':
          // Navigate to event detail page
          this.$router.push(`/event/${eventId}`);
          break;
        case 'list':
          // Navigate to registration list page
          this.$router.push(`/event/${eventId}/registrations`);
          break;
        case 'edit':
          // Open edit modal
          this.openEditModal(event);
          break;
        case 'delete':
          // Handle delete action
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
  }
},
mounted() {
  document.addEventListener('click', this.handleClickOutside);
},
beforeUnmount() {
  document.removeEventListener('click', this.handleClickOutside);
}
};
</script>

<style scoped></style>