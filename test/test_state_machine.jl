using Compat

fsm = state_machine(@compat Dict{AbstractString, Any}(
    "initial" => "first",
    "final" => "fourth",
    "events" => @compat( [ Dict{AbstractString, Any}(
            "name" => "hop",
            "from" => "first",
            "to" => "second"
        ),  Dict{AbstractString, Any}(
            "name" => "skip",
            "from" => "second",
            "to" => "third"
        ),  Dict{AbstractString, Any}(
            "name" => "jump",
            "from" => "third",
            "to" => "fourth"
        )
    ]),
    "callbacks" => @compat Dict{AbstractString, Any}(
        "onbeforeevent" => (fsm::StateMachine, args...) -> 1,
        "onafterevent" => (fsm::StateMachine, args...) -> 1 + 1,
        "onbeforejump" => (fsm::StateMachine, args...) -> 1 + 2,
        "onafterskip" => (fsm::StateMachine, args...) -> 2 + 3,
        "onchangestate" => (fsm::StateMachine, args...) -> 3 + 5,
        "onenterstate" => (fsm::StateMachine, args...) -> 5 + 8,
        "onentersecond" => (fsm::StateMachine, args...) -> 8 + 13,
        "onleavestate" => (fsm::StateMachine, args...) -> 13 + 21,
        "onleavefirst" => (fsm::StateMachine, args...) -> 21 + 34
    )
))

@test fsm.current == "first"
@test fsm.terminal == "fourth"
@test fsm.map == @compat( Dict{AbstractString, Any}(
    "startup" => @compat( Dict("none" => "first")),
    "skip" => @compat( Dict("second" => "third")),
    "jump" => @compat( Dict("third" => "fourth")),
    "hop" => @compat( Dict("first" => "second"))
))

dfsm = state_machine(@compat Dict{AbstractString, Any}(
    "initial" => @compat( Dict{AbstractString, Any}(
        "state" => "first",
        "event" => "dance",
        "defer" => true,
    )),
    "terminal" => "fourth",
    "events" => @compat [Dict{AbstractString, Any}(
            "name" => "hop",
            "from" => "first",
            "to" => "second",
        ), Dict{AbstractString, Any}(
            "name" => "skip",
            "from" => "second",
            "to" => "third",
        ), Dict{AbstractString, Any}(
            "name" => "sleep",
            "from" => "third",
        ), Dict{AbstractString, Any}(
            "name" => "coupdegrace",
            "from" => "third",
            "to" => "fourth",
        )
    ]
))

@test dfsm.current == "none"
@test dfsm.terminal == "fourth"

mfsm = state_machine(@compat Dict{AbstractString, Any}(
    "initial" => @compat( Dict{AbstractString, Any}(
        "state" => "first",
        "defer" => false,
    )),
    "events" => @compat( [Dict{AbstractString, Any}(
            "name" => "hop",
            "from" => ["first", "third"],
            "to" => "second",
        ), Dict{AbstractString, Any}(
            "name" => "skip",
            "from" => "second",
            "to" => "third",
        ), Dict{AbstractString, Any}(
            "name" => "sleep",
            "from" => "third",
        )
    ]),
    "callbacks" => @compat( Dict{AbstractString, Any}(
        "onevent" => (fsm::StateMachine, args...) -> 1,
        "onstate" => (fsm::StateMachine, args...) -> -1,
    ))
))

@test mfsm.current == "first"
