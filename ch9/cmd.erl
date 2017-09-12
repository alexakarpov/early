-module(cmd).
-export([main/1]).

fac(0) ->
    1;
fac(N) -> N * fac(N-1).

main([A]) ->
    I = list_to_integer(atom_to_list(A)),
    F = fac(I),
    io:format("factorial of ~w = ~w~n", [I, F]),
    init:stop().
