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
    write("What would you like to cook? "), flush_output(current_output),
    readln(Ln),
	ask(Ln,A).

ask(Q,A) :-
	recipe_request(Q, [], Food, C, []),
	ask_api(Food, C, A),
	get_recipe_details(A, Title, Ingredients, Link),
	write("We recommend, "),
	writeln(Title),
	writeln("Ingredient List: "),
	writeln(Ingredients),
	write("Link to Recipe: "),
	writeln(Link).

%% P0 and P4 are lists of words, that forms the recipe request
%% C0 - C4 are the list of constraints imposed on entity 
recipe_request(P0, P4, Entity, C0, C3) :-
	leading_phrase(P0, P1),
	det(P1, P2, Entity, C0, C1),
	food_phrase(P2, P3, Entity, C1, C2),
	modifying_phrase(P3, P4, Entity, C2, C3).

leading_phrase(['I', 'want', 'to', 'cook' |P], P).
leading_phrase(['I', 'want', 'to', 'make' |P], P).
leading_phrase(P,P).

det(['some' |P],P,_,C,C).
det(['a' |P],P,_,C,C).
det(['an' |P],P,_,C,C).
det(P,P,_,C,C).

food_phrase(P0, P2, Entity, C0, C2) :-
	adjectives(P0, P1, Entity, C0, C1),
	food(P1, P2, Entity, C1, C2).

%% try: food_phrase([wheat, free, brownies], P, brownies, C, C1).

food([Food|P],P,Food,C,C).
food(P,_,Food,C,C) :-
	multi_part_food(P,Food).

multi_part_food(P,Food) :-
	atomic_list_concat(P,'+',Food).

%% UNFINISHED!!! 
%% NOTE: might cause problems if we have a list of Queries and Adjectives (NEED SOLUTION)
%% 		-- could we make a query from the Adj (?????)
%% 
%%adjectives([],_,_,[],_).
adjectives([Restriction|P], P1, Entity, [Extension|C], C1) :-
	query(Restriction, Extension),
	adjectives(P,P1,Entity,C,C1).
adjectives(RP, P1, Entity, [Extension|C], C1) :-
	append(R,P, RP),
	multi_part_adj(R, Restriction),
	query(Restriction, Extension),
	adjectives(P,P1,Entity,C,C1).
adjectives(P,P,_,C,C).

%% try: adjectives([vegan, chicken], P, E, C, C1).
%% try: adjectives([no, wheat], P, E, C, C1).
%% try: adjectives([no, wheat, chicken], P, E, C, C1).
%% try: adjectives([vegan, chicken, with, no, shellfish], P, E, C, C1).
%% try: adjectives([gluten, free, brownies], P, E, C, C1).
%% try: adjectives([wheat, free, brownies], P, E, C, C1).
%% try: adjectives([vegan, wheat, free, brownies], P, E, C, C1).

multi_part_adj(P,W) :-
	standardize_free(P,W).
multi_part_adj(P,W) :-
	atomic_list_concat(P, ' ', W).
multi_part_adj(P,W) :-
	atomic_list_concat(P,W).
	
%% try: multi_part_adj([no, wheat, brownies], W).

%% standardizes decriptors such as "gluten free" or "gluten free" into "no gluten"
standardize_free([O, '-', 'free'], W) :-
	atomic_list_concat(['no', O], ' ', W).
standardize_free([O, 'free'], W) :-
	atomic_list_concat(['no', O], ' ', W).

%% try: standardize_free([wheat, free], W).

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