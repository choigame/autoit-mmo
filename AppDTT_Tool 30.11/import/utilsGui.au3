#include-once

#include <GUIEdit.au3>
#include <WinAPI.au3>
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <StaticConstants.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <GuiListView.au3>
#include <ListViewConstants.au3>
#include <GUIConstants.au3>
#include <GuiComboBox.au3>
#include "GUIScrollbars_Ex.au3"

Func _selectall()
    Local $hWnd = _WinAPI_GetFocus()
    _GUICtrlEdit_SetSel($hWnd, 0, -1)
    HotKeySet("^a")
    Send("^a")
    HotKeySet("^a", "_selectall")
 EndFunc   ;==>_selectall

Func _createButtonWithCursor($content,$x,$y,$w)
    $hand = GUICtrlCreateButton($content,$x,$y,$w,22)
	GUICtrlSetColor(-1,0xffffff)
	GUICtrlSetBkColor(-1,0x191919)
    GUICtrlSetCursor(-1, 0)  ; hand
	return $hand
EndFunc


Func _createLable($content,$x,$y,$color)
   GUICtrlCreateLabel($content,$x,$y)
   GUICtrlSetColor(-1,$color)
EndFunc

Func _createSuccessLable($x,$y,$w,$h)
   $hand = GUICtrlCreateLabel("",$x,$y,$w,$h)
   GUICtrlSetColor(-1,$MediumVioletRed)
   return $hand
EndFunc

Func _createRequiredInputText($content,$x,$y,$w,$placeholder,$limit = 95)
   $hand = GUICtrlCreateInput($content,$x,$y,$w,23)
   GUICtrlSetLimit(-1, $limit)
   if Not($placeholder="" or $placeholder=null) Then GUICtrlSendMsg(-1, $EM_SETCUEBANNER, False, $placeholder)
   _createLable("*",$x+$w+4,$y+7,$red)
   return $hand
EndFunc

Func isRequiredInputField($val,$message,$id)
   if $val="" then
	 ; MsgBox($MB_ICONERROR+262144+8192,"Error","Field "&$message&" required")
	  GUICtrlSetBkColor($id,$xanhLaChuoi)
	  _WinAPI_SetFocus(ControlGetHandle("", "", $id))
	  Return false
   EndIf
   GUICtrlSetBkColor($id,$white)
   Return true
EndFunc

Func _resetInputField($id)
   GUICtrlSetBkColor($id,$white)
   GUICtrlSetData($id,"")
EndFunc


Func _GUICtrlCreateCombo($index0, $x, $y, $w, $h ,$color)
   Local  $handle =  GUICtrlCreateCombo($index0, $x,$y, $w, $h , BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL))
   DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($handle), "wstr", 0, "wstr", 0)
   GUICtrlSetBkColor($handle, $color)
   GUICtrlSetColor($handle, 0xFFFFFF)
   GUICtrlSetFont($handle,$fontSizeComboBox)
   return $handle
EndFunc

Func messageSelectCombo($message)
   MsgBox($MB_ICONERROR+262144+8192, $ErrorDiaglogTitle, "Choose "&$message&" ComboBox.")
EndFunc