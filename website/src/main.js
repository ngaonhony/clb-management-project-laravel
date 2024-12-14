import { createApp } from 'vue';
import './assets/styles.css';
import App from './App.vue';
import router from './route'; // Nhập router

const app = createApp(App);
app.use(router); // Sử dụng router
app.mount('#app');