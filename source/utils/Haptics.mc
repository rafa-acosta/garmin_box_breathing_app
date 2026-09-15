import Toybox.Attention;

class Haptics {
    var _pattern;
    function initialize() {
        if (Attention has :VibeProfile) { _pattern = [new Attention.VibeProfile(35, 100)]; }
    }
    function pulse(enabled) as Void {
        if (!enabled || _pattern == null) { return; }
        if (Attention has :vibrate) {
            try { Attention.vibrate(_pattern); }
            catch (error) { /* Optional feedback must never interrupt a session. */ }
        }
    }
}
