import XMonad
-----------------------------------------
import System.IO
import System.Exit
------------------------------------------
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks                                                                  
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
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
import Data.List	(isPrefixOf, isInfixOf)
import Data.Map (fromList)
import XMonad.Actions.WindowGo
--------------------------------------------
import qualified XMonad.StackSet as W                                                                
import qualified Data.Map as M
---------------------------------------------

myModMask :: KeyMask
myTerminal      = "gnome-terminal"
--myTerminal	= "xterm"
myModMask       = mod4Mask --Win-icon key
myBorderWidth   = 2 
myManagementHooks :: [ManageHook]
myLogHook :: X ()
--handleEventHook = ewmhDesktopsEventHook
--logHook = ewmhDesktopsLogHook
-------------------------------------------------------------------------------------------------------------------------------------
myLogHook = fadeInactiveLogHook fadeAmount
  where
        --fadeAmount = 0.5
	fadeAmount = 0.95
myWorkspaces = ["1:main","2:web","3:code","4:remote","5:multi","6:train","7:ref", "8:media", "9:scripting"] -- ++ map show [7..9]
-- See more at: http://www.tonicebrian.com/2011/09/05/my-working-environment-with-xmonad/#sthash.naKWmCyr.dpuf
--------------------------
myManagementHooks =  
	[
               	resource =? "stalonetray" 			--> doIgnore,
		fmap ( "libreoffice" `isPrefixOf` ) className	--> doShift "5:multi",
		className=? "Google-chrome-stable" 		--> doShift "2:web",
		stringProperty "WM_WINDOW_ROLE" =? "pop-up" 	--> doCenterFloat,
		className =? "Firefox" 	--> doShift "2:web",
		fmap ("ManageEngine ServiceDesk Plus - Send Notification" `isPrefixOf`) title --> doCenterFloat,
		fmap ("ManageEngine ServiceDesk Plus - View Requester Details" `isPrefixOf`) title --> doCenterFloat,
		className=? "nxclient" 	--> doShift "4:remote",
		fmap ("NX" `isPrefixOf`) title --> doShift "4:remote",
		stringProperty "WM_WINDOW_ROLE" =? "LoginWidget"	--> doCenterFloat,
               	className=? "Remmina" 	--> doShift "4:remote",
		className =? "Vncviewer" --> doShift "4:remote",
		appName=? "VNC Viewer" --> doShift "4:remote",
               	className=? "P4v.bin" 	--> doShift "3:code",
               	className=? "banshee" 	--> doShift "5:multi",
		appName=? "manager.exe" --> doShift "6:train",
		appName=? "vdpau" 	--> doShift "8:media",
               	className=? "VLC" 	--> doShift "8:media",
		className =? "MPlayer"	--> doShift "8:media",
	       	stringProperty "WM_WINDOW_ROLE" =? "conversation" --> doCenterFloat,
		className=? "Pidgin"	--> doShift "1:main",
		--stringProperty "WM_WINDOW_ROLE" =? "conversation" --> doCenterFloat,
		resource =? "xcalc" 	--> doCenterFloat,
		className =? "Xmessage" --> doCenterFloat, 
		resource =? "Dialog" 	--> doCenterFloat,
		className =? "xpad" 	--> doCenterFloat,
	--	fmap ( "Skype" `isInfixOf` ) className          --> doCenterFloat <+> doShift "1:main",
		className=? "Skype"	--> doShift "1:main",
		stringProperty "WM_WINDOW_ROLE" =? "ConversationsWindow"	--> doCenterFloat <+> doShift "1:main",
		className =? "File Operation Progress"   	--> doFloat,
		fmap ("NetApp" `isPrefixOf`) title --> doShift "4:remote" <+> doCenterFloat
	]
------------------------------------------------------------
--myLayout = avoidStruts (tall ||| Mirror tall ||| Full)
  --where
    -- tall = ResizableTall nmaster delta ratio []
     --nmaster = 1
     --delta   = 3/100
     --ratio   = 1/2      
------------------------------------------------------------
myLayout = avoidStruts (
        Tall 1 (3/100) (1/2) |||
        Mirror (Tall 1 (3/100) (1/2)) |||
        tabbed shrinkText tabConfig |||
        spiral (6/7)) -- |||
------------------------------------------------------------
tabConfig = defaultTheme { 
	  activeBorderColor = "#7C7C7C"
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
--	, ((myModMask,                  xK_a),          spawn "google-chrome-stable")
--	, ((myModMask .|. shiftMask,    xK_a),          spawn "chromium")
	, ((myModMask,                  xK_b),          spawn "ebook-viewer")
	, ((myModMask, 			xK_c),		spawn "calibre")
	, ((myModMask .|. controlMask,  xK_c),          spawn "xchat")
	, ((myModMask .|. mod1Mask,	xK_c), 		spawn "xcalc")
	, ((myModMask,                  xK_d),          spawn "gimp") 
	, ((myModMask .|. controlMask,	xK_e),          spawn "evince")
	, ((myModMask,                  xK_f),          spawn "firefox")
        , ((myModMask .|. controlMask,  xK_f),          spawn "p4v")
	, ((myModMask,                  xK_g),          spawn "/usr/bin/smartgithg >& /dev/null")
	, ((myModMask,                  xK_i),          spawn "pidgin") 
	, ((myModMask,			xK_o),		spawn "libreoffice")
	, ((myModMask,			xK_s),		spawn "stardict")
	, ((myModMask .|. shiftMask,	xK_s),		spawn "skype")
--	, ((myModMask,                  xK_n),          spawn "java -jar /home/tduong/NetApp/oncommand_system_manager/SystemManager.jar &") 
	, ((myModMask .|. shiftMask,	xK_n),		spawn "nixnote")
	, ((myModMask,                  xK_q),          spawn "killall xpad shutter stalonetray xmobar nm-applet gnome-setting-daemon xautolock" >> restart "xmonad" True)
	, ((myModMask,                  xK_r),          spawn "remmina")
	, ((myModMask,                  xK_x),          spawn "nxclient")
        , ((myModMask .|. shiftMask,  	xK_r),          spawn "/usr/local/bin/vncviewer")
--	, ((myModMask .|. shiftMask,	xK_r),          spawn "/usr/bin/vnc-E4_6_3-x64_linux_viewer")
	, ((myModMask,                  xK_comma), 	sendMessage (IncMasterN 1))
	, ((myModMask,                  xK_period), 	sendMessage (IncMasterN (-1)))
 	, ((controlMask,		xK_Print),      spawn "/home/tduong/.xmonad/bin/select-sreenshot")
--	, ((0,                          xK_Print),      spawn "/home/tduong/.xmonad/bin/screenshot") 
      	, ((myModMask,                  xK_Print),      spawn "shutter -s")
        , ((0, 				xK_Print), 	spawn "shutter -f")
 	--Volume control
	-- Mute toggle
	, ((0 , xF86XK_AudioMute),                      spawn "amixer -q set Master toggle")
--	, ((0 , xF86XK_MicMute),			spawn "amixer -q set Master toggle")
	, ((0 , xF86XK_AudioLowerVolume),               spawn "amixer -q set Master 10%-")
	, ((0 , xF86XK_AudioRaiseVolume),               spawn "amixer -q set Master 10%+")
--	, ((0 , xF86XK_AudioLowerVolume),               spawn "amixer -c0 set Master on && amixer -c0 set Headphone on && amixer -c0 set Master 5%-")
--	, ((0 , xF86XK_AudioRaiseVolume),               spawn "amixer -c0 set Master on && amixer -c0 set Headphone on && amixer -c0 set Master 5%+")
--	, ((0 , xF86XK_AudioMute), 			spawn "amixer set Master toggle && amixer set Headphone toggle")
	-----------------------------
        , ((myModMask .|. controlMask,   xK_l),         spawn "xscreensaver-command -lock")
        , ((myModMask,                   xK_v),         spawn "virtualbox &")
        , ((myModMask .|.controlMask,    xK_v),         spawn "wine '/home/tduong/.wine/drive_c/Program Files (x86)/Visual CertExam Suite/manager.exe'")
        ]
--- Added more application "ipcalc, eog, scribus, inkscape, evince, foxitpdf, okular
-- The Main Config --
main = do
    spawn "ibus-daemon"
    spawn "xautolock"
    spawn "xpad"
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
	, handleEventHook = ewmhDesktopsEventHook <+> docksEventHook
        , logHook = myLogHook <+> ewmhDesktopsLogHook <+> dynamicLogWithPP xmobarPP
                { ppOutput = hPutStrLn xmproc
                , ppTitle = xmobarColor "blue" "" . shorten 50
                }
        , terminal      = myTerminal
        , modMask       = myModMask
        , borderWidth   = myBorderWidth
        , workspaces    = myWorkspaces
        , keys          = myKeys <+> keys defaultConfig
        , focusFollowsMouse = False
}
