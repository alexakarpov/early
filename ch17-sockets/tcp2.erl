-module(tcp2).
-compile([export_all]).
-define(Port, 2345).

loop(Socket) ->
    receive
        {tcp, Socket, Bin} ->
            io:format("Server received binary = ~p~n", [Bin]),
            Str = binary_to_term(Bin),
            io:format("Server (unpacked) ~p~n", [Str]),
            Reply = lib_misc:string2value(Str),
            io:format("Server replying = ~p~n", [Reply]),
            gen_tcp:send(Socket, term_to_binary(Reply)),
            loop(Socket);
        {tcp_closed, Socket} ->
            io:format("Server connection closed~n")
    end.

par_connect(Listen) ->
    io:format("~p is accepting connections~n", [self()]),
    {ok, Socket} = gen_tcp:accept(Listen),
    io:format("~p accepted a new connection~n",[self()]),
    io:format("Socket options: ~p~n", [inet:getopts(Socket, [socket_getopts])]),
    spawn(fun() ->
                  par_connect(Listen) end),
    loop(Socket).

start_parallel_server() ->
    {ok, Listen} = gen_tcp:listen(?Port, [binary, {packet, 4},
                                          {reuseaddr, true},
                                          {active, true}]),
    io:format("Listen: ~p~n", [Listen]),
    Pid1 = spawn(fun() -> par_connect(Listen) end),
    register(par_server, self()),
    io:format("Originally spawned acceptor ~p~n", [Pid1]).
