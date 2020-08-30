import XMonad
import XMonad.Actions.Minimize
import XMonad.Layout.Minimize (Minimize, minimize)
import XMonad.Layout.LayoutModifier
import qualified Data.Map as M

myLayout :: ModifiedLayout
            Minimize
            (Choose Tall (Choose (Mirror Tall) Full))
            Window
myLayout = minimize $ layoutHook def

main :: IO ()
main = xmonad def
  { layoutHook = myLayout,
    keys = const . M.fromList $
      [ ((mod4Mask, xK_o), spawn (terminal def)),
        ((mod4Mask, xK_minus), withFocused minimizeWindow),
        ((mod4Mask, xK_equal), withLastMinimized maximizeWindowAndFocus)
      ]
  }
