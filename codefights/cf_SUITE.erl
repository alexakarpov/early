-module(cf_SUITE).
-compile(export_all).

all() ->
    [testCrypt,
     testMapFromRow,
     testGroupingDishes,
     testFollowPattern,
     testCloseNums
    ].

testCrypt(_Config) ->
    true == cf:isCryptSolution(["AA", "AB", "BC"],
                                         [["A","1"],
                                          ["B","2"],
                                          ["C","3"]]),
    true == cf:isCryptSolution(["A", "BA", "BA"],
                                       [["A","0"],
                                        ["B","2"]]),
    false == cf:isCryptSolution(["AB", "AB", "AC"],
                                       [["A","0"],
                                        ["B","2"],
                                        ["C","4"]]),
    false == cf:isCryptSolution(["AA", "BB", "CC"],
                                       [["A","1"],
                                        ["B","2"],
                                        ["C","4"]]).

testMapFromRow(_Config) ->
    true = cf:mapFromRow([v, k1, k2, k3]) == #{k1 => v,
                                               k2 => v,
                                               k3 => v}.

testGroupingDishes(_Config) ->
    Dishes = [["Salad", "Tomato", "Cucumber", "Salad", "Sauce"],
              ["Pizza", "Tomato", "Sausage", "Sauce", "Dough"],
              ["Quesadilla", "Chicken", "Cheese", "Sauce"],
              ["Sandwich", "Salad", "Bread", "Tomato", "Cheese"]],
    Groups = [["Cheese", "Quesadilla", "Sandwich"],
     ["Salad", "Salad", "Sandwich"],
     ["Sauce", "Pizza", "Quesadilla", "Salad"],
     ["Tomato", "Pizza", "Salad", "Sandwich"]],
    true = cf:groupingDishes(Dishes) == Groups.

testFollowPattern(_Config) ->
    true = cf:areFollowingPatterns(["qwe","asd","zxc"], ["x","y","z"]),
    true = cf:areFollowingPatterns([], []),
    false = cf:areFollowingPatterns(["q","w","q"],["a","a","a"]),
    true = cf:areFollowingPatterns(["q","w","q"],["a","x","a"]),
    false = cf:areFollowingPatterns([], ["x","y","z"]),
    false = cf:areFollowingPatterns(["qwe","asd","zxc"], []).

testCloseNums(_Config) ->
    true = cf:containsCloseNums([0, 1, 2, 3, 5, 2], 3) == true,
    false = cf:containsCloseNums([0, 1, 2, 3, 5, 2], 2) == true.

twstCoins(_Config) ->
    true = cf:possibleSums([10, 50, 100], [1, 2, 1]) == 9.
