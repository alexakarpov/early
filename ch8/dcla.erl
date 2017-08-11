-module(dcla).
-compile(export_all).

start(Tag) ->
    spawn(fun() -> loop(Tag) end).

loop(Tag) ->
    sleep(),
    Val = dclb:x(),
    io:format("Vsn2 (~p) b:x() = ~p~n", [Tag, Val]),
    loop(Tag).

sleep() ->
    receive
    after 3000 -> true
    end.
