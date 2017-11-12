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
Global $Y1 = $YGUI/3
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

Local $getBtn = _createButtonWithCursor("GET", $XGUI- 49, $Y1 + 30 + $YTAB, 45)
GUICtrlSetOnEvent(-1, "GetTagsTeespring")
;---------
Local $chkFilterEmailGoogle = _createCheckbox("Filter Emails Google: Ctrl+A. Ctrl+C. Shift+F để get mail",5,$Y1+60 + $YTAB,$XGUI- 2*$padSide)
GUICtrlSetOnEvent(-1, "IsFilterEmailGoolge")

Local $chkSaveImgFromScreen = _createCheckbox("Save Img From CBoard: Ctrl+C. Shift+C để save",5,$Y1+80+ $YTAB,$XGUI-15)
GUICtrlSetOnEvent(-1, "isSaveImgFromScreen")

;====================== TAB2 ==================================================================
GUICtrlCreateTabItem("Sunfrog")
GUISetFont(8.5)

Local $chkGuysTee = _createCheckbox("Guys Tee",5, 5 + $YTAB, 70)

Local $chkGuysColor[$colors[0]]
For $i= 1 to UBound($colors) - 1
   $chkGuysColor[$i-1] = _createCheckbox($colors[$i], 5 , $YTAB + 10 + $i * $k , 70)
Next

Local $chkLadyTee = _createCheckbox("Lady Tee",5 + $space, 5 + $YTAB, 70)

Local $chkLadyColor[$colors[0]]
For $i= 1 to UBound($colors) - 1
   $chkLadyColor[$i-1] = _createCheckbox($colors[$i], 5 + $space , $YTAB + 10 + $i * $k,70)
Next

;---------------
Local $chkHoodie = _createCheckbox("Hoodie",5 + $space * 2, 5 + $YTAB, 80)

Local $chkHoodieColor[$colors[0]]
For $i= 1 to UBound($colors) - 1
   $chkHoodieColor[$i-1] = _createCheckbox($colors[$i], 5 + $space * 2 , $YTAB + 10 + $i * $k,70)
Next

;----------
Local $chkSweat = _createCheckbox("Sweat",5 + $space * 3, 5 + $YTAB, 80)

Local $chkSweatColor[$colors[0]]
For $i= 1 to UBound($colors) - 1
   $chkSweatColor[$i-1] = _createCheckbox($colors[$i], 5 + $space * 3 , $YTAB + 10 + $i * $k,70)
Next

;----------
Local $chkUniLSleeve = _createCheckbox("Uni.L.Sleeve",5 + $space * 4, 5 + $YTAB, 80)

Local $chkUniLSleeveColor[$colors[0]]
For $i= 1 to UBound($colors) - 1
   $chkUniLSleeveColor[$i-1] = _createCheckbox($colors[$i], 5 + $space * 4 , $YTAB + 10 + $i * $k, 70)
Next

;----------
Local $chkColoredMug = _createCheckbox("ColorMug",5 + $space * 5, 5 + $YTAB, 60)
;GUICtrlCreateLabel("ColorMug:", 25 + $space * 5 , 10 + $YTAB, 70)

;=================
;$YTAB = 120
Local $openFilePNG = _createButtonWithCursor("PNG",5,$YTAB + 140, 60)
GUICtrlSetOnEvent(-1, "pngDesign")

local $chkBackDesign = _createCheckbox("Back",150, $YTAB + 142 ,50,20)

Local $txtAreaPNG =  GUICtrlCreateEdit("", 5, $YTAB + 36 + $i * $k, 200, 89,   $ES_AUTOVSCROLL + $WS_VSCROLL + $ES_READONLY)

Local $titleCamp = _createRequiredInputText("#KEY Apparel - Ltd. Edition",210,  $YTAB + 147, 240,"Title", 150)

Local $descCamp =  _createRequiredEdit("#KEY Apparel. Best Gifts For You.", 465, $YTAB + 147, 170, 103, 300)
$descriptionHandle = GUICtrlGetHandle($descCamp)

Local $keywordCamp = _createRequiredInputText("",210,  $YTAB + 174, 240,"Keyword", 100)

Local $categoriesCampCombo = _createComboBoxWithCursor($CHOOSE, 210 , $YTAB + 202, 242 , 25 )
GUICtrlSetFont(-1,9.5)
$categories = StrToArray($categories)
For $i = 1 to UBound($categories) - 1
   GUICtrlSetData(-1, $categories[$i], $CHOOSE)
Next

Local $collectionCampCombo = _createComboBoxWithCursor($CHOOSE, 210 , $YTAB + 229, 242 , 25 )
GUICtrlSetFont(-1, 9.5)
$collections = StrToArray($collections)
For $i = 1 to UBound($collections) - 1
   GUICtrlSetData(-1, $collections[$i], $CHOOSE)
Next

Local $uploadDesign = _createButtonWithCursor("Upload", 580, $YTAB + 125, 56)
GUICtrlSetOnEvent(-1, "uploadDesign")

GUICtrlCreateTabItem("") ; end tabitem definition

GuISetState(@SW_SHOW, $hGUI)

While 1
	Sleep(30)
WEnd

Func ExitApp()
	Exit
EndFunc