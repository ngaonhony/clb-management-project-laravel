import { createWebHistory, createRouter } from 'vue-router'

import Admin from './admin'

const routes = [...Admin];

const router = createRouter({
    history: createWebHistory(),
    routes,
})

export default router;