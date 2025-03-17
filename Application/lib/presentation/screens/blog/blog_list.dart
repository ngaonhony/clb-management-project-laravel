import 'package:flutter/material.dart';
import '../../../services/BlogService.dart';
import 'blog_card.dart';

class BlogList extends StatefulWidget {
  @override
  _BlogListState createState() => _BlogListState();
}

class _BlogListState extends State<BlogList> {
  late Future<List<dynamic>> _blogsFuture;

  @override
  void initState() {
    super.initState();
    _blogsFuture = BlogApi.fetchBlogs();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _blogsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Lỗi khi tải blog!"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("Không có bài viết nào."));
        }

        final blogs = snapshot.data!;
        return ListView.builder(
          itemCount: blogs.length,
          itemBuilder: (context, index) {
            return BlogCard(blog: blogs[index]);
          },
        );
      },
    );
  }
}
