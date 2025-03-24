import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notification_provider.dart';
import 'badge_icon.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _shakeAnimation = Tween<double>(begin: -1, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticIn,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    // Nếu đang ở tab thông báo hoặc không có thông báo, dừng animation
    if (widget.currentIndex == 3 || notificationProvider.unreadCount == 0) {
      _animationController.stop();
    } else if (notificationProvider.unreadCount > 0 &&
        !_animationController.isAnimating) {
      // Nếu có thông báo mới và animation chưa chạy, bắt đầu animation
      _animationController.repeat(reverse: true);
    }

    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Trang chủ',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: 'Sự kiện',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.article),
          label: 'Bài viết',
        ),
        BottomNavigationBarItem(
          icon: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              // Chỉ áp dụng hiệu ứng rung nếu có thông báo chưa đọc và không ở tab thông báo
              if (notificationProvider.unreadCount > 0 &&
                  widget.currentIndex != 3) {
                return Transform.translate(
                  offset: Offset(0, _shakeAnimation.value * 2),
                  child: child,
                );
              }
              return child!;
            },
            child: BadgeIcon(
              icon: Icons.notifications,
              count: notificationProvider.unreadCount,
              badgeColor: Colors.red,
            ),
          ),
          label: 'Thông báo',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Tài khoản',
        ),
      ],
    );
  }
}
