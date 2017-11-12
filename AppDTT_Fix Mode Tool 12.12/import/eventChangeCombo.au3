#include-once

Func _Combo_Changed()
    $changed = 1
 EndFunc  ;==>_Combo_Changed

Func _ComboID_Changed($i,$k)
    $comboIDChanged[$k][$i] = 1
 EndFunc  ;==>_ComboID_Changed


Func MY_WM_COMMAND($hWnd, $msg, $wParam, $lParam)
   Local $nNotifyCode = _HiWord($wParam)
   Local $nID = _LoWord($wParam)
   Local $hCtrl = $lParam
   Switch $nID
		   Case $formComboBox
			   Switch $nNotifyCode
				   Case $CBN_EDITUPDATE, $CBN_EDITCHANGE; when user types in new data
					   _Combo_Changed()
				   Case $CBN_EDITUPDATE; sent when the edit control portion of a combo box is about to display altered text.
				   ; This notification message is sent after the control has formatted the text,
				   ; but before it displays the text.
				   Case $CBN_SELCHANGE; item from drop down selected
					   _Combo_Changed()
			   EndSwitch
   EndSwitch

    Return $GUI_RUNDEFMSG
EndFunc  ;==>MY_WM_COMMAND


Func _HiWord($x)
    Return BitShift($x, 16)
EndFunc  ;==>_HiWord

Func _LoWord($x)
    Return BitAND($x, 0xFFFF)
 EndFunc  ;==>_LoWord
