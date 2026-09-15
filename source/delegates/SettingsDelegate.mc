import Toybox.WatchUi;
import Toybox.Lang;

class SettingsDelegate extends WatchUi.Menu2InputDelegate {
    var settings as BreathingSettings;
    var view;
    function initialize(config, screen) { Menu2InputDelegate.initialize(); settings = config; view = screen; }
    function onBack() as Void { WatchUi.popView(WatchUi.SLIDE_DOWN); }
    function onSelect(item) as Void {
        var id = item.getId() as Number;
        if (id == 8) { return; }
        if (id == 5) {
            settings.vibration = !settings.vibration;
            settings.save(); view.refresh(); WatchUi.requestUpdate(); return;
        }
        if (id == 7) {
            var colorMenu = new WatchUi.Menu2({:title => Strings.get(Rez.Strings.Colors)});
            var phaseNames = Strings.phaseIds();
            var paletteNames = Strings.paletteIds();
            for (var c = 0; c < 5; c += 1) {
                colorMenu.addItem(new WatchUi.MenuItem(Strings.get(c < 4 ? phaseNames[c] : Rez.Strings.ProgressRing),
                    Strings.get(paletteNames[settings.colorIndices[c]]), c, null));
            }
            WatchUi.pushView(colorMenu, new ColorSettingsDelegate(settings, view, colorMenu), WatchUi.SLIDE_UP);
            return;
        }
        var menu = new WatchUi.Menu2({:title => item.getLabel()});
        if (id == 6) {
            var themes = Strings.themeIds();
            for (var t = 0; t < themes.size(); t += 1) {
                menu.addItem(new WatchUi.MenuItem(Strings.get(themes[t]), null, t, null));
            }
            menu.setFocus(settings.theme);
        } else {
            var low = id == 4 ? BreathingSettings.MIN_CYCLES : BreathingSettings.MIN_SECONDS;
            var high = id == 4 ? BreathingSettings.MAX_CYCLES : BreathingSettings.MAX_SECONDS;
            for (var n = low; n <= high; n += 1) {
                var detail = id == 4 ? TimeUtils.duration((settings.totalSeconds() / settings.cycles) * n) : Strings.get(Rez.Strings.Seconds);
                menu.addItem(new WatchUi.MenuItem(n.toString(), detail, n, null));
            }
            menu.setFocus((id == 4 ? settings.cycles : settings.seconds[id]) - low);
        }
        WatchUi.pushView(menu, new SettingChoiceDelegate(settings, view, id, null), WatchUi.SLIDE_UP);
    }
}

class ColorSettingsDelegate extends WatchUi.Menu2InputDelegate {
    var settings as BreathingSettings;
    var parent;
    var menu;
    function initialize(config, screen, colorsMenu) { Menu2InputDelegate.initialize(); settings = config; parent = screen; menu = colorsMenu; }
    function onBack() as Void { WatchUi.popView(WatchUi.SLIDE_DOWN); }
    function onSelect(item) as Void {
        var choices = new WatchUi.Menu2({:title => item.getLabel()});
        var names = Strings.paletteIds();
        for (var i = 0; i < names.size(); i += 1) {
            choices.addItem(new WatchUi.MenuItem(Strings.get(names[i]), null, i, null));
        }
        choices.setFocus(settings.colorIndices[item.getId() as Number]);
        WatchUi.pushView(choices, new SettingChoiceDelegate(settings, parent, (item.getId() as Number) + 10, menu), WatchUi.SLIDE_UP);
    }
}

class SettingChoiceDelegate extends WatchUi.Menu2InputDelegate {
    var settings as BreathingSettings;
    var parent;
    var field;
    var colorMenu;
    function initialize(config, screen, id, colorsMenu) { Menu2InputDelegate.initialize(); settings = config; parent = screen; field = id; colorMenu = colorsMenu; }
    function onBack() as Void { WatchUi.popView(WatchUi.SLIDE_DOWN); }
    function onSelect(item) as Void {
        var value = item.getId() as Number;
        if (field < 4) { settings.seconds[field] = value; }
        else if (field == 4) { settings.cycles = value; }
        else if (field == 6) { settings.applyTheme(value); }
        else if (field >= 10) {
            settings.colorIndices[field - 10] = value;
            colorMenu.getItem(field - 10).setSubLabel(item.getLabel());
        }
        settings.save();
        parent.refresh();
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}
