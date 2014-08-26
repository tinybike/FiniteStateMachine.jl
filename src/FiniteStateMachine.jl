# Finite state machine library for Julia
# @license MIT
# @author jack@tinybike.net (Jack Peterson)

module FiniteStateMachine

export StateMachine, state_machine, fire, callback, before_event, before_this_event, before_any_event, after_event, after_this_event, after_any_event, change_state, enter_state, enter_this_state, enter_any_state, leave_state, leave_this_state, leave_any_state

type StateMachine
    current::String
    terminal::Union(String, Nothing)
    map::Dict{String,Dict{String,String}}
    StateMachine() = new("none", nothing, (String => Dict{String,String})[])
end

# All events and callbacks are stored here
actions = (String => Function)[]

include("state_machine.jl")

include("fire.jl")

include("transitions.jl")

end # module
