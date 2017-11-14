-module(perms).
-export([digits_perms/1]).

permutations([]) -> [[]];
permutations(L) -> [[H|T] || H <- L, T <- permutations(L--[H])].


back_to_number(L) ->
    list_to_integer(L).

digits_perms(Number) ->
    Digits = integer_to_list(Number),
    Perms = permutations(Digits),
    Numbers = lists:map(fun(L) ->
                                back_to_number(L) end,
                        Perms),
    Result = lists:filter(fun(N) ->
                                  N rem 8 == 0 end,
                          Numbers),
    Result.
