import Toybox.Lang;

module Colors {
    const BACKGROUND = 0x000000;
    const TEXT = 0xF4F7FA;
    const MUTED = 0xADB9C8;
    const TRACK = 0x26313C;
    const BUTTON = 0x17232E;
    const INK = 0x00151B;
    const ACCENT = 0x71DBEA;
    // Curated bright outlines against black; text never inherits a phase color.
    var PALETTE as Array<Number> = [0x71DBEA, 0xA9A0FF, 0x78E4B3, 0xC2B7DB,
        0x66B8FF, 0xFFD67A, 0xFFABAC, 0xF4F7FA];
    var THEMES as Array<Array<Number>> = [[0, 1, 2, 3, 0], [4, 0, 2, 4, 0],
        [4, 5, 2, 3, 5], [7, 7, 7, 7, 7], [0, 5, 2, 6, 7]];
}
