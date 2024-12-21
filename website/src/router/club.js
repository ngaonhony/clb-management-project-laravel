import ClubManageLayout from "../layouts/ClubManage.vue";
import Dashboard from "../pages/ClubManage/Dashboard.vue";
import InfoClub from "../pages/ClubManage/ClubInfo.vue";
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
                component: Dashboard,
            },
            {
                path: "update-info-club",
                component: InfoClub,
            },
            {
                path: "quan-ly-trang-dai-dien",
                component: Introduce,
            },
            {
                path: "quan-ly-thanh-vien",
                component: Member,
            },
            {
                path: "quan-ly-su-kien",
                component: Event,
            },
            {
                path: "quan-ly-blog",
                component: Blog,
            }
        ]
    }
];

export default admin;