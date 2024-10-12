import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import 'diet_form.dart';
import 'diet_menu_screen.dart';
import 'profile_page.dart';
import 'settings.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
        ),
        backgroundColor:
            const Color(0xFF7ED957).withOpacity(0.7), // Dimmed color
        actions: [
          IconButton(
            icon: Icon(Icons.person,
                size: 30,
                color: isDarkMode
                    ? Colors.white70
                    : Colors.black54), // Dimmed color
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout,
                size: 30,
                color: isDarkMode
                    ? Colors.white70
                    : Colors.black54), // Dimmed color
            onPressed: () => _logout(context),
          ),
        ],
      ),
      backgroundColor: isDarkMode
          ? Colors.black54
          : const Color(0xFFCCFFB6), // Dimmed background in dark mode
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMotivationalQuote(isDarkMode),
            const SizedBox(height: 20.0),
            _buildDailySummary(isDarkMode),
            const SizedBox(height: 20.0),
            _buildQuickAccessButtons(context, isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivationalQuote(bool isDarkMode) {
    return Card(
      color: isDarkMode ? Colors.grey[800] : const Color(0xFF7ED957),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Motivational Quote of the Day:',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.greenAccent : Colors.black54),
            ),
            const SizedBox(height: 10.0),
            const Text(
              '“The journey of a thousand miles begins with a single step.”',
              style: TextStyle(fontSize: 16.0, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailySummary(bool isDarkMode) {
    return Card(
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Summary',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.greenAccent : Color(0xFF7ED957)),
            ),
            const SizedBox(height: 10.0),
            _buildSummaryItem('Calories Consumed', '1,800 kcal', isDarkMode),
            _buildSummaryItem('Steps Taken', '8,000', isDarkMode),
            _buildSummaryItem('Water Intake', '1.5L', isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color:
                  isDarkMode ? Colors.white70 : Colors.black87, // Dimmed color
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color:
                  isDarkMode ? Colors.white70 : Colors.black87, // Dimmed color
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessButtons(BuildContext context, bool isDarkMode) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickAccessButton(
                'Create Diet Plan',
                Icons.add_circle,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DietFormScreen()),
                  );
                },
                isDarkMode,
              ),
              _buildQuickAccessButton(
                'View Diet Plan',
                Icons.list,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DietMenuScreen()),
                  );
                },
                isDarkMode,
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickAccessButton(
                'Profile',
                Icons.person_outline,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()),
                  );
                },
                isDarkMode,
              ),
              _buildQuickAccessButton(
                'Settings',
                Icons.settings,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
                isDarkMode,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessButton(
      String label, IconData icon, VoidCallback onTap, bool isDarkMode) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isDarkMode ? Colors.grey[700] : const Color(0xFF7ED957),
        foregroundColor: isDarkMode ? Colors.greenAccent : Colors.black54,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      onPressed: onTap,
      child: Column(
        children: [
          Icon(icon,
              size: 40.0,
              color: isDarkMode
                  ? Colors.greenAccent
                  : Colors.black54), // Updated icon color
          const SizedBox(height: 10.0),
          Text(
            label,
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
