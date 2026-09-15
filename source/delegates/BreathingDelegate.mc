import Toybox.WatchUi;

class BreathingDelegate extends WatchUi.BehaviorDelegate {
    var controller;
    var view;
    function initialize(owner, screen) { BehaviorDelegate.initialize(); controller = owner; view = screen; }
    function onSelect() {
        if (controller.engine.state == SessionState.PAUSED) { controller.resume(); }
        else { controller.pause(); }
        return true;
    }
    function onBack() { controller.confirmStop(); return true; }
    function onMenu() { controller.options(); return true; }
    function onTap(event) {
        if (controller.engine.state != SessionState.PAUSED) { controller.pause(); return true; }
        var p = event.getCoordinates();
        if (view.geometry.inButton(p[0], p[1], 0.36)) { controller.resume(); }
        else if (view.geometry.inButton(p[0], p[1], 0.50)) { controller.restart(); }
        else if (view.geometry.inButton(p[0], p[1], 0.64)) { controller.confirmStop(); }
        return true;
    }
}

class SessionOptionsDelegate extends WatchUi.Menu2InputDelegate {
    var controller;
    function initialize(owner) { Menu2InputDelegate.initialize(); controller = owner; }
    function onSelect(item) as Void {
        var id = item.getId();
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        if (id == :resume) { controller.resume(); }
        else if (id == :restart) { controller.restart(); }
        else if (id == :stop) { controller.confirmStop(); }
    }
    function onBack() as Void { WatchUi.popView(WatchUi.SLIDE_DOWN); }
}

class StopDelegate extends WatchUi.Menu2InputDelegate {
    var controller;
    function initialize(owner) { Menu2InputDelegate.initialize(); controller = owner; }
    function onSelect(item) as Void {
        if (!controller._confirmOpen) { return; }
        controller._confirmOpen = false;
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        if (item.getId() == :yes) { controller.stop(); }
    }
    function onBack() as Void {
        controller._confirmOpen = false;
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}
