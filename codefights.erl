-module(codefights).
-export([isCryptSolution/2]).

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

[["Salad", "Tomato", "Cucumber", "Salad", "Sauce"],
 ["Pizza", "Tomato", "Sausage", "Sauce", "Dough"],
 ["Quesadilla", "Chicken", "Cheese", "Sauce"],
 ["Sandwich", "Salad", "Bread", "Tomato", "Cheese"]]
