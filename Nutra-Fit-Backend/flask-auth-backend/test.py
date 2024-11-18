# Load the recipe data
import pandas as pd
recipe_file = r'.\recipe_nutrient_matrix.xlsx'
recipe_df = pd.read_excel(recipe_file)

# Print column names to debug
print(recipe_df.columns)
