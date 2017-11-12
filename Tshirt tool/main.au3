#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include<ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>

#include <GUIEdit.au3>
#include <WinAPI.au3>


#include "ConfigVar.au3"
#include "Func.au3"
#include "sunfrogUtils.au3"
#include "SunfrogFunc.au3"
#include "GuiFunc.au3"
#include "var.au3"
#include "sunfrogObj.au3"

HotKeySet("^a", "_selectall")

Opt("GUIOnEventMode", 1)

Local $hGUI = GUICreate($APPTITLE,$XGUI, $YGUI)

GUISetOnEvent($GUI_EVENT_CLOSE, "ExitApp")

Local $idFilemenu = GUICtrlCreateMenu("&File")
Local $idFileitem = GUICtrlCreateMenuItem("Open", $idFilemenu)
GUICtrlSetState(-1, $GUI_DEFBUTTON)
Local $idHelpmenu = GUICtrlCreateMenu("?")
GUICtrlCreateMenuItem("Save", $idFilemenu)
GUICtrlSetState(-1, $GUI_DISABLE)
Local $idInfoitem = GUICtrlCreateMenuItem("Info", $idHelpmenu)
Local $idExititem = GUICtrlCreateMenuItem("Exit", $idFilemenu)
Local $idRecentfilesmenu = GUICtrlCreateMenu("Recent Files", $idFilemenu, 1)

GUICtrlCreateMenuItem("", $idFilemenu, 2) ; create a separator line

;-----------
Global $Y1 = $YGUI/4
Global $YTAB = 25
global $padSide = 5
global $k = 18
global $space = 100


GUICtrlCreateTab(0, 5, $XGUI, $YGUI)

GUICtrlCreateTabItem("Util")

GUICtrlCreateLabel("Get Tags Teespring", $padSide , 5 + $YTAB, $XGUI)
Local $div = GUICtrlCreateEdit("" , $padSide, 25 + $YTAB, $XGUI- 2*$padSide, $Y1 , $ES_AUTOVSCROLL + $WS_VSCROLL)
$divHandle = GUICtrlGetHandle($div)

Local $combox = _createComboBoxWithCursor("|",$padSide, $Y1 + 30 + $YTAB, 50,25)
GUICtrlSetData($combox, ",", "|")
GUICtrlSetFont($combox,11)

Local $chkTagsTeespring = _createCheckbox("Copy",60, $Y1 + 30 + $YTAB,50,25)

Local $getBtn = _createButtonWithCursor("GET", $XGUI- 68, $Y1 + 30 + $YTAB, 65)
GUICtrlSetOnEvent(-1, "GetTagsTeespring")
;---------
Local $chkFilterEmailGoogle = _createCheckbox("Filter Emails Google: Ctrl+A. Ctrl+C. Shift+F để get mail",5,$Y1+60 + $YTAB,$XGUI- 2*$padSide)
GUICtrlSetOnEvent(-1, "IsFilterEmailGoolge")

Local $chkSaveImgFromScreen = _createCheckbox("Save Img From CBoard: Ctrl+C. Shift+C để save",5,$Y1+80+ $YTAB,$XGUI-15)
GUICtrlSetOnEvent(-1, "isSaveImgFromScreen")

;====================== TAB2 ==================================================================
GUICtrlCreateTabItem("Sunfrog")
GUISetFont(8.5)
Local $sunfrogUser =  _createRequiredInputText($SUNFROG_USER_DEFAULT, 5,  $YTAB + 5, 150,"Username", 50)
Local $sunfrogPass =  _createRequiredInputPass("", 170,  $YTAB + 5, 120,"Password", 20)
Local $sunfrogLogin = _createButtonWithCursor($LOGIN,305,  $YTAB + 5, 60)
GUICtrlSetOnEvent($sunfrogLogin, "sunfrogLogin")

$BeginSunforData=25

Local $chkGuysTee = _createCheckbox("Guys Tee",5, 5 + $YTAB + $BeginSunforData, 70)

Local $chkGuysColor[$teeColors[0]]
For $i= 1 to UBound($teeColors) - 1
   $chkGuysColor[$i-1] = _createCheckbox($teeColors[$i], 5 , $YTAB + 10 + $i * $k +$BeginSunforData, 70)
Next

Local $chkLadyTee = _createCheckbox("Lady Tee",5 + $space, 5 + $YTAB + $BeginSunforData, 70)

Local $chkLadyColor[$teeColors[0]]
For $i= 1 to UBound($teeColors) - 1
   $chkLadyColor[$i-1] = _createCheckbox($teeColors[$i], 5 + $space , $YTAB + 10 + $i * $k + $BeginSunforData,70)
Next

;---------------
Local $chkHoodie = _createCheckbox("Hoodie",5 + $space * 2, 5 + $YTAB + $BeginSunforData, 80)

Local $chkHoodieColor[$hoodieColors[0]]
For $i= 1 to UBound($hoodieColors) - 1
   $chkHoodieColor[$i-1] = _createCheckbox($hoodieColors[$i], 5 + $space * 2 ,$BeginSunforData+ $YTAB + 10 + $i * $k,70)
Next

;----------
Local $chkSweat = _createCheckbox("Sweat",5 + $space * 3, 5 + $YTAB + $BeginSunforData, 80)

Local $chkSweatColor[$sweatColors[0]]
For $i= 1 to UBound($sweatColors) - 1
   $chkSweatColor[$i-1] = _createCheckbox($sweatColors[$i], 5 + $space * 3 , $YTAB + 10 + $i * $k + $BeginSunforData,70)
Next

;----------
Local $chkUniLSleeve = _createCheckbox("Uni.L.Sleeve",5 + $space * 4, 5 + $YTAB + $BeginSunforData, 80)

Local $chkUniLSleeveColor[$uniLSleeveColors[0]]
For $i= 1 to UBound($uniLSleeveColors) - 1
   $chkUniLSleeveColor[$i-1] = _createCheckbox($uniLSleeveColors[$i], 5 + $space * 4 , $YTAB + 10 + $i * $k + $BeginSunforData, 70)
Next

;----------
Local $chkColoredMug = _createCheckbox("ColorMug",5 + $space * 5, 5 + $YTAB + $BeginSunforData, 60)

;=================
;$YTAB = 120
Local $openFilePNG = _createButtonWithCursor("PNG",5, $BeginSunforData + $YTAB + 140, 60)
GUICtrlSetOnEvent(-1, "pngDesign")

local $chkBackDesign = _createCheckbox("Back",150,$BeginSunforData+ $YTAB + 142 ,50,20)

Local $txtAreaPNG =  GUICtrlCreateEdit("", 5, $BeginSunforData + $YTAB + 36 + $i * $k, 200, 89,   $ES_AUTOVSCROLL + $WS_VSCROLL + $ES_READONLY)

Local $titleCamp = _createRequiredInputText($TITLE_DEFAULT, 210, $BeginSunforData + $YTAB + 147, 240,"Title", 150)

Local $descCamp =  _createRequiredEdit($DESC_DEFAULT, 465,$BeginSunforData + $YTAB + 147, 170, 103, 300)
$descHandle = GUICtrlGetHandle($descCamp)

Local $keywordCamp = _createRequiredInputText("",210,$BeginSunforData +  $YTAB + 174, 240,"Keyword", 100)

Local $categoriesCampCombo = _createComboBoxWithCursor($CHOOSE, 210 , $BeginSunforData + $YTAB + 202, 242 , 25 )
GUICtrlSetFont(-1,9.5)
$categories = StrToArray($categories)
For $i = 1 to UBound($categories) - 1
   GUICtrlSetData(-1, $categories[$i], $CHOOSE)
Next

Local $collectionCampCombo = _createComboBoxWithCursor($CHOOSE, 210 ,$BeginSunforData + $YTAB + 229, 242 , 25 )
GUICtrlSetFont(-1, 9.5)
$collections = StrToArray($collections)
For $i = 1 to UBound($collections) - 1
   GUICtrlSetData(-1, $collections[$i], $CHOOSE)
Next

Local $sunfrogUploadCampBtn = _createButtonWithCursor("Upload", 580,$BeginSunforData + $YTAB + 125, 56)
GUICtrlSetOnEvent(-1, "uploadSunfrogCamp")

GUICtrlCreateTabItem("") ; end tabitem definition

GuISetState(@SW_SHOW, $hGUI)

While 1
	Sleep(120)
WEnd

Func ExitApp()
   Local $oke = MsgBox($MB_ICONINFORMATION + $MB_OKCANCEL, "Exit App","Are you sure?")
   If $oke = 1 Then Exit
EndFunc