import 'package:flutter/material.dart';

class RecipesPage extends StatelessWidget {
  final List<dynamic> recipes;

  RecipesPage({required this.recipes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
        backgroundColor: Colors.green.shade700,
      ),
      body: recipes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.no_food,
                    size: 80,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "No recipes available",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Available Recipes',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Table(
                    border: TableBorder.all(
                      color: Colors.grey.shade400,
                      width: 1,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    columnWidths: {
                      0: const FixedColumnWidth(160),
                      1: const FixedColumnWidth(80),
                      2: const FixedColumnWidth(80),
                      3: const FixedColumnWidth(80),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                        ),
                        children: [
                          _buildTableHeaderCell('Recipe Name'),
                          _buildTableHeaderCell('Protein (g)'),
                          _buildTableHeaderCell('Fats (g)'),
                          _buildTableHeaderCell('Carbs (g)'),
                        ],
                      ),
                      // Create table rows for each recipe
                      for (var recipe in recipes)
                        TableRow(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                          ),
                          children: [
                            _buildTableCell(recipe['recipe_name'] ?? 'No Name'),
                            _buildTableCell(
                                recipe['protein']?.toString() ?? 'N/A'),
                            _buildTableCell(
                                recipe['fats']?.toString() ?? 'N/A'),
                            _buildTableCell(
                                recipe['carbs']?.toString() ?? 'N/A'),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Go Back'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTableHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }
}
