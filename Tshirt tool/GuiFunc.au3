
Func _selectall()
    Local $hWnd = _WinAPI_GetFocus()
    Switch $hWnd
        Case 0

        Case $divHandle , $descHandle
            _GUICtrlEdit_SetSel($hWnd, 0, -1)
            Return
    EndSwitch
    HotKeySet("^a")
    Send("^a")
    HotKeySet("^a", "_selectall")
 EndFunc   ;==>_selectall

 Func WM_COMMAND($hWnd, $msg, $wParam, $lParam)
    Local $nNotifyCode = BitShift($wParam, 16)
    Local $nID = BitAND($wParam, 0x0000FFFF)
    If $nID = $descCamp Then  ;the input control
        If $nNotifyCode = $EN_UPDATE Then
            If StringRight(GUICtrlRead($descCamp),2) = @CRLF Then
                ;delete the return (also prevents the edit box from scrolling)
                Send("{BS}")
                ;Do something like move to the next control in zorder.
                Send("{TAB}")
            EndIf
        EndIf
    EndIf
    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND

 Func _createButtonWithCursor($content,$x,$y,$w)
    $hand = GUICtrlCreateButton($content,$x,$y,$w,22)
	GUICtrlSetColor(-1,0xffffff)
	GUICtrlSetBkColor(-1,0x191919)
    GUICtrlSetCursor(-1, 0)  ; hand
	return $hand
 EndFunc

Func _createComboBoxWithCursor($index0, $x, $y, $w, $h)
   Local  $handle =  GUICtrlCreateCombo($index0, $x,$y, $w, $h , BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL))
    GUICtrlSetCursor(-1, 0)  ; hand
   DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($handle), "wstr", 0, "wstr", 0)
  ; GUICtrlSetBkColor($handle, $color)
 ;  GUICtrlSetColor($handle, 0xFFFFFF)
   GUICtrlSetFont($handle,0.5)
   return $handle
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

Func _createRequiredInputPass($content,$x,$y,$w,$placeholder,$limit = 20)
   $hand = GUICtrlCreateInput($content,$x,$y,$w,23,$ES_PASSWORD)
   GUICtrlSetLimit(-1, $limit)
   if Not($placeholder="" or $placeholder=null) Then GUICtrlSendMsg(-1, $EM_SETCUEBANNER, False, $placeholder)
   _createLable("*",$x+$w+4,$y+7,$red)
   return $hand
EndFunc

Func _createRequiredEdit($content,$x,$y,$w,$h,$limit = 95)
   $hand = GUICtrlCreateEdit($content,$x,$y,$w,$h,$ES_AUTOVSCROLL + $WS_VSCROLL )
   GUICtrlSetLimit(-1, $limit)
   _createLable("*",$x+$w+4,$y+7,$red)
   return $hand
EndFunc

Func _createCheckbox($content,$x,$y,$w,$h=23)
   $hand = GUICtrlCreateCheckbox($content,$x,$y,$w,$h)
   GUICtrlSetCursor(-1, 0)  ; hand
   return $hand
EndFunc
