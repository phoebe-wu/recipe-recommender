# Recipe Recommender

A recipe recommender implemented in Prolog

Program uses NLP to parse user's recipe request and pulls a recipe from an API that satisfies all of the inputted criteria. 

## Sample:

**Output: "What would you like to cook?"**

Possible User Inputs:

- falafel
- dessert
- vegetarian pizza
- gluten-free bread
- soy sauce chicken
- gluten-free pizza dough
- vegan carrot cake
- dumplings with no meat
- barbeque chicken wings that are peanut free
- keto fried chicken
- low carb pasta
- a pizza that is vegan
- nut free apple pie without cinnamon
- some oatmeal cookies that doesn't have raisins
- cilantro free pho
- pie that doesn't have shortening

**Output: "Please list any allergies. Enter none if you do not have any allergies"**

Possible User Inputs:

- peanuts
- soy
- I am allergic to shellfish, tomatoes, and lobster
- ginger, oranges, and celery

**Output: "How much time do you have?"**

Possible User Inputs:

- 50 minutes
- 3 hours
- four hours


**Output: "We recommend, *name of recipe*"**

***Ingredients***

***URL to recipe***

**Would you like to see a different recipe? (yes or no)**

Possible User Inputs:

- yes
- no

"yes" will show more recipes

## Prerequistes

- swipl on terminal is recommended.
- You must have an Edamam App ID and API key. Get one [here](https://developer.edamam.com/edamam-recipe-api).
- You must set env variables EDAMAM_APP_ID with your app ID and EDAMAM_API_KEY with your API key.

## To run

1. run `[recipeRecommender].` in swipl.
2. type `start.`
3. have fun!

