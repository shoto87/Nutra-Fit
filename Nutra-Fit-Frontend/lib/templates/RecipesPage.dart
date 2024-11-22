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
                    size: 100,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "No recipes available",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Try adding some recipes to your plan!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
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
                    ),
                    columnWidths: {
                      0: const FlexColumnWidth(3),
                      1: const FlexColumnWidth(1),
                      2: const FlexColumnWidth(1),
                      3: const FlexColumnWidth(1),
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
                      // Generate table rows for recipes
                      for (var recipe in recipes)
                        TableRow(
                          decoration: BoxDecoration(
                            color: recipes.indexOf(recipe) % 2 == 0
                                ? Colors.grey.shade200
                                : Colors.grey.shade50,
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTableHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
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
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }
}
