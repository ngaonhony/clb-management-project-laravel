import 'package:flutter/material.dart';

class BadgeIcon extends StatefulWidget {
  final IconData icon;
  final int count;
  final Color badgeColor;
  final double size;
  final double fontSize;

  const BadgeIcon({
    Key? key,
    required this.icon,
    required this.count,
    this.badgeColor = Colors.red,
    this.size = 24.0,
    this.fontSize = 12.0,
  }) : super(key: key);

  @override
  State<BadgeIcon> createState() => _BadgeIconState();
}

class _BadgeIconState extends State<BadgeIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  int _previousCount = 0;

  @override
  void initState() {
    super.initState();
    _previousCount = widget.count;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(BadgeIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Nếu số lượng thông báo tăng lên, chạy animation
    if (widget.count > _previousCount) {
      _controller.forward().then((_) => _controller.reverse());
    }
    _previousCount = widget.count;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(
          widget.icon,
          size: widget.size,
        ),
        if (widget.count > 0)
          Positioned(
            right: 0,
            top: 0,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: widget.badgeColor,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: widget.size * 0.8,
                      minHeight: widget.size * 0.8,
                    ),
                    child: Center(
                      child: Text(
                        widget.count.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: widget.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
