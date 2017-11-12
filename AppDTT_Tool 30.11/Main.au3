#NoTrayIcon
#include-once

#include <import\MessageBox.au3>
#include <import\functionCreateProperties.au3>
#include <import\service.au3>
#include <import\utils.au3>
#include <import\GlobalVar.au3>
#include <import\utilsGui.au3>
#include <import\generate.au3>
#include <import\eventChangeCombo.au3>
#include <import\hover.au3>
#include <import\funcDrawJSP.au3>
#include <import\onEventFunc.au3>
#include <import\JSP.au3>
#include <import\FixMode.au3>

Opt("GUIOnEventMode", 1) ; Change to OnEvent mode

Global $tab[3]

HotKeySet("^a", "_selectall")
HotKeySet("{esc}", "closeApp")

If (WinExists($TitleGui)) Then
	  WinActivate($TitleGui)
	  Exit
EndIf

Global $hMainGUI = GUICreate($TitleGui,$WidthGui, $HeightGui,-1,-1)

GUISetFont(10)
GUISetOnEvent($GUI_EVENT_CLOSE, "closeApp")
GUISetOnEvent($GUI_EVENT_PRIMARYDOWN, "drag")

$cTab_Right = GUICtrlCreateDummy()
GUICtrlSetOnEvent( $cTab_Right, "cTab_Right")
$cTab_Left = GUICtrlCreateDummy()
GUICtrlSetOnEvent( $cTab_Left, "cTab_Left")

Global $aAccelKeys[2][2] = [["^{w}", $cTab_Right],["^{s}", $cTab_Left]]
GUISetAccelerators($aAccelKeys)


;================TAB IN TAB===========================

$child1         = GUICreate("",$WidthGui-10,$heightGui - 245,5,210,BitOr($WS_CHILD,$WS_TABSTOP),-1,$hMainGUI)

;==================   Child Gui In tab ============================
$guiInTab       = GUICreate("",$WidthGui-10,$heightGui - 280,1,22,BitOr($WS_CHILD,$WS_TABSTOP),-1,$child1)

GUISetBkColor(0xffffff,$guiInTab)

;============================Return child1=================================================
GUISwitch($child1)

$child_tab      = GUICtrlCreateTab(0,0,$WidthGui-5,$heightGui)
GUICtrlSetOnEvent( $child_tab, "toogleChildTab")

$child11tab     = GUICtrlCreateTabItem("Utils")

Local $formComboBox = _GUICtrlCreateCombo("-- Utils --", 5, 25, 156, 20 , 0x191919)
GUICtrlSetCursor(-1, 0)  ; hand
_GUICtrl_SetOnHover(-1, "_Hover_Proc", "_Leave_Hover_Proc", "PrimaryDown_Proc", "PrimaryUp_Proc")
GUICtrlSetFont(-1,9)
$arrKeyForm = readKeyIniFile($configPath,"form")

If Not @error Then
For $i= 1 to $arrKeyForm[0][0]
   GUICtrlSetData($formComboBox, $arrKeyForm[$i][0])
Next
EndIf

$openFileHTML= _createButtonWithCursor("Open file", 163,25,70)
GUICtrlSetOnEvent( $openFileHTML, "openFileHTML")
_GUICtrl_SetOnHover(-1, "_Hover_Proc", "_Leave_Hover_Proc", "PrimaryDown_Proc", "PrimaryUp_Proc")

$textFieldGenerate = GUICtrlCreateEdit("",5,50,$WidthGui-17,$HeightGui-297,$ES_AUTOVSCROLL +$ES_AUTOHSCROLL+ $WS_VSCROLL+ $WS_HSCROLL)
GUICtrlSetFont($textFieldGenerate,9)

$child12tab     = GUICtrlCreateTabItem("Draw Form")

GUICtrlCreateTabItem("")
GUISetState()

;===================== Return to MainGui ========================

GUISwitch($hMainGUI)
Local $idFilemenu = GUICtrlCreateMenu("&File")
Local $idFileitem = GUICtrlCreateMenuItem("Choose working folder", $idFilemenu)
GUICtrlSetOnEvent( $idFileitem, "menuOpen")
GUICtrlSetState(-1, $GUI_DEFBUTTON)

$openWorkingFolder = GUICtrlCreateMenuItem("Open working folder", $idFilemenu)
GUICtrlSetOnEvent( $openWorkingFolder, "openWorkingFolder")

Local $chooseWriteMode = GUICtrlCreateMenuItem("Write append", $idFilemenu)
GUICtrlSetOnEvent( $chooseWriteMode, "chooseWriteMode")
GUICtrlSetState(-1, $GUI_UNCHECKED)

Local $chooseFixMode = GUICtrlCreateMenuItem("FixMode", $idFilemenu)
GUICtrlSetOnEvent( $chooseFixMode, "chooseFixMode")
GUICtrlSetState(-1, $GUI_UNCHECKED)

Local $chooseFixModeTab = GUICtrlCreateMenuItem("FixModeTab", $idFilemenu)
GUICtrlSetOnEvent( $chooseFixModeTab, "chooseFixModeTab")
GUICtrlSetState(-1, $GUI_UNCHECKED)

Local $idExititem = GUICtrlCreateMenuItem("Exit", $idFilemenu)
GUICtrlCreateMenuItem("", $idFilemenu, 2) ; create a separator line
GUICtrlSetOnEvent( $idExititem, "closeApp")


Local $idViewmenu = GUICtrlCreateMenu("&View", -1, 1) ; is created before "?" menu
Local $idViewstatusitem = GUICtrlCreateMenuItem("Statusbar", $idViewmenu)
GUICtrlSetOnEvent( $idViewstatusitem, "viewStatusBar")
GUICtrlSetState(-1, $GUI_CHECKED)

;-------------- info menu -------------------------------------------------------------
Local $idHelpmenu = GUICtrlCreateMenu("&Info")
Local $idInfoitem = GUICtrlCreateMenuItem("About me", $idHelpmenu)
GUICtrlSetOnEvent( $idInfoitem, "showInfo")

;================ status bar ===============================================================================

$idStatuslabel = GUICtrlCreateLabel(" " &$WorkingDir, 5, $HeightGui-35, $widthGui-7, 25)
GUICtrlSetColor($idStatuslabel,0xffffff)
GUICtrlSetBkColor($idStatuslabel,0x191919)
GUICtrlSetFont($idStatuslabel,9)
GUICtrlSetOnEvent($idStatuslabel, "openWorkingFolder")
GUICtrlSetCursor($idStatuslabel, 0)  ; hand

$tabParent = GUICtrlCreateTab(0, 0, $WidthGui, $HeightGui)
GUICtrlSetCursor($tabParent, 0)  ; hand
GUICtrlSetOnEvent( $tabParent, "toogleMainTab")


;------------ Tab 1 ---------------

$tab[0] = GUICtrlCreateTabItem("Config")
GUICtrlSetState(-1, $GUI_SHOW); will be display first

GUICtrlCreateLabel("Group",10,33)

;------------- combobox---------------------------------------------------------------------
Local $pathComboBox2 = _GUICtrlCreateCombo($index0Combo, 50, 30, 90, 20 ,0x191919)
GUICtrlSetCursor(-1, 0)  ; hand
_GUICtrl_SetOnHover(-1, "_Hover_Proc", "_Leave_Hover_Proc", "PrimaryDown_Proc", "PrimaryUp_Proc")

$valueGroup = readKeyIniFile($configPath,"group")
If Not @error Then
$groups = StringSplit($valueGroup[1][1],"|")
For $i= 1 to $groups[0]
   GUICtrlSetData($pathComboBox2, $groups[$i])
Next
EndIf

Local $constantCombo = _GUICtrlCreateCombo($index0Combo, 10,60, 130, 20,0x191919)
GUICtrlSetCursor(-1, 0)  ; hand
_GUICtrl_SetOnHover(-1, "_Hover_Proc", "_Leave_Hover_Proc", "PrimaryDown_Proc", "PrimaryUp_Proc")
$valueConstants = readKeyIniFile($configPath,"constants")
If Not @error Then
$constants = StringSplit($valueConstants[1][1],"|")
For $i= 1 to $constants[0]
   GUICtrlSetData($constantCombo, $constants[$i]&"Constrants")
Next
   GUICtrlSetData($constantCombo, "SttttConstants")
EndIf

GUICtrlCreateLabel("FolderEntity :",151,33)
$folderEntity = _createRequiredInputText("", 235, 30, 340," Chỉ nhập chữ, số và .",$maxLengthTextField)

GUICtrlCreateLabel("Entity :",187,63)
$entityGenerate = _createRequiredInputText("", 235, 60, 340," Chỉ nhập chữ và số",$maxLengthTextField)

GUICtrlCreateLabel("UtilsName :",160,93)
$utilsName = _createRequiredInputText("", 235, 90, 340," Chỉ nhập chữ và số",$maxLengthTextField)

GUICtrlCreateLabel("FolderJsp :",164,123)
$folderName = _createRequiredInputText("", 235, 120, 340," Chỉ nhập chữ, số và /",$maxLengthTextField)

GUICtrlCreateLabel("maQT :", 187,155)
$maQuiTrinh = _createRequiredInputText("", 235, 152, 155, " Chỉ nhập chữ và số",$maxLengthTextField/8)

$generate = _createButtonWithCursor("Generate",480,152,80)
GUICtrlSetOnEvent( $generate, "generate")
_GUICtrl_SetOnHover(-1, "_Hover_Proc", "_Leave_Hover_Proc", "PrimaryDown_Proc", "PrimaryUp_Proc")

$resultGenerate = _createSuccessLable( 565,155,120,25)

;----------End of Tab1 -----
GUISwitch($hMainGUI)

;============================== TAB 2 : MODEL ============================================================

$tab[1] = GUICtrlCreateTabItem("Model")
;GUICtrlSetState(-1, $GUI_SHOW); will be display first
GUICtrlCreateLabel("Create service.xml ...", 10,30)

GUICtrlCreateLabel("<Entity = ", 17,60)
$entityName = _createRequiredInputText("", 75, 55, 210," Chỉ nhập chữ, số và _",$maxLengthTextField)

Local $group_create_service = _GUICtrlCreateCombo($index0Combo, 300, 55, 110, 22 ,0x191919)
GUICtrlSetCursor(-1, 0)  ; hand
_GUICtrl_SetOnHover(-1, "_Hover_Proc", "_Leave_Hover_Proc", "PrimaryDown_Proc", "PrimaryUp_Proc")

$groups = StringSplit($valueGroup[1][1],"|")
For $i= 1 to $groups[0]
   GUICtrlSetData($group_create_service, $groups[$i])
Next

$createEntity = _createButtonWithCursor("Create", $WidthGui - 180 , 55,50)
GUICtrlSetOnEvent( $createEntity, "createEntity")
_GUICtrl_SetOnHover(-1, "_Hover_Proc", "_Leave_Hover_Proc", "PrimaryDown_Proc", "PrimaryUp_Proc")

;======================= LABEL Message Sucessfull =====================================
$createEntityLabel = _createSuccessLable( $WidthGui - 40,58,60,25)
$resultCreateColumn1 = _createSuccessLable($WidthGui - 40, 95,120,25)
$resultCreateColumn2 = _createSuccessLable($WidthGui - 40, 130,120,25)
$resultCreateColumn3 = _createSuccessLable($WidthGui - 40, 162,120,25)
;=======================END LABEL Message Sucessfull =====================================
;# column String
_createLable("<Col String ", 5,92,$red)
$colNameStr = _createRequiredInputText("", 75, 90, 210,"",$maxLengthTextField/2)


Local $strComboBox = _GUICtrlCreateCombo('input *', 300, 90, 110, 20 ,0x191919)
GUICtrlSetCursor(-1, 0)  ; hand
_GUICtrl_SetOnHover(-1, "_Hover_Proc", "_Leave_Hover_Proc", "PrimaryDown_Proc", "PrimaryUp_Proc")

$groups = StringSplit($serviceTypeStrCombo,"|")
For $i= 1 to $groups[0]
   GUICtrlSetData($strComboBox, $groups[$i])
Next

$createColumnStr = _createButtonWithCursor("Create", $WidthGui - 180, 90, 50)
GUICtrlSetOnEvent( $createColumnStr, "createColumnStr")
_GUICtrl_SetOnHover(-1, "_Hover_Proc", "_Leave_Hover_Proc", "PrimaryDown_Proc", "PrimaryUp_Proc")

;# column Long (Numeric)
_createLable("<Col long ", 5,127,$red)
$colNameLong = _createRequiredInputText("", 75, 125, 210,"",$maxLengthTextField/2)
;$checkNoiCapCmnd = GUICtrlCreateCheckbox("NoiCapCmnd",300,125)

Local $longComboBox = _GUICtrlCreateCombo('long *', 300, 125, 110, 20 ,0x191919)
GUICtrlSetCursor(-1, 0)  ; hand
_GUICtrl_SetOnHover(-1, "_Hover_Proc", "_Leave_Hover_Proc", "PrimaryDown_Proc", "PrimaryUp_Proc")

$groups = StringSplit($serviceTypeLongCombo,"|")
For $i= 1 to $groups[0]
   GUICtrlSetData($longComboBox, $groups[$i])
Next


$createColumnLong = _createButtonWithCursor("Create", $WidthGui - 180, 125, 50)
GUICtrlSetOnEvent( $createColumnLong, "createColumnLong")
_GUICtrl_SetOnHover(-1, "_Hover_Proc", "_Leave_Hover_Proc", "PrimaryDown_Proc", "PrimaryUp_Proc")

;# column Date
_createLable("<Col Date ", 5,159,$red)
$colNameDate = _createRequiredInputText("", 75, 157, 210,"",$maxLengthTextField/2)
$checkDateRequired = GUICtrlCreateCheckbox("Required",300,157)
GUICtrlSetState($checkDateRequired,$GUI_CHECKED)

$createColumnDate = _createButtonWithCursor("Create", $WidthGui - 180, 157, 50)
GUICtrlSetOnEvent( $createColumnDate, "createColumnDate")
_GUICtrl_SetOnHover(-1, "_Hover_Proc", "_Leave_Hover_Proc", "PrimaryDown_Proc", "PrimaryUp_Proc")

$finishService = _createButtonWithCursor("Finish", $WidthGui-85, 185, 80)
GUICtrlSetOnEvent( $finishService, "finishService")
_GUICtrl_SetOnHover(-1, "_Hover_Proc", "_Leave_Hover_Proc", "PrimaryDown_Proc", "PrimaryUp_Proc")

$textFieldService = GUICtrlCreateEdit("",5,210,$WidthGui-7,$HeightGui-250, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL, $ES_READONLY))

;-------------Tab 3 : Language_xxxx.properties--------------
$tab[2] = GUICtrlCreateTabItem("Languages")

GUICtrlCreateLabel("vn.dtt.", 20,33)
Local $tab1Combo = _GUICtrlCreateCombo($index0Combo, 60, 30, 65, 20 , 0x191919)
GUICtrlSetCursor(-1, 0)  ; hand
_GUICtrl_SetOnHover(-1, "_Hover_Proc", "_Leave_Hover_Proc", "PrimaryDown_Proc", "PrimaryUp_Proc")

$groups = StringSplit($valueGroup[1][1],"|")
For $i= 1 to $groups[0]
   GUICtrlSetData($tab1Combo, $groups[$i])
Next

GUICtrlCreateLabel("Folder jsp",133,35)
$folderJsp =  _createRequiredInputText("", 200, 31, 330,"",45)
GUICtrlCreateLabel("Value",19,62)
$value =  _createRequiredInputText("",60, 60, 470,"Hồ Sơ Xác Nhận",65)

$createKeyValue = _createButtonWithCursor("Create", 89, 97, 60)
GUICtrlSetOnEvent( $createKeyValue, "createKeyValue")
_GUICtrl_SetOnHover(-1, "_Hover_Proc", "_Leave_Hover_Proc", "PrimaryDown_Proc", "PrimaryUp_Proc")

$idListview = GUICtrlCreateListView("",5, 125, $WidthGui-60,$HeightGui-200)
_GUICtrlListView_SetExtendedListViewStyle($idListview, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_SUBITEMIMAGES))
GUICtrlSetFont($idListview,9)

_GUICtrlListView_AddColumn($idListview, "Row", 40)
_GUICtrlListView_AddColumn($idListview, "KEY", $WidthGui/1.6)
_GUICtrlListView_AddColumn($idListview, "VALUE", $WidthGui)

$loadFileToListView = _createButtonWithCursor("Load Data", 152, 97, 70)
GUICtrlSetOnEvent( $loadFileToListView, "loadFileToListView")
_GUICtrl_SetOnHover(-1, "_Hover_Proc", "_Leave_Hover_Proc", "PrimaryDown_Proc", "PrimaryUp_Proc")

$openFile = _createButtonWithCursor("Open File", 225,97,75)
GUICtrlSetOnEvent( $openFile , "openFile")
_GUICtrl_SetOnHover(-1, "_Hover_Proc", "_Leave_Hover_Proc", "PrimaryDown_Proc", "PrimaryUp_Proc")

$copyRowInList = _createButtonWithCursor("Copy", $WidthGui-51,190,45)
GUICtrlSetOnEvent( $copyRowInList, "copyRowInList")
_GUICtrl_SetOnHover(-1, "_Hover_Proc", "_Leave_Hover_Proc", "PrimaryDown_Proc", "PrimaryUp_Proc")

$getKeyRowInList = _createButtonWithCursor("Key", $WidthGui-51, 220,45)
GUICtrlSetOnEvent( $getKeyRowInList, "getKeyRowInList")
_GUICtrl_SetOnHover(-1, "_Hover_Proc", "_Leave_Hover_Proc", "PrimaryDown_Proc", "PrimaryUp_Proc")

$deleteRowInList = _createButtonWithCursor("Delete", $WidthGui-51, 250,45)
_GUICtrl_SetOnHover(-1, "_Hover_Proc", "_Leave_Hover_Proc", "PrimaryDown_Proc", "PrimaryUp_Proc")

GUICtrlCreateTabItem("")
;=================================================================================================
GUIRegisterMsg($WM_COMMAND, "MY_WM_COMMAND")

GUISetState(@SW_SHOW, $hMainGUI)


While 1
    Sleep(7) ; Sleep to reduce CPU usage
    $msg = 0

    While $msg <> $GUI_EVENT_CLOSE
	  $msg = GUIGetMsg()
	  $focus = String(ControlGetFocus($hMainGui))
	  If StringInStr($focus,"Edit") And $focus <> $last Then
		 $last = $focus
		 $h = ControlGetHandle($hMainGui, "",$focus)
		 _GUICtrlEdit_SetSel($h, 0, StringLen(ControlGetText($hMainGui,"",$h)))
	  EndIf

	  Select
		 Case $changed = 1
			   eventProcessComboBox(GUICtrlRead($formComboBox))
			   $changed = 0
	  EndSelect
    WEnd
WEnd

Func closeApp()
   If (WinActive($TitleGui)) Then
		 $isYes = MsgBox($MB_OKCANCEL+262144+8192, "Thoát", "Đồng ý?")
		 if($isYes=1) then Exit
   EndIf
 EndFunc   ;==>closeApp



 Func menuOpen()
   Local Const $sMessage = "Select a folder"
   $WorkingDir = FileSelectFolder($sMessage, @ScriptDir)
  ; MsgBox(0,"",$WorkingDir)
   If @error <> 1 Then
   GUICtrlSetData($idStatuslabel,$WorkingDir)
   GUICtrlCreateMenuItem($WorkingDir, $idRecentfilesmenu)
   EndIf
EndFunc

Func viewStatusBar()
If BitAND(GUICtrlRead($idViewstatusitem), $GUI_CHECKED) = $GUI_CHECKED Then
			  GUICtrlSetState($idViewstatusitem, $GUI_UNCHECKED)
			  GUICtrlSetState($idStatuslabel, $GUI_HIDE)
		  Else
			  GUICtrlSetState($idViewstatusitem, $GUI_CHECKED)
			  GUICtrlSetState($idStatuslabel, $GUI_SHOW)
		  EndIf
EndFunc

Func chooseWriteMode()
If BitAND(GUICtrlRead($chooseWriteMode), $GUI_UNCHECKED) = $GUI_UNCHECKED Then
			  GUICtrlSetState($chooseWriteMode, $GUI_CHECKED)
			  $modeWrite = 9+$utf8
		  Else
			  GUICtrlSetState($chooseWriteMode, $GUI_UNCHECKED)
			  $modeWrite = 10+$utf8
		  EndIf
EndFunc

Func chooseFixModeTab()
If BitAND(GUICtrlRead($chooseFixModeTab), $GUI_UNCHECKED) = $GUI_UNCHECKED Then
			GUICtrlSetState($chooseFixModeTab, $GUI_CHECKED)
			HotKeySet("{tab}","SendSuffix")
		 Else
			GUICtrlSetState($chooseFixModeTab, $GUI_UNCHECKED)
			HotKeySet("{tab}")
		  EndIf
EndFunc

Func chooseFixMode()
   If BitAND(GUICtrlRead($chooseFixMode), $GUI_UNCHECKED) = $GUI_UNCHECKED Then

	  GUICtrlSetState($chooseFixMode, $GUI_CHECKED)

	  $FillData2Form =  $WorkingDir&"\fix-mode\fillData2Form.java"
	  $Validator =  $WorkingDir&"\fix-mode\validator.java"

	  $FillData2FormTab =  $WorkingDir&"\fix-mode\tab\fillData2FormTab.java"
	  $ValidatorTab =  $WorkingDir&"\fix-mode\tab\validatorTab.java"

	  $arrRequired =  $WorkingDir&"\fix-mode\arrRequired.java"
	  $arrDate =  $WorkingDir&"\fix-mode\arrDate.java"

	  $arrRequiredTab =  $WorkingDir&"\fix-mode\tab\arrRequiredTab.java"
	  $arrDateTab =  $WorkingDir&"\fix-mode\tab\arrDateTab.java"

	  $alter =  $WorkingDir&"\fix-mode\alterTable.sql"

   	  $FillData2Form = FileOpen($FillData2Form, $modeWrite)
	  $Validator = FileOpen($Validator, $modeWrite)

	  $FillData2FormTab = FileOpen($FillData2FormTab, $modeWrite)
	  $ValidatorTab = FileOpen($ValidatorTab, $modeWrite)

	  $arrRequired = FileOpen($arrRequired, $modeWrite)
	  $arrDate = FileOpen($arrDate, $modeWrite)

	  $arrRequiredTab = FileOpen($arrRequiredTab, $modeWrite)
	  $arrDateTab = FileOpen($arrDateTab, $modeWrite)

	  $alter = FileOpen($alter, $modeWrite)

	  HotKeySet("{SPACE}","fixMode")
	  HotKeySet("s","fixMode")
	  HotKeySet("x","fixMode")

   ElseIf BitAND(GUICtrlRead($chooseFixMode), $GUI_CHECKED) = $GUI_CHECKED Then
	  GUICtrlSetState($chooseFixMode, $GUI_UNCHECKED)
	  HotKeySet("{SPACE}")
	  HotKeySet("s")
	  HotKeySet("x")

	  CloseFileFixMode()
   EndIf
EndFunc

Func openWorkingFolder()
	Run("explorer.exe "&$WorkingDir)
EndFunc

Func showInfo()
   MsgBox($MB_ICONINFORMATION+262144+8192,"Info","tan.nguyen@dtt.vn")
EndFunc

Func drag()
    _SendMessage($hMainGUI, $WM_SYSCOMMAND, 0xF012, 0)
EndFunc

func toogleMainTab()
   Switch GUICtrlRead($tabParent)
	   Case 0
		 GUISetState(@SW_SHOW,$child1)
	   Case 1,2
		 GUISetState(@SW_HIDE,$child1)
   EndSwitch
EndFunc

func toogleMainTabEx($index)
   Switch $index
	   Case 0
		 GUISetState(@SW_SHOW,$child1)
	   Case 1,2
		 GUISetState(@SW_HIDE,$child1)
   EndSwitch
EndFunc

func toogleChildTab()
   Switch GUICtrlRead($child_tab)
	   Case 1
		 GUISetState(@SW_SHOW,$guiInTab)
	   Case 0
		 GUISetState(@SW_HIDE,$guiInTab)
   EndSwitch
EndFunc
;======================= Ctrl + W  : switch tab forward ========================;

Func cTab_Right()
   Local  $index = GUICtrlRead($tabParent) + 1
   If $index > (UBound($tab) - 1) Then $index = 0
   toogleMainTabEx($index)
   GUICtrlSetState($tab[$index], $GUI_SHOW)
EndFunc

;======================= Ctrl + S  : switch tab back ===================;

Func cTab_Left()
   Local  $index = GUICtrlRead($tabParent) - 1
   If $index < 0 Then $index = UBound($tab) - 1
   toogleMainTabEx($index)
   GUICtrlSetState($tab[$index], $GUI_SHOW)
EndFunc
;=================================================================================;
