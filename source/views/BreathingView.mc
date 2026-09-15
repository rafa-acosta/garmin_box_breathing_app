import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

class BreathingView extends BaseView {
    var controller as SessionController;
    var _labels as Array<String>;
    var _digits as Array<String>;
    var _cycles as Array<String>;
    var _ready;
    var _paused;
    var _finish;
    var _resume;
    var _stop;
    var _restart;
    var _hint;
    function initialize(owner) {
        BaseView.initialize();
        controller = owner;
        _labels = [Strings.get(Rez.Strings.Inhale), Strings.get(Rez.Strings.Hold),
            Strings.get(Rez.Strings.Exhale), Strings.get(Rez.Strings.Hold)];
        _ready = Strings.get(Rez.Strings.GetReady);
        _paused = Strings.get(Rez.Strings.Paused);
        _finish = Strings.get(Rez.Strings.Finishing);
        _resume = Strings.get(Rez.Strings.Resume);
        _stop = Strings.get(Rez.Strings.Stop);
        _restart = Strings.get(Rez.Strings.Restart);
        _hint = Strings.get(Rez.Strings.TapPause);
        _digits = [];
        for (var i = 0; i <= BreathingSettings.MAX_SECONDS; i += 1) { _digits.add(i.toString()); }
        _cycles = [];
        var total = controller.engine.session.cycles;
        var cycle = Strings.get(Rez.Strings.Cycle) + " ";
        for (var n = 1; n <= total; n += 1) { _cycles.add(cycle + n.toString() + " / " + total.toString()); }
    }
    function onShow() as Void { controller.showBreathing(); }
    function onHide() as Void { controller.hideBreathing(); }
    function onUpdate(dc) as Void {
        var e = controller.engine;
        var g = geometry;
        clear(dc);
        dc.setPenWidth(g.ringStroke);
        dc.setColor(Colors.TRACK, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(g.cx, g.cy, g.ringRadius);
        var remaining = 1.0 - e.progress();
        dc.setColor(e.session.ringColor, Graphics.COLOR_TRANSPARENT);
        if (remaining >= 0.99999) { dc.drawCircle(g.cx, g.cy, g.ringRadius); }
        else if (remaining > 0.0) {
            dc.drawArc(g.cx, g.cy, g.ringRadius, Graphics.ARC_CLOCKWISE, 90, 90 - remaining * 360);
        }
        var radius = e.isPreparing() ? g.minRadius : Geometry.radius(e.phase, e.phaseProgress(), g.minRadius, g.maxRadius);
        dc.setColor(e.session.colors[e.phase], Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth((g.size * 0.012).toNumber());
        dc.drawCircle(g.cx, g.cy, radius);
        if (e.state == SessionState.PAUSED) {
            text(dc, _paused, 0.13, Graphics.FONT_MEDIUM, Colors.TEXT);
            button(dc, _resume, 0.36, true);
            button(dc, _restart, 0.50, false);
            button(dc, _stop, 0.64, false);
        } else {
            text(dc, e.isPreparing() ? _ready : _labels[e.phase], 0.13, Graphics.FONT_MEDIUM, Colors.TEXT);
            text(dc, _digits[e.phaseSeconds()], 0.50, Graphics.FONT_NUMBER_MEDIUM, Colors.TEXT);
            text(dc, e.state == SessionState.FINAL_COUNTDOWN ? _finish : _hint,
                0.89, Graphics.FONT_XTINY, Colors.MUTED);
        }
        if (!e.isPreparing() && e.completedCycles < _cycles.size()) {
            text(dc, _cycles[e.completedCycles], 0.835, Graphics.FONT_TINY, Colors.MUTED);
        }
    }
}
