# -*- coding: utf-8 -*-
"""
Created on Thu Nov 14 01:29:05 2024

@author: manes
"""

import pandas as pd


from wtloss import wtloss
from wtmaintenance import wtmen

#Function to calculate BMI
def calculate_bmi(weight, height):
    height_m = height / 100  # Convert height from cm to meters
    return weight / (height_m ** 2)

#Function for diabetes management
def diabetes(wt, ht, gender, age, work):
    #Calculate BMI
    bmi = calculate_bmi(wt, ht)
    print(f"BMI is: {bmi}")
    
    if bmi >= 25:
        print("BMI is >= 25. Running wtloss...")
    
        wtloss(wt, ht, gender, age, work)
    else:
        print("BMI is < 25. Running wtmaintenance...")

        wtmen(wt, ht, gender, age, work)


if __name__ == "__main__":

    wt = 30 
    ht = 175
    gender = "M" 
    age = 30
    work = "sedentary" 

   
    diabetes(wt, ht, gender, age, work)
