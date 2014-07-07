-module(app_env_var_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    app_env_var_sup:start_link().

stop(_State) ->
    ok.
