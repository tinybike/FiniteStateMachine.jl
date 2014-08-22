# Finite state machine library for Julia
# @license MIT
# @author jack@tinybike.net (Jack Peterson)

module FiniteStateMachine

export StateMachine, state_machine

type StateMachine
    events::Dict
    current::String
    function StateMachine(events::Dict)
        current = events["current"]
        new(events, current)
    end
end

const RESULT = (ASCIIString => Int8)[
    "SUCCEEDED" => 1,
    "NOTRANSITION" => 2,
    "CANCELLED" => 3,
    "PENDING" => 4,
]

include("state_machine.jl")

include("transitions.jl")

end # module
