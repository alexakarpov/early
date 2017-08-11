-module(foo).

-export([funt/0, funf/0]).

funt() ->
    io:format("true...~n"),
    true.
    
funf() ->
    io:format("false...~n"),
    false.
