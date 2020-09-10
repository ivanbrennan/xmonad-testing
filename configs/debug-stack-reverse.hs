import XMonad
import XMonad.Hooks.DebugStack (debugStack)
import qualified Data.Map as M

main :: IO ()
main = xmonad def
  { keys = const . M.fromList $
      [ ((mod4Mask, xK_o), spawn (terminal def)),
        ((mod4Mask, xK_equal), debugStack)
      ]
  }
