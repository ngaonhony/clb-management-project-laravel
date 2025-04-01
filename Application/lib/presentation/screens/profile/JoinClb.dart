import 'package:flutter/material.dart';
import '../../../models/club_model.dart';
import '../../../services/JoinRequestService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../models/user_model.dart';

class JoinedClubsScreen extends StatefulWidget {
  const JoinedClubsScreen({Key? key}) : super(key: key);

  @override
  State<JoinedClubsScreen> createState() => _JoinedClubsScreenState();
}

class _JoinedClubsScreenState extends State<JoinedClubsScreen> {
  final JoinRequestService _joinRequestService = JoinRequestService();
  bool _isLoading = true;
  List<Club> _clubs = [];
  User? _currentUser;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString('user');

      print('DEBUG JoinClb: User data from SharedPreferences: $userString');

      if (userString != null && userString.isNotEmpty) {
        try {
          final userData = json.decode(userString);
          _currentUser = User.fromJson(userData);
          print('DEBUG JoinClb: User ID loaded: ${_currentUser?.id}');
          await _loadJoinedClubs();
        } catch (e) {
          print('DEBUG JoinClb: Error parsing user data: $e');
          setState(() {
            _error = 'Định dạng dữ liệu người dùng không hợp lệ';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _error = 'Vui lòng đăng nhập để xem câu lạc bộ của bạn';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('DEBUG JoinClb: Error loading user: $e');
      setState(() {
        _error = 'Không thể tải thông tin người dùng: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadJoinedClubs() async {
    if (_currentUser == null) {
      print('DEBUG JoinClb: Cannot load clubs - user is null');
      return;
    }

    try {
      print('DEBUG JoinClb: Loading clubs for user ID: ${_currentUser!.id}');
      final clubs = await _joinRequestService.getUserClubs(_currentUser!.id);
      print('DEBUG JoinClb: Loaded ${clubs.length} clubs');
      setState(() {
        _clubs = clubs;
        _isLoading = false;
      });
    } catch (e) {
      print('DEBUG JoinClb: Error loading clubs: $e');
      setState(() {
        _error = 'Không thể tải danh sách câu lạc bộ: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Câu lạc bộ của tôi'),
        backgroundColor: Colors.indigo,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(
                  child:
                      Text(_error, style: const TextStyle(color: Colors.red)))
              : _clubs.isEmpty
                  ? const Center(
                      child: Text('Bạn chưa tham gia câu lạc bộ nào'))
                  : RefreshIndicator(
                      onRefresh: _loadJoinedClubs,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _clubs.length,
                        itemBuilder: (context, index) {
                          final club = _clubs[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              onTap: () {
                                // Điều hướng đến trang chi tiết câu lạc bộ
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => ClubDetailScreen(club: club),
                                //   ),
                                // );
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Background image hoặc logo của câu lạc bộ
                                        Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            image: (club.backgroundImages !=
                                                        null &&
                                                    club.backgroundImages!
                                                        .isNotEmpty &&
                                                    club.backgroundImages![0] !=
                                                        null)
                                                ? DecorationImage(
                                                    image: NetworkImage(club
                                                        .backgroundImages![0]
                                                        .toString()),
                                                    fit: BoxFit.cover,
                                                  )
                                                : null,
                                          ),
                                          child: (club.backgroundImages ==
                                                      null ||
                                                  club.backgroundImages!
                                                      .isEmpty ||
                                                  club.backgroundImages![0] ==
                                                      null)
                                              ? const Icon(Icons.group,
                                                  size: 40, color: Colors.grey)
                                              : null,
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                club.name,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                              const SizedBox(height: 8),
                                              if (club.shortDescription !=
                                                      null &&
                                                  club.shortDescription!
                                                      .isNotEmpty)
                                                Text(
                                                  club.shortDescription!,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[700],
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    // Thông tin liên hệ
                                    if (club.email != null &&
                                        club.email!.isNotEmpty)
                                      Row(
                                        children: [
                                          const Icon(Icons.email,
                                              size: 16, color: Colors.indigo),
                                          const SizedBox(width: 8),
                                          Text(
                                            club.email!,
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    if (club.phone != null &&
                                        club.phone!.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.phone,
                                              size: 16, color: Colors.indigo),
                                          const SizedBox(width: 8),
                                          Text(
                                            club.phone!,
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ],
                                    if (club.address != null &&
                                        club.address!.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on,
                                              size: 16, color: Colors.indigo),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              club.address!,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
