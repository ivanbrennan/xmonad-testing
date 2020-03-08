{-# LANGUAGE NamedFieldPuns #-}

import XMonad
    (IncMasterN(IncMasterN), Layout, X, XConfig(XConfig), borderWidth, clickJustFocuses, def, focusedBorderColor, io, keys,
     kill, layoutHook, manageHook, modMask, normalBorderColor, sendMessage, spawn, terminal, windows, workspaces, xmonad
    )
import XMonad.Actions.CycleWS (Direction1D(Next, Prev), WSType(NonEmptyWS), moveTo)
import XMonad.Hooks.DynamicLog (statusBar, xmobarColor, xmobarPP, ppCurrent, ppHidden, ppLayout, ppTitle, ppWsSep, wrap)
import XMonad.Hooks.ManageDocks (avoidStruts, manageDocks)
import XMonad.StackSet (focusDown, focusUp, focusMaster, shift, swapDown, swapUp, greedyView)
import Graphics.X11
    (KeyMask, KeySym, mod4Mask, noModMask, shiftMask, xK_1, xK_2, xK_b, xK_d, xK_j, xK_k, xK_m, xK_o, xK_x, xK_comma,
     xK_period, xK_Return
    )
import Data.Bits ((.|.))
import System.Exit (exitSuccess)

import qualified Data.Map as M


keys' :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
keys' conf@(XConfig {modMask}) = M.fromList $
    -- workspaces
    [ ((modMask,               xK_period), moveTo Next NonEmptyWS)
    , ((modMask,               xK_comma ), moveTo Prev NonEmptyWS)

    -- focus
    , ((modMask,               xK_j     ), windows focusDown)
    , ((modMask,               xK_k     ), windows focusUp  )
    , ((modMask,               xK_m     ), windows focusMaster)

    -- swap
    , ((modMask .|. shiftMask, xK_j     ), windows swapDown  )
    , ((modMask .|. shiftMask, xK_k     ), windows swapUp    )

    -- increment/decrement master area
    , ((modMask .|. shiftMask, xK_comma ), sendMessage (IncMasterN 1))
    , ((modMask .|. shiftMask, xK_period), sendMessage (IncMasterN (-1)))

    -- quit
    , ((modMask .|. shiftMask, xK_x     ), io exitSuccess)

    -- launch/kill
    , ((modMask .|. shiftMask, xK_o     ), spawn "alacritty --command env PS1='$ ' bash --norc")
    , ((modMask,               xK_Return), spawn "dmenu_run -fn monospace:size=12 -l 16 -i -nb '#1c1c1c' -nf '#a5adb7' -sb '#1f1f1f' -sf '#c8f5ff'")
    , ((modMask .|. shiftMask, xK_d     ), kill)
    ]
    ++
    -- mod-[1..2], Switch to workspace N
    -- mod-shift-[1..2], Move client to workspace N
    [ ((m .|. modMask, k), windows $ f i)
      | (i, k) <- zip (workspaces conf) [xK_1..xK_2]
      , (f, m) <- [(greedyView, noModMask), (shift, shiftMask)]
    ]


main :: IO ()
main =
    xmonad =<< statusBar "xmobar" barPP toggleStrutsKey config
  where
    config = def
        { layoutHook         = avoidStruts (layoutHook def)
        , manageHook         = manageDocks
        , modMask            = mod4Mask
        , terminal           = "alacritty"
        , clickJustFocuses   = False
        , normalBorderColor  = "#212121"
        , focusedBorderColor = "#506068"
        , borderWidth        = 2
        , keys               = keys'
        }

    barPP = xmobarPP
        { ppCurrent = xmobarColor "#dddddd" "#004466" . wrap " " " "
        , ppHidden  = xmobarColor "#888888" "#222222" . wrap " " " "
        , ppWsSep = ""
        , ppTitle = const ""
        , ppLayout = const ""
        }

    toggleStrutsKey XConfig {modMask} = (modMask .|. shiftMask, xK_b)
