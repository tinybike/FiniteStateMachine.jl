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
