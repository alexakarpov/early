-module(play).
-compile(export_all).
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

should_recompile(Mod) ->
    case file:read_file_info(Mod++".erl") of
        {ok, Info} ->
            Mtime = Info#file_info.mtime,
            io:format("~p~n", [Mtime]),
            case file:read_file_info(Mod++".beam") of
                {error, enoent} ->
                    true;
                {ok, BeamInfo} ->
                    BeamInfo#file_info.mtime < Mtime
            end;
        {error, Why} ->
            {error, Why}
    end.

get_md5(File) ->
    {ok, S} = file:open(File, read),
    Context = erlang:md5_init(),
    FinalCtxt = get_md5_rec(S, Context),
    lists:flatten([io_lib:format("~2.16.0b", [B]) || <<B>> <= erlang:md5_final(FinalCtxt)]).

get_md5_rec(Dev, Ctxt) ->
    case file:read(Dev, 1000000) of
        {ok, Bin} ->
            NewCtxt = erlang:md5_update(Ctxt, Bin),
            get_md5_rec(Dev, NewCtxt);
        eof -> Ctxt
    end.

hex(X) ->
    element(X+1, {$0, $1, $2, $3, $4, $5, $6, $7, $8, $9, $a, $b, $c, $d, $e, $f}).
