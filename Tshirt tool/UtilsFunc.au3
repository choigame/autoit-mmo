#include "utils.au3"
#include <GDIPlus.au3>
#include <ScreenCapture.au3>
#include <File.au3>

Func GetTagsTeespring()

   Local $input = trim(GUICtrlRead($div))
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

Func MakeHashTags()

   Local $isCopy = GUICtrlRead($chkTagsTeespring)

   Local $output
   Local $input = trim(GUICtrlRead($div))
   $input = StringRegExpReplace($input, '\s{1,}' , '')
   $input = StringLower($input)

   If StringInStr($input,"|") Then
	  $output = makeHashTagWithDetermite($input, "|")
   ElseIf StringInStr($input,",") Then
	  $output = makeHashTagWithDetermite($input, ",")
   Else
	  MsgBox($MB_ICONERROR+262144+8192,"Error","Invalid Input Determite")
   EndIf

    if $isCopy == 1 then ClipPut($output)

   GUICtrlSetData($div, $output)

EndFunc

Func makeHashTagWithDetermite($input, $determite)
   Local $output
   Local $array = StringSplit($input, $determite)

   For $i=1 To $array[0]
	  Local $hashTag = $array[$i]
	  $output &=  "#" & $hashTag & " "
   Next

   Return trim($output)
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
   Local $niche = trim(GUICtrlRead($NicheCaptureImg))
   If $niche = '' Then
	  MsgBox($MB_ICONERROR+262144+8192,"Error","Invalid Niche Input")
	  Return
   EndIf


   Local $fileName = $niche &  "_" & TimerInit() & ".jpg"
   Local $path = @ScriptDir  & "\" &  $ROOTIMG & "\" & $niche & "\" &$fileName

   Local $tempPath = @MyDocumentsDir & "\" & $fileName

   Local $Xcenter = @DesktopWidth/2
   Local $Ycenter = @DesktopHeight/2

   Local $save = _ScreenCapture_Capture("", $ImgScreenX1, $ImgScreenY1, $ImgScreenX2, $ImgScreenY2)
    _ScreenCapture_SaveImage($tempPath, $save)

   FileMove($tempPath , $path , $FC_OVERWRITE + $FC_CREATEPATH)

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



Func chooseListCampEMail()
  local $file = FileOpenDialog("Campain List Of Mail", @ScriptDir & '\' ,"(*.csv;*.txt)|(*.xlsx)", $FD_FILEMUSTEXIST)

   if (@error == 1) Then
	  $ListCampEmail = ''
	  HotKeySet("+r")
	  GUICtrlSetData($nameListCampEmailLbl,"")
	  return;

   ElseIf (@error = 0) then

	  $ListCampEmailPath = $file

	  HotKeySet("+r","removeBounceMailListCampEmail")

	  Local $name = getFileNameFromPath($file)

	  GUICtrlSetData($nameListCampEmailLbl,$name)

	  FileCopy($ListCampEmailPath,'BUp_' & getDateTimeReport() &$name , 8)
   EndIf
EndFunc

Func removeBounceMailListCampEmail()

   if Not $ListCampEmailPath then
		MsgBox($MB_ICONWARNING+262144+8192,"Error","Choose file first.")
		return
   EndIf

   Local $input = trim(ClipGet())

   if(StringLen($input)==0) then
		MsgBox($MB_ICONWARNING+262144+8192,"Error","Copy carefully.")
		return
   EndIf

   ;To: admon.anglo (2)
   Local $BouncedEmails = StringRegExp($input, $RegexEmail, 3)

   If @error > 0 Then
		MsgBox($MB_ICONERROR+262144+8192,"Error","Invalid Copy")
		Return
	 EndIf

   HotKeySet("+r")

   Local $pathBounceMailFile = 'bounces_emails' & $BounceMailFileExt
   Local $hBounceMailsFile = FileOpen( $pathBounceMailFile , 1 + 8)

   For $j= 0 to UBound($BouncedEmails) - 1
	  For $i = 1 to _FileCountLines($ListCampEmailPath)
		 local $bounceEmail = $BouncedEmails[$j]
		 If StringInStr(FileReadLine($ListCampEmailPath,$i), $bounceEmail) Then
			_FileWriteToLine($ListCampEmailPath,$i, "", True)
			sleep(14)
			FileWriteLine($hBounceMailsFile, $bounceEmail)

			;Tim dc 1 cai la break cho nhanh. vi muc dich lay bouncemail. sau nay con filter voi file bounce_mail lan nua (dc AFK).
			ExitLoop
		 EndIf
	  Next
   Next

   FileClose($hBounceMailsFile)
   HotKeySet("+r","removeBounceMailListCampEmail")
   MsgBox($MB_ICONERROR+262144+8192,"Info", "Removing Bounced Emails Finish")

EndFunc

Func filterBounceMail()
   local $fileCampMail = FileOpenDialog("Campain List Of Mail", @ScriptDir & '\',"(*.csv;*.txt)|(*.xlsx)", $FD_FILEMUSTEXIST)

   if (@error == 1) Then
	  GUICtrlSetData($nameListCampEmailLbl , "")
	  return;
   EndIf

   local $fileBouncemail = FileOpenDialog("Bounce Email File", @ScriptDir & '\',"(*"&$BounceMailFileExt&")", $FD_FILEMUSTEXIST)

   if (@error == 1) Then
	  GUICtrlSetData($nameBounceEmaiFilelLbl , "")
	  return;
   EndIf

   Local $nameCampMailFile = getFileNameFromPath($fileCampMail)

   GUICtrlSetData($nameListCampEmailLbl,$nameCampMailFile)

   FileCopy($fileCampMail,'BUp_' & getDateTimeReport() &$nameCampMailFile , 8)

   $name = getFileNameFromPath($fileBouncemail)
   GUICtrlSetData($nameBounceEmaiFilelLbl , $name & "... Running")

	For $i = 1 to _FileCountLines($fileBouncemail)
		 local $bounceEmail = FileReadLine($fileBouncemail,$i)
		 For $j= 1 to _FileCountLines($fileCampMail)
			   If StringInStr(FileReadLine($fileCampMail,$j), $bounceEmail) Then
			   _FileWriteToLine($fileCampMail,$j, "", True)
			EndIf
		 Next
	  Next


   $nameBounceEmaiFilelLbl=""
   GUICtrlSetData($nameBounceEmaiFilelLbl , "")

   MsgBox($MB_ICONERROR+262144+8192,"Info", "Removing Bounced Emails Finish")

EndFunc





