using FiniteStateMachine
using Base.Test

fsm = StateMachine(
    "initialstate",
    ["state1", "state2", "state3"],
    ["event1", "event2"],
    ["callback1", "callback2"]
)

@test fsm.initial == "initialstate"
@test fsm.states == ["state1", "state2", "state3"]
@test fsm.events == ["event1", "event2"]
@test fsm.callbacks == ["callback1", "callback2"]

cfg = {
    "initial" => "first",
    "final" => "fourth",
    "events" => Dict{String,String}[
        (String => String)[
            "name" => "hop",
            "from" => "first",
            "to" => "second",
        ],
        (String => String)[
            "name" => "skip",
            "from" => "second",
            "to" => "third",
        ],
        (String => String)[
            "name" => "jump",
            "from" => "third",
            "to" => "fourth",
        ],
    ],
}
