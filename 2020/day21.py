import re

def read_input(file):
    with open(file, "r") as fin:
        ingredients_pattern = re.compile(r"^([a-z ]+)")
        allergens_pattern = re.compile(r"\(contains ([a-z, ]+)+\)$")
        foods = []
        for l in fin.readlines():
            ingredients = ingredients_pattern.findall(l)[0].strip().split(" ")
            allergens = allergens_pattern.findall(l)[0].strip().split(", ")
            #print("ingredients=", ingredients, "allergens=", allergens)
            foods.append((ingredients, allergens))
        return foods

def process(foods):
    unique_ingredients = set()
    unique_allergens = set()
    for ingredients, allergens in foods:
        unique_ingredients.update(ingredients)
        unique_allergens.update(allergens)

    allergen_ingredients = {}
    while len(allergen_ingredients.keys()) < len(unique_allergens):
        for allergen in unique_allergens:
            if allergen in allergen_ingredients:
                continue
            
            matching_foods = list(filter(lambda tuple: allergen in tuple[1], foods))

            possible_ingredients = set(unique_ingredients)
            for ingredients, allergens in matching_foods:
                possible_ingredients = possible_ingredients.intersection(ingredients)

            # remove all ingredients we've already found the allergen for
            possible_ingredients -= set(allergen_ingredients.values())

            # if we've isolated the ingredient, track it
            if len(possible_ingredients) == 1:
                allergen_ingredients[allergen] = list(possible_ingredients)[0]
    
    return (allergen_ingredients, set(unique_ingredients) - set(allergen_ingredients.values()))

def run(label, input_file):
    foods = read_input(input_file)
    allergen_ingredients, inert_ingredients = process(foods)

    inert_ingredient_food_count = 0
    for i in inert_ingredients:
        for f in foods:
            inert_ingredient_food_count += 1 if i in f[0] else 0
    
    print("{} 1: {}".format(label, inert_ingredient_food_count))

    canonical_dangerous_ingredients = []
    for a in sorted(list(allergen_ingredients.keys())):
        canonical_dangerous_ingredients.append(allergen_ingredients[a])
    
    print("{} 2: {}".format(label, ",".join(canonical_dangerous_ingredients)))

run("test", "day21-input-test")
run("part", "day21-input")