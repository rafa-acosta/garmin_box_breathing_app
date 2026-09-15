import Toybox.WatchUi;

class CompletionDelegate extends WatchUi.BehaviorDelegate {
    var controller;
    var view;
    function initialize(owner, screen) { BehaviorDelegate.initialize(); controller = owner; view = screen; }
    function onSelect() { controller.restart(); return true; }
    function onBack() { controller.home(); return true; }
    function onTap(event) {
        var p = event.getCoordinates();
        if (view.geometry.inButton(p[0], p[1], 0.73)) { return onSelect(); }
        if (view.geometry.inButton(p[0], p[1], 0.86)) { return onBack(); }
        return false;
    }
}
