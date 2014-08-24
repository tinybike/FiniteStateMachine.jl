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
@test fsm.events["isfinished"]() == false
@test_throws ErrorException fsm.events["jump"]()
@test_throws ErrorException fsm.events["skip"]()
@test_throws ErrorException fsm.events["hop"]()

fsm.events["startup"]()
@test fsm.current == "first"
@test fsm.events["isfinished"]() == false
@test_throws ErrorException fsm.events["jump"]()
@test_throws ErrorException fsm.events["skip"]()
@test_throws ErrorException fsm.events["startup"]()

fsm.events["hop"]()
@test fsm.current == "second"
@test fsm.events["isfinished"]() == false
@test_throws ErrorException fsm.events["jump"]()
@test_throws ErrorException fsm.events["hop"]()
@test_throws ErrorException fsm.events["startup"]()

fsm.events["skip"]()
@test fsm.current == "third"
@test fsm.events["isfinished"]() == false
@test_throws ErrorException fsm.events["hop"]()
@test_throws ErrorException fsm.events["skip"]()
@test_throws ErrorException fsm.events["startup"]()

fsm.events["jump"]()
@test fsm.current == "fourth"
@test fsm.events["isfinished"]() == true
@test_throws ErrorException fsm.events["jump"]()
@test_throws ErrorException fsm.events["skip"]()
@test_throws ErrorException fsm.events["hop"]()
@test_throws ErrorException fsm.events["startup"]()
