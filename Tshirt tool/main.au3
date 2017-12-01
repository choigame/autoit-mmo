#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include<ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>

#include <GUIEdit.au3>
#include <WinAPI.au3>

#include 'http\_HttpRequest.au3'
#include "ConfigVar.au3"
#include "UtilsFunc.au3"
#include "sunfrog_code\sunfrogUtils.au3"
#include "sunfrog_code\SunfrogUploadFunc.au3"
#include "sunfrog_code\sunfrogObj.au3"
#include "sunfrog_code\SunfrogSpyFunc.au3"
#include "GuiFunc.au3"
#include "var.au3"

HotKeySet("^a", "_selectall")

Opt("GUIOnEventMode", 1)

Local $hGUI = GUICreate($APPTITLE,$XGUI, $YGUI)

GUISetOnEvent($GUI_EVENT_CLOSE, "ExitApp")

Local $idFilemenu = GUICtrlCreateMenu("&File")
Local $idFileitem = GUICtrlCreateMenuItem("ScriptDir", $idFilemenu)
GUICtrlSetOnEvent(-1, "openScriptDir")
GUICtrlSetState(-1, $GUI_DEFBUTTON)
Local $idHelpmenu = GUICtrlCreateMenu("?")
GUICtrlCreateMenuItem("Save", $idFilemenu)
GUICtrlSetState(-1, $GUI_DISABLE)
Local $idInfoitem = GUICtrlCreateMenuItem("Info", $idHelpmenu)
Local $idExititem = GUICtrlCreateMenuItem("Exit", $idFilemenu)
Local $idRecentfilesmenu = GUICtrlCreateMenu("Recent Files", $idFilemenu, 1)

GUICtrlCreateMenuItem("", $idFilemenu, 2) ; create a separator line

;-----------
Global $Y1 = $YGUI/7
Global $YTAB = 25
global $padSide = 5
global $k = 18
global $space = 100


GUICtrlCreateTab(0, 5, $XGUI, $YGUI)

GUICtrlCreateTabItem("Utils")

GUICtrlCreateLabel("Get Tags Teespring Or Making Hashtags", $padSide , 10 + $YTAB, $XGUI)
Local $div = GUICtrlCreateEdit("" , $padSide, 25 + $YTAB, $XGUI- 2*$padSide, $Y1 , $ES_AUTOVSCROLL + $WS_VSCROLL)
$divHandle = GUICtrlGetHandle($div)

Local $combox = _createComboBoxWithCursor("|",$padSide, $Y1 + 30 + $YTAB, 50,25)
GUICtrlSetData($combox, ",", "|")
GUICtrlSetFont($combox,11)

Local $chkTagsTeespring = _createCheckbox("Copy",60, $Y1 + 30 + $YTAB,50,25)

Local $getTagsTeespringBtn = _createButtonWithCursor("Get Tags teespring", $XGUI- 240, $Y1 + 30 + $YTAB, 125)
GUICtrlSetOnEvent(-1, "GetTagsTeespring")

Local $maketHashTagsBtn = _createButtonWithCursor("Make Hashtags", $XGUI- 105, $Y1 + 30 + $YTAB, 100)
GUICtrlSetOnEvent(-1, "MakeHashTags")
;---------
$Y2 = 0

Local $chkSaveImgFromScreen = _createCheckbox("Shift+C để chụp ảnh màn hình.",5, $Y1+60+ $YTAB + $Y2,170)
GUICtrlSetOnEvent(-1, "isSaveImgFromScreen")

Local $NicheCaptureImg =  _createRequiredInputText("", 180, $Y1+60+ $YTAB + $Y2, 160,"Niche", 60)

#comments-start

Local $chkFilterEmailGoogle = _createCheckbox("Lọc GG Emails: Ctrl+A. Ctrl+C. Shift+F để get mail.",5,$Y1 + 60 + $YTAB + $Y2, $XGUI- 2*$padSide)
GUICtrlSetOnEvent(-1, "IsFilterEmailGoolge")

GUICtrlCreateLabel('Vào inbox GG mail. Bôi đen và Shirt+R để xóa sent-bounce-email trong file (nhớ Unique line trước).',5,  $Y1 + 105 + $YTAB + $Y2,$XGUI,20)
Local $chooseListCampEMailBtn = _createButtonWithCursor ("Chọn file email chiến dịch", 3, $Y1 + 125 + $YTAB + $Y2, 135)
GUICtrlSetOnEvent(-1, "chooseListCampEMail")
Local $nameListCampEmailLbl = GUICtrlCreateLabel('',152,  $Y1 + 130 + $YTAB + $Y2,$XGUI,25)

Local $filterBounceMailBtn = _createButtonWithCursor ("Chọn bounced email file để lọc", 3, $Y1 + 150 + $YTAB + $Y2, 155)
GUICtrlSetOnEvent(-1, "filterBounceMail")
Local $nameBounceEmaiFilelLbl = GUICtrlCreateLabel('',165,  $Y1 + 160 + $YTAB + $Y2,$XGUI,25)

#comments-end

;====================== TAB2 Sunfrog ==================================================================
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

;----------TAB3----------
GUICtrlCreateTabItem("Sunfrog Spy")
GUISetFont(8.5)
Local $sunfrogKeyword =  _createRequiredInputText("", 5,  $YTAB + 5, 150,"Keyword", 25)
Local $sunfrogOffsetFrom =  _createRequiredInputText("", 175,  $YTAB + 5, 60,"PageFrom", 20)
Local $sunfrogOffsetTo =  _createRequiredInputText("", 255,  $YTAB + 5, 60,"PageTo", 20)
Local $sunfrogfilter =  _createComboBoxWithCursor("sales", 345,  $YTAB + 5, 80, 20)
GUICtrlSetFont(-1, 9.5)
GUICtrlSetData(-1, "new|popular|relevance", "new")
;Local $sunfrogCollectionID =  _createRequiredInputText("168608", 5,  $YTAB + 35, 110,"Collection ID", 20)
;GUICtrlCreateLabel("Để trống thì chỉ có SPY",140,  $YTAB + 35,110,40)
Local $spySunfrogBtn = _createButtonWithCursor("Spy", 435,  $YTAB + 5, 50)
GUICtrlSetOnEvent($spySunfrogBtn, "spySunfrog")

GUICtrlCreateLabel("Copy collection",5,  $YTAB + 35,80,40)
Local $copyCollectionHelpBtn = _createButtonWithCursor("?", 80,  $YTAB + 30, 30)
GUICtrlSetOnEvent($copyCollectionHelpBtn, "copyCollectionHelp")

Local $sunfrogCollectionItems =  _createRequiredEdit("", 5,  $YTAB + 55, 300,100,5000)
$sunfrogCollectionItemsHandle = GUICtrlGetHandle($sunfrogCollectionItems)
Local $sunfrogCollectionItemsFilter =  _createRequiredEdit("", 325,  $YTAB + 55, 300,100,5000)
$sunfrogCollectionItemsFilterHandle = GUICtrlGetHandle($sunfrogCollectionItemsFilter)
Local $sunfrogCollectionFilterBtn = _createButtonWithCursor("Get", 4,  $YTAB + 155, 50)
GUICtrlSetOnEvent(-1, "copyCollection")




GUICtrlCreateTabItem("") ; end tabitem definition

GuISetState(@SW_SHOW, $hGUI)

While 1
	Sleep(120)
WEnd

Func ExitApp()
   Local $oke = MsgBox($MB_ICONINFORMATION + $MB_OKCANCEL, "Exit App","Are you sure?")
   If $oke = 1 Then Exit
EndFunc