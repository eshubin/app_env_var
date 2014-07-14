-module(gs1).

-behaviour(gen_server).

%% API
-export([start_link/1, use_env_variable/0, get_application/0,
        get_application_in_caller_proc/0]).

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

get_application() ->
    gen_server:call(?SERVER, get_app).

get_application_in_caller_proc() ->
    application:get_application().

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init(Var1) ->
    {ok, #state{var = Var1}}.

handle_call(use, _From, #state{var = Var1} = State) ->
    {reply, Var1, State};
handle_call(get_app, _From, State) ->
    {reply, application:get_application(), State}.

terminate(_Reason, _State) ->
    ok.

%%%===================================================================
%%% Internal functions
%%%===================================================================

%% test_get_application() ->
%%     ?assertEqual

basic_test_() ->
    {
        setup,
        fun() -> start_link(3) end,
        fun({ok, Pid}) ->
            unlink(Pid),
            exit(Pid, stop)
        end,
        fun(_) ->
            [
                ?_assertEqual(3, use_env_variable()),
                ?_assertEqual(undefined, gs1:get_application()),
                ?_assertEqual(undefined, gs1:get_application_in_caller_proc())
            ]
        end
    }.
