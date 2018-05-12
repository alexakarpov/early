-module(challenges).
-compile(export_all).


adaNumber(String) ->
    S = lists:filter(fun(C) ->
                         C =/= $_ end,
                 String),
    case re:run(S, "^\\d+$") of
        {match, _} -> true;
        nomatch -> adaBaseXNumber(S)
    end.
            
adaBaseXNumber(String) ->
    case re:run(String,"^(\\d+)#(.+)#$") of
        {match, [_, Base, Nums]} ->
            processNums(String, Nums, Base);
        nomatch -> false
    end.

processNums(String, {NFrom, NLen}, {BFrom, BLen}) ->
    SBase = lists:sublist(String, BFrom+1, BLen),
    Base = list_to_integer(SBase),
    if Base =< 16, Base >= 2 -> validate(lists:sublist(String, NFrom+1, NLen), Base);
       true  -> false
end.

validate(S, B) ->
    io:format("validating ~p/~p~n", [S,B]),
    Chars = [$0,$1,$2,$3,$4,$5,$6,$7,$8,$9,$a,$b,$c,$d,$e,$f],
    ValidChars = lists:sublist(Chars, 1, B),
    CapChars = [$0,$1,$2,$3,$4,$5,$6,$7,$8,$9,$A,$B,$C,$D,$E,$F],
    ValidCapChars = lists:sublist(CapChars, 1, B),
    io:format("geronimo! ~p/~p~n", [ValidChars, ValidCapChars]),    
    length(lists:filter(fun(C) ->
                         not(lists:member(C, ValidChars) or lists:member(C, ValidCapChars))
                 end,
                 S)) == 0.

%% You have a collection of coins, and you know the values of the coins and the quantity of each type of coin in it. You want to know how many distinct sums you can make from non-empty groupings of these coins.

%% Example

%% For coins = [10, 50, 100] and quantity = [1, 2, 1], the output should be
%% possibleSums(coins, quantity) = 9.

possibleSums(Coins, Quantity) ->
    Tuples = lists:zip(Coins, Quantity),
    lists:foldl(fun({C,Q},Acc) ->
                        lists:merge(Acc, lists:duplicate(C,Q))
                end,
                Tuples),
    Sums = [S || lists:foldl(fun(N, S) -> S + N end,
                             
