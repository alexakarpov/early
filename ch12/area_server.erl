-module(area_server).
-export([loop/1]).

loop() ->
    receive
        {rectangle, Width, Ht} ->
            io:format("Rectangle area is ~p~n", [Width*Ht]),
            loop();
        {square, Side} ->
            io:format("Square area is ~p~n", [Side*Side]),
            loop()
    end.
