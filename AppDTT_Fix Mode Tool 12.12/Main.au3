#include-once

#include <import\service.au3>
#include <import\MessageBox.au3>
#include <import\utils.au3>
#include <import\GlobalVar.au3>
#include <import\utilsGui.au3>
#include <import\onEventFunc.au3>
#include <import\FixMode.au3>
#include <TrayConstants.au3>

Opt("GUIOnEventMode", 1) ; Change to OnEvent mode
Opt("TrayIconHide", 0)

HotKeySet("^+f", "openWorkingFolder")
HotKeySet("^+e", "endSessionWork")
HotKeySet("`", "toogleOnOff")
HotKeySet("{esc}", "closeApp")

Global $Toogle = True
Global $NewSession = False

chooseWriteMode()

chooseFixMode()
chooseFixModeTab()


While 1
    Sleep(37) ; Sleep to reduce CPU usage
WEnd

Func toogleOnOff()

   If $NewSession Then
	  chooseFixMode()
	  chooseFixModeTab()
	  $NewSession = False
	  TrayTip("", "Start New Session", 2, $TIP_ICONASTERISK ) ; Warning icon
	  Return
   EndIf

   $Toogle = Not $Toogle
   If $Toogle Then
	  HotKeySet("{tab}", SendSuffix)

	  HotKeySet("{SPACE}", fixMode)
	  HotKeySet("s", fixMode)
	  HotKeySet("x", fixMode)
	  TrayTip("", "Toogle : ON", 2, $TIP_ICONASTERISK) ; Warning icon
   Else
	  HotKeySet("{tab}")

	  HotKeySet("{SPACE}")
	  HotKeySet("s")
	  HotKeySet("x")
	  TrayTip("", "Toogle : OFF", 2, $TIP_ICONASTERISK ) ; Warning icon
   EndIf
EndFunc

Func endSessionWork()
   Local $isYes = MsgBox($MB_OKCANCEL+262144+8192, "End This Session?", "Yes No?")
   If($isYes=1) then
	  CloseFileFixMode()
	  HotKeySet("{SPACE}")
	  HotKeySet("s")
	  HotKeySet("x")
	  HotKeySet("{tab}")
	  $Toogle = True
	  $NewSession = True
	  TrayTip("", "End This Session", 2, $TIP_ICONASTERISK ) ; Warning icon
   EndIf
EndFunc


Func closeApp()
   Local $isYes = MsgBox($MB_OKCANCEL+262144+8192, "Thoát", "Đồng ý?")
   if($isYes=1) then Exit
EndFunc   ;==>closeApp

Func chooseWriteMode()
	$modeWrite = 10+$utf8
EndFunc

Func chooseFixModeTab()
   HotKeySet("{tab}", SendSuffix)
EndFunc

Func chooseFixMode()
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

EndFunc

Func openWorkingFolder()
	Run("explorer.exe "&@ScriptDir)
EndFunc