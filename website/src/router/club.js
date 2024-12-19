import ClubManageLayout from "../layouts/ClubManage.vue";
import Dashboard from "../pages/ClubManage/Dashboard.vue";
import Introduce from "../pages/ClubManage/Introduce.vue";
import Event from "../pages/ClubManage/Event.vue";
import Member from "../pages/ClubManage/Member.vue";
import Blog from "../pages/ClubManage/Blog.vue";

const admin = [
    {
        path: "/clb",
        component: ClubManageLayout,
        children: [
            {
                path: "dashboard",
                name: "dashboard",
                component: Dashboard,
            },
            {
                path: "quan-ly-trang-dai-dien",
                name: "introduce",
                component: Introduce,
            },
            {
                path: "quan-ly-thanh-vien",
                name: "member",
                component: Member,
            },
            {
                path: "quan-ly-su-kien",
                name: "event-manage",
                component: Event,
            },
            {
                path: "quan-ly-blog",
                name: "blog-manage",
                component: Blog,
            }
        ]
    }
];

export default admin;