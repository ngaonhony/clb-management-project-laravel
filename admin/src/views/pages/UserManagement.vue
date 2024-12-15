<template>
  <v-container fluid class="pa-0">
    <v-card class="elevation-2">
      <v-toolbar color="primary" dark>
        <v-toolbar-title>Quản Lý User</v-toolbar-title>
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
              <v-icon left>mdi-plus</v-icon>
              Thêm User
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
          :items="filteredUsers"
          :items-per-page="itemsPerPage"
          :page.sync="page"
          class="elevation-1"
        >
          <template v-slot:item.index="{ item }">
            {{ users.indexOf(item) + 1 }}
          </template>
          <template v-slot:item.role="{ item }">
                        <v-chip
                            :color="item.role === 'User' ? 'success' : 'error'"
                            :text-color="item.role === 'User' ? 'white' : 'white'"
                            small
                        >
                            {{ item.role === 'User' ? 'User' : 'Admin' }}
                        </v-chip>
                    </template>
          <template v-slot:item.actions="{ item }">
            <v-btn small color="primary" class="mr-2" @click="editUser(item)">
              <v-icon small>mdi-pencil</v-icon>
            </v-btn>
            <v-btn small color="error" @click="confirmDelete(item)">
              <v-icon small>mdi-delete</v-icon>
            </v-btn>
          </template>
        </v-data-table>
      </v-card-text>
    </v-card>

    <!-- Add/Edit User Dialog -->
    <v-dialog v-model="dialog" max-width="500px">
      <v-card>
        <v-card-title>
          <span class="text-h5">{{ formTitle }}</span>
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-row>
              <v-col cols="12">
                <v-text-field v-model="editedItem.name" label="Tên User"></v-text-field>
              </v-col>
              <v-col cols="12">
                <v-text-field v-model="editedItem.email" label="Email"></v-text-field>
              </v-col>
              <v-col cols="12">
                <v-select v-model="editedItem.role" :items="roleOptions" label="Vai Trò"></v-select>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" text @click="closeDialog">Hủy</v-btn>
          <v-btn color="blue darken-1" text @click="saveUser">Lưu</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Delete Confirmation Dialog -->
    <v-dialog v-model="deleteDialog" max-width="400px">
      <v-card>
        <v-card-title class="text-h5">Xác nhận xóa user</v-card-title>
        <v-card-text>Bạn có chắc chắn muốn xóa user này không?</v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" text @click="deleteDialog = false">Hủy</v-btn>
          <v-btn color="red darken-1" text @click="deleteUser">Xóa</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';

const search = ref('');
const users = ref([
  { id: 1, name: 'User 1', email: 'user1@example.com', role: 'Admin' },
  { id: 2, name: 'User 2', email: 'user2@example.com', role: 'User' },
  { id: 3, name: 'User 3', email: 'user3@example.com', role: 'User' },
]);

const notification = ref({ message: '', type: 'info' });
const itemsPerPage = 5;
const page = ref(1);
const dialog = ref(false);
const deleteDialog = ref(false);
const editedIndex = ref(-1);
const editedItem = ref({ id: null, name: '', email: '', role: '' });
const defaultItem = { id: null, name: '', email: '', role: '' };
const roleOptions = ['Admin', 'User', 'Guest'];

const headers = [
  { title: 'STT', align: 'center', sortable: false, value: 'index' },
  { title: 'Tên User', align: 'start', sortable: true, value: 'name' },
  { title: 'Email', align: 'start', value: 'email' },
  { title: 'Vai Trò', align: 'center', value: 'role' },
  { title: 'Hành Động', align: 'center', sortable: false, value: 'actions' },
];

const filteredUsers = computed(() => {
  return users.value.filter((user) =>
    user.name.toLowerCase().includes(search.value.toLowerCase()) ||
    user.email.toLowerCase().includes(search.value.toLowerCase()) ||
    user.role.toLowerCase().includes(search.value.toLowerCase())
  );
});

const formTitle = computed(() => (editedIndex.value === -1 ? 'Thêm User' : 'Chỉnh Sửa User'));

const openAddDialog = () => {
  editedIndex.value = -1;
  editedItem.value = { ...defaultItem };
  dialog.value = true;
};

const editUser = (item) => {
  editedIndex.value = users.value.indexOf(item);
  editedItem.value = { ...item };
  dialog.value = true;
};

const closeDialog = () => {
  dialog.value = false;
  editedItem.value = { ...defaultItem };
  editedIndex.value = -1;
};

const saveUser = () => {
  if (editedIndex.value > -1) {
    Object.assign(users.value[editedIndex.value], editedItem.value);
    showNotification('User đã được cập nhật thành công!', 'success');
  } else {
    editedItem.value.id = users.value.length + 1;
    users.value.push(editedItem.value);
    showNotification('User mới đã được thêm thành công!', 'success');
  }
  closeDialog();
};

const confirmDelete = (item) => {
  editedIndex.value = users.value.indexOf(item);
  editedItem.value = { ...item };
  deleteDialog.value = true;
};

const deleteUser = () => {
  users.value.splice(editedIndex.value, 1);
  closeDeleteDialog();
  showNotification('User đã được xóa thành công!', 'success');
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
  // The filtering is handled by the computed property filteredUsers
};
</script>

<style scoped>
.v-data-table ::v-deep th {
  font-weight: bold !important;
}
</style>