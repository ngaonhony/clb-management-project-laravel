class NotificationModel {
  final int id;
  final String title;
  final String content;
  final DateTime time;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.content,
    required this.time,
    this.isRead = false,
  });
}

// Sample data for notifications
List<NotificationModel> dummyNotifications = [
  NotificationModel(
    id: 1,
    title: "Khuyến mãi đặc biệt",
    content:
        "Chúng tôi có chương trình khuyến mãi đặc biệt dành cho tất cả khách hàng trong tháng này. Giảm giá 50% cho tất cả sản phẩm mới và miễn phí vận chuyển cho đơn hàng trên 500.000 VND. Chương trình kéo dài từ ngày 01/03/2025 đến hết ngày 15/03/2025.",
    time: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  NotificationModel(
    id: 2,
    title: "Cập nhật hệ thống",
    content:
        "Hệ thống sẽ được nâng cấp vào ngày mai từ 22:00 đến 23:00. Trong thời gian này, bạn sẽ không thể truy cập vào ứng dụng. Xin lỗi vì sự bất tiện này!",
    time: DateTime.now().subtract(const Duration(days: 1)),
  ),
  NotificationModel(
    id: 3,
    title: "Đơn hàng đã được xác nhận",
    content:
        "Đơn hàng #123456 của bạn đã được xác nhận và đang được chuẩn bị giao hàng. Dự kiến đơn hàng sẽ được giao trong vòng 2-3 ngày tới. Cảm ơn bạn đã mua sắm cùng chúng tôi!",
    time: DateTime.now().subtract(const Duration(days: 3)),
  ),
  NotificationModel(
    id: 4,
    title: "Mã giảm giá mới",
    content:
        "Bạn có một mã giảm giá mới: WELCOME2025. Áp dụng cho đơn hàng đầu tiên, giảm 20% tối đa 100.000 VND. Hạn sử dụng đến hết ngày 31/03/2025.",
    time: DateTime.now().subtract(const Duration(days: 7)),
  ),
  NotificationModel(
    id: 5,
    title: "Sản phẩm mới ra mắt",
    content:
        "Chúng tôi vừa ra mắt dòng sản phẩm mới nhất với nhiều tính năng đột phá. Hãy ghé thăm ứng dụng để khám phá ngay hôm nay! Đặc biệt có ưu đãi dành cho 100 khách hàng đầu tiên đặt mua sản phẩm mới.",
    time: DateTime.now().subtract(const Duration(days: 14)),
  ),
  NotificationModel(
    id: 6,
    title: "Nhắc nhở thanh toán",
    content:
        "Đơn hàng #123789 của bạn đang chờ thanh toán. Vui lòng hoàn tất thanh toán trong vòng 24 giờ để đảm bảo đơn hàng được xử lý đúng hạn.",
    time: DateTime.now().subtract(const Duration(days: 20)),
  ),
  NotificationModel(
    id: 7,
    title: "Thông báo bảo trì",
    content:
        "Ứng dụng sẽ được bảo trì định kỳ vào ngày Chủ Nhật hàng tuần từ 23:00 đến 01:00 sáng hôm sau. Trong thời gian này, một số tính năng có thể không hoạt động ổn định.",
    time: DateTime.now().subtract(const Duration(days: 30, hours: 5)),
  ),
];
