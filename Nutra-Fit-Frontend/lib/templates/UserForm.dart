import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:login_flask/templates/ObjectiveSelectionScreen.dart';

void main() {
  runApp(UserForm());
}

class UserForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nutra Fit Diet Planner',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor:
            const Color(0xFFE6F9F5), // Soft mint background
        appBarTheme: const AppBarTheme(
          color: Color(0xFF2E8B57), // Dark green for AppBar
          iconTheme: IconThemeData(color: Colors.white),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFF2E8B57), // Dark green for buttons
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E8B57), // Dark green
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF2E8B57)),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF2E8B57)),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          labelStyle: TextStyle(
            color: Color(0xFF2E8B57),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
              color: Colors.black87), // Slightly dimmed black for contrast
          titleLarge: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold), // AppBar title style
        ),
      ),
      home: UserFormScreen(),
    );
  }
}

class UserFormScreen extends StatefulWidget {
  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String gender = 'Male';
  String work = 'moderate';

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Collect data from the form
      final userData = {
        'weight': double.parse(weightController.text),
        'height': double.parse(heightController.text),
        'age': int.parse(ageController.text),
        'gender': gender,
        'work': work,
      };

      // Submit data to the server
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/submit'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      if (response.statusCode == 200) {
        // On success, pass data to the ObjectiveSelectionScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ObjectiveSelectionScreen(userData: userData),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit form'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Form'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter your details',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E8B57)),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: weightController,
                label: 'Weight (kg)',
                hint: 'e.g., 70',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: heightController,
                label: 'Height (cm)',
                hint: 'e.g., 170',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: ageController,
                label: 'Age',
                hint: 'e.g., 25',
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                value: gender,
                label: 'Gender',
                items: ['Male', 'Female'],
                onChanged: (String? newValue) {
                  setState(() {
                    gender = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                value: work,
                label: 'Work',
                items: ['sedentary', 'light', 'moderate'],
                onChanged: (String? newValue) {
                  setState(() {
                    work = newValue!;
                  });
                },
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: submitForm,
                  child: const Text('Submit', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String label,
      String? hint}) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter ${label.toLowerCase()}';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField(
      {required String value,
      required String label,
      required List<String> items,
      required ValueChanged<String?> onChanged}) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label),
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                      color: Colors.black), // Set text color to black
                ),
              ))
          .toList(),
    );
  }
}
