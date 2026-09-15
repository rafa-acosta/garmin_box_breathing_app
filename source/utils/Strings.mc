import Toybox.Lang;
import Toybox.WatchUi;

module Strings {
    function get(id as ResourceId) as String { return WatchUi.loadResource(id) as String; }
    function phaseIds() as Array<ResourceId> { return [Rez.Strings.Inhale, Rez.Strings.HoldIn, Rez.Strings.Exhale, Rez.Strings.HoldOut]; }
    function themeIds() as Array<ResourceId> { return [Rez.Strings.Calm, Rez.Strings.Ocean, Rez.Strings.Focus, Rez.Strings.Minimal, Rez.Strings.HighContrast]; }
    function paletteIds() as Array<ResourceId> { return [Rez.Strings.Cyan, Rez.Strings.Lavender, Rez.Strings.Mint, Rez.Strings.Violet, Rez.Strings.Blue, Rez.Strings.Gold, Rez.Strings.Coral, Rez.Strings.White]; }
}
