import { defineStore } from 'pinia';
import DepartmentService from '../services/department';

export const useDepartmentStore = defineStore('department', {
    state: () => ({
        departments: [],
        currentDepartment: null,
        loading: false,
        error: null
    }),

    getters: {
        getDepartmentById: (state) => (id) => {
            return state.departments.find(dept => dept.id === id);
        }
    },

    actions: {
        async fetchDepartments() {
            this.loading = true;
            try {
                const data = await DepartmentService.getAllDepartments();
                this.departments = data;
                this.error = null;
            } catch (error) {
                this.error = error.message;
                console.error('Error fetching departments:', error);
            } finally {
                this.loading = false;
            }
        },

        async fetchDepartmentById(id) {
            this.loading = true;
            try {
                const data = await DepartmentService.getDepartmentById(id);
                this.currentDepartment = data;
                this.error = null;
            } catch (error) {
                this.error = error.message;
                console.error('Error fetching department:', error);
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
        }
    }
}); 