import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_flask/templates/ObjectiveSelectionScreen.dart';
import 'dart:convert';

class UserDetailsForm extends StatefulWidget {
  final int userId; // Pass userId dynamically

  const UserDetailsForm({required this.userId, Key? key}) : super(key: key);

  @override
  _UserDetailsFormState createState() => _UserDetailsFormState();
}

class _UserDetailsFormState extends State<UserDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String gender = 'Male';
  String work = 'moderate';

  Future<void> submitUserDetails() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse('http://127.0.0.1:5000/user-details-store'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'user_id': widget.userId, // Use the userId dynamically
            'weight': double.parse(weightController.text),
            'height': double.parse(heightController.text),
            'age': int.parse(ageController.text),
            'gender': gender,
            'work': work,
          }),
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User details stored successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // Redirect to the ObjectiveSelectionPage and pass the form data
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ObjectiveSelectionScreen(
                userData: {
                  'user_id': widget.userId, // Pass userId to the next page
                  'weight': weightController.text,
                  'height': heightController.text,
                  'age': ageController.text,
                  'gender': gender,
                  'work': work,
                },
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to store user details: ${response.body}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred while submitting details.'),
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
        title: const Text('Enter Your Details'),
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
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                items: ['Male', 'Female', 'Other'],
                onChanged: (String? newValue) {
                  setState(() {
                    gender = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                value: work,
                label: 'Work Activity',
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
                  onPressed: submitUserDetails,
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
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField(
      {required String value,
      required String label,
      required List<String> items,
      required Function(String?) onChanged}) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: label),
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }
}
