% api.pl 
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
	replace(Food, FoodPlus),
	name_value("q", FoodPlus, FoodPair),
	atomics_to_string([IdPair, KeyPair, FoodPair], '&', Tail),
	string_concat("https://api.edamam.com/search?", Tail, URL),
	add_queries(URL, Queries, QURL).


%% adds all necessary extensions for the given list of queries
add_queries(URL1, [], QURL).

add_queries(URL1, [query(Key, Val)|T], QURL) :-
	string_concat(URL1, Val, URL),
	add_queries(URL, T, URL, QURL).


%% Retrives all reciepes 
fetch_recipes(URL, Data) :-
	setup_call_cleanup(
		http_open(URL, In, []),
		json_read_dict(In, Data),
		close(In)
	).

%% replaces possible spaces with "+" for foods with more than one word
replace(X,Y) :-
	split_string(X, "\s", "\s", L),
	atomic_list_concat(L, '+', Y).

%% add allergies
%% use query kb for (peaunuts, soy, dairy, shellfish, wheat, pork, gluten).
add_allergy(URL, [], AURL).

add_allergy(URL, [H|T], AURL) :-
	replace(H,Allergy),
	name_value('&excluded', Allergy, AllergyPair),
	string_concat(URL, AllergyPair, URL1),
	add_allergy(URL1, T, AURL).