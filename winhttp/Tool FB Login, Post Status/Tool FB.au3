#include '..\lib\_HttpRequest.au3'
#include '..\lib\StringUtils.au3'
#include 'Utils.au3'
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <GUIConstants.au3>
#include <FontConstants.au3>
#include <..\lib\WinHttp.au3>
#include <Function.au3>
#include <Declare.au3>


Opt("GUIOnEventMode", 1)

$hGUI = GUICreate("Login Facebook", $widthGUI , $heightGUI)
GUISetHelp("notepad.exe") ; will run notepad if F1 is typed
GUISetFont(11,  "", "", "Times")

GUICtrlCreateLabel("Email",5,13)
$inputEmailLogin = GUICtrlCreateInput("dactandn0@gmail.com", 45, 10, $widthGUI - 50 , 25)

GUICtrlCreateLabel("*****",5,43)
$inputPassLogin = GUICtrlCreateInput("doithay11", 45, 40, $widthGUI - 50, 25, $ES_PASSWORD)

$buttonLogin = GUICtrlCreateButton("Login", $widthGUI - 60, 70, 55, 25)
GUICtrlCreateLabel("Content",5,80)
$inputStatusContent = GUICtrlCreateInput("https://www.fshare.vn/file/T9Q6Q9HTKT", 5, 100, $widthGUI - 10, 25)
$comboPrivate = GUICtrlCreateCombo($PRIVATE_STATUS[0] , 5, 130 , 120)
GUICtrlSetData($comboPrivate, ArrayToString($PRIVATE_STATUS , 0 ), $PRIVATE_STATUS[0])


$buttonPostStatus = GUICtrlCreateButton("Post Status", $widthGUI - 110 , 130, 105, 25)

GUICtrlSetOnEvent($buttonLogin, "Login")
GUISetOnEvent($GUI_EVENT_CLOSE, "CloseApp")
GUICtrlSetOnEvent($buttonPostStatus, "PostStatus")
; Display the GUI.
GUISetState(@SW_SHOW, $hGUI)

While 1
	sleep(15)
WEnd
