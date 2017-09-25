-module(links).
-export([linkme/1, start/0, loop/1]).

linkme(Pid) ->
    link(Pid).

start() ->
    spawn(links, loop, [[start]]).

loop(History) ->
    receive
        halt -> exit(normal);
        {command, {Sender, history}} ->
            Sender ! History,
            loop([]);
        {msg, Message} ->
            NewHistory = [Message | History],
            loop(NewHistory)
        end.
