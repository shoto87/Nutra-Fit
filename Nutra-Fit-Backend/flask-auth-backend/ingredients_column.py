import pandas as pd

#Reading specific columns from excel sheet
excel1=r'Nutra-Fit-Backend/flask-auth-backend/P_recipes_100.xlsx'
df=pd.read_excel(excel1,usecols="C,D")
print(df)

# Make bunch of all unique ingredients from each recipe
ingredient=set()
for i in df['TranslatedIngredients']:
    if isinstance(i, str):
        for j in i.split(','):
            ingredient.add(j.strip())
print(ingredient)

# Creating new dataframe where ingredients will be stored in columns
new_df=pd.DataFrame(index=df['TranslatedRecipeName'],columns=list(ingredient))
print(new_df)
