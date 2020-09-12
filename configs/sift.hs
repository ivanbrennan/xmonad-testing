import XMonad
import XMonad.Actions.Sift (siftUp, siftDown)
import qualified Data.Map as M

main :: IO ()
main = xmonad def
  { keys = const . M.fromList $
      [ ((mod4Mask, xK_o),    spawn (terminal def)),
        ((mod4Mask, xK_Up),   windows siftUp),
        ((mod4Mask, xK_Down), windows siftDown)
      ]
  }
