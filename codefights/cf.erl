-module(cf).
%% -export([isCryptSolution/2, groupingDishes/1]).
-compile(export_all).

foo() ->
    42.

%% Given an array strings, determine whether it follows the sequence given in the patterns array. In other words, there should be no i and j for which strings[i] = strings[j] and patterns[i] ≠ patterns[j] or for which strings[i] ≠ strings[j] and patterns[i] = patterns[j].

%% Example

%% For strings = ["cat", "dog", "dog"] and patterns = ["a", "b", "b"], the output should be
%% areFollowingPatterns(strings, patterns) = true;
%% For strings = ["cat", "dog", "doggy"] and patterns = ["a", "b", "b"], the output should be
%% areFollowingPatterns(strings, patterns) = false.

areFollowingPatterns(Strings, Patterns) ->
    case length(Strings) - length(Patterns) of
        0 -> are_following_patterns(lists:zip(Patterns, Strings));
        _ -> false
    end.

are_following_patterns(LOPP) ->
    AMap = maps:from_list(LOPP),
    try    
        lists:foldl(fun({K,V}, Acc) ->
                            case maps:get(K, Acc, none) of
                                none -> maps:put(K, V, Acc);
                                OV ->
                                    if V == OV ->
                                            Acc;
                                       true ->
                                            throw(bad_pattern)
                                    end
                            end
                    end,
                    #{},
                    LOPP),
        S = sets:from_list(maps:values(AMap)),
        length(maps:to_list(AMap)) == sets:size(S)
    catch
        throw:bad_pattern -> false
    end.

containsCloseNums(Nums, K) ->
    {_, AMap} = lists:foldl(fun(N, {Idx, Acc}) ->
                                    {Idx+1, maps:put(Idx, N, Acc)}
                            end,
                            {0, #{}},
                            Nums),
    L = maps:to_list(AMap),
    try
        lists:foldl(fun({Idx, Val}, Acc) ->
                            case maps:get(Val, Acc, none) of
                                none  -> maps:put(Val, Idx, Acc);
                                OldIdx ->
                                    if Idx - OldIdx =< K ->
                                            throw(gotcha);
                                       true  ->
                                            maps:put(Val, Idx, Acc)
                                    end
                            end
                    end,
                    #{},
                    L),
        false
    catch
        throw:gotcha -> true
    end.

perms([]) -> [[]];
perms(L)  -> [[H|T] || H <- L, T <- perms(L--[H])].

%% You have a collection of coins, and you know the values of the coins and the quantity of each type of coin in it. You want to know how many distinct sums you can make from non-empty groupings of these coins.

%% Example

%% For Coins = [10, 50, 100] and quantities = [1, 2, 1], the output should be
%% possibleSums(Coins, Quantities) = 9.

add_coin_to_map(Coin, M) ->
    Tuples = maps:to_list(M),
    maps:merge(maps:put([Coin], Coin, M),
               lists:foldl(fun({KeyList, ValueSum}, Acc) ->
                                   maps:put([Coin|KeyList],
                                            ValueSum + Coin,
                                            Acc)
                           end,
                           #{},
                           Tuples)).

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

possibleSums(Coins, Quantities) ->
    Ts = lists:zip(Coins, Quantities),
    All = lists:foldl(fun({C,Q}, Acc) ->
                              lists:merge(Acc, lists:duplicate(Q,C))
                      end, [], Ts),
    Answer = lists:foldl(fun(C, A) ->
                                 add_coin_to_map2(C,A)
                         end,
                         #{},
                         All),
    io:format("~p~n", [Answer]),
    length(sets:to_list(
             sets:from_list(
                 maps:values(Answer)))).
