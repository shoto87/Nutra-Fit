import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _email = '';
  String _password = '';
  bool _isLoading = false; // Loading state

  Future<void> register() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    const url = 'http://127.0.0.1:5000/register';
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'username': _username,
        'email': _email,
        'password': _password,
      }),
    );

    setState(() {
      _isLoading = false; // Hide loading indicator
    });

    if (response.statusCode == 201) {
      // Registration success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful!')),
      );
      Navigator.pop(context); // Return to login page
    } else {
      // Registration failed
      String message;
      try {
        final data = jsonDecode(response.body);
        message = data['message'] ??
            'Registration failed!'; // Use message from server
      } catch (e) {
        message = 'Registration failed!'; // Default message if parsing fails
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: const Color(0xFF7ED957),
      ),
      backgroundColor: const Color(0xFFCCFFB6),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Username'),
                onChanged: (value) {
                  setState(() {
                    _username = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading
                    ? null // Disable button while loading
                    : () {
                        if (_formKey.currentState!.validate()) {
                          register();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7ED957), // Button color
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        'Register',
                        style: const TextStyle(color: Colors.black),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
