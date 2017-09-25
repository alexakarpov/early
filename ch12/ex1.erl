-module(ex1).
-export([loop/0, start/0]).

loop2(History) ->
    receive
        halt -> exit(normal);
        {Sender, history} ->
            Sender ! History,
            loop2([]);
        Message ->
            NewHistory = [Message | History],
            loop2(NewHistory)
    end.

start() ->
    Pid = spawn(ex1, loop, []),
    io:format("Spawned ~p~n",[Pid]),
    register(area, Pid).

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
