-module(tcp2).
-compile([export_all]).
-define(Port, 2345).

loop(Socket) ->
    report("About to enter the [blocking] receive"),
    receive
        {tcp, Socket, Bin} ->
            report({msg, "Server received binary",
                    bin, Bin}),
            Str = binary_to_term(Bin),
            report({"unpacked ", Str}),
            Reply = lib_misc:string2value(Str),
            io:format("Server replying with ~p to ~p~n", [Reply, Socket]),
            gen_tcp:send(Socket, term_to_binary(Reply)),
            inet:setopts(Socket, [{active, once}]),
            io:format("Looping~n",[]),
            loop(Socket);
        {tcp_closed, Socket} ->
            io:format("server at ~p is about to exit...~n", [ self()])
    end.

report(Msg) ->
    io:format("~p reporting: ~p~n", [self(), Msg]).

par_connect(Listen) ->
    report("in par_connect, accepting (blocking)..."),
    {ok, Socket} = gen_tcp:accept(Listen),
    report("accepted a new connection"),
    Pid = spawn(fun() -> par_connect(Listen) end),
    io:format("newly spawed ~p before entering loop(..)~n", [Pid]),
    loop(Socket).

start_parallel_server() ->
    {ok, Listen} = gen_tcp:listen(?Port, [binary, {packet, 4},
                                          {reuseaddr, true},
                                          {active, once}]),
    io:format("Listen: ~p~n", [Listen]),
    Pid1 = spawn(fun() -> par_connect(Listen) end),
    io:format("shell (~p) spawned the first acceptor ~p~n", [self(), Pid1]).
