-module(clock).
-export([start/2, stop/0, hi/0]).

start(Time, Fun) ->
    AFun = fun() -> tick(Time, Fun) end,
    Pid = spawn(AFun),
    register(clock, Pid ),
    Pid.

stop() -> clock ! stop.

tick(Time, Fun) ->
    receive
        stop ->
            void;
        die ->
            io:format ("I'm killed!~n"),
            exit(dead)
    after Time ->
            Fun(),
            %%io:format("tock~n"),
            tick(Time, Fun)
    end.

hi() ->
    io:format("ohai from ~p~n", [?MODULE]).
