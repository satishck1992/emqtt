%%%-------------------------------------------------------------------
%% @doc emqtt public API
%% @end
%%%-------------------------------------------------------------------

-module(emqtt_logger).

%% Application callbacks
-export([start/2, stop/1]).

%% API's
-export([info/1, debug/1]).
-compile([{parse_transform, lager_transform}]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
	lager:start(),
	ok.

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================

info(Message) ->
	lager:log(info, "file", Message).

debug(Message) ->
	lager:log(debug, self(), Message).