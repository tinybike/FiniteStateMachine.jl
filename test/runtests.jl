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
        "onfirst" => () -> println("boom!"),
    ],
}

fsm = state_machine(cfg)

@test fsm.initial["event"] == "startup"
@test fsm.initial["state"] == "first"
@test fsm.map["startup"] == {"none"=>"first"}
@test fsm.map["skip"] == {"second"=>"third"}
@test fsm.map["jump"] == {"third"=>"fourth"}
@test fsm.map["hop"] == {"first"=>"second"}
@test fsm.events[1] == ["name"=>"hop","to"=>"second","from"=>"first"] 
@test fsm.events[2] == ["name"=>"skip","to"=>"third","from"=>"second"]
@test fsm.events[3] == ["name"=>"jump","to"=>"fourth","from"=>"third"]
