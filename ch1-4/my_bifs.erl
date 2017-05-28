-module(my_bifs).
-export([my_tuple_to_list/1, timing/1, date_string/0]).

my_tuple_to_list(T) ->
    ttl_help(T, size(T), []).

ttl_help(_, 0, Acc) -> Acc;
ttl_help(T, N, Acc) -> ttl_help(T, N-1, [element(N, T)|Acc]).


timing(F) ->
    X = erlang:system_time(),
    F(),
    Y = erlang:system_time(),
    Y-X.

date_string() ->
    {H, M, S} = erlang:time(),
    io_lib:format('~2..0b~2..0b~2..0b', [H,M,S]).
