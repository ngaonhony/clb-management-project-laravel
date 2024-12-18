import { createWebHistory, createRouter } from 'vue-router'

import Club from './club'
import Main from './main'

const routes = [...Club, ...Main];

const router = createRouter({
    history: createWebHistory(),
    routes,
})

export default router;