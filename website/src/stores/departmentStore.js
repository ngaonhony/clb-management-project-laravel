import { defineStore } from 'pinia';
import DepartmentService from '../services/department';
const userData = JSON.parse(localStorage.getItem('user'));
const userId = userData?.id;
export const useDepartmentStore = defineStore('department', {
    state: () => ({
        departments: [],
        clubDepartments: null,
        currentDepartment: null,
        loading: false,
        error: null,
        userRole: {
            owner_id: null,
            id: null,
            name: null,
            description: null,
            manage_clubs: 0,
            manage_events: 0,
            manage_members: 0,
            manage_blogs: 0,
            manage_feedback: 0
        },
    }),

    getters: {
        getDepartmentById: (state) => (id) => {
            return state.departments.find(dept => dept.id === id);
        },
        
        // Retrieve user ID from localStorage

        // Check if user is club owner
        isClubOwner: (state) => {
            return state.userRole.owner_id === userId;
        },
        
        // Check permissions for specific features
        canManageClubs: (state) => {
            return state.userRole.owner_id === userId || state.userRole.manage_clubs === 1;
        },
        
        canManageEvents: (state) => {
            return state.userRole.owner_id === userId || state.userRole.manage_events === 1;
        },
        
        canManageMembers: (state) => {
            return state.userRole.owner_id === userId || state.userRole.manage_members === 1;
        },
        
        canManageBlogs: (state) => {
            return state.userRole.owner_id === userId || state.userRole.manage_blogs === 1;
        },
        
        canManageFeedback: (state) => {
            return state.userRole.owner_id === userId || state.userRole.manage_feedback === 1;
        }
    },

    actions: {
        async fetchDepartmentById(id) {
            this.loading = true;
            try {
                const data = await DepartmentService.getDepartmentById(id);
                this.currentDepartment = data;
                this.error = null;
                return data;
            } catch (error) {
                this.error = error.message;
                console.error('Error fetching department:', error);
                throw error;
            } finally {
                this.loading = false;
            }
        },

        async createDepartment(departmentData) {
            this.loading = true;
            try {
                const data = await DepartmentService.createDepartment(departmentData);
                this.departments.push(data);
                this.error = null;
                return data;
            } catch (error) {
                this.error = error.message;
                console.error('Error creating department:', error);
                throw error;
            } finally {
                this.loading = false;
            }
        },

        async updateDepartment(id, departmentData) {
            this.loading = true;
            try {
                const data = await DepartmentService.updateDepartment(id, departmentData);
                const index = this.departments.findIndex(dept => dept.id === id);
                if (index !== -1) {
                    this.departments[index] = data;
                }
                this.error = null;
                return data;
            } catch (error) {
                this.error = error.message;
                console.error('Error updating department:', error);
                throw error;
            } finally {
                this.loading = false;
            }
        },

        async deleteDepartment(id) {
            this.loading = true;
            try {
                await DepartmentService.deleteDepartment(id);
                this.departments = this.departments.filter(dept => dept.id !== id);
                this.error = null;
            } catch (error) {
                this.error = error.message;
                console.error('Error deleting department:', error);
                throw error;
            } finally {
                this.loading = false;
            }
        },

        async fetchClubDepartments(clubId) {
            this.loading = true;
            try {
                const data = await DepartmentService.getAllDepartmentsClub(clubId);
                this.clubDepartments = data;
                this.error = null;
                return data;
            } catch (error) {
                this.error = error.message;
                console.error('Error fetching club departments:', error);
                throw error;
            } finally {
                this.loading = false;
            }
        },

        async checkUserDepartment(clubId) {
            this.loading = true;
            try {
                const data = await DepartmentService.checkUserDepartment(clubId);
                this.userRole = data;
                console.log('User role:', this.userRole); // Log the user role
                this.error = null;
                return data;
            } catch (error) {
                this.error = error.message;
                console.error('Error checking user department:', error);
                throw error;
            } finally {
                this.loading = false;
            }
        }
    }
});