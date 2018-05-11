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
    OList2 = lists:map(fun({I, Ds}) ->
                               [I| lists:sort(Ds)]
                       end,
                       OList1).
