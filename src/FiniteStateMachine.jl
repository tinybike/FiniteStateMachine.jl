# Finite state machine library for Julia
# @license MIT
# @author jack@tinybike.net (Jack Peterson)

module FiniteStateMachine

export StateMachine, state_machine

type StateMachine
    initial::Dict{String,String}
    states::Array{String,1}
    events::Array{Dict{String,String},1}
    callbacks::Array{String,1}
end

include("constants.jl")

include("state_machine.jl")

include("transitions.jl")

end # module
