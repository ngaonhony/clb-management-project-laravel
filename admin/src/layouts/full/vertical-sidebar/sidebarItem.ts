
export interface menu {
    header?: string;
    title?: string;
    icon?: any;
    to?: string;
    chip?: string;
    BgColor?: string;
    chipBgColor?: string;
    chipColor?: string;
    chipVariant?: string;
    chipIcon?: string;
    children?: menu[];
    disabled?: boolean;
    type?: string;
    subCaption?: string;
}

const sidebarItem: menu[] = [
    { header: 'Home' },
    {
        title: 'Dashboard',
        icon: 'widget-add-line-duotone',
        to: '/'
    },
    { header: 'Management' },
    {
        title: 'User Management',
        icon: 'user-bold',
        to: '/user-management-page'
    },
    {
        title: 'Category Management',
        icon: 'login-3-line-duotone',
        to: '/category-management-page'
    },
    {
        title: 'CLB Management',
        icon: 'login-3-line-duotone',
        to: '/clb-management-page'
    },
    {
        title: 'Event Management',
        icon: 'mdi:event-available',
        to: '/event-management-page'
    },
    {
        title: 'Feedback Management',
        to: '/feedback-management-page'
    },
    {
        title: 'Blog Management',
        icon: 'login-3-line-duotone',
        to: '/blog-management-page'
    },
    { header: 'auth' },
    {
        title: 'Login',
        icon: 'login-3-line-duotone',
        to: '/auth/login'
    },
];

export default sidebarItem;

