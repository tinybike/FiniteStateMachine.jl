# Fire a state transition
function fire(fsm::StateMachine, name::AbstractString, args...)

    # Reserved event names: is, can, finished
    # is: check whether the current state is the same as the requested state
    #     returns true if they are the same, false otherwise
    if name == "is"
        event = args[1]
        fsm.current == event

    # can: ensure a specified event can be triggered from the current state
    #      returns true if it can be triggered, false otherwise
    elseif name == "can"
        event = args[1]
        haskey(fsm.map[event], fsm.current)

    # finished: check if the terminal state has been reached
    #           returns true if current = terminal state, false otherwise
    elseif name == "finished"
        fsm.current == fsm.terminal

    # User-defined events and callbacks
    elseif haskey(fsm.actions, name)
        fsm.actions[name]()

    # Throw an error if there weren't any matching names
    else
        error(name * " not found")
    end
end
