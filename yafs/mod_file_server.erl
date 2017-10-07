-module(mod_file_server).
-export([start_up/3]).

start_up(MM, _ArgsC, ArgsS) ->
    loop(MM).

loop(MM) ->
    receive
        {chan, MM, {ls, Dir}} ->
            MM ! {send, file:list_dir(Dir)},
            loop(MM)
    end.
