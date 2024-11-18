// diet_menu_screen.dart
import 'package:flutter/material.dart';

class DietMenuScreen extends StatelessWidget {
  final List<String> dietPlan;

  DietMenuScreen({required this.dietPlan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Diet Plan'),
      ),
      body: ListView.builder(
        itemCount: dietPlan.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(dietPlan[index]),
          );
        },
      ),
    );
  }
}
