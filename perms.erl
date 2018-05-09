-module(perms).
-export([sums/1, count_sets/1, limited_powerset/2]).



limited_powerset(L, N) ->
    {_, Acc} = generate(L, N),
    Acc.

generate([], _) ->
    {[[]], []};
generate([H|T], N) ->        
    {PT, Acc} = generate(T, N),
    generate(H, PT, PT, Acc, N).

generate(_, [], PT, Acc, _) ->
    %io:format("g5 base returns PT:~p,~n Acc:~p}~n",[PT, Acc]),
    {PT, Acc};
generate(X, [H|T], PT, Acc, N) when length(H)=/=N-1 ->
    generate(X, T, [[X|H]|PT], Acc, N);
generate(X, [H|T], PT, Acc, N) ->    
    generate(X, T, [[X|H]|PT], [[X|H]|Acc], N).

sums([]) -> 0;
sums([H|T]) ->
    H + sums(T).

count_sets(L) ->
    S = limited_powerset(L, 237),
    length(S).

    
