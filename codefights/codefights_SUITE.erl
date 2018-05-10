-module(codefights_SUITE).
-compile(export_all).

all() ->
    [testCrypt1,
     testCrypt2,
     testCrypt3,
     testCrypt4].

testCrypt1(_Config) ->
    true == codefights:isCryptSolution(["AA", "AB", "BC"],
                                         [["A","1"],
                                          ["B","2"],
                                          ["C","3"]]).

testCrypt2(_Config) ->
    true == codefights:isCryptSolution(["A", "BA", "BA"],
                                       [["A","0"],
                                        ["B","2"]]).
testCrypt3(_Config) ->
    false == codefights:isCryptSolution(["AB", "AB", "AC"],
                                       [["A","0"],
                                        ["B","2"],
                                        ["C","4"]]).
testCrypt4(_Config) ->
    false == codefights:isCryptSolution(["AA", "BB", "CC"],
                                       [["A","1"],
                                        ["B","2"],
                                        ["C","4"]]).
