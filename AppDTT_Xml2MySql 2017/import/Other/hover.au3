#include-once
#include <GUIConstantsEx.au3>
#include <GUICtrlSetOnHover_UDF.au3>


 ;========================= UDF ===================================================================================================================
 Func _Hover_Proc($iCtrlID)
	Switch $iCtrlID
		 Case $ChooseXMLFile
			GUICtrlSetBkColor($iCtrlID,0xFFFFFF)
			GUICtrlSetColor($iCtrlID,0x000000)
			;======================== TAB 3 =======================================================
		 Case $ChooseXMLFile
			GUICtrlSetBkColor($iCtrlID,0xFFFFFF)
			GUICtrlSetColor($iCtrlID,0x000000)
		 ;======================= COMBO BOX ==================================================
		 Case $ChooseXMLFile
			GUICtrlSetBkColor($iCtrlID,0xFFFFFF)
			GUICtrlSetColor($iCtrlID,0x000000)
	EndSwitch
EndFunc

Func _Leave_Hover_Proc($iCtrlID)
	Switch $iCtrlID
		 Case $ChooseXMLFile
			GUICtrlSetColor($iCtrlID,0xFFFFFF)
			GUICtrlSetBkColor($iCtrlID,0x000000)
			;======================== TAB 3 =======================================================
		 Case $ChooseXMLFile
			GUICtrlSetColor($iCtrlID,0xFFFFFF)
			GUICtrlSetBkColor($iCtrlID,0x000000)
			;======================= COMBO BOX ==================================================
		Case $ChooseXMLFile
			GUICtrlSetColor($iCtrlID,0xFFFFFF)
			GUICtrlSetBkColor($iCtrlID,0x000000)
	EndSwitch
EndFunc

Func PrimaryDown_Proc($iCtrlID)
	Switch $iCtrlID
		 Case $ChooseXMLFile
		 Case $ChooseXMLFile

	EndSwitch
EndFunc

Func PrimaryUp_Proc($iCtrlID)
	Switch $iCtrlID
		 Case $ChooseXMLFile

		 Case $ChooseXMLFile

	EndSwitch
EndFunc