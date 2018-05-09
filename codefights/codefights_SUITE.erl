-module(codefights_SUITE).

-include_lib("common_test/include/ct.hrl").

-export([all/0]).

all() ->
    [testFoo,
     testBar].

testFoo(Config) ->
    {ok, N} = codefights:foo(1).

testBar(Config) ->
    {nope, X} = codefights:foo(2).

