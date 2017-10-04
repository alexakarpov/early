-module(kvs).
-export([start/0, store/2, lookup/1, echo_worker/0]).

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

echo_worker() ->
    io:format("starting~n"),
    receive
        Msg ->
            io:format("received ~p~n", [Msg]),
            {echo, Msg}
    end.
