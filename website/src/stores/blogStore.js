import { defineStore } from 'pinia';
import BlogService from '../services/blog';

export const useBlogStore = defineStore('blog', {
    state: () => ({
        blogs: [],
        currentBlog: null,
        loading: false,
        error: null
    }),

    getters: {
        getBlogById: (state) => (id) => {
            return state.blogs.find(blog => blog.id === id);
        }
    },

    actions: {
        async fetchBlogs() {
            this.loading = true;
            try {
                const data = await BlogService.getAllBlogs();
                this.blogs = data;
                this.error = null;
            } catch (error) {
                this.error = error.message;
                console.error('Error fetching blogs:', error);
            } finally {
                this.loading = false;
            }
        },

        async fetchBlogById(id) {
            this.loading = true;
            try {
                const data = await BlogService.getBlogById(id);
                this.currentBlog = data;
                this.error = null;
            } catch (error) {
                this.error = error.message;
                console.error('Error fetching blog:', error);
            } finally {
                this.loading = false;
            }
        },

        async createBlog(blogData) {
            this.loading = true;
            try {
                const data = await BlogService.createBlog(blogData);
                this.blogs.push(data);
                this.error = null;
                return data;
            } catch (error) {
                this.error = error.message;
                console.error('Error creating blog:', error);
                throw error;
            } finally {
                this.loading = false;
            }
        },

        async updateBlog(id, blogData) {
            this.loading = true;
            try {
                const data = await BlogService.updateBlog(id, blogData);
                const index = this.blogs.findIndex(blog => blog.id === id);
                if (index !== -1) {
                    this.blogs[index] = data;
                }
                this.error = null;
                return data;
            } catch (error) {
                this.error = error.message;
                console.error('Error updating blog:', error);
                throw error;
            } finally {
                this.loading = false;
            }
        },

        async deleteBlog(id) {
            this.loading = true;
            try {
                await BlogService.deleteBlog(id);
                this.blogs = this.blogs.filter(blog => blog.id !== id);
                this.error = null;
            } catch (error) {
                this.error = error.message;
                console.error('Error deleting blog:', error);
                throw error;
            } finally {
                this.loading = false;
            }
        }
    }
}); 