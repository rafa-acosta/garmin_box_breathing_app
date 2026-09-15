import Toybox.Test;

(:test)
function circleInterpolationAndClamping(logger) {
    Test.assertEqual(Geometry.radius(0, 0.0, 40.0, 120.0), 40.0);
    Test.assertEqual(Geometry.radius(0, 0.5, 40.0, 120.0), 80.0);
    Test.assertEqual(Geometry.radius(0, 1.0, 40.0, 120.0), 120.0);
    Test.assertEqual(Geometry.radius(1, 0.5, 40.0, 120.0), 120.0);
    Test.assertEqual(Geometry.radius(2, 0.5, 40.0, 120.0), 80.0);
    Test.assertEqual(Geometry.radius(2, 1.0, 40.0, 120.0), 40.0);
    Test.assertEqual(Geometry.radius(3, 0.5, 40.0, 120.0), 40.0);
    Test.assertEqual(Geometry.radius(0, -1.0, 40.0, 120.0), 40.0);
    Test.assertEqual(Geometry.radius(0, 2.0, 40.0, 120.0), 120.0);
    return true;
}

(:test)
function bothRoundDisplaysAndTouchTargets(logger) {
    var sizes = [390, 454];
    for (var i = 0; i < sizes.size(); i += 1) {
        var g = new RoundGeometry(sizes[i], sizes[i]);
        Test.assertEqual(g.cx, sizes[i] / 2.0); Test.assertEqual(g.cx, g.cy);
        Test.assert(g.ringRadius + g.ringStroke / 2.0 < g.size / 2);
        Test.assert(g.maxRadius + g.size * 0.02 < g.ringRadius);
        Test.assert(g.minRadius > 0); Test.assert(g.minRadius < g.maxRadius);
        Test.assert(g.inButton(g.cx.toNumber(), (g.size * 0.36).toNumber(), 0.36));
        Test.assert(!g.inButton(0, 0, 0.36));
        Test.assert(g.size * 0.11 >= 42);
    }
    return true;
}
