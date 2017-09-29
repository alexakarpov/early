-module(ex13).
-export([solution/0, worker/3, worker/1, mon_bootstrap/1]).

% fake worker process body
worker(Name, Seconds, Reason) ->
    io:format("worker ~p started at ~p~n", [Name, self()]),
    timer:sleep(Seconds),
    io:format("~p exiting with ~p~n", [self(), Reason]),
    exit(Reason).

worker(Name) ->
    io:format("~p is alive at ~p~n",[Name, self()]),
    timer:sleep(1000),
    worker(Name).
    

orchestrate(Funs) ->
    Pids = [spawn(Fun) || Fun <- Funs],
    MonitorPid = spawn(ex13, mon_bootstrap, [Pids]),
    io:format("Monitor started at ~p~n", [MonitorPid]).
    
% bootstrap the multi-process monitor
mon_bootstrap(Pids) ->
    Refs = lists:map(fun(Pid) ->
                             monitor(process, Pid)
                     end,
                     Pids),
    mon_listen(Pids, Refs).

mon_listen(Pids, Refs) ->
    receive
        {'DOWN', _Ref, process, PidA, normal} ->
            io:format("detected normal exit of ~p~n", [PidA]),
            mon_listen(Pids, Refs);
        {'DOWN', Ref, process, PidB, Why} ->
            io:format("~p exited with ~p, giving all up~n",[PidB, Why]),
            lists:foreach(fun(Pid) ->
                                  io:format("stopping ~p for cleanup~n", [Pid]),
                                  exit(Pid, cleanup)
                          end,
                          Pids),
            lists:foreach(fun(ARef) ->
                                  demonitor(ARef)
                          end,
                          Refs),
            mon_listen([],[])
    end.


% test the solution
solution() ->
    orchestrate([fun() -> worker(bar, 3000, busted) end,
                 fun() -> worker(foo, 2000, normal) end,
                 fun() -> worker(lasting) end]).
