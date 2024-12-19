import MainLayout from "../layouts/main.vue";
import Home from "../pages/home.vue";
import ManageClb from "../pages/ManageClub.vue";
import Event from "../pages/Event.vue";
import Blog from "../pages/Blog.vue"

const main = [
    {
        path: "/",
        component: MainLayout,
        children: [
            {
                path: "",
                name: "home",
                component: Home,
            },
            {
                path: "quan-ly-clb",
                name: "manageclub",
                component: ManageClb,
            },
            {
                path: "event",
                name: "event",
                component: Event,
            },
            {
                path: "blog",
                name: "blog",
                component: Blog,
            },
        ]
    }
]

export default main;