import { defineStore } from 'pinia';
import DepartmentService from '../services/department';

export const useDepartmentStore = defineStore('department', {
    state: () => ({
        departments: [],
        clubDepartments: [],
        selectedDepartment: null,
        isLoading: false,
        error: null
    }),

    getters: {
        getDepartmentById: (state) => (id) => {
            return state.departments.find(dept => dept.id === id);
        },
        
        getClubDepartments: (state) => {
            return state.clubDepartments;
        }
    },

    actions: {
        async fetchDepartments() {
            this.isLoading = true;
            this.error = null;
            
            try {
                const data = await DepartmentService.getAllDepartments();
                this.departments = data;
            } catch (error) {
                this.error = error.message;
                console.error('Error fetching departments:', error);
            } finally {
                this.isLoading = false;
            }
        },

        async fetchClubDepartments(clubId) {
            this.isLoading = true;
            this.error = null;
            
            try {
                const data = await DepartmentService.getAllDepartmentsClub(clubId);
                this.clubDepartments = data.departments || [];
                return this.clubDepartments;
            } catch (error) {
                this.error = error.message;
                console.error('Error fetching club departments:', error);
                throw error;
            } finally {
                this.isLoading = false;
            }
        },

        async fetchDepartmentById(id) {
            this.isLoading = true;
            this.error = null;
            
            try {
                const data = await DepartmentService.getDepartmentById(id);
                this.selectedDepartment = data;
                return data;
            } catch (error) {
                this.error = error.message;
                console.error('Error fetching department:', error);
                throw error;
            } finally {
                this.isLoading = false;
            }
        },

        async createDepartment(departmentData) {
            this.isLoading = true;
            this.error = null;
            
            try {
                const data = await DepartmentService.createDepartment(departmentData);
                this.departments.push(data);
                return data;
            } catch (error) {
                this.error = error.message;
                console.error('Error creating department:', error);
                throw error;
            } finally {
                this.isLoading = false;
            }
        },

        async updateDepartment(id, departmentData) {
            this.isLoading = true;
            this.error = null;
            
            try {
                const data = await DepartmentService.updateDepartment(id, departmentData);
                const index = this.departments.findIndex(dept => dept.id === id);
                if (index !== -1) {
                    this.departments[index] = data;
                }
                return data;
            } catch (error) {
                this.error = error.message;
                console.error('Error updating department:', error);
                throw error;
            } finally {
                this.isLoading = false;
            }
        },

        async deleteDepartment(id) {
            this.isLoading = true;
            this.error = null;
            
            try {
                await DepartmentService.deleteDepartment(id);
                this.departments = this.departments.filter(dept => dept.id !== id);
                this.clubDepartments = this.clubDepartments.filter(dept => dept.id !== id);
            } catch (error) {
                this.error = error.message;
                console.error('Error deleting department:', error);
                throw error;
            } finally {
                this.isLoading = false;
            }
        }
    }
}); 