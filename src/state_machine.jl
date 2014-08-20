function state_machine(cfg::Dict)
    fsm = Dict()
    _map = Dict()
    # Initial state
    if haskey(cfg, "initial")
        if typeof(cfg["initial"]) <: String
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
        ], _map)
    end
    for event in events
        add(event, _map)
    end
    for (name, target) in _map
        fsm[name] = build_event(fsm, name, target)
    end
    for (name, cb) in callbacks
        fsm[name] = cb
    end
    fsm["current"] = "none"
    fsm["is"] = state -> isa(state, Array) ? findfirst(state, fsm["current"] > 0) : (fsm["current"] == state)
    fsm["can"] = event -> !fsm["transition"] && (haskey(_map[event], fsm["current"]) || haskey(_map[event], "*"))
    fsm["cannot"] = event -> !fsm["can"](event)
    if haskey(cfg, "error")
        fsm["error"] = cfg["error"]
    else
        fsm["error"] = (name, from, to, args, error, msg, exc) -> error(exc)
    end
    fsm["isfinished"] = () -> fsm["is"](terminal)
    if initial != nothing
        if haskey(initial, "defer")
            if !initial["defer"]
                fsm[initial["event"]]()
            end
        end
    end
    StateMachine(initial, events, _map, callbacks)
end

function add(event::Dict, _map::Dict)
    if haskey(event, "from")
        if typeof(event["from"]) <: Array
            from = event["from"]
        else
            from = String[event["from"]]
        end
    else
        # Wildcard transition
        from = "*"
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

function build_event(fsm::Dict, name::String, _map::Dict)
    function ()
        from = fsm["current"]
        if haskey(_map, "from")
            to = _map["from"]
        elseif haskey(_map, "*")
            to = _map["*"]
        else
            to = from
        end
        if fsm["transition"]
            return error(name * " inappropriate because previous transition did not complete")
        end
        if fsm["cannot"](name)
            return error(name * " inappropriate in current state " * fsm["current"])
        end
        if before_event(fsm, name, from, to)
            return RESULT["CANCELLED"]
        end
        if from == to
            after_event(fsm, name, from, to)
            return RESULT["NOTRANSITION"]
        end
        fsm["transition"] = function ()
            if haskey(fsm, "transition")
                delete!(fsm, "transition")
            end
            fsm["current"] = to
            enter_state(fsm, name, from, to)
            change_state(fsm, name, from, to)
            after_event(fsm, name, from, to)
            RESULT["SUCCEEDED"]
        end
        # Cancel asynchronous transition on request
        fsm["cancel_transition"] = function ()
            if haskey(fsm, "transition")
                delete!(fsm, "transition")
            end
            after_event(fsm, name, from, to)
        end
        leave = leave_state(fsm, name, from, to)
        if leave == false
            if haskey(fsm, "transition")
                delete!(fsm, "transition")
            end
            RESULT["CANCELLED"]
        elseif leave == ASYNC
            RESULT["PENDING"]
        else
            if fsm["transition"]
                fsm["transition"]()
            end
        end
    end
end
