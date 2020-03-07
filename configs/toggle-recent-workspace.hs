import XMonad
import XMonad.Actions.CycleRecentWS
import System.Exit (exitSuccess)

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

keys' conf = M.fromList $
    -- workspaces
    [ ((mod4Mask, xK_bracketright),
       cycleRecentWS [xK_Super_L] xK_bracketright xK_bracketleft
      )
    , ((mod4Mask .|. shiftMask, xK_bracketright),
       cycleRecentNonEmptyWS [xK_Super_L] xK_bracketright xK_bracketleft
      )
    , ((mod4Mask .|. controlMask, xK_bracketright),
       cycleWindowSets (recentWS (null . W.stack)) [xK_Super_L] xK_bracketright xK_bracketleft
      )
    , ((mod4Mask, xK_l),
       toggleRecentWS
      )
    , ((mod4Mask .|. shiftMask, xK_l),
       toggleRecentNonEmptyWS
      )
    , ((mod4Mask .|. controlMask, xK_l),
       toggleWindowSets $ recentWS (null . W.stack)
      )
    -- launch/kill
    , ((mod4Mask, xK_Return),
       spawn (terminal conf)
      )
    -- quit or restart
    , ((mod4Mask .|. shiftMask, xK_x),
       io exitSuccess
      )
    ]
    ++
    -- mod-[1..9], Switch to workspace N
    [ ((mod4Mask, k), windows $ W.greedyView i) | (i, k) <- zip (workspaces conf) [xK_1..xK_9] ]

main = xmonad $ def { keys = keys' }
