from genetic_algorithm import genetic_algorithm
import numpy as np
import pandas as pd

# Function for CKD dietary recommendations
def chronickidneydisease(condition_type, ckd_stage):
    """
    Prescribes the recommended daily intake of key nutrients (Vitamin D, Calcium, Phosphorus, Potassium, Sodium, Protein)
    based on the type and stage of Chronic Kidney Disease (CKD).
    """
    # Nutritional recommendations dictionary
    recommendations = {
        'Vitamin D': None,
        'Calcium': None,
        'Phosphorus': None,
        'Potassium': None,
        'Sodium': None,
        'Protein': None,
    }
    
    # Non-dialysis CKD stages
    if condition_type == "Non-dialysis CKD":
        if ckd_stage in ["CKD G3a", "CKD G3b"]:
            recommendations.update({
                'Vitamin D': 0.8,
                'Calcium': 0.8,
                'Phosphorus': 0.8,
                'Potassium': 3.0,
                'Sodium': 2.15,
                'Protein': 0.7,
            })
        elif ckd_stage in ["CKD G1", "CKD G2"]:
            recommendations.update({
                'Vitamin D': 0.8,
                'Calcium': 0.8,
                'Phosphorus': None,
                'Potassium': 4.7,
                'Sodium': 2.15,
                'Protein': 0.9,
            })
    
    # Target nutrient vector
    target_vector = np.array([recommendations['Protein'], recommendations['Calcium'], recommendations['Phosphorus'],
                              recommendations['Potassium'], recommendations['Sodium']])

    # Load recipe nutrient data
    recipe_file = r'/home/pratik/NUTRA-FIT/BACKEND/recipe_nutrient_matrix.xlsx'
    recipe_df = pd.read_excel(recipe_file)

    # Filter relevant columns
    recipes_df = recipe_df[['Recipe Name', recipe_df.columns[7], recipe_df.columns[16], recipe_df.columns[22],
                            recipe_df.columns[23], recipe_df.columns[25], recipe_df.columns[11]]]
    recipes_df.columns = ['recipe_name', 'protein', 'calcium', 'phosphorus', 'potassium', 'sodium', 'vitamin_d']

    # Extract nutrient data for the genetic algorithm
    nutrients = recipes_df[['protein', 'calcium', 'phosphorus', 'potassium', 'sodium']].values

    # Genetic algorithm parameters
    population_size = 5
    num_generations = 10
    mutation_rate = 0.01

    # Run the genetic algorithm to select the best recipes
    best_recipes = genetic_algorithm(recipes_df, target_vector, nutrients, population_size, num_generations, mutation_rate)

    # Calculate total nutrients and prepare the result
    total_nutrients = {
        'Protein': 0,
        'Calcium': 0,
        'Phosphorus': 0,
        'Potassium': 0,
        'Sodium': 0,
        'Vitamin D': 0
    }
    selected_recipes = []

    for _, row in best_recipes.iterrows():
        recipe_info = {
            'recipe_name': row['recipe_name'],
            'Protein': row['protein'],
            'Calcium': row['calcium'],
            'Phosphorus': row['phosphorus'],
            'Potassium': row['potassium'],
            'Sodium': row['sodium'],
            'Vitamin D': row['vitamin_d']
        }
        selected_recipes.append(recipe_info)

        # Update totals
        total_nutrients['Protein'] += row['protein']
        total_nutrients['Calcium'] += row['calcium']
        total_nutrients['Phosphorus'] += row['phosphorus']
        total_nutrients['Potassium'] += row['potassium']
        total_nutrients['Sodium'] += row['sodium']
        total_nutrients['Vitamin D'] += row['vitamin_d']

    # Return selected recipes and total nutrients
    return selected_recipes, total_nutrients


# Run the function with an example input
selected_recipes, totals = chronickidneydisease("Non-dialysis CKD", "CKD G3a")

# Example usage to display results
#print("\nSelected Recipes:")
#for recipe in selected_recipes:
 #   print(recipe)

#print("\nTotal Nutrient Values:")
#print(totals)
