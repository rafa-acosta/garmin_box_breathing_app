import Toybox.Test;

(:test)
function pauseFreezesAndResumePreservesMilliseconds(logger) {
    var e = new BreathingEngine(new BreathingSession(new BreathingSettings()));
    e.start(0); e.pause(4250);
    Test.assertEqual(e.state, SessionState.PAUSED);
    Test.assertEqual(e.phaseElapsed, 1250);
    var progress = e.progress(); e.update(90000); e.pause(95000);
    Test.assertEqual(e.phaseElapsed, 1250); Test.assertEqual(e.progress(), progress);
    e.resume(100000); e.resume(101000); e.update(102749);
    Test.assertEqual(e.state, SessionState.INHALE); Test.assertEqual(e.phaseElapsed, 3999);
    e.update(102750); Test.assertEqual(e.state, SessionState.HOLD_IN);
    return true;
}

(:test)
function pausedCountdownAndFinalCountdown(logger) {
    var s = new BreathingSettings(); s.cycles = 1;
    var e = new BreathingEngine(new BreathingSession(s)); e.start(0); e.pause(1250);
    e.resume(10000); e.update(11749); Test.assertEqual(e.state, SessionState.PRE_START_COUNTDOWN);
    e.update(11750); Test.assertEqual(e.state, SessionState.INHALE);
    e.pause(24750); Test.assertEqual(e.phaseSeconds(), 3);
    e.resume(30000); Test.assertEqual(e.state, SessionState.FINAL_COUNTDOWN);
    e.update(32999); Test.assert(e.isRunning());
    e.update(33000); Test.assertEqual(e.state, SessionState.COMPLETED);
    return true;
}

(:test)
function clockRollover(logger) {
    Test.assertEqual(TimeUtils.elapsed(-2147483648, 2147483647), 1);
    Test.assertEqual(TimeUtils.elapsed(0, -1), 1);
    var e = new BreathingEngine(new BreathingSession(new BreathingSettings()));
    e.start(2147483000); e.update(-2147481296);
    Test.assertEqual(e.state, SessionState.INHALE); Test.assertEqual(e.phaseElapsed, 0);
    e.pause(-2147480296); e.resume(-2147470296); e.update(-2147467296);
    Test.assertEqual(e.state, SessionState.HOLD_IN);
    return true;
}

(:test)
function progressQuartersAndDelayedCallbacks(logger) {
    var e = new BreathingEngine(new BreathingSession(new BreathingSettings())); e.start(0);
    var times = [3000, 43000, 83000, 123000, 163000];
    var expected = [0.0, 0.25, 0.5, 0.75, 1.0];
    for (var i = 0; i < times.size(); i += 1) { e.update(times[i]); Test.assertEqual(e.progress(), expected[i]); }
    Test.assertEqual(e.state, SessionState.COMPLETED);
    e.update(999999); Test.assertEqual(e.progress(), 1.0);
    e.restart(0); e.update(35555);
    Test.assertEqual(e.completedCycles, 2); Test.assertEqual(e.phaseElapsed, 555);
    Test.assertEqual(e.state, SessionState.INHALE);
    return true;
}

(:test)
function noDriftAcrossEntireMaximumSession(logger) {
    var s = new BreathingSettings(); s.seconds = [15, 15, 15, 15]; s.cycles = 60;
    var e = new BreathingEngine(new BreathingSession(s)); e.start(0);
    for (var now = 0; now < 3603000; now += 719) { e.update(now); }
    e.update(3602999); Test.assert(e.isRunning());
    e.update(3603000); Test.assertEqual(e.state, SessionState.COMPLETED);
    Test.assertEqual(e.breathingElapsed, 3600000);
    return true;
}

(:test)
function pauseAtCompletionCannotResurrectSession(logger) {
    var e = new BreathingEngine(new BreathingSession(new BreathingSettings())); e.start(0);
    e.pause(163000); e.resume(200000);
    Test.assertEqual(e.state, SessionState.COMPLETED);
    return true;
}
