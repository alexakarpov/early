-module(test3).
-export([test/0, factorial/1]).

test() ->
    factorial(-5).

factorial(0) ->
    1;
factorial(X) ->
    X * factorial(X-1).
