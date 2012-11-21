import XMonad hiding ((|||)) -- Hide default layout combination function |||
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.NoBorders
import XMonad.Layout.Grid
import XMonad.Layout.LimitWindows
import XMonad.Layout.Magnifier
import XMonad.Layout.Tabbed
import XMonad.Config.Gnome
import XMonad.Config.Desktop (desktopLayoutModifiers)
import XMonad.Hooks.ManageHelpers
import XMonad.Util.EZConfig
import XMonad.Layout.IM
import XMonad.Layout.Renamed
import Data.Ratio ((%))

nmaster = 1
delta = 3/100
sideRatio = 75/100
bottomRatio = 65/100

-- Wide layout
wideLayout = renamed [Replace "Wide"] $ Mirror $ Tall nmaster delta sideRatio

-- Simple grid layout
gridLayout = renamed [Replace "Grid"] $ Grid

-- Code layout (two windows on right), zoom on focus
codeLayout = renamed [Replace "Code"] $ limitWindows 3 $ magnifiercz' 2.9 $ Tall nmaster delta sideRatio

-- Mirrored code layout (two windows on bottom), zoom on focus
codeLayoutMirrored = renamed [Replace "MCode"] $ limitWindows 3 $ magnifiercz' 1.9 $ Mirror $ Tall nmaster delta bottomRatio

-- Tabbed layout
tabbedLayout = renamed [Replace "Tabbed"] $ simpleTabbed

-- IM Tabbed layout
imTabbedLayout = renamed [Replace "IMTabbed"] $ withIM (1%5) (ClassName "Empathy") simpleTabbed

-- Hook layouts together to a ring
customLayoutHook = gridLayout ||| wideLayout ||| tabbedLayout ||| imTabbedLayout ||| codeLayout ||| codeLayoutMirrored ||| Full

-- Test for window type SPLASH
isSplash = isInProperty "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_SPLASH"

-- Create custom managehook
customManageHook :: [ManageHook]
customManageHook = [
    className =? "Unity-2d-panel" --> doIgnore,
    className =? "Unity-2d-launcher" --> doFloat,
    isSplash --> doIgnore, -- Do not layout splashscreens such as Gnome Do
    title =? "Aspect" --> doIgnore, -- Ignore Aspect VST plugin
    title =? "Resound" --> doIgnore, -- Ignore Resound VST plugin
    title =? "Manifold" --> doIgnore, -- Ignore Manifold VST plugin
    title =? "Sequent" --> doIgnore, -- Ignore Sequent VST plugin
    title =? "Shift" --> doIgnore, -- Ignore Shift VST plugin
    isFullscreen --> doFullFloat, -- Full float on fullscreen windows
    title =? "VLC (XVideo output)" --> doFullFloat -- Full float on VLC windows
    ]

main = xmonad $ gnomeConfig {
    modMask = mod4Mask,
    focusFollowsMouse = False,
    layoutHook = smartBorders $ desktopLayoutModifiers customLayoutHook,
    manageHook = manageHook gnomeConfig <+> composeAll customManageHook
} `additionalKeysP` [
    -- Custom key bindings
    ("M-f", sendMessage $ JumpToLayout "Full"),
    ("M-g", sendMessage $ JumpToLayout "Grid"),
    ("M-w", sendMessage $ JumpToLayout "Wide"),
    ("M-x", sendMessage $ JumpToLayout "Tabbed"),
    ("M-a", sendMessage $ JumpToLayout "IMTabbed"),
    ("M-c", sendMessage $ JumpToLayout "Code"),
    ("M-z", sendMessage $ JumpToLayout "MCode")
    ]
