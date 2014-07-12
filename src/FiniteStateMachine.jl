# Finite state machine library for Julia
# @license MIT
# @author jack@tinybike.net (Jack Peterson)

module FiniteStateMachine

export StateMachine, result, errors, callback, change_state, enter_state,
       enter_this_state, leave_state, leave_this_state, before_event,
       before_this_event, after_event, after_this_event

type StateMachine
    initial::String
    states::Array{String,1}
    events::Array{String,1}
    callbacks::Array{String,1}
end

include("constants.jl")

include("states.jl")

include("events.jl")

include("callback.jl")

end # module
