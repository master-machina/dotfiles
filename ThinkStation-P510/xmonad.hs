import Data.Map qualified as M
import Graphics.X11.ExtraTypes.XF86
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.IndependentScreens
import XMonad.Layout.Spacing
import XMonad.StackSet qualified as W
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

myWorkspaces = withScreens 2 ["1", "2", "3", "4", "5"]

myKeys conf@(XConfig {XMonad.modMask = modm}) =
  M.fromList $
    [ ((modm, xK_Return), spawn $ XMonad.terminal conf),
      ((modm, xK_space), sendMessage NextLayout),
      ((modm, xK_p), spawn "dmenu_run -f -m 0 -fn 'FiraCode Nerd Font-11' -nf '#bfbdb6' -nb '#0b0e14' -sf '#0b0e14' -sb '#bfbdb6'"),
      ((modm, xK_r), spawn "xmonad --recompile; xmonad --restart"),
      ((modm, xK_q), kill),
      ((modm, xK_j), windows W.focusDown),
      ((modm, xK_k), windows W.focusUp),
      ((modm, xK_m), windows W.focusMaster),
      ((modm, xK_h), sendMessage Shrink),
      ((modm, xK_l), sendMessage Expand),
      ((modm .|. shiftMask, xK_j), windows W.swapDown),
      ((modm .|. shiftMask, xK_k), windows W.swapUp),
      ((modm .|. shiftMask, xK_m), windows W.swapMaster),
      ((modm .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf),
      ((modm, xK_t), withFocused $ windows . W.sink),
      ((0, xF86XK_AudioMute), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle"),
      ((0, xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ -10%"),
      ((0, xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ +10%"),
      ((mod1Mask, xK_Shift_L), spawn "toggle-layout")
      -- ((mod1Mask, xK_Shift_L), spawn "setxkbmap us"),
      -- ((mod1Mask, xK_Shift_R), spawn "setxkbmap bg phonetic")
    ]
      ++ [((m .|. modm, k), windows $ onCurrentScreen f i) | (i, k) <- zip (workspaces' conf) [xK_1 .. xK_9], (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
      ++ [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f)) | (key, sc) <- zip [xK_w, xK_e] [0 ..], (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

myMouseBindings (XConfig {XMonad.modMask = modm}) =
  M.fromList $
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster)),
      ((modm, button2), (\w -> focus w >> windows W.shiftMaster)),
      ((modm, button3), (\w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster))
    ]

myLayoutHook = avoidStruts $ spacingWithEdge 4 (tiled ||| Full)
  where
    tiled = Tall nmaster delta ratio
    nmaster = 1
    ratio = 1 / 2
    delta = 1 / 100

myStartupHook = do
  spawnOnce "picom -b &"
  spawnOnce "xset s off &"
  spawnOnce "xset s 0 0 &"
  spawnOnce "xset -dpms &"
  spawnOnce "nitrogen --restore &"
  spawnOnce "xinput set-prop 13 344 1 &"
  spawnOnce "xinput set-prop 13 365 1 &"
  spawnOnce "setxkbmap -option ctrl:nocaps &"
  spawnOnce "xsetroot -cursor_name left_ptr &"
  spawnOnce "xrandr --output DisplayPort-0 --mode 2560x1440 --rate 144 &"
  spawnOnce "xrandr --output DisplayPort-1 --mode 2560x1440 --rate 144 &"

myLogHook xmproc0 xmproc1 =
  ( dynamicLogWithPP . filterOutWsPP ["1_1", "1_2", "1_3", "1_4", "1_5"] $
      xmobarPP
        { ppOutput = \x -> hPutStrLn xmproc0 x,
          ppCurrent = \(_ : _ : ws) -> "<box type=Bottom width=2 mb=2 color=#e6b450><fc=#e6b450> " ++ ws ++ " </fc></box>",
          ppVisible = \(_ : _ : ws) -> "<box type=Bottom width=2 mb=2 color=#bfbdb6><fc=#bfbdb6> " ++ ws ++ " </fc></box>",
          ppHidden = \(_ : _ : ws) -> "<box type=Bottom width=2 mb=2 color=#bfbdb6><fc=#bfbdb6> " ++ ws ++ " </fc></box>",
          ppHiddenNoWindows = \(_ : _ : ws) -> "<box type=Bottom width=2 mb=2 color=#bfbdb6><fc=#bfbdb6> " ++ ws ++ " </fc></box>",
          ppOrder = \(ws : _) -> [ws]
        }
  )
    >> ( dynamicLogWithPP . filterOutWsPP ["0_1", "0_2", "0_3", "0_4", "0_5"] $
           xmobarPP
             { ppOutput = \x -> hPutStrLn xmproc1 x,
               ppCurrent = \(_ : _ : ws) -> "<box type=Bottom width=2 mb=2 color=#e6b450><fc=#e6b450> " ++ ws ++ " </fc></box>",
               ppVisible = \(_ : _ : ws) -> "<box type=Bottom width=2 mb=2 color=#bfbdb6><fc=#bfbdb6> " ++ ws ++ " </fc></box>",
               ppHidden = \(_ : _ : ws) -> "<box type=Bottom width=2 mb=2 color=#bfbdb6><fc=#bfbdb6> " ++ ws ++ " </fc></box>",
               ppHiddenNoWindows = \(_ : _ : ws) -> "<box type=Bottom width=2 mb=2 color=#bfbdb6><fc=#bfbdb6> " ++ ws ++ " </fc></box>",
               ppOrder = \(ws : _) -> [ws]
             }
       )

main = do
  xmproc0 <- spawnPipe "xmobar -x 0 ~/.config/xmonad/xmobar.conf"
  xmproc1 <- spawnPipe "xmobar -x 1 ~/.config/xmonad/xmobar.conf"
  xmonad $
    docks
      def
        { modMask = mod4Mask,
          terminal = "alacritty",
          clickJustFocuses = True,
          focusFollowsMouse = False,
          workspaces = myWorkspaces,
          borderWidth = 2,
          normalBorderColor = "#11151c",
          focusedBorderColor = "#11151c",
          keys = myKeys,
          mouseBindings = myMouseBindings,
          layoutHook = myLayoutHook,
          logHook = myLogHook xmproc0 xmproc1,
          startupHook = myStartupHook
        }
