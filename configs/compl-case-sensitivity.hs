import XMonad
import XMonad.Layout.WorkspaceDir (changeDir', workspaceDir)
import XMonad.Prompt (ComplCaseSensitivity (ComplCaseSensitive))
import qualified XMonad.StackSet as W
import qualified Data.Map as M

main :: IO ()
main = xmonad def
  { layoutHook = workspaceDir "~" (layoutHook def),
    keys = const . M.fromList $
      [ ((mod4Mask, xK_o), spawn (terminal def)),
        ((mod4Mask, xK_equal), changeDir' (ComplCaseSensitive False) def)
      ]
      ++
      [ ((mod4Mask, k), windows $ W.greedyView i)
        | (i, k) <- zip (workspaces def) [xK_1 .. xK_9]
      ]
  }
