-module(area_server).
-export([loop/0, rpc/2]).

loop() ->
    receive
        {From, {rectangle, Width, Ht}} ->
            From ! Width*Ht,
            loop();
        {From, {square, Side}} ->
            From ! Side*Side,
            loop();
        {From, Other} ->
            From ! {error, Other},
            loop()
    end.

rpc(Pid, Request) ->
    Pid ! {self(), Request},
    receive
        Response ->
            Response
    end.
