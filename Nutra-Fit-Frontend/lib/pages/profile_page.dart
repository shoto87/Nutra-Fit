import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart'; // for jsonDecode

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _userName;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token'); // Retrieve the token

    if (token != null) {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/user/profile'),
        headers: {"Authorization": "Bearer $token"}, // Pass the token in header
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _userName = data['name'] ?? 'Unknown User';
          _userEmail = data['email'] ?? 'Unknown Email';
        });
      } else {
        // Handle error
        setState(() {
          _userName = 'Failed to load';
          _userEmail = 'Failed to load';
        });
      }
    } else {
      setState(() {
        _userName = 'Not logged in';
        _userEmail = 'Not logged in';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF7ED957), // Green color from your theme
      ),
      backgroundColor: const Color(0xFFCCFFB6), // Light green background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            _buildProfileDetail('Name', _userName ?? 'Loading...'),
            const SizedBox(height: 20.0),
            _buildProfileDetail('Email', _userEmail ?? 'Loading...'),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetail(String label, String value) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
