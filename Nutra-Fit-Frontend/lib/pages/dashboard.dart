import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_flask/pages/userDetails.dart';
import 'package:login_flask/templates/UserForm.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import 'diet_form.dart';
import 'diet_menu_screen.dart';
import 'profile_page.dart';
import 'settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:provider/provider.dart';

class UserProvider with ChangeNotifier {
  String _userId = '';

  String get userId => _userId;

  void setUserId(String id) {
    _userId = id;
    notifyListeners();
  }
}

// Fetching the userId from the provider
String getUserId(BuildContext context) {
  return Provider.of<UserProvider>(context).userId;
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Future<void> _logout(BuildContext context) async {
    final url = Uri.parse('http://127.0.0.1:5000/logout');
    final response = await http.post(url);

    if (response.statusCode == 200) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Logout failed'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final userData = getUserData(); // Mock user data
    final userObjective = userData['objective'] ?? 'weight maintenance';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black87,
              fontSize: 24.0,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDarkMode
            ? const Color(0xFF303030)
            : const Color(0xFF7ED957).withOpacity(0.8),
        actions: [
          CircleAvatar(
            backgroundColor: isDarkMode ? Colors.greenAccent : Colors.white,
            child: IconButton(
              icon: const Icon(Icons.person),
              color: isDarkMode ? Colors.black : Colors.green,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.logout,
                size: 28, color: isDarkMode ? Colors.white70 : Colors.black54),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Colors.black87, Colors.black54]
                : [Colors.white, const Color(0xFFCCFFB6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMotivationalQuote(isDarkMode),
              const SizedBox(height: 20.0),
              _buildDailySummary(userObjective, isDarkMode),
              const SizedBox(height: 30.0),
              _buildQuickAccessButtons(context, isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMotivationalQuote(bool isDarkMode) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: isDarkMode ? Colors.grey[900] : const Color(0xFF7ED957),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🌟 Motivational Quote of the Day:',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.greenAccent : Colors.black87),
            ),
            const SizedBox(height: 10.0),
            Text(
              '“The journey of a thousand miles begins with a single step.”',
              style: TextStyle(
                fontSize: 16.0,
                color: isDarkMode ? Colors.white70 : Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailySummary(String userObjective, bool isDarkMode) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📊 Daily Summary',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode
                      ? Colors.greenAccent
                      : const Color(0xFF7ED957)),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Tips for ${userObjective.toUpperCase()}:',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white70 : Colors.black87),
            ),
            const SizedBox(height: 5.0),
            Text(
              _getTips(userObjective),
              style: TextStyle(
                  fontSize: 16.0,
                  color: isDarkMode ? Colors.white70 : Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessButtons(BuildContext context, bool isDarkMode) {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        children: [
          _buildQuickAccessButton('Calculate Diet Plan', Icons.add_circle, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserFormScreen()),
            );
          }, isDarkMode),
          _buildQuickAccessButton('Save User Details', Icons.list, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          }, isDarkMode),
          _buildQuickAccessButton('Profile', Icons.person_outline, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }, isDarkMode),
          _buildQuickAccessButton('Settings', Icons.settings, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            );
          }, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildQuickAccessButton(
      String label, IconData icon, VoidCallback onTap, bool isDarkMode) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 5.0,
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
        shadowColor: Colors.black45,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        padding: const EdgeInsets.all(20.0),
      ),
      onPressed: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              size: 40.0,
              color: isDarkMode ? Colors.greenAccent : const Color(0xFF7ED957)),
          const SizedBox(height: 10.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 16.0,
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  String _getTips(String userObjective) {
    switch (userObjective) {
      case 'muscle gain':
        return 'Focus on high-protein foods and strength training.';
      case 'weight loss':
        return 'Choose whole foods and control portions.';
      default:
        return 'Stay active and maintain balance!';
    }
  }

  Map<String, dynamic> getUserData() {
    return {'objective': 'weight loss'}; // Mock data
  }
}
