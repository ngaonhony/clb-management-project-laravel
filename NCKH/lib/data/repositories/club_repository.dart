class ClubRepository {
  // Danh sách các CLB
  final List<Map<String, dynamic>> clubs = [
    {
      'id': '1',
      'title': 'Minishow Len',
      'description': '"LEN" - hành trình cảm xúc qua những thanh âm du dương.',
      'location': 'Hà Nội',
      'members': 15,
      'imageUrl': 'assets/images/img_1.png',
    },
    {
      'id': '2',
      'title': 'CLB Nghệ thuật',
      'description': 'Khám phá và sáng tạo nghệ thuật đa dạng.',
      'location': 'TP. Hồ Chí Minh',
      'members': 20,
      'imageUrl': 'assets/images/img_1.png',
    },
    // Thêm các CLB khác vào đây
  ];

  // Lấy danh sách các CLB
  List<Map<String, dynamic>> getClubs() {
    return clubs;
  }

  // Lấy thông tin chi tiết của một CLB theo ID
  Map<String, dynamic>? getClubById(String clubId) {
    return clubs.firstWhere((club) => club['id'] == clubId);
  }
}