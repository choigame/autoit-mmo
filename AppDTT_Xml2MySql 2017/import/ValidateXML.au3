
Func ValidateXML($XMLInput)
   Local $Log = ''
   Local $Flag = True
   ; Validate General
   Local $EntityNames = StringRegExp($XMLInput, '(?s)<\s*entity.+?name=\"(.+?)\"', 3)
   Local $TableNames = StringRegExp($XMLInput, '(?s)<\s*entity.+?table=\"(.+?)\"', 3)

   If StringInStr($XMLInput,'""') Then
	  $Log &='Check ""' &@CRLF
	  $Flag = False
   EndIf

   If StringInStr($XMLInput,'==') Then
	  $Log &='Check ==' &@CRLF
	  $Flag = False
   EndIf

   For $j == 0 To UBound($EntityNames) - 2
	  For $n == $j+1 To UBound($EntityNames) - 1
		 If (StringLower($EntityNames[$j]) == StringLower($EntityNames[$n])) Then
			$Log &= "Same Entity Name = " & $EntityNames[$j] &@CRLF
			$Flag = False
		 EndIf
	  Next
   Next

   For $j == 0 To UBound($TableNames) - 2
	  For $n == $j+1 To UBound($TableNames) - 1
		 If (StringLower($TableNames[$j]) == StringLower($TableNames[$n])) Then
			$Log &= "Same Table Name = " & $TableNames[$j] &@CRLF
			$Flag = False
		 EndIf
	  Next
   Next

   ;; Validate tung Entity
   Local $Entities = StringRegExp($XMLInput, '(?s)<\s*entity.+?</entity>', 3)

   For $i = 0 To UBound($Entities) - 1
	  $Log &= "Check Entity: " & $i + 1 &"." &@CRLF

	  Local $TypeOfField = StringRegExp($Entities[$i], $RegexGetTypeName, 3)

	  If @error > 0 Then
		 MsgBox($MB_SYSTEMMODAL+262144+8192, "", "Match Error")
		 $Flag = False
	  EndIf

	  If (getFieldPK($Entities[$i]) == 0) Then
		 $Log &= "Check primary key " &@CRLF
		 $Flag = False
	  EndIf

	  For $h = 0 To UBound($TypeOfField) - 1
			$Type = $TypeOfField[$h]
			If NOT (($Type == 'String') _
			   OR ($Type == 'Date') _
			   OR ($Type == 'long')  _
			   OR ($Type == 'Long')  _
			   OR ($Type == 'boolean')  _
			   OR ($Type == 'Boolean')  _
			   OR ($Type == 'Collection') _
			   OR ($Type == 'Integer') _
			   OR ($Type == 'int')) Then
			   $Log &= "Type = " & $Type & "--> Error" &@CRLF
			   $Flag = False
			EndIf
	  Next

	  Local $FieldNames = StringRegExp($Entities[$i], $RegexGetFieldName, 3)
	  Local $DbFieldNames = StringRegExp($Entities[$i], $RegexGetDbName, 3)

	  Local $FinderFieldNames = StringRegExp($Entities[$i], '(?s)<\s*?finder-column.*?name=\"(.*?)\"', 3)
	  Local $FinderNames = StringRegExp($Entities[$i], '(?s)<\s*?finder\s+.*?name=\"(.*?)\"', 3)

	  For $j = 0 To UBound($FieldNames) - 2
		 For $n == $j+1 To UBound($FieldNames) - 1
			If (StringLower($FieldNames[$j]) == StringLower($FieldNames[$n])) Then
			   $Log &= "Same Field = " & $FieldNames[$j] &@CRLF
			   $Flag = False
			EndIf
		 Next
	  Next

	  For $j == 0 To UBound($DbFieldNames) - 2
		 For $n == $j+1 To UBound($DbFieldNames) - 1
			If (StringLower($FieldNames[$j]) == StringLower($DbFieldNames[$n])) Then
			   $Log &= "Same Db-Field = " & $DbFieldNames[$j] &@CRLF
			   $Flag = False
			EndIf
		 Next
	  Next

	  ;Check trong cung 1 Entity ma co nhieu finderBy trung name
	  For $j = 0 To UBound($FinderNames) - 2
		 For $n = $j + 1 To UBound($FinderNames) - 1
			If $FinderNames[$j] == $FinderNames[$n] Then
			   $Log &= "Same finder-Name = " & $FinderNames[$j] &@CRLF
			   $Flag = False
			EndIf
		 Next
	  Next

	  ;Check finder-name co trung voi 1 fieldName ko?
	  ;Neu trung 1 lan thi count = 1 d/v <finder-column>
	  Local $count = 0

	  For $j = 0 To UBound($FieldNames) - 1
		 For $n = 0 To UBound($FinderFieldNames) - 1
			If $FieldNames[$j] == $FinderFieldNames[$n] Then
			   $count = $count + 1
			EndIf
		 Next
	  Next

	  If  Not ($count == UBound($FinderFieldNames)) Then
		 $Log &= "Check fieldName and finder-column" &@CRLF
		 $Flag = False
	  EndIf
   Next

   If Not $Flag Then
	   MsgBox($MB_SYSTEMMODAL+262144+8192, "Error", $Log)
	   Return False
   EndIf

   Return True
EndFunc

Func getFieldPK($EntityInput)

   Local $count = 0
   Local $PkField
   Local $ColumnsPKs = StringRegExp($EntityInput, '(?s)<column.+?\sprimary=\"true\".*?/>', 3)
   Local $ColumnsPK
   For $i = 0 To UBound($ColumnsPKs) - 1
	  $ColumnsPK = StringRegExp($ColumnsPKs[$i], '(?s)<column.+?\s.*?/>', 3)
	  ConsoleWrite($ColumnsPK &@CRLF)
	  For $j = 0 To UBound($ColumnsPK) - 1
		 If (StringInStr($ColumnsPK[$j],'primary')) then
			$PkField = $ColumnsPK[$j]
			$count = $count + 1
			If $count > 1 Then Return 0
		 EndIf
	  Next
   Next
   $arr = StringRegExp($PkField, '(?s)<column.*?\sname=\"(.+?)\"', 3)
   Return $arr[0]
EndFunc