% api.pl manages communication between recipe recommender and api
:- use_module(library(http/json)).
:- use_module(library(http/http_open)).
:- consult(kb).

%% fetch_url - https://api.edamam.com/search?

% Sample query: https://api.edamam.com/search?app_id=EDAMAM_APP_ID&app_key=EDAMAM_API_KEY&q=dimsum


%% gets the enviroment variable for app id
app_id(Id) :-
	getenv("EDAMAM_APP_ID", Id).

%% gets the enviroment variable for API Key
api_key(Key) :-
	getenv("EDAMAM_API_KEY", Key).

%% creates a name value pair, eg. if you have Name as "potato" and Value as "tomato" you'll get "potato=tomato"
name_value(Name, Value, NVP) :-
	List = [Name, Value],
	atomics_to_string(List, '=', NVP).

%% construct_url is true if QURL is the URL with queriesc used to fetch recipes from API
construct_url(Food, Queries, QURL) :-
	app_id(Id),
	name_value("app_id", Id, IdPair),
	api_key(Key),
	name_value("app_key", Key, KeyPair),
	name_value("q", Food, FoodPair),
	atomics_to_string([IdPair, KeyPair, FoodPair], '&', Tail),
	string_concat("https://api.edamam.com/search?", Tail, URL),
	add_queries(URL, Queries, QURL).

%% Retrives all reciepes 
fetch_recipes(URL, Data) :-
	setup_call_cleanup(
		http_open(URL, In, []),
		json_read_dict(In, Data),
		close(In)
	).

%% adds all necessary extensions for the given list of queries
add_queries(URL1, [], URL1).
add_queries(URL1, [Restriction|T], QURL) :-
	string_concat(URL1, Restriction, URL),
	add_queries(URL, T, QURL).

%% try: add_queries("www.food.com", [query(vegan, A)], QURL).

%% is_query returns true if Q is a query
is_query(Q) :-
	member(Q, [gluten, shellfish, soy, wheat, peanuts, diary, pork, fish, nuts]).

%% takes lists of queries and returns their extensions
parse_query_extensions([], []).
parse_query_extensions([H|T], [Extension|Q]) :-
	atomic_concat('no ', H, HQ),
	query(HQ, Extension),
	parse_query_extensions(T, Q). 

%% separates allergies into those who are queries in kb and those who are not
separate_allergies(L, Q, A) :-
	include(is_query, L, Q),
	exclude(is_query, L, A).

%% add allergies
%% use query kb for (peaunuts, nuts, red meat, soy, dairy, shellfish, wheat, pork, fish, gluten).
add_allergy(URL, [], URL).
add_allergy(URL, [H|T], AURL) :-
	atom_string(H, Allergy),
	name_value("&excluded", Allergy, AllergyPair),
	string_concat(URL, AllergyPair, URL1),
	add_allergy(URL1, T, AURL).

%% add time restriction to api fetch
add_time_constraint(URL, Time, TURL) :-
	name_value('&time', Time, TimePair),
	string_concat(URL, TimePair, TURL).

%% gets details from the recipe at Num index
print_recipe_details(Data, Num) :-
	Hits = Data.get('hits'),
	nth1(Num, Hits, FirstHit),
	Recipe = FirstHit.get('recipe'),
	Title = Recipe.get('label'),
	Ingredients = Recipe.get('ingredientLines'),
	Link = Recipe.get('url'),
	write("We recommend, "),
	writeln(Title),
	writeln("Ingredient List: "),
	writeln(Ingredients),
	write("Link to Recipe: "),
	writeln(Link).

print_recipe_details(_, 11) :-
	write("That is all our recommendations. Please do a different search "),
	break().
