;Phím SPACE - String || S - long || X - Date

Func fixMode()
   Local $getDataFromClip = trim(ClipGet())

   If ($getDataFromClip == '') Then
	  MsgBox($MB_ICONERROR+262144+8192,"Error","Error Copy")
	  Return
   ElseIf StringInStr($getDataFromClip, @CR) Then
	  MsgBox($MB_ICONERROR+262144+8192,"Error","Error Copy")
	  Return
   EndIf

   ; An toàn nên xóa ()
   Local $str
   Local $IsMatchGetter = StringRegExp($getDataFromClip, '^get[A-Z].*')

   If $IsMatchGetter  <> 0 Then
	  $str = lowerFirstLetter(StringRight($getDataFromClip,StringLen($getDataFromClip)-3))
   Else
	  MsgBox($MB_ICONERROR+262144+8192,"Error","Error Copy")
	  Return
	  ;$str = lowerFirstLetter($getDataFromClip)
   EndIf

   $str = StringReplace($str,"()","")
   $str = StringReplace($str, $suffix,"")

   Local $sample = "hoSo.set" & $str & "(" & $str & ")"

   ConsoleWrite($sample)

   Local $IsSameField = StringInStr(FileRead($WorkingDir&"\fix-mode\fillData2Form.java"), $sample, 0)  ; 1 = ko phan biet hoa thuong

   If $IsSameField <> 0 Then
	   MsgBox($MB_ICONERROR+262144+8192,"Error","Field exists")
	   Return
   EndIf

   Local $form
   Local $valid
   Local $formTab
   Local $validTab

   Local $validRequired
   Local $validDate
   Local $validRequiredTab
   Local $validDateTab

   Local $alt

   If (StringInStr(@HotKeyPressed,"SPACE")) Then

	  ; fillData2Form
	  $form = fillData2FormString($str,"")
	  $formTab = fillData2FormString($str,$suffix)

	  ; validator
	  $valid = createValidateString('input *', $str, "")
	  $validTab = createValidateString('input *', $str, $suffix)

	  ; ALTER TABLE
	  $alt = 'ALTER TABLE XXXXXX MODIFY ' &$str &' VARCHAR(' & $maxLengthInput &');'

   Elseif(StringInStr(@HotKeyPressed,"s")) Then

	  ; fillData2Form
	  $form = fillData2FormLong("",$str,"")
	  $formTab = fillData2FormLong("",$str,$suffix)

	  ; validators
	  $valid = createValidateLong("long *",$str, "")
   	  $validTab = createValidateLong("long *",$str, $suffix)

	  ; alter table
	  $alt = 'ALTER TABLE XXXXXX MODIFY ' &$str &' DECIMAL;'

   ; Date field
   Elseif (StringInStr(@HotKeyPressed,"x")) Then

   ; write to fillData2Form      ; Entity hoSo
   $form =  fillData2FormDate($str,"")
   $formTab =  fillData2FormDate($str,$suffix)

   ;validators.txt
   $valid = createValidateDate(1,$str,"")
   $validTab = createValidateDate(1,$str,$suffix)

   $validDate = quote($str) & ","
   $validDateTab = quote($str & $suffix) & ","

   ; alter table
   $alt = 'ALTER TABLE XXXXXX MODIFY ' &$str &' datetime;'

   EndIf
   ; write to arrRequired.txt
   $validRequired = quote($str) & ","
   $validRequiredTab = quote($str & $suffix) & ","

   FileWriteLine($FillData2Form, $form)
   FileWriteLine($Validator, $valid)
   FileWriteLine($FillData2FormTab, $formTab)
   FileWriteLine($ValidatorTab, $validTab)

   FileWrite($arrRequired, $validRequired)
   FileWrite($arrDate, $validDate)
   FileWrite($arrRequiredTab, $validRequiredTab)
   FileWrite($arrDateTab, $validDateTab)

   FileWriteLine($alter,$alt)

   ClipPut($str)
EndFunc

Func CloseFileFixMode()
   FileClose($FillData2Form)
   FileClose($Validator)
   FileClose($FillData2FormTab)
   FileClose($ValidatorTab)

   FileClose($arrRequired)
   FileClose($arrDate)
   FileClose($arrRequiredTab)
   FileClose($arrDateTab)

   FileClose($alter)
EndFunc


Func SendSuffix()
   Send($suffix)
EndFunc


