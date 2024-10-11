import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_flask/pages/diet_menu_screen.dart';
import 'package:login_flask/pages/settings.dart';
// for jsonEncode and jsonDecode
import 'diet_form.dart';
import 'diet_plan_view.dart';
import 'profile_page.dart';
import 'settings_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Future<void> _logout(BuildContext context) async {
    final url = Uri.parse('http://127.0.0.1:5000/logout');

    final response = await http.post(url);

    if (response.statusCode == 200) {
      // Successfully logged out
      Navigator.pushReplacementNamed(
          context, '/login'); // Navigate to login page
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Logout failed'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: const Color(0xFF7ED957),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.logout, size: 30),
            onPressed: () => _logout(context),
          ),
          const SizedBox(width: 10),
        ],
      ),
      backgroundColor: const Color(0xFFCCFFB6),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMotivationalQuote(),
            const SizedBox(height: 20.0),
            _buildDailySummary(),
            const SizedBox(height: 20.0),
            _buildQuickAccessButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivationalQuote() {
    return Card(
      color: const Color(0xFF7ED957),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 5,
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Motivational Quote of the Day  :',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '“The journey of a thousand miles begins with a single step.”',
              style: TextStyle(fontSize: 16.0, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailySummary() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Summary',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7ED957),
              ),
            ),
            const SizedBox(height: 10.0),
            _buildSummaryItem('Calories Consumed', '1,800 kcal'),
            _buildSummaryItem('Steps Taken', '8,000'),
            _buildSummaryItem('Water Intake', '1.5L'),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessButtons(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickAccessButton(
                'Create Diet Plan',
                Icons.add,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DietFormScreen()),
                  );
                },
              ),
              _buildQuickAccessButton(
                'View Diet Plan',
                Icons.visibility,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DietMenuScreen()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickAccessButton(
                'Profile',
                Icons.person,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()),
                  );
                },
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessButton(
      String label, IconData icon, VoidCallback onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7ED957),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      onPressed: onTap,
      child: Column(
        children: [
          Icon(icon, size: 40.0),
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
