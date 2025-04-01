import 'package:flutter/material.dart';
import '../../data/repositories/club_repository.dart';
import '../UI/club_card.dart';
import '../UI/footer.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import 'package:provider/provider.dart';

import 'club/club_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ClubRepository _clubRepository = ClubRepository();
  bool _isLoading = false;
  String? _error;

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
            await _clubRepository.getClubs();
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
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: buildClubCard(
                context,
                {
                  'id': club['id']?.toString() ?? 'No ID',
                  'title': club['title'] ?? club['name'] ?? 'Chưa có tên',
                  'description':
                      club['description']?.toString() ?? 'Chưa có mô tả',
                  'location': club['location'] ??
                      club['contact_address'] ??
                      'Chưa có địa điểm',
                  'members': club['members'] ?? club['members_count'] ?? '0',
                  'imageUrl': club['imageUrl'] ??
                      club['logo'] ??
                      'assets/images/default.png',
                  'tags': ['${club['category'] ?? 'Chung'}'],
                },
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
