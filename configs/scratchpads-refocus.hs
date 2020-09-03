import XMonad
import XMonad.Layout.SubLayouts (subLayout)
import qualified XMonad.Util.NamedScratchpad as NS
import qualified Data.Map as M

keys' = const . M.fromList $
  [ ((mod4Mask, xK_o), spawn (terminal def)),
    ((mod4Mask, xK_Shift_R), NS.namedScratchpadAction scratchpads "scratchpad")
  ]

scratchpads = [NS.NS name command (appName =? name) NS.defaultFloating]
  where
    name = "scratchpad"
    command = terminal def ++ " -name " ++ name

layoutHook' = subLayout [] tiled tiled
  where
    tiled = Tall 1 (3/100) (1/2)

main = xmonad def
  { keys = keys',
    manageHook = NS.namedScratchpadManageHook scratchpads,
    layoutHook = layoutHook'
  }
