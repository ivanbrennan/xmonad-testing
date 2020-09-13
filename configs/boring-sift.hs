import XMonad
import qualified XMonad.Layout.BoringWindows as B
import qualified Data.Map as M

main :: IO ()
main = xmonad def
  { layoutHook = B.boringWindows (layoutHook def),
    keys = const . M.fromList $
      [ ((mod4Mask, xK_o), spawn (terminal def)),
        ((mod4Mask, xK_minus), B.markBoring),
        ((mod4Mask, xK_equal), B.clearBoring),
        ((mod4Mask, xK_Up),   B.siftUp),
        ((mod4Mask, xK_Down), B.siftDown)
      ]
  }
