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
    get_md5_hex_str(erlang:md5_final(FinalCtxt)).

get_md5_rec(Dev, Ctxt) ->
    case file:read(Dev, 1000000) of
        {ok, Bin} ->
            NewCtxt = erlang:md5_update(Ctxt, Bin),
            get_md5_rec(Dev, NewCtxt);
        eof -> Ctxt
    end.

get_md5_hex_str(Str) ->
    X = erlang:md5(Str),
    [begin if N < 10 -> 48 + N; true -> 87 + N end end || <<N:4>> <= X].

read_chunks(Dev, Bytes) ->
    case file:read(Dev, Bytes) of
        {ok, L} ->
            io:format("Read ~p~n", [L]),
            read_chunks(Dev, Bytes);
        eof -> done
    end.
