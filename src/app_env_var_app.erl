-module(app_env_var_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

-include_lib("eunit/include/eunit.hrl").

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    {ok, Var1} = application:get_env(var1),
    app_env_var_sup:start_link(Var1).

stop(_State) ->
    ok.

performance_test_() ->
    {
        setup,
        fun() ->
            application:start(app_env_var)
        end,
        fun(_) ->
            application:stop(app_env_var)
        end,
        fun(_) ->
            []
        end
    }.
