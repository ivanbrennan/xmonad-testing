Config
  { font = "xft:monospace:size=11"
  , additionalFonts = [ "xft:FontAwesome:size=11" ]
  , bgColor = "#161616"
  , fgColor = "#a8b8b8"
  , position = Top
  , iconRoot = "/run/current-system/sw/share/icons/xmobar"
  , commands = [Run StdinReader]
  , sepChar = "%"
  , alignSep = "}{"
  , template = "%StdinReader% }{ "
  }
-- vim: filetype=haskell
