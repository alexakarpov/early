-module(exercise_ch5).
-export([map_search_pred/2]).

map_search_pred(M, P) ->
    lists:filter(P, maps:to_list(M)).
