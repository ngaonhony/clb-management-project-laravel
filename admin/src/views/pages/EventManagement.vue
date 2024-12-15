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
import { ref, computed } from 'vue';

const search = ref('');
const events = ref([
    {
        id: 1,
        name: 'Sự Kiện 1',
        location: 'Hà Nội',
        start_date: new Date(),
        end_date: new Date(),
        max_participants: 100,
        registered_participants: 50,
        content: 'Nội dung sự kiện 1',
        logo: 'link1.jpg',
        category_id: 1,
        status: 'active'
    },
    {
        id: 2,
        name: 'Sự Kiện 2',
        location: 'TP.HCM',
        start_date: new Date(),
        end_date: new Date(),
        max_participants: 200,
        registered_participants: 150,
        content: 'Nội dung sự kiện 2',
        logo: 'link2.jpg',
        category_id: 2,
        status: 'active'
    }
]);

const notification = ref({ message: '', type: 'info' });
const itemsPerPage = 5;
const page = ref(1);
const dialog = ref(false);
const deleteDialog = ref(false);
const detailsDialog = ref(false);
const selectedEvent = ref({});
const editedIndex = ref(-1);
const editedItem = ref({
    id: null,
    name: '',
    location: '',
    max_participants: 0,
    registered_participants: 0,
    content: '',
    logo: '',
    category_id: null,
    start_date: new Date(),
    end_date: new Date(),
    status: 'active'
});
const defaultItem = {
    id: null,
    name: '',
    location: '',
    max_participants: 0,
    registered_participants: 0,
    content: '',
    logo: '',
    category_id: null,
    start_date: new Date(),
    end_date: new Date(),
    status: 'active'
};
const categoryOptions = ['Danh mục 1', 'Danh mục 2', 'Danh mục 3']; // Thay thế bằng danh mục thực tế

const headers = [
    { title: 'STT', align: 'center', sortable: false, value: 'index' },
    { title: 'Tên Sự Kiện', align: 'start', sortable: true, value: 'name' },
    { title: 'Địa Điểm', align: 'start', sortable: true, value: 'location' },
    { title: 'Ngày Bắt Đầu', align: 'start', sortable: true, value: 'start_date' },
    { title: 'Ngày Kết Thúc', align: 'start', sortable: true, value: 'end_date' },
    { title: 'Xem Chi Tiết', align: 'center', sortable: false, value: 'details' },
    { title: 'Hành Động', align: 'center', sortable: false, value: 'actions' },
];

const filteredEvents = computed(() => {
    return events.value.filter(
        (event) =>
            event.name.toLowerCase().includes(search.value.toLowerCase()) ||
            event.location.toLowerCase().includes(search.value.toLowerCase())
    );
});

const formTitle = computed(() => (editedIndex.value === -1 ? 'Thêm Sự Kiện' : 'Chỉnh Sửa Sự Kiện'));

const openAddDialog = () => {
    editedIndex.value = -1;
    editedItem.value = { ...defaultItem };
    dialog.value = true;
};

const editEvent = (item) => {
    editedIndex.value = events.value.indexOf(item);
    editedItem.value = { ...item };
    dialog.value = true;
};

const viewDetails = (item) => {
    selectedEvent.value = { ...item };
    detailsDialog.value = true;
};

const closeDetailsDialog = () => {
    detailsDialog.value = false;
    selectedEvent.value = {};
};

const closeDialog = () => {
    dialog.value = false;
    editedItem.value = { ...defaultItem };
    editedIndex.value = -1;
};

const saveEvent = () => {
    if (editedIndex.value > -1) {
        Object.assign(events.value[editedIndex.value], editedItem.value);
        showNotification('Sự kiện đã được cập nhật thành công!', 'success');
    } else {
        editedItem.value.id = events.value.length + 1;
        events.value.push(editedItem.value);
        showNotification('Sự kiện mới đã được thêm thành công!', 'success');
    }
    closeDialog();
};

const confirmDelete = (item) => {
    editedIndex.value = events.value.indexOf(item);
    editedItem.value = { ...item };
    deleteDialog.value = true;
};

const deleteEvent = () => {
    events.value.splice(editedIndex.value, 1);
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
const formatDate = (date) => {
    const options = { year: 'numeric', month: 'numeric', day: 'numeric', hour: '2-digit', minute: '2-digit' };
    return new Intl.DateTimeFormat('vi-VN', options).format(new Date(date));
};
const applyFilter = () => {
    // The filtering is handled by the computed property filteredEvents
};
</script>

<style scoped>
.v-data-table ::v-deep th {
    font-weight: bold !important;
}
</style>
