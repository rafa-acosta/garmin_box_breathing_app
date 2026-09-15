import Toybox.Lang;

// An immutable-by-convention snapshot; settings changes cannot alter an active run.
class BreathingSession {
    var durations as Array<Number>;
    var cycles as Number;
    var cycleMs as Number;
    var totalMs as Number;
    var colors as Array<Number>;
    var ringColor as Number;
    var vibration as Boolean;

    function initialize(settings as BreathingSettings) {
        durations = [0, 0, 0, 0];
        colors = [0, 0, 0, 0];
        cycleMs = 0;
        for (var i = 0; i < 4; i += 1) {
            durations[i] = settings.seconds[i] * 1000;
            colors[i] = Colors.PALETTE[settings.colorIndices[i]];
            cycleMs += durations[i];
        }
        cycles = settings.cycles;
        totalMs = cycleMs * cycles;
        ringColor = Colors.PALETTE[settings.colorIndices[4]];
        vibration = settings.vibration;
    }
}
