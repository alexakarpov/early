-module(my_bifs).
-export([my_tuple_to_list/1, timing/1]).

my_tuple_to_list(T) ->
    ttl_help(T, size(T), []).

ttl_help(_, 0, Acc) -> Acc;
ttl_help(T, N, Acc) -> ttl_help(T, N-1, [element(N, T)|Acc]).


timing(F) ->
    X = erlang:system_time(),
    F(),
    Y = erlang:system_time(),
    Y-X.
