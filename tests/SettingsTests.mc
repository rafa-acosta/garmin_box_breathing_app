import Toybox.Test;

(:test)
function validateSettingTypesAndBoundaries(logger) {
    Test.assertEqual(BreathingSettings.validNumber(1, 1, 15, 4), 1);
    Test.assertEqual(BreathingSettings.validNumber(15, 1, 15, 4), 15);
    Test.assertEqual(BreathingSettings.validNumber(0, 1, 15, 4), 4);
    Test.assertEqual(BreathingSettings.validNumber(16, 1, 15, 4), 4);
    Test.assertEqual(BreathingSettings.validNumber(null, 1, 15, 4), 4);
    Test.assertEqual(BreathingSettings.validNumber("4", 1, 15, 4), 4);
    Test.assertEqual(BreathingSettings.validNumber(true, 1, 15, 4), 4);
    Test.assertEqual(BreathingSettings.validNumber(5.5, 1, 15, 4), 4);
    Test.assertEqual(BreathingSettings.validNumber(60, 1, 60, 10), 60);
    Test.assertEqual(BreathingSettings.validNumber(61, 1, 60, 10), 10);
    return true;
}

(:test)
function durationsAndThemePresets(logger) {
    var s = new BreathingSettings();
    Test.assertEqual(s.totalSeconds(), 160); Test.assertEqual(TimeUtils.duration(160), "2:40");
    s.seconds = [1, 1, 1, 1]; s.cycles = 1; Test.assertEqual(s.totalSeconds(), 4);
    s.seconds = [15, 15, 15, 15]; s.cycles = 60; Test.assertEqual(s.totalSeconds(), 3600);
    for (var i = 0; i < 5; i += 1) {
        s.applyTheme(i); Test.assert(!s.isCustom());
        for (var j = 0; j < 5; j += 1) { Test.assert(s.colorIndices[j] >= 0 && s.colorIndices[j] < Colors.PALETTE.size()); }
    }
    s.colorIndices[0] = 7; Test.assert(s.isCustom());
    return true;
}
