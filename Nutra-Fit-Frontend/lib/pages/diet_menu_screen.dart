import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class DietMenuScreen extends StatefulWidget {
  const DietMenuScreen({super.key});

  @override
  _DietMenuScreenState createState() => _DietMenuScreenState();
}

class _DietMenuScreenState extends State<DietMenuScreen> {
  String _username = '';
  List<String> _breakfast = ['Eggs', 'Toast', 'Orange Juice'];
  List<String> _lunch = ['Grilled Chicken', 'Salad', 'Water'];
  List<String> _dinner = ['Steak', 'Broccoli', 'Green Tea'];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchDietPlan();
  }

  Future<void> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    final response = await http.get(
      Uri.parse('http://127.0.0.1:5000/user-details'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _username = data['username']; // Fetch user name
      });
    } else {
      print('Failed to load user data');
    }
  }

  Future<void> _fetchDietPlan() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    final response = await http.get(
      Uri.parse('http://127.0.0.1:5000/diet-plan'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _breakfast = List<String>.from(data['breakfast']);
        _lunch = List<String>.from(data['lunch']);
        _dinner = List<String>.from(data['dinner']);
      });
    } else {
      print('Failed to load diet plan data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text('Diet Menu for $_username'),
        backgroundColor: isDarkMode
            ? const Color(0xFF7ED957)
                .withOpacity(0.7) // Dark mode app bar color
            : const Color(0xFF7ED957), // Light mode app bar color
      ),
      backgroundColor: isDarkMode
          ? Colors.black87
          : const Color(0xFFCCFFB6), // Background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Displaying Diet Menu for $_username',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                _buildDietMenuBox('Breakfast', _breakfast, isDarkMode),
                const SizedBox(height: 20),
                _buildDietMenuBox('Lunch', _lunch, isDarkMode),
                const SizedBox(height: 20),
                _buildDietMenuBox('Dinner', _dinner, isDarkMode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDietMenuBox(
      String mealType, List<String> menuItems, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.grey[850]
            : Colors.white, // Box color based on theme
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mealType,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDarkMode
                  ? Colors.greenAccent
                  : Color(0xFF7ED957), // Text color based on theme
            ),
          ),
          const SizedBox(height: 5),
          ...menuItems.map((item) => Text(
                '- $item',
                style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white70 : Colors.black),
              )),
        ],
      ),
    );
  }
}
