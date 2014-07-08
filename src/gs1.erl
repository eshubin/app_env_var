-module(gs1).

-behaviour(gen_server).

%% API
-export([start_link/1, use_env_variable/0]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    terminate/2]).

-define(SERVER, ?MODULE).

-include_lib("eunit/include/eunit.hrl").

-record(state, {var}).

%%%===================================================================
%%% API
%%%===================================================================

start_link(Var1) ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, Var1, []).

use_env_variable() ->
    gen_server:call(?SERVER, use).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init(Var1) ->
    {ok, #state{var = Var1}}.

handle_call(use, _From, #state{var = Var1} = State) ->
    {reply, Var1, State}.

terminate(_Reason, _State) ->
    ok.

%%%===================================================================
%%% Internal functions
%%%===================================================================


basic_test_() ->
    {
        setup,
        fun() -> start_link(3) end,
        fun(_) ->
            [
                ?_assertEqual(3, use_env_variable())
            ]
        end
    }.