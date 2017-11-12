#include-once

;_GUICtrl_SetOnHover Global Variables
Global $aHOVER_CONTROLS_ARRAY[1][1]
Global $aLAST_HOVERED_ELEMENT[2] 	= [-1, -1]
Global $aLAST_HOVERED_ELEMENT_MARK 	= -1
Global $hLAST_CLICKED_ELEMENT_MARK 	= -1
Global $pTimerProc 					= 0
Global $uiTimer 					= 0

#Region =================== UDF Info ===================
; UDF Name:    _GUICtrl_SetOnHover
; Forum link:  http://www.autoitscript.com/forum/index.php?s=&showtopic=55120
; Author:      G.Sandler a.k.a MrCreatoR (CreatoR's Lab, http://creator-lab.ucoz.ru)
;
; 
; {Version History}:
; [v1.5]
; + Added AutoIt 3.2.10.0+ support, but 3.2.8.1 or less is dropped :( (due to lack of native CallBack functions).
; + Added Primary Down and Primary Up support. Helping to handle with the buttons pressing.
; + Added new arguments to calling function...
;      The OnHover function now can recieve two more arguments:
;                                        $iHoverMode - Defines the hover mode (1 - Hover, 2 - Leaves Hovering)
;                                        $hWnd_Hovered - Control Handle where the mouse is moved to (after hovering).
;
; * Almost all code of this UDF was rewritted.
; * Now the main function name is _GUICtrl_SetOnHover(),
;    but for backwards compatibility reasons, other (old) function names are still supported.
; * Fixed bug with hovering controls in other apps.
; * Improvements in generaly, the UDF working more stable now.
;
; [v1.?]
; * Beta changes, see "Forum link" for more details.
;
; [v1.0]
; * First release.
#EndRegion =================== UDF Info ===================
;

;===============================================================================
;
; Function Name:    _GUICtrl_SetOnHover()
; Description:      Set function(s) to call when hovering/leave hovering GUI elements.
;
; Parameter(s):     $iCtrlID              - The Ctrl ID to set hovering for (can be a -1 as indication to the last item created).
;
;                   $sHover_FuncName      - [Optional] Function to call when the mouse is hovering the control.
;                                             If this parameter passed as empty string (""),
;                                             then the specified CtrlID is UnSet from Hovering Handler list.
;
;                   $sLeaveHover_FuncName - [Optional] Function to call when the mouse is leaving hovering the control
;                       (-1 no function used).
;                     * For both parameters, $sHover_FuncName and $sLeaveHover_FuncName,
;                       the specified function called with maximum 3 parameters:
;                                                     $iCtrlID      - CtrlID of hovered control.
;                                                     $iHoverMode   - Defines the hover mode (1 - Hover, 2 - Leaves Hovering)
;                                                     $hWnd_Hovered - Control Handle where the mouse is moved to (after hovering).
;
;                   $sPrimDwnFuncName     - [Optional] Function to call when Primary mouse button is *clicked* on the control.
;                       (-1 -> function is not called).
;
;                   $sPrimUpFuncName      - [Optional] Function to call when Primary mouse button is *released* the control.
;                       (-1 -> function is not called).
;
;                   $iKeepCallFnc         - [Optional] If this parameter < 1,
;                                            then the $sPrimDwnFuncName function will *Not* be called constantly untill
;                                            the primary mouse button is released (default behaviour, $iKeepCallFunc = 1).
;
; Return Value(s):  Always returns 1 regardless of success.
;
; Requirement(s):   AutoIt 3.2.10.0 +
;
; Note(s):          1) TreeView/ListView Items can not be set :(.
;                   2) When the window is not active, the hover/leave hover functions will still called,
;                      but not when the window is disabled.
;                   3) The hover/leave hover functions will be called even if the script is paused by such functions as MsgBox().
;                   4) It is not recommended to block the HoverFunc by calling functions like Sleep() or MsgBox().
;
; Author(s):        G.Sandler (a.k.a CreatoR).
;
;===============================================================================
Func _GUICtrl_SetOnHover($iCtrlID,$sHover_Func="",$sLeaveHover_Func=-1,$sPrimaryDownFunc=-1,$sPrimaryUpFunc=-1,$iKeepCallFunc=1)
	Local $hCtrlID = GUICtrlGetHandle($iCtrlID)
	
	If $pTimerProc = 0 Then
		$pTimerProc = DllCallbackRegister("__MAIN_CALLBACK_ONHOVER_PROC", "none", "hwnd;int;int;dword")
		
		$uiTimer = DllCall("user32.dll", "int", "SetTimer", "hwnd", 0, _
			"int", TimerInit(), "int", 10, "ptr", DllCallbackGetPtr($pTimerProc))
		
		If IsArray($uiTimer) Then $uiTimer = $uiTimer[0]
	EndIf
	
	;UnSet Hovering for specified control (remove control id from hovering checking process)
	If $sHover_Func = "" Then
		Local $aHOVER_CONTROLS_Tmp[1][1]
		
		For $i = 1 To $aHOVER_CONTROLS_ARRAY[0][0]
			If $hCtrlID <> $aHOVER_CONTROLS_ARRAY[$i][0] Then
				$aHOVER_CONTROLS_Tmp[0][0] += 1
				ReDim $aHOVER_CONTROLS_Tmp[$aHOVER_CONTROLS_Tmp[0][0]+1][6]
				
				$aHOVER_CONTROLS_Tmp[$aHOVER_CONTROLS_Tmp[0][0]][0] = $aHOVER_CONTROLS_ARRAY[$i][0]
				$aHOVER_CONTROLS_Tmp[$aHOVER_CONTROLS_Tmp[0][0]][1] = $aHOVER_CONTROLS_ARRAY[$i][1]
				$aHOVER_CONTROLS_Tmp[$aHOVER_CONTROLS_Tmp[0][0]][2] = $aHOVER_CONTROLS_ARRAY[$i][2]
				$aHOVER_CONTROLS_Tmp[$aHOVER_CONTROLS_Tmp[0][0]][3] = $aHOVER_CONTROLS_ARRAY[$i][3]
				$aHOVER_CONTROLS_Tmp[$aHOVER_CONTROLS_Tmp[0][0]][4] = $aHOVER_CONTROLS_ARRAY[$i][4]
				$aHOVER_CONTROLS_Tmp[$aHOVER_CONTROLS_Tmp[0][0]][5] = $aHOVER_CONTROLS_ARRAY[$i][5]
			EndIf
		Next
		
		If $aHOVER_CONTROLS_Tmp[0][0] < 1 Then
			OnAutoItExit() ;Release the callbacks
		Else
			$aHOVER_CONTROLS_ARRAY = $aHOVER_CONTROLS_Tmp
		EndIf
		
		Return 1
	EndIf
	
	;Check if the hovering process already handle the passed CtrlID, if so, just assign new values (functions)
	For $i = 1 To $aHOVER_CONTROLS_ARRAY[0][0]
		If $hCtrlID = $aHOVER_CONTROLS_ARRAY[$i][0] Then
			$aHOVER_CONTROLS_ARRAY[$i][0] = $hCtrlID
			$aHOVER_CONTROLS_ARRAY[$i][1] = $sHover_Func
			$aHOVER_CONTROLS_ARRAY[$i][2] = $sLeaveHover_Func
			$aHOVER_CONTROLS_ARRAY[$i][3] = $sPrimaryDownFunc
			$aHOVER_CONTROLS_ARRAY[$i][4] = $sPrimaryUpFunc
			$aHOVER_CONTROLS_ARRAY[$i][5] = $iKeepCallFunc
			
			Return 1
		EndIf
	Next
	
	$aHOVER_CONTROLS_ARRAY[0][0] += 1
	ReDim $aHOVER_CONTROLS_ARRAY[$aHOVER_CONTROLS_ARRAY[0][0]+1][6]
	
	$aHOVER_CONTROLS_ARRAY[$aHOVER_CONTROLS_ARRAY[0][0]][0] = $hCtrlID
	$aHOVER_CONTROLS_ARRAY[$aHOVER_CONTROLS_ARRAY[0][0]][1] = $sHover_Func
	$aHOVER_CONTROLS_ARRAY[$aHOVER_CONTROLS_ARRAY[0][0]][2] = $sLeaveHover_Func
	$aHOVER_CONTROLS_ARRAY[$aHOVER_CONTROLS_ARRAY[0][0]][3] = $sPrimaryDownFunc
	$aHOVER_CONTROLS_ARRAY[$aHOVER_CONTROLS_ARRAY[0][0]][4] = $sPrimaryUpFunc
	$aHOVER_CONTROLS_ARRAY[$aHOVER_CONTROLS_ARRAY[0][0]][5] = $iKeepCallFunc
	
	Return 1
EndFunc

;CallBack function to handle the hovering process
Func __MAIN_CALLBACK_ONHOVER_PROC($hWnd, $uiMsg, $idEvent, $dwTime)
	If $aHOVER_CONTROLS_ARRAY[0][0] < 1 Then Return
	
	Local $iControl_Hovered = _ControlGetHovered()
	Local $sCheck_LHE = $aLAST_HOVERED_ELEMENT[1]
	Local $iCheck_LCEM = $hLAST_CLICKED_ELEMENT_MARK
	Local $iCtrlID
	
	;Leave Hovering Process and reset variables
	If Not $iControl_Hovered Or ($sCheck_LHE <> -1 And $iControl_Hovered <> $sCheck_LHE) Then
		If $aLAST_HOVERED_ELEMENT_MARK = -1 Then Return
		
		If $aLAST_HOVERED_ELEMENT[0] <> -1 Then
			$iCtrlID = DllCall("user32.dll", "int", "GetDlgCtrlID", "hwnd", $aLAST_HOVERED_ELEMENT[1])
			If IsArray($iCtrlID) Then $iCtrlID = $iCtrlID[0]
			
			Call($aLAST_HOVERED_ELEMENT[0], $iCtrlID, 2, $iControl_Hovered) ;2 is the indicator of OnLeavHover process
			If @error Then Call($aLAST_HOVERED_ELEMENT[0], $iCtrlID, 2)
			If @error Then Call($aLAST_HOVERED_ELEMENT[0], $iCtrlID)
			If @error Then Call($aLAST_HOVERED_ELEMENT[0])
		EndIf
		
		$aLAST_HOVERED_ELEMENT[0] = -1
		$aLAST_HOVERED_ELEMENT[1] = -1
		$aLAST_HOVERED_ELEMENT_MARK = -1
		$hLAST_CLICKED_ELEMENT_MARK = -1
	Else ;Hovering Process, Primary Down/Up handler, and set LAST_HOVERED_ELEMENT
		For $i = 1 To $aHOVER_CONTROLS_ARRAY[0][0]
			If $aHOVER_CONTROLS_ARRAY[$i][0] = $iControl_Hovered Then
				$iCtrlID = DllCall("user32.dll", "int", "GetDlgCtrlID", "hwnd", $iControl_Hovered)
				If IsArray($iCtrlID) Then $iCtrlID = $iCtrlID[0]
				
				;Primary Down/Up handler
				If ($aHOVER_CONTROLS_ARRAY[$i][3] <> "" Or $aHOVER_CONTROLS_ARRAY[$i][4] <> "") And _
					($iCheck_LCEM = -1 Or $iCheck_LCEM = $iControl_Hovered) Then
					
					Local $aCursorInfo = GUIGetCursorInfo()
					
					If IsArray($aCursorInfo) Then
						;Primary Down. Last condition is to Prevent/Allow multiple function call.
						If $aCursorInfo[2] = 1 And $aHOVER_CONTROLS_ARRAY[$i][3] <> -1 And _
							(($aHOVER_CONTROLS_ARRAY[$i][5] < 1 And $iCheck_LCEM <> $iControl_Hovered) Or _
								$aHOVER_CONTROLS_ARRAY[$i][5] > 0) Then
							
							Call($aHOVER_CONTROLS_ARRAY[$i][3], $iCtrlID)
							If @error Then Call($aHOVER_CONTROLS_ARRAY[$i][3])
							
							$hLAST_CLICKED_ELEMENT_MARK = $iControl_Hovered
						ElseIf $aCursorInfo[2] = 0 And $aHOVER_CONTROLS_ARRAY[$i][4] <> -1 And _ ;Primary Up
							$iCheck_LCEM = $iControl_Hovered Then
							
							Call($aHOVER_CONTROLS_ARRAY[$i][4], $iCtrlID)
							If @error Then Call($aHOVER_CONTROLS_ARRAY[$i][4])
							
							$hLAST_CLICKED_ELEMENT_MARK = -1
						EndIf
					EndIf
				EndIf
				
				If $aLAST_HOVERED_ELEMENT_MARK = $aHOVER_CONTROLS_ARRAY[$i][0] Then ExitLoop
				$aLAST_HOVERED_ELEMENT_MARK = $aHOVER_CONTROLS_ARRAY[$i][0]
				
				Call($aHOVER_CONTROLS_ARRAY[$i][1], $iCtrlID, 1, 0) ;1 is the indicator of OnHover process
				If @error Then Call($aHOVER_CONTROLS_ARRAY[$i][1], $iCtrlID, 1)
				If @error Then Call($aHOVER_CONTROLS_ARRAY[$i][1], $iCtrlID)
				If @error Then Call($aHOVER_CONTROLS_ARRAY[$i][1])
				
				If $aHOVER_CONTROLS_ARRAY[$i][2] <> -1 Then
					$aLAST_HOVERED_ELEMENT[0] = $aHOVER_CONTROLS_ARRAY[$i][2]
					$aLAST_HOVERED_ELEMENT[1] = $iControl_Hovered
				EndIf
				
				ExitLoop
			EndIf
		Next
	EndIf
EndFunc

;Backwards compatibility function #1
Func GUICtrl_SetOnHover($iCtrlID, $sHover_Func="", $sLeaveHover_Func=-1, $sPrimaryDownFunc=-1, $sPrimaryUpFunc=-1, $iKeepCallFunc=1)
	_GUICtrl_SetOnHover($iCtrlID, $sHover_Func, $sLeaveHover_Func, $sPrimaryDownFunc, $sPrimaryUpFunc, $iKeepCallFunc)
EndFunc

;Backwards compatibility function #2
Func GUICtrlSetOnHover($iCtrlID, $sHover_Func="", $sLeaveHover_Func=-1, $sPrimaryDownFunc=-1, $sPrimaryUpFunc=-1, $iKeepCallFunc=1)
	_GUICtrl_SetOnHover($iCtrlID, $sHover_Func, $sLeaveHover_Func, $sPrimaryDownFunc, $sPrimaryUpFunc, $iKeepCallFunc)
EndFunc

;Backwards compatibility function #3
Func _GUICtrlSetOnHover($iCtrlID, $sHover_Func="", $sLeaveHover_Func=-1, $sPrimaryDownFunc=-1, $sPrimaryUpFunc=-1, $iKeepCallFunc=1)
	_GUICtrl_SetOnHover($iCtrlID, $sHover_Func, $sLeaveHover_Func, $sPrimaryDownFunc, $sPrimaryUpFunc, $iKeepCallFunc)
EndFunc

;Thanks to amel27 for that one!!!
Func _ControlGetHovered()
	Local $Old_Opt_MCM = Opt("MouseCoordMode", 1)
	
	Local $aRet = DllCall("User32.dll", "int", "WindowFromPoint", _
		"long", MouseGetPos(0), _
		"long", MouseGetPos(1))
	
	;$aRet = DllCall("user32.dll", "int", "GetDlgCtrlID", "hwnd", $aRet[0])
	
	Opt("MouseCoordMode", $Old_Opt_MCM)
	
	Return $aRet[0]
EndFunc

;Release the CallBack resources
Func OnAutoItExit()
	If $pTimerProc > 0 Then DllCallbackFree($pTimerProc)
	If $uiTimer > 0 Then DllCall("user32.dll", "int", "KillTimer", "hwnd", 0, "int", $uiTimer)
	
	$pTimerProc = 0
	$uiTimer = 0
EndFunc
