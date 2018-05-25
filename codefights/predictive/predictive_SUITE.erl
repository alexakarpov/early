-module(predictive_SUITE).
-compile(export_all).

all() ->
    [
     testAfter,
     testMostCommon,
     testMakeSuggestion,
     testBuildMap
    ].

testAfter(_Config) ->
    ["c", "c", "c"] = predictive:afterf(["a","b","c",
                                         "x","b","c",
                                         "z","b","c"], "b"),
    ["1","2","3"] = predictive:afterf(["a","1","c",
                                       "a","2","c",
                                       "a","3","c"],
                                      "a").

testMostCommon(_Config) ->
    "zxc" = predictive:most_common(#{"zxc" => 3,
                                   "qwe" => 2,
                                   "asd" => 1},
                                  ["qwe", "qwe", "asd", "zxc", "zxc"]).

testMakeSuggestion(_Config) ->
    AF = #{"a" => 5,
           "b" => 6,
           "c" => 5,
           "d" => 8,
           "x" => 7,
           "y" => 6,
           "z" => 9},
    TextList = ["a","b"],
    "z" = predictive:make_suggestion("a", {#{}, AF, TextList}),

    BF = #{"V" => #{"x" => 5,
                    "y" => 3,
                    "z" => 1}},
    "x" = predictive:make_suggestion("V", {BF, AF, []}),
    BF1 = #{"X" => #{"x" => 5,
                    "y" => 3,
                    "z" => 1}},
    "z" = predictive:make_suggestion("V", {BF1, AF,[]}).

testBuildMap(_Config) ->
    ML = maps:to_list(#{"a" => #{"b" => 4},
                        "b" => #{"c" => 4},
                        "c" => #{"a" => 3,
                                 "d" => 1},
                        "d" => #{"d" => 2}}),
    ML = maps:to_list(predictive:build_freq_map(["a","b","c","d"],
                                                ["a","b","c","a","b","c","a","b","c","a","b","c","d","d","d"])).
