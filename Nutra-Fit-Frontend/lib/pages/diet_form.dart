import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DietFormScreen extends StatefulWidget {
  const DietFormScreen({Key? key}) : super(key: key);

  @override
  State<DietFormScreen> createState() => _DietFormScreenState();
}

class _DietFormScreenState extends State<DietFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  String? _gender;
  String? _objective;
  String? _workCategory;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _objectives = [
    'Weight Loss',
    'Muscle Gain',
    'Maintain Weight'
  ];
  final List<String> _workCategories = ['Sedentary', 'Active', 'Highly Active'];

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diet Plan Form'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(labelText: 'Height (cm)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your height';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: InputDecoration(labelText: 'Gender'),
                items: _genders.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _gender = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select your gender' : null,
              ),
              DropdownButtonFormField<String>(
                value: _objective,
                decoration: InputDecoration(labelText: 'Objective'),
                items: _objectives.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _objective = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select your objective' : null,
              ),
              DropdownButtonFormField<String>(
                value: _workCategory,
                decoration: InputDecoration(labelText: 'Work Category'),
                items: _workCategories.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _workCategory = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select your work category' : null,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Submit'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final dietPlan = {
        'weight': _weightController.text,
        'height': _heightController.text,
        'gender': _gender,
        'objective': _objective,
        'work_category': _workCategory,
      };

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You need to log in first!')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/create-user-data'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(dietPlan),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Diet plan submitted successfully')),
        );
        Navigator.pushReplacementNamed(context,
            '/dashboard'); // Change '/dashboard' to the correct route name.

        _weightController.clear();
        _heightController.clear();
        setState(() {
          _gender = null;
          _objective = null;
          _workCategory = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit diet plan: ${response.body}'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }
}
