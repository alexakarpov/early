-module(ex).
-export([my_spawn/3, foo/0]).

my_spawn(Mod, Func, Args) ->
    {_, _, StartTime} = erlang:timestamp(),
    {Pid, Ref} = spawn_monitor(Mod, Func, Args),
    receive
        {'DOWN', Ref, process, Pid, Why} ->
            {_,_,EndTime} = erlang:timestamp(),
            io:format("died because ~p after ~p~n", [Why, EndTime - StartTime])
    end.

foo() ->
    io:format("foo~n"),
    foo.
