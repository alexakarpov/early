-module(math_fun).
-export([odd/1, even/1, filter/2]).


odd(X) when not is_integer(X) -> nan;
odd(N) ->
    case N rem 2 of
       1 -> true;
       0 -> false
    end.

even(N) ->
    not odd(N).

filter(F, L)->
    [X || X <- L, F(X) =:= true].
