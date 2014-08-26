fsm = state_machine((String => Any)[
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
        "onbeforeevent" => (fsm::StateMachine, args...) -> 1,
        "onafterevent" => (fsm::StateMachine, args...) -> 1 + 1,
        "onbeforejump" => (fsm::StateMachine, args...) -> 1 + 2,
        "onafterskip" => (fsm::StateMachine, args...) -> 2 + 3,
        "onchangestate" => (fsm::StateMachine, args...) -> 3 + 5,
        "onenterstate" => (fsm::StateMachine, args...) -> 5 + 8,
        "onentersecond" => (fsm::StateMachine, args...) -> 8 + 13,
        "onleavestate" => (fsm::StateMachine, args...) -> 13 + 21,
        "onleavefirst" => (fsm::StateMachine, args...) -> 21 + 34,
    ],
])

@test fsm.current == "first"
@test fsm.terminal == "fourth"
@test fsm.map == (String => Dict{String, String})[
    "startup" => ["none" => "first"],
    "skip" => ["second" => "third"],
    "jump" => ["third" => "fourth"],
    "hop" => ["first" => "second"],
]
