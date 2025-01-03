import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/api/api_client.dart';
import 'core/api/api_service.dart';
import 'data/repositories/auth_repository.dart';
import 'presentation/providers/auth_provider.dart';
import 'routes.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            AuthRepository(
              ApiService(ApiClient()),
            ),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Club Management',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: AppRoutes.home, // Sử dụng route từ AppRoutes
      onGenerateRoute: AppRoutes.generateRoute, // Sử dụng hàm generateRoute
    );
  }
}