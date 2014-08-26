fsm = state_machine({
    "initial" => "first",
    "final" => "fourth",
    "events" => [{
            "name" => "hop",
            "from" => "first",
            "to" => "second",
        }, {
            "name" => "skip",
            "from" => "second",
            "to" => "third",
        }, {
            "name" => "jump",
            "from" => "third",
            "to" => "fourth",
        },
    ],
    "callbacks" => {
        "onbeforeevent" => (fsm::StateMachine, args...) -> 1,
        "onafterevent" => (fsm::StateMachine, args...) -> 1 + 1,
        "onbeforejump" => (fsm::StateMachine, args...) -> 1 + 2,
        "onafterskip" => (fsm::StateMachine, args...) -> 2 + 3,
        "onchangestate" => (fsm::StateMachine, args...) -> 3 + 5,
        "onenterstate" => (fsm::StateMachine, args...) -> 5 + 8,
        "onentersecond" => (fsm::StateMachine, args...) -> 8 + 13,
        "onleavestate" => (fsm::StateMachine, args...) -> 13 + 21,
        "onleavefirst" => (fsm::StateMachine, args...) -> 21 + 34,
    },
})

@test fsm.current == "first"
@test fsm.terminal == "fourth"
@test fsm.map == {
    "startup" => ["none" => "first"],
    "skip" => ["second" => "third"],
    "jump" => ["third" => "fourth"],
    "hop" => ["first" => "second"],
}

dfsm = state_machine({
    "initial" => {
        "state" => "first",
        "event" => "dance",
        "defer" => true,
    },
    "terminal" => "fourth",
    "events" => [{
            "name" => "hop",
            "from" => "first",
            "to" => "second",
        }, {
            "name" => "skip",
            "from" => "second",
            "to" => "third",
        }, {
            "name" => "sleep",
            "from" => "third",
        }, {
            "name" => "coupdegrace",
            "from" => "third",
            "to" => "fourth",
        }
    ],
})

@test dfsm.current == "none"
@test dfsm.terminal == "fourth"

mfsm = state_machine({
    "initial" => {
        "state" => "first",
        "defer" => false,
    },
    "events" => [{
            "name" => "hop",
            "from" => ["first", "third"],
            "to" => "second",
        }, {
            "name" => "skip",
            "from" => "second",
            "to" => "third",
        }, {
            "name" => "sleep",
            "from" => "third",
        },
    ],
    "callbacks" => {
        "onevent" => (fsm::StateMachine, args...) -> 1,
        "onstate" => (fsm::StateMachine, args...) -> -1,
    },
})

@test mfsm.current == "first"
