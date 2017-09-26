-module(ex).
-export([my_spawn/3, my_spawn/4, foo/0]).

my_spawn(Mod, Func, Args) ->
    {_, _, StartTime} = erlang:timestamp(),
    {Pid, Ref} = spawn_monitor(Mod, Func, Args),
    receive
        {'DOWN', Ref, process, Pid, Why} ->
            {_,_,EndTime} = erlang:timestamp(),
            io:format("died because ~p after ~p~n", [Why, EndTime - StartTime])
    end.

my_spawn(Mod, Func, Args, Time) ->
    {Pid, Ref} = spawn_monitor(Mod, Func, Args),
    receive
        {'DOWN', Ref, process, Pid, Why} ->
            io:format("died because ~p~n", [Why])
    after
        Time ->
            io:format("I'm done~n"),
            exit(Pid, timesup)
    end.

foo() ->
    io:format("foo~n"),
    receive
        _ ->
             void
    after
        infinity ->
            void
    end.

