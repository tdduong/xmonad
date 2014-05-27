import XMonad
--------------------------
import System.IO
import System.Exit
--------------------------
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks                                                                  
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog
-----------------------------------------
import XMonad.Layout.ResizableTile
import XMonad.Layout.NoBorders
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Tabbed
import XMonad.Layout.IM
import XMonad.Layout.Fullscreen
import XMonad.Layout.Spiral
import XMonad.Layout.Grid  
-----------------------------------------
import Graphics.X11.Xlib
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.XMonad
import XMonad.Util.EZConfig(additionalKeys)
import Graphics.X11.ExtraTypes.XF86
import XMonad.Util.Run(spawnPipe)
--------------------------------------------
import Data.List
import Data.Map (fromList)
import XMonad.Actions.WindowGo
--------------------------------------------
import qualified XMonad.StackSet as W                                                                
import qualified Data.Map as M

-- Manual adding modules @ ~/.xmonad/lib/XMonad
------------------------------------
myModMask :: KeyMask
myTerminal      = "gnome-terminal"
--myTerminal	= "xterm"
myModMask       = mod4Mask --Win-icon key
myBorderWidth   = 2 
myManagementHooks :: [ManageHook]
myLogHook :: X ()
-------------------------------------------------------------------------------------------------------------------------------------
myLogHook = fadeInactiveLogHook fadeAmount
  where
        fadeAmount = 0.5
myWorkspaces = ["1:main","2:web","3:code","4:dev","5:multi"] ++ map show [6..7]
-- - See more at: http://www.tonicebrian.com/2011/09/05/my-working-environment-with-xmonad/#sthash.naKWmCyr.dpuf
--------------------------
myManagementHooks =  
	[
               	resource =? "stalonetray" --> doIgnore,
		className=? "Google-chrome-stable" --> doShift "2:web",
		stringProperty "WM_WINDOW_ROLE" =? "pop-up" --> doCenterFloat,
		(className =? "Firefox" <&&> title =? "ManageEngine ServiceDesk Plus - View Requester Details - Mozilla Firefox") -->  doCenterFloat,
	--	stringProperty "WM_WINDOW_ROLE" =? "browser" --> doCenterFloat,
		className =? "Firefox" --> doShift "2:web",
		className=? "nxclient" --> doShift "4:dev",
               	className=? "Remmina" --> doShift "4:dev",
               	className=? "P4v.bin" --> doShift "3:code",
               	className=? "banshee" --> doShift "5:multi",
               	className=? "VLC" --> doShift "5:multi",
	       	className=? "Pidgin" --> doShift "1:main",
		resource =? "xcalc" --> doCenterFloat,
		className =? "Xmessage" --> doCenterFloat, 
		resource =? "Dialog" --> doCenterFloat,
		className =? "File Operation Progress"   --> doFloat
	]
--Main config
main = do
    spawn "ibus-daemon"
    spawn "xautolock"
    spawn "gnome-settings-daemon"
    spawn "xcompmgr -c"
    spawn "nm-applet --sm-disable"
    spawn "stalonetray"
    spawn "feh --bg-scale ~/.wallpapers/desktop.jpg"
    spawn "/opt/dropbox/dropbox &"
    xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmonad/xmobarrc"
    xmonad $ defaultConfig { 
	manageHook = manageDocks <+> manageHook defaultConfig <+> composeAll myManagementHooks 
        , layoutHook = avoidStruts  $ smartBorders $ myLayout 
        , logHook = myLogHook <+> dynamicLogWithPP xmobarPP
                { ppOutput = hPutStrLn xmproc
                , ppTitle = xmobarColor "blue" "" . shorten 50
                }
        , terminal    	= myTerminal
        , modMask     	= myModMask
        , borderWidth 	= myBorderWidth
        , workspaces 	= myWorkspaces
        , keys 		= myKeys <+> keys defaultConfig
        , focusFollowsMouse = False
  }
	
--myLayout = tiled ||| Mirror tiled ||| Full 
--      where 
--       	-- tiled = Tall 1 (3/100) (3/5)
--	-- big master
--	   tiled = Tall 1 (3/100) (7/11)
myLayout = avoidStruts (
    	Tall 1 (3/100) (1/2) |||
   	Mirror (Tall 1 (3/100) (1/2)) |||
    	tabbed shrinkText tabConfig |||
	--tabbed |||
    	Full |||
    	spiral (6/7)) -- |||
	--Full
    --noBorders (fullscreenFull Full)
------------------------------------------------------------
tabConfig = defaultTheme 
	{ activeBorderColor = "#7C7C7C"
	, activeTextColor = "#EE9A00"
	, activeColor = "#222222"
	, inactiveBorderColor = "#7C7C7C"
	, inactiveTextColor = "#bbbbbb"
	, inactiveColor = "#222222"
		}
-- Binding keys setting
myKeys conf@(XConfig {XMonad.modMask = myModMask}) = M.fromList
        [ ((myModMask, xK_F12), 	xmonadPrompt 	defaultXPConfig)
        , ((myModMask, xK_F3 ), 	shellPrompt  	defaultXPConfig)
	, ((myModMask,            	xK_n), 		spawn "nautilus")
	, ((myModMask, 			xK_c ),		spawn "calibre")
	, ((myModMask .|. controlMask,  xK_c),          spawn "xchat")
	, ((myModMask .|. controlMask,	xK_e),          spawn "evince")
	, ((myModMask,  	        xK_x), 		spawn "nxclient")
	, ((myModMask,			xK_o),		spawn "google-chrome-stable")
	, ((myModMask,			xK_s),		spawn "stardict")
	, ((myModMask,			xK_i), 		spawn "pidgin")
        , ((myModMask,                  xK_r),          spawn "remmina")
        , ((myModMask,                  xK_f),          spawn "p4v")
	, ((myModMask,                  xK_comma), 	sendMessage (IncMasterN 1))
	, ((myModMask,                  xK_period), 	sendMessage (IncMasterN (-1)))
        , ((myModMask,                  xK_b),          spawn "ebook-viewer")
	, ((myModMask,                  xK_Print),      spawn "/home/tduong/.xmonad/bin/select-sreenshot")
	, ((0,                          xK_Print),      spawn "/home/tduong/.xmonad/bin/screenshot") 
        --, ((myModMask,                  xK_Print),      spawn "shutter -s")
	--, ((myModMask,	 		xK_Print), 	spawn "sleep 0.2; scrot -s")
	--, ((0, 				xK_Print), 	spawn "scrot")	
      --  , ((0, 				xK_Print), 	spawn "shutter -f")
        , ((myModMask,                  xK_g),          spawn "/opt/smartgit/bin/smartgit")
        , ((myModMask,                  xK_q),          spawn "killall stalonetray xmobar nm-applet gnome-setting-daemon xautolock" >> restart "xmonad" True)
 	--Volume control
	, ((0 , xF86XK_AudioLowerVolume),               spawn "amixer -c0 set Master on && amixer -c0 set Headphone on && amixer -c0 set Master 5%-")
	, ((0 , xF86XK_AudioRaiseVolume),               spawn "amixer -c0 set Master on && amixer -c0 set Headphone on && amixer -c0 set Master 5%+")
	, ((0 , xF86XK_AudioMute), 			spawn "amixer set Master toggle && amixer set Headphone toggle")
	-----------------------------
        , ((myModMask .|. controlMask,   xK_l),          spawn "xscreensaver-command -lock")
        , ((myModMask,                   xK_v),          spawn "/opt/cisco/anyconnect/bin/vpnui &")
        , ((myModMask .|.controlMask,    xK_v),         spawn "wine '/home/tduong/.wine/drive_c/Program Files (x86)/Visual CertExam Suite/manager.exe'")
        ]
--- Added more application "ipcalc, eog, scribus, inkscape, evince,
