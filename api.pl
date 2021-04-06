% api.pl 
:- use_module(library(http/json)).
:- use_module(library(http/http_open)).
:- consult(kb).

%% app_ID - aa18a42a
%% app_key - 1ba4f3337583c50ad6d1071f22fbefad
%% fetch_url - https://api.edamam.com/search?)

% Sample query: https://api.edamam.com/search?app_id=aa18a42a&app_key=1ba4f3337583c50ad6d1071f22fbefad&q=dimsum


%% construct_url is true if URL is the URL used to fetch recipes from API
construct_url(Food, Queries, URL) :-
	fetch_url = "https://api.edamam.com/search?app_id=aa18a42a&app_key=1ba4f3337583c50ad6d1071f22fbefad&q=",
	string_concat(fetch_url, Food, URL),
	add_queries(URL, Queries, QURL).


%% adds all necessary extensions for the given list of queries
add_queries(URL1, [], URL1).

add_queries(URL1, [query(Key, Val)|T], QURL) :-
	string_concat(URL1, Val, URL),
	add_queries(URL, T, URL, QURL)

%% Retrives all reciepes 
fetch_recipes(URL, Data) :-
	setup_call_concat(
		http_open(URL, In, []),
		json_read_dict(In, Data),
		close(In)
	).