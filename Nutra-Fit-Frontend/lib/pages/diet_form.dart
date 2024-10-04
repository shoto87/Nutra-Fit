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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diet Planner Form'),
        backgroundColor: const Color(0xFF7ed957), // Set app bar color
      ),
      body: Center(
        // Center the entire content
        child: Container(
          padding: const EdgeInsets.all(20.0), // Padding around the container
          decoration: BoxDecoration(
            color: Colors.white, // Background color of the box
            borderRadius: BorderRadius.circular(15.0), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Minimize the height of the column
              children: [
                _buildTextFormField(_weightController, 'Weight (kg)',
                    'Please enter your weight'),
                _buildTextFormField(_heightController, 'Height (cm)',
                    'Please enter your height'),
                _buildDropdownFormField<String>(
                  _gender,
                  'Gender',
                  _genders,
                  (newValue) => setState(() => _gender = newValue),
                  'Please select your gender',
                ),
                _buildDropdownFormField<String>(
                  _objective,
                  'Objective',
                  _objectives,
                  (newValue) => setState(() => _objective = newValue),
                  'Please select your objective',
                ),
                _buildDropdownFormField<String>(
                  _workCategory,
                  'Work Category',
                  _workCategories,
                  (newValue) => setState(() => _workCategory = newValue),
                  'Please select your work category',
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7ed957), // Button color
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white), // Button text color
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(
      TextEditingController controller, String label, String errorMessage) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF7ed957)), // Label color
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(
              color: Color(0xFF7ed957)), // Focused border color
        ),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorMessage;
        }
        return null;
      },
    );
  }

  Widget _buildDropdownFormField<T>(
    T? value,
    String label,
    List<String> items,
    void Function(T?) onChanged,
    String errorMessage,
  ) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF7ed957)), // Label color
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(
              color: Color(0xFF7ed957)), // Focused border color
        ),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<T>(
          value: item as T,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return errorMessage;
        }
        return null;
      },
    );
  }

  Future<void> createDietPlan() async {
    const url = 'http://127.0.0.1:5000/create-diet-plan'; // Updated endpoint

    // Fetch JWT token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('jwt_token'); // Ensure you store the token after login

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        'Authorization':
            'Bearer $token', // Use the valid token from shared preferences
      },
      body: jsonEncode({
        'weight': _weightController.text,
        'height': _heightController.text,
        'objective': _objective,
        'work_category': _workCategory,
        'gender': _gender,
      }),
    );

    if (response.statusCode == 201) {
      print('Diet plan created successfully');
      Navigator.pushReplacementNamed(context, '/diet-menu');
    } else {
      print('Failed to save data: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save data: ${response.body}')),
      );
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Call the createDietPlan method to handle the HTTP request
      await createDietPlan();
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }
}
