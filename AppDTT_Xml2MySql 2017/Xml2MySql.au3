#NoTrayIcon
#include-once

#include <Array.au3>
#include <import\Other\utils.au3>
#include <import\GlobalVar.au3>
#include <import\Other\utilsGui.au3>
#include <import\Other\hover.au3>
#include <import\XMLFunc.au3>
#include <import\JSPFunc.au3>

Opt("GUIOnEventMode", 1) ; Change to OnEvent mode

HotKeySet("^a", "_selectall")
HotKeySet("{esc}", "CloseApp")

If (WinExists($TitleGui)) Then
	  WinActivate($TitleGui)
	  Exit
EndIf

Global $hMainGUI = GUICreate($TitleGui,$WidthGui, $HeightGui,-1,-1)

GUISetFont(10)
GUISetOnEvent($GUI_EVENT_CLOSE, "CloseApp")

GUISetState(@SW_SHOW, $hMainGUI)

Local $Lbl_MaxLengthVarcharInput =  GUICtrlCreateLabel("Max length varchar : ", 5,7)
Local $MaxLengthVarcharInput = _createRequiredInputText("",130, 5, $WidthGui/4,"",3)
GUICtrlSetData($MaxLengthVarcharInput,$MaxLengthVarchar)

Local $ChooseXMLFile = _createButtonWithCursor("XML File", $WidthGui - 85, 35, 80)
_GUICtrl_SetOnHover($ChooseXMLFile, "_Hover_Proc", "_Leave_Hover_Proc", "PrimaryDown_Proc", "PrimaryUp_Proc")
GUICtrlSetOnEvent( $ChooseXMLFile , "XMLAction")

Local $ChooseJSPFile = _createButtonWithCursor("JSP File", $WidthGui - 185, 35, 80)
_GUICtrl_SetOnHover($ChooseJSPFile, "_Hover_Proc", "_Leave_Hover_Proc", "PrimaryDown_Proc", "PrimaryUp_Proc")
GUICtrlSetOnEvent( $ChooseJSPFile , "JSPAction")

Local $Lbl_Result = _createSuccessLable( $WidthGui - 40,58,60,25)

While 1
    Sleep(37) ; Sleep to reduce CPU usage
WEnd

Func CloseApp()
   If (WinActive($TitleGui)) Then
		 $isYes = MsgBox($MB_OKCANCEL+262144+8192, "Thoát", "Đồng ý?")
		 if($isYes=1) then Exit
   EndIf
EndFunc   ;==>CloseApp
