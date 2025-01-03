# nckh

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

club_management/
├── android/
├── ios/
├── lib/
│   ├── core/
│   │   ├── api/
│   │   │   ├── api_client.dart       // Client để gọi API (Dio, http, etc.)
│   │   │   ├── api_endpoints.dart    // Định nghĩa các endpoint API
│   │   │   ├── api_service.dart      // Service để gọi API và xử lý response
│   │   │   └── api_interceptor.dart  // Interceptor để xử lý request/response (nếu cần)
│   │   ├── constants/
│   │   │   └── app_constants.dart    // Các hằng số của ứng dụng
│   │   ├── errors/
│   │   │   └── api_exceptions.dart   // Xử lý các lỗi từ API
│   │   ├── network/
│   │   │   └── network_info.dart     // Kiểm tra kết nối mạng
│   │   ├── utils/
│   │   │   ├── validators.dart       // Các hàm validate dữ liệu
│   │   │   └── helpers.dart          // Các hàm tiện ích
│   │   └── app.dart                  // Khởi tạo ứng dụng và các dịch vụ
│   ├── data/
│   │   ├── models/
│   │   │   ├── club_model.dart       // Model cho Club
│   │   │   ├── member_model.dart     // Model cho Member
│   │   │   └── event_model.dart      // Model cho Event
│   │   ├── repositories/
│   │   │   ├── club_repository.dart  // Repository để quản lý dữ liệu Club
│   │   │   ├── member_repository.dart // Repository để quản lý dữ liệu Member
│   │   │   └── event_repository.dart // Repository để quản lý dữ liệu Event
│   │   └── datasources/
│   │       ├── remote_datasource.dart // Kết nối API để lấy dữ liệu từ server
│   │       └── local_datasource.dart  // Kết nối local storage (nếu cần)
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── club_entity.dart      // Entity cho Club
│   │   │   ├── member_entity.dart    // Entity cho Member
│   │   │   └── event_entity.dart     // Entity cho Event
│   │   └── usecases/
│   │       ├── get_clubs.dart        // Usecase để lấy danh sách Club
│   │       ├── get_members.dart      // Usecase để lấy danh sách Member
│   │       └── get_events.dart       // Usecase để lấy danh sách Event
│   ├── presentation/
│   │   ├── screens/
│   │   │   ├── club/
│   │   │   │   ├── club_list_screen.dart   // Màn hình danh sách Club
│   │   │   │   ├── club_detail_screen.dart // Màn hình chi tiết Club
│   │   │   │   └── club_form_screen.dart   // Màn hình thêm/sửa Club
│   │   │   ├── member/
│   │   │   │   ├── member_list_screen.dart   // Màn hình danh sách Member
│   │   │   │   ├── member_detail_screen.dart // Màn hình chi tiết Member
│   │   │   │   └── member_form_screen.dart   // Màn hình thêm/sửa Member
│   │   │   ├── event/
│   │   │   │   ├── event_list_screen.dart   // Màn hình danh sách Event
│   │   │   │   ├── event_detail_screen.dart // Màn hình chi tiết Event
│   │   │   │   └── event_form_screen.dart   // Màn hình thêm/sửa Event
│   │   │   └── home_screen.dart             // Màn hình chính
│   │   ├── widgets/
│   │   │   ├── custom_app_bar.dart          // Custom AppBar
│   │   │   ├── custom_button.dart           // Custom Button
│   │   │   └── custom_text_field.dart       // Custom TextField
│   │   ├── providers/                       // State management (Provider, Riverpod, etc.)
│   │   │   ├── club_provider.dart           // Provider cho Club
│   │   │   ├── member_provider.dart         // Provider cho Member
│   │   │   └── event_provider.dart          // Provider cho Event
│   │   └── theme/
│   │       └── app_theme.dart               // Định nghĩa theme cho ứng dụng
│   ├── main.dart                            // File chính để khởi chạy ứng dụng
│   └── routes.dart                          // Định nghĩa các route trong ứng dụng
├── test/                                    // Thư mục chứa các file test
│   ├── data/
│   ├── domain/
│   ├── presentation/
│   └── core/
├── pubspec.yaml                             // File cấu hình dependencies
└── README.md                                // File mô tả dự án