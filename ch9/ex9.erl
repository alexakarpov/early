-module(ex9).
-export([fuzzbuzz/1]).

fuzzbuzz(X) ->
    Three = case X rem 3 of
                0 -> "fuzz";
                _ -> ""
            end,
    Five = case X rem 5 of
               0 -> "buzz";                   
               _ -> ""
           end.


                         
