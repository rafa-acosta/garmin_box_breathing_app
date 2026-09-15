import Toybox.Graphics;

class HomeView extends BaseView {
    var controller as SessionController;
    var _title;
    var _start;
    var _settings;
    var _summary;
    var _duration;
    var _pattern;
    function initialize(owner) {
        BaseView.initialize();
        controller = owner;
        _title = Strings.get(Rez.Strings.AppName);
        _start = Strings.get(Rez.Strings.Start);
        _settings = Strings.get(Rez.Strings.Settings);
    }
    function onShow() as Void {
        var s = controller.settings;
        _duration = TimeUtils.duration(s.totalSeconds());
        _summary = s.cycles.toString() + " " + Strings.get(Rez.Strings.Cycles);
        _pattern = s.seconds[0].toString() + " · " + s.seconds[1].toString() + " · " +
            s.seconds[2].toString() + " · " + s.seconds[3].toString();
    }
    function onUpdate(dc) as Void {
        clear(dc);
        dc.setColor(Colors.ACCENT, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        dc.drawCircle(geometry.cx, geometry.size * 0.20, geometry.size * 0.055);
        text(dc, _title, 0.32, Graphics.FONT_SMALL, Colors.TEXT);
        text(dc, _duration, 0.455, Graphics.FONT_NUMBER_MEDIUM, Colors.TEXT);
        text(dc, _summary, 0.56, Graphics.FONT_TINY, Colors.MUTED);
        text(dc, _pattern, 0.635, Graphics.FONT_TINY, Colors.MUTED);
        button(dc, _start, 0.745, true);
        button(dc, _settings, 0.875, false);
    }
}
