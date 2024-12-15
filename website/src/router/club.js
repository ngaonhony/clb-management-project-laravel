import ClubManageLayout from "../layouts/ClubManage.vue";
import Dashboard from "../pages/ClubManage/Dashboard.vue";
import Introduce from "../pages/ClubManage/Introduce.vue";

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
            }
        ]
    }
];

export default admin;