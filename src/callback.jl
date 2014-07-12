function callback(fsm::StateMachine, func, state::String, from::String, to::String)
    if func
        try
            func(fsm, state, from, to)
        catch
            error("Invalid callback")
        end
    end
end
