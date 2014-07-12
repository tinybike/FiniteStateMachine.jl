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
    (~specific || ~general) ? false : async
end
leave_this_state(fsm::StateMachine, state::String, from::String, to::String) =
    callback(fsm, fsm["onleave"] + from, state, from, to)
leave_any_state(fsm::StateMachine, state::String, from::String, to::String) =
    callback(fsm, fsm["onleavestate"], state, from, to)
