# Before event
function before_event(fsm::StateMachine, state::String, from::String, to::String)
    specific = before_this_event(fsm, state, from, to)
    general = before_any_event(fsm, state, from, to)
    (~specific || ~general) ? false : async
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
