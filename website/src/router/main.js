import MainLayout from "../layouts/main.vue";
import Home from "../pages/home.vue"
import Event from "../pages/EventPage.vue";
import EventList from "../pages/EventListPage.vue";
import Club from "../pages/ClubPage.vue";
import MyClub from "../pages/ClubManagement.vue";
import Blog from "../pages/BlogListPage.vue";
import Login from "../pages/Login.vue";
import Register from "../pages/Register.vue";

const main = [
    {
        path: "/",
        component: MainLayout,
        children: [
            {
                path: "",
                component: Home,
            },
            {
                path: "detail-event-page",
                component: Event,
            },
            {
                path: "detail-club-page",
                component: Club,
            },
            {
                path: "blog-list-page",
                component: Blog,
            },
            {
                path: "event-list-page",
                component: EventList,
            },
            {
                path: "manage-club-page",
                component: MyClub,
            },
            {
                path: "login",
                component: Login,
            },
            {
                path: "register",
                component: Register,
            },
        ]
    }
]

export default main;