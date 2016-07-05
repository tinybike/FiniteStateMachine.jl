# Create a finite state machine, using model supplied by the user.
function state_machine(model::Dict)

    fsm = StateMachine()

    # Write events and their associated states to the state machine's map
    function add(event::Dict)

        # Multiple source states are allowed
        if haskey(event, "from")
            if isa(event["from"], Array)
                from = event["from"]
            else
                from = [event["from"]]
            end
        end
        if !haskey(fsm.map, event["name"])
            fsm.map[event["name"]] = Dict()
        end

        # Use "to" if it has been specified; otherwise, this is a no-op
        # transition (before and after states are the same)
        for f in from
            if haskey(event, "to")
                fsm.map[event["name"]][f] = event["to"]
            else
                fsm.map[event["name"]][f] = f
            end
        end
    end

    # Set up initial state and startup event
    if haskey(model, "initial")

        # Initial state can be specified as a string or dict.
        # If the initial event has not been specified, default to "startup".
        if isa(model["initial"], AbstractString)
            initial = Dict{AbstractString, Any}(
                "state" => model["initial"],
                "event" => "startup",
            )
        else
            initial = model["initial"]
            if !haskey(initial, "event")
                initial["event"] = "startup"
            end
        end

        # Add the startup event to the map
        add(Dict{AbstractString, Any}(
            "name" => initial["event"],
            "from" => "none",
            "to" => initial["state"],
        ))
    end

    # Terminal (final) state
    if haskey(model, "terminal")
        fsm.terminal = model["terminal"]
    elseif haskey(model, "final")
        fsm.terminal = model["final"]
    end

    # Write user-specified events to the map
    if haskey(model, "events")
        for event in model["events"]
            add(event)
        end
    end

    # Set up the callable events (functions), which can be invoked by fire()
    for (name, minimap) in fsm.map
        fsm.actions[name] = () -> begin
            from = fsm.current
            to = haskey(minimap, from) ? minimap[from] : from
            if !fire(fsm, "can", name)
                error(name * " is not accessible from state " * fsm.current)
            elseif from == to
                after_event(fsm, name, from, to)
            else
                leave_state(fsm, name, from, to)
                fsm.current = to
                enter_state(fsm, name, from, to)
                change_state(fsm, name, from, to)
                after_event(fsm, name, from, to)
            end
        end
    end

    # Set up user-specified callbacks, if any were provided
    if haskey(model, "callbacks")
        for (name, callback) in model["callbacks"]
            fsm.actions[name] = callback
        end
    end

    # Fire (or defer firing of) the initial event
    if !haskey(initial, "defer") || !initial["defer"]
        fire(fsm, initial["event"])
    end

    fsm
end
