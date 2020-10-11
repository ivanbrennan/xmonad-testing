import XMonad
import XMonad.Hooks.DynamicLog (statusBar', xmobarPP)
import XMonad.Hooks.EwmhDesktops (ewmh)
import qualified XMonad.StackSet as W
import qualified Data.Map as M

main :: IO ()
main = do
  xmonad =<< statusBar' xmobar pp toggleKey xconfig
  where
    xmobar =
      unwords
        [ "xmobar",
          "-t", "'%UnsafeStdinReader% }{ '",
          "-c", "'[Run UnsafeStdinReader]'"
        ]

    pp = pure xmobarPP

    toggleKey = const (mod4Mask, xK_b)

    xconfig = ewmh def {keys = keys'}

    keys' conf = M.fromList $
      [((mod4Mask, xK_o), spawn (terminal conf))]
      ++
      [ ((mod4Mask, k), windows $ W.greedyView i)
        | (i, k) <- zip (workspaces conf) [xK_1 .. xK_9]
      ]
