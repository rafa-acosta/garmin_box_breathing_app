import Toybox.Application;

class BoxBreathingApp extends Application.AppBase {
    var controller;
    function initialize() { AppBase.initialize(); }
    function onStart(state) as Void { controller = new SessionController(); }
    function getInitialView() {
        var view = new HomeView(controller);
        return [view, new HomeDelegate(controller, view)];
    }
    function onStop(state) as Void {
        if (controller != null) { controller.shutdown(); }
    }
    function onSettingsChanged() as Void {
        controller.settings.load();
        // An active engine owns a snapshot; remote configuration affects only
        // the next session. Refresh the idle summary when it is visible.
        controller.refreshHome();
    }
}
