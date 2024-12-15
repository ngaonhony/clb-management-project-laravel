<template>
    <v-container fluid class="pa-0">
        <v-card class="elevation-2">
            <v-toolbar color="primary" dark>
                <v-toolbar-title>Quản Lý Câu Lạc Bộ</v-toolbar-title>
                <v-spacer></v-spacer>
            </v-toolbar>

            <v-card-text>
                <v-alert v-if="notification.message" :type="notification.type" :text="notification.message" class="mb-4" closable></v-alert>

                <v-row class="mb-4">
                    <v-col cols="12" sm="4">
                        <v-btn color="primary" @click="openAddDialog">
                            <v-icon left>mdi-plus</v-icon>
                            Thêm Câu Lạc Bộ
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
                    :items="filteredClubs"
                    :items-per-page="itemsPerPage"
                    :page.sync="page"
                    class="elevation-1"
                >
                    <template v-slot:item.index="{ item }">
                        {{ clubs.indexOf(item) + 1 }}
                    </template>

                    <template v-slot:item.name="{ item }">
                        <span style="color: red">{{ item.name }}</span>
                    </template>

                    <template v-slot:item.user_name="{ item }">
                        {{ getUserName(item.user_id) }}
                    </template>

                    <template v-slot:item.status="{ item }">
                        <v-chip :color="item.status === 'approved' ? 'success' : item.status === 'rejected' ? 'error' : 'warning'" small>
                            {{ item.status.charAt(0).toUpperCase() + item.status.slice(1) }}
                        </v-chip>
                    </template>

                    <template v-slot:item.details="{ item }">
                        <v-btn text @click="viewDetails(item)" style="color: red">Xem Chi Tiết</v-btn>
                    </template>

                    <template v-slot:item.actions="{ item }">
                        <v-btn small color="primary" class="mr-2" @click="editClub(item)">
                            Sửa
                        </v-btn>
                        <v-btn small color="error" @click="confirmDelete(item)">
                            Xóa
                        </v-btn>
                    </template>
                </v-data-table>
            </v-card-text>
        </v-card>

        <!-- Add/Edit Club Dialog -->
        <v-dialog v-model="dialog" max-width="600px">
            <v-card>
                <v-card-title>
                    <span class="text-h5">{{ formTitle }}</span>
                </v-card-title>
                <v-card-text>
                    <v-container>
                        <v-row>
                            <v-col cols="12">
                                <v-text-field v-model="editedItem.name" label="Tên Câu Lạc Bộ"></v-text-field>
                            </v-col>
                            <v-col cols="12">
                                <v-textarea v-model="editedItem.description" label="Mô Tả"></v-textarea>
                            </v-col>
                            <v-col cols="12">
                                <v-text-field v-model="editedItem.logo" label="Liên kết Logo"></v-text-field>
                            </v-col>
                            <v-col cols="12">
                                <v-text-field v-model="editedItem.contact_email" label="Email Liên Hệ"></v-text-field>
                            </v-col>
                            <v-col cols="12">
                                <v-text-field v-model="editedItem.contact_phone" label="Số Điện Thoại Liên Hệ"></v-text-field>
                            </v-col>
                            <v-col cols="12">
                                <v-text-field v-model="editedItem.contact_address" label="Địa Chỉ Liên Hệ"></v-text-field>
                            </v-col>
                            <v-col cols="12">
                                <v-text-field v-model="editedItem.province" label="Tỉnh/Thành Phố"></v-text-field>
                            </v-col>
                            <v-col cols="12">
                                <v-text-field v-model="editedItem.website" label="Website"></v-text-field>
                            </v-col>
                            <v-col cols="12">
                                <v-text-field v-model="editedItem.facebook_link" label="Liên Kết Facebook"></v-text-field>
                            </v-col>
                            <v-col cols="12">
                                <v-text-field v-model="editedItem.zalo_link" label="Liên Kết Zalo"></v-text-field>
                            </v-col>
                            <v-col cols="12">
                                <v-select v-model="editedItem.category_id" :items="categories" item-text="name" item-value="id" label="Danh Mục"></v-select>
                            </v-col>
                            <v-col cols="12">
                                <v-select v-model="editedItem.user_id" :items="users" item-text="name" item-value="id" label="Người Dùng"></v-select>
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
                    <v-btn color="blue darken-1" text @click="saveClub">Lưu</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- View Details Dialog -->
        <v-dialog v-model="detailsDialog" max-width="600px">
            <v-card>
                <v-card-title>
                    <span class="text-h5">Chi Tiết Câu Lạc Bộ</span>
                </v-card-title>
                <v-card-text>
                    <v-row>
                        <v-col cols="12">
                            <h3>{{ selectedClub.name }}</h3>
                            <p><strong>Mô Tả:</strong> {{ selectedClub.description }}</p>
                            <p><strong>Người Dùng:</strong> {{ getUserName(selectedClub.user_id) }}</p>
                            <p><strong>Email:</strong> {{ selectedClub.contact_email }}</p>
                            <p><strong>Số Điện Thoại:</strong> {{ selectedClub.contact_phone }}</p>
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
                <v-card-title class="text-h5">Xác nhận xóa câu lạc bộ</v-card-title>
                <v-card-text>Bạn có chắc chắn muốn xóa câu lạc bộ này không?</v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue darken-1" text @click="closeDeleteDialog">Hủy</v-btn>
                    <v-btn color="red darken-1" text @click="deleteClub">Xóa</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </v-container>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';

const search = ref('');
const clubs = ref([
    {
        id: 1,
        user_id: 'user1',
        category_id: 'cat1',
        name: 'Câu Lạc Bộ 1',
        logo: 'link_to_logo_1',
        description: 'Mô tả 1',
        member_count: 100,
        contact_email: 'email1@example.com',
        contact_phone: '0123456789',
        contact_address: 'Địa chỉ 1',
        province: 'Tỉnh 1',
        website: 'website1.com',
        facebook_link: 'facebook.com/clb1',
        zalo_link: 'zalo.me/clb1',
        created_at: new Date(),
        status: 'approved'
    },
    {
        id: 2,
        user_id: 'user2',
        category_id: 'cat2',
        name: 'Câu Lạc Bộ 2',
        logo: 'link_to_logo_2',
        description: 'Mô tả 2',
        member_count: 50,
        contact_email: 'email2@example.com',
        contact_phone: '0123456780',
        contact_address: 'Địa chỉ 2',
        province: 'Tỉnh 2',
        website: 'website2.com',
        facebook_link: 'facebook.com/clb2',
        zalo_link: 'zalo.me/clb2',
        created_at: new Date(),
        status: 'pending'
    },
]);

const users = [
    { id: 'user1', name: 'Người Dùng 1' },
    { id: 'user2', name: 'Người Dùng 2' },
];

const categories = [
    { id: 'cat1', name: 'Danh Mục 1' },
    { id: 'cat2', name: 'Danh Mục 2' },
];

const notification = ref({ message: '', type: 'info' });
const itemsPerPage = 5;
const page = ref(1);
const dialog = ref(false);
const deleteDialog = ref(false);
const detailsDialog = ref(false);
const selectedClub = ref({});
const editedIndex = ref(-1);
const editedItem = ref({
    id: null,
    user_id: '',
    category_id: '',
    name: '',
    logo: '',
    description: '',
    member_count: 0,
    contact_email: '',
    contact_phone: '',
    contact_address: '',
    province: '',
    website: '',
    facebook_link: '',
    zalo_link: '',
    created_at: new Date(),
    status: 'pending', // Trạng thái mặc định
});
const defaultItem = {
    id: null,
    user_id: '',
    category_id: '',
    name: '',
    logo: '',
    description: '',
    member_count: 0,
    contact_email: '',
    contact_phone: '',
    contact_address: '',
    province: '',
    website: '',
    facebook_link: '',
    zalo_link: '',
    created_at: new Date(),
    status: 'pending',
};
const statusOptions = [
    { title: 'Đang chờ', value: 'pending' },
    { title: 'Đã phê duyệt', value: 'approved' },
    { title: 'Bị từ chối', value: 'rejected' }
];

const headers = [
    { title: 'STT', align: 'center', sortable: false, value: 'index' },
    { title: 'Tên Câu Lạc Bộ', align: 'start', sortable: true, value: 'name' },
    { title: 'Người Dùng', align: 'start', sortable: true, value: 'user_name' },
    { title: 'Trạng Thái', align: 'center', sortable: false, value: 'status' },
    { title: 'Xem Chi Tiết', align: 'center', sortable: false, value: 'details' },
    { title: 'Hành Động', align: 'center', sortable: false, value: 'actions' },
];

const filteredClubs = computed(() => {
    return clubs.value.filter(club => 
        club.name.toLowerCase().includes(search.value.toLowerCase())
    );
});

const formTitle = computed(() => (editedIndex.value === -1 ? 'Thêm Câu Lạc Bộ' : 'Chỉnh Sửa Câu Lạc Bộ'));

const openAddDialog = () => {
    editedIndex.value = -1;
    editedItem.value = { ...defaultItem };
    dialog.value = true;
};

const editClub = (item) => {
    editedIndex.value = clubs.value.indexOf(item);
    editedItem.value = { ...item };
    dialog.value = true;
};

const viewDetails = (item) => {
    selectedClub.value = { ...item };
    detailsDialog.value = true;
};

const closeDetailsDialog = () => {
    detailsDialog.value = false;
    selectedClub.value = {};
};

const closeDialog = () => {
    dialog.value = false;
    editedItem.value = { ...defaultItem };
    editedIndex.value = -1;
};

const saveClub = () => {
    if (editedIndex.value > -1) {
        Object.assign(clubs.value[editedIndex.value], editedItem.value);
        showNotification('Câu lạc bộ đã được cập nhật thành công!', 'success');
    } else {
        editedItem.value.id = clubs.value.length + 1;
        clubs.value.push(editedItem.value);
        showNotification('Câu lạc bộ mới đã được thêm thành công!', 'success');
    }
    closeDialog();
};

const confirmDelete = (item) => {
    editedIndex.value = clubs.value.indexOf(item);
    editedItem.value = { ...item };
    deleteDialog.value = true;
};

const deleteClub = () => {
    clubs.value.splice(editedIndex.value, 1);
    closeDeleteDialog();
    showNotification('Câu lạc bộ đã được xóa thành công!', 'success');
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
    // Filtering is handled by the computed property filteredClubs
};

const getUserName = (userId) => {
    const user = users.find(u => u.id === userId);
    return user ? user.name : 'N/A';
};
</script>

<style scoped>
.v-data-table ::v-deep th {
    font-weight: bold !important;
}
</style>