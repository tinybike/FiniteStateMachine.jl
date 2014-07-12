# Finite state machine library for Julia
# (based on Jake Gordon's javascript-state-machine)
# @license MIT
# @author jack@tinybike.net (Jack Peterson)

module JuliaStateMachine

export StateMachine, result, errors

type StateMachine
    initial::String
    states::Array{String,1}
    events::Array{String,1}
    callbacks::Array{String,1}
    StateMachine(states::Array{String,1}) = new(false, states, String[], String[])
    StateMachine(events::Array{String,1}) = new(false, String[], events, String[])
    StateMachine(states::Array{String,1}, events::Array{String,1}) = new(
        false, states, events, String[]
    )
end

const result = (ASCIIString => Int8)[
    "SUCCEEDED" => 1,
    "NOTRANSITION" => 2,
    "CANCELLED" => 3,
    "PENDING" => 4,
]
const errors = (ASCIIString => Int16)[
    "INVALID_TRANSITION" => 100,
    "PENDING_TRANSITION" => 200,
    "INVALID_CALLBACK" => 300,
]
const async = "async"

change_state(fsm::StateMachine, state::String, from::String, to::String) =
    callback(fsm, fsm["onchangestate"], state, from, to)

function enter_state(fsm::StateMachine, state::String, from::String, to::String)
    enter_this_state(fsm, state, from, to)
    enter_any_state(fsm, state, from, to)
end

enter_this_state(fsm::StateMachine, state::String, from::String, to::String) =
    callback(fsm, fsm["onenter"] + to, state, from, to)

function leave_state(fsm::StateMachine, state::String, from::String, to::String)
    specific = leave_this_state(fsm, state, from, to)
    general = leave_any_state(fsm, state, from, to)
    (~specific || ~general) ? false : async
end

leave_this_state(fsm::StateMachine, state::String, from::String, to::String) =
    callback(fsm, fsm["onleave"] + from, state, from, to)

function before_event(fsm::StateMachine, state::String, from::String, to::String)
    specific = before_this_event(fsm, state, from, to)
    general = before_any_event(fsm, state, from, to)
    (~specific || ~general) ? false : async
end

before_this_event(fsm::StateMachine, state::String, from::String, to::String) =
    callback(fsm, fsm["onbefore"] + state, state, from, to)

function after_event(fsm::StateMachine, state::String, from::String, to::String)
    after_this_event(fsm, state, from, to)
    after_any_event(fsm, state, from, to)
end

after_this_event(fsm::StateMachine, state::String, from::String, to::String) =
    callback(fsm, fsm["onafter"] + state, state, from, to)

function callback(fsm::StateMachine, func, state::String, from::String, to::String)
    if func
        try
            func(fsm, state, from, to)
        catch
            error("Invalid callback")
        end
    end
end

end