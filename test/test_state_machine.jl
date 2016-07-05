fsm = state_machine(Dict{AbstractString, Any}(
    "initial" => "first",
    "final" => "fourth",
    "events" => [Dict{AbstractString, Any}(
            "name" => "hop",
            "from" => "first",
            "to" => "second",
        ), Dict{AbstractString, Any}(
            "name" => "skip",
            "from" => "second",
            "to" => "third",
        ), Dict{AbstractString, Any}(
            "name" => "jump",
            "from" => "third",
            "to" => "fourth",
        ),
    ],
    "callbacks" => Dict{AbstractString, Any}(
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
@test fsm.map == Dict{AbstractString, Any}(
    "startup" => Dict("none" => "first"),
    "skip" => Dict("second" => "third"),
    "jump" => Dict("third" => "fourth"),
    "hop" => Dict("first" => "second"),
)

dfsm = state_machine(Dict{AbstractString, Any}(
    "initial" => Dict{AbstractString, Any}(
        "state" => "first",
        "event" => "dance",
        "defer" => true,
    ),
    "terminal" => "fourth",
    "events" => [Dict{AbstractString, Any}(
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
    ],
))

@test dfsm.current == "none"
@test dfsm.terminal == "fourth"

mfsm = state_machine(Dict{AbstractString, Any}(
    "initial" => Dict{AbstractString, Any}(
        "state" => "first",
        "defer" => false,
    ),
    "events" => [Dict{AbstractString, Any}(
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
        ),
    ],
    "callbacks" => Dict{AbstractString, Any}(
        "onevent" => (fsm::StateMachine, args...) -> 1,
        "onstate" => (fsm::StateMachine, args...) -> -1,
    ),
))

@test mfsm.current == "first"
