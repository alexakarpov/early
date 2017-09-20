-module(area_server).
-export([loop/0, start/0, area/2]).

start() ->
    spawn(area_server, loop, []).

area(Pid, What) ->
    rpc(Pid, What).

loop() ->
    receive
        {From, {rectangle, Width, Ht}} ->
            io:format("Computing for rectangle...~n"),
            From ! {self(), Width*Ht},
            loop();
        {From, {square, Side}} ->
            io:format("Computing for square...~n"),
            From ! {self(), Side*Side},
            loop();
        {From, Other} ->
            io:format("lolwut?~n"),
            From ! {self(), {error, Other}},
            loop()
    end.

rpc(Pid, Request) ->
    Pid ! {self(), Request},
    receive
        {Pid, Response} ->
            Response
    end.
