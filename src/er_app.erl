-module(er_app).

-behaviour(application).

%% Application callbacks
-export([start/0, start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start() -> start(normal, []).

start(_StartType, _StartArgs) ->
    ok = application:start(crypto),
    ok = application:start(sasl),
    ok = application:start(ranch),
    ok = application:start(cowlib),
    ok = application:start(cowboy),
    application:set_env(n2o, route, routes),
    er_sup:start_link().

stop(_State) ->
    ok.
