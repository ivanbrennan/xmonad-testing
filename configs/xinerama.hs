import Control.Monad ((>=>))
import Data.List (intercalate)
import qualified Data.Map as M
import XMonad
import XMonad.Actions.CycleWS (Direction1D (Next, Prev), WSType (WSIs), moveTo)
import XMonad.Actions.WorkspaceNames (renameWorkspace, workspaceNamesPP)
import XMonad.Hooks.DynamicBars (dynStatusBarEventHook, dynStatusBarStartup, multiPPFormat)
import XMonad.Hooks.DynamicLog (dynamicLogString, ppCurrent, ppHidden, ppLayout, ppSep, ppTitle, ppWsSep, wrap, xmobarColor, xmobarPP)
import XMonad.Hooks.ManageDocks (avoidStruts, docks)
import XMonad.Layout.IndependentScreens (marshallPP, onCurrentScreen, unmarshallS, withScreens, workspaces')
import qualified XMonad.StackSet as W
import XMonad.Util.NamedScratchpad (namedScratchpadFilterOutWorkspace)
import XMonad.Util.Run (spawnPipe)

startupHook' = dynStatusBarStartup xmobar' (pure ())

xmobar' s@(S i) = spawnPipe $
  unwords
    [ "xmobar",
      "-f", "xft:monospace:size=11",
      "-N", "xft:FontAwesome:size=11",
      "-x", show i,
      "-t", quote' (xmobarTemplate s),
      "-c", quote' $ list (xmobarCommands s)
    ]

xmobarTemplate (S 0) = "%StdinReader% }{ %alsa:default:Master% "
xmobarTemplate (S _) = "%StdinReader% }{ "

xmobarCommands (S i) = map unwords $
  if i == 0
    then [stdinReader, volume]
    else [stdinReader]
  where
    stdinReader = ["Run StdinReader"]

    volume =
      ["Run Alsa", quote "default", quote "Master", list (map quote volumeArgs)]

    volumeArgs =
      [ "--template", "<status>",
        "--",
        "--on" , "<fn=1>\xf026</fn><volume>",
        "--off", "<fn=1>\xf026</fn><volume>"
      ]

list :: [String] -> String
list xs = "[" ++ intercalate "," xs ++ "]"

quote :: String -> String
quote = wrap "\"" "\""

quote' :: String -> String
quote' = wrap "'" "'"

logHook' = multiPP' barPP barPP
  where
    multiPP' = multiPPFormat (withCurrentScreen . logString)

    logString pp =
      (workspaceNamesPP >=> dynamicLogString) . flip marshallPP pp

    barPP =
      xmobarPP
        { ppCurrent = xmobarColor "#dddddd" "#004466" . wrap " " " ",
          ppHidden  = xmobarColor "#888888" "#222222" . wrap " " " ",
          ppSep     = " ",
          ppWsSep   = "",
          ppTitle   = const "",
          ppLayout  = const ""
        }

withCurrentScreen f = withWindowSet (f . W.screen . W.current)

isOnScreen :: ScreenId -> WindowSpace -> Bool
isOnScreen s ws =
  case namedScratchpadFilterOutWorkspace [ws] of
    [] -> False
    x:_ -> s == unmarshallS (W.tag x)

currentScreen :: X ScreenId
currentScreen = withWindowSet (pure . W.screen . W.current)

screenWS :: WSType
screenWS = WSIs $ do
  sc <- currentScreen
  pure $
    and
      . (<*>)
        [ (not . null . namedScratchpadFilterOutWorkspace . pure),
          (not . null . W.stack),
          isOnScreen sc
        ]
      . pure

keys' conf = M.fromList $
  [ ((mod4Mask, xK_o), spawn (terminal conf)),
    ((mod4Mask, xK_equal), renameWorkspace def),
    ((mod4Mask, xK_period), moveTo Next screenWS),
    ((mod4Mask, xK_comma), moveTo Prev screenWS)
  ]
  ++
  [ ((mod4Mask, k), windows $ onCurrentScreen W.view i)
    | (i, k) <- zip (workspaces' conf) [xK_1 .. xK_9]
  ]
  ++
  [ ( (m .|. controlMask .|. mod1Mask, key),
      screenWorkspace sc >>= flip whenJust (windows . f)
    )
    | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..],
      (f, m) <- [(W.view, noModMask), (W.shift, shiftMask)]
  ]

main :: IO ()
main = xmonad xconfig
  where
    nScreens = 2 -- bin/run-in-xephyr.sh -s 2

    xconfig =
      docks $
        def
          { layoutHook = avoidStruts (layoutHook def),
            handleEventHook = dynStatusBarEventHook xmobar' (pure ()),
            logHook = logHook',
            startupHook = startupHook',
            workspaces = withScreens nScreens (workspaces def),
            keys = keys'
          }
