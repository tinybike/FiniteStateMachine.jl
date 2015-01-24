## FiniteStateMachine

[![Build Status](https://travis-ci.org/tinybike/FiniteStateMachine.jl.svg)](https://travis-ci.org/tinybike/FiniteStateMachine.jl) [![Coverage Status](https://coveralls.io/repos/tinybike/FiniteStateMachine.jl/badge.png)](https://coveralls.io/r/tinybike/FiniteStateMachine.jl) [![FiniteStateMachine](http://pkg.julialang.org/badges/FiniteStateMachine_nightly.svg)](http://pkg.julialang.org/?pkg=FiniteStateMachine&ver=nightly)

A simple finite state machine library for Julia, based on Jake Gordon's [javascript-state-machine](https://github.com/jakesgordon/javascript-state-machine).

### Installation

    julia> Pkg.add("FiniteStateMachine")

### Usage

`StateMachine` objects are set up using the `state_machine` function, which takes a "model" describing your state machine's layout as input.

    julia> using FiniteStateMachine

    julia> fsm = state_machine({
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
            "onbeforeevent" => (fsm::StateMachine, args...) -> 1+1,
        },
    })

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

Supports multiple source states, for example, the following code allows "hop" to take place from either the "first" or "third" states:
            
    "events" => [{
        "name" => "hop",
        "from" => ["first", "third"],
        "to" => "second",
    },

### Tests

Unit tests are located in `test/`.  To run the tests:

    $ julia test/runtests.jl
