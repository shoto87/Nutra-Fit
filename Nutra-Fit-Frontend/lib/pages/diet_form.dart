import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DietFormScreen extends StatefulWidget {
  const DietFormScreen({super.key});

  @override
  State<DietFormScreen> createState() => _DietFormScreenState();
}

class _DietFormScreenState extends State<DietFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers to handle form input
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  String? _gender;
  String? _objective;
  String? _workCategory;

  // Dropdown values for gender, objective, and work category
  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _objectives = [
    'Weight Loss',
    'Muscle Gain',
    'Maintain Weight'
  ];
  final List<String> _workCategories = ['Sedentary', 'Active', 'Highly Active'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diet Planner Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Weight input
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight';
                  }
                  return null;
                },
              ),

              // Height input
              TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(labelText: 'Height (cm)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your height';
                  }
                  return null;
                },
              ),

              // Gender dropdown
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(labelText: 'Gender'),
                items: _genders.map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _gender = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your gender';
                  }
                  return null;
                },
              ),

              // Objective dropdown
              DropdownButtonFormField<String>(
                value: _objective,
                decoration: const InputDecoration(labelText: 'Objective'),
                items: _objectives.map((String objective) {
                  return DropdownMenuItem<String>(
                    value: objective,
                    child: Text(objective),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _objective = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your objective';
                  }
                  return null;
                },
              ),

              // Work category dropdown
              DropdownButtonFormField<String>(
                value: _workCategory,
                decoration: const InputDecoration(labelText: 'Work Category'),
                items: _workCategories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _workCategory = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your work category';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Submit button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle form submission
                    _submitForm();
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    final weight = _weightController.text;
    final height = _heightController.text;
    final gender = _gender;
    final objective = _objective;
    final workCategory = _workCategory;

    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/submit_form'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'weight': weight,
        'height': height,
        'gender': gender!,
        'objective': objective!,
        'work_category': workCategory!,
      }),
    );

    if (response.statusCode == 201) {
      print('Form data saved successfully');
    } else {
      print('Failed to save data');
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }
}
