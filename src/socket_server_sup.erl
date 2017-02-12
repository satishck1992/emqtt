-module(socket_server_sup).
-behaviour(supervisor).
-export([init/1,
	start_link/0]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init(_) ->
	io:format(" Initing ", []),
	{ok, ListenSocket} = gen_tcp:listen(18999, [binary, {backlog, 100}]),
	SupFlags = {one_for_one, 5, 1},
	ChildSpec = {
		socket_server, 
		{socket_server, start_link, [ListenSocket]},
		temporary, 
		brutal_kill, 
		worker,
		[socket_server]
	},
	{ok,{SupFlags, [ChildSpec]}}.

shutdown() ->
     exit(whereis(?MODULE), shutdown).