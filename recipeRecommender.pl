
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

%% P0 and P3 are lists of words, that forms the recipe request
%% C0 - C4 are the list of constraints imposed on entity 
recipe_request(P0, P3, Entity, C0, C3) :-
	det(P0, P1, Entity, C0, C1),
	food_phrase(P1, P2, Entity, C1, C2),
	modifying_phrase(P2, P3, Entity, C2, C3).


det(['some' |P],P,_,C,C).
det(['a' |P],P,_,C,C).
det(['an' |P],P,_,C,C).
det(P,P,_,C,C).

food_phrase(P0, P2, Entity, C0, C2) :-
	adjectives(P0, P1, Entity, C0, C1),
	food(P1, P2, Entity, C1, C2).

%% UNFINISHED!!! 
%% NOTE: might cause problems if we have a list of Queries and Adjectives (NEED SOLUTION)
%% 		-- could we make a query from the Adj (?????)
%% 
adjectives([Restriction|P], P, _, [query(Restriction, Extension)|C], C).
adjectives([Adj|P, P, _, [Adj|C], C).
adjectives(['doesn\'t have'|P], P, _, []) %% unfinished
adjectives(P,P,_,C,C).

food([Food|P],P,_,C,C).

modifying_phrase(['that', 'is'|P0], P1, _, C0, C1) :-
	adjectives(P0,P1,_,C0,C1).
modifying_phrase(['that\'s'|P0], P1, _, C0, C1) :-
	adjectives(P0,P1,_,C0,C1).
modifying_phrase(['that', 'are'|P0], P1, _, C0, C1) :-
	adjectives(P0,P1,_,C0,C1).
modifying_phrase(['that\'re'|P0], P1, _, C0, C1) :-
	adjectives(P0,P1,_,C0,C1).
modifying_phrase(['without'|P0], P1, _, C0, C1) :-
	adjectives(P0,P1,_,C0,C1).
modifying_phrase(['with'|P0], P1, _, C0, C1) :-
	adjectives(P0,P1,_,C0,C1).
modifying_phrase(P, P, _, C, C).