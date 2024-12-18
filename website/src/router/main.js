import MainLayout from "../layouts/main.vue";
import Home from "../pages/home.vue"

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
        ]
    }
]

export default main;