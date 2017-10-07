-module(kvs).
-export([start/0, store/2, lookup/1, echo_loop/0]).

start() ->
    register(kvs, spawn(fun() -> loop() end)).

store(Key, Value) ->
    rpc({store, Key, Value}).

lookup(Key) ->
    rpc({lookup, Key}).

rpc(Q) ->
    kvs ! {self(), Q},
    receive
        {kvs, Reply} ->
            Reply
    end.

loop() ->
    receive
        {From, {store, Key, Value}} ->
            put(Key, {ok, Value}),
            From ! {kvs, true},
            loop();
        {From, {lookup, Key}} ->
            From ! {kvs, get(Key)},
            loop()
    end.

echo_loop() ->
    io:format("starting~n"),
    receive
        {Pid, Msg} when is_pid(Pid)  ->
            io:format("received ~p from ~p ~n", [Msg, Pid]),
            Pid ! {echo, self(), Msg},
            echo_loop()
    end.
