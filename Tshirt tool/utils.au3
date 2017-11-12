#include-once
#Include <WinAPI.au3>
#include <MsgBoxConstants.au3>




Func upper1stLetter($str)
   Return StringUpper(StringLeft($str, 1)) & StringTrimLeft($str, 1)
EndFunc

Func lower1stLetter($str)
   Return StringLower(StringLeft($str, 1)) & StringTrimLeft($str, 1)
EndFunc

Func strValidate($str)
   $str = trim($str)
   if Not ($str="" or StringInStr($str,"=") or StringInStr($str," ")) Then
	  return 1
   Else
	  Return 0
   EndIf
EndFunc

func quote($str)
   ; x = abc --> x = "abc"
   return '"'& $str & '"'
EndFunc

Func trim($str)
   return StringStripWS($str, 3)
EndFunc





