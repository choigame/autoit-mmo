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

$hGUI = GUICreate("Get Commnent FB", $widthGUI , $heightGUI)
GUISetHelp("notepad.exe") ; will run notepad if F1 is typed
GUISetFont(11,  "", "", "Times")

GUICtrlCreateLabel("Token",5,13)
$inputToken = GUICtrlCreateInput($TOKEN, 55, 10, $widthGUI - 60 , 25)

GUICtrlCreateLabel("Post ID",5,43)
$inputPostId = GUICtrlCreateInput($POST_ID, 55, 40, $widthGUI - 60, 25)

$action = GUICtrlCreateButton("Action", $widthGUI - 60, 70, 55, 25)

GUICtrlSetOnEvent($action, "Action")
GUISetOnEvent($GUI_EVENT_CLOSE, "CloseApp")
; Display the GUI.
GUISetState(@SW_SHOW, $hGUI)

While 1
	sleep(15)
WEnd
