-module(caller).
-behavior(gen_server).

-include("gen-erl/tproxy_thrift.hrl").

-export([start_link/0, terminate/2, init/1]).
-export([handle_call/3]).
-export([handle_cast/2]).
-export([handle_info/2]).
-export([code_change/3]).

-export([call/1]).
-export([call/2]).

debug(Format, Data) ->
    error_logger:info_msg(Format, Data).

call(Function, Args) ->
	Packed = base64:encode(term_to_binary({Function, Args})),
	call(Packed).
	
call(Packed) ->
	gen_server:call(?MODULE, {call, Packed}).

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
	

init(_Args) ->
	process_flag(trap_exit, true),
	NewState = undefined,
	{ok, NewState}.

terminate(shutdown, _State) ->
	ok.

handle_call({call, Packed}, _From, State) ->
    debug("~p:~p handle_call({call, ~p}, ~p, ~p)",[?FILE,?LINE,Packed,_From, State]),
    {ok, Client0} = thrift_client_util:new("127.0.0.1", 10002, tproxy_thrift, []),
	%%Client0 = State,
	{Function, Args} = binary_to_term(base64:decode(Packed)),
	ArgsList = tuple_to_list(Args),
	debug("~p:~p handle_call do ~p, ~p~n", [?FILE,?LINE,Function, ArgsList]),
	{_Client1, Result} = thrift_client:call(Client0, Function, ArgsList),
	debug("~p:~p thrift call result is ~p~n", [?FILE,?LINE,Result]),
	EncodedResult = binary_to_list(base64:encode(term_to_binary(Result))),
	debug("~p:~p returning result is ~p~n", [?FILE,?LINE,EncodedResult]),
	%%NewState = Client1,
    thrift_client:close(Client0),
	{reply, EncodedResult, State}.

handle_cast(_Request, State) ->
	{noreply, State}.

handle_info(_Info, State) ->
	{noreply, State}.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

