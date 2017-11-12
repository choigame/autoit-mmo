#include-once
#include 'Import.au3'

Opt("GUIOnEventMode", 1)

Global $guiLogin = GUICreate("Facebook", $widthGuiLogin , $heightGuiLogin)
GUISetHelp("notepad.exe") ; will run notepad if F1 is typed

_GuiSetFont(11, "Times")

GUICtrlCreateLabel("Email",5,13)
$inputEmailLogin = GUICtrlCreateInput($email, 45, 10, $widthGuiLogin - 50 , 25)

GUICtrlCreateLabel("***",5,43)
$inputPassLogin = GUICtrlCreateInput($pass, 45, 40, $widthGuiLogin - 50, 25, $ES_PASSWORD)

$buttonGetToken = GUICtrlCreateButton("Init Token", $widthGuiLogin - 80, 70, 75, 25)

GUICtrlSetOnEvent($buttonGetToken, "InitToken")
GUISetOnEvent($GUI_EVENT_CLOSE, "CloseApp")

; Display the GUI.
GUISetState(@SW_SHOW, $guiLogin)

While 1
	sleep(15)
WEnd
