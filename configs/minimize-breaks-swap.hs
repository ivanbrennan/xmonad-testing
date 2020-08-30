import XMonad
import qualified XMonad.StackSet as W
import XMonad.Actions.Minimize
import XMonad.Layout.Minimize
import qualified Data.Map as M

main :: IO ()
main = xmonad def
  { layoutHook = minimize (layoutHook def),
    keys = const . M.fromList $
      [ ((mod4Mask, xK_o), spawn (terminal def)),
        ((mod4Mask, xK_minus), withFocused minimizeWindow),
        ((mod4Mask, xK_equal), withLastMinimized maximizeWindowAndFocus),
        ((mod4Mask .|. shiftMask, xK_Up), windows W.swapUp),
        ((mod4Mask .|. shiftMask, xK_Down), windows W.swapDown)
      ]
  }
