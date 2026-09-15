import Toybox.WatchUi;
import Toybox.Lang;

// Native Menu2 supplies device-specific scrolling, touch targets and button input.
class SettingsView extends WatchUi.Menu2 {
    var settings as BreathingSettings;
    function initialize(config) {
        Menu2.initialize({:title => Strings.get(Rez.Strings.Settings)});
        settings = config;
        var labels = Strings.phaseIds();
        for (var i = 0; i < 4; i += 1) {
            addItem(new WatchUi.MenuItem(Strings.get(labels[i]), null, i, null));
        }
        addItem(new WatchUi.MenuItem(Strings.get(Rez.Strings.Cycles), null, 4, null));
        addItem(new WatchUi.MenuItem(Strings.get(Rez.Strings.Vibration), null, 5, null));
        addItem(new WatchUi.MenuItem(Strings.get(Rez.Strings.Theme), null, 6, null));
        addItem(new WatchUi.MenuItem(Strings.get(Rez.Strings.Colors), null, 7, null));
        addItem(new WatchUi.MenuItem(Strings.get(Rez.Strings.Version), "1.0.0", 8, null));
        refresh();
    }
    function refresh() as Void {
        for (var i = 0; i < 4; i += 1) {
            getItem(i).setSubLabel(settings.seconds[i].toString() + " " + Strings.get(Rez.Strings.Seconds));
        }
        getItem(4).setSubLabel(settings.cycles.toString() + " · " + TimeUtils.duration(settings.totalSeconds()));
        getItem(5).setSubLabel(Strings.get(settings.vibration ? Rez.Strings.On : Rez.Strings.Off));
        var themes = Strings.themeIds();
        getItem(6).setSubLabel(Strings.get(settings.isCustom() ? Rez.Strings.Custom : themes[settings.theme]));
        setTitle(Strings.get(settings.saveFailed ? Rez.Strings.SaveFailed : Rez.Strings.Settings));
    }
}
