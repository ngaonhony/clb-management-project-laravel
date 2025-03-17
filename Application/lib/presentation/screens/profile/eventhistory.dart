import 'package:flutter/material.dart';

class Event {
  final int id;
  final String title;
  final String category;
  final String organizer;
  final String location;
  final String image;

  Event({
    required this.id,
    required this.title,
    required this.category,
    required this.organizer,
    required this.location,
    required this.image,
  });
}

class EventH extends StatelessWidget {
  final List<Event> events = [
    Event(
      id: 1,
      title: 'Workshop "Data-driven Marketing"',
      category: "Hoạt động, Cộng đồng",
      organizer: "Marketing UEL Club",
      location: "Số 669, Quốc lộ 1A, Phường Linh Xuân, Thủ Đức, Thành phố Hồ Chí Minh",
      image: "https://leaderbook.com/_next/image?url=https%3A%2F%2Fedus3.leaderbook.com%2Fprod%2Fupload%2Fimg%2F673c4ea96aec6a0053467f02-Proposal.png&w=384&q=75",
    ),
    Event(
      id: 2,
      title: 'Hội thảo "Khởi Nghiệp Thành Công"',
      category: "Workshop, Kinh doanh",
      organizer: "Câu lạc bộ Khởi nghiệp",
      location: "Số 123, Đường ABC, Quận 1, TP. Hồ Chí Minh",
      image: "https://leaderbook.com/_next/image?url=https%3A%2F%2Fedus3.leaderbook.com%2Fprod%2Fupload%2Fimg%2F66d95561ad98c90053039ed4-Vi%C3%A1%C2%BB%C2%87t%20Anh.JPG-1.png&w=384&q=75",
    ),
    Event(
      id: 3,
      title: "Lễ hội Âm nhạc Mùa Hè",
      category: "Âm nhạc, Giải trí",
      organizer: "Nhà tài trợ EventX",
      location: "Công viên B, Quận 2, TP. Hồ Chí Minh",
      image: "https://leaderbook.com/_next/image?url=https%3A%2F%2Fedus3.leaderbook.com%2Fprod%2Fupload%2Fimg%2F66e0286a39d87f0051b00295-1_16x9.png&w=384&q=75",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sự kiện'),
        backgroundColor: Colors.blue, // Màu nền AppBar
        elevation: 0, // Bỏ shadow
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search Bar và Bộ lọc
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Thanh tìm kiếm
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm Sự kiện',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Bộ lọc
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: 'Loại sự kiện',
                          items: ['Loại sự kiện'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (_) {},
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: 'Khu vực',
                          items: ['Khu vực'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (_) {},
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Bộ lọc'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Danh sách sự kiện
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return GestureDetector(
                  onTap: () {
                    // Điều hướng đến trang chi tiết sự kiện
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Hình ảnh sự kiện
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            event.image,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 16),
                        // Thông tin sự kiện
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Danh mục sự kiện
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    event.category,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                // Tiêu đề sự kiện
                                Text(
                                  event.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                // Người tổ chức
                                Row(
                                  children: [
                                    Icon(Icons.person, size: 16, color: Colors.grey),
                                    SizedBox(width: 4),
                                    Text(
                                      event.organizer,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                // Địa điểm
                                Row(
                                  children: [
                                    Icon(Icons.location_on, size: 16, color: Colors.grey),
                                    SizedBox(width: 4),
                                    Text(
                                      event.location,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}