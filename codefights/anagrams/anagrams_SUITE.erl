-module(anagrams_SUITE).
-compile(export_all).

all() ->
    [
     test_anagrams
    ].

test_anagrams(_Config) ->
    true = anagrams:couldBeAnagram("",""),
    true = anagrams:couldBeAnagram("q","q"),
    true = anagrams:couldBeAnagram("qwe","qwe"),
    true = anagrams:couldBeAnagram("qwe","weq"),
    true = anagrams:couldBeAnagram("qwe?","qwea"),
    true = anagrams:couldBeAnagram("?qwe?","xqwex"),
    %false = anagrams:couldBeAnagram("?qwe?","aqweb"),
    false = anagrams:couldBeAnagram("qwe?","qwe"),
    false = anagrams:couldBeAnagram("qqwe","qwe"),
    false = anagrams:couldBeAnagram("qw","qwe").
