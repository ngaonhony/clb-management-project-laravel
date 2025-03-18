import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../services/BlogService.dart';
import '../../UI/footer.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer.dart';

class BlogDetailScreen extends StatefulWidget {
  final String blogId;

  const BlogDetailScreen({Key? key, required this.blogId}) : super(key: key);

  @override
  _BlogDetailScreenState createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  late Future<Map<String, dynamic>> _blogFuture;
  bool _isLoading = true;
  Map<String, dynamic>? _blog;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('vi_VN');
    _loadBlogDetails();
  }

  Future<void> _loadBlogDetails() async {
    setState(() => _isLoading = true);
    try {
      _blogFuture = BlogApi.getBlog(int.parse(widget.blogId));
      final blogData = await _blogFuture;
      setState(() {
        _blog = blogData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Không thể tải chi tiết bài viết: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? _buildLoadingState()
          : _blog != null
              ? _buildBlogContent()
              : _buildErrorState(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Đang tải bài viết...'),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          SizedBox(height: 16),
          Text('Không thể tải bài viết'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadBlogDetails,
            child: Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildBlogContent() {
    try {
      // Format the date if available
      String formattedDate = '';
      if (_blog!.containsKey('created_at') && _blog!['created_at'] != null) {
        try {
          final DateTime date = DateTime.parse(_blog!['created_at'].toString());
          formattedDate = DateFormat.yMMMMd('vi_VN').format(date);
        } catch (e) {
          formattedDate = 'Ngày không xác định';
          print('Lỗi khi phân tích ngày: $e');
        }
      }

      // Extract author name
      final String authorName = _blog!.containsKey('user') &&
              _blog!['user'] != null &&
              _blog!['user'].containsKey('name')
          ? _blog!['user']['name']?.toString() ?? 'Tác giả ẩn danh'
          : 'Tác giả ẩn danh';

      // Extract category name
      final String categoryName = _blog!.containsKey('category') &&
              _blog!['category'] != null &&
              _blog!['category'].containsKey('name')
          ? _blog!['category']['name']?.toString() ?? 'Chưa phân loại'
          : 'Chưa phân loại';

      // Get background images if available
      final List<dynamic> backgroundImages =
          _blog!.containsKey('background_images') &&
                  _blog!['background_images'] != null
              ? _blog!['background_images'] as List<dynamic>
              : [];

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with cover image
            _buildBlogHeader(backgroundImages),

            // Content container
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    _blog!.containsKey('title') && _blog!['title'] != null
                        ? _blog!['title'].toString()
                        : 'Không có tiêu đề',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                      height: 1.3,
                    ),
                  ),

                  SizedBox(height: 12),

                  // Meta information
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Wrap(
                      spacing: 16,
                      children: [
                        // Author
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.person,
                                size: 16, color: Colors.grey[600]),
                            SizedBox(width: 4),
                            Text(
                              authorName,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),

                        // Category
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.category,
                                size: 16, color: Colors.grey[600]),
                            SizedBox(width: 4),
                            Text(
                              categoryName,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),

                        // Date
                        if (formattedDate.isNotEmpty)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.calendar_today,
                                  size: 16, color: Colors.grey[600]),
                              SizedBox(width: 4),
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                        // View count
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.remove_red_eye,
                                size: 16, color: Colors.grey[600]),
                            SizedBox(width: 4),
                            Text(
                              _blog!.containsKey('view_count')
                                  ? '${_blog!['view_count'] ?? 0} lượt xem'
                                  : '0 lượt xem',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // Description
                  if (_blog!.containsKey('description') &&
                      _blog!['description'] != null)
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      margin: EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Text(
                        _blog!['description'].toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.blue.shade800,
                          height: 1.5,
                        ),
                      ),
                    ),

                  // Content
                  if (_blog!.containsKey('content') &&
                      _blog!['content'] != null)
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nội dung bài viết:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            _stripHtmlTags(_blog!['content'].toString()),
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.8,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Tags section if you want to add tags later
                  SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Lỗi khi hiển thị nội dung blog: $e');
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            SizedBox(height: 16),
            Text('Có lỗi khi hiển thị nội dung: ${e.toString()}'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadBlogDetails,
              child: Text('Thử lại'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildBlogHeader(List<dynamic> backgroundImages) {
    try {
      // Use the first background image as header if available
      String? headerImageUrl;
      if (backgroundImages.isNotEmpty) {
        if (backgroundImages[0] is Map) {
          final Map<String, dynamic> firstImage =
              backgroundImages[0] as Map<String, dynamic>;
          if (firstImage.containsKey('url') && firstImage['url'] != null) {
            headerImageUrl = firstImage['url'].toString();
          } else if (firstImage.containsKey('image_url') &&
              firstImage['image_url'] != null) {
            headerImageUrl = firstImage['image_url'].toString();
          }
        }
      }

      return Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: headerImageUrl == null
                ? [Colors.blue.shade700, Colors.blue.shade900]
                : [
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.8)
                  ],
          ),
        ),
        child: Stack(
          children: [
            // Background image
            if (headerImageUrl != null)
              Positioned.fill(
                child: Image.network(
                  headerImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print('Lỗi tải hình ảnh: $error');
                    return Container(
                      color: Colors.grey.shade200,
                      child: Icon(
                        Icons.image_not_supported,
                        size: 60,
                        color: Colors.grey.shade400,
                      ),
                    );
                  },
                ),
              ),

            // Gradient overlay
            if (headerImageUrl != null)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),

            // Back button
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                  color: Colors.blue.shade800,
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Lỗi khi hiển thị header blog: $e');
      return Container(
        height: 200,
        width: double.infinity,
        color: Colors.blue.shade700,
        child: Stack(
          children: [
            Center(
              child: Icon(
                Icons.image_not_supported,
                size: 60,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                  color: Colors.blue.shade800,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  // Hàm hỗ trợ để loại bỏ các thẻ HTML
  String _stripHtmlTags(String htmlString) {
    if (htmlString.isEmpty) {
      return ''; // Trả về chuỗi rỗng nếu đầu vào rỗng
    }

    try {
      // Regex đơn giản để loại bỏ các thẻ HTML
      // Lưu ý: Đây là cách xử lý đơn giản, không xử lý được tất cả trường hợp
      String strippedString = htmlString
          .replaceAll(RegExp(r'<[^>]*>'), '') // Loại bỏ tất cả các thẻ HTML
          .replaceAll('&nbsp;', ' ') // Thay thế &nbsp; bằng khoảng trắng
          .replaceAll('&amp;', '&') // Thay thế &amp; bằng &
          .replaceAll('&lt;', '<') // Thay thế &lt; bằng <
          .replaceAll('&gt;', '>') // Thay thế &gt; bằng >
          .replaceAll('&quot;', '"') // Thay thế &quot; bằng "
          .replaceAll('&apos;', "'"); // Thay thế &apos; bằng '

      // Xử lý xuống dòng
      strippedString = strippedString
          .replaceAll('</p>', '\n\n')
          .replaceAll('<br>', '\n')
          .replaceAll('<br/>', '\n')
          .replaceAll('<br />', '\n');

      return strippedString;
    } catch (e) {
      print('Lỗi khi xử lý HTML: $e');
      return htmlString; // Trả về chuỗi gốc nếu có lỗi
    }
  }
}
