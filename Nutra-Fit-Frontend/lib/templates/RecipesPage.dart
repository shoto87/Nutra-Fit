import 'package:flutter/material.dart';

class RecipesPage extends StatelessWidget {
  final List<dynamic> recipes;

  RecipesPage({required this.recipes});

  @override
  Widget build(BuildContext context) {
    // Group recipes into days
    final daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final dayWiseRecipes = _divideRecipesByDays(recipes, daysOfWeek.length);

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Weekly Recipes',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(daysOfWeek.length, (index) {
                    return _buildDaySection(
                      daysOfWeek[index],
                      dayWiseRecipes[index],
                    );
                  }),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
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
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildDaySection(String day, List<dynamic> recipes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          day,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 8),
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
            ...recipes.map((recipe) {
              return TableRow(
                decoration: BoxDecoration(
                  color: recipes.indexOf(recipe) % 2 == 0
                      ? Colors.grey.shade200
                      : Colors.grey.shade50,
                ),
                children: [
                  _buildTableCell(recipe['recipe_name'] ?? 'No Name'),
                  _buildTableCell(recipe['protein']?.toString() ?? 'N/A'),
                  _buildTableCell(recipe['fats']?.toString() ?? 'N/A'),
                  _buildTableCell(recipe['carbs']?.toString() ?? 'N/A'),
                ],
              );
            }).toList(),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  List<List<dynamic>> _divideRecipesByDays(List<dynamic> recipes, int numDays) {
    List<List<dynamic>> dayWiseRecipes = List.generate(numDays, (_) => []);
    for (int i = 0; i < recipes.length; i++) {
      dayWiseRecipes[i % numDays].add(recipes[i]);
    }
    return dayWiseRecipes;
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
