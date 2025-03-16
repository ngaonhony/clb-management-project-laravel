import 'package:flutter/material.dart';
import '../../data/repositories/club_repository.dart';
import '../UI/club_card.dart';
import '../UI/footer.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final clubRepository = ClubRepository();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      endDrawer: CustomDrawer(),
      body: _buildBody(context, clubRepository),
      bottomNavigationBar: buildFooter(context),
    );
  }

  Widget _buildBody(BuildContext context, ClubRepository clubRepository) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: clubRepository.getClubs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        if (snapshot.hasData) {
          final clubs = snapshot.data!;
          if (clubs.isEmpty) {
            return Center(
              child: Text('No clubs found'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: clubs.length,
            itemBuilder: (context, index) {
              final club = clubs[index];
              // Xử lý null an toàn cho các trường
              final id = club['id']?.toString() ?? 'No ID';
              final title = club['title']?.toString() ?? 'No Title';
              final description =
                  club['description']?.toString() ?? 'No Description';
              final location =
                  club['location']?.toString() ?? 'Unknown Location';
              final members = club['members']?.toString() ?? '0';
              final imageUrl =
                  club['imageUrl']?.toString() ?? 'assets/images/default.png';

              // Truyền dữ liệu đã xử lý vào buildClubCard
              return buildClubCard(
                context,
                {
                  'id': id,
                  'title': title,
                  'description': description,
                  'location': location,
                  'members': members,
                  'imageUrl': imageUrl,
                },
              );
            },
          );
        }

        return Center(
          child: Text('No data available'),
        );
      },
    );
  }
}
