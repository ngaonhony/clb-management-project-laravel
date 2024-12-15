<template>
  <v-container fluid class="pa-0">
    <v-card class="elevation-2">
      <v-toolbar color="primary" dark>
        <v-toolbar-title>Quản Lý Phản Hồi</v-toolbar-title>
        <v-spacer></v-spacer>
      </v-toolbar>

      <v-card-text>
        <v-alert
          v-if="notification.message"
          :type="notification.type"
          :text="notification.message"
          class="mb-4"
          closable
        ></v-alert>

        <v-row class="mb-4">
          <v-col cols="12" sm="4">
            <v-btn color="primary" @click="openAddDialog">
              Thêm Phản Hồi
            </v-btn>
          </v-col>
          <v-col cols="12" sm="8">
            <v-text-field
              v-model="search"
              label="Tìm kiếm"
              prepend-icon="mdi-magnify"
              single-line
              hide-details
              @input="applyFilter"
            ></v-text-field>
          </v-col>
        </v-row>

        <v-data-table
          :headers="headers"
          :items="filteredFeedbacks"
          :items-per-page="itemsPerPage"
          :page.sync="page"
          class="elevation-1"
        >
          <template v-slot:item.index="{ item }">
            {{ feedbacks.indexOf(item) + 1 }}
          </template>
          <template v-slot:item.content="{ item }">
            {{ item.content }}
          </template>
          <template v-slot:item.actions="{ item }">
            <v-btn small color="primary" class="mr-2" @click="editFeedback(item)">
              Sửa
            </v-btn>
            <v-btn small color="error" @click="confirmDelete(item)">
              Xóa
            </v-btn>
          </template>
        </v-data-table>
      </v-card-text>
    </v-card>

    <!-- Add/Edit Feedback Dialog -->
    <v-dialog v-model="dialog" max-width="500px">
      <v-card>
        <v-card-title>
          <span class="text-h5">{{ formTitle }}</span>
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-row>
              <v-col cols="12">
                <v-textarea v-model="editedItem.content" label="Nội Dung Phản Hồi" required></v-textarea>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" text @click="closeDialog">Hủy</v-btn>
          <v-btn color="blue darken-1" text @click="saveFeedback">Lưu</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Delete Confirmation Dialog -->
    <v-dialog v-model="deleteDialog" max-width="400px">
      <v-card>
        <v-card-title class="text-h5">Xác nhận xóa phản hồi</v-card-title>
        <v-card-text>Bạn có chắc chắn muốn xóa phản hồi này không?</v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" text @click="closeDeleteDialog">Hủy</v-btn>
          <v-btn color="red darken-1" text @click="deleteFeedback">Xóa</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';

const search = ref('');
const feedbacks = ref([
  { id: 1, content: 'Phản hồi đầu tiên' },
  { id: 2, content: 'Phản hồi thứ hai' },
  { id: 3, content: 'Phản hồi thứ ba' },
]);

const notification = ref({ message: '', type: 'info' });
const itemsPerPage = 5;
const page = ref(1);
const dialog = ref(false);
const deleteDialog = ref(false);
const editedIndex = ref(-1);
const editedItem = ref({ id: null, content: '' });
const defaultItem = { id: null, content: '' };

const headers = [
  { title: 'STT', align: 'center', sortable: false, value: 'index' },
  { title: 'Nội Dung', align: 'start', sortable: false, value: 'content' },
  { title: 'Hành Động', align: 'center', sortable: false, value: 'actions' },
];

const filteredFeedbacks = computed(() => {
  return feedbacks.value.filter((feedback) =>
    feedback.content.toLowerCase().includes(search.value.toLowerCase())
  );
});

const formTitle = computed(() => (editedIndex.value === -1 ? 'Thêm Phản Hồi' : 'Chỉnh Sửa Phản Hồi'));

const openAddDialog = () => {
  editedIndex.value = -1;
  editedItem.value = { ...defaultItem };
  dialog.value = true;
};

const editFeedback = (item) => {
  editedIndex.value = feedbacks.value.indexOf(item);
  editedItem.value = { ...item };
  dialog.value = true;
};

const closeDialog = () => {
  dialog.value = false;
  editedItem.value = { ...defaultItem };
  editedIndex.value = -1;
};

const saveFeedback = () => {
  if (editedIndex.value > -1) {
    Object.assign(feedbacks.value[editedIndex.value], editedItem.value);
    showNotification('Phản hồi đã được cập nhật thành công!', 'success');
  } else {
    editedItem.value.id = feedbacks.value.length + 1;
    feedbacks.value.push(editedItem.value);
    showNotification('Phản hồi mới đã được thêm thành công!', 'success');
  }
  closeDialog();
};

const confirmDelete = (item) => {
  editedIndex.value = feedbacks.value.indexOf(item);
  editedItem.value = { ...item };
  deleteDialog.value = true;
};

const deleteFeedback = () => {
  feedbacks.value.splice(editedIndex.value, 1);
  closeDeleteDialog();
  showNotification('Phản hồi đã được xóa thành công!', 'success');
};

const closeDeleteDialog = () => {
  deleteDialog.value = false;
  editedItem.value = { ...defaultItem };
  editedIndex.value = -1;
};

const showNotification = (message, type) => {
  notification.value = { message, type };
  setTimeout(() => {
    notification.value = { message: '', type: 'info' };
  }, 3000);
};

const applyFilter = () => {
  // The filtering is handled by the computed property filteredFeedbacks
};
</script>

<style scoped>
.v-data-table ::v-deep th {
  font-weight: bold !important;
}
</style>