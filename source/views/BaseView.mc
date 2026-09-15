import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class BaseView extends WatchUi.View {
    var geometry;
    function initialize() { View.initialize(); }
    function onLayout(dc as Graphics.Dc) as Void {
        geometry = new RoundGeometry(dc.getWidth(), dc.getHeight());
    }
    function clear(dc) as Void {
        dc.setColor(Colors.TEXT, Colors.BACKGROUND);
        dc.clear();
        if (dc has :setAntiAlias) { dc.setAntiAlias(true); }
    }
    function text(dc, value, row, font, color) as Void {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(geometry.cx, geometry.size * row, font, value,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
    function button(dc, label, row, primary) as Void {
        var g = geometry;
        dc.setColor(primary ? Colors.ACCENT : Colors.BUTTON, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(g.cx - g.size * 0.28, g.size * (row - 0.055),
            g.size * 0.56, g.size * 0.11, g.size * 0.045);
        text(dc, label, row, Graphics.FONT_SMALL, primary ? Colors.INK : Colors.TEXT);
    }
}
