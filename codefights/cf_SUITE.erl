-module(cf_SUITE).
-compile(export_all).

all() ->
    [testCrypt1,
     testCrypt2,
     testCrypt3,
     testCrypt4,
     testMapFromRow].

testCrypt1(_Config) ->
    true == cf:isCryptSolution(["AA", "AB", "BC"],
                                         [["A","1"],
                                          ["B","2"],
                                          ["C","3"]]).

testCrypt2(_Config) ->
    true == cf:isCryptSolution(["A", "BA", "BA"],
                                       [["A","0"],
                                        ["B","2"]]).
testCrypt3(_Config) ->
    false == cf:isCryptSolution(["AB", "AB", "AC"],
                                       [["A","0"],
                                        ["B","2"],
                                        ["C","4"]]).
testCrypt4(_Config) ->
    false == cf:isCryptSolution(["AA", "BB", "CC"],
                                       [["A","1"],
                                        ["B","2"],
                                        ["C","4"]]).

testMapFromRow(_Config) ->
    cf:mapFromRow([v, k1, k2, k3]) == #{k => v,
                                                k2 => v,
                                                k3 => v}.

%% testGroupingDishes(_Config) ->
%%     Dishes = [["Salad", "Tomato", "Cucumber", "Salad", "Sauce"],
%%               ["Pizza", "Tomato", "Sausage", "Sauce", "Dough"],
%%               ["Quesadilla", "Chicken", "Cheese", "Sauce"],
%%               ["Sandwich", "Salad", "Bread", "Tomato", "Cheese"]],
%%     Groups = [["Cheese", "Quesadilla", "Sandwich"],
%%      ["Salad", "Salad", "Sandwich"],
%%      ["Sauce", "Pizza", "Quesadilla", "Salad"],
%%      ["Tomato", "Pizza", "Salad", "Sandwich"]],
%%     cf:groupingDishes(Dishes) == Groups.

