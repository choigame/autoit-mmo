#include "utils.au3"
#include <GDIPlus.au3>
#include <ScreenCapture.au3>

Func GetTagsTeespring()

Local $idInfoitem = GUICtrlCreateMenuItem("Info", $idHelpmenu)
Local $idExititem = GUICtrlCreateMenuItem("Exit", $idFilemenu)
Local $idRecentfilesmenu = GUICtrlCreateMenu("Recent Files", $idFilemenu, 1)

GUICtrlCreateMenuItem("", $idFilemenu, 2) ; create a separator line
   Local $input = GUICtrlRead($div)
   Local $determite = GUICtrlRead($combox)

    Local $isCopy = GUICtrlRead($chkTagsTeespring)

   $input = StringRegExpReplace($input , '\s{2,}' , ' ')
   $input = StringRegExpReplace($input , $RegexTagsTeespring , '')
   $input = StringRegExpReplace($input , '\s{2,}' , $determite)
   $input = StringReplace($input , 'Tags' , '')
   $input = StringTrimLeft($input,1)
   $input = StringTrimRight($input,2)

   if $isCopy == 1 then ClipPut($input)

   GUICtrlSetData($div,$input)
EndFunc

Func FilterEmailGoogle()

	Local $input = trim(ClipGet())

	if(StringLen($input)==0) then
		MsgBox($MB_ICONWARNING+262144+8192,"Info","Please copy")
		return
	EndIf

	local $key = StringRegExp($input, '(\s{3,}(.*)\s{3,})' , 2)
	if @error > 0 Then
		MsgBox($MB_ICONERROR+262144+8192,"Error","Invalid Copy")
		Return
	EndIf

	$key = trim($key[0])

	Local $Emails = StringRegExp($input, $RegexEmail, 3)
	if @error > 0 or (UBound($Emails) == 0) Then
		MsgBox($MB_ICONERROR+262144+8192,"Error","Invalid Copy Or Emails = 0")
		Return
	EndIf

	Local $PathFile = @ScriptDir & "\" & $ROOTMAIL & "\" & $key & ".csv"

   Local $CSV = ""
   if Not FileExists($PathFile) Then
	  $CSV = FileOpen($PathFile, 1+8)
	  FileWriteLine($CSV, $key)
   EndIf

   $CSV = FileOpen($PathFile, 1+8)

	For $i = 0 to UBound($Emails) -1
		FileWriteLine($CSV,$Emails[$i])
	Next

	FileClose($CSV)
EndFunc


Func IsFilterEmailGoolge()

	Local $check = GUICtrlRead($chkFilterEmailGoogle)
	if $check==1 Then
		HotKeySet("+f","FilterEmailGoogle")
	Else
		HotKeySet("+f")
	EndIf
 EndFunc

 Func IsSaveImgFromScreen()

	Local $check = GUICtrlRead($chkSaveImgFromScreen)
	if $check==1 Then
		HotKeySet("+c","SaveImgFromScreen")
	Else
		HotKeySet("+c")
	EndIf
 EndFunc


 Func SaveImgFromScreen()
   Local $fileName = TimerInit() & "_Screen_Img.jpg"
   Local $path = @ScriptDir  & "\" &  $ROOTIMG & "\" & $fileName

   Local $tempPath = @MyDocumentsDir & "\" & $fileName

   Local $Xcenter = @DesktopWidth/2
   Local $Ycenter = @DesktopHeight/2

   Local $save = _ScreenCapture_Capture("", $ImgScreenX1, $ImgScreenY1, $ImgScreenX2, $ImgScreenY2)
    _ScreenCapture_SaveImage($tempPath, $save)

   FileMove($tempPath , $path , $FC_OVERWRITE + $FC_CREATEPATH)

EndFunc


