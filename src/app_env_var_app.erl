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


-define(NUMBER_OF_TEST_ROUNDS, 100000).

test_performance(TestRounds, Module) ->
    {Time, _} = timer:tc(
        fun() ->
            lists:foreach(
                fun(_) ->
                    Module:use_env_variable()
                end,
                lists:seq(1, TestRounds)
            )
        end
    ),
    ?debugFmt("~p : ~p", [Module, Time]).

performance_test_() ->
    {
        setup,
        fun() ->
            application:start(app_env_var),
            ?NUMBER_OF_TEST_ROUNDS
        end,
        fun(_) ->
            application:stop(app_env_var)
        end,
        fun(TestRounds) ->
            [
                fun() -> test_performance(TestRounds, gs1) end,
                fun() -> test_performance(TestRounds, gs2) end
            ]
        end
    }.
