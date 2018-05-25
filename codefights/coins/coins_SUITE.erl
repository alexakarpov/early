-module(coins_SUITE).
-compile(export_all).

all() ->
    [
     test_add_coin_to_map,
     test_add_coin_to_map2,     
     testPossibleSums,
     testPossibleSums2
    ].

test_add_coin_to_map(_Config) ->
    M0 = #{},
    M1 = coins:add_coin_to_map(1, M0),
    L1 = maps:to_list(M1),
    L1 = [{[1],1}],
    M2 = coins:add_coin_to_map(1, M1),
    L2 = maps:to_list(M2),
    L2 = [{[1],1},{[1,1],2}],
    M3 = coins:add_coin_to_map(5, M2),
    L3 = maps:to_list(M3),
    L3 = [{[1],1},{[1,1],2},{[5],5},{[5,1], 6}, {[5,1,1], 7}].

test_add_coin_to_map2(_Config) ->
    M0 = #{},
    M1 = coins:add_coin_to_map2(1, M0),
    L1 = maps:to_list(M1),
    L1 = [{[1],1}],
    M2 = coins:add_coin_to_map2(1, M1),
    L2 = maps:to_list(M2),
    L2 = [{[1],1},{[1,1],2}],
    M3 = coins:add_coin_to_map2(5, M2),
    L3 = maps:to_list(M3),
    L3 = [{[1],1},{[1,1],2},{[5],5},{[5,1], 6}, {[5,1,1], 7}].

testPossibleSums(_Config) ->
    7 = cf:possibleSums([1,3,5],[1,1,1]),
    9 = cf:possibleSums([10, 50, 100], [1, 2, 1]).

testPossibleSums2(_Config) ->
    7 = cf:possibleSums2([1,3,5],[1,1,1]),
    9 = cf:possibleSums2([10, 50, 100], [1, 2, 1]).
