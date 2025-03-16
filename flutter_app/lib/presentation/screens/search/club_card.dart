import 'package:flutter/material.dart';

class ClubCard extends StatelessWidget {
  final Map<String, dynamic> club;
  final VoidCallback? onTap;

  const ClubCard({
    Key? key,
    required this.club,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildClubImage(club, context),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              club['title'] ?? 'Không có tiêu đề',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Icon(
                              Icons.bookmark_border,
                              color: theme.primaryColor,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        club['description'] ?? 'Không có mô tả',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 12),
                      Divider(height: 1, color: Colors.grey[200]),
                      SizedBox(height: 12),
                      _buildClubInfo(club, theme),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClubImage(Map<String, dynamic> club, BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 160,
          width: double.infinity,
          child: Image.network(
            club['imageUrl'] ?? 'https://placeholder.com/300x150',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 160,
              color: Colors.grey[200],
              child: Center(
                child: Icon(Icons.image_not_supported, color: Colors.grey[400], size: 40),
              ),
            ),
          ),
        ),
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              club['category'] ?? 'Câu lạc bộ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClubInfo(Map<String, dynamic> club, ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.location_on_rounded,
          size: 16,
          color: theme.primaryColor,
        ),
        SizedBox(width: 4),
        Expanded(
          child: Text(
            club['location'] ?? 'Không xác định',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 16),
        Icon(
          Icons.people_rounded,
          size: 16,
          color: theme.primaryColor,
        ),
        SizedBox(width: 4),
        Text(
          '${club['members'] ?? '0'} thành viên',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
