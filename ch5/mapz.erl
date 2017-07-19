-module(mapz).
-export([count_chars/1]).

count_chars(Str) ->
    count_chars(Str, #{}).

count_chars([H|T], X) ->
    count_chars(T, maps:update_with(H,fun(V) -> V+1 end, 1,X));
count_chars([], X) -> X.

%count_characters(Str) ->
%    count_characters(Str, #{}).


%count_characters([H|T], #{H := N} = X) ->
%    count_characters(T, X#{H := N+1});
%count_characters([H|T], X) ->
%	count_characters(T, X#{H=>1});
%count_characters([], X) -> X.
