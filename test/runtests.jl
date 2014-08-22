using FiniteStateMachine
using Base.Test

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
    "callbacks" => (String => Function)[
        "onbeforeevent" => () -> println("boom!"),
    ],
}

fsm = state_machine(cfg)

@test fsm.current == "none"

fsm.events["startup"]()
@test fsm.events["current"] == "first"

fsm.events["hop"]()
@test fsm.events["current"] == "second"

fsm.events["skip"]()
@test fsm.events["current"] == "third"

fsm.events["jump"]()
@test fsm.events["current"] == "fourth"
