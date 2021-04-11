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
    write("What would you like to cook? "), 
    flush_output(current_output),
    readln(Ln),
    prelim_ask(Ln, Prelim_URL),
    write("Please list any allergies. Enter none if you do not have any allergies "),
    readln(NextLn),
    allergy_ask(NextLn, Allergy_Extensions),
    string_concat(Prelim_URL, Allergy_Extensions, Next_URL),
    write("How much time do you have? "),
    readln(TimeLn),
    atomics_to_string(TimeLn, Time),
    add_time_constraint(Next_URL, Time, Final_URL),
    ask(Final_URL,A).

ask(Q,A) :-
	fetch_recipes(Q, A),
	get_recipe_details(A, Title, Ingredients, Link),
	write("We recommend, "),
	writeln(Title),
	writeln("Ingredient List: "),
	writeln(Ingredients),
	write("Link to Recipe: "),
	writeln(Link).

prelim_ask(Q, URL) :-
     recipe_request(Q, [], Food, C, []),
     construct_url(Food, C, URL).

allergy_ask(Q, Extensions) :-
	allergies(Q, P),
	separate_allergies(P, Q1, A1),
	atomic_list_concat(Q1, '+', Q2),
     atom_string(Q2, Q3),
	add_allergy(Q3, A1, Extensions).


%% P0 and P4 are lists of words, that forms the recipe request
%% C0 - C4 are the list of constraints imposed on entity 
recipe_request(P0, P4, Entity, C0, C3) :-
	leading_phrase(P0, P1),
	det(P1, P2, Entity, C0, C1),
	food_phrase(P2, P3, Entity, C1, C2),
	modifying_phrase(P3, P4, Entity, C2, C3).

leading_phrase(['I', 'want', 'to', 'cook' |P], P).
leading_phrase(['I', 'want', 'to', 'make' |P], P).
leading_phrase(['I', 'am', 'allergic', 'to'|P], P).
leading_phrase(P,P).

det(['some' |P],P,_,C,C).
det(['a' |P],P,_,C,C).
det(['an' |P],P,_,C,C).
det(P,P,_,C,C).

food_phrase(P0, P2, Entity, C0, C2) :-
	adjectives(P0, P1, Entity, C0, C1),
	food(P1, P2, Entity, C1, C2).

%% try: food_phrase([wheat, free, brownies], P, brownies, C, C1).

%% UNFINISHED!!! 
%% NOTE: might cause problems if we have a list of Queries and Adjectives (NEED SOLUTION)
%% 		-- could we make a query from the Adj (?????)
%% 

adjectives([Restriction|T], P, _, [Extension|C0], C) :-
	query(Restriction, Extension),
	adjectives(T, P, _, C0, C).
adjectives(RP, P, _, [Extension|C], C) :-
	append(R,P, RP),
	multi_part_word(R, Restriction),
	query(Restriction, Extension).
adjectives(P,P,_,C,C).

%% try: adjectives([vegan, chicken], P, E, C, C1).
%% try: adjectives([no, wheat], P, E, C, C1).
%% try: adjectives([no, wheat, chicken], P, E, C, C1).
%% try: adjectives([vegan, chicken, with, no, shellfish], P, E, C, C1).
%% try: adjectives([gluten, free, brownies], P, E, C, C1).
%% try: adjectives([wheat, free, brownies], P, E, C, C1).

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
food([Food|P],P,Food,C,C).
food(P0,P1,Food,C,C) :-
	append(FP,P1,P0),
	atomic_list_concat(FP,'+',Food).

%% try: food([chicken, with, no, shellfish], P, F, C, C).

modifying_phrase(['that', 'is'|P0], P1, _, C0, C1) :-
	adjectives(P0,P1,_,C0,C1).
modifying_phrase(['that\'s'|P0], P1, _, C0, C1) :-
	adjectives(P0,P1,_,C0,C1).
modifying_phrase(['that', 'are'|P0], P1, _, C0, C1) :-
	adjectives(P0,P1,_,C0,C1).
modifying_phrase(['that\'re'|P0], P1, _, C0, C1) :-
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
allergens(P,P).

%% separates allergies into those who are queries in kb and those who are not
separate_allergies(L, Q, A) :-
	include(is_query, L, Q),
	exclude(is_query, L, A).

%% is_query returns true if Q is a query
is_query(Q) :-
	member(Q, [gluten, shellfish, soy, wheat, peanuts, diary, pork, fish, nuts]).

%% takes lists of queries and returns their extension
make_queries([], []).
make_queries([H|T], [Extension|Q]) :-
	atomic_concat('no ', H, HQ),
	query(HQ, Extension),
	make_queries(T, Q). 