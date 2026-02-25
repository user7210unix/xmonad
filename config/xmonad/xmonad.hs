import XMonad
import XMonad.Util.EZConfig           (additionalKeysP)
import XMonad.Util.Run                (spawnPipe)
import XMonad.Util.SpawnOnce          (spawnOnce)
import XMonad.Hooks.DynamicLog        (dynamicLogWithPP, xmobarPP, xmobarColor,
                                       wrap, shorten, PP(..))
import XMonad.Hooks.ManageDocks       (avoidStruts, docks, manageDocks)
import XMonad.Hooks.EwmhDesktops      (ewmh, ewmhFullscreen)
import XMonad.Layout.Dwindle          (Dwindle(..), Direction2D(..), Chirality(..))
import XMonad.Layout.NoBorders        (smartBorders)
import XMonad.Layout.Spacing          (spacingRaw, Border(..))
import XMonad.Layout.ResizableTile    (ResizableTall(..), MirrorResize(..))
import XMonad.Layout.ToggleLayouts    (toggleLayouts, ToggleLayout(..))
import XMonad.Layout.Fullscreen       (fullscreenManageHook, fullscreenEventHook)
import XMonad.Actions.CycleWS         (nextWS, prevWS, shiftToNext, shiftToPrev)
import XMonad.Actions.WithAll         (killAll)
import System.IO                      (hPutStrLn)
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

colBg        = "#1a1a1a"
colBg2       = "#242424"
colBg3       = "#2e2e2e"
colFg        = "#c8c8c8"
colFgDim     = "#606060"
colAccent    = "#5f87af"
colAccent2   = "#87af5f"
colRed       = "#af5f5f"
colYellow    = "#af875f"
colBorder    = "#3a3a3a"
colBorderFoc = "#5f87af"

myTerminal = "alacritty"
myModMask  = mod4Mask

myBorderWidth :: Dimension
myBorderWidth = 2

myWorkspaces :: [String]
myWorkspaces = ["dev","web","sys","doc","irc","six","seven","eight","nine"]

myLayouts =
    avoidStruts
    . smartBorders
    . toggleLayouts Full
    $ dwindle ||| tall ||| Full
  where
    gap     = spacingRaw False (Border 4 4 4 4) True (Border 4 4 4 4) True
    dwindle = gap $ Dwindle R CW (3/2) (11/10)
    tall    = gap $ ResizableTall 1 (3/100) (1/2) []

myManageHook = manageDocks <+> fullscreenManageHook <+> composeAll
    [ className =? "Gimp"        --> doFloat
    , className =? "mpv"         --> doFloat
    , className =? "Pavucontrol" --> doFloat
    , className =? "Arandr"      --> doFloat
    , className =? "Firefox"     --> doShift "web"
    , className =? "Chromium"    --> doShift "web"
    , className =? "discord"     --> doShift "irc"
    ]

myStartupHook :: X ()
myStartupHook = do
    spawnOnce "picom --backend glx --vsync &"
    spawnOnce "dunst &"
    spawnOnce "xsetroot -cursor_name left_ptr"
    spawnOnce "xset r rate 200 50"

myKeys :: [(String, X ())]
myKeys =
    [ ("M-d",         spawn "rofi -show drun")
    , ("M-S-d",       spawn "rofi -show run")
    , ("M-<Tab>",     spawn "rofi -show window")
    , ("M-<Return>",  spawn myTerminal)
    , ("M-q",         kill)
    , ("M-S-q",       killAll)
    , ("M-S-r",       spawn "xmonad --recompile && xmonad --restart")
    , ("M-f",         sendMessage (Toggle "Full"))
    , ("M-a",         sendMessage MirrorShrink)
    , ("M-z",         sendMessage MirrorExpand)
    , ("M-.",         nextWS)
    , ("M-,",         prevWS)
    , ("M-S-.",       shiftToNext)
    , ("M-S-,",       shiftToPrev)
    , ("M-<Print>",   spawn "scrot ~/Screenshots/%Y-%m-%d-%H%M%S.png")
    , ("M-S-<Print>", spawn "scrot -s ~/Screenshots/%Y-%m-%d-%H%M%S.png")
    ]

myPP :: Handle -> PP
myPP h = xmobarPP
    { ppOutput          = hPutStrLn h
    , ppCurrent         = xmobarColor colAccent  colBg2 . wrap " [" "] "
    , ppVisible         = xmobarColor colFg      ""     . wrap " "  " "
    , ppHidden          = xmobarColor colFgDim   ""     . wrap " "  " "
    , ppHiddenNoWindows = xmobarColor colBg3     ""     . wrap " "  " "
    , ppUrgent          = xmobarColor colRed     ""     . wrap "!" "!"
    , ppTitle           = xmobarColor colAccent2 ""     . shorten 60
    , ppSep             = xmobarColor colFgDim   ""     "  |  "
    , ppLayout          = xmobarColor colYellow  ""
    }

main :: IO ()
main = do
    xmproc <- spawnPipe "xmobar ~/.config/xmobar/xmobarrc"
    xmonad
      . ewmhFullscreen
      . ewmh
      . docks
      $ def
          { terminal           = myTerminal
          , modMask            = myModMask
          , workspaces         = myWorkspaces
          , borderWidth        = myBorderWidth
          , normalBorderColor  = colBorder
          , focusedBorderColor = colBorderFoc
          , layoutHook         = myLayouts
          , manageHook         = myManageHook
          , startupHook        = myStartupHook
          , handleEventHook    = fullscreenEventHook
          , logHook            = dynamicLogWithPP (myPP xmproc)
          }
      `additionalKeysP` myKeys
