Func CreateMySQLFromXMLForMainEntity($EntityInput, $PathEntity)

   Local $EntityTag, $EntityName, $Group

   Local $TableName

   Local $FieldName
   Local $DbFieldName
   Local $TypeOfField

   Local $SqlScript

   Local $ArrayRequiredValidate = ""
   Local $ArrayDateValidate = ""
   Local $ArrayCmndValidate = '""'
   Local $ArrayPhoneValidate = '""'
   Local $ArrayEmailValidate = '""'

   Local $FillData2Form = ""
   Local $ValidateForm = ""
   Local $DrawForm = ""

   ;TAB
   Local $ArrayRequiredValidateTab = ""
   Local $ArrayDateValidateTab = ""
   Local $ArrayCmndValidateTab= '""'
   Local $ArrayPhoneValidateTab = '""'
   Local $ArrayEmailValidateTab = '""'

   Local $FillData2FormTab = ""
   Local $ValidateFormTab = ""
   Local $DrawFormTab = ""

   Local $MySQLOutPut
   Local $JavaUtilsOutPut
   Local $JavaUtilsTabOutPut
   Local $JspRegistryOutPut
   Local $JspRegistryTabOutPut
   Local $JspReviewOutPut

   Local $Columns

   $TableName = StringRegExp($EntityInput, 'table=\"(.+?)\"', 1)[0]
   $SqlScript = "Create table " & $TableName & " (" &@CRLF
   $Columns = StringRegExp($EntityInput, '(?s)(<column.+?/>)', 3)
   $EntityTag = StringRegExp($EntityInput, '(?s)<\s*entity.+?>', 1)
   $EntityName = StringRegExp($EntityTag[0], 'name=\"(.+?)\"', 1)[0]
   $Group = StringRegExp($PathEntity, 'vn.dtt\.(.+?)\.', 1)[0]

   Local $FieldPK = getFieldPK($EntityInput)

   For $i = 0 To UBound($Columns) - 1
	  ConsoleWrite($Columns[$i] & @CRLF)
	  Local $FieldName = StringRegExp($Columns[$i], $RegexGetFieldName, 1)[0]
	  Local $DbFieldName = StringRegExp($Columns[$i], $RegexGetDbName, 1)[0]
	  Local $TypeOfField = StringRegExp($Columns[$i], $RegexGetTypeName, 1)[0]

	  ConsoleWrite($FieldName & " - " & $DbFieldName & " - " & $TypeOfField & @CRLF)

	  $SqlScript &= $DbFieldName & " " & ConverDataTypeJava2TypeMySQL($TypeOfField,$DbFieldName)
	  If ($FieldPK==$FieldName) Then
		 $SqlScript &= " primary key" & "," & @CRLF
	  Else
		 $SqlScript &=  "," & @CRLF
	  EndIf

	  $ArrayRequiredValidate &= quote($FieldName) & ","
	  $ArrayRequiredValidateTab &= quote($FieldName & $suffix) & ","

	  If StringInStr($TypeOfField, "Date") Then
		 $ArrayDateValidate &= quote($FieldName) & ","
		 $ArrayDateValidateTab &= quote($FieldName & $suffix) & ","
	  EndIf

	  If ($TypeOfField == 'String') Then
		 If StringInStr($FieldName, "cmnd") Then
			$ArrayCmndValidate &= quote($FieldName) & ","
			$ArrayCmndValidateTab &= quote($FieldName & $suffix) & ","
		 EndIf

		 If(StringInStr($FieldName, "phone") OR StringInStr($FieldName, "fax")) Then
			$ArrayPhoneValidate &= quote($FieldName) & ","
			$ArrayPhoneValidateTab &= quote($FieldName & $suffix) & ","
		 EndIf

		 If StringInStr($FieldName, "email") Or StringInStr($FieldName, "website") OR StringInStr($FieldName, "web") Then
			$ArrayEmailValidate &= quote($FieldName) & ","
			$ArrayEmailValidateTab &= quote($FieldName & $suffix) & ","
		 EndIf
	  EndIf

	  $FillData2Form &= FillData2Form($FieldName, $TypeOfField , '')
	  $FillData2FormTab &= FillData2Form($FieldName, $TypeOfField, $suffix)

	  $ValidateForm  &= ValidateForm($FieldName, $TypeOfField, '')
	  $ValidateFormTab  &= ValidateForm($FieldName, $TypeOfField, $suffix)

	  $DrawForm &= registryForm($TypeOfField,'',$FieldName,'')
	  $DrawFormTab &= registryForm($TypeOfField,'',$FieldName, $suffix)

   Next

   $SqlScript = StringLeft($SqlScript,StringLen($SqlScript)-3) &@CRLF & ")"

   $ArrayRequiredValidate = StringReplace($ArrayRequiredValidate, '"id",' , "")
   $ArrayRequiredValidate = StringReplace($ArrayRequiredValidate, ',"nguoiTao"' , "")
   $ArrayRequiredValidate = StringReplace($ArrayRequiredValidate, ',"ngayTao"' , "")
   $ArrayRequiredValidate = StringReplace($ArrayRequiredValidate, ',"nguoiSua"' , "")
   $ArrayRequiredValidate = StringReplace($ArrayRequiredValidate, ',"ngaySua"' , "")
   $ArrayRequiredValidate = StringReplace($ArrayRequiredValidate, ',"xoa"' , "")

   $ArrayRequiredValidateTab = StringReplace($ArrayRequiredValidateTab, quote("id" & $suffix)&',' , "")
   $ArrayRequiredValidateTab = StringReplace($ArrayRequiredValidateTab, ','& quote("nguoiTao" & $suffix) , "")
   $ArrayRequiredValidateTab = StringReplace($ArrayRequiredValidateTab, ','& quote("ngayTao" & $suffix) , "")
   $ArrayRequiredValidateTab = StringReplace($ArrayRequiredValidateTab, ','& quote("nguoiSua" & $suffix) , "")
   $ArrayRequiredValidateTab = StringReplace($ArrayRequiredValidateTab, ','& quote("ngaySua" & $suffix) , "")
   $ArrayRequiredValidateTab = StringReplace($ArrayRequiredValidateTab, ','& quote("xoa" & $suffix) , "")

   $ArrayRequiredValidate = 'String []danhSachRequired = {'& $ArrayRequiredValidate &'};'
   $ArrayRequiredValidateTab = 'String []danhSachRequired = {'& $ArrayRequiredValidateTab &'};'

   $ArrayDateValidate = StringReplace($ArrayDateValidate, ',"ngayTao"' , "")
   $ArrayDateValidate = StringReplace($ArrayDateValidate, ',"ngaySua"' , "")
   $ArrayDateValidateTab = StringReplace($ArrayDateValidateTab, ','& quote("nguoiTao" & $suffix) , "")
   $ArrayDateValidateTab = StringReplace($ArrayDateValidateTab, ','& quote("ngaySua" & $suffix) , "")

   $ArrayDateValidate = 'String []danhSachDate = {'& $ArrayDateValidate &'};'
   $ArrayDateValidateTab = 'String []danhSachDate = {'& $ArrayDateValidateTab &'};'

   $ArrayCmndValidate = 'String []danhsachCMND = {'& $ArrayCmndValidate &'};'
   $ArrayPhoneValidate = 'String []danhsachPhone = {'& $ArrayPhoneValidate &'};'
   $ArrayEmailValidate = 'String []danhsachURL = {'& $ArrayEmailValidate &'};'

   $ArrayCmndValidateTab = 'String []danhsachCMND = {'& $ArrayCmndValidateTab &'};'
   $ArrayPhoneValidateTab = 'String []danhsachPhone = {'& $ArrayPhoneValidateTab &'};'
   $ArrayEmailValidateTab = 'String []danhsachURL = {'& $ArrayEmailValidateTab &'};'

   Local $ArrayValidate = $ArrayRequiredValidate & @CRLF & $ArrayDateValidate & @CRLF & $ArrayCmndValidate & @CRLF & $ArrayPhoneValidate & @CRLF & $ArrayEmailValidate
   $ArrayValidate = StringReplace($ArrayValidate,',}','}')
   $ArrayValidate = StringReplace($ArrayValidate,'{"""','{"')

   Local $ArrayValidateTab = $ArrayRequiredValidateTab & @CRLF & $ArrayDateValidateTab & @CRLF & $ArrayCmndValidateTab & @CRLF & $ArrayPhoneValidateTab & @CRLF & $ArrayEmailValidateTab
   $ArrayValidateTab = StringReplace($ArrayValidateTab,',}','}')
   $ArrayValidateTab = StringReplace($ArrayValidateTab,'{"""','{"')

   Local $PathFolderOut = $WorkingDir & "\" & $TableName

   If FileExists($PathFolderOut) Then
	  Local $yesDialog = MsgBox (4 + 32 + 256 + 262144 + 8192, "", "Folder Jsp existes. Create new one ?")
	  If $yesDialog == 7 Then Return
	  EndIf

   Local $FolderEntity = StringReplace($PathEntity, "vn.dtt." &$Group &".", "")

; ------------------------------------ Lay HANDLE cua cac file ------------------------------------------------------------------------------------------
   Local $HandFileMySQL = FileOpen($PathFolderOut & "\" & $TableName & ".sql", $modeWrite)
   Local $HandFileJavaUtils = FileOpen($PathFolderOut & "\" & $EntityName & "Utils.java", $modeWrite)
   Local $HandFileRegistryJsp = FileOpen($PathFolderOut & "\" & $FolderEntity & "\registry_" & $FolderEntity & "_step.jsp", $modeWrite)
   Local $HandFileReviewJsp = FileOpen($PathFolderOut & "\" & $FolderEntity & "\registry_" & $FolderEntity & "_preview.jsp", $modeWrite)
   Local $HandFileJavaUtilsTab = FileOpen($PathFolderOut & "\" & $suffix & "\"& $EntityName & "Utils" & $suffix & ".java", $modeWrite)
   Local $HandFileRegistryTabJsp = FileOpen($PathFolderOut & "\" & $suffix & "\registry_" & $FolderEntity & "_step.jsp", $modeWrite)
; ------------------------------------ End OF lay HANDLE cua cac file ------------------------------------------------------------------------------------------
   ; -- Noi dung cua Java Utils File
   $JavaUtilsOutPut = CreateJavaUtils($Group, $EntityName, $PathEntity)
   ; Move FillData2Form inTo Java Utils File
   $JavaUtilsOutPut = StringRegExpReplace($JavaUtilsOutPut, "fillData2FormFormService", $FillData2Form)
   $JavaUtilsOutPut = StringRegExpReplace($JavaUtilsOutPut, "validateFormService", $ValidateForm)

   ; -- Noi dung cua Java Utils Tab File
   $JavaUtilsTabOutPut = CreateJavaUtils($Group, $EntityName, $PathEntity)
   ; -- Move FillData2Form inTo Java Utils Tab File
   $JavaUtilsTabOutPut = StringRegExpReplace($JavaUtilsTabOutPut, "fillData2FormFormService", $FillData2FormTab)
   $JavaUtilsTabOutPut = StringRegExpReplace($JavaUtilsTabOutPut, "validateFormService", $ValidateFormTab)

   ; -- JSP File
   $JspRegistryOutPut = CreateJspRegistry($Group, $EntityName, $PathEntity)
   ; -- Dua data vao JSP
   $JspRegistryOutPut = StringRegExpReplace($JspRegistryOutPut, "arrayValidateFormFromService", $ArrayValidate)
   $JspRegistryOutPut = StringRegExpReplace($JspRegistryOutPut, "formJspFromService", $DrawForm)

   ; -- JSP Tab File
   $JspRegistryTabOutPut = CreateJspRegistry($Group, $EntityName, $PathEntity)
   ; -- Dua data vao JSP TAB
   $JspRegistryTabOutPut = StringRegExpReplace($JspRegistryTabOutPut, "arrayValidateFormFromService", $ArrayValidateTab)
   $JspRegistryTabOutPut = StringRegExpReplace($JspRegistryTabOutPut, "formJspFromService", $DrawFormTab)

   $JspReviewOutPut = CreateJspReview($Group, $EntityName, $PathEntity)

   FileWrite($HandFileMySQL , $SqlScript)
   FileWrite($HandFileJavaUtils , $JavaUtilsOutPut)
   FileWrite($HandFileJavaUtilsTab , $JavaUtilsTabOutPut)

   FileWrite($HandFileRegistryJsp , $JspRegistryOutPut)
   FileWrite($HandFileRegistryTabJsp , $JspRegistryTabOutPut)
   FileWrite($HandFileReviewJsp , $JspReviewOutPut)

   FileClose($HandFileMySQL)

   FileClose($HandFileJavaUtils)
   FileClose($HandFileJavaUtilsTab)

   FileClose($HandFileRegistryJsp)
   FileClose($HandFileRegistryTabJsp)

   FileClose($HandFileReviewJsp)

EndFunc

;For Sub ENTITY
Func CreateMySQLFromXML($EntityInput, $PathEntity)

   Local $TableName = StringRegExp($EntityInput, 'table=\"(.+?)\"', 1)[0]
   Local $SqlScript = "Create table " & $TableName & " (" &@CRLF

   Local $Columns = StringRegExp($EntityInput, '(?s)(<column.+?/>)', 3)
   Local $EntityTag = StringRegExp($EntityInput, '(?s)<\s*entity.+?>', 1)
   Local $EntityName = StringRegExp($EntityTag[0], 'name=\"(.+?)\"', 1)[0]
   Local $Group = StringRegExp($PathEntity, 'vn.dtt\.(.+?)\.', 1)[0]
   Local $FolderEntity = StringReplace($PathEntity, "vn.dtt." &$Group &".", "")

   Local $FieldPK = getFieldPK($EntityInput)

   For $i = 0 To UBound($Columns) - 1

	  Local $FieldName = StringRegExp($Columns[$i], $RegexGetFieldName, 1)[0]
	  Local $DbFieldName = StringRegExp($Columns[$i], $RegexGetDbName, 1)[0]
	  Local $TypeOfField = StringRegExp($Columns[$i], $RegexGetTypeName, 1)[0]

	  $SqlScript &= $DbFieldName & " " & ConverDataTypeJava2TypeMySQL($TypeOfField,$DbFieldName)
	  If ($FieldPK==$FieldName) Then
		 $SqlScript &= " primary key" & "," & @CRLF
	  Else
		 $SqlScript &=  "," & @CRLF
	  EndIf
   Next

   ;Set du lieu vao bien Global
   $listVaribleInJsp &= @CRLF & 'List<'&$EntityName&'> '& lowerFirstLetter($EntityName) &' = null;' & @CRLF & _
   'if(request.getAttribute("'&$EntityName&'") != null){' & @CRLF & _
		 lowerFirstLetter($EntityName) &' = (List<'&$EntityName&'>)' & @CRLF & _
		 'request.getAttribute("'&$EntityName&'");' & @CRLF& _
   '}'

   ;include ngoai registry.jsp
   $includeListJspInJsp &= @CRLF & '<jsp:include page="/html/portlet/'&$Group&'/'&$FolderEntity&'/'&StringLower($EntityName)&'.jsp"></jsp:include>'

   ;sessionSetAttribute in ModelUtils.java
   $sessionForList &= @CRLF & 'session.setAttribute("'&$EntityName&'", fillData2Form'&$EntityName&'(request));'

   $SqlScript = StringLeft($SqlScript, StringLen($SqlScript)-3) &@CRLF & ")"

   Return $SqlScript
EndFunc