#include-once
#include <GUIConstantsEx.au3>
#include <GUICtrlSetOnHover_UDF.au3>


 ;========================= UDF ===================================================================================================================
 Func _Hover_Proc($iCtrlID)
	Switch $iCtrlID
		 Case $openFileHTML,$generate,$createEntity,$createColumnStr,$createColumnDate,$createColumnLong,$finishService      ;$openServiceFile,$openSqlFile,$openListIdFile,$openFillData2FormFile,$openValidatorFile,$openReviewFile,
			GUICtrlSetBkColor($iCtrlID,0xFFFFFF)
			GUICtrlSetColor($iCtrlID,0x000000)
			;======================== TAB 3 =======================================================
		 Case $loadFileToListView,$openFile,$copyRowInList,$getKeyRowInList,$deleteRowInList,$createKeyValue
			GUICtrlSetBkColor($iCtrlID,0xFFFFFF)
			GUICtrlSetColor($iCtrlID,0x000000)
		 ;======================= COMBO BOX ==================================================
		 Case $pathComboBox2,$constantCombo,$tab1Combo,$formComboBox,$group_create_service,$strComboBox,$longComboBox,$dateComboBox
			GUICtrlSetBkColor($iCtrlID,0xFFFFFF)
			GUICtrlSetColor($iCtrlID,0x000000)
	EndSwitch
EndFunc

Func _Leave_Hover_Proc($iCtrlID)
	Switch $iCtrlID
		 Case $openFileHTML, $generate,$createEntity,$createColumnStr,$createColumnDate,$createColumnLong,$finishService
			GUICtrlSetColor($iCtrlID,0xFFFFFF)
			GUICtrlSetBkColor($iCtrlID,0x000000)
			;======================== TAB 3 =======================================================
		 Case $loadFileToListView,$openFile,$copyRowInList,$getKeyRowInList,$deleteRowInList,$createKeyValue
			GUICtrlSetColor($iCtrlID,0xFFFFFF)
			GUICtrlSetBkColor($iCtrlID,0x000000)
			;======================= COMBO BOX ==================================================
		Case $pathComboBox2,$constantCombo,$tab1Combo,$formComboBox,$group_create_service,$strComboBox,$longComboBox,$dateComboBox
			GUICtrlSetColor($iCtrlID,0xFFFFFF)
			GUICtrlSetBkColor($iCtrlID,0x000000)
	EndSwitch
EndFunc

Func PrimaryDown_Proc($iCtrlID)
	Switch $iCtrlID
		 Case $openFileHTML, $generate, $createEntity,$createColumnStr,$createColumnDate,$createColumnLong,$finishService

		 Case $loadFileToListView,$openFile,$copyRowInList,$getKeyRowInList,$deleteRowInList,$createKeyValue

	EndSwitch
EndFunc

Func PrimaryUp_Proc($iCtrlID)
	Switch $iCtrlID
		  Case $openFileHTML,$generate, $createEntity,$createColumnStr,$createColumnDate,$createColumnLong,$finishService

		 Case $loadFileToListView,$openFile,$copyRowInList,$getKeyRowInList,$deleteRowInList,$createKeyValue

	EndSwitch
EndFunc