-module(socket_server).
-behaviour(gen_server).

-export([
	start_link/1,
	start/0
	]).

-export([
	init/1,
	handle_cast/2,
	handle_call/3,
	handle_info/2,
	terminate/2
	]).

-define(CHILDSPEC(ListenSocket), {
		?MODULE, 
		{?MODULE, start_link, [ListenSocket]},
		temporary, 
		1000, 
		worker,
		[?MODULE]
	}).


-define(SUPERVISOR, socket_server_sup).
-record(state,{}).

start_link(Socket) ->
	emqtt_logger:info("start_link for socket_server"),
	gen_server:start_link({local, ?MODULE}, ?MODULE, [Socket], []).

init([ListenSocket]) ->
	emqtt_logger:info("Listen Socket for socket_server "),
	{ok, Socket} = gen_tcp:accept(ListenSocket),
	emqtt_logger:info(" Accepted connection "),
	spawn(
		fun() -> 
			Return = supervisor:start_child(?SUPERVISOR, ?CHILDSPEC(ListenSocket)),
			emqtt_logger:info(" Spawned socket listener ")
			end
	),
	{ok, #state{}}.

handle_info({tcp, Socket, <<"quit">>}, State) ->
	{stop, normal, State};

handle_info({tcp, Socket, Data}, State) ->
	emqtt_logger:info(lists:flatten(" socket_server Got data: ", Data)),
	{noreply, State};
	
handle_info(_, State) ->
	{noreply, State}.

handle_call(_, _From, State) ->
	emqtt_logger:info(" Handle call for socket_server "),
	{noreply, State}.

handle_cast(_, State) ->
	emqtt_logger:info("Handle cast for socket_server"),
	{noreply, State}.
	
terminate(_, State) ->
	emqtt_logger:info(" Terminating Socket Server "),
	ok.

code_change(_, State, _) ->
	emqtt_logger:info(" Code change for socket_server "),
	{ok, State}.

% callbacks for starting

start() ->
	emqtt_logger:info("Starting socket listeners"),
	socket_server_sup:start_link(),
	ok.