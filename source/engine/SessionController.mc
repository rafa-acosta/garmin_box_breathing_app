import Toybox.System;
import Toybox.Timer;
import Toybox.WatchUi;

class SessionController {
    const REFRESH_MS = 100;
    var settings as BreathingSettings;
    var engine as BreathingEngine?;
    var _timer;
    var _haptics;
    var _visible = false;
    var _timerRunning = false;
    var _confirmOpen = false;
    var _home;
    function initialize() {
        settings = new BreathingSettings();
        settings.load();
        _timer = new Timer.Timer();
        _haptics = new Haptics();
    }
    function refreshHome() as Void {
        if (_home != null) { _home.onShow(); WatchUi.requestUpdate(); }
    }
    function home() as Void {
        stopTimer();
        _home = new HomeView(self);
        WatchUi.switchToView(_home, new HomeDelegate(self, _home), WatchUi.SLIDE_IMMEDIATE);
        engine = null;
    }
    function start() as Void {
        if (engine != null && (engine.isRunning() || engine.state == SessionState.PAUSED)) { return; }
        engine = new BreathingEngine(new BreathingSession(settings));
        engine.start(System.getTimer());
        showSessionView();
    }
    function restart() as Void {
        if (engine == null) { start(); return; }
        engine.restart(System.getTimer());
        // Replacing a visible breathing view would trigger onHide and pause the
        // freshly restarted engine. Keep it in place if it is already visible.
        if (_visible) { startTimer(); WatchUi.requestUpdate(); }
        else { showSessionView(); }
    }
    private function showSessionView() as Void {
        _home = null;
        var view = new BreathingView(self);
        WatchUi.switchToView(view, new BreathingDelegate(self, view), WatchUi.SLIDE_IMMEDIATE);
    }
    function showBreathing() as Void {
        _visible = true;
        if (engine != null && engine.isRunning()) { startTimer(); }
    }
    function hideBreathing() as Void {
        _visible = false;
        pause();
    }
    private function startTimer() as Void {
        if (!_timerRunning && _visible && engine.isRunning()) {
            _timer.start(method(:tick), REFRESH_MS, true);
            _timerRunning = true;
        }
    }
    function stopTimer() as Void {
        if (_timerRunning) { _timer.stop(); _timerRunning = false; }
    }
    function pause() as Void {
        stopTimer();
        if (engine != null) { engine.pause(System.getTimer()); }
        if (_visible) { finishIfComplete(); WatchUi.requestUpdate(); }
    }
    function resume() as Void {
        if (engine == null || _confirmOpen) { return; }
        engine.resume(System.getTimer());
        startTimer();
        WatchUi.requestUpdate();
    }
    function tick() as Void {
        if (!_visible || engine == null || !engine.isRunning()) { stopTimer(); return; }
        var oldState = engine.state;
        var oldPhase = engine.phase;
        var oldCycle = engine.completedCycles;
        engine.update(System.getTimer());
        if (finishIfComplete()) { return; }
        if (oldPhase != engine.phase || oldCycle != engine.completedCycles ||
            oldState == SessionState.PRE_START_COUNTDOWN && !engine.isPreparing()) {
            _haptics.pulse(engine.session.vibration);
        }
        WatchUi.requestUpdate();
    }
    function finishIfComplete() {
        if (engine == null || engine.state != SessionState.COMPLETED) { return false; }
        stopTimer();
        _haptics.pulse(engine.session.vibration);
        var view = new CompletionView(engine.session);
        WatchUi.switchToView(view, new CompletionDelegate(self, view), WatchUi.SLIDE_IMMEDIATE);
        return true;
    }
    function confirmStop() as Void {
        if (_confirmOpen || engine == null) { return; }
        pause();
        if (engine.state == SessionState.COMPLETED) { return; }
        _confirmOpen = true;
        var menu = new WatchUi.Menu2({:title => Strings.get(Rez.Strings.EndSession)});
        // Default to No: an extra select press cannot accidentally stop a run.
        menu.addItem(new WatchUi.MenuItem(Strings.get(Rez.Strings.No), null, :no, null));
        menu.addItem(new WatchUi.MenuItem(Strings.get(Rez.Strings.Yes), null, :yes, null));
        WatchUi.pushView(menu, new StopDelegate(self), WatchUi.SLIDE_UP);
    }
    function stop() as Void {
        stopTimer();
        if (engine != null) { engine.stop(); }
        home();
    }
    function options() as Void {
        pause();
        if (engine == null || engine.state != SessionState.PAUSED) { return; }
        var menu = new WatchUi.Menu2({:title => Strings.get(Rez.Strings.Paused)});
        menu.addItem(new WatchUi.MenuItem(Strings.get(Rez.Strings.Resume), null, :resume, null));
        menu.addItem(new WatchUi.MenuItem(Strings.get(Rez.Strings.Restart), null, :restart, null));
        menu.addItem(new WatchUi.MenuItem(Strings.get(Rez.Strings.Stop), null, :stop, null));
        WatchUi.pushView(menu, new SessionOptionsDelegate(self), WatchUi.SLIDE_UP);
    }
    function openSettings() as Void {
        if (engine != null && (engine.isRunning() || engine.state == SessionState.PAUSED)) { return; }
        var view = new SettingsView(settings);
        WatchUi.pushView(view, new SettingsDelegate(settings, view), WatchUi.SLIDE_UP);
    }
    function shutdown() as Void {
        stopTimer();
        if (engine != null) { engine.stop(); }
    }
}
