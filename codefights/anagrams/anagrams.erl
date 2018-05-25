-module(anagrams).
-compile(export_all).


couldBeAnagram(S1, S2) when length(S1) =/= length(S2) ->
    false;
couldBeAnagram(S1, S2) ->
    {_,S2InS1} = lists:foldl(fun(C,{AS1,A}) ->
                                 case lists:member(C,AS1) of
                                     true -> {lists:delete(C,AS1),[true|A]};
                                     false -> {AS1, [false|A]}
                                 end
                         end,
                         {S1,[]},
                         S2),
    QMarks = lists:filter(fun(X) ->
                                  X == $?
                          end,
                          S1),
    Different = lists:filter(fun(X) ->
                                   X =/= true
                           end,
                           S2InS1),
    length(QMarks) == length(Different).
