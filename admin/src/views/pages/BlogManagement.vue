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
                        <v-btn color="primary" @click="openAddDialog">
                            <v-icon left>mdi-plus</v-icon>
                            Thêm Bài Viết
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
                    :items="filteredPosts"
                    :items-per-page="itemsPerPage"
                    :page.sync="page"
                    class="elevation-1"
                >
                    <template v-slot:item.index="{ item }">
                        {{ posts.indexOf(item) + 1 }}
                    </template>
                    <template v-slot:item.title="{ item }">
                        <span style="color: green">{{ item.title }}</span>
                    </template>
                    <template v-slot:item.details="{ item }">
                        <v-btn text @click="viewDetails(item)" style="color: red"> Xem Chi Tiết </v-btn>
                    </template>
                    <template v-slot:item.actions="{ item }">
                        <v-btn small color="primary" class="mr-2" @click="editPost(item)">
                            Sửa
                        </v-btn>
                        <v-btn small color="error" @click="confirmDelete(item)">
                            Xóa
                        </v-btn>
                    </template>
                </v-data-table>
            </v-card-text>
        </v-card>

        <!-- Add/Edit Post Dialog -->
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
                                <v-textarea v-model="editedItem.content" label="Nội Dung"></v-textarea>
                            </v-col>
                            <v-col cols="12">
                                <v-text-field v-model="editedItem.logo" label="Liên Kết Ảnh"></v-text-field>
                            </v-col>
                            <v-col cols="12">
                                <v-text-field v-model="editedItem.view_count" label="Số Lượt Xem" type="number"></v-text-field>
                            </v-col>
                            <v-col cols="12">
                                <v-select v-model="editedItem.category_id" :items="categoryOptions" label="Danh Mục"></v-select>
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

        <!-- View Details Dialog -->
        <v-dialog v-model="detailsDialog" max-width="600px">
            <v-card>
                <v-card-title>
                    <span class="text-h5">Chi Tiết Bài Viết</span>
                </v-card-title>
                <v-card-text>
                    <v-row>
                        <v-col cols="12">
                            <v-img :src="selectedPost.logo" max-height="200" contain></v-img>
                        </v-col>
                        <v-col cols="12">
                            <h3>{{ selectedPost.title }}</h3>
                            <p><strong>Tác Giả:</strong> {{ selectedPost.author_id }}</p>
                            <p><strong>Mô Tả:</strong> {{ selectedPost.description }}</p>
                            <p><strong>Nội Dung:</strong> {{ selectedPost.content }}</p>
                            <p><strong>Số Lượt Xem:</strong> {{ selectedPost.view_count }}</p>
                            <p><strong>Danh Mục ID:</strong> {{ selectedPost.category_id }}</p>
                            <p><strong>Ngày Tạo:</strong> {{ new Date(selectedPost.created_at).toLocaleString() }}</p>
                            <p><strong>Ngày Cập Nhật:</strong> {{ new Date(selectedPost.updated_at).toLocaleString() }}</p>
                        </v-col>
                    </v-row>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue darken-1" text @click="closeDetailsDialog">Đóng</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- Delete Confirmation Dialog -->
        <v-dialog v-model="deleteDialog" max-width="400px">
            <v-card>
                <v-card-title class="text-h5">Xác nhận xóa bài viết</v-card-title>
                <v-card-text>Bạn có chắc chắn muốn xóa bài viết này không?</v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue darken-1" text @click="deleteDialog = false">Hủy</v-btn>
                    <v-btn color="red darken-1" text @click="deletePost">Xóa</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </v-container>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';

const search = ref('');
const posts = ref([
    {
        id: 1,
        title: 'Bài Viết 1',
        author_id: 1,
        description: 'Mô tả bài viết 1',
        category_id: 1,
        view_count: 10,
        logo: 'link1.jpg',
        content: 'Nội dung bài viết 1',
        created_at: new Date(),
        updated_at: new Date()
    },
    {
        id: 2,
        title: 'Bài Viết 2',
        author_id: 2,
        description: 'Mô tả bài viết 2',
        category_id: 2,
        view_count: 5,
        logo: 'link2.jpg',
        content: 'Nội dung bài viết 2',
        created_at: new Date(),
        updated_at: new Date()
    }
]);

const notification = ref({ message: '', type: 'info' });
const itemsPerPage = 5;
const page = ref(1);
const dialog = ref(false);
const deleteDialog = ref(false);
const detailsDialog = ref(false);
const selectedPost = ref({});
const editedIndex = ref(-1);
const editedItem = ref({
    id: null,
    title: '',
    author_id: 1,
    description: '',
    category_id: null,
    view_count: 0,
    logo: '',
    content: '',
    created_at: new Date(),
    updated_at: new Date()
});
const defaultItem = {
    id: null,
    title: '',
    author_id: 1,
    description: '',
    category_id: null,
    view_count: 0,
    logo: '',
    content: '',
    created_at: new Date(),
    updated_at: new Date()
};
const categoryOptions = ['Danh mục 1', 'Danh mục 2', 'Danh mục 3']; // Thay thế bằng danh mục thực tế

const headers = [
    { title: 'STT', align: 'center', sortable: false, value: 'index' },
    { title: 'Tiêu Đề', align: 'start', sortable: true, value: 'title' },
    { title: 'Xem Chi Tiết', align: 'center', sortable: false, value: 'details' },
    { title: 'Số Lượt Xem', align: 'center', value: 'view_count' },
    { title: 'Hành Động', align: 'center', sortable: false, value: 'actions' }
];

const filteredPosts = computed(() => {
    return posts.value.filter(
        (post) =>
            post.title.toLowerCase().includes(search.value.toLowerCase()) ||
            post.description.toLowerCase().includes(search.value.toLowerCase())
    );
});

const formTitle = computed(() => (editedIndex.value === -1 ? 'Thêm Bài Viết' : 'Chỉnh Sửa Bài Viết'));

const openAddDialog = () => {
    editedIndex.value = -1;
    editedItem.value = { ...defaultItem };
    dialog.value = true;
};

const editPost = (item) => {
    editedIndex.value = posts.value.indexOf(item);
    editedItem.value = { ...item };
    dialog.value = true;
};

const viewDetails = (item) => {
    selectedPost.value = { ...item };
    detailsDialog.value = true;
};

const closeDetailsDialog = () => {
    detailsDialog.value = false;
    selectedPost.value = {};
};

const closeDialog = () => {
    dialog.value = false;
    editedItem.value = { ...defaultItem };
    editedIndex.value = -1;
};

const savePost = () => {
    if (editedIndex.value > -1) {
        Object.assign(posts.value[editedIndex.value], editedItem.value);
        showNotification('Bài viết đã được cập nhật thành công!', 'success');
    } else {
        editedItem.value.id = posts.value.length + 1;
        posts.value.push(editedItem.value);
        showNotification('Bài viết mới đã được thêm thành công!', 'success');
    }
    closeDialog();
};

const confirmDelete = (item) => {
    editedIndex.value = posts.value.indexOf(item);
    editedItem.value = { ...item };
    deleteDialog.value = true;
};

const deletePost = () => {
    posts.value.splice(editedIndex.value, 1);
    closeDeleteDialog();
    showNotification('Bài viết đã được xóa thành công!', 'success');
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
    // The filtering is handled by the computed property filteredPosts
};
</script>

<style scoped>
.v-data-table ::v-deep th {
    font-weight: bold !important;
}
</style>
