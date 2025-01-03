import 'package:flutter/material.dart';
import 'package:nckh/presentation/screens/club_manager/dashboard.dart';
import 'package:nckh/presentation/screens/club_manager/event.dart';
import 'package:nckh/presentation/screens/club_manager/page_avatar.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/register_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/club/club_list_screen.dart';
import 'presentation/screens/club/club_detail_screen.dart';
import 'presentation/screens/club/club_form_screen.dart';
import 'presentation/screens/member/member_list_screen.dart';
import 'presentation/screens/member/member_detail_screen.dart';
import 'presentation/screens/member/member_form_screen.dart';
import 'presentation/screens/event/event_list_screen.dart';
import 'presentation/screens/event/event_detail_screen.dart';
import 'presentation/screens/event/event_form_screen.dart';
import 'presentation/screens/club_manager/information.dart';
import 'presentation/screens/club_manager/member.dart';
import 'presentation/screens/club_manager/blog.dart';
import 'presentation/screens/profile/eventhistory.dart';
import 'presentation/screens/profile/profile.dart';

class AppRoutes {
  // Tên các route
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String clubList = '/club-list';
  static const String clubDetail = '/club-detail';
  static const String clubForm = '/club-form';
  static const String memberList = '/member-list';
  static const String memberDetail = '/member-detail';
  static const String memberForm = '/member-form';
  static const String eventList = '/event-list';
  static const String eventDetail = '/event-detail';
  static const String eventForm = '/event-form';
  static const String eventManager = '/event-manager';
  static const String clubManager = '/club-manager';
  static const String blogManager = '/blog-manager';
  static const String memberManager = '/member-manager';
  static const String homeManager = '/home-manager';
  static const String information = '/infomation';
  static const String profile = '/profile';
  static const String eventH = '/eventH';
  // Hàm để tạo các route
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case profile :
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case eventH :
        return MaterialPageRoute(builder: (_) => EventH());
      case homeManager :
        return MaterialPageRoute(builder: (_) => DashboardScreen());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case information:
        return MaterialPageRoute(builder: (_) => Information());
      case eventManager:
        return MaterialPageRoute(builder: (_) => EventManagementScreen());
      case memberManager :
        return MaterialPageRoute(builder: (_) => MemberManager());
      case clubList:
        return MaterialPageRoute(builder: (_) => ClubListScreen());
      case clubManager:
        return MaterialPageRoute(builder: (_) => PageAvatar());
      case blogManager:
        return MaterialPageRoute(builder: (_) => BlogManagementPage());
      case clubDetail:
        final clubId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => ClubDetailScreen(clubId: clubId));
      case clubForm:
        return MaterialPageRoute(builder: (_) => ClubFormScreen());
      case memberList:
        return MaterialPageRoute(builder: (_) => MemberListScreen());
      case memberDetail:
        final memberId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => MemberDetailScreen(memberId: memberId));
      case memberForm:
        return MaterialPageRoute(builder: (_) => MemberFormScreen());
      case eventList:
        return MaterialPageRoute(builder: (_) => EventListScreen());
      case eventDetail:
        final eventId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => EventDetailScreen(eventId: eventId));
      case eventForm:
        return MaterialPageRoute(builder: (_) => EventFormScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route không tồn tại!'),
            ),
          ),
        );
    }
  }
}