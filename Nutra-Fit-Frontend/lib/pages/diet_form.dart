import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'diet_menu_screen.dart';

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
    'Maintain Weight',
    'Diabetes type 2',
    'Chronic Kidney Disease'
  ];
  final List<String> _workCategories = ['Sedentary', 'Light', 'Moderate'];

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diet Plan Form'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _weightController,
                          decoration: InputDecoration(
                            labelText: 'Weight (kg)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your weight';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _heightController,
                          decoration: InputDecoration(
                            labelText: 'Height (cm)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your height';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        DropdownButtonFormField<String>(
                          value: _gender,
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          items: _genders.map((String gender) {
                            return DropdownMenuItem<String>(
                              value: gender,
                              child: Text(gender),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _gender = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your gender';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        DropdownButtonFormField<String>(
                          value: _objective,
                          decoration: InputDecoration(
                            labelText: 'Objective',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          items: _objectives.map((String objective) {
                            return DropdownMenuItem<String>(
                              value: objective,
                              child: Text(objective),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _objective = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select an objective';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        DropdownButtonFormField<String>(
                          value: _workCategory,
                          decoration: InputDecoration(
                            labelText: 'Work Category',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          items: _workCategories.map((String workCategory) {
                            return DropdownMenuItem<String>(
                              value: workCategory,
                              child: Text(workCategory),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _workCategory = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your work category';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    await _submitForm();
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                },
                                child: const Text('Submit'),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token') ?? '';
    final url = Uri.parse('http://127.0.0.1:5000/create-user-data');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'weight': _weightController.text,
        'height': _heightController.text,
        'gender': _gender,
        'objective': _objective,
        'work_category': _workCategory,
        'age': 25, // Adjust as needed
      }),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      if (_objective == 'Weight Loss') {
        // Navigate to the Diet Menu screen with the diet plan
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DietMenuScreen(dietPlan: data['diet_plan']),
          ),
        );
      }
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.body}')),
      );
    }
  }
}
