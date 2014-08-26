## FiniteStateMachine

[![Build Status](https://travis-ci.org/tensorjack/FiniteStateMachine.jl.svg)](https://travis-ci.org/tensorjack/FiniteStateMachine.jl) [![Coverage Status](https://coveralls.io/repos/tensorjack/FiniteStateMachine.jl/badge.png)](https://coveralls.io/r/tensorjack/FiniteStateMachine.jl)

A simple finite state machine library for Julia, based on Jake Gordon's [javascript-state-machine](https://github.com/jakesgordon/javascript-state-machine).

### Installation

    julia> Pkg.clone("git://github.com/tensorjack/FiniteStateMachine.jl")

### Usage

`StateMachine` objects are set up using the `state_machine` function, which takes a "model" describing your state machine's layout as input.

    julia> using FiniteStateMachine

    julia> fsm = state_machine((String => Any)[
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
            "onbeforeevent" => (fsm::StateMachine, args...) -> 10,
        ],
    ])

Events are called using the `fire` function:

    julia> fsm.current
    "first"

    julia> fire(fsm, "hop")

    julia> fsm.current
    "second"

    julia> fire(fsm, "skip")

    julia> fsm.current
    "third"

    julia> fire(fsm, "jump")

    julia> fsm.current
    "fourth"

    julia> fire(fsm, "finished")
    true

Unless other specified, a special "startup" event fires automatically when the state machine is created.

The "initial" field can be either a string, or a dict specifying: `state` (the name of the state in which to start), `event` (the startup event), and/or `defer` (set to `true` if the startup event should *not* be fired automatically when the state machine is created).

### Tests

Unit tests are located in `test/`.  To run the tests:

    $ julia test/runtests.jl
