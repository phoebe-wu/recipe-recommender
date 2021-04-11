query('keto', "&health=keto-friendly").
query('vegan', "&health=vegan").
query('vegetarian', "&health=vegetarian").
query('pescatarian', "&health=pescatarian").
query('paleo', "&health=paleo").
query('kosher', "&health=kosher").
query('gluten free', "&health=gluten-free").
query('gluten-free', "&health=gluten-free").

query('no gluten', "&health=gluten-free").
query('no shellfish', "&health=shellfish-free").
query('no soy', "&health=soy-free").
query('no wheat', "&health=wheat-free").
query('no peanuts', "&health=peanut-free").
query('no diary', "&health=dairy-free").
query('no pork', "&health=pork-free").
query('no red meat', "&health=no-red-meat").
query('no fish', "&health=fish-free").
query('no nuts', "&health=tree-nut-free&health=peanut-free").

query('high fiber', "&diet=high-fiber").
query('high protein', "&diet=high-protein").
query('low carb', "&diet=low-carb").
query('low fat', "&diet=low-fat").
query('low sodium', "&diet=low-sodium").
query('low sugar', "&health=sugar-conscious").

query('breakfast', "&mealType=Breakfast").
query('lunch', "&mealType=Lunch").
query('dinner', "&mealType=Dinner").
query('snack', "&mealType=Snack").
query('dessert', "&dishType=Desserts").
query('drink', "&dishType=Drinks").

% query(EP, EQ) :-
%     atom_concat('no ', E, EP),
%     atomic_concat("&excluded=", E, EQ).