import Toybox.Lang;

module TimeUtils {
    function elapsed(now as Number, start as Number) as Number {
        // Convert before subtracting: the signed 32-bit millisecond clock wraps
        // from +2^31-1 to -2^31. Unsigned modular subtraction also handles -1 -> 0.
        // Sessions are at most one hour; no measurement spans a full 2^32 period.
        var delta = (now.toLong() - start.toLong()) & 0xffffffffl;
        return delta.toNumber();
    }

    function duration(seconds as Number) as String {
        return (seconds / 60).format("%d") + ":" + (seconds % 60).format("%02d");
    }
}
