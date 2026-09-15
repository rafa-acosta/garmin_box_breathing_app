import Toybox.Application;
import Toybox.Lang;

class BreathingSettings {
    static const MIN_SECONDS = 1;
    static const MAX_SECONDS = 15;
    static const MIN_CYCLES = 1;
    static const MAX_CYCLES = 60;
    var seconds as Array<Number> = [4, 4, 4, 4];
    var cycles as Number = 10;
    var vibration as Boolean = true;
    var theme as Number = 0;
    var colorIndices as Array<Number> = [0, 1, 2, 3, 0];
    var saveFailed as Boolean = false;
    var _phaseKeys as Array<String> = ["inhale", "holdIn", "exhale", "holdOut"];
    var _colorKeys as Array<String> = ["inhaleColor", "holdInColor", "exhaleColor", "holdOutColor", "ringColor"];

    function initialize() {}

    static function validNumber(value, low as Number, high as Number, fallback as Number) as Number {
        if (!(value instanceof Number)) { return fallback; }
        if (value < low || value > high) { return fallback; }
        return value;
    }

    private function read(key as String) {
        try { return Application.Properties.getValue(key); }
        catch (error) { return null; }
    }

    function load() as Void {
        for (var i = 0; i < 4; i += 1) {
            seconds[i] = validNumber(read(_phaseKeys[i]), MIN_SECONDS, MAX_SECONDS, 4);
        }
        cycles = validNumber(read("cycles"), MIN_CYCLES, MAX_CYCLES, 10);
        var storedVibration = read("vibration");
        vibration = (storedVibration instanceof Boolean) ? storedVibration : true;
        theme = validNumber(read("theme"), 0, 4, 0);
        for (var j = 0; j < 5; j += 1) {
            colorIndices[j] = validNumber(read(_colorKeys[j]), 0, Colors.PALETTE.size() - 1, Colors.THEMES[theme][j]);
        }
    }

    function applyTheme(index as Number) as Void {
        theme = validNumber(index, 0, 4, 0);
        for (var i = 0; i < 5; i += 1) { colorIndices[i] = Colors.THEMES[theme][i]; }
    }

    function isCustom() as Boolean {
        for (var i = 0; i < 5; i += 1) {
            if (colorIndices[i] != Colors.THEMES[theme][i]) { return true; }
        }
        return false;
    }

    function totalSeconds() as Number {
        return (seconds[0] + seconds[1] + seconds[2] + seconds[3]) * cycles;
    }

    function save() as Void {
        saveFailed = false;
        try {
            for (var i = 0; i < 4; i += 1) { Application.Properties.setValue(_phaseKeys[i], seconds[i]); }
            Application.Properties.setValue("cycles", cycles);
            Application.Properties.setValue("vibration", vibration);
            Application.Properties.setValue("theme", theme);
            for (var j = 0; j < 5; j += 1) { Application.Properties.setValue(_colorKeys[j], colorIndices[j]); }
        } catch (error) { saveFailed = true; }
    }
}
