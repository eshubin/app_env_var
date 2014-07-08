-module(gs2).

-behaviour(gen_server).

%% API
-export([start_link/0, use_env_variable/0]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    terminate/2]).

-define(SERVER, ?MODULE).

-include_lib("eunit/include/eunit.hrl").

-record(state, {}).

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

use_env_variable() ->
    gen_server:call(?SERVER, use).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init([]) ->
    {ok, #state{}}.

handle_call(use, _From, State) ->
    {ok, Var2} = application:get_env(app_env_var, var2),
    {reply, Var2, State}.

terminate(_Reason, _State) ->
    ok.

%%%===================================================================
%%% Internal functions
%%%===================================================================

basic_test_() ->
    {
        setup,
        fun() ->
            start_link(),
            application:set_env(app_env_var, var2, 3)
        end,
        fun(_) ->
            [
                ?_assertEqual(3, use_env_variable())
            ]
        end
    }.