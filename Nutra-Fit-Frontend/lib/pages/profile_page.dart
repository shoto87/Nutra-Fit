import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _username;
  String? _email;
  List<dynamic>? _dietPlans;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to log in first!')),
      );
      return; // Exit if no token is found
    }

    final response = await http.get(
      Uri.parse('http://127.0.0.1:5000/user-details'),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      setState(() {
        _username = userData['username'];
        _email = userData['email'];
        _dietPlans = userData['diet_plans'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load user details: ${response.body}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${_email ?? "Loading..."}'),
            Text('Username: ${_username ?? "Loading..."}'),
            const SizedBox(height: 20),
            const Text(
              'User Details:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            _dietPlans != null && _dietPlans!.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _dietPlans!.length,
                    itemBuilder: (context, index) {
                      final plan = _dietPlans![index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Weight: ${plan['weight']} kg'),
                              Text('Height: ${plan['height']} cm'),
                              Text('Objective: ${plan['objective']}'),
                              Text('Work Category: ${plan['work_category']}'),
                              Text('Gender: ${plan['gender']}'),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : const Text('No User Details Found.'),
          ],
        ),
      ),
    );
  }
}
