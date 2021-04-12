:- consult(kb).
:- consult(api).

%% The recipe the user wants to search for
%% e.g. 
%% biscuits
%% gluten-free bread
%% vegan carrot cake
%% keto fried chicken
%% low carb pasta 
%% some chocolate chip cookies that are paleo
%% an apple pie that doesn't have dairy
%% dumplings with no meat
%% barbeque chicken wings that are peanut free
%% brownies without nuts


start :-
    write("What would you like to cook?\n"), 
    flush_output(current_output),
    readln(Ln),
    prelim_ask(Ln, Prelim_URL),
    write("Please list any allergies. Enter none if you do not have any allergies\n"),
    readln(NextLn),
    allergy_ask(NextLn, Allergy_Extensions),
    string_concat(Prelim_URL, Allergy_Extensions, Next_URL),
    write("How much time do you have?\n"),
    readln(TimeLn),
	handle_time(TimeLn, Time),
    add_time_constraint(Next_URL, Time, Final_URL),
    fetch_recipes(Final_URL, A),
    nb_setval(count, 0),
    handle_request(yes, A).

%% returns first recipe details to user 
%% returns the following recipes if user wants to see more recipes
handle_request(yes, A) :-
	nb_getval(count, C), NewC is C + 1, nb_setval(count, NewC),
	nb_getval(count, Num),
	nl,
	print_recipe_details(A, Num),
	nl,
	write("Would you like to see a different recipe? (yes or no)\n"),
	readln(AnotherLn),
	yes_or_no(AnotherLn, A).

%% ends program when user does not want to see any more recipes
handle_request(no, _) :-
	nl,
	write("Thank you for using our recipe recommender! ").

%% parses user response if they want to see more recipes
yes_or_no([R|_], A) :-
	handle_request(R, A).

%% constructs preliminary URL based on users first recipe request
prelim_ask(Q, URL) :-
     recipe_request(Q, [], Food, C, []),
     construct_url(Food, C, URL).

%% creates the extensions for any allergies the user might have
allergy_ask(Q, Extensions) :-
	allergies(Q, P),
	separate_allergies(P, Q1, A1),
	parse_query_extensions(Q1, Q2),
    atomics_to_string(Q2, Q3),
	add_allergy(Q3, A1, Extensions).


%% parses a time phrase into that time in minutes
handle_time([W|T], Time) :-
	number_word(W,N),
	handle_time([N|T],Time).
handle_time([N,'hour'], Time) :-
	number(N),
	Time is N * 60.
handle_time([N,'hours'], Time) :-
	number(N),
	Time is N * 60.
handle_time([N,'minutes'], N) :-
	number(N).
handle_time([N,'minute'], N) :-
	number(N).
handle_time([N], N) :-
	number(N).		

%% The recipe request made
%% P0 and P4 are lists of words, that forms the recipe request
%% C0 - C4 are the list of constraints imposed on entity 
recipe_request(P0, P4, Entity, C0, C3) :-
	leading_phrase(P0, P1),
	det(P1, P2, Entity, C0, C1),
	food_phrase(P2, P3, Entity, C1, C2),
	modifying_phrase(P3, P4, Entity, C2, C3).

%% An optional leading phrase for recipe request
leading_phrase(['I', 'want', 'to', 'cook' |P], P).
leading_phrase(['I', 'want', 'to', 'make' |P], P).
leading_phrase(['I', 'am', 'allergic', 'to'|P], P).
leading_phrase(['I\'m', 'allergic', 'to'|P], P).
leading_phrase(P,P).

%% An optional determiner in recipe request
det(['some' |P],P,_,C,C).
det(['a' |P],P,_,C,C).
det(['an' |P],P,_,C,C).
det(P,P,_,C,C).

%% food_phrase contains the food to search for
food_phrase(P0, P2, Entity, C0, C2) :-
	adjectives(P0, P1, Entity, C0, C1),
	food(P1, P2, Entity, C1, C2).

%% try: food_phrase([wheat, free, brownies], P, brownies, C, C1).

%% the list of adjectives/constraints put on the food
%% e.g. vegan, gluten-free 
adjectives([Restriction|T], P, Entity, [Extension|C0], C) :-
	query(Restriction, Extension),
	adjectives(T, P, Entity, C0, C).
adjectives(RP, P, Entity, [Extension|C0], C) :-
	append(R,P1, RP),
	multi_part_word(R, Restriction),
	query(Restriction, Extension),
	adjectives(P1,P,Entity,C0,C).
adjectives(P,P,_,C,C).

%% try: adjectives([vegan, chicken], P, E, C, C1).
%% try: adjectives([no, wheat], P, E, C, C1).
%% try: adjectives([no, wheat, chicken], P, E, C, C1).
%% try: adjectives([vegan, chicken, with, no, shellfish], P, E, C, C1).
%% try: adjectives([gluten, free, brownies], P, E, C, C1).
%% try: adjectives([wheat, free, brownies], P, E, C, C1).

%% returns true if a list of words can be made into one word
multi_part_word(P,W) :-
	standardize_free(P,W).
multi_part_word(P,W) :-
	atomic_list_concat(P, ' ', W).
multi_part_word(P,W) :-
	atomic_list_concat(P,W).
	
%% try: multi_part_word([no, wheat, brownies], W).

%% standardizes decriptors such as "gluten free" or "gluten free" into "no gluten"
standardize_free([O, '-', 'free'], W) :-
	atomic_list_concat(['no', O], ' ', W).
standardize_free([O, 'free'], W) :-
	atomic_list_concat(['no', O], ' ', W).

%% try: standardize_free([wheat, free], W).


%% returns true if Food is the first part of the phrase. Food can consist of multiple words.
food(P0,P1,Food,C,C) :-
	append(FP,P1,P0),
	atomic_list_concat(FP,'+',Food).

%% try: food([chicken, with, no, shellfish], P, F, C, C).

%% An optional modifying phrase that further modifies the recipe criteria
modifying_phrase(['that', 'is'|P0], P1, _, C0, C1) :-
	adjectives(P0,P1,_,C0,C1).
modifying_phrase(['that', 'does', 'not', 'have'|P0], P1, _, C0, C1) :-
	adjectives(['no'|P0],P1,_,C0,C1).
modifying_phrase(['that', 'doesn', '\'', 't', 'have'|P0], P1, _, C0, C1) :-
	adjectives(['no'|P0],P1,_,C0,C1).
modifying_phrase(['that', 'don', '\'', 't', 'have'|P0], P1, _, C0, C1) :-
	adjectives(['no'|P0],P1,_,C0,C1).		
modifying_phrase(['that', '\'', 's'|P0], P1, _, C0, C1) :-
	adjectives(P0,P1,_,C0,C1).
modifying_phrase(['that', 'are'|P0], P1, _, C0, C1) :-
	adjectives(P0,P1,_,C0,C1).
modifying_phrase(['that', '\'', 're'|P0], P1, _, C0, C1) :-
	adjectives(P0,P1,_,C0,C1).
modifying_phrase(['without'|P0], P1, _, C0, C1) :-
	adjectives(['no'|P0],P1,_,C0,C1).
modifying_phrase(['with'|P0], P1, _, C0, C1) :-
	adjectives(P0,P1,_,C0,C1).
modifying_phrase(P, P, _, C, C).

%% e.g. 
%?- allergies([shellfish],P).
%?- allergies([I, am, allergic, to, shrimp],P).
%?- allergies([I, am, allergic, to, shrimp, and, garlic],P).
%?- allergies([peanuts, apples, tomatoes],P).
%% allergies is true if P2 is the list of foods the user is allergic to
allergies(P0, P2) :-
	leading_phrase(P0, P1),
	allergens(P1, P2).

%% allergens is the list of things user wants absent from their recipes
allergens(P,P2) :-
	delete(P, ',', P1),
	delete(P1, 'and', P2).






