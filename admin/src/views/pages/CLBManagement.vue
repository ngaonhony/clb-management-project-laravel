<template>
    <v-container fluid class="pa-0">
        <v-card class="elevation-2">
            <v-toolbar color="primary" dark>
                <v-toolbar-title>Quản Lý Club</v-toolbar-title>
                <v-spacer></v-spacer>
            </v-toolbar>

            <v-card-text>
                <v-alert v-if="notification.message" :type="notification.type" :text="notification.message" class="mb-4" closable></v-alert>
                
                <v-row class="mb-4">
                    <v-col cols="12" sm="4">
                        <v-btn color="primary" @click="openAddDialog">Thêm Club</v-btn>
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
                    :items="filteredClubs"
                    :items-per-page="itemsPerPage"
                    :page.sync="page"
                    class="elevation-1"
                >
                    <template v-slot:item.index="{ item }">
                        {{ filteredClubs.indexOf(item) + 1 + (page.value - 1) * itemsPerPage }}
                    </template>

                    <template v-slot:item.actions="{ item }">
                        <v-btn small color="primary" @click="editClub(item)">
                            <v-icon color="white">mdi-pencil</v-icon>
                        </v-btn>
                        <v-btn small color="error" @click="confirmDelete(item)">
                            <v-icon color="white">mdi-delete</v-icon>
                        </v-btn>
                    </template>
                </v-data-table>
            </v-card-text>
        </v-card>

        <!-- Add/Edit Club Dialog -->
        <v-dialog v-model="dialog" max-width="500px">
            <v-card>
                <v-card-title>
                    <span class="text-h5">{{ formTitle }}</span>
                </v-card-title>
                <v-card-text>
                    <v-container>
                        <v-row>
                            <v-col cols="12">
                                <v-text-field v-model="editedItem.name" label="Tên Club" required></v-text-field>
                            </v-col>
                            <v-col cols="12">
                                <v-text-field v-model="editedItem.contact_email" label="Email Liên Hệ"></v-text-field>
                            </v-col>
                            <v-col cols="12">
                                <v-select v-model="editedItem.status" :items="statusOptions" label="Trạng Thái"></v-select>
                            </v-col>
                        </v-row>
                    </v-container>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn text @click="closeDialog">Hủy</v-btn>
                    <v-btn color="primary" @click="saveClub">Lưu</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- Delete Confirmation Dialog -->
        <v-dialog v-model="deleteDialog" max-width="400px">
            <v-card>
                <v-card-title class="text-h5">Xác nhận xóa club</v-card-title>
                <v-card-text>Bạn có chắc chắn muốn xóa club này không?</v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn text @click="closeDeleteDialog">Hủy</v-btn>
                    <v-btn color="red" @click="deleteClub">Xóa</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </v-container>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { useClubStore } from '../../stores';

const search = ref('');
const notification = ref({ message: '', type: 'info' });
const itemsPerPage = 5;
const page = ref(1);
const dialog = ref(false);
const deleteDialog = ref(false);
const editedIndex = ref(-1);
const editedItem = ref({
    id: null,
    name: '',
    contact_email: '',
    status: 'active' // default status
});
const defaultItem = {
    id: null,
    name: '',
    contact_email: '',
    status: 'inactive'
};

const store = useClubStore();

const headers = [
    { title: 'STT', align: 'center', sortable: false, key: 'id' },
    { title: 'Tên Club', align: 'start', sortable: true, key: 'name' },
    { title: 'Email liên hệ', align: 'start', key: 'contact_email' },
    { title: 'Trạng Thái', align: 'start', key: 'status' },
    { title: 'Hành Động', align: 'center', key: 'actions', sortable: false }
];

const statusOptions = [
    { title: 'Hoạt động', value: 'active' },
    { title: 'Không hoạt động', value: 'inactive' }
];

const filteredClubs = computed(() => {
    return store.clubs.filter((club) =>
        club.name.toLowerCase().includes(search.value.toLowerCase())
    );
});

// Fetch clubs when component is mounted
onMounted(async () => {
    await store.fetchClubs();
});

const formTitle = computed(() => {
    return editedIndex.value === -1 ? 'Thêm Club' : 'Chỉnh Sửa Club';
});

const openAddDialog = () => {
    editedIndex.value = -1;
    editedItem.value = { ...defaultItem };
    dialog.value = true;
};

const editClub = (item) => {
    editedIndex.value = store.clubs.indexOf(item);
    editedItem.value = { ...item };
    dialog.value = true;
};

const closeDialog = () => {
    dialog.value = false;
    editedItem.value = { ...defaultItem };
    editedIndex.value = -1;
};

const saveClub = async () => {
    if (editedIndex.value > -1) {
        await store.updateClub(editedItem.value.id, editedItem.value);
        Object.assign(store.clubs[editedIndex.value], editedItem.value);
        showNotification('Club đã được cập nhật thành công!', 'success');
    } else {
        const newClub = await store.createClub(editedItem.value);
        store.clubs.push(newClub);
        showNotification('Club mới đã được thêm thành công!', 'success');
    }
    closeDialog();
};

const confirmDelete = (item) => {
    editedIndex.value = store.clubs.indexOf(item);
    editedItem.value = { ...item };
    deleteDialog.value = true;
};

const deleteClub = async () => {
    await store.deleteClub(editedItem.value.id);
    store.clubs.splice(editedIndex.value, 1);
    closeDeleteDialog();
    showNotification('Club đã được xóa thành công!', 'success');
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