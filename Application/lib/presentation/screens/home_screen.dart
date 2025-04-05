import 'package:flutter/material.dart';
import '../../data/repositories/club_repository.dart';
import '../UI/club_card.dart';
import '../UI/footer.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import 'package:provider/provider.dart';

import 'dart:developer' as developer;
import '../../providers/notification_provider.dart';

import 'club/club_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ClubRepository _clubRepository = ClubRepository();
  bool _isLoading = false;
  String? _error;

  // Phương thức hiển thị thông báo test
  void _showTestNotification(BuildContext context) {
    final notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    notificationProvider.showLocalNotification(
      'Thông báo thử nghiệm',
      'Đây là thông báo thử nghiệm từ CLB Management. Nhấn để xem chi tiết!',
      'notification',
      999,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã gửi thông báo thử nghiệm!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      endDrawer: CustomDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _isLoading = true;
            _error = null;
          });
          try {
            await _clubRepository.getClubs(forceRefresh: true);
          } catch (e) {
            setState(() {
              _error = e.toString();
            });
          } finally {
            setState(() {
              _isLoading = false;
            });
          }
        },
        child: _buildBody(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showTestNotification(context);
        },
        child: Icon(Icons.notifications),
      ),
      bottomNavigationBar: buildFooter(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _clubRepository.getClubs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          developer.log('Error loading clubs: ${snapshot.error}',
              name: 'HomeScreen');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'Chưa có câu lạc bộ nào',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final club = snapshot.data![index];
            developer.log('Club data at index $index: $club',
                name: 'HomeScreen');
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: buildClubCard(
                context,
                club,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClubDetailScreen(
                        clubId: club['id'].toString(),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
