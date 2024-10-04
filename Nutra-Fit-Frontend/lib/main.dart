import 'package:flutter/material.dart';
import 'package:login_flask/pages/diet_menu_screen.dart';
import './auth/login_page.dart';
import './pages/dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/dashboard': (context) => DashboardPage(),
        '/diet-menu': (context) => DietMenuScreen(),
      },
    );
  }
}
