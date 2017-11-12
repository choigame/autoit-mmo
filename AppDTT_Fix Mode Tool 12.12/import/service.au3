#include-once

#include <String.au3>
#include <File.au3>
#include <GlobalVar.au3>

Global $pathPrefix

Func createColumnStr()
   if($serviceFilePath='') Then
	  MsgBox($MB_ICONERROR+262144+8192,$ErrorDiaglogTitle,"Create Entity First!")
	  Return
   EndIf

   Local $str = trim(GUICtrlRead($colNameStr,0))

   If (StringLower($str) == 'string') Then
	  MsgBox($MB_ICONERROR+262144+8192, $ErrorDiaglogTitle, "Trùng từ khóa")
	  Return
   EndIf

   If Not (isRequiredInputField($str,"Column String",$colNameStr)) Then Return
   If Not (isCharAndDigistAnd_($str,"Column String",$colNameStr)) Then return
   IF NOT (checkRequiredLine($serviceFilePath,$str)) Then Return

   Local $hFileOpen = FileOpen($serviceFilePath, 9) ;2+8 : create if not exist and write override. Theo mode cua createEntity phia duoi
   Local $hFileOpen2 = FileOpen($dbscriptFilePath, 9)
   Local $hFileOpen3 = FileOpen($idListFilePath, 9)
   Local $hFileOpen4 = FileOpen($fillData2FormFilePath, 9)
   Local $hFileOpen5 = FileOpen($validatorFilePath, 9)
   Local $hFileOpen6 = FileOpen($reviewFilePath, 9)
   Local $hFileOpen7 = FileOpen($alterFilePath, 9)

   Local $hFileOpen10 = FileOpen($registryFilePath, 9)

   ;TAB
   Local $hFileOpen11 = FileOpen($fillData2FormFilePathTAB, 9)
   Local $hFileOpen12 = FileOpen($validatorFilePathTAB, 9)

   Local $hFileOpen15 = FileOpen($registryFilePathTAB, 9)

   Local $select = GUICtrlRead($strComboBox)

   $str = lowerFirstLetter($str)

   Local $path = @ScriptDir & $jspFolderTemplate
   Local $hand

   Local $content1 = "<column name=" &'"'&$str&'" ' & "db-name=" &'"' & $str&'" ' &"type="&'"'&"String"&'"/>';

   GUICtrlSetData($resultCreateColumn1,"Done")
   GUICtrlSetData($resultCreateColumn2,"")
   GUICtrlSetData($resultCreateColumn3,"")
   GUICtrlSetData($textFieldService,GUICtrlRead($textFieldService,0)&@CRLF&$content1)

   ; write to DBscript
   Local $content2 = $str & ' varchar('&$maxLengthInput&'),'

   If(StringInStr($select,"lgTextarea")) then
	  $content2 = $str & ' varchar('&$maxlengthTextArea*2&'),'
   ElseIf(StringInStr($select,"textarea")) then
	  $content2 = $str & ' varchar('&$maxlengthTextArea&'),'
   EndIf

   ; write to listID
   Local $content3 = "String" & " " & $str

   ; write to fillData2Form + fillData2FormTab
   Local $content4 =  fillData2FormString($str,"")
   Local $content11 =  fillData2FormString($str,$suffix)

   ;write to validator.txt va validatorTAB.txt
   Local $content5 = createValidateString($select,$str,'')
   Local $content12 = createValidateString($select, $str, $suffix)

   ;review
   If StringInStr($select,'textarea') Then
	  $hand = FileOpen($path & $reviewStringTextArea)
   Else
	  $hand = FileOpen($path & $reviewString)
   EndIf

   If ($hand == -1) Then
	  MsgBox($MB_ICONERROR+262144+8192, $ErrorDiaglogTitle, $reviewString & " Not found!")
   EndIf

   Local $content6 = FileRead($hand)
		 $content6 = StringReplace($content6, "TYPEBYTAN", $select)
		 $content6 = StringReplace($content6, "UPPERFIRSTLETTER", upperFirstLetter($str)) &@CRLF &@CRLF

   ;alter.txt
   Local $content7 = 'alter table ' &$tableSql &' modify '&$str

   If StringInStr($select, 'lgTextarea') Then
	  $content7 &= ' varchar('&$maxlengthTextArea * 2 &');'
   ElseIf StringInStr($select, 'textarea') Then
	  $content7 &= ' varchar('& $maxlengthTextArea &');'
   Else
	  $content7 &= ' varchar('&$maxLengthInput&');'
   EndIf

   ;$arrRequiredValidate

   if(StringInStr($select,"*")) Then
	  $arrRequiredValidate &= quote($str) & ","
	  $arrRequiredValidateTab &= quote($str&$suffix) & ","
   EndIf

   If(StringInStr($select,"cmnd")) Then
	  $arrCMNDValidate &= quote($str) & ","
	  $arrCMNDValidateTab &= quote($str&$suffix) & ","
   EndIf

   If(StringInStr($select,"email")) Then
	  $arrEmailValidate &= quote($str) & ","
	  $arrEmailValidateTab &= quote($str&$suffix) & ","
   EndIf

   If(StringInStr($select,"phone")) Then
	  $arrPhoneValidate &= quote($str) & ","
	  $arrPhoneValidateTab &= quote($str&$suffix) & ","
   EndIf

   ;registryForm.txt + registryFormTAB.txt
   Local $content10 = registryFormString($select,$str,"")
   Local $content15 = registryFormString($select,$str,$suffix)

   FileWriteLine($hFileOpen,$content1)
   FileWriteLine($hFileOpen2,$content2)
   FileWriteLine($hFileOpen3,$content3)
   FileWriteLine($hFileOpen4,$content4)
   FileWriteLine($hFileOpen5,$content5)
   FileWriteLine($hFileOpen6,$content6)
   FileWriteLine($hFileOpen7,$content7)

   FileWrite($hFileOpen10,$content10)

   FileWriteLine($hFileOpen11,$content11)
   FileWriteLine($hFileOpen12,$content12)

   FileWriteLine($hFileOpen15,$content15)

   FileClose($hFileOpen)
   FileClose($hFileOpen2)
   FileClose($hFileOpen3)
   FileClose($hFileOpen4)
   FileClose($hFileOpen5)
   FileClose($hFileOpen6)
   FileClose($hFileOpen7)
   FileClose($hFileOpen10)

   FileClose($hFileOpen11)
   FileClose($hFileOpen12)
   FileClose($hFileOpen15)

   GUICtrlSetData($colNameStr,"")

   ;add content and scroll down
   _GUICtrlEdit_Scroll($textFieldService, $SB_SCROLLCARET)
EndFunc

Func registryFormString($select,$str,$suffix)

   Local $content10 = ''

   If ($select == "input *") OR ($select == "email *") Then
	  $content10 = _registryFormString($str,$suffix,1,$registryStringInput)
   ElseIf ($select == "input")  OR ($select == "email") Then
	  $content10 = _registryFormString($str,$suffix,0,$registryStringInput)
   ElseIf ($select == "upper *")   Then
	  $content10 = _registryFormString($str,$suffix,1,$registryStringUpper)
   ElseIf ($select == "upper")   Then
	  $content10 = _registryFormString($str,$suffix,0,$registryStringUpper)
   ElseIf $select == "cmnd *" Then
	  $content10 = _registryFormString($str,$suffix,1,$registryStringCmnd)
   ElseIf $select == "cmnd" Then
	  $content10 = _registryFormString($str,$suffix,0,$registryStringCmnd)
   ElseIf $select == "phone *" Then
	  $content10 = _registryFormString($str,$suffix,1,$registryStringPhone)
   ElseIf $select == "phone" Then
	  $content10 = _registryFormString($str,$suffix,0,$registryStringPhone)
   ElseIf $select == "numFormat *" Then
	  $content10 = _registryFormString($str,$suffix,1,$registryStringNumFormat)
   ElseIf $select == "numFormat" Then
	  $content10 = _registryFormString($str,$suffix,0,$registryStringNumFormat)
   ElseIf $select == "floatFormat *" Then
	  $content10 = _registryFormString($str,$suffix,1,$registryStringFloatFormat)
   ElseIf $select == "floatFormat" Then
	  $content10 = _registryFormString($str,$suffix,0,$registryStringFloatFormat)
   ElseIf $select == "onlyNumeric *" Then
	  $content10 = _registryFormString($str,$suffix,1,$registryStringNumeric)
   ElseIf $select == "onlyNumeric" Then
	  $content10 = _registryFormString($str,$suffix,0,$registryStringNumeric)
   ElseIf $select == 'textarea *' Then
	  $content10 = _registryFormString($str,$suffix,1,$registryStringTextArea)
   ElseIf  $select == 'textarea' Then
	  $content10 = _registryFormString($str,$suffix,0,$registryStringTextArea)
   ElseIf $select == 'lgTextarea *' Then
	  $content10 = _registryFormString($str,$suffix,1,$registryStringLgTextArea)
   ElseIf  $select == 'lgTextarea' Then
	  $content10 = _registryFormString($str,$suffix,0,$registryStringLgTextArea)
   EndIf

   Return $content10&@CRLF&@CRLF
EndFunc

Func _registryFormString($str, $suffix, $isRequired, $fileName)

   Local $path = @ScriptDir & $jspFolderTemplate & "create service" & "\registry string\"
   Local $hand = FileOpen($path&$fileName)

   If ($hand == -1) Then
	  MsgBox($MB_ICONERROR+262144+8192, $ErrorDiaglogTitle, $fileName & " Not found!")
   EndIf

   Local $value = FileRead($hand)
		 $value = StringReplace($value,"NAMEBYTAN",$str&$suffix)
		 $value = StringReplace($value,"LARGEMAXLENGTHTEXTAREABYTAN",$maxlengthTextArea*2)
		 $value = StringReplace($value,"MAXLENGTHTEXTAREABYTAN",$maxlengthTextArea)
		 $value = StringReplace($value,"MAXLENGTHBYTAN",$maxLengthInput)
		 $value = StringReplace($value,"UPPERFIRSTLETTER",upperFirstLetter($str))

   If NOT ($isRequired == 1)Then  Return StringReplace($value,'<label class="egov-label-red">*</label>','')

   Return $value
EndFunc

Func fillData2FormString($str,$suffix)
   Local $a = '// '&$str&$suffix &' - String '&@CRLF& _
		'String '&$str&' = ParamUtil.getString(request,'&quote($str&$suffix)&').trim();' &@CRLF& _
		'hoSo.set' & upperFirstLetter($str) & '('&$str&');'  &@CRLF&@CRLF
   Return $a
EndFunc

Func createValidateString($select,$str,$suffix)
   ; $select - choose from dropBox || $str & $suffix - fieldName of entity || $suffix - fieldName + 'TAB'
   ; numFormat (*) | floatFormat (*)   : chua lam
   ; upperCase (*)                   : ko can thiet

   Local $path = @ScriptDir & $jspFolderTemplate & "create service" & "\validate string\"
   Local $hand
   Local $value = ''

   if($select == 'cmnd *')  Then
	  $hand = FileOpen($path & $validateStringCmnd)
	  If ($hand == -1) Then
		 MsgBox($MB_ICONERROR+262144+8192, $ErrorDiaglogTitle, $validateStringCmnd & " Not found!")
	  EndIf

	  Local $value = FileRead($hand)
			$value = StringReplace($value,"TYPEBYTAN",$select)
			$value = StringReplace($value,"NAMEBYTAN",$str&$suffix)
			$value = StringReplace($value,"REPLACEIFREQUIRED",requiredValidate($str&$suffix))

   ElseIf ($select == 'cmnd') then
	  $hand = FileOpen($path & $validateStringCmnd)

	  If ($hand == -1) Then
		 MsgBox($MB_ICONERROR+262144+8192, $ErrorDiaglogTitle, $validateStringCmnd & " Not found!")
	  EndIf

	  Local $value = FileRead($hand)
			$value = StringReplace($value,"TYPEBYTAN",$select)
			$value = StringReplace($value,"NAMEBYTAN",$str&$suffix)
			$value = StringReplace($value,"REPLACEIFREQUIRED","")

   ElseIf      ($select == 'textarea *') _
			OR ($select == 'lgTextarea *') _
			OR ($select == 'input *') _
			OR ($select == 'numFormat *') _
			OR ($select == 'onlyNumeric *') _
			OR ($select == 'floatFormat *') _
			OR ($select == 'upper *') Then

	  $hand = FileOpen($path & $validateStringInput)

	  If ($hand == -1) Then
		 MsgBox($MB_ICONERROR+262144+8192, $ErrorDiaglogTitle, $validateStringInput & " Not found!")
	  EndIf

	  Local $value = FileRead($hand)
			$value = StringReplace($value,"TYPEBYTAN",$select)
			$value = StringReplace($value,"NAMEBYTAN",$str&$suffix)

   ElseIf ($select == 'phone *') then
	  $hand = FileOpen($path & $validateStringPhone)
	  If ($hand == -1) Then
		 MsgBox($MB_ICONERROR+262144+8192, $ErrorDiaglogTitle, $validateStringPhone & " Not found!")
	  EndIf

	  Local $value = FileRead($hand)
			$value = StringReplace($value,"TYPEBYTAN",$select)
			$value = StringReplace($value,"NAMEBYTAN",$str&$suffix)
			$value = StringReplace($value,"REPLACEIFREQUIRED",requiredValidate($str&$suffix))

   ElseIf ($select == 'phone') Then
	  $hand = FileOpen($path & $validateStringPhone)
	  If ($hand == -1) Then
		 MsgBox($MB_ICONERROR+262144+8192, $ErrorDiaglogTitle, $validateStringPhone & " Not found!")
	  EndIf

	  Local $value = FileRead($hand)
			$value = StringReplace($value,"TYPEBYTAN",$select)
			$value = StringReplace($value,"NAMEBYTAN",$str&$suffix)
			$value = StringReplace($value,"REPLACEIFREQUIRED", "")

   ElseIf ($select == 'email *') then
	  $hand = FileOpen($path & $validateStringEmail)
	  If ($hand == -1) Then
		 MsgBox($MB_ICONERROR+262144+8192, $ErrorDiaglogTitle, $validateStringEmail & " Not found!")
	  EndIf

	  Local $value = FileRead($hand)
			$value = StringReplace($value,"TYPEBYTAN",$select)
			$value = StringReplace($value,"NAMEBYTAN",$str&$suffix)
			$value = StringReplace($value,"REPLACEIFREQUIRED",requiredValidate($str&$suffix))

   ElseIf ($select == 'email') Then
	  $hand = FileOpen($path & $validateStringEmail)
	  If ($hand == -1) Then
		 MsgBox($MB_ICONERROR+262144+8192, $ErrorDiaglogTitle, $validateStringEmail & " Not found!")
	  EndIf

	  Local $value = FileRead($hand)
			$value = StringReplace($value,"TYPEBYTAN",$select)
			$value = StringReplace($value,"NAMEBYTAN",$str&$suffix)
			$value = StringReplace($value,"REPLACEIFREQUIRED", "")
   EndIf

   Return $value & @CRLF & @CRLF
EndFunc

;======>  Date field ------------------------------------------------------------------------------------

Func createColumnDate()

   if($serviceFilePath='') Then
	  MsgBox($MB_ICONERROR+262144+8192,$ErrorDiaglogTitle,"Create Entity First!")
	  Return
   EndIf

   Local $str = trim(GUICtrlRead($colNameDate,0))

   If (StringLower($str) == 'date') Then
	  MsgBox($MB_ICONERROR+262144+8192,$ErrorDiaglogTitle,"Trùng từ khóa")
	  Return
   EndIf

   If Not (isRequiredInputField($str,"Column Date",$colNameDate)) Then Return
   If Not (isCharAndDigistAnd_($str,"Column Date",$colNameDate)) Then return
   If NOT (checkRequiredLine($serviceFilePath,$str)) Then Return

   Local $hFileOpen = FileOpen($serviceFilePath, 9)   			;1+8 : create if not exist and write override
   Local $hFileOpen2 = FileOpen($dbscriptFilePath, 9)
   Local $hFileOpen3 = FileOpen($idListFilePath, 9)
   Local $hFileOpen4 = FileOpen($fillData2FormFilePath, 9)
   Local $hFileOpen5 = FileOpen($validatorFilePath, 9)
   Local $hFileOpen6 = FileOpen($reviewFilePath, 9)

   Local $hFileOpen10 = FileOpen($registryFilePath, 9)

   ;TAB
   Local $hFileOpen11 = FileOpen($fillData2FormFilePathTAB, 9)
   Local $hFileOpen12 = FileOpen($validatorFilePathTAB, 9)

   Local $hFileOpen15 = FileOpen($registryFilePathTAB, 9)

   Local $isRequired = GUICtrlRead($checkDateRequired)

   Local $path = @ScriptDir & $jspFolderTemplate
   Local $hand

   $str = lowerFirstLetter($str)



   Local $content1 = "<column name=" &'"'&$str&'" ' & "db-name=" &'"' & $str&'" ' &"type="&'"'&"Date"&'"/>';
   GUICtrlSetData($resultCreateColumn3,"Done")
   GUICtrlSetData($resultCreateColumn2,"")
   GUICtrlSetData($resultCreateColumn1,"")
   GUICtrlSetData($textFieldService,GUICtrlRead($textFieldService,0)&@CRLF&$content1)

   ; write to DBscript
   Local $content2 = $str & " " & " datetime,"

   ; write to listID
   Local $content3 = "Date" & " " & $str

   ; write to fillData2Form      ; Entity hoSo
   Local $content4 = fillData2FormDate($str,"")
   Local $content11 = fillData2FormDate($str,$suffix)

   ; write to validator.txt va validatorTAB.txt
   Local $content5 = createValidateDate($isRequired,$str,"")
   Local $content12 = createValidateDate($isRequired,$str,$suffix)

   ;requiredValidate
   If $isRequired == 1 Then
	  $arrRequiredValidate &= quote($str) & ","
	  $arrRequiredValidateTab &= quote($str&$suffix) & ","
   EndIf

   ;arrDate.txt
   $arrDateValidate &= quote($str) &","
   $arrDateValidateTab &= quote($str&$suffix) &","

   GUICtrlSetState($checkDateRequired,$GUI_CHECKED)

   ;review
   $hand = FileOpen($path&$reviewDate)

   If ($hand == -1) Then
	  MsgBox($MB_ICONERROR+262144+8192,$ErrorDiaglogTitle,$reviewDate&" Not found!")
   EndIf

   Local $content6 = FileRead($hand)
		 $content6 = StringReplace($content6,"REQUIREDBYTAN",$isRequired == 1 ? "*" : "")
		 $content6 = StringReplace($content6,"UPPERFIRSTLETTER",upperFirstLetter($str)) &@CRLF &@CRLF

   ;registry Form
   Local $content10 = registryFormDate($str,"",$isRequired)
   Local $content15 = registryFormDate($str,$suffix,$isRequired)

   FileWriteLine($hFileOpen,$content1)
   FileWriteLine($hFileOpen2,$content2)
   FileWriteLine($hFileOpen3,$content3)
   FileWriteLine($hFileOpen4,$content4)
   FileWriteLine($hFileOpen5,$content5)
   FileWriteLine($hFileOpen6,$content6)

   FileWriteLine($hFileOpen10,$content10)

   FileWriteLine($hFileOpen11,$content11)
   FileWriteLine($hFileOpen12,$content12)

   FileWriteLine($hFileOpen15,$content15)

   FileClose($hFileOpen)
   FileClose($hFileOpen2)
   FileClose($hFileOpen3)
   FileClose($hFileOpen4)
   FileClose($hFileOpen5)
   FileClose($hFileOpen6)

   FileClose($hFileOpen10)

   ;Tab
   FileClose($hFileOpen11)
   FileClose($hFileOpen12)

   FileClose($hFileOpen15)

   GUICtrlSetData($colNameDate,"")
   ;add content and scroll down
   _GUICtrlEdit_Scroll($textFieldService, $SB_SCROLLCARET)
EndFunc

Func registryFormDate($str,$suffix,$isRequired)

   Local $path = @ScriptDir & $jspFolderTemplate
   Local $hand = FileOpen($path&$registryDateInput)

   If ($hand == -1) Then
	  MsgBox($MB_ICONERROR+262144+8192,$ErrorDiaglogTitle,$registryDateInput&" Not found!")
   EndIf

   Local $value = FileRead($hand)
		 $value = StringReplace($value,"NAMEBYTAN",$str&$suffix)
		 $value = StringReplace($value,"UPPERFIRSTLETTER",upperFirstLetter($str))

   If NOT ($isRequired == 1) Then Return StringReplace($value,'<label class="egov-label-red">*</label>','')

   Return $value &@CRLF & @CRLF

EndFunc

Func fillData2FormDate($str,$suffix)

   Local $value = '// '&$str&$suffix&' - Date' &@CRLF& _
				'String '&$str&' = ParamUtil.getString(request,'&quote($str&$suffix)&');' &@CRLF& _
				'if('&$str&'.length()>0)' &@CRLF& _
				'hoSo.set' & upperFirstLetter($str) & '(ActionUtils.parseStringToDate('&$str&'));'

   Return $value & @CRLF & @CRLF

EndFunc

Func createValidateDate($isRequired,$str,$suffix)

   Local $a  = '' , $t = ''
   if($isRequired == 1) then $t = "*"

   $a = '//'&$str&$suffix&' - Date '&$t &@CRLF& _
		 'String '&$str&$suffix&' = ParamUtil.getString(request, '&quote($str&$suffix)&').trim();'

   If($isRequired == 1) Then
	  $a &= @CRLF & 'if ('&$str&$suffix&'.length() == 0) {' &@CRLF& _
		 'SessionErrors.add(request, '&quote($str&$suffix)&');' &@CRLF& _
		 'valid = false;' &@CRLF& _
	  '} else {'
   EndIf

   $a &= @CRLF & 'try {' &@CRLF& _
	  'if ('&$str&$suffix&'.length() > 0 && ActionUtils.compareTwoDates('&$str&$suffix&', today, "dd/MM/yyyy") > 0) {' &@CRLF& _
			'SessionErrors.add(request, '&quote($str&$suffix)&' + "lonHonHienTai");' &@CRLF& _
			'valid = false;' &@CRLF& _
	  '}' &@CRLF& _
   '} catch (ParseException e) {' &@CRLF& _
   '}'

   If($isRequired == 1) Then $a &= '}'

   Return $a &@CRLF&@CRLF

EndFunc

; -=----------------------- Long field ==================================
Func createColumnLong()
  if($serviceFilePath='') Then
	  MsgBox($MB_ICONERROR+262144+8192,$ErrorDiaglogTitle,"Create Entity First!")
	  Return
   EndIf

   Local $str = trim(GUICtrlRead($colNameLong,0))

   If (StringLower($str) == 'long') Then
	  MsgBox($MB_ICONERROR+262144+8192,$ErrorDiaglogTitle,"Trùng từ khóa")
	  Return
   EndIf

   If Not (isRequiredInputField($str,"Column long",$colNameLong)) Then Return
   If Not (isCharAndDigistAnd_($str,"Column long",$colNameLong)) Then return
   If NOT (checkRequiredLine($serviceFilePath,$str)) Then Return

   Local $select = GUICtrlRead($longComboBox)

   If(StringInStr($select,'address')) Then
	  If NOT (checkRequiredLine($serviceFilePath,'tinh'&upperFirstLetter($str))) Then Return
	  If Not (isDigist($str,"Column name",$colNameLong)) Then return
   EndIf

   Local $hFileOpen = FileOpen($serviceFilePath, 9) 	;1+8 : create if not exist and write append
   Local $hFileOpen2 = FileOpen($dbscriptFilePath, 9)
   Local $hFileOpen3 = FileOpen($idListFilePath, 9)
   Local $hFileOpen4 = FileOpen($fillData2FormFilePath, 9)
   Local $hFileOpen5 = FileOpen($validatorFilePath, 9)
   Local $hFileOpen6 = FileOpen($reviewFilePath, 9)

   Local $hFileOpen10 = FileOpen($registryFilePath, 9)

   ;TAB
   Local $hFileOpen11 = FileOpen($fillData2FormFilePathTAB, 9)
   Local $hFileOpen12 = FileOpen($validatorFilePathTAB, 9)
   Local $hFileOpen15 = FileOpen($registryFilePathTAB, 9)

   $str = lowerFirstLetter($str)

   Local $content1 = "<column name=" &'"'&$str&'" ' & "db-name=" &'"' & $str&'" ' &"type="&'"'&"long"&'"/>';

   If(StringInStr($select,'address')) Then
	  $content1 = "<column name=" &'"'&'tinh'&upperFirstLetter($str)&'" ' & "db-name=" &'"' &'tinh'& $str&'" ' &"type="&'"'&"long"&'"/>' &@CRLF& _
	  "<column name=" &'"'&'quan'&upperFirstLetter($str)&'" ' & "db-name=" &'"' &'quan'& $str&'" ' &"type="&'"'&"long"&'"/>' &@CRLF& _
	  "<column name=" &'"'&'xa'&upperFirstLetter($str)&'" ' & "db-name=" &'"' &'xa'& $str&'" ' &"type="&'"'&"long"&'"/>' &@CRLF& _
	  "<column name=" &'"'&'diaChi'&upperFirstLetter($str)&'" ' & "db-name=" &'"' &'diaChi'& $str&'" ' &"type="&'"'&"String"&'"/>'
   EndIf

   GUICtrlSetData($resultCreateColumn2,"Done")
   GUICtrlSetData($resultCreateColumn1,"")
   GUICtrlSetData($resultCreateColumn3,"")
   GUICtrlSetData($textFieldService,GUICtrlRead($textFieldService,0)&@CRLF&$content1)

   ; write to DBscript
   Local $content2 = $str & " decimal,"

   If(StringInStr($select,'address')) Then
	  $content2 = 'tinh'&$str & " decimal," &@CRLF& _
				  'quan'& $str & " decimal," &@CRLF& _
				  'xa'&$str & " decimal," &@CRLF& _
				  'diaChi'&$str & ' varchar(' & $maxLengthInput & '),'
   EndIf

   ; write to listID
   Local $content3 = "long" & " " & $str

   If(StringInStr($select,'address')) Then
	  $content3 = "long tinh"& upperFirstLetter($str) &@CRLF& _
				  "long quan"& upperFirstLetter($str) &@CRLF& _
				  "long xa"& upperFirstLetter($str) &@CRLF& _
				  "String diaChi"& upperFirstLetter($str)
   EndIf

   ;fillData2Form
   Local $content4 = fillData2FormLong($select,$str,"")
   Local $content11 = fillData2FormLong($select,$str,$suffix)


   ;validators
   Local $content5 = createValidateLong($select,$str,"")
   Local $content12 =  createValidateLong($select,$str,$suffix)

   ;review
   Local $content6 = createReviewLong($select,$str)

   ;alter.txt
   If(StringInStr($select,'address')) Then
	  Local $hFileOpen7 = FileOpen($alterFilePath, 9)
	  Local $content7 = 'ALTER TABLE ' &$tableSql &' modify diaChi'&upperFirstLetter($str) & ' varchar('&$maxLengthInput&');'
	  FileWriteLine($hFileOpen7,$content7)
	  FileClose($hFileOpen7)
   EndIf


   ;arrRequired.txt
   if ((StringInStr($select,'*')) AND (Not StringInStr($select,'address'))) Then
	  ;requiredValidate
	  If(StringInStr($select,"*")) Then
		 $arrRequiredValidate &= quote($str) & ","
		 $arrRequiredValidateTab &= quote($str&$suffix) & ","
	  EndIf

   ElseIf (StringInStr($select,'address *')) Then
	  $arrRequiredValidate &= quote('quan'&upperFirstLetter($str)) &","& quote('xa'&upperFirstLetter($str)) &","& quote('diaChi'&upperFirstLetter($str)) &","
	  $arrRequiredValidateTab &= quote('quan'&upperFirstLetter($str&$suffix)) &","& quote('xa'&upperFirstLetter($str&$suffix)) &","& quote('diaChi'&upperFirstLetter($str&$suffix)) &","
   EndIf

   ;RegistryForm.txt
   Local $content10 = registryFormLong($select,$str,"",1)
   Local $content15 = registryFormLong($select,$str,$suffix,0)

   FileWriteLine($hFileOpen,$content1)
   FileWriteLine($hFileOpen2,$content2)
   FileWriteLine($hFileOpen3,$content3)
   FileWriteLine($hFileOpen4,$content4)
   FileWriteLine($hFileOpen5,$content5)
   FileWriteLine($hFileOpen6,$content6)
   ;$hFileOpen7 la Alter DiaChi[ coded dong 457]

   FileWrite($hFileOpen10,$content10)

   FileWriteLine($hFileOpen11,$content11)
   FileWriteLine($hFileOpen12,$content12)

   FileWriteLine($hFileOpen15,$content15)

   FileClose($hFileOpen)
   FileClose($hFileOpen2)
   FileClose($hFileOpen3)
   FileClose($hFileOpen4)
   FileClose($hFileOpen5)
   FileClose($hFileOpen6)
   FileClose($hFileOpen10)

   FileClose($hFileOpen11)
   FileClose($hFileOpen12)
   FileClose($hFileOpen15)

   GUICtrlSetData($colNameLong,"")
   ;add content and scroll down
   _GUICtrlEdit_Scroll($textFieldService, $SB_SCROLLCARET)
EndFunc

Func fillData2FormLong($select,$str,$suffix)
   Local $a = ''
   If NOT (StringInStr($select,'address')) Then
   $a = '// '&$str&' - long' &@CRLF& _
		'long '&$str&' = ParamUtil.getLong(request,'&quote($str&$suffix)&');' &@CRLF& _
		'hoSo.set' & upperFirstLetter($str) & '('&$str&');'
   Else
	  $a = '// tinh'&upperFirstLetter($str&$suffix)&' - long' &@CRLF& _
		'long tinh'&upperFirstLetter($str)&' = ParamUtil.getLong(request,'&quote('tinh'&upperFirstLetter($str&$suffix))&');' &@CRLF& _
		'hoSo.setTinh' & upperFirstLetter($str) & '(tinh'& upperFirstLetter($str)&');' &@CRLF& _
		 @CRLF&'//  quan'&upperFirstLetter($str&$suffix)&' - long' &@CRLF& _
		'long quan'&upperFirstLetter($str)&' = ParamUtil.getLong(request,'&quote('quan'&upperFirstLetter($str&$suffix))&');' &@CRLF& _
		'hoSo.setQuan' & upperFirstLetter($str) & '(quan'& upperFirstLetter($str)&');' &@CRLF& _
		 @CRLF&'// xa'&upperFirstLetter($str&$suffix)&' - long' &@CRLF& _
		'long xa'&upperFirstLetter($str)&' = ParamUtil.getLong(request,'&quote('xa'&upperFirstLetter($str&$suffix))&');' &@CRLF& _
		'hoSo.setXa' & upperFirstLetter($str) & '(xa'& upperFirstLetter($str)&');'&@CRLF& _
		 @CRLF&'// diaChi'&upperFirstLetter($str&$suffix)&' - long' &@CRLF& _
		'String diaChi'&upperFirstLetter($str)&' = ParamUtil.getString(request,'&quote('diaChi'&upperFirstLetter($str&$suffix))&').trim();' &@CRLF& _
		'hoSo.setDiaChi' & upperFirstLetter($str) & '(diaChi'& upperFirstLetter($str)&');'
	 EndIf
	 Return $a &@CRLF &@CRLF
EndFunc

Func createReviewLong($select,$str)
   Local $path = @ScriptDir & $jspFolderTemplate & "create service" & "\review long\"
   Local $hand
   Local $value

   If(StringInStr($select, "long"))  Then
	  $hand = _FileOpenTemplate($path, $reviewLong)
   ElseIf (StringInStr($select, "cmnd"))  Then
	  $hand = _FileOpenTemplate($path, $reviewLongCmnd)
   ElseIf (StringInStr($select, "nation"))  Then
	  $hand = _FileOpenTemplate($path, $reviewLongNation)
   ElseIf (StringInStr($select, "danToc"))  Then
	  $hand = _FileOpenTemplate($path, $reviewLongDantoc)
   ElseIf (StringInStr($select, "sex"))  Then
	  $hand = _FileOpenTemplate($path, $reviewLongSex)
   ElseIf (StringInStr($select, "quanHe"))  Then
	  $hand = _FileOpenTemplate($path, $reviewLongQuanHe)
   ElseIf (StringInStr($select, "city"))  Then
	  $hand = _FileOpenTemplate($path, $reviewLongCity)
   ElseIf (StringInStr($select, "job"))  Then
	  $hand = _FileOpenTemplate($path, $reviewLongJob)
   ElseIf (StringInStr($select, "address"))  Then
	  $hand = _FileOpenTemplate($path, $reviewLongAddress)
   EndIf

   $value = FileRead($hand)
   $value = StringReplace($value,"TYPEBYTAN",$select)
   $value = StringReplace($value,"UPPERFIRSTLETTER",upperFirstLetter($str))
   Return $value &@CRLF & @CRLF
EndFunc

Func createValidateLong($select,$str,$suffix)

   Local $path = @ScriptDir & $jspFolderTemplate
   Local $hand
   Local $value

   If($select == 'address *')  Then
	  $hand = FileOpen($path & $validateLongAddress)

	  If ($hand == -1) Then
		 MsgBox($MB_ICONERROR+262144+8192, $ErrorDiaglogTitle, $validateLongAddress & " Not found!")
	  EndIf

   ElseIf ($select == 'quanHe *') Or ($select == 'job *') then
	  $hand = FileOpen($path & $validateLongLess0)

	  If ($hand == -1) Then
		 MsgBox($MB_ICONERROR+262144+8192, $ErrorDiaglogTitle, $validateLongLess0  " Not found!")
	  EndIf

   ElseIf (StringInStr($select, '*')) Then
	  $hand = FileOpen($path & $validateLong0)

	  If ($hand == -1) Then
		 MsgBox($MB_ICONERROR+262144+8192, $ErrorDiaglogTitle, $validateLong0  " Not found!")
	  EndIf
   EndIf

   $value = FileRead($hand)
   $value = StringReplace($value,"TYPEBYTAN",$select)
   $value = StringReplace($value,"NAMEBYTAN",$str&$suffix)
   Return $value &@CRLF & @CRLF
EndFunc

Func registryFormLong($select,$str,$suffix,$isMsg)
   ; isMsg : set = 1 thi MsgBox show khi ko tim ra file

    Local $value = ''
   If ($select == 'cmnd *') then
	  $value = _registryFormLong($str, $suffix,1,$isMsg,$registryLongCmnd)
   ElseIf ($select == 'cmnd') then
	  $value = _registryFormLong($str, $suffix,0,$isMsg,$registryLongCmnd)
   ElseIf (StringInStr($select,'nation *')) Then
	  $value = _registryFormLong($str, $suffix,1,$isMsg,$registryLongNation)
   ElseIf (StringInStr($select,'nation')) Then
	  $value = _registryFormLong($str, $suffix,0,$isMsg,$registryLongNation)
   ElseIf (StringInStr($select,'quanHe *')) Then
   	  $value = _registryFormLong($str, $suffix,1,$isMsg,$registryLongQuanhe)
   ElseIf (StringInStr($select,'quanHe')) Then
	  $value = _registryFormLong($str, $suffix,0,$isMsg,$registryLongQuanhe)
   ElseIf (StringInStr($select,'sex *')) Then
	  $value = _registryFormLong($str, $suffix,1,$isMsg,$registryLongSex)
   ElseIf (StringInStr($select,'sex')) Then
	  $value = _registryFormLong($str, $suffix,0,$isMsg,$registryLongSex)
   ElseIf (StringInStr($select,'danToc *')) Then
	  $value = _registryFormLong($str, $suffix,1,$isMsg,$registryLongDantoc)
   ElseIf (StringInStr($select,'danToc')) Then
	  $value = _registryFormLong($str, $suffix,0,$isMsg,$registryLongDantoc)
   ElseIf (StringInStr($select,'city *')) Then
	  $value = _registryFormLong($str, $suffix,1,$isMsg,$registryLongCity)
   ElseIf (StringInStr($select,'city')) Then
	  $value = _registryFormLong($str, $suffix,0,$isMsg,$registryLongCity)
   ElseIf (StringInStr($select,'job *')) Then
	  $value = _registryFormLong($str, $suffix,1,$isMsg,$registryLongJob)
   ElseIf (StringInStr($select,'job')) Then
	  $value = _registryFormLong($str, $suffix,0,$isMsg,$registryLongJob)
   ElseIf (StringInStr($select,'long *')) Then
	  $value = _registryFormLong($str, $suffix,1,$isMsg,$registryLongOther)
   ElseIf (StringInStr($select,'long')) Then
	  $value = _registryFormLong($str, $suffix,0,$isMsg,$registryLongOther)
   ElseIf (StringInStr($select,'address *')) Then
	  $value = _registryFormLong($str, $suffix, 1, $isMsg,$registryLongAdress)
   ElseIf (StringInStr($select,'address')) Then
	  $value = _registryFormLong($str, $suffix, 0, $isMsg,$registryLongAdress)
   EndIf

   Return $value &@CRLF &@CRLF

EndFunc

Func _registryFormLong($str,$suffix,$isRequired,$isMsg,$fileName)

   Local $path = @ScriptDir & $jspFolderTemplate & "create service" & "\registry long\"
   Local $hand = FileOpen($path&$fileName)

   If ($hand == -1) Then
	  If $isMsg == 1 Then MsgBox($MB_ICONERROR+262144+8192,$ErrorDiaglogTitle,$fileName&" Not found!")
	  Return ''
   EndIf

   Local $value = FileRead($hand)
   $value = StringReplace($value,"NAMEBYTAN",$str&$suffix)
   $value = StringReplace($value,"UPPERFIRSTLETTER",upperFirstLetter($str))
   $value = StringReplace($value,"MAXLENGTHBYTAN",$maxLengthInput)

   If ($isRequired == 1) then Return $value

   Return StringReplace($value,'<label class="egov-label-red">*</label>','')

EndFunc

;================================================= Create service.xml ==========================================

Func createEntity()

   Local $entityN = trim(GUICtrlRead($entityName,0))

   If Not (isRequiredInputField($entityN,"Tên entity",$entityName)) Then Return
   If Not (isCharAndDigistAnd_($entityN,"Tên entity",$entityName)) Then return
   If Not (isValidateInputEntityName($entityN,"Tên entity",$entityName)) Then return

   If FileExists($WorkingDir & '\' & $entityN) Then
	  Local $yesDialog = MsgBox (4 + 32 + 256 + 262144 + 8192,"Tạo Entity mới","Entity đã tồn tại. Bạn muốn tạo mới không ?")
	  If $yesDialog == 7 Then Return
	  EndIf

   $arrRequiredValidate = ''
   $arrDateValidate = ''
   $arrCMNDValidate = ''
   $arrEmailValidate  = ''
   $arrPhoneValidate = ''

   $arrRequiredValidateTab = ''
   $arrDateValidateTab = ''
   $arrCMNDValidateTab = ''
   $arrEmailValidateTab  = ''
   $arrPhoneValidateTab = ''

   _resetInputField($colNameStr)
   _resetInputField($colNameLong)
   _resetInputField($colNameDate)

   GUICtrlSetData($resultCreateColumn1,"")
   GUICtrlSetData($resultCreateColumn2,"")
   GUICtrlSetData($resultCreateColumn3,"")
   GUICtrlSetData($createEntityLabel,"")

   Local $groupValue = trim(GUICtrlRead($group_create_service,0))

   ;required DropBox
   if ($groupValue == $index0Combo) Then
	  messageSelectCombo("")
	  Return
   EndIf

   $tableSql = $groupValue & '_' & StringLower($entityN)

   ; global PATH
   $serviceFilePath = $WorkingDir&"\"&$entityN&"\service.xml"
   $dbscriptFilePath = $WorkingDir&"\"&$entityN&"\"& $tableSql &".sql"
   $idListFilePath =  $WorkingDir&"\"&$entityN&"\listID.txt"
   $fillData2FormFilePath =  $WorkingDir&"\"&$entityN&"\fillData2Form.java"
   $validatorFilePath =  $WorkingDir&"\"&$entityN&"\validators.java"
   $reviewFilePath =  $WorkingDir&"\"&$entityN&"\review.jsp"
   $alterFilePath =  $WorkingDir&"\"&$entityN&"\alter.txt"
   $arrRequiredFilePathService =  $WorkingDir&"\"&$entityN&"\arrRequired.java"

   $registryFilePath = $WorkingDir&"\"&$entityN&"\registryForm.jsp"

   $arrRequiredFilePathServiceTAB =  $WorkingDir&"\"&$entityN&"\TAB\arrRequiredTAB.java"

   $fillData2FormFilePathTAB =  $WorkingDir&"\"&$entityN&"\TAB\fillData2FormTAB.java"
   $validatorFilePathTAB =  $WorkingDir&"\"&$entityN&"\TAB\validatorsTAB.java"
   $registryFilePathTAB  = $WorkingDir&"\"&$entityN&"\TAB\registryFormTAB.jsp"

   Local $hFileOpen  = FileOpen($serviceFilePath, $modeWrite) ;2+8 : create if not exist and write override
   Local $hFileOpen2 = FileOpen($dbscriptFilePath, $modeWrite)
   Local $hFileOpen3 = FileOpen($idListFilePath, $modeWrite)
   Local $hFileOpen4 = FileOpen($fillData2FormFilePath, $modeWrite)
   Local $hFileOpen5 = FileOpen($validatorFilePath, $modeWrite)
   Local $hFileOpen6 = FileOpen($reviewFilePath, $modeWrite)
   Local $hFileOpen7 = FileOpen($alterFilePath, $modeWrite)
   Local $hFileOpen10  = FileOpen($registryFilePath, $modeWrite) ;2+8 : create if not exist and write override

   ;TAB
   Local $hFileOpen11 = FileOpen($fillData2FormFilePathTAB, $modeWrite)
   Local $hFileOpen12 = FileOpen($validatorFilePathTAB, $modeWrite)

   Local $hFileOpen15 = FileOpen($registryFilePathTAB, $modeWrite) ;2+8 : create if not exist and write override

   $entityN = upperFirstLetter($entityN)

   Local $path = @ScriptDir & $jspFolderTemplate & 'create service\'

   ; Header Of file service.xml
   Local $hand = FileOpen($path&$serviceHeader)

   If ($hand == -1) Then
	  If $isMsg == 1 Then MsgBox($MB_ICONERROR+262144+8192,$ErrorDiaglogTitle,$serviceHeader&" Not found!")
	  Return ''
   EndIf

   Local $xmlHeader = FileRead($hand)
   $xmlHeader = StringReplace($xmlHeader,"GROUPBYTAN", $groupValue)
   $xmlHeader = StringReplace($xmlHeader,"TABLEBYTAN", $tableSql)
   $xmlHeader = StringReplace($xmlHeader,"FOLDERENTITYBYTAN", StringLower($entityN))
   $xmlHeader = StringReplace($xmlHeader,"UPPERFIRSTLETTER", upperFirstLetter($entityN))

   FileWriteLine($hFileOpen, $xmlHeader)
   GUICtrlSetData($textFieldService, $xmlHeader )
   ;End Of Header Of file service.xml

   FileWriteLine($hFileOpen2, "Create table "& $tableSql & "("&@CRLF & _
							  "id decimal primary key," &@CRLF& "coQuanQuanLyId decimal,")

   FileWriteLine($hFileOpen3, "#"&"Entity : "& $entityN & @CRLF & "long id" & @CRLF & "long coQuanQuanLyId")

   _GUICtrlEdit_Scroll($textFieldService, $SB_SCROLLCARET)

   GUICtrlSetData($createEntityLabel,"Done")

   FileWriteLine($hFileOpen4, '//coQuanQuanLyId - long' &@CRLF & _
		'long coQuanQuanLyId = ParamUtil.getLong(request,"coQuanQuanLyId");' &@CRLF & _
		'hoSo.setCoQuanQuanLyId(coQuanQuanLyId);'&@CRLF&@CRLF)

   FileWriteLine($hFileOpen11, '//coQuanQuanLyId - long' &@CRLF & _
		'long coQuanQuanLyId = ParamUtil.getLong(request,"coQuanQuanLyId2");' &@CRLF & _
		'hoSo.setCoQuanQuanLyId(coQuanQuanLyId);'&@CRLF&@CRLF)

   FileClose($hFileOpen)
   FileClose($hFileOpen2)
   FileClose($hFileOpen3)
   FileClose($hFileOpen4)
   FileClose($hFileOpen5)
   FileClose($hFileOpen6)
   FileClose($hFileOpen7)


   FileClose($hFileOpen10)
   FileClose($hFileOpen11)
   FileClose($hFileOpen12)

   FileClose($hFileOpen15)
EndFunc


Func finishService()
   If($serviceFilePath='') Then
	  MsgBox($MB_ICONERROR+262144+8192,$ErrorDiaglogTitle,"Create Entity First!")
	  Return
   EndIf

   Local $hFileOpen = FileOpen($serviceFilePath, 9) ;1+8 : create if not exist and write append
   Local $hFileOpen2 = FileOpen($dbscriptFilePath, 9)

   Local $hFileOpen8 = FileOpen($arrRequiredFilePathService, $modeWrite)
   Local $hFileOpen13 = FileOpen($arrRequiredFilePathServiceTAB, $modeWrite)

   Local $path = @ScriptDir & $jspFolderTemplate & 'create service\'

   Local $hand = FileOpen($path & $serviceFooter)

   If ($hand == -1) Then
	  If $isMsg == 1 Then MsgBox($MB_ICONERROR+262144+8192,$ErrorDiaglogTitle,$serviceFooter&" Not found!")
	  Return ''
   EndIf

   Local $serviceFooter = FileRead($hand)

   FileWriteLine($hFileOpen, $serviceFooter)

   GUICtrlSetData($textFieldService, GUICtrlRead($textFieldService,0) & @CRLF & $serviceFooter)

   $hand = FileOpen($path & $sqlFooter)

   If ($hand == -1) Then
	  If $isMsg == 1 Then MsgBox($MB_ICONERROR+262144+8192,$ErrorDiaglogTitle, $sqlFooter&" Not found!")
	  Return ''
   EndIf

   Local $sqlFooter = FileRead($hand)
   $sqlFooter = StringReplace($sqlFooter,"MAXLENGTHBYTAN",$maxLengthInput)

   FileWriteLine($hFileOpen2,$sqlFooter)

   ;Write to validate Form
   Local $validateContent =  'String []danhSachRequired = {' & ($arrRequiredValidate == "" ? quote("") : $arrRequiredValidate) & '};' & @CRLF & @CRLF
		 $validateContent &= 'String []danhSachDate = {' & ($arrDateValidate == "" ? quote("") : $arrDateValidate) & '};' & @CRLF & @CRLF
		 $validateContent &= 'String []danhsachCMND = {' & ($arrCMNDValidate == "" ? quote("") : $arrCMNDValidate) & '};' & @CRLF & @CRLF
		 $validateContent &= 'String []danhsachPhone = {' & ($arrPhoneValidate == "" ? quote("") : $arrPhoneValidate) & '};' & @CRLF & @CRLF
		 $validateContent &= 'String []danhsachEmail = {' & ($arrEmailValidate == "" ? quote("") : $arrEmailValidate) & '};'
		 $validateContent = StringReplace($validateContent, ',}' , '}')

   ;Write to validate Form Tab
   Local $validateContentTab =  'String []danhSachRequired = {' & $arrRequiredValidateTab & '};' & @CRLF & @CRLF
		 $validateContentTab &= 'String []danhSachDate = {' & $arrDateValidateTab & '};' & @CRLF & @CRLF
		 $validateContentTab &= 'String []danhsachCMND = {' & $arrCMNDValidateTab & '};' & @CRLF & @CRLF
		 $validateContentTab &= 'String []danhsachPhone = {' & $arrPhoneValidateTab & '};' & @CRLF & @CRLF
		 $validateContentTab &= 'String []danhsachEmail = {' & $arrEmailValidateTab & '};'
		 $validateContentTab = StringReplace($validateContentTab, ',}' , '}')

   FileWrite($hFileOpen8,$validateContent)
   FileWrite($hFileOpen13,$validateContentTab)

   GUICtrlSetData($resultCreateColumn1,"")
   GUICtrlSetData($resultCreateColumn2,"")
   GUICtrlSetData($resultCreateColumn3,"")
   GUICtrlSetData($createEntityLabel,"")

   _resetInputField($colNameStr)
   _resetInputField($colNameLong)
   _resetInputField($colNameDate)

   ;GUICtrlSetBkColor($textFieldService,$xanhLaChuoi)

   $serviceFilePath = ""
   $dbscriptFilePath = ""

   FileClose($hFileOpen)
   FileClose($hFileOpen2)
   FileClose($hFileOpen8)
   FileClose($hFileOpen13)
EndFunc

;================= Utils Tab service ================================================================

Func checkRequiredLine($file,$line)
   for $i=1 to _FileCountLines($file)
	  if(StringInStr(FileReadLine($file,$i),"<column name="&quote($line))) Then
		  MsgBox($MB_ICONERROR+262144+8192, "Error !", "Value must be unique!")
		  Return false
		  EndIf
	   Next
	   Return true
EndFunc

Func requiredValidate($str)
    return 'if ('&$str&'.length() == 0) {' &@CRLF & _
			   'SessionErrors.add(request, '&quote($str)&');' &@CRLF & _
			   'valid = false;' &@CRLF & _
			'}else'
EndFunc