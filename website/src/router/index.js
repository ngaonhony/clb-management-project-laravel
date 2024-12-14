import { createWebHistory, createRouter } from 'vue-router'

import Club from './club'

const routes = [...Club];

const router = createRouter({
    history: createWebHistory(),
    routes,
})

export default router;