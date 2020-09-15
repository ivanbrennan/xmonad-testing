import XMonad
import qualified XMonad.StackSet as W
import XMonad.Hooks.DynamicLog (statusBar', xmobarPP)
import qualified Data.Map as M

main :: IO ()
main = xmonad =<< statusBar' "xmobar" xpp toggleStrutsKey conf
  where
    xpp = return xmobarPP

    toggleStrutsKey = const (mod4Mask, xK_b)

    conf = def
      { keys = const . M.fromList $
          [ ((mod4Mask, xK_o), spawn (terminal def)) ]
          ++
          [ ((mod4Mask, k), windows $ W.greedyView i)
            | (i, k) <- zip (workspaces def) [xK_1 .. xK_9]
          ]
      }
