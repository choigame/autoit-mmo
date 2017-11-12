#include "XMLMainEntity.au3"
#include "ValidateXML.au3"

;Do name va db-name de nham lan nen lay ra phuc tap hon lay Type
Global $RegexGetFieldName = '(?s)<column.*?\sname=\"(.+?)\"'
Global $RegexGetDbName = '(?s)<column.*?\sdb-name=\"(.+?)\"'
Global $RegexGetTypeName = '\stype=\"(.+?)\"' ; tranh bi return-type

Func XMLAction()

   ;Global
   $MaxLengthVarchar = GUICtrlRead($MaxLengthVarcharInput)

   If Not (isRequiredInputField($MaxLengthVarchar,"",$MaxLengthVarcharInput)) Then Return
   If Not (isDigist($MaxLengthVarchar,"",$MaxLengthVarcharInput)) Then return

   Local $HandFileOpen = FileOpenDialog("Choose service.xml", $PathEclipse, "service.xml (*.xml)", $FD_FILEMUSTEXIST)

   If @error Then
        MsgBox($MB_SYSTEMMODAL+262144+8192, "", "No file were selected.")
		Return
   EndIf

   ;Chuan hoa file service.xml
   Local $XMLInput = FileRead($HandFileOpen)
   $XMLInput = StringRegExpReplace($XMLInput , '\s*=\s*\"' , '="')
   $XMLInput = StringRegExpReplace($XMLInput , '\s+\"(\s+|>)' , '" ')
   $XMLInput = StringRegExpReplace($XMLInput , '(?s)(>\s*</column\s*>)' , '/>')

   If NOT ValidateXML($XMLInput) Then
		Return
	 EndIf

   Local $ScripMySQL = @CRLF & @CRLF

   Local $PathEntity
   $PathEntity = StringRegExp($XMLInput, 'package-path=\"(.+?)\"', 1)[0]

   Local $Entities = StringRegExp($XMLInput, '(?s)<\s*entity.+?</entity>', 3)
   Local $TableNameMainEntity = StringRegExp($XMLInput, 'table=\"(.+?)\"', 1)[0]

   For $i = 0 To UBound($Entities) - 1
	  If $i == 0 Then
		 CreateMySQLFromXMLForMainEntity($Entities[$i], $PathEntity)
	  Else
		 $ScripMySQL &= CreateMySQLFromXML($Entities[$i], $PathEntity) &@CRLF &@CRLF
		 ;Global $listVaribleInJsp In CreateMySQLFromXML()
	  EndIf
   Next

   ;================================ for bang phu (table) ============================

   Local $PathFolderOut = $WorkingDir & "\" & $TableNameMainEntity
   Local $HandFileMySQL = FileOpen($PathFolderOut & "\" & $TableNameMainEntity & ".sql", 9)
   Local $Group = StringRegExp($PathEntity, 'vn.dtt\.(.+?)\.', 1)[0]
   Local $FolderEntity = StringReplace($PathEntity, "vn.dtt." &$Group &".", "")

   Local $JSPFile = $PathFolderOut & "\" & $FolderEntity & "\registry_" & $FolderEntity & "_step.jsp"
   Local $JspRegistryOutPut = FileRead($JSPFile)

   Local $EntityTag = StringRegExp($Entities[0], '(?s)<\s*entity.+?>', 1)
   Local $EntityName = StringRegExp($EntityTag[0], 'name=\"(.+?)\"', 1)[0]

   Local $JavaUtilsFile = $PathFolderOut & "\" & $EntityName & "Utils.java"
   Local $JavaUtilsFileOutPut = FileRead($JavaUtilsFile)

   If Not ($listVaribleInJsp == '') Then
	  $JspRegistryOutPut = StringReplace($JspRegistryOutPut,"$listVaribleInJsp",$listVaribleInJsp)
	  $JspRegistryOutPut = StringReplace($JspRegistryOutPut,"$includeListJspInJsp",$includeListJspInJsp)

	  $JavaUtilsFileOutPut = StringReplace($JavaUtilsFileOutPut,"$sessionForList",$sessionForList)

   Else
	  $JspRegistryOutPut = StringReplace($JspRegistryOutPut,"$listVaribleInJsp",'')
	  $JspRegistryOutPut = StringReplace($JspRegistryOutPut,"$includeListJspInJsp",'')

	  $JavaUtilsFileOutPut = StringReplace($JavaUtilsFileOutPut,"$sessionForList",'')

   EndIf

   Local $HandFileRegistryJsp = FileOpen($JSPFile, $modeWrite)
   Local $HandFileJavaUtils = FileOpen($JavaUtilsFile, $modeWrite)

   FileWrite($HandFileRegistryJsp , $JspRegistryOutPut)
   FileClose($HandFileRegistryJsp)

   FileWrite($HandFileJavaUtils , $JavaUtilsFileOutPut)
   FileClose($HandFileJavaUtils)

   FileWrite($HandFileMySQL , $ScripMySQL)
   FileClose($HandFileMySQL)

EndFunc

Func ConverDataTypeJava2TypeMySQL($TypeJava,$DbFieldName)
   Local $Result

   If ($TypeJava == 'String') Then
	  If StringInStr($DbFieldName,'phone') OR StringInStr($DbFieldName,'fax') OR StringInStr($DbFieldName,'email') OR StringInStr($DbFieldName,'web') Then
		  $Result =  'varchar(' &$MaxLengthVarcharPhone & ')'
	  Else
		 $Result =  'varchar(' &$MaxLengthVarchar & ')'
	  EndIf
   EndIf

   If ($TypeJava == 'long') OR ($TypeJava == 'int') OR ($TypeJava == 'Long') OR ($TypeJava == 'Integer') Then $Result =  'decimal'
   If ($TypeJava == 'Date')   Then $Result = 'datetime'

   Return $Result
EndFunc

Func FillData2Form($FieldName, $Type , $suffix)
   Local $OutPut
   Local $Upper1stFieldName = upperFirstLetter($FieldName)

   If ($Type == 'String') AND NOT (($FieldName == 'nguoiTao') OR ($FieldName == 'nguoiSua')) Then
	  $OutPut = '// '& $FieldName &' - String ' &@CRLF & _
	  'String '&$FieldName&' = ParamUtil.getString(request,'& quote($FieldName & $suffix) & ').trim();' &@CRLF & _
	  'hoSo.set'& $Upper1stFieldName & '('&$FieldName&');' & @CRLF
   ElseIf ($Type == 'long') AND (NOT (($FieldName == 'id') OR ($FieldName == 'xoa'))) Then
	  $OutPut = '// '& $FieldName &' - long ' &@CRLF & _
	  'long '&$FieldName&' = ParamUtil.getLong(request,'& quote($FieldName & $suffix) & ');' &@CRLF & _
	  'hoSo.set'& $Upper1stFieldName & '('&$FieldName&');' & @CRLF
   ElseIf ($Type == 'Date') AND ( NOT (($FieldName == 'ngayTao') OR ($FieldName == 'ngaySua'))) Then
	  $OutPut = '// '&$FieldName&' - Date' & @CRLF & _
	  'String '&$FieldName&' = ParamUtil.getString(request,'& quote($FieldName & $suffix) & ');' & @CRLF & _
	  'hoSo.set'& $Upper1stFieldName & '(ActionUtils.parseStringToDate('&$FieldName&'));' & @CRLF
   EndIf

   Return $OutPut
EndFunc

Func ValidateForm($FieldName, $Type, $suffix)
   Local $OutPut = ''
   Local $path = @ScriptDir & $jspFolderTemplate & "create service" & "\validate string\"
   Local $hand

   If (($Type == 'long') OR ($Type == 'int')) AND (($FieldName == 'id') OR ($FieldName == 'xoa')) Then return ''
   If ($Type == 'Date') AND (($FieldName == 'ngayTao') OR ($FieldName == 'ngaySua')) Then return ''
   If ($Type == 'String')  AND  (($FieldName == 'nguoiTao')  OR ($FieldName == 'nguoiSua')) Then return ''

   If ($Type == 'long') Then
	  $OutPut = '// '& $FieldName &' - long ' &@CRLF & _
	  'long '&$FieldName&' = ParamUtil.getLong(request,'& quote($FieldName & $suffix) & ');' &@CRLF & _
	  'if ('&$FieldName&' <= 0 ) {' &@CRLF & _
		  'SessionErrors.add(request, '& quote($FieldName & $suffix)&');' &@CRLF & _
		  'valid = false;' &@CRLF & _
	  '}'
   ElseIf ($Type == 'Date') Then
	  $OutPut = '//'& $FieldName &' - Date ' & @CRLF & _
			'String '&$FieldName &' = ParamUtil.getString(request, '& quote($FieldName & $suffix)&').trim();' &@CRLF & _
			'if ('&$FieldName &'.length() == 0) {' & @CRLF & _
			   'SessionErrors.add(request, '&quote($FieldName & $suffix)&');' & @CRLF& _
			   'valid = false;' & @CRLF& _
			'} else {' & @CRLF & _
			   'try {' & @CRLF& _
				  'if ('&$FieldName&'.length() > 0 & ActionUtils.compareTwoDates('&$FieldName&', today, "dd/MM/yyyy") > 0) {' & @CRLF & _
					 'SessionErrors.add(request, '&quote($FieldName & $suffix)&' + "lonHonHienTai");' &@CRLF& _
					 'valid = false;' & @CRLF & _
				  '}' & @CRLF& _
			   '} catch (ParseException e) {' & @CRLF& _
			   '}' & @CRLF& _
			'}'
   ElseIf ($Type == 'String') AND StringInStr($FieldName,'email') Then

	  $hand = FileOpen($path & $validateStringEmail)
	  If ($hand == -1) Then
		 MsgBox($MB_ICONERROR+262144+8192, $ErrorDiaglogTitle, $validateStringEmail & " Not found!")
	  EndIf

	  $OutPut = FileRead($hand)
	  $OutPut = StringReplace($OutPut,"NAMEBYTAN",$FieldName& $suffix)
	  $OutPut = StringReplace($OutPut,"REPLACEIFREQUIRED",requiredValidate($FieldName, $suffix))

   ElseIf ($Type == 'String') AND StringInStr($FieldName,'cmnd') Then
	  $hand = FileOpen($path & $validateStringCmnd)
	  If ($hand == -1) Then
		 MsgBox($MB_ICONERROR+262144+8192, $ErrorDiaglogTitle, $validateStringCmnd & " Not found!")
	  EndIf

	  $OutPut = FileRead($hand)
	  $OutPut = StringReplace($OutPut,"NAMEBYTAN", $FieldName& $suffix)
	  $OutPut = StringReplace($OutPut,"REPLACEIFREQUIRED",requiredValidate($FieldName, $suffix))

   ElseIf ($Type == 'String') AND (StringInStr($FieldName,'phone') OR StringInStr($FieldName,'fax')) Then
	  $hand = FileOpen($path & $validateStringPhone)
	  If ($hand == -1) Then
		 MsgBox($MB_ICONERROR+262144+8192, $ErrorDiaglogTitle, $validateStringPhone & " Not found!")
	  EndIf

	  $OutPut = FileRead($hand)
	  $OutPut = StringReplace($OutPut,"NAMEBYTAN", $FieldName& $suffix)
	  $OutPut = StringReplace($OutPut,"REPLACEIFREQUIRED",requiredValidate($FieldName, $suffix))

   ElseIf ($Type == 'String') AND (StringInStr($FieldName,'website') Or StringInStr($FieldName,'web')) Then

	  $hand = FileOpen($path & $validateStringWebsite)
	  If ($hand == -1) Then
		 MsgBox($MB_ICONERROR+262144+8192, $ErrorDiaglogTitle, $validateStringWebsite & " Not found!")
	  EndIf

	  $OutPut = FileRead($hand)
	  $OutPut = StringReplace($OutPut,"NAMEBYTAN",$FieldName& $suffix)
	  $OutPut = StringReplace($OutPut,"REPLACEIFREQUIRED",requiredValidate($FieldName, $suffix))

   ElseIf ($Type == 'String') Then
	  $OutPut = '// '& $FieldName &' - String ' &@CRLF & _
	  'String '&$FieldName&' = ParamUtil.getString(request,'& quote($FieldName & $suffix) & ').trim();' &@CRLF & _
	  'if ('&$FieldName&'.length() == 0 ) {' &@CRLF & _
		  'SessionErrors.add(request, '& quote($FieldName & $suffix)&');' &@CRLF & _
		  'valid = false;' &@CRLF & _
	  '}'
   Else
   EndIf

   Return $OutPut & @CRLF & @CRLF
EndFunc

Func CreateJavaUtils($Group, $EntityName, $PathEntity)
   Local $path = @ScriptDir & $jspFolderTemplate
   Local $hand
   Local $Out

   $hand  = FileOpen($path & $utilsJava)

   If ($hand == -1) Then
	  MsgBox($MB_ICONERROR+262144+8192,"Error",$utilsJava&" Not found!")
   EndIf

   Local $Out = FileRead($hand)
   $Out = StringReplace($Out,"SUBFOLDERENTITYBYTAN","")
   $Out = StringReplace($Out,"GROUPBYTAN",$Group)
   $Out = StringReplace($Out,"GROUPCONSTANTBYTAN", upperFirstLetter($Group) & "Constrants")

   $Out = StringReplace($Out,"FOLDERENTITYBYTAN", StringReplace($PathEntity, "vn.dtt." &$Group &".", ""))
   $Out = StringReplace($Out,"ENTITYNAMEBYTAN", $EntityName)
   $Out = StringReplace($Out,"UTILSNAMEBYTAN", $EntityName)

   Return $Out
EndFunc

Func CreateJspRegistry($Group, $EntityName, $PathEntity)
   Local $path = @ScriptDir & $jspFolderTemplate
   Local $hand = FileOpen($path & $jspRegistry)
   Local $Out= FileRead($hand)

   Local $FolderEntity = StringReplace($PathEntity, "vn.dtt." &$Group &".", "")

   $Out = StringReplace($Out,"GROUPBYTAN",$Group)
   $Out = StringReplace($Out,"FOLDERENTITYBYTAN", $FolderEntity)
   $Out = StringReplace($Out,"ENTITYNAMEBYTAN", $EntityName)
   $Out = StringReplace($Out,"GROUPCONSTANTBYTAN", upperFirstLetter($Group) & "Constrants")
   $Out = StringReplace($Out,"UTILSNAMEBYTAN", $EntityName)
   $Out = StringReplace($Out,"FOLDERJSPBYTAN",$FolderEntity)
   $Out = StringReplace($Out,"HOSOBYTAN",$FolderEntity)

   Return $Out
EndFunc

Func CreateJspReview($Group, $EntityName, $PathEntity)
   Local $path = @ScriptDir & $jspFolderTemplate
   Local $hand = FileOpen($path & $jspReview)
   Local $Out= FileRead($hand)

   Local $FolderEntity = StringReplace($PathEntity, "vn.dtt." &$Group &".", "")

   $Out = StringReplace($Out,"GROUPBYTAN", $Group)
   $Out = StringReplace($Out,"FOLDERENTITYBYTAN", $FolderEntity)
   $Out = StringReplace($Out,"ENTITYNAMEBYTAN", $EntityName)
   $Out = StringReplace($Out,"GROUPCONSTANTBYTAN", upperFirstLetter($Group) & "Constrants")
   $Out = StringReplace($Out,"FOLDERJSPBYTAN", $FolderEntity)
   $Out = StringReplace($Out,"HOSOBYTAN",$FolderEntity)

   Return $Out
EndFunc

Func requiredValidate($FieldName,$suffix)
    return 'if ('&$FieldName&'.length() == 0) {' &@CRLF & _
			   'SessionErrors.add(request, '&quote($FieldName& $suffix)&');' &@CRLF & _
			   'valid = false;' &@CRLF & _
			'}else'
EndFunc

Func registryForm($Type, $select, $FieldName, $suffix)

   Local $value = ''

   If (($Type == 'long') OR ($Type == 'int')) AND (($FieldName == 'id') OR ($FieldName == 'xoa')) Then return ''
   If ($Type == 'Date') AND (($FieldName == 'ngayTao') OR ($FieldName == 'ngaySua')) Then return ''
   If ($Type == 'String')  AND  (($FieldName == 'nguoiTao')  OR ($FieldName == 'nguoiSua')) Then return ''

   If ($Type == 'String') Then

	  If StringInStr($FieldName,"email") Then
	  	 $value = _registryFormString($FieldName, $suffix, 1, $registryStringEmail)

	  ElseIf StringInStr($FieldName,"website") OR StringInStr($FieldName,"web") Then
		 $value = _registryFormString($FieldName, $suffix, 1, $registryStringWebsite)

	  ElseIf StringInStr($FieldName,"cmnd") Then
		 $value = _registryFormString($FieldName, $suffix, 1, $registryStringCmnd)

	  ElseIf (StringInStr($FieldName,"phone") OR StringInStr($FieldName,"fax")) Then
		 $value = _registryFormString($FieldName,$suffix, 1,$registryStringPhone)

	  Else
		 $value = _registryFormString($FieldName,$suffix, 1,$registryStringInput)
	  EndIf

   ElseIf ($Type == 'Date')  Then
	  $value = registryFormDate($FieldName,'',1)
   ElseIf ($Type == 'long')  Then
	  $value = '<!--' & $FieldName & " -->"
   EndIf

   Return $value &@CRLF
EndFunc

Func _registryFormString($FieldName, $suffix, $isRequired, $fileName)

   Local $path = @ScriptDir & $jspFolderTemplate & "create service" & "\registry string\"
   Local $hand = FileOpen($path&$fileName)

   If ($hand == -1) Then
	  MsgBox($MB_ICONERROR+262144+8192, $ErrorDiaglogTitle, $fileName & " Not found!")
   EndIf

   Local $value = FileRead($hand)
		 $value = StringReplace($value,"NAMEBYTAN",$FieldName&$suffix)
		 $value = StringReplace($value,"LARGEMAXLENGTHTEXTAREABYTAN", $maxlengthTextArea*2)
		 $value = StringReplace($value,"MAXLENGTHTEXTAREABYTAN", $maxlengthTextArea)
		 $value = StringReplace($value,"MAXLENGTHVARCHARPHONE", $MaxLengthVarcharPhone)

		 $value = StringReplace($value,"MAXLENGTHBYTAN",$MaxLengthVarchar)
		 $value = StringReplace($value,"UPPERFIRSTLETTER",upperFirstLetter($FieldName))

   If NOT ($isRequired == 1)Then  Return StringReplace($value,'<label class="egov-label-red">*</label>','')

   Return $value
EndFunc

Func registryFormDate($FieldName,$suffix,$isRequired)

   Local $path = @ScriptDir & $jspFolderTemplate & 'create service\'
   Local $hand = FileOpen($path & $registryDateInput)

   If ($hand == -1) Then
	  MsgBox($MB_ICONERROR+262144+8192,$ErrorDiaglogTitle,$registryDateInput&" Not found!")
   EndIf

   Local $value = FileRead($hand)
		 $value = StringReplace($value,"NAMEBYTAN",$FieldName&$suffix)
		 $value = StringReplace($value,"UPPERFIRSTLETTER",upperFirstLetter($FieldName))

   If NOT ($isRequired == 1) Then Return StringReplace($value,'<label class="egov-label-red">*</label>','')

   Return $value

EndFunc

Func registryFormLong($FieldName,$suffix,$isMsg)
   ; isMsg : set = 1 thi MsgBox show khi ko tim ra file
   Local $value = ''

   If StringInStr($FieldName,'noiCapCmnd') then
	  $value = _registryFormLong($FieldName, $suffix,1,$registryLongCmnd)

   ElseIf StringInStr($FieldName,'quocGia') OR StringInStr($FieldName,'quocTich') Then
	  $value = _registryFormLong($FieldName, $suffix,1,$registryLongNation)

   ElseIf (StringInStr($FieldName,'quanHe')) Then
   	  $value = _registryFormLong($FieldName, $suffix,1,$registryLongQuanhe)

   ElseIf (StringInStr($FieldName,'sex')) Then
	  $value = _registryFormLong($FieldName, $suffix,1,$registryLongSex)

   ElseIf (StringInStr($FieldName,'danToc')) Then
	  $value = _registryFormLong($FieldName, $suffix,1,$registryLongDantoc)

   ElseIf StringInStr($FieldName,'city') Then
	  $value = _registryFormLong($FieldName, $suffix,1,$registryLongCity)

   ElseIf StringInStr($FieldName,'noiCapHoChieu') Then
	  $value = _registryFormLong($FieldName, $suffix,1,$registryLongHoChieu)

   ElseIf (StringInStr($FieldName,'job')) Then
	  $value = _registryFormLong($FieldName, $suffix,1,$registryLongJob)

   Else
	  $value = _registryFormLong($FieldName, $suffix,1,$registryLongOther)
   EndIf

   Return $value

EndFunc

Func _registryFormLong($FieldName,$suffix,$isRequired,$fileName)

   Local $path = @ScriptDir & $jspFolderTemplate & "create service" & "\registry long\"
   Local $hand = FileOpen($path & $fileName)

   If ($hand == -1) Then
	  MsgBox($MB_ICONERROR+262144+8192,$ErrorDiaglogTitle,$fileName&" Not found!")
	  Return ''
   EndIf

   Local $value = FileRead($hand)
   $value = StringReplace($value,"NAMEBYTAN",$FieldName&$suffix)
   $value = StringReplace($value,"UPPERFIRSTLETTER",upperFirstLetter($FieldName))
   ;$value = StringReplace($value,"MAXLENGTHBYTAN",$maxLengthInput)

   If ($isRequired == 1) then Return $value

   $value = StringReplace($value,'<label class="egov-label-red">*</label>','')

   Return $value
EndFunc
