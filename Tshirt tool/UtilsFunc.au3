#include "utils.au3"
#include <GDIPlus.au3>
#include <ScreenCapture.au3>
#include <File.au3>

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

Func chooseListCampEMail()
  local $file = FileOpenDialog("CSV,TXT",@ScriptDir,"(*.csv;*.txt)|(*.xlsx)", $FD_FILEMUSTEXIST)

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

	  FileCopy($ListCampEmailPath,'BackUp_' &$name , 8)
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
   Local $FoundEmails = StringRegExp($input, 'To: (.+) \(2\)', 3)

   If @error > 0 Then
		MsgBox($MB_ICONERROR+262144+8192,"Error","Invalid Copy")
		Return
	 EndIf

  For $j= 0 to UBound($FoundEmails) - 1
	  For $i = 1 to _FileCountLines($ListCampEmailPath)
		 If StringInStr(FileReadLine($ListCampEmailPath,$i), $FoundEmails[$j]) Then
			_FileWriteToLine($ListCampEmailPath,$i, "", True)
		 EndIf
	  Next
  Next

#comments-start
   Local $emailList = FileRead($hFile)

   FileClose($hFile)
   local $regex = ""
   For $i= 0 to UBound($FoundEmails) - 1
	   $regex = "^.*"&$FoundEmails[$i]&".*$"
	  $emailList=StringRegExpReplace($emailList, $regex , "")
	 Next

   $emailList = StringRegExpReplace($emailList,"^\n","")

   Local $PathOuputFile = StringReplace($ListCampEmailPath,".txt","")
   $PathOuputFile = StringReplace($PathOuputFile,".csv","")
   $PathOuputFile = StringReplace($PathOuputFile,".xlsx","")

   Local $date = getDateTimeReport()
   $PathOuputFile &= '_RemoveBounce_'& $date &'.csv'

   Local $hOut = FileOpen($PathOuputFile,10)
   FileWrite($hOut,$emailList)

   FileClose($hOut)
   #comments-end
EndFunc




