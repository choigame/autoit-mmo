Func _StringRegExp($input , $template , $index = 0)
	Local $value = StringRegExp($input , $template, 1)
	If  @error == 0 Then
		return $value[$index]
	Else
		return -1
	EndIf
EndFunc

Func _UnicodeToANSI($sString)
	Local $temp =  Execute("'" & StringRegExpReplace($sString, "(\\u([[:xdigit:]]{4}))","' & ChrW(0x$2) & '") & "'")
	If @error == 0 Then Return ReturnNewLine($temp)
	Return StringRegExpReplace($sString, "(\\u([[:xdigit:]]{4}))","' & ChrW(0x$2) & '")
EndFunc   ;==>_UnicodeToANSI

Func ReturnNewLine($input)
	Local $output = ''
	$input = StringReplace($input, "\n" , @CRLF)
	Local $array = StringSplit($input , @CRLF)
	For $i = 0 To UBound($array) - 1
		If  StringRegExp($array[$i] , '(^\s*$)' , 0) <> 1 Then
			If $i < (UBound($array) - 1) Then
				$output &= $array[$i] & @CRLF
			Else
				$output &= $array[$i]
			EndIf
		EndIf
	Next
	Return $output
EndFunc

Func _FileWriteToTest($fileName , $data)
	Local $hOpen = FileOpen(@ScriptDir & '\' & $fileName , 2+8 )
	FileWrite($hOpen , $data)
	FileClose($hOpen)
EndFunc

Func _ConsoleWrite($text)
	ConsoleWrite($text & @CRLF)
EndFunc

Func _IniWrite($pathFile, $section , $key , $value)
	Local $hOpen = FileOpen($pathFile,1 + 8)
	IniWrite($pathFile, $section , $key , $value)
	FileClose($hOpen)
EndFunc



