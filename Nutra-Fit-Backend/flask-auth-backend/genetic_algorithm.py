import numpy as np
import pandas as pd
from random import sample, choices, randint

# Function to generate an initial population
def generate_population(recipes_df, population_size):
    population = []
    for _ in range(population_size):
        individual = sample(list(recipes_df.index), 3)  # Select 3 random recipes as an individual
        population.append(individual)
    return population

# Fitness function
def fitness_function(individual, nutrients, target_vector):
    combined_vector = np.sum(nutrients[individual], axis=0)
    distance = np.linalg.norm(combined_vector - target_vector)

    # Ensure that the distance is finite, replace with a large number if it's not
    if not np.isfinite(distance):
        distance = 1e6  # Large penalty for invalid values

    return -distance  # Negative because lower distance means better fitness

# Function to select parents
def select_parents(population, fitness_scores):
    # Sanitize fitness_scores: replace non-finite scores with a very low fitness score
    fitness_scores = [score if np.isfinite(score) else -1e6 for score in fitness_scores]

    # Find the minimum fitness to shift scores to positive values
    min_fitness = min(fitness_scores)
    shifted_fitness_scores = [score - min_fitness + 1 for score in fitness_scores]

    # If all scores are identical, assign equal probability
    if len(set(shifted_fitness_scores)) == 1:
        return choices(population, k=len(population))

    # Ensure the sum of weights is finite and non-zero
    total_weight = sum(shifted_fitness_scores)
    if not np.isfinite(total_weight) or total_weight == 0:
        raise ValueError("Invalid fitness scores: Sum of weights is not finite or zero.")

    parents = choices(population, weights=shifted_fitness_scores, k=len(population))
    return parents

# Crossover function
def crossover(parent1, parent2):
    point = randint(1, len(parent1) - 1)
    child1 = parent1[:point] + parent2[point:]
    child2 = parent2[:point] + parent1[point:]
    return child1, child2

# Mutation function
def mutate(individual, recipes_df, mutation_rate):
    if np.random.rand() < mutation_rate:
        idx_to_replace = randint(0, len(individual) - 1)
        new_recipe = sample(list(recipes_df.index), 1)[0]
        while new_recipe in individual:
            new_recipe = sample(list(recipes_df.index), 1)[0]
        individual[idx_to_replace] = new_recipe
    return individual

# Genetic Algorithm
def genetic_algorithm(recipes_df, target_vector, nutrients, population_size, num_generations, mutation_rate):
    population = generate_population(recipes_df, population_size)
    for generation in range(num_generations):
        fitness_scores = [fitness_function(ind, nutrients, target_vector) for ind in population]
        
        # Debug: Print out fitness scores to see if there are any issues
        #print(f"Generation {generation} Fitness Scores: {fitness_scores}")
        
        parents = select_parents(population, fitness_scores)
        next_generation = []

        # Iterate over pairs of parents
        for i in range(0, len(parents) - 1, 2):
            child1, child2 = crossover(parents[i], parents[i + 1])
            next_generation.extend([
                mutate(child1, recipes_df, mutation_rate), 
                mutate(child2, recipes_df, mutation_rate)
            ])

        # Handle the case where the number of parents is odd
        if len(parents) % 2 == 1:
            last_parent = parents[-1]
            mutated_last_parent = mutate(last_parent, recipes_df, mutation_rate)
            next_generation.append(mutated_last_parent)

        population = next_generation

    # Identify the best individual after all generations
    best_individual = max(population, key=lambda ind: fitness_function(ind, nutrients, target_vector))
    best_recipes = recipes_df.iloc[best_individual]
    return best_recipes
