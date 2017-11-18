-module(perms).
-export([checkDivisibility/1]).

permutations([]) -> [[]];
permutations(L) -> [[H|T] || H <- L, T <- permutations(L--[H])].

checkDivisibility(Arr) -> lists:map(
              fun(S) ->
                      Perms = permutations(S),
                      Nums = lists:map(fun(L) -> list_to_integer(L) end, Perms),
                      Divisibles = lists:filter(fun(N) -> N rem 8 == 0 end, Nums),
                      if Divisibles == [] -> "NO"; true -> "YES" end
              end,
              Arr).
