@test fire(dfsm, "can", "dance") == true
@test fire(dfsm, "can", "hop") == false
@test_throws ErrorException fire(dfsm, "skip")
@test_throws ErrorException fire(dfsm, "startup")

fire(dfsm, "dance")

@test dfsm.current == "first"
@test fire(dfsm, "can", "dance") == false
@test fire(dfsm, "can", "hop") == true
@test_throws ErrorException fire(dfsm, "skip")
@test_throws ErrorException fire(dfsm, "dance")

fire(dfsm, "hop")

@test dfsm.current == "second"

fire(dfsm, "skip")

@test dfsm.current == "third"

fire(dfsm, "sleep")

@test dfsm.current == "third"

@test fire(fsm, "is", "first") == true
@test fire(fsm, "can", "hop") == true
@test fire(fsm, "can", "jump") == false
@test fire(fsm, "finished") == false
@test_throws ErrorException fire(fsm, "jump")
@test_throws ErrorException fire(fsm, "skip")
@test_throws ErrorException fire(fsm, "startup")
@test_throws ErrorException fire(fsm, "humblebrag")

fire(fsm, "hop")

@test fsm.current == "second"
@test fire(fsm, "is", "first") == false
@test fire(fsm, "is", "second") == true
@test fire(fsm, "can", "hop") == false
@test fire(fsm, "can", "skip") == true
@test fire(fsm, "finished") == false
@test_throws ErrorException fire(fsm, "jump")
@test_throws ErrorException fire(fsm, "hop")
@test_throws ErrorException fire(fsm, "startup")
@test_throws ErrorException fire(fsm, "humblebrag")

fire(fsm, "skip")

@test fsm.current == "third"
@test fire(fsm, "is", "third") == true
@test fire(fsm, "can", "jump") == true
@test fire(fsm, "can", "skip") == false
@test fire(fsm, "finished") == false
@test_throws ErrorException fire(fsm, "hop")
@test_throws ErrorException fire(fsm, "skip")
@test_throws ErrorException fire(fsm, "startup")
@test_throws ErrorException fire(fsm, "humblebrag")

fire(fsm, "jump")

@test fsm.current == "fourth"
@test fire(fsm, "is", "fourth") == true
@test fire(fsm, "can", "hop") == false
@test fire(fsm, "can", "jump") == false
@test fire(fsm, "finished") == true
@test_throws ErrorException fire(fsm, "jump")
@test_throws ErrorException fire(fsm, "skip")
@test_throws ErrorException fire(fsm, "hop")
@test_throws ErrorException fire(fsm, "startup")
@test_throws ErrorException fire(fsm, "humblebrag")

fire(mfsm, "hop")

@test mfsm.current == "second"

fire(mfsm, "skip")

@test mfsm.current == "third"

fire(mfsm, "sleep")

@test mfsm.current == "third"

fire(mfsm, "hop")

@test mfsm.current == "second"
