-module(mapz).
-export([count_chars/1]).

count_chars(Str) ->
    count_chars(Str, #{}).

count_chars([H|T], X) ->
    count_chars(T, maps:update_with(H,fun(V) -> V+1 end, 1,X));
count_chars([], X) -> X.
