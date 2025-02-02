<template>
    <v-container fluid class="pa-0">
        <v-card class="elevation-2">
            <v-toolbar color="primary" dark>
                <v-toolbar-title>Quản Lý Sự Kiện</v-toolbar-title>
                <v-spacer></v-spacer>
            </v-toolbar>

            <v-card-text>
                <v-alert v-if="notification.message" :type="notification.type" :text="notification.message" class="mb-4" closable></v-alert>

                <v-row class="mb-4">
                    <v-col cols="12" sm="4">
                        <v-btn color="primary" @click="openAddDialog">
                            Thêm Sự Kiện
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
                    :items="filteredEvents"
                    :items-per-page="itemsPerPage"
                    :page.sync="page"
                    class="elevation-1"
                >
                    <template v-slot:item.index="{ item }">
                        {{ events.indexOf(item) + 1 }}
                    </template>
                    <template v-slot:item.name="{ item }">
                        <span style="color: red">{{ item.name }}</span>
                    </template>
                    <template v-slot:item.start_date="{ item }">
                        {{ formatDate(item.start_date) }}
                    </template>
                    <template v-slot:item.end_date="{ item }">
                        {{ formatDate(item.end_date) }}
                    </template>
                    <template v-slot:item.details="{ item }">
                        <v-btn text @click="viewDetails(item)" style="color: red"> Xem Chi Tiết </v-btn>
                    </template>
                    <template v-slot:item.actions="{ item }">
                        <v-btn small color="primary" class="mr-2" @click="editEvent(item)">
                            Sửa
                        </v-btn>
                        <v-btn small color="error" @click="confirmDelete(item)">
                            Xóa
                        </v-btn>
                    </template>
                </v-data-table>
            </v-card-text>
        </v-card>

        <!-- Add/Edit Event Dialog -->
        <v-dialog v-model="dialog" max-width="500px">
            <v-card>
                <v-card-title>
                    <span class="text-h5">{{ formTitle }}</span>
                </v-card-title>
                <v-card-text>
                    <v-container>
                        <v-row>
                            <v-col cols="12">
                                <v-text-field v-model="editedItem.name" label="Tên Sự Kiện"></v-text-field>
                            </v-col>
                            <v-col cols="12">
                                <v-text-field v-model="editedItem.location" label="Địa Điểm"></v-text-field>
                            </v-col>
                            <v-col cols="12">
                                <v-text-field v-model="editedItem.max_participants" label="Số Lượng Tối Đa" type="number"></v-text-field>
                            </v-col>
                            <v-col cols="12">
                                <v-textarea v-model="editedItem.content" label="Nội Dung"></v-textarea>
                            </v-col>
                            <v-col cols="12">
                                <v-text-field v-model="editedItem.logo" label="Liên Kết Ảnh"></v-text-field>
                            </v-col>
                            <v-col cols="12">
                                <v-select v-model="editedItem.category_id" :items="categoryOptions" label="Danh Mục"></v-select>
                            </v-col>
                            <v-col cols="12">
                                <v-menu v-model="startDateMenu" :close-on-content-click="false" transition="scale-transition">
                                    <template v-slot:activator="{ on }">
                                        <v-text-field
                                            v-model="editedItem.start_date"
                                            label="Ngày Bắt Đầu"
                                            readonly
                                            v-on="on"
                                        ></v-text-field>
                                    </template>
                                    <v-date-picker v-model="editedItem.start_date" @input="startDateMenu = false"></v-date-picker>
                                </v-menu>
                            </v-col>
                            <v-col cols="12">
                                <v-menu v-model="endDateMenu" :close-on-content-click="false" transition="scale-transition">
                                    <template v-slot:activator="{ on }">
                                        <v-text-field v-model="editedItem.end_date" label="Ngày Kết Thúc" readonly v-on="on"></v-text-field>
                                    </template>
                                    <v-date-picker v-model="editedItem.end_date" @input="endDateMenu = false"></v-date-picker>
                                </v-menu>
                            </v-col>
                        </v-row>
                    </v-container>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue darken-1" text @click="closeDialog">Hủy</v-btn>
                    <v-btn color="blue darken-1" text @click="saveEvent">Lưu</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- View Details Dialog -->
        <v-dialog v-model="detailsDialog" max-width="600px">
            <v-card>
                <v-card-title>
                    <span class="text-h5">Chi Tiết Sự Kiện</span>
                </v-card-title>
                <v-card-text>
                    <v-row>
                        <v-col cols="12">
                            <v-img :src="selectedEvent.logo" max-height="200" contain></v-img>
                        </v-col>
                        <v-col cols="12">
                            <h3>{{ selectedEvent.name }}</h3>
                            <p><strong>Địa Điểm:</strong> {{ selectedEvent.location }}</p>
                            <p><strong>Ngày Bắt Đầu:</strong> {{ new Date(selectedEvent.start_date).toLocaleString() }}</p>
                            <p><strong>Ngày Kết Thúc:</strong> {{ new Date(selectedEvent.end_date).toLocaleString() }}</p>
                            <p><strong>Số Lượng Tối Đa:</strong> {{ selectedEvent.max_participants }}</p>
                            <p><strong>Nội Dung:</strong> {{ selectedEvent.content }}</p>
                            <p><strong>Danh Mục ID:</strong> {{ selectedEvent.category_id }}</p>
                            <p><strong>Trạng Thái:</strong> {{ selectedEvent.status }}</p>
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
                <v-card-title class="text-h5">Xác nhận xóa sự kiện</v-card-title>
                <v-card-text>Bạn có chắc chắn muốn xóa sự kiện này không?</v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue darken-1" text @click="deleteDialog = false">Hủy</v-btn>
                    <v-btn color="red darken-1" text @click="deleteEvent">Xóa</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </v-container>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { useEventStore } from '../../stores';

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
    date: '',
    status: 'active'
});
const defaultItem = {
    id: null,
    title: '',
    date: '',
    status: 'active'
};

const store = useEventStore();

const headers = [
    { title: 'STT', align: 'center', sortable: false, key: 'index' },
    { title: 'Tiêu Đề Sự Kiện', align: 'start', sortable: true, key: 'title' },
    { title: 'Ngày', align: 'start', key: 'date' },
    { title: 'Trạng Thái', align: 'center', key: 'status' },
    { title: 'Hành Động', align: 'center', key: 'actions', sortable: false }
];

const statusOptions = [
    { title: 'Hoạt động', value: 'active' },
    { title: 'Không hoạt động', value: 'inactive' }
];

const filteredEvents = computed(() => {
    return store.events.filter((event) =>
        event.title.toLowerCase().includes(search.value.toLowerCase())
    );
});

// Fetch events when component is mounted
onMounted(async () => {
    await store.fetchEvents();
});

// Dialog management
const openAddDialog = () => {
    editedIndex.value = -1;
    editedItem.value = { ...defaultItem };
    dialog.value = true;
};

const editEvent = (item) => {
    editedIndex.value = store.events.indexOf(item);
    editedItem.value = { ...item };
    dialog.value = true;
};

const closeDialog = () => {
    dialog.value = false;
    editedItem.value = { ...defaultItem };
    editedIndex.value = -1;
};

const saveEvent = async () => {
    if (editedIndex.value > -1) {
        await store.updateEvent(editedItem.value.id, editedItem.value);
        Object.assign(store.events[editedIndex.value], editedItem.value);
        showNotification('Sự kiện đã được cập nhật thành công!', 'success');
    } else {
        const newEvent = await store.createEvent(editedItem.value);
        store.events.push(newEvent);
        showNotification('Sự kiện mới đã được thêm thành công!', 'success');
    }
    closeDialog();
};

const confirmDelete = (item) => {
    editedIndex.value = store.events.indexOf(item);
    editedItem.value = { ...item };
    deleteDialog.value = true;
};

const deleteEvent = async () => {
    await store.deleteEvent(editedItem.value.id);
    store.events.splice(editedIndex.value, 1);
    closeDeleteDialog();
    showNotification('Sự kiện đã được xóa thành công!', 'success');
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