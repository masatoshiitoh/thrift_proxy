-module(gateway).

-include("gen-erl/tproxy_thrift.hrl").

-export([start_link/0]).
-export([stop/1]).
-export([handle_function/2]).
-export([getHelloWorld/1]).

debug(Format, Data) ->
	%%io:format(Format, Data),
	error_logger:info_msg(Format, Data).

start_link() ->
	start_link(9090).

start_link(Port) ->
	Handler = ?MODULE,
	thrift_socket_server:start(
		[{handler, Handler},
		{service, tproxy},
		{ip, "127.0.0.1"},
		{port, Port},
		{name, tproxy}]
	).

stop(Server) ->
	thrift_socket_server:stop(Server).

handle_function(Function, Args) when is_atom(Function), is_tuple(Args) ->
	debug("handle_function(~p, ~p)",[Function, Args]),
	case apply(?MODULE, Function, tuple_to_list(Args)) of
		ok -> ok;
		Reply -> {reply, Reply}
		end.

getHelloWorld(Name) ->
	io_lib:format("Hi, ~p Hello World!", [Name]).

