import Toybox.Lang;

class BreathingEngine {
    const PRE_START_MS = 3000;
    const FINAL_MS = 3000;
    var session as BreathingSession;
    var state as Number = SessionState.IDLE;
    var phase as Number = 0;
    var phaseElapsed as Number = 0;
    var breathingElapsed as Number = 0;
    var completedCycles as Number = 0;
    var countdown as Number = 3;
    var _anchor as Number = 0;
    var _accumulated as Number = 0;
    var _elapsed as Number = 0;

    function initialize(config as BreathingSession) { session = config; }

    function isRunning() as Boolean {
        return state == SessionState.PRE_START_COUNTDOWN ||
            (state >= SessionState.INHALE && state <= SessionState.HOLD_OUT) ||
            state == SessionState.FINAL_COUNTDOWN;
    }

    function start(now as Number) as Void {
        if (state == SessionState.IDLE || state == SessionState.STOPPED || state == SessionState.COMPLETED) {
            restart(now);
        }
    }

    function restart(now as Number) as Void {
        _anchor = now;
        _accumulated = 0;
        _elapsed = 0;
        breathingElapsed = 0;
        completedCycles = 0;
        phase = 0;
        phaseElapsed = 0;
        countdown = PRE_START_MS / 1000;
        state = SessionState.PRE_START_COUNTDOWN;
    }

    function update(now as Number) as Void {
        if (!isRunning()) { return; }
        _elapsed = _accumulated + TimeUtils.elapsed(now, _anchor);
        evaluate();
    }

    function pause(now as Number) as Void {
        if (!isRunning()) { return; }
        update(now);
        if (!isRunning()) { return; }
        _accumulated = _elapsed;
        state = SessionState.PAUSED;
    }

    function resume(now as Number) as Void {
        if (state != SessionState.PAUSED) { return; }
        // Keep all pre-pause elapsed milliseconds and anchor only the next active
        // interval. Paused wall time is never added, including across clock rollover.
        _anchor = now;
        evaluate();
    }

    function stop() as Void {
        state = SessionState.STOPPED;
        _accumulated = 0;
        _elapsed = 0;
        phase = 0;
        phaseElapsed = 0;
        breathingElapsed = 0;
        completedCycles = 0;
        countdown = PRE_START_MS / 1000;
    }

    private function evaluate() as Void {
        if (_elapsed < PRE_START_MS) {
            state = SessionState.PRE_START_COUNTDOWN;
            countdown = (PRE_START_MS - _elapsed + 999) / 1000;
            return;
        }
        breathingElapsed = _elapsed - PRE_START_MS;
        if (breathingElapsed >= session.totalMs) {
            breathingElapsed = session.totalMs;
            completedCycles = session.cycles;
            phase = 3;
            phaseElapsed = session.durations[3];
            countdown = 0;
            state = SessionState.COMPLETED;
            return;
        }
        // Locate the exact cycle/phase on the timeline, carrying all overshoot.
        // A delayed callback can cross many phases without drifting or looping
        // over every missed tick, and it never generates a burst of old haptics.
        completedCycles = breathingElapsed / session.cycleMs;
        var position = breathingElapsed % session.cycleMs;
        phase = 0;
        while (phase < 3 && position >= session.durations[phase]) {
            position -= session.durations[phase];
            phase += 1;
        }
        phaseElapsed = position;
        state = SessionState.INHALE + phase;
        countdown = (session.durations[phase] - phaseElapsed + 999) / 1000;
        // FINAL_COUNTDOWN explicitly retains the underlying HOLD_OUT phase.
        if (completedCycles == session.cycles - 1 && phase == 3 &&
            session.durations[3] - phaseElapsed <= FINAL_MS) {
            state = SessionState.FINAL_COUNTDOWN;
        }
    }

    function phaseProgress() as Float {
        return Geometry.clamp(phaseElapsed.toFloat() / session.durations[phase]);
    }

    function progress() as Float {
        return Geometry.clamp(breathingElapsed.toFloat() / session.totalMs);
    }

    function phaseSeconds() as Number {
        if (_elapsed < PRE_START_MS) { return countdown; }
        return (phase == 0 || phase == 2) ? phaseElapsed / 1000 : countdown;
    }

    function isPreparing() as Boolean { return _elapsed < PRE_START_MS; }
}
