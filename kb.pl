%% kb.pl contains URL extensions for the queries/constraints supported by recipe recommender

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
query('no dairy', "&health=dairy-free").
query('no pork', "&health=pork-free").
query('no red meat', "&health=no-red-meat").
query('no fish', "&health=fish-free").
query('no nuts', "&health=tree-nut-free&health=peanut-free").
query('no meat', "&health=vegetarian").

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

query(EP, EQ) :-
    atom_concat('no ', E, EP),
    atomic_concat("&excluded=", E, EQ).

number_word(one,1).
number_word(two,2).
number_word(three,3).
number_word(four,4).
number_word(five,5).
number_word(six,6).
number_word(seven,7).
number_word(eight,8).
number_word(nine,9).
number_word(ten,10).
number_word(twenty,20).
number_word(thirty,30).
number_word(fourty,40).
number_word(fifty,50).