import ManageMemberLayout from "../layouts/ManageMember.vue";
import ManageMemberPage from "../pages/ManageMember.vue";

const admin = [
    {
        path: "/clb",
        component: ManageMemberLayout,
        children: [
            {
                path: "dashboard",
                name: "admin-manage-member",
                component: ManageMemberPage,
            }
        ]
    }
];

export default admin;