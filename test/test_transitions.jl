@test callback(fsm, "onbeforeevent", "hop", "first", "second") == 1
@test before_any_event(fsm, "hop", "first", "second") == 1
@test before_event(fsm, "hop", "first", "second") == 1

@test callback(fsm, "onbeforejump", "jump", "third", "fourth") == 3
@test before_any_event(fsm, "jump", "third", "fourth") == 1
@test before_this_event(fsm, "jump", "third", "fourth") == 3
@test before_event(fsm, "jump", "third", "fourth") == 1

@test callback(fsm, "onafterevent", "skip", "second", "third") == 2
@test after_any_event(fsm, "skip", "second", "third") == 2
@test after_this_event(fsm, "skip", "second", "third") == 5
@test after_event(fsm, "skip", "second", "third") == 2

@test change_state(fsm, "hop", "first", "second") == 8
@test enter_any_state(fsm, "hop", "first", "second") == 13
@test enter_this_state(fsm, "hop", "first", "second") == 21
@test leave_any_state(fsm, "hop", "first", "second") == 34
@test leave_this_state(fsm, "hop", "first", "second") == 55

@test after_any_event(mfsm, "hop", "first", "second") == 1
@test enter_any_state(mfsm, "hop", "first", "second") == -1