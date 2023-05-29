import qualified Data.Map                     as M
import           Graphics.X11.ExtraTypes.XF86
import           XMonad
import           XMonad.Actions.SpawnOn
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.ManageDocks
import           XMonad.Layout.NoBorders
import           XMonad.Layout.Spacing
import           XMonad.Layout.ToggleLayouts
import qualified XMonad.StackSet              as W
import           XMonad.Util.Run
import           XMonad.Util.SpawnOnce

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((modm, xK_Return), spawn $ XMonad.terminal conf)
    , ((modm, xK_space), sendMessage NextLayout)
    , ((modm, xK_f), sendMessage (Toggle "Full"))
    , ((modm, xK_p), spawn "dmenu_run -fn 'JetBrainsMono Nerd Font-11' -nf '#BFBDB6' -nb '#0B0E14' -sf '#0B0E14' -sb '#e6b450'")
    , ((modm, xK_r), spawn "xmonad --recompile; xmonad --restart")
    , ((modm, xK_q), kill)
    , ((modm, xK_j), windows W.focusDown)
    , ((modm, xK_k), windows W.focusUp)
    , ((modm, xK_m), windows W.focusMaster)
    , ((modm, xK_h), sendMessage Shrink)
    , ((modm, xK_l), sendMessage Expand)
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )
    , ((modm .|. shiftMask,               xK_m), windows W.swapMaster)
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)
    , ((0, xF86XK_AudioMute), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
    , ((0, xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ -10%")
    , ((0, xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ +10%")
    , ((0, xF86XK_MonBrightnessUp), spawn "lux -a 10%")
    , ((0, xF86XK_MonBrightnessDown), spawn "lux -s 10%")
    , ((mod1Mask, xK_Shift_L), spawn "setxkbmap us")
    , ((mod1Mask, xK_Shift_R), spawn "setxkbmap bg phonetic")
    ]
    ++
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = toggleLayouts (noBorders Full) (avoidStruts $ spacingWithEdge 4 (tiled ||| Full))
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 1/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = mempty

  ------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty


main = do
  h <- spawnPipe "xmobar ~/.config/xmobar/xmobar.hs"
  xmonad $ docks def {
    modMask = mod4Mask,
    terminal = "alacritty",
    clickJustFocuses = True,
    focusFollowsMouse = False,
    workspaces         = ["1", "2", "3", "4", "5"],
    borderWidth        = 2,
    normalBorderColor  = "#BFBDB6",
    focusedBorderColor = "#e6b450",
    keys               = myKeys,
    mouseBindings      = myMouseBindings,
    layoutHook         = myLayout,
    manageHook         = manageSpawn <+> myManageHook,
    handleEventHook    = myEventHook,
    logHook            = dynamicLogWithPP $ xmobarPP {
        ppOutput = hPutStrLn h,
        ppCurrent = \(ws) -> "<box type=Bottom width=2 mb=2 color=#e6b450><fc=#e6b450> " ++ ws ++ " </fc></box>",
        ppHiddenNoWindows = \(ws) -> "<box type=Bottom width=2 mb=2 color=#BFBDB6><fc=#BFBDB6> " ++ ws ++ " </fc></box>",
        ppHidden = \(ws) -> "<box type=Bottom width=2 mb=2 color=#BFBDB6><fc=#BFBDB6> " ++ ws ++ " </fc></box>",
        ppVisible =  \(ws) -> "<box type=Bottom width=2 mb=2 color=#BFBDB6><fc=#BFBDB6> " ++ ws ++ " </fc></box>",
        ppTitle = \(t) -> if length t > 0 then "<box type=Bottom width=2 mb=2 color=#e6b450><fc=#e6b450> " ++ shorten 60 t ++ " </fc></box>" else t,
        ppSep = " ",
        ppOrder = \(ws:_:t) -> [ws] ++ t
        },
        startupHook = do
                        spawnOnce "picom &"
                        spawnOnce "xset s off &"
                        spawnOnce "xset s 0 0 &"
                        spawnOnce "xset -dpms &"
                        spawnOnce "nitrogen --restore &"
                        spawnOnce "xinput set-prop 13 345 1 &"
                        spawnOnce "xinput set-prop 13 366 1 &"
                        spawnOnce "setxkbmap -option ctrl:nocaps &"
                        spawnOnce "xsetroot -cursor_name left_ptr &"
    }
