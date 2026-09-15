import Toybox.WatchUi;

class HomeDelegate extends WatchUi.BehaviorDelegate {
    var controller;
    var view;
    function initialize(owner, screen) { BehaviorDelegate.initialize(); controller = owner; view = screen; controller._home = screen; }
    function onSelect() { controller.start(); return true; }
    function onMenu() { controller.openSettings(); return true; }
    function onTap(event) {
        var p = event.getCoordinates();
        if (view.geometry.inButton(p[0], p[1], 0.745)) { return onSelect(); }
        if (view.geometry.inButton(p[0], p[1], 0.875)) { return onMenu(); }
        return false;
    }
}
