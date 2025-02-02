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

    <!-- Dialog để thêm/chỉnh sửa phản hồi -->
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

    <!-- Dialog xác nhận xóa phản hồi -->
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
import { ref, computed, onMounted } from 'vue';
import { useFeedbackStore } from '../../stores';

const search = ref('');
const notification = ref({ message: '', type: 'info' });
const itemsPerPage = 5;
const page = ref(1);
const dialog = ref(false);
const deleteDialog = ref(false);
const editedIndex = ref(-1);
const editedItem = ref({
    id: null,
    user: '',
    comment: '',
    status: 'active'
});
const defaultItem = {
    id: null,
    user: '',
    comment: '',
    status: 'active'
};

const store = useFeedbackStore();

const headers = [
    { title: 'STT', align: 'center', sortable: false, key: 'index' },
    { title: 'Người Dùng', align: 'start', sortable: true, key: 'user' },
    { title: 'Nhận Xét', align: 'start', key: 'comment' },
    { title: 'Trạng Thái', align: 'center', key: 'status' },
    { title: 'Hành Động', align: 'center', key: 'actions', sortable: false }
];

const statusOptions = [
    { title: 'Hoạt động', value: 'active' },
    { title: 'Không hoạt động', value: 'inactive' }
];

const filteredFeedbacks = computed(() => {
    return store.feedbacks.filter((feedback) =>
        feedback.user.toLowerCase().includes(search.value.toLowerCase())
    );
});

// Fetch feedbacks when component is mounted
onMounted(async () => {
    await store.fetchFeedbacks();
});

// Dialog management
const openAddDialog = () => {
    editedIndex.value = -1;
    editedItem.value = { ...defaultItem };
    dialog.value = true;
};

const editFeedback = (item) => {
    editedIndex.value = store.feedbacks.indexOf(item);
    editedItem.value = { ...item };
    dialog.value = true;
};

const closeDialog = () => {
    dialog.value = false;
    editedItem.value = { ...defaultItem };
    editedIndex.value = -1;
};

const saveFeedback = async () => {
    if (editedIndex.value > -1) {
        await store.updateFeedback(editedItem.value.id, editedItem.value);
        Object.assign(store.feedbacks[editedIndex.value], editedItem.value);
        showNotification('Nhận xét đã được cập nhật thành công!', 'success');
    } else {
        const newFeedback = await store.createFeedback(editedItem.value);
        store.feedbacks.push(newFeedback);
        showNotification('Nhận xét mới đã được thêm thành công!', 'success');
    }
    closeDialog();
};

const confirmDelete = (item) => {
    editedIndex.value = store.feedbacks.indexOf(item);
    editedItem.value = { ...item };
    deleteDialog.value = true;
};

const deleteFeedback = async () => {
    await store.deleteFeedback(editedItem.value.id);
    store.feedbacks.splice(editedIndex.value, 1);
    closeDeleteDialog();
    showNotification('Nhận xét đã được xóa thành công!', 'success');
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
</script>

<style scoped>
.v-data-table ::v-deep th {
    font-weight: bold !important;
}
</style>