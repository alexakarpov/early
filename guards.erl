-module(guards).
-export([gfun/1]).

gfun(It) when It+2>0, is_integer(It) ->
    2*It;
gfun(It) ->
    It.
