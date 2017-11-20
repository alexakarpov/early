-module(play).
-export([unconsult/2, file_size_and_type/1, ls/1]).
-include_lib("kernel/include/file.hrl").

unconsult(File, L) ->
    {ok, S} = file:open(File, write),
    lists:foreach(fun(X) -> io:format(S, "~p.~n", [X]) end,
                  L),
    file:close(S).

file_size_and_type(File) ->
    case file:read_file_info(File) of
        {ok, Facts} ->
            {Facts#file_info.type, Facts#file_info.size};
        _  -> error
    end.

ls(Dir) ->
    {ok, L} = file:list_dir(Dir),
    lists:map(fun(I) ->
                       {I, file_size_and_type(I)} end, lists:sort(L)).
