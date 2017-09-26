-module(links).
-export([start_many/1, loop_w/1, loop_m/1, on_exit/2]).

loop_w(Name) ->
    io:format("~p started on ~p~n", [Name, self()]),
    receive
        halt ->
            io:format("~p asked to stop.~n", [Name]),
            exit(normal);
        ping ->
            io:format("pong~n"),
            loop_w(Name);
        {link, Pid} when is_pid(Pid) ->
            link(Pid),
            io:format("linked ~p to ~p~n", [self(), Pid]),
            loop_w(Name)
        end.

loop_m(Name) ->
    receive
        {'DOWN', _Ref, process, Pid, Why} ->
            io:format("Process ~p is down with reason ~p~n",[Pid, Why]),
            loop_m(Name)
    end.

on_exit(Pid, Fun) ->
    spawn(fun() ->
                  Ref = monitor(process, Pid),
                  receive
                      {'DOWN', Ref, process, Pid, Why} ->
                          Fun(Why)
                  end
          end).

start_many(Fs) ->
    spawn(fun() ->
                  [spawn_link(F) || F <- Fs],
                  receive
                      after
                          infinity ->
                              true
                      end
          end).
