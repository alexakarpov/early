-module(test2).
-export([myand/2, bug/2]).

myand(true, true) -> true;
myand(false, _) -> false;
myand(_, false) -> false.

% dialyzer won't see this problem
bug(X, Y) ->
    case myand(X, Y) of
        true ->
            X + Y
    end.
