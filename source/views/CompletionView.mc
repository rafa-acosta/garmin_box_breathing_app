import Toybox.Graphics;

class CompletionView extends BaseView {
    var _title;
    var _cycles;
    var _duration;
    var _restart;
    var _done;
    function initialize(session) {
        BaseView.initialize();
        _title = Strings.get(Rez.Strings.SessionComplete);
        _cycles = session.cycles.toString() + " " + Strings.get(Rez.Strings.Cycles);
        _duration = TimeUtils.duration(session.totalMs / 1000);
        _restart = Strings.get(Rez.Strings.Restart);
        _done = Strings.get(Rez.Strings.Done);
    }
    function onUpdate(dc) as Void {
        clear(dc);
        dc.setColor(Colors.ACCENT, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(3);
        dc.drawCircle(geometry.cx, geometry.size * 0.20, geometry.size * 0.055);
        text(dc, _title, 0.32, Graphics.FONT_SMALL, Colors.TEXT);
        text(dc, _duration, 0.465, Graphics.FONT_NUMBER_MEDIUM, Colors.TEXT);
        text(dc, _cycles, 0.585, Graphics.FONT_TINY, Colors.MUTED);
        button(dc, _restart, 0.73, true);
        button(dc, _done, 0.86, false);
    }
}
