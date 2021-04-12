# Recipe Recommender

A recipe recommender implemented in Prolog

## Sample:

**Output: "What would you like to cook?"**

Possible User Inputs:

- soy sauce chicken
- gluten-free pizza dough
- falafel
- dessert
- vegetarian pizza
- gluten-free bread
- vegan carrot cake
- dumplings with no meat
- barbeque chicken wings that are peanut free
- keto fried chicken
- low carb pasta
- a pizza that is vegan

**Output: "Please list any allergies. Enter none if you do not have any allergies"**

Possible User Inputs:

- peanuts
- soy
- gluten

**Output: "We recommend, *name of recipe*"**

***Ingredients***

***URL to recipe***

***Would you like to see a different recipe? (yes or no)***

Possible User Inputs:

- yes
- no

"yes" will show more recipes

## Prereqs

- swipl on terminal is recommended.
- You must have an Edamam App ID and API key. Get one [here](https://developer.edamam.com/edamam-recipe-api).
- You must set env variables EDAMAM_APP_ID with your app ID and EDAMAM_API_KEY with your API key.

## To run

1. run `[recipeRecommender].` in swipl.
2. type `start.`
3. have fun!

