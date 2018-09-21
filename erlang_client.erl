-module(erlang_client).
-export([
    start/0
]).

start() ->
    io:format("START!\n", []),
    proc_lib:spawn_link(fun() -> init() end).

init() ->
    process_flag(trap_exit, true),
    {ok, Hostname} = inet:gethostname(),
    JavaServerNode = list_to_atom("server@"++Hostname),
    case net_kernel:connect(JavaServerNode) of
        true ->
            {ok, _TRef} =
                timer:send_interval(1000, self(), req),
            loop(JavaServerNode);
        false ->
            io:format("Start the java-erlang-server first\n", []),
            erlang:halt(1)
    end.

loop(JavaServerNode) ->
    receive
        req ->
            io:format("send request\n", []),
            {counterserver, JavaServerNode} ! {self(), "count"},
            loop(JavaServerNode);
        {ok, Num} ->
            io:format("Received ~p from server\n", [Num]),
            loop(JavaServerNode);
        X ->
            io:format("received ~p\n", [X]),
            loop(JavaServerNode)
    end.