-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th3 18, 2025 lúc 08:54 AM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `clb-management-project`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `background_images`
--

CREATE TABLE `background_images` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `club_id` bigint(20) UNSIGNED DEFAULT NULL,
  `event_id` bigint(20) UNSIGNED DEFAULT NULL,
  `blog_id` bigint(20) UNSIGNED DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `video_url` varchar(255) DEFAULT NULL,
  `is_logo` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `blogs`
--

CREATE TABLE `blogs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `club_id` bigint(20) UNSIGNED NOT NULL,
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `content` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `categories`
--

CREATE TABLE `categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `categories`
--

INSERT INTO `categories` (`id`, `name`, `description`, `type`, `status`) VALUES
(1, 'Học thuật', 'Chuyên môn', 'club', 'active'),
(2, 'Nghệ thuật', 'Sáng tạo', 'club', 'active'),
(3, 'Truyền thông', 'Báo trí', 'club', 'active'),
(4, 'Thể thao', 'Sức khỏe', 'club', 'active'),
(5, 'Kỹ năng', 'Giá trị', 'club', 'active'),
(6, 'Tình nguyện', 'Cộng đồng', 'club', 'active'),
(7, 'Ngoại ngữ', 'Văn hóa', 'club', 'active'),
(8, 'Thể thao', 'Giải trí', 'club', 'active'),
(9, 'Workshop', 'Học tập', 'event', 'active'),
(10, 'Âm nhạc', 'Tiết tấu', 'event', 'active'),
(11, 'Ẩm thực', 'Trải nghiệm', 'event', 'active'),
(12, 'Thể thao', 'Sức khỏe', 'event', 'active'),
(13, 'Sở thích', 'Giải trí', 'event', 'active'),
(14, 'Hoạt động', 'Cộng đồng', 'event', 'active'),
(15, 'Văn hóa', 'Lễ hội', 'event', 'active'),
(16, 'Nghề nghiệp', 'Định hướng', 'event', 'active'),
(17, 'Tin tức', 'Thông tin cập nhật', 'blog', 'active'),
(18, 'Thông tin tuyển sinh', 'Thông tin về tuyển sinh', 'blog', 'active'),
(19, 'Tư vấn chọn khối thi', 'Hướng dẫn chọn khối thi', 'blog', 'active'),
(20, 'Tư vấn chọn ngành', 'Hướng dẫn chọn ngành học', 'blog', 'active');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `clubs`
--

CREATE TABLE `clubs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `member_count` int(11) NOT NULL DEFAULT 0,
  `contact_email` varchar(255) DEFAULT NULL,
  `contact_phone` varchar(255) DEFAULT NULL,
  `contact_address` varchar(255) DEFAULT NULL,
  `province` varchar(255) DEFAULT NULL,
  `facebook_link` varchar(255) DEFAULT NULL,
  `zalo_link` varchar(255) DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `clubs`
--

INSERT INTO `clubs` (`id`, `user_id`, `category_id`, `name`, `description`, `member_count`, `contact_email`, `contact_phone`, `contact_address`, `province`, `facebook_link`, `zalo_link`, `status`) VALUES
(1, 2, 1, 'Club ABC', NULL, 0, 'contact@clubabc.com', NULL, NULL, NULL, NULL, NULL, 'pending'),
(2, 1, 2, 'CLB Khởi nghiệp Đổi mới Sáng tạo Khoa học', 'Câu lạc bộ Khởi nghiệp Đổi mới Sáng tạo Khoa học - Trường Đại học Khoa học tự nhiên, ĐHQG-HCM (Science Innovation Startup Club HCMUS) ra đời với sứ mệnh truyền cảm hứng và thúc đẩy tinh thần khởi nghiệp đổi mới sáng tạo Khoa học công nghệ...', 25, 'sisc.hcmus@example.com', '0901234567', '123 Đường ABC, HCM', 'Hồ Chí Minh', 'https://facebook.com/sisc', NULL, 'active'),
(3, 1, 3, 'MUSIC IG CLUB (MIC)', 'Music Ig Club (MIC) là một trong những câu lạc bộ có thâm niên hoạt động lâu đời nhất của trường THPT Chuyên Nguyễn Huệ...', 70, 'mic.uel@example.com', '0907654321', '456 Đường DEF, HN', 'Hà Nội', 'https://facebook.com/mic', NULL, 'active'),
(4, 2, 8, 'SÁNG TẠO SỰ KIỆN TDTU', 'Cuộc thi “Sáng tạo Sự kiện mùa 4 năm 2025” là nơi để sinh viên thể hiện khả năng lên ý tưởng, lập kế hoạch và triển khai thực tế các sự kiện...', 10, 'tdtu.event@example.com', '0912345678', '789 Đường GHI, HCM', 'Hồ Chí Minh', 'https://facebook.com/tdtu', NULL, 'active'),
(5, 1, 9, 'CLB Âm nhạc Cổ điển Đại học Kinh tế Quốc Dân - NEU Philharmonic', 'CLB ÂM NHẠC CỔ ĐIỂN ĐẠI HỌC KINH TẾ QUỐC DÂN - NEU PHILHARMONIC là CLB Âm nhạc Cổ điển đầu tiên và duy nhất tại Đại học Kinh tế Quốc dân...', 100, NULL, NULL, NULL, 'Hà Nội', NULL, NULL, 'active'),
(6, 2, 10, 'Loang Lổ.', 'Loang Lổ. là dự án phi lợi nhuận đề cập đến những vấn đề xoay quanh các định kiến xã hội.', 70, 'loanglo@example.com', '0945678901', '102 Đường MNO, HN', 'Hà Nội', 'https://facebook.com/loanglo', NULL, 'active'),
(7, 2, 11, 'MEC MUSIC CLUB', 'Câu lạc bộ Âm nhạc Đại học Kinh tế Quốc dân - Sự gắn kết giữa âm nhạc và tâm hồn nghệ thuật.', 100, 'mecclub@example.com', '0956789012', '103 Đường PQR, HN', 'Hà Nội', 'https://facebook.com/mec', NULL, 'active'),
(8, 1, 13, 'Study Abroad Club - FTU', 'CLB Du học Trường Đại học Ngoại thương - SAC FTU tự hào là kênh thông tin chính thức về các vấn đề liên quan tới lĩnh vực du học...', 451, 'sac.ftu@example.com', '0967890123', '104 Đường STU, HN', 'Hà Nội', 'https://facebook.com/sac', NULL, 'active'),
(9, 1, 12, 'MEA Hanoi', 'MEA Hanoi là dự án tìm hiểu về những nét văn hóa, nghệ thuật đặc sắc của người dân Hà Nội thông qua lăng kính sắc màu.', 60, 'meahanoi@example.com', '0978901234', '105 Đường VWX, HN', 'Hà Nội', 'https://facebook.com/meahanoi', NULL, 'active'),
(10, 2, 14, 'VTAB Team', '“Link The Chain” là một dự án truyền thông trong khuôn khổ đồ án tốt nghiệp của nhóm sinh viên năm cuối ngành Truyền thông Đa phương tiện.', 4, 'vtabteam@example.com', '0989012345', '106 Đường YZA, HCM', 'Hồ Chí Minh', 'https://facebook.com/vtab', NULL, 'active'),
(11, 1, 12, 'Vietnam Through Lenses', 'Vietnam Through Lenses là dự án phi lợi nhuận làm về chủ đề văn hóa và nét sống trải dài khắp đất nước Việt Nam.', 50, 'vietnamlenses@example.com', '0990123456', '107 Đường ABC, HN', 'Hà Nội', 'https://facebook.com/vietnamlenses', NULL, 'active'),
(12, 2, 18, 'CLB Khoa học và Công nghệ', 'CLB tập trung vào nghiên cứu và phát triển các dự án ứng dụng khoa học và công nghệ.', 30, 'scienceclub@example.com', '0901234568', '108 Đường DEF, HCM', 'Hồ Chí Minh', 'https://facebook.com/scienceclub', NULL, 'active');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `departments`
--

CREATE TABLE `departments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `club_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `manage_events` tinyint(1) NOT NULL DEFAULT 0,
  `create_events` tinyint(1) NOT NULL DEFAULT 0,
  `manage_members` tinyint(1) NOT NULL DEFAULT 0,
  `view_notifications` tinyint(1) NOT NULL DEFAULT 0,
  `create_blogs` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `events`
--

CREATE TABLE `events` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `club_id` bigint(20) UNSIGNED NOT NULL,
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  `max_participants` int(11) DEFAULT NULL,
  `registered_participants` int(11) NOT NULL DEFAULT 0,
  `content` text DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `events`
--

INSERT INTO `events` (`id`, `club_id`, `category_id`, `name`, `start_date`, `end_date`, `location`, `max_participants`, `registered_participants`, `content`, `status`) VALUES
(1, 1, 17, 'Event Name', '2025-01-15 10:00:00', '2025-01-15 12:00:00', 'Event Location', 100, 0, 'Description of the event', 'active'),
(2, 11, 16, 'CUỘC THI SÁNG TẠO CHIẾN LƯỢC TRUYỀN THÔNG S-MAZE 2025', '2025-04-15 00:00:00', '2025-04-16 00:00:00', NULL, 15, 0, 'Avatar của CLB Truyền thông Marketing tích hợp IMC', 'active'),
(3, 2, 11, 'Cuộc thi “Sáng tạo nội dung số - Digital Creatory 2025”', '2025-03-12 00:00:00', '2025-03-13 00:00:00', 'Số 669, Quốc lộ 1A, Phường Linh Xuân, Thủ Đức, Thành phố Hồ Chí Minh', 12, 0, 'Avatar của Marketing UEL Club', 'active'),
(4, 3, 15, 'Cuộc thi Khởi nghiệp Kinh Doanh - Mùa XI - 2025', '2025-02-16 00:00:00', '2025-02-18 00:00:00', 'Trường Đại học Kinh tế - Luật', 16, 0, 'Avatar của CLB GPA - Group of Potential Administrators (Quản trị Tiềm năng)', 'active'),
(5, 4, 14, 'Chuỗi sự kiện TDT Sport Science Reunion 2025 - \"Lưu giữ khoảnh khắc\"', '2025-04-15 00:00:00', '2025-04-17 00:00:00', 'Số 19 Nguyễn Hữu Thọ, P. Tân Phong, Q.7, TP.HCM', NULL, 0, 'Avatar của TDT Sport Science Reunion', 'active'),
(6, 5, 20, 'TEDx FTU 2025', '2025-03-09 00:00:00', '2025-03-10 00:00:00', '451/45C/9 Xô Viết Nghệ Tĩnh', NULL, 0, 'Avatar của Business & English Club - BEC FTU2', 'active'),
(7, 6, 15, 'Cuộc thi Auditing and Accounting Challenge - AAC', '2025-03-05 00:00:00', '2025-03-06 00:00:00', 'Học viện Tài chính', NULL, 0, 'Avatar của CLB Kế toán Kiểm toán viên A&A', 'active'),
(8, 7, 14, 'Cuộc thi Rocket to Business Development 2025', '2025-05-20 00:00:00', '2025-05-21 00:00:00', '207 Giải Phóng, Đồng Tâm, Quận Hai Bà Trưng, Hà Nội, Việt Nam', NULL, 0, 'Avatar của CLB Doanh Nhân Trẻ Tiên Phong Dynamic ĐH KTQD', 'active'),
(9, 8, 17, 'MINISHOW SAU CƠN MƯA', '2025-03-30 00:00:00', '2025-03-31 00:00:00', '153 Nguyễn Chí Thanh, Q5 TP.HCM', NULL, 0, 'Avatar của LUYẾN', 'active'),
(10, 9, 12, 'Hội trại Truyền thống Trường Đại học Ngoại thương Cơ sở II tại Thành phố Hồ Chí Minh', '2025-03-29 00:00:00', '2025-03-30 00:00:00', 'Xã Tân Kiều, huyện Tháp Mười, tỉnh Đồng Tháp', NULL, 0, 'Avatar của Hội trại Truyền thống Trường Đại học Ngoại thương Cơ sở II', 'active'),
(11, 10, 11, 'Viết tiếp câu chuyện', '0000-00-00 00:00:00', '2025-04-01 00:00:00', NULL, NULL, 0, 'Avatar của CLB Sách Papersane THPT Chuyên Trần Đại Nghĩa', 'active'),
(12, 11, 19, 'Sự kiện đặc biệt của CLB', '0000-00-00 00:00:00', '2025-06-01 00:00:00', NULL, NULL, 0, 'Thông tin chi tiết về sự kiện đặc biệt.', 'active');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `feedback`
--

CREATE TABLE `feedback` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `club_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `mobile` varchar(255) NOT NULL,
  `comment` text DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `join_requests`
--

CREATE TABLE `join_requests` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `club_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `event_id` bigint(20) UNSIGNED NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(3, '2024_12_15_000001_create_categories_table', 1),
(4, '2024_12_15_000002_create_clubs_table', 1),
(5, '2024_12_15_000003_create_events_table', 1),
(6, '2024_12_15_000004_create_departments_table', 1),
(7, '2024_12_15_000005_create_feedbacks_table', 1),
(8, '2024_12_15_000006_create_blogs_table', 1),
(9, '2024_12_15_185815_create_join_requests_table', 1),
(10, '2024_12_15_185925_create_background_images_table', 1),
(11, '2025_03_17_160331_create_notifications_table', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `notifications`
--

CREATE TABLE `notifications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `notifiable_id` bigint(20) UNSIGNED NOT NULL,
  `data` text NOT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `gender` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `role` varchar(255) DEFAULT 'User',
  `resetPasswordToken` varchar(255) DEFAULT NULL,
  `resetPasswordExpires` timestamp NULL DEFAULT NULL,
  `email_verified` tinyint(1) NOT NULL DEFAULT 0,
  `verification_token` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `gender`, `description`, `role`, `resetPasswordToken`, `resetPasswordExpires`, `email_verified`, `verification_token`, `created_at`, `updated_at`) VALUES
(1, 'admin_user', 'admin_password', 'admin@example.com', '1234567890', 'male', 'Administrator account', 'admin', NULL, NULL, 1, NULL, '2025-03-18 06:26:30', '2025-03-18 06:26:30'),
(2, 'regular_user', 'user_password', 'user@example.com', '0987654321', 'female', 'Regular user account', 'user', NULL, NULL, 1, NULL, '2025-03-18 06:26:30', '2025-03-18 06:26:30');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `background_images`
--
ALTER TABLE `background_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `background_images_user_id_foreign` (`user_id`),
  ADD KEY `background_images_club_id_foreign` (`club_id`),
  ADD KEY `background_images_event_id_foreign` (`event_id`),
  ADD KEY `background_images_blog_id_foreign` (`blog_id`);

--
-- Chỉ mục cho bảng `blogs`
--
ALTER TABLE `blogs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `blogs_club_id_foreign` (`club_id`),
  ADD KEY `blogs_category_id_foreign` (`category_id`);

--
-- Chỉ mục cho bảng `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `clubs`
--
ALTER TABLE `clubs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `clubs_user_id_foreign` (`user_id`),
  ADD KEY `clubs_category_id_foreign` (`category_id`);

--
-- Chỉ mục cho bảng `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `departments_club_id_foreign` (`club_id`),
  ADD KEY `departments_user_id_foreign` (`user_id`);

--
-- Chỉ mục cho bảng `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `events_club_id_foreign` (`club_id`),
  ADD KEY `events_category_id_foreign` (`category_id`);

--
-- Chỉ mục cho bảng `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`id`),
  ADD KEY `feedback_club_id_foreign` (`club_id`);

--
-- Chỉ mục cho bảng `join_requests`
--
ALTER TABLE `join_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `join_requests_club_id_foreign` (`club_id`),
  ADD KEY `join_requests_user_id_foreign` (`user_id`),
  ADD KEY `join_requests_event_id_foreign` (`event_id`);

--
-- Chỉ mục cho bảng `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_username_unique` (`username`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD UNIQUE KEY `users_phone_unique` (`phone`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `background_images`
--
ALTER TABLE `background_images`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `blogs`
--
ALTER TABLE `blogs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT cho bảng `clubs`
--
ALTER TABLE `clubs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT cho bảng `departments`
--
ALTER TABLE `departments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `events`
--
ALTER TABLE `events`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT cho bảng `feedback`
--
ALTER TABLE `feedback`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `join_requests`
--
ALTER TABLE `join_requests`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT cho bảng `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `background_images`
--
ALTER TABLE `background_images`
  ADD CONSTRAINT `background_images_blog_id_foreign` FOREIGN KEY (`blog_id`) REFERENCES `blogs` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `background_images_club_id_foreign` FOREIGN KEY (`club_id`) REFERENCES `clubs` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `background_images_event_id_foreign` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `background_images_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Các ràng buộc cho bảng `blogs`
--
ALTER TABLE `blogs`
  ADD CONSTRAINT `blogs_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`),
  ADD CONSTRAINT `blogs_club_id_foreign` FOREIGN KEY (`club_id`) REFERENCES `clubs` (`id`);

--
-- Các ràng buộc cho bảng `clubs`
--
ALTER TABLE `clubs`
  ADD CONSTRAINT `clubs_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`),
  ADD CONSTRAINT `clubs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Các ràng buộc cho bảng `departments`
--
ALTER TABLE `departments`
  ADD CONSTRAINT `departments_club_id_foreign` FOREIGN KEY (`club_id`) REFERENCES `clubs` (`id`),
  ADD CONSTRAINT `departments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Các ràng buộc cho bảng `events`
--
ALTER TABLE `events`
  ADD CONSTRAINT `events_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`),
  ADD CONSTRAINT `events_club_id_foreign` FOREIGN KEY (`club_id`) REFERENCES `clubs` (`id`);

--
-- Các ràng buộc cho bảng `feedback`
--
ALTER TABLE `feedback`
  ADD CONSTRAINT `feedback_club_id_foreign` FOREIGN KEY (`club_id`) REFERENCES `clubs` (`id`);

--
-- Các ràng buộc cho bảng `join_requests`
--
ALTER TABLE `join_requests`
  ADD CONSTRAINT `join_requests_club_id_foreign` FOREIGN KEY (`club_id`) REFERENCES `clubs` (`id`),
  ADD CONSTRAINT `join_requests_event_id_foreign` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`),
  ADD CONSTRAINT `join_requests_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
