function state_machine(cfg::Dict)
    function add(event::Dict)
        if haskey(event, "from")
            if isa(event["from"], Array)
                from = event["from"]
            else
                from = String[event["from"]]
            end
        end
        if !haskey(_map, event["name"])
            _map[event["name"]] = Dict()
        end
        for f in from
            if haskey(event, "to")
                _map[event["name"]][f] = event["to"]
            else
                # No-op transition
                _map[event["name"]][f] = f
            end
        end
    end
    fsm = StateMachine()
    _map = Dict()
    # Initial state
    if haskey(cfg, "initial")
        if isa(cfg["initial"], String)
            initial = (String => String)["state" => cfg["initial"]]
        else
            initial = cfg["initial"]
        end
    else
        initial = nothing
    end
    # Terminal state
    if haskey(cfg, "terminal")
        terminal = cfg["terminal"]
    elseif haskey(cfg, "final")
        terminal = cfg["final"]
    else
        terminal = nothing
    end
    # Event list
    if haskey(cfg, "events")
        events = cfg["events"]
    else
        events = Dict[]
    end
    # Callback list
    if haskey(cfg, "callbacks")
        callbacks = cfg["callbacks"]
    else
        callbacks = Dict{String,String}()
    end
    if initial != nothing
        if !haskey(initial, "event")
            initial["event"] = "startup"
        end
        add((String => String)[
            "name" => initial["event"],
            "from" => "none",
            "to" => initial["state"],
        ])
    end
    for event in events
        add(event)
    end
    for (name, minimap) in _map
        fsm.events[name] = build_event(fsm, name, minimap)
    end
    for (name, cb) in callbacks
        fsm.events[name] = cb
    end
    fsm.events["is"] = state -> isa(state, Array) ?
        findfirst(state, fsm.current > 0) : (fsm.current == state)
    fsm.events["can"] = event -> !haskey(fsm.events, "transition") && haskey(_map[event], fsm.current)
    fsm.events["cannot"] = event -> !fsm.events["can"](event)
    fsm.events["isfinished"] = () -> fsm.events["is"](terminal)
    if initial != nothing
        if haskey(initial, "defer")
            if !initial["defer"]
                fsm.events[initial["event"]]()
            end
        end
    end
    return fsm
end

function build_event(fsm::StateMachine, name::String, _map::Dict)
    function ()
        from = fsm.current
        if haskey(_map, from)
            to = _map[from]
        else
            to = from
        end
        if fsm.events["cannot"](name)
            return error(name * " inappropriate in current state " * fsm.current)
        end
        if from == to
            after_event(fsm, name, from, to)
            RESULT["NOTRANSITION"]
        else
            fsm.events["transition"] = function ()
                if haskey(fsm.events, "transition")
                    delete!(fsm.events, "transition")
                end
                fsm.current = to
                enter_state(fsm, name, from, to)
                change_state(fsm, name, from, to)
                after_event(fsm, name, from, to)
                RESULT["SUCCEEDED"]
            end
            leave = leave_state(fsm, name, from, to)
            if leave == false
                if haskey(fsm.events, "transition")
                    delete!(fsm.events, "transition")
                end
                RESULT["CANCELLED"]
            else
                if haskey(fsm.events, "transition")
                    fsm.events["transition"]()
                end
            end
        end
    end
end
