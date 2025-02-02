<template>
    <v-container fluid class="pa-0">
      <v-card class="elevation-2">
        <v-toolbar color="primary" dark>
          <v-toolbar-title>Quản Lý Bài Viết</v-toolbar-title>
          <v-spacer></v-spacer>
        </v-toolbar>
  
        <v-card-text>
          <v-alert v-if="notification.message" :type="notification.type" :text="notification.message" class="mb-4" closable></v-alert>
  
          <v-row class="mb-4">
            <v-col cols="12" sm="4">
              <v-btn color="primary" @click="openAddDialog">Thêm Bài Viết</v-btn>
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
            :items="filteredPosts"
            :items-per-page="itemsPerPage"
            :page.sync="page"
            class="elevation-1"
          >
            <template v-slot:item.index="{ item }">
              {{ posts.indexOf(item) + 1 }}
            </template>
            <template v-slot:item.details="{ item }">
              <v-btn small @click="viewDetails(item)">Xem Chi Tiết</v-btn>
            </template>
            <template v-slot:item.actions="{ item }">
              <v-btn small color="primary" class="mr-2" @click="editPost(item)">Sửa</v-btn>
              <v-btn small color="error" @click="confirmDelete(item)">Xóa</v-btn>
            </template>
          </v-data-table>
        </v-card-text>
      </v-card>
  
      <!-- Dialog để thêm/chỉnh sửa bài viết -->
      <v-dialog v-model="dialog" max-width="500px">
        <v-card>
          <v-card-title>
            <span class="text-h5">{{ formTitle }}</span>
          </v-card-title>
          <v-card-text>
            <v-container>
              <v-row>
                <v-col cols="12">
                  <v-text-field v-model="editedItem.title" label="Tiêu Đề"></v-text-field>
                </v-col>
                <v-col cols="12">
                  <v-textarea v-model="editedItem.description" label="Mô Tả"></v-textarea>
                </v-col>
                <v-col cols="12">
                  <v-select v-model="editedItem.category_id" :items="categoryOptions" label="Danh Mục"></v-select>
                </v-col>
                <v-col cols="12">
                  <v-text-field v-model="editedItem.logo" label="Logo"></v-text-field>
                </v-col>
                <v-col cols="12">
                  <v-textarea v-model="editedItem.content" label="Nội Dung"></v-textarea>
                </v-col>
              </v-row>
            </v-container>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="blue darken-1" text @click="closeDialog">Hủy</v-btn>
            <v-btn color="blue darken-1" text @click="savePost">Lưu</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
  
      <!-- Dialog xác nhận xóa bài viết -->
      <v-dialog v-model="deleteDialog" max-width="400px">
        <v-card>
          <v-card-title class="text-h5">Xác nhận xóa bài viết</v-card-title>
          <v-card-text>Bạn có chắc chắn muốn xóa bài viết này không?</v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="blue darken-1" text @click="closeDeleteDialog">Hủy</v-btn>
            <v-btn color="red darken-1" text @click="deletePost">Xóa</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
  
      <!-- Dialog xem chi tiết bài viết -->
      <v-dialog v-model="detailsDialog" max-width="600px">
        <v-card>
          <v-card-title>
            <span class="text-h5">{{ selectedPost.title }}</span>
          </v-card-title>
          <v-card-text>
            <p><strong>Nội Dung:</strong> {{ selectedPost.content }}</p>
            <p><strong>Mô Tả:</strong> {{ selectedPost.description }}</p>
            <p><strong>Danh Mục:</strong> {{ selectedPost.category_id }}</p>
            <p><strong>Số Lượt Xem:</strong> {{ selectedPost.view_count }}</p>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="blue darken-1" @click="closeDetailsDialog">Đóng</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </v-container>
  </template>
  
  <script setup lang="ts">
  import { ref, computed, onMounted } from 'vue';
  import { useBlogStore } from '../../stores';
  
  const search = ref('');
  const notification = ref({ message: '', type: 'info' });
  const itemsPerPage = 5;
  const page = ref(1);
  const dialog = ref(false);
  const deleteDialog = ref(false);
  const editedIndex = ref(-1);
  const editedItem = ref({
      id: null,
      title: '',
      content: '',
      status: 'active'
  });
  const defaultItem = {
      id: null,
      title: '',
      content: '',
      status: 'active'
  };
  
  const store = useBlogStore();
  
  const headers = [
      { title: 'STT', align: 'center', sortable: false, key: 'index' },
      { title: 'Tiêu Đề', align: 'start', sortable: true, key: 'title' },
      { title: 'Nội Dung', align: 'start', key: 'content' },
      { title: 'Trạng Thái', align: 'center', key: 'status' },
      { title: 'Hành Động', align: 'center', key: 'actions', sortable: false }
  ];
  
  const statusOptions = [
      { title: 'Hoạt động', value: 'active' },
      { title: 'Không hoạt động', value: 'inactive' }
  ];
  
  const filteredBlogs = computed(() => {
      return store.blogs.filter((blog) =>
          blog.title.toLowerCase().includes(search.value.toLowerCase())
      );
  });
  
  // Fetch blogs when component is mounted
  onMounted(async () => {
      await store.fetchBlogs();
  });
  
  // Dialog management
  const openAddDialog = () => {
      editedIndex.value = -1;
      editedItem.value = { ...defaultItem };
      dialog.value = true;
  };
  
  const editBlog = (item) => {
      editedIndex.value = store.blogs.indexOf(item);
      editedItem.value = { ...item };
      dialog.value = true;
  };
  
  const closeDialog = () => {
      dialog.value = false;
      editedItem.value = { ...defaultItem };
      editedIndex.value = -1;
  };
  
  const saveBlog = async () => {
      if (editedIndex.value > -1) {
          await store.updateBlog(editedItem.value.id, editedItem.value);
          Object.assign(store.blogs[editedIndex.value], editedItem.value);
          showNotification('Blog đã được cập nhật thành công!', 'success');
      } else {
          const newBlog = await store.createBlog(editedItem.value);
          store.blogs.push(newBlog);
          showNotification('Blog mới đã được thêm thành công!', 'success');
      }
      closeDialog();
  };
  
  const confirmDelete = (item) => {
      editedIndex.value = store.blogs.indexOf(item);
      editedItem.value = { ...item };
      deleteDialog.value = true;
  };
  
  const deleteBlog = async () => {
      await store.deleteBlog(editedItem.value.id);
      store.blogs.splice(editedIndex.value, 1);
      closeDeleteDialog();
      showNotification('Blog đã được xóa thành công!', 'success');
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