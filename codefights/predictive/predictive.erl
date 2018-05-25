-module(predictive).
-compile(export_all).

build_freq_map(UniqueWords, TrainingText) ->
    lists:foldl(fun(Word, Acc) ->
                        maps:put(Word,
                                 count_words(afterf(TrainingText, Word)),
                                 Acc)
                end,
                #{},
                UniqueWords).

count_words(LW) ->
    lists:foldl(fun(W, Acc) ->
                        case maps:get(W, Acc, false) of
                            false -> maps:put(W, 1, Acc);
                            V -> maps:put(W, V+1, Acc)
                        end
               end,
               #{},
               LW).

afterf(List, X) ->
    afterf(List, X, []).
afterf([X, A | Tail], X, Acc) ->
    afterf([A | Tail], X, [A | Acc]);
afterf([_ | Tail], X, Acc) ->
    afterf(Tail, X, Acc);
afterf([], _, Acc) ->
    lists:reverse(Acc).

make_suggestion(W,{Us, As, T}) ->
    M = case maps:get(W, As, false) of
            false -> Us;
            V -> V
        end,
    io:format("looking for suggestion after ~p~n, in ~p~n based on ~p~n", [W, M, As]),
    Res = most_common(case maps:size(M) of
                          0 -> Us;
                          _ -> As
                      end,
                      T),
    io:format("suggesting ~p~n based on map ~p~n, word ~p~n",[Res,M,W]),
    Res.

predictiveText(TrainingText, FirstWord, HowManyWords) ->
    WordsList = lists:map(fun(X) ->
                                  binary_to_list(X)
                          end,
                          lists:filter(fun(B) ->
                                               size(B) =/= 0
                                       end,
                                       re:split(TrainingText, "[\s\,\.\?\'\"\!\;]"))),

    io:format("Training Text: ~p~n", [WordsList]),
    UniqueWordsFreqs = freq(WordsList),
    UniqueWords = maps:keys(UniqueWordsFreqs),
    AfterWordsFreq = build_freq_map(UniqueWords, WordsList),
    drive(HowManyWords-1,
          FirstWord,
          {UniqueWordsFreqs,
           AfterWordsFreq,
           WordsList},
          [FirstWord]).

drive(0, _, _, Acc) ->
    lists:reverse(Acc);
drive(N, FW, {UWFs, AWFs, T}=State, Acc) ->
    Suggestion = make_suggestion(FW, State),
    io:format("Acc:~p~n", [Acc]),
    drive(N-1, Suggestion, State, [Suggestion|Acc]).

freq(L) ->
    lists:foldl(fun(X, A) ->
                        case maps:get(X, A, false) of
                            false -> maps:put(X,1,A);
                            C -> maps:update(X, C+1, A)
                        end
                end,
                #{},
                L).

most_common(Freq,[H|T]) ->
    L = maps:to_list(Freq),
    [{S,_}|_T] = lists:sort(fun({_, V1}, {_, V2}) ->
                                    V1 > V2
                            end,
                       L),
    S.
