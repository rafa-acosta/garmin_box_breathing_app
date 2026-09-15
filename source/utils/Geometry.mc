import Toybox.Lang;

module Geometry {
    function clamp(value as Float) as Float {
        if (value < 0.0) { return 0.0; }
        if (value > 1.0) { return 1.0; }
        return value;
    }

    function radius(phase as Number, progress as Float, low as Float, high as Float) as Float {
        var p = clamp(progress);
        if (phase == 0) { return low + (high - low) * p; }
        if (phase == 1) { return high; }
        if (phase == 2) { return high - (high - low) * p; }
        return low;
    }
}

class RoundGeometry {
    var size as Float;
    var cx as Float;
    var cy as Float;
    var ringRadius as Float;
    var ringStroke as Number;
    var minRadius as Float;
    var maxRadius as Float;

    function initialize(width as Number, height as Number) {
        size = ((width < height) ? width : height).toFloat();
        cx = width / 2.0;
        cy = height / 2.0;
        ringRadius = size * 0.467;
        ringStroke = (size * 0.009).toNumber();
        // Usable radius is 44% of the diameter. Breathing radii use 23% and
        // 68% of that radius, leaving space for text and the perimeter track.
        minRadius = size * 0.44 * 0.23;
        maxRadius = size * 0.44 * 0.68;
    }

    function inButton(x as Number, y as Number, row as Float) as Boolean {
        return x >= cx - size * 0.28 && x <= cx + size * 0.28 &&
            y >= size * (row - 0.055) && y <= size * (row + 0.055);
    }
}
