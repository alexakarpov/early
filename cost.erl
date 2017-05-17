-module(cost).
-export([cost/1]).

cost(orange) -> 5;
cost(newspaper) ->8;
cost(apples) -> 2;
cost(pears) -> 9;
cost(milk) -> 7;
cost(_) -> 0. % if we don't carry it, it's free!!
