--
-- Đang đổ dữ liệu cho bảng `categories`
--

INSERT INTO `categories` ( `name`, `description`, `type`, `status`) VALUES
('Học thuật', 'Chuyên môn', 'club', 'active'),
( 'Nghệ thuật', 'Sáng tạo', 'club', 'active'),
( 'Truyền thông', 'Báo trí', 'club', 'active'),
( 'Thể thao', 'Sức khỏe', 'club', 'active'),
( 'Kỹ năng', 'Giá trị', 'club', 'active'),
( 'Tình nguyện', 'Cộng đồng', 'club', 'active'),
( 'Ngoại ngữ', 'Văn hóa', 'club', 'active'),
( 'Thể thao', 'Giải trí', 'club', 'active'),
( 'Workshop', 'Học tập', 'event', 'active'),
( 'Âm nhạc', 'Tiết tấu', 'event', 'active'),
( 'Ẩm thực', 'Trải nghiệm', 'event', 'active'),
( 'Thể thao', 'Sức khỏe', 'event', 'active'),
( 'Sở thích', 'Giải trí', 'event', 'active'),
( 'Hoạt động', 'Cộng đồng', 'event', 'active'),
( 'Văn hóa', 'Lễ hội', 'event', 'active'),
( 'Nghề nghiệp', 'Định hướng', 'event', 'active'),
( 'Tin tức', 'Thông tin cập nhật', 'blog', 'active'),
( 'Thông tin tuyển sinh', 'Thông tin về tuyển sinh', 'blog', 'active'),
( 'Tư vấn chọn khối thi', 'Hướng dẫn chọn khối thi', 'blog', 'active'),
( 'Tư vấn chọn ngành', 'Hướng dẫn chọn ngành học', 'blog', 'active');

--
-- Đang đổ dữ liệu cho bảng `clubs`
--

INSERT INTO `users` ( `username`, `password`, `email`, `phone`, `gender`, `description`, `role`, `resetPasswordToken`, `resetPasswordExpires`, `email_verified`, `verification_token`, `created_at`, `updated_at`) VALUES
( 'admin_user', 'admin_password', 'admin@example.com', '1234567890', 'male', 'Administrator account', 'Admin', NULL, NULL, 1, NULL, '2025-03-18 06:26:30', '2025-03-18 06:26:30'),
( 'regular_user', 'user_password', 'user@example.com', '0987654321', 'female', 'Regular user account', 'User', NULL, NULL, 1, NULL, '2025-03-18 06:26:30', '2025-03-18 06:26:30');

INSERT INTO `clubs` ( `user_id`, `category_id`, `name`, `description`, `member_count`, `contact_email`, `contact_phone`, `contact_address`, `province`, `facebook_link`, `zalo_link`, `status`) VALUES
( 2, 1, 'Club ABC', NULL, 0, 'contact@clubabc.com', NULL, NULL, NULL, NULL, NULL, 'pending'),
( 1, 2, 'CLB Khởi nghiệp Đổi mới Sáng tạo Khoa học', 'Câu lạc bộ Khởi nghiệp Đổi mới Sáng tạo Khoa học - Trường Đại học Khoa học tự nhiên, ĐHQG-HCM (Science Innovation Startup Club HCMUS) ra đời với sứ mệnh truyền cảm hứng và thúc đẩy tinh thần khởi nghiệp đổi mới sáng tạo Khoa học công nghệ...', 25, 'sisc.hcmus@example.com', '0901234567', '123 Đường ABC, HCM', 'Hồ Chí Minh', 'https://facebook.com/sisc', NULL, 'active'),
( 1, 3, 'MUSIC IG CLUB (MIC)', 'Music Ig Club (MIC) là một trong những câu lạc bộ có thâm niên hoạt động lâu đời nhất của trường THPT Chuyên Nguyễn Huệ...', 70, 'mic.uel@example.com', '0907654321', '456 Đường DEF, HN', 'Hà Nội', 'https://facebook.com/mic', NULL, 'active'),
( 2, 8, 'SÁNG TẠO SỰ KIỆN TDTU', 'Cuộc thi "Sáng tạo Sự kiện mùa 4 năm 2025" là nơi để sinh viên thể hiện khả năng lên ý tưởng, lập kế hoạch và triển khai thực tế các sự kiện...', 10, 'tdtu.event@example.com', '0912345678', '789 Đường GHI, HCM', 'Hồ Chí Minh', 'https://facebook.com/tdtu', NULL, 'active'),
( 1, 9, 'CLB Âm nhạc Cổ điển Đại học Kinh tế Quốc Dân - NEU Philharmonic', 'CLB ÂM NHẠC CỔ ĐIỂN ĐẠI HỌC KINH TẾ QUỐC DÂN - NEU PHILHARMONIC là CLB Âm nhạc Cổ điển đầu tiên và duy nhất tại Đại học Kinh tế Quốc dân...', 100, NULL, NULL, NULL, 'Hà Nội', NULL, NULL, 'active'),
( 2, 9, 'Loang Lổ.', 'Loang Lổ. là dự án phi lợi nhuận đề cập đến những vấn đề xoay quanh các định kiến xã hội.', 70, 'loanglo@example.com', '0945678901', '102 Đường MNO, HN', 'Hà Nội', 'https://facebook.com/loanglo', NULL, 'active'),
( 2, 1, 'MEC MUSIC CLUB', 'Câu lạc bộ Âm nhạc Đại học Kinh tế Quốc dân - Sự gắn kết giữa âm nhạc và tâm hồn nghệ thuật.', 100, 'mecclub@example.com', '0956789012', '103 Đường PQR, HN', 'Hà Nội', 'https://facebook.com/mec', NULL, 'active'),
( 1, 3, 'Study Abroad Club - FTU', 'CLB Du học Trường Đại học Ngoại thương - SAC FTU tự hào là kênh thông tin chính thức về các vấn đề liên quan tới lĩnh vực du học...', 451, 'sac.ftu@example.com', '0967890123', '104 Đường STU, HN', 'Hà Nội', 'https://facebook.com/sac', NULL, 'active'),
( 1, 1, 'MEA Hanoi', 'MEA Hanoi là dự án tìm hiểu về những nét văn hóa, nghệ thuật đặc sắc của người dân Hà Nội thông qua lăng kính sắc màu.', 60, 'meahanoi@example.com', '0978901234', '105 Đường VWX, HN', 'Hà Nội', 'https://facebook.com/meahanoi', NULL, 'active'),
( 2, 4, 'VTAB Team', '"Link The Chain" là một dự án truyền thông trong khuôn khổ đồ án tốt nghiệp của nhóm sinh viên năm cuối ngành Truyền thông Đa phương tiện.', 4, 'vtabteam@example.com', '0989012345', '106 Đường YZA, HCM', 'Hồ Chí Minh', 'https://facebook.com/vtab', NULL, 'active'),
( 1, 2, 'Vietnam Through Lenses', 'Vietnam Through Lenses là dự án phi lợi nhuận làm về chủ đề văn hóa và nét sống trải dài khắp đất nước Việt Nam.', 50, 'vietnamlenses@example.com', '0990123456', '107 Đường ABC, HN', 'Hà Nội', 'https://facebook.com/vietnamlenses', NULL, 'active'),
( 2, 8, 'CLB Khoa học và Công nghệ', 'CLB tập trung vào nghiên cứu và phát triển các dự án ứng dụng khoa học và công nghệ.', 30, 'scienceclub@example.com', '0901234568', '108 Đường DEF, HCM', 'Hồ Chí Minh', 'https://facebook.com/scienceclub', NULL, 'active');

--
-- Đang đổ dữ liệu cho bảng `events`
--

INSERT INTO `events` ( `club_id`, `category_id`, `name`, `start_date`, `end_date`, `location`, `max_participants`, `registered_participants`, `content`, `status`) VALUES
( 1, 9, 'Event Name', '2025-01-15 10:00:00', '2025-01-15 12:00:00', 'Event Location', 100, 0, 'Description of the event', 'active'),
( 11, 16, 'CUỘC THI SÁNG TẠO CHIẾN LƯỢC TRUYỀN THÔNG S-MAZE 2025', '2025-04-15 00:00:00', '2025-04-16 00:00:00', NULL, 15, 0, 'Avatar của CLB Truyền thông Marketing tích hợp IMC', 'active'),
( 2, 11, 'Cuộc thi "Sáng tạo nội dung số - Digital Creatory 2025"', '2025-03-12 00:00:00', '2025-03-13 00:00:00', 'Số 669, Quốc lộ 1A, Phường Linh Xuân, Thủ Đức, Thành phố Hồ Chí Minh', 12, 0, 'Avatar của Marketing UEL Club', 'active'),
( 3, 15, 'Cuộc thi Khởi nghiệp Kinh Doanh - Mùa XI - 2025', '2025-02-16 00:00:00', '2025-02-18 00:00:00', 'Trường Đại học Kinh tế - Luật', 16, 0, 'Avatar của CLB GPA - Group of Potential Administrators (Quản trị Tiềm năng)', 'active'),
( 4, 14, 'Chuỗi sự kiện TDT Sport Science Reunion 2025 - "Lưu giữ khoảnh khắc"', '2025-04-15 00:00:00', '2025-04-17 00:00:00', 'Số 19 Nguyễn Hữu Thọ, P. Tân Phong, Q.7, TP.HCM', NULL, 0, 'Avatar của TDT Sport Science Reunion', 'active'),
( 5, 10, 'TEDx FTU 2025', '2025-03-09 00:00:00', '2025-03-10 00:00:00', '451/45C/9 Xô Viết Nghệ Tĩnh', NULL, 0, 'Avatar của Business & English Club - BEC FTU2', 'active'),
( 6, 15, 'Cuộc thi Auditing and Accounting Challenge - AAC', '2025-03-05 00:00:00', '2025-03-06 00:00:00', 'Học viện Tài chính', NULL, 0, 'Avatar của CLB Kế toán Kiểm toán viên A&A', 'active'),
( 7, 14, 'Cuộc thi Rocket to Business Development 2025', '2025-05-20 00:00:00', '2025-05-21 00:00:00', '207 Giải Phóng, Đồng Tâm, Quận Hai Bà Trưng, Hà Nội, Việt Nam', NULL, 0, 'Avatar của CLB Doanh Nhân Trẻ Tiên Phong Dynamic ĐH KTQD', 'active'),
( 8, 13, 'MINISHOW SAU CƠN MƯA', '2025-03-30 00:00:00', '2025-03-31 00:00:00', '153 Nguyễn Chí Thanh, Q5 TP.HCM', NULL, 0, 'Avatar của LUYẾN', 'active'),
( 9, 12, 'Hội trại Truyền thống Trường Đại học Ngoại thương Cơ sở II tại Thành phố Hồ Chí Minh', '2025-03-29 00:00:00', '2025-03-30 00:00:00', 'Xã Tân Kiều, huyện Tháp Mười, tỉnh Đồng Tháp', NULL, 0, 'Avatar của Hội trại Truyền thống Trường Đại học Ngoại thương Cơ sở II', 'active'),
( 10, 11, 'Viết tiếp câu chuyện', '0000-00-00 00:00:00', '2025-04-01 00:00:00', NULL, NULL, 0, 'Avatar của CLB Sách Papersane THPT Chuyên Trần Đại Nghĩa', 'active'),
( 11, 9, 'Sự kiện đặc biệt của CLB', '0000-00-00 00:00:00', '2025-06-01 00:00:00', NULL, NULL, 0, 'Thông tin chi tiết về sự kiện đặc biệt.', 'active');