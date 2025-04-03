import 'package:flutter/material.dart';

class ImageUtils {
  /// Widget xử lý hiển thị hình ảnh từ URL với đầy đủ xử lý lỗi, loading và placeholder
  static Widget buildNetworkImage({
    required String? imageUrl,
    required double width,
    required double height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    BorderRadius? borderRadius,
    double? placeholderIconSize,
    Color? placeholderIconColor,
  }) {
    // Xử lý URL rỗng hoặc không hợp lệ
    if (imageUrl == null || imageUrl.isEmpty || imageUrl == 'null') {
      return placeholder ??
          _buildDefaultPlaceholder(
            width,
            height,
            iconSize: placeholderIconSize,
            iconColor: placeholderIconColor,
          );
    }

    // Widget hiển thị ảnh với đầy đủ xử lý lỗi
    Widget imageWidget = Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        print('Lỗi tải hình ảnh: $error - URL: $imageUrl');
        return placeholder ??
            _buildDefaultPlaceholder(
              width,
              height,
              iconSize: placeholderIconSize,
              iconColor: placeholderIconColor,
            );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildLoadingIndicator(width, height);
      },
    );

    // Nếu có borderRadius, wrap bằng ClipRRect
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  /// Widget hiển thị avatar hình tròn
  static Widget buildCircleAvatar({
    required String? imageUrl,
    required double radius,
    Widget? placeholder,
    Color? backgroundColor,
  }) {
    if (imageUrl == null || imageUrl.isEmpty || imageUrl == 'null') {
      return placeholder ??
          Container(
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor ?? Colors.grey[200],
            ),
            child: Icon(
              Icons.person,
              size: radius,
              color: Colors.grey[400],
            ),
          );
    }

    return ClipOval(
      child: buildNetworkImage(
        imageUrl: imageUrl,
        width: radius * 2,
        height: radius * 2,
        placeholder: placeholder,
      ),
    );
  }

  /// Widget để hiển thị gallery ảnh dạng ngang
  static Widget buildHorizontalGallery({
    required List<dynamic> images,
    required double height,
    double? width,
    String Function(dynamic)? imageUrlExtractor,
    double spacing = 8.0,
    BorderRadius? borderRadius,
  }) {
    if (images.isEmpty) {
      return SizedBox();
    }

    return Container(
      height: height,
      width: width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          String? imageUrl;
          if (imageUrlExtractor != null) {
            imageUrl = imageUrlExtractor(images[index]);
          } else {
            // Mặc định thử lấy URL từ các field phổ biến
            if (images[index] is String) {
              imageUrl = images[index];
            } else if (images[index] is Map) {
              imageUrl = images[index]['url'] ??
                  images[index]['image_url'] ??
                  images[index]['image'] ??
                  images[index]['path'];
            }
          }

          return Container(
            margin: EdgeInsets.only(right: spacing),
            child: buildNetworkImage(
              imageUrl: imageUrl,
              width: height,
              height: height,
              borderRadius: borderRadius ?? BorderRadius.circular(8),
            ),
          );
        },
      ),
    );
  }

  /// Widget xử lý hiển thị ảnh bìa với tỷ lệ aspect ratio
  static Widget buildCoverImage({
    required String? imageUrl,
    required double width,
    double aspectRatio = 16 / 9,
    BorderRadius? borderRadius,
    Widget? placeholder,
  }) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: buildNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: width / aspectRatio,
        borderRadius: borderRadius,
        placeholder: placeholder,
      ),
    );
  }

  /// Widget placeholder mặc định khi không có ảnh
  static Widget _buildDefaultPlaceholder(
    double width,
    double height, {
    double? iconSize,
    Color? iconColor,
  }) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          Icons.image_not_supported,
          color: iconColor ?? Colors.grey[400],
          size: iconSize ?? width * 0.4,
        ),
      ),
    );
  }

  /// Widget hiển thị loading khi đang tải ảnh
  static Widget _buildLoadingIndicator(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[100],
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
        ),
      ),
    );
  }

  /// Kiểm tra URL hình ảnh có hợp lệ hay không
  static String? getValidImageUrl(String? url) {
    if (url == null || url.isEmpty || url == 'null') return null;

    // Nếu url đã là đường dẫn http/https đầy đủ
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }

    // Nếu là đường dẫn tương đối thì thêm base URL
    // Thay thế bằng base URL thực tế của bạn
    return 'https://example.com/$url';
  }
}
