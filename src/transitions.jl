function callback(fsm::StateMachine, func::Function,
                  state::String, from::String, to::String)
    if isdefined(func)
        try
            func(fsm, state, from, to)
        catch
            error("Invalid callback")
        end
    end
end

# Before event
function before_event(fsm::StateMachine, state::String, from::String, to::String)
    specific = before_this_event(fsm, state, from, to)
    general = before_any_event(fsm, state, from, to)
    (~specific || ~general) ? false : ASYNC
end

before_this_event(fsm::StateMachine, state::String, from::String, to::String) =
    callback(fsm, fsm["onbefore"] + state, state, from, to)

before_any_event(fsm::StateMachine, state::String, from::String, to::String) =
    callback(fsm, fsm["onbeforeevent"], state, from, to)

# After event
function after_event(fsm::StateMachine, state::String, from::String, to::String)
    after_this_event(fsm, state, from, to)
    after_any_event(fsm, state, from, to)
end

after_this_event(fsm::StateMachine, state::String, from::String, to::String) =
    callback(fsm, fsm["onafter"] + state, state, from, to)

after_any_event(fsm::StateMachine, state::String, from::String, to::String) =
    callback(fsm, fsm["onafterevent"] || fsm["onevent"], state, from, to)

# Change of state
change_state(fsm::StateMachine, state::String, from::String, to::String) =
    callback(fsm, fsm["onchangestate"], state, from, to)

# Entering a state
function enter_state(fsm::StateMachine, state::String, from::String, to::String)
    enter_this_state(fsm, state, from, to)
    enter_any_state(fsm, state, from, to)
end

enter_this_state(fsm::StateMachine, state::String, from::String, to::String) =
    callback(fsm, fsm["onenter"] + to, state, from, to)

enter_any_state(fsm::StateMachine, state::String, from::String, to::String) =
    callback(fsm, fsm["onenterstate"] || fsm["onstate"], state, from, to)

# Leaving a state
function leave_state(fsm::StateMachine, state::String, from::String, to::String)
    specific = leave_this_state(fsm, state, from, to)
    general = leave_any_state(fsm, state, from, to)
    (~specific || ~general) ? false : ASYNC
end

leave_this_state(fsm::StateMachine, state::String, from::String, to::String) =
    callback(fsm, fsm["onleave"] + from, state, from, to)

leave_any_state(fsm::StateMachine, state::String, from::String, to::String) =
    callback(fsm, fsm["onleavestate"], state, from, to)
