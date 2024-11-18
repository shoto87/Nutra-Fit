import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:login_flask/templates/RecipesPage.dart';

class ObjectiveSelectionScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  ObjectiveSelectionScreen({required this.userData});

  @override
  _ObjectiveSelectionScreenState createState() =>
      _ObjectiveSelectionScreenState();
}

class _ObjectiveSelectionScreenState extends State<ObjectiveSelectionScreen> {
  Future<void> fetchRecipes(String objective) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/$objective'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(widget.userData),
    );

    if (response.statusCode == 200) {
      final recipes = json.decode(response.body);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipesPage(recipes: recipes),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch recipes')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Objective'),
        backgroundColor:
            const Color(0xFF7ED957).withOpacity(0.7), // Dimmed color
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildObjectiveButton(
                context,
                'Weight Maintenance',
                Icons.health_and_safety,
                Colors.teal.shade400,
                () => fetchRecipes('weight-maintenance'),
              ),
              const SizedBox(height: 20),
              _buildObjectiveButton(
                context,
                'Weight Loss',
                Icons.fitness_center,
                Colors.green.shade400,
                () => fetchRecipes('weight-loss'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildObjectiveButton(BuildContext context, String label,
      IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 30),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
