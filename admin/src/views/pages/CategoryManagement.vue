<template>
    <v-container fluid class="pa-0">
        <v-card class="elevation-2">
            <v-toolbar color="primary" dark>
                <v-toolbar-title>Quản Lý Danh Mục</v-toolbar-title>
                <v-spacer></v-spacer>
            </v-toolbar>

            <v-card-text>
                <v-alert v-if="notification.message" :type="notification.type" :text="notification.message" class="mb-4" closable></v-alert>
                <v-row class="mb-4">
                    <v-col cols="12" sm="4">
                        <v-btn color="primary" @click="openAddDialog">
                            Thêm Danh Mục
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
                    :items="filteredCategories"
                    :items-per-page="itemsPerPage"
                    :page.sync="page"
                    class="elevation-1"
                >
                    <template v-slot:item.index="{ item }">
                        {{ categories.indexOf(item) + 1 }}
                    </template>

                    <template v-slot:item.status="{ item }">
                        <v-chip
                            :color="item.status === 'active' ? 'success' : 'error'"
                            :text-color="item.status === 'active' ? 'white' : 'white'"
                            small
                        >
                            {{ item.status === 'active' ? 'Hoạt động' : 'Không hoạt động' }}
                        </v-chip>
                    </template>

                    <template v-slot:item.actions="{ item }">
                        <v-btn small color="primary" class="mr-2" @click="editUser(item)">
                            Sửa
                        </v-btn>
                        <v-btn small color="error" @click="confirmDelete(item)">
                            Xóa
                        </v-btn>
                    </template>
                </v-data-table>
            </v-card-text>
        </v-card>

        <!-- Add/Edit Category Dialog -->
        <v-dialog v-model="dialog" max-width="500px">
            <v-card>
                <v-card-title>
                    <span class="text-h5">{{ formTitle }}</span>
                </v-card-title>

                <v-card-text>
                    <v-container>
                        <v-row>
                            <v-col cols="12">
                                <v-text-field v-model="editedItem.name" label="Tên Danh Mục"></v-text-field>
                            </v-col>
                            <v-col cols="12">
                                <v-textarea v-model="editedItem.description" label="Mô Tả"></v-textarea>
                            </v-col>
                            <v-col cols="12">
                                <v-select v-model="editedItem.status" :items="statusOptions" label="Trạng Thái"></v-select>
                            </v-col>
                        </v-row>
                    </v-container>
                </v-card-text>

                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue darken-1" text @click="closeDialog">Hủy</v-btn>
                    <v-btn color="blue darken-1" text @click="saveCategory">Lưu</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- Delete Confirmation Dialog -->
        <v-dialog v-model="deleteDialog" max-width="400px">
            <v-card>
                <v-card-title class="text-h5">Xác nhận xóa danh mục</v-card-title>
                <v-card-text>Bạn có chắc chắn muốn xóa danh mục này không?</v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue darken-1" text @click="deleteDialog = false">Hủy</v-btn>
                    <v-btn color="red darken-1" text @click="deleteCategory">Xóa</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </v-container>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';

const search = ref('');
const categories = ref([
    { id: 1, name: 'Danh mục 1', description: 'Mô tả 1', status: 'active' },
    { id: 2, name: 'Danh mục 2', description: 'Mô tả 2', status: 'inactive' },
    { id: 3, name: 'Danh mục 3', description: 'Mô tả 3', status: 'active' },
    { id: 4, name: 'Danh mục 4', description: 'Mô tả 4', status: 'inactive' },
    { id: 5, name: 'Danh mục 5', description: 'Mô tả 5', status: 'active' },
    { id: 6, name: 'Danh mục 6', description: 'Mô tả 1', status: 'active' },
    { id: 7, name: 'Danh mục 7', description: 'Mô tả 2', status: 'inactive' },
    { id: 8, name: 'Danh mục 8', description: 'Mô tả 3', status: 'active' },
    { id: 9, name: 'Danh mục 9', description: 'Mô tả 4', status: 'inactive' },
    { id: 10, name: 'Danh mục 10', description: 'Mô tả 5', status: 'active' }
]);

const notification = ref({ message: '', type: 'info' });
const itemsPerPage = 5;
const page = ref(1);
const dialog = ref(false);
const deleteDialog = ref(false);
const editedIndex = ref(-1);
const editedItem = ref({
    id: null,
    name: '',
    description: '',
    status: 'active'
});
const defaultItem = {
    id: null,
    name: '',
    description: '',
    status: 'active'
};

const headers = [
    { title: 'STT', align: 'center', sortable: false, key: 'index' },
    { title: 'Tên Danh Mục', align: 'start', sortable: true, key: 'name' },
    { title: 'Mô Tả', align: 'start', key: 'description' },
    { title: 'Trạng Thái', align: 'center', key: 'status' },
    { title: 'Hành Động', align: 'center', key: 'actions', sortable: false }
];

const statusOptions = [
    { title: 'Hoạt động', value: 'active' },
    { title: 'Không hoạt động', value: 'inactive' }
];

const filteredCategories = computed(() => {
    return categories.value.filter((category) => category.name.toLowerCase().includes(search.value.toLowerCase()));
});

const formTitle = computed(() => {
    return editedIndex.value === -1 ? 'Thêm Danh Mục' : 'Chỉnh Sửa Danh Mục';
});

const applyFilter = () => {
    // Filtering is handled by the computed property
};

const openAddDialog = () => {
    editedIndex.value = -1;
    editedItem.value = Object.assign({}, defaultItem);
    dialog.value = true;
};

const editCategory = (item) => {
    editedIndex.value = categories.value.indexOf(item);
    editedItem.value = Object.assign({}, item);
    dialog.value = true;
};

const closeDialog = () => {
    dialog.value = false;
    editedItem.value = Object.assign({}, defaultItem);
    editedIndex.value = -1;
};

const saveCategory = () => {
    if (editedIndex.value > -1) {
        Object.assign(categories.value[editedIndex.value], editedItem.value);
        showNotification('Danh mục đã được cập nhật thành công!', 'success');
    } else {
        editedItem.value.id = categories.value.length + 1;
        categories.value.push(editedItem.value);
        showNotification('Danh mục mới đã được thêm thành công!', 'success');
    }
    closeDialog();
};

const confirmDelete = (item) => {
    editedIndex.value = categories.value.indexOf(item);
    editedItem.value = Object.assign({}, item);
    deleteDialog.value = true;
};

const deleteCategory = () => {
    categories.value.splice(editedIndex.value, 1);
    closeDeleteDialog();
    showNotification('Danh mục đã được xóa thành công!', 'success');
};

const closeDeleteDialog = () => {
    deleteDialog.value = false;
    editedItem.value = Object.assign({}, defaultItem);
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