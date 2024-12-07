# wtloss.py
import numpy as np
import pandas as pd
from genetic_algorithm import genetic_algorithm

# Function to calculate BMR
def CalculateBMR(wt, ht, gender, age):
    if gender == "Male":
        BMR = 10 * wt + 6.25 * ht - 5 * age + 5
    elif gender == "Female":
        BMR = 10 * wt + 6.25 * ht - 5 * age - 161
    else:
        raise ValueError("Invalid gender. Please provide 'M' for male or 'F' for female.")
    return BMR

# Weight loss function
def wtloss(wt, ht, gender, age, work):
    BMR = CalculateBMR(wt, ht, gender, age)

    if work == "sedentary":
        TDC = BMR * 1.2
    elif work == "light":
        TDC = BMR * 1.375
    elif work == "moderate":
        TDC = BMR * 1.55
    else:
        raise ValueError("Invalid work type. Please provide 'sedentary', 'light', or 'moderate'.")

    # Reduce calories by 500 for weight loss
    TDC -= 500

    # Calculate macronutrient targets in grams
    P = (0.3 * TDC) / 4  # Protein target in grams
    F = (0.25 * TDC) / 9  # Fats target in grams
    C = (0.45 * TDC) / 4  # Carbs target in grams

    # Set the target vector for the genetic algorithm
    target_vector = np.array([P, F, C])

    # Load the recipe data
    recipe_file = r'/home/pratik/NUTRA-FIT/BACKEND/recipe_nutrient_matrix.xlsx'
    recipe_df = pd.read_excel(recipe_file)

    # Select relevant columns: recipe name, protein (column 6), fats (column 4), and carbs (column 5)
    recipes_df = recipe_df[['Recipe Name', recipe_df.columns[6], recipe_df.columns[3], recipe_df.columns[5]]]
    recipes_df.columns = ['recipe_name', 'protein', 'fats', 'carbs']

    # Extract nutrient data
    nutrients = recipes_df[['protein', 'fats', 'carbs']].values

    # Genetic Algorithm parameters
    population_size = 5
    num_generations = 10
    mutation_rate = 0.01

    # Run the genetic algorithm
    best_recipes = genetic_algorithm(recipes_df, target_vector, nutrients, population_size, num_generations, mutation_rate)

    result = []
    for index, row in best_recipes.iterrows():
        result.append({
            'recipe_name': row['recipe_name'],
            'protein': row['protein'],
            'fats': row['fats'],
            'carbs': row['carbs']
        })

    return result
