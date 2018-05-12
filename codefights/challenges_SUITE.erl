-module(challenges_SUITE).
-compile(export_all).

all() ->
    [testAda
    ].

testAda(_Config) ->
    true = challenges:adaNumber("237465") == true,
    true = challenges:adaNumber("_1234__2134_") == true,
    true = challenges:adaNumber("2#0101010#") == true,
    true = challenges:adaNumber("16#4657abcdefg#") == false,
    true = challenges:adaNumber("16#A_BC_DEF_#") == true,
    true = challenges:adaNumber("_") == false,
    true = challenges:adaNumber("") == false.

