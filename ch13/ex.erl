-module(ex).
-export([my_spawn/3,
         my_spawn/4,
         my_monitor/1,
         loop_5_print/0,
         monitor_listener/2,
         solution4/1
        ]).

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

%% ============================ MONITORS work ==========================

% simple "working" loop
loop_5_print() ->
    receive
    after 5000 ->
            io:format("I'm still alive~n"),
            loop_5_print()
    end.


solution4(Name) ->
    Pid = spawn(ex, loop_5_print, []),
    register(Name, Pid),
    my_monitor(Name).


% my monitor
monitor_listener(Pid, Name) ->
    monitor(process, Pid),
    io:format("monitoring ~p at ~p~n", [Name, Pid]),
    receive
        {'DOWN', _Ref, process, Pid, Why} ->
            io:format("~p (~p) died because ~p~n", [Pid, Name, Why]),
            NewPid = restart(Name),
            monitor_listener(NewPid, Name)
    end.

% recover action
restart(Name) ->
    io:format("Recovering ~p~n", [Name]),
    Pid = spawn(ex,loop_5_print, []),
    register(Name, Pid),
    Pid.

%function to bootstrapma monitor
my_monitor(Name) ->
    Pid = whereis(Name),
    spawn(ex, monitor_listener, [Pid, Name]).
