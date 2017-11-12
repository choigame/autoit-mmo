#include '..\lib\_HttpRequest.au3'
#include '..\lib\StringUtils.au3'
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <GUIConstants.au3>
#include <FontConstants.au3>
#include <..\lib\WinHttp.au3>
#include <Function.au3>
#include <Declare.au3>

Opt("GUIOnEventMode", 1)

$hGUI = GUICreate("Get Link Fshare", $widthGUI , $heightGUI)
GUISetHelp("notepad.exe") ; will run notepad if F1 is typed
GUISetFont(11,  "", "", "Times")

GUICtrlCreateLabel("Email",5,13)
$inputEmailLogin = GUICtrlCreateInput("dactandn6@gmail.com", 45, 10, $widthGUI - 50 , 25)

GUICtrlCreateLabel("*****",5,43)
$inputPassLogin = GUICtrlCreateInput("handoi", 45, 40, $widthGUI - 50, 25, $ES_PASSWORD)

$buttonLogin = GUICtrlCreateButton("Login", $widthGUI - 60, 70, 55, 25)

GUICtrlCreateLabel("Link",5,103)
$inputLink = GUICtrlCreateInput("https://www.fshare.vn/file/T9Q6Q9HTKT", 45, 100, $widthGUI - 50, 25)

$buttonGetLink = GUICtrlCreateButton("GetLink", $widthGUI - 60 , 130, 55, 25)
GUICtrlSetOnEvent($buttonLogin, "Login")
GUICtrlSetOnEvent($buttonGetLink, "GetLink")
GUISetOnEvent($GUI_EVENT_CLOSE, "CloseApp")
; Display the GUI.
GUISetState(@SW_SHOW, $hGUI)

While 1
	sleep(15)
WEnd
