-module(tcp1).
-compile([export_all]).
-define(Port, 2345).

nano_get_url() ->
    nano_get_url("yyz.alexakarpov.xyz").

nano_get_url(Host) ->
    {ok, Socket} = gen_tcp:connect(Host, 80, [binary, {packet, 0}]),
    ok = gen_tcp:send(Socket, "GET / HTTP/1.0\r\n\r\n"),
    receive_data(Socket, []).

receive_data(Socket, SoFar) ->
    receive
        {tcp, Socket, Bin} ->
            io:format("Got some data...~n"),
            receive_data(Socket, [Bin|SoFar]);
        {tcp_closed, Socket} ->
            list_to_binary(lists:reverse(SoFar))
    end.

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

nano_client_eval(Str) ->
    case gen_tcp:connect("localhost", ?Port,
                                   [binary, {packet, 4}]) of
        {ok, Socket} ->
            ok = gen_tcp:send(Socket, term_to_binary(Str)),
            receive
                {tcp, Socket, Bin} ->
                    io:format("Client received binary = ~p~n", [Bin]),
                    Val = binary_to_term(Bin),
                    io:format("Client result = ~p~n", [Val]),
                    gen_tcp:close(Socket)
            end;
        {error, Why} -> io:format("Failed to connect to the server: ~p~n",
                                  [Why])
    end.

start_seq_server() ->
    register(seq_server, self()),
    {ok, Listen} = gen_tcp:listen(?Port, [binary, {packet, 4},
					 {reuseaddr, true},
					 {active, true}]),
    seq_loop(Listen).

start_parallel_server() ->
    {ok, Listen} = gen_tcp:listen(?Port, [binary, {packet, 4},
                                          {reuseaddr, true},
                                          {active, true}]),
    io:format("Listening on Port ~p~n", [Listen]),
    register(par_server, self()),
    spawn(fun() -> par_connect(Listen) end).

par_connect(Listen) ->
    {ok, Socket} = gen_tcp:accept(Listen),
    spawn(fun() ->
                  par_connect(Listen) end),
    loop(Socket).

seq_loop(Listen) ->
    {ok, Socket} = gen_tcp:accept(Listen),
    loop(Socket),
    seq_loop(Listen).
