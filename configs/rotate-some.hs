import XMonad
import XMonad.Actions.RotateSome (surfaceNext, surfacePrev)
import XMonad.Layout.LimitWindows (limitSelect)
import qualified Data.Map as M

main :: IO ()
main = xmonad def
  { layoutHook = limitSelect 1 2 (layoutHook def),
    keys = const . M.fromList $
      [ ((mod4Mask, xK_o), spawn (terminal def)),
        ((mod4Mask, xK_Down), surfaceNext),
        ((mod4Mask, xK_Up),   surfacePrev)
      ]
  }
