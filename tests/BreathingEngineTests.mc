import Toybox.Test;

(:test)
function initialState(logger) {
    var e = new BreathingEngine(new BreathingSession(new BreathingSettings()));
    Test.assertEqual(e.state, SessionState.IDLE);
    Test.assertEqual(e.progress(), 0.0);
    Test.assert(!e.isRunning());
    return true;
}

(:test)
function countdownAndAllTransitions(logger) {
    var e = new BreathingEngine(new BreathingSession(new BreathingSettings()));
    e.start(100);
    Test.assertEqual(e.state, SessionState.PRE_START_COUNTDOWN);
    Test.assertEqual(e.phaseSeconds(), 3);
    e.update(1100); Test.assertEqual(e.phaseSeconds(), 2);
    e.update(2100); Test.assertEqual(e.phaseSeconds(), 1);
    Test.assertEqual(e.progress(), 0.0);
    e.update(3100); Test.assertEqual(e.state, SessionState.INHALE);
    Test.assertEqual(e.phaseSeconds(), 0);
    e.update(7100); Test.assertEqual(e.state, SessionState.HOLD_IN);
    Test.assertEqual(e.phaseSeconds(), 4);
    e.update(11100); Test.assertEqual(e.state, SessionState.EXHALE);
    e.update(15100); Test.assertEqual(e.state, SessionState.HOLD_OUT);
    e.update(19100); Test.assertEqual(e.state, SessionState.INHALE);
    Test.assertEqual(e.completedCycles, 1);
    return true;
}

(:test)
function finalCountdownRetainsLastPhase(logger) {
    var s = new BreathingSettings(); s.cycles = 1;
    var e = new BreathingEngine(new BreathingSession(s)); e.start(0);
    e.update(15000); Test.assertEqual(e.state, SessionState.HOLD_OUT);
    e.update(16000); Test.assertEqual(e.state, SessionState.FINAL_COUNTDOWN);
    Test.assertEqual(e.phase, 3); Test.assertEqual(e.phaseSeconds(), 3);
    e.update(17000); Test.assertEqual(e.phaseSeconds(), 2);
    e.update(18000); Test.assertEqual(e.phaseSeconds(), 1);
    e.update(18999); Test.assert(e.isRunning());
    e.update(19000); Test.assertEqual(e.state, SessionState.COMPLETED);
    Test.assertEqual(e.phaseSeconds(), 0); Test.assertEqual(e.completedCycles, 1);
    Test.assertEqual(e.progress(), 1.0); Test.assert(!e.isRunning());
    return true;
}

(:test)
function restartFromPauseAndCompletion(logger) {
    var e = new BreathingEngine(new BreathingSession(new BreathingSettings()));
    e.start(0); e.pause(8000); e.restart(9000);
    Test.assertEqual(e.state, SessionState.PRE_START_COUNTDOWN);
    Test.assertEqual(e.phase, 0); Test.assertEqual(e.phaseElapsed, 0);
    Test.assertEqual(e.breathingElapsed, 0); Test.assertEqual(e.completedCycles, 0);
    Test.assertEqual(e.progress(), 0.0);
    e.update(172000); Test.assertEqual(e.state, SessionState.COMPLETED);
    e.restart(180000); e.update(183000);
    Test.assertEqual(e.state, SessionState.INHALE);
    return true;
}

(:test)
function stopIsIdempotentAndInert(logger) {
    var e = new BreathingEngine(new BreathingSession(new BreathingSettings()));
    e.start(0); e.update(12000); e.stop(); e.stop(); e.update(100000); e.resume(100000);
    Test.assertEqual(e.state, SessionState.STOPPED);
    Test.assertEqual(e.breathingElapsed, 0); Test.assertEqual(e.phaseElapsed, 0);
    Test.assertEqual(e.completedCycles, 0); Test.assert(!e.isRunning());
    e.start(200000); Test.assertEqual(e.state, SessionState.PRE_START_COUNTDOWN);
    return true;
}

(:test)
function unequalDurationsAndMinimumFinalHold(logger) {
    var s = new BreathingSettings(); s.seconds = [1, 2, 3, 1]; s.cycles = 1;
    var e = new BreathingEngine(new BreathingSession(s)); e.start(0);
    e.update(4000); Test.assertEqual(e.state, SessionState.HOLD_IN);
    e.update(6000); Test.assertEqual(e.state, SessionState.EXHALE);
    e.update(9000); Test.assertEqual(e.state, SessionState.FINAL_COUNTDOWN);
    Test.assertEqual(e.phaseSeconds(), 1);
    e.update(10000); Test.assertEqual(e.state, SessionState.COMPLETED);
    return true;
}

(:test)
function sessionSnapshotIsIndependent(logger) {
    var s = new BreathingSettings(); var session = new BreathingSession(s);
    s.seconds[0] = 15; s.cycles = 60; s.applyTheme(3); s.vibration = false;
    Test.assertEqual(session.durations[0], 4000);
    Test.assertEqual(session.cycles, 10); Test.assertEqual(session.totalMs, 160000);
    Test.assertEqual(session.colors[0], Colors.PALETTE[0]); Test.assert(session.vibration);
    return true;
}
