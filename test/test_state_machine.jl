fsm = @compat state_machine(Dict(
    "initial" => "first",
    "final" => "fourth",
    "events" => [Dict(
            "name" => "hop",
            "from" => "first",
            "to" => "second",
        ), Dict(
            "name" => "skip",
            "from" => "second",
            "to" => "third",
        ), Dict(
            "name" => "jump",
            "from" => "third",
            "to" => "fourth",
        ),
    ],
    "callbacks" => Dict(
        "onbeforeevent" => (fsm::StateMachine, args...) -> 1,
        "onafterevent" => (fsm::StateMachine, args...) -> 1 + 1,
        "onbeforejump" => (fsm::StateMachine, args...) -> 1 + 2,
        "onafterskip" => (fsm::StateMachine, args...) -> 2 + 3,
        "onchangestate" => (fsm::StateMachine, args...) -> 3 + 5,
        "onenterstate" => (fsm::StateMachine, args...) -> 5 + 8,
        "onentersecond" => (fsm::StateMachine, args...) -> 8 + 13,
        "onleavestate" => (fsm::StateMachine, args...) -> 13 + 21,
        "onleavefirst" => (fsm::StateMachine, args...) -> 21 + 34,
    ),
))

@test fsm.current == "first"
@test fsm.terminal == "fourth"
@test fsm.map == @compat Dict(
    "startup" => Dict("none" => "first"),
    "skip" => Dict("second" => "third"),
    "jump" => Dict("third" => "fourth"),
    "hop" => Dict("first" => "second"),
)

dfsm = @compat state_machine(Dict(
    "initial" => Dict(
        "state" => "first",
        "event" => "dance",
        "defer" => true,
    ),
    "terminal" => "fourth",
    "events" => [Dict(
            "name" => "hop",
            "from" => "first",
            "to" => "second",
        ), Dict(
            "name" => "skip",
            "from" => "second",
            "to" => "third",
        ), Dict(
            "name" => "sleep",
            "from" => "third",
        ), Dict(
            "name" => "coupdegrace",
            "from" => "third",
            "to" => "fourth",
        )
    ],
))

@test dfsm.current == "none"
@test dfsm.terminal == "fourth"

mfsm = @compat state_machine(Dict(
    "initial" => Dict(
        "state" => "first",
        "defer" => false,
    ),
    "events" => [Dict(
            "name" => "hop",
            "from" => ["first", "third"],
            "to" => "second",
        ), Dict(
            "name" => "skip",
            "from" => "second",
            "to" => "third",
        ), Dict(
            "name" => "sleep",
            "from" => "third",
        ),
    ],
    "callbacks" => Dict(
        "onevent" => (fsm::StateMachine, args...) -> 1,
        "onstate" => (fsm::StateMachine, args...) -> -1,
    ),
))

@test mfsm.current == "first"
