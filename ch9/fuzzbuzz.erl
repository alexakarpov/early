-module(fuzzbuzz).
-export([fuzzbuzz/1, const_str/0]).


fuzzbuzz(X) ->
    Three = case X rem 3 of
                0 -> fuzz;
                _ -> ""
            end,
    Five = case X rem 5 of
               0 -> buzz;                   
               _ -> ""
           end,
    {Three, Five}.

const_str() ->
    "qwe".
