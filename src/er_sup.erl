-module(er_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-include_lib("n2o/include/wf.hrl").


%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    case cowboy:start_http(http, 3, [{port, wf:config(n2o,port,8000)}],
                                    [{env, [{dispatch, dispatch_rules()}]}]) of
        {ok, _} -> 
            ok;
        {error,{{_,{_,_,{X,_}}},_}} -> 
            io:format("Can't start Web Server: ~p\r\n",[X]), 
            halt(abort,[]);
        X -> 
            io:format("Unknown Error: ~p\r\n",[X]), halt(abort,[]) 
    end,

    {ok, {{one_for_one, 5, 10}, []}}.


mime() -> [{mimetypes,cow_mimetypes,all}].

dispatch_rules() ->
    cowboy_router:compile(
        [{'_', [
            {"/static/[...]", n2o_dynalo, {dir, "apps/review/priv/static", mime()}},
            {"/n2o/[...]", n2o_dynalo, {dir, "deps/n2o/priv", mime()}},
            {"/rest/:resource", rest_cowboy, []},
            {"/rest/:resource/:id", rest_cowboy, []},
            {"/ws/[...]", bullet_handler, [{handler, n2o_bullet}]},
            {'_', n2o_cowboy, []}
    ]}]).
