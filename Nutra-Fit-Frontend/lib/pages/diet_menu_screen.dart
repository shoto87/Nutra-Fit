import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DietMenuScreen extends StatefulWidget {
  const DietMenuScreen({super.key});

  @override
  _DietMenuScreenState createState() => _DietMenuScreenState();
}

class _DietMenuScreenState extends State<DietMenuScreen> {
  String _username = '';
  String _email = '';
  String _weight = '';
  String _height = '';
  String _objective = '';
  String _workCategory = '';

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
      Uri.parse('http://127.0.0.1:5000/user/profile'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _username = data['name'];
        _email = data['email'];
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
        _weight = data['weight'];
        _height = data['height'];
        _objective = data['objective'];
        _workCategory = data['work_category'];
      });
    } else {
      print('Failed to load diet plan data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diet Menu'),
        backgroundColor: const Color(0xFF7ED957),
      ),
      backgroundColor: const Color(0xFFCCFFB6),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'User Data',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildUserData(),
              const SizedBox(height: 20),
              const Text(
                'Diet Menu',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildDietMenu('Breakfast', _breakfast),
              const SizedBox(height: 20),
              _buildDietMenu('Lunch', _lunch),
              const SizedBox(height: 20),
              _buildDietMenu('Dinner', _dinner),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Name: $_username'),
        Text('Email: $_email'),
        Text('Weight: $_weight kg'),
        Text('Height: $_height cm'),
        Text('Objective: $_objective'),
        Text('Work Category: $_workCategory'),
      ],
    );
  }

  Widget _buildDietMenu(String mealType, List<String> menuItems) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mealType,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5),
          ...menuItems
              .map((item) =>
                  Text('- $item', style: const TextStyle(fontSize: 16)))
              .toList(),
        ],
      ),
    );
  }
}
