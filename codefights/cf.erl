-module(cf).
%% -export([isCryptSolution/2, groupingDishes/1]).
-compile(export_all).

isCryptSolution([L1, L2, A], Solution) ->
    LolToLot = fun(Alol) ->
                       lists:map(fun([K,V]) ->
                                         {K,V}
                                 end,
                                 Alol)
               end,
    TransMap = maps:from_list(LolToLot(Solution)),
    TF = fun(C) ->
                 maps:get([C], TransMap,none)
         end,
    [FL1|TL1] = lists:map(TF, L1),
    [FL2|TL2] = lists:map(TF, L2),
    TA = lists:map(TF, A),
    io:format("1=~p|~p, 2=~p|~p, A=~p~n", [FL1,TL1,FL2,TL2,TA]),
    case {[FL1|TL1], [FL2|TL2]} of
        {[$0|[]], _} ->
            false;
        {_, [$0|[]]} ->
            false;
        {_, _} ->
            I1 = list_to_integer(lists:flatten([FL1|TL1])),
            I2 = list_to_integer(lists:flatten([FL2|TL2])),
            IA = list_to_integer(lists:flatten(TA)),
            IA == I1 + I2
    end.

mapFromRow([H|T] = Row) ->
    lists:foldl(fun(X, AccM) ->
                        maps:put(X, H, AccM)
                end,
                #{},
                T).

groupingDishes(Dishes) ->
    IToDs = lists:foldl(fun([D|Is], AccMap) ->
                                % list of tuples of the form {Ingredient, Dish} - dealing with a single dish
                                LoT = maps:to_list(mapFromRow([D|Is])),
                                lists:foldl(fun({I, D}, Acc2) ->
                                                    case maps:get(I, Acc2, none) of
                                                        none -> maps:put(I, [D], Acc2);
                                                        LoV -> maps:put(I, [D|LoV], Acc2)
                                                    end
                                            end,
                                            AccMap,
                                            LoT)
                        end,
                        #{},
                        Dishes),
    OList1 = lists:filter(fun({I, Ds}) ->
                                      length(Ds) >= 2
                              end,
                              maps:to_list(IToDs)),
    OList2 = lists:sort(lists:map(fun({I, Ds}) ->
                                          [I| lists:sort(Ds)]
                                  end,
                                  OList1)).

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

