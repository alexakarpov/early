-module(coins).
%% -export([isCryptSolution/2, groupingDishes/1]).
-compile(export_all).

foo() ->
    42.

%% You have a collection of coins, and you know the values of the coins and the quantity of each type of coin in it. You want to know how many distinct sums you can make from non-empty groupings of these coins.

%% Example

%% For Coins = [10, 50, 100] and quantities = [1, 2, 1], the output should be
%% possibleSums(Coins, Quantities) = 9.

%% ######### SOLUTION #1, NOT effective (times out for large quantities
add_coin_to_map(Coin, M) ->
    Tuples = maps:to_list(M), % O(n)
    maps:merge(maps:put([Coin], Coin, M),
               lists:foldl(fun({KeyList, ValueSum}, Acc) -> % O(n)
                                   maps:put([Coin|KeyList],
                                            ValueSum + Coin,
                                            Acc)
                           end,
                           #{},
                           Tuples)).

possibleSums(Coins, Quantities) ->
    Ts = lists:zip(Coins, Quantities), %O(n)
    All = lists:foldl(fun({C,Q}, Acc) -> %O(n)
                              lists:merge(Acc, lists:duplicate(Q,C))
                      end, [], Ts),
    Answer = lists:foldl(fun(C, A) ->
                                 add_coin_to_map(C,A)
                         end,
                         #{},
                         All),
    io:format("~p~n", [Answer]),
    length(sets:to_list(
             sets:from_list(
               maps:values(Answer)))).

%% Solution #2
add_coin_to_map2(Coin, M) ->
    maps:merge(maps:put([Coin],Coin,M),
               maps:fold(fun(K,V,Acc) ->
                                 maps:put([Coin|K],
                                          V + Coin,
                                          Acc)
                         end,
                         M,
                         M)).

possibleSums2(Coins, Quantities) ->
    All = maps:from_list(lists:zip(Coins, Quantities)),
    io:format("All: ~p~n",[All]),
    {_,Acc} = maps:fold(fun(K,V,{AccIn,AccOut}) ->
                                {maps:update(K,V-1,AccIn),
                                 add_coin_to_map(K,AccOut)}
                        end,
                        {All,#{}},
                        All),
    io:format("~p~n", [Acc]),
    length(maps:values(Acc)).

perms([]) -> [[]];

perms(L)  -> [[H|T] || H <- L, T <- perms(L--[H])].

couldBeAnagram(S1, S2) when length(S1) =/= length(S2) ->
    false;
couldBeAnagram(S1, S2) ->
    S1InS2 = lists:foldl(fun(C,A) ->
                                 [lists:member(C,S2)|A]
                         end,
                         [],
                         S1),
    QMarks = lists:filter(fun(X) ->
                                  X == $?
                          end,
                         S1),
    io:format("QMarks:~p~n", [QMarks]),
    NotSame = lists:filter(fun(X) ->
                                   X =/= true
                           end,
                           S1InS2),
    io:format("NotSame:~p~n", [NotSame]),    
    length(QMarks) >= length(NotSame).
