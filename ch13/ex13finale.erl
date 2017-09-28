-module(ex13finale).
-export([solution/0, work/3, monitor_body/2]).

% fake worker process body
work(Name, Seconds, Reason) ->
    io:format("worker ~p starting~n", [Name]),
    timer:sleep(Seconds),
    exit(Reason).

% organize the fake workers run
orchestrate(Funs) ->
    Pids = [spawn(Fun) || Fun <- Funs],
    Pairs = lists:zip(Pids, Funs),
    lists:foreach(fun({Pid, Fun}) ->
                          make_watch(Pid, Fun)
                  end,
                  [{P, F} || {P, F} <- Pairs]).

% bootstrap the monitors
make_watch(Pid, Fun) ->
    spawn(ex13finale, monitor_body, [Pid, Fun]).

% monitoring process body
monitor_body(Pid, Fun) ->
    monitor(process, Pid),
    receive
        {'DOWN', _Ref, process, Pid, normal} ->
            io:format("~p exited normally~n", [Pid]);
        {'DOWN', _Ref, process, Pid, Why} ->
            io:format("~p exited abnormally: ~p~n", [Pid, Why]),
            timer:sleep(1000),
            NewPid = spawn(Fun),
            make_watch(NewPid, Fun)
    end.

% test the solution
solution() ->
    orchestrate([fun() -> work(bar, 2000, crashed) end,
                 fun() -> work(foo, 1000, normal) end]).
