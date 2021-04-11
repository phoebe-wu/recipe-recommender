query('keto', "&health=keto-friendly").
query('vegan', "&health=vegan").
query('vegetarian', "&health=vegetarian").
query('no pork', "&health=pork-free").
query('pescatarian', "&health=pescatarian").
query('no peanuts', "&health=peanut-free").
query('no diary', "&health=dairy-free").
query('paleo', "&health=paleo").
query('kosher', "&health=kosher").
query('no soy', "&health=soy-free").
query('no wheat', "&health=wheat-free").
query('gluten free', "&health=wheat-free").
query('gluten-free', "&health=wheat-free").
query('no shellfish', "&health=shellfish-free").
query('low sugar', "&health=sugar-conscious").

query('high fiber', "&diet=high-fiber").
query('high protein', "&diet=high-protein").
query('low carb', "&diet=low-carb").
query('low fat', "&diet=low-fat").
query('low sodium', "&diet=low-sodium").

query('breakfast', "&mealType=Breakfast").
query('lunch', "&mealType=Lunch").
query('dinner', "&mealType=Dinner").
query('snack', "&mealType=Snack").
query('dessert', "&dishType=Desserts").
query('drink', "&dishType=Drinks").

query(EP, EQ) :-
    atom_concat('no ', E, EP),
    atomic_concat("&excluded=", E, EQ).