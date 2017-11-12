#include-once
#Include <WinAPI.au3>
#include <MsgBoxConstants.au3>

Func upperFirstLetter($str)
   Return StringUpper(StringLeft($str, 1)) & StringTrimLeft($str, 1)
EndFunc

Func lowerFirstLetter($str)
   Return StringLower(StringLeft($str, 1)) & StringTrimLeft($str, 1)
EndFunc


Func viToEnglish($str)

$val1="áàảãạâấầẩẫậắằẳẵặă"
$val2="úùủũụứừửữựư"
$val3="íìỉĩị"
$val4="ýỷỹỳ"
$val5="éèẻẽẹếềểễệê"
$val6="đ"
$val7="óòỏõọơớởờỡợôốồổỗộ"
$val8='<>.,/?\;~"{}|=!@#$%^&*()'
$val9="'"
$str=StringLower($str)

Local $r=""
Local $a[StringLen($str)]
For $i=0 to StringLen($str)-1
   $a[$i]= StringMid($str, $i+1, 1)

    if $a[$i]=" " then ContinueLoop


   if(StringInStr($val1,$a[$i])) then
	  $r &="a"
	  ContinueLoop
   EndIf

    if(StringInStr($val2,$a[$i])) then
	  $r &="u"
	  ContinueLoop
   EndIf

   if(StringInStr($val3,$a[$i])) then
	  $r &="i"
	  ContinueLoop
   EndIf

  if(StringInStr($val4,$a[$i])) then
	  $r &="y"
	  ContinueLoop
   EndIf

    if(StringInStr($val5,$a[$i])) then
	  $r &="e"
	  ContinueLoop
   EndIf

   if(StringInStr($val6,$a[$i])) then
	  $r &="d"
	  ContinueLoop
   EndIf

   if(StringInStr($val7,$a[$i])) then
	  $r &="o"
	  ContinueLoop
   EndIf

   if(StringInStr($val8,$a[$i])) then
	  $r &=""
	  ContinueLoop
   EndIf

   if(StringInStr($val9,$a[$i])) then
	  $r &=""
	  ContinueLoop
   EndIf
   $r &=$a[$i]
Next
return $r
EndFunc

Func isDigist($val,$message,$id)
   Local $str = "0123456789"
   Local $a[StringLen($val)]
   for $i=0 to StringLen($val)-1
	  $a[$i]= StringMid($val, $i+1, 1)
	  if Not StringInStr($str,$a[$i]) then
		 GUICtrlSetBkColor($id,$xanhLaChuoi)
		  _WinAPI_SetFocus(ControlGetHandle("", "", $id))
		 MsgBox($MB_ICONERROR+262144+8192,"Error",$message&"  0-9")
		 return false
	  EndIf
	  Next
	  return true
EndFunc

Func isCharAndDigist($val,$message,$id)
   Local $str = "0123456789qwertyuiopasdfghjklzxcvbnm"
   Local $a[StringLen($val)]
   for $i=0 to StringLen($val)-1
	  $a[$i]= StringMid($val, $i+1, 1)
	  if Not StringInStr($str,$a[$i]) then
		 GUICtrlSetBkColor($id,$xanhLaChuoi)
		  _WinAPI_SetFocus(ControlGetHandle("", "", $id))
		 MsgBox($MB_ICONERROR+262144+8192,"Error",$message&" chỉ cho phép 0-9a-Z ")
		 return false
	  EndIf
	  Next
	  return true
EndFunc

Func isCharAndDigistAndDot($val,$message,$id)
   Local $str = "0123456789qwertyuiopasdfghjklzxcvbnm."
   Local $a[StringLen($val)]
   for $i=0 to StringLen($val)-1
	  $a[$i]= StringMid($val, $i+1, 1)
	  if Not StringInStr($str,$a[$i]) then
		 GUICtrlSetBkColor($id,$xanhLaChuoi)
		 _WinAPI_SetFocus(ControlGetHandle("", "", $id))
		 MsgBox($MB_ICONERROR+262144+8192,"Error",$message&" chỉ cho phép 0-9a-Z. ")
		 return false
	  EndIf
	  Next
	  return true
   EndFunc

Func isCharAndDigistAnd($val,$message,$id,$custom)
   Local $str = "0123456789qwertyuiopasdfghjklzxcvbnm" &$custom
   Local $a[StringLen($val)]
   for $i=0 to StringLen($val)-1
	  $a[$i]= StringMid($val, $i+1, 1)
	  if Not StringInStr($str,$a[$i]) then
		 GUICtrlSetBkColor($id,$xanhLaChuoi)
		 _WinAPI_SetFocus(ControlGetHandle("", "", $id))
		 MsgBox($MB_ICONERROR+262144+8192,"Error",$message&" chỉ cho phép 0-9a-Z"&$custom&" ")
		 return false
	  EndIf
	  Next
	  return true
   EndFunc

Func isCharAndDigistAnd_($val,$message,$id)
   Local $str = "0123456789qwertyuiopasdfghjklzxcvbnm_"
   Local $a[StringLen($val)]
   for $i=0 to StringLen($val)-1
	  $a[$i]= StringMid($val, $i+1, 1)
	  if Not StringInStr($str,$a[$i]) then
		 GUICtrlSetBkColor($id,$xanhLaChuoi)
		 _WinAPI_SetFocus(ControlGetHandle("", "", $id))
		 MsgBox($MB_ICONERROR+262144+8192,"Error",$message&" chỉ cho phép 0-9a-Z_ ")
		 return false
	  EndIf
	  Next
	  return true
   EndFunc

Func isChar($val,$message,$id)
   Local $str = "qwertyuiopasdfghjklzxcvbnm"
   Local $a[StringLen($val)]
   for $i=0 to StringLen($val)-1
	  $a[$i]= StringMid($val, $i+1, 1)
	  if Not StringInStr($str,$a[$i]) then
		 GUICtrlSetBkColor($id,$xanhLaChuoi)
		 _WinAPI_SetFocus(ControlGetHandle("", "", $id))
		 MsgBox($MB_ICONERROR+262144+8192,"Error",$message&" chỉ cho phép a-Z ")
		 return false
	  EndIf
	  Next
	  return true
   EndFunc

Func isNotDotFirstAndLast($val,$message,$id)
   If (StringRight($val, 1)=".") OR (StringLeft($val, 1)=".") Then
	  MsgBox($MB_ICONERROR+262144+8192,"Error","Field "&$message&" not begin and end with .")
	  GUICtrlSetBkColor($id,$xanhLaChuoi)
	  _WinAPI_SetFocus(ControlGetHandle("", "", $id))
	  Return false
   EndIf
   GUICtrlSetBkColor($id,$white)
   Return true
EndFunc

Func strValidate($str)
   $str = trim($str)
   if Not ($str="" or StringInStr($str,"=") or StringInStr($str," ")) Then
	  return 1
   Else
	  Return 0
   EndIf
EndFunc

Func quote($str)
   ; x = abc --> x = "abc"
   return '"'& $str & '"'
EndFunc

Func trim($str)
   return StringStripWS($str, 3)
EndFunc

Func readKeyIniFile($pathFile,$sectionName)
   return IniReadSection($pathFile, $sectionName)
EndFunc

Func isValidateInputFolderJSP($val,$message,$id)

   $val = trim($val)

   If StringRegExp($val, '^[a-zA-Z0-9]+(\/[a-zA-Z0-9]+)*$') <> 1 Then
	  GUICtrlSetBkColor($id, $red)
	  _WinAPI_SetFocus(ControlGetHandle("", "", $id))
	  MsgBox($MB_ICONERROR+262144+8192,"Error",$message&" sai định dạng." & @CRLF & "Ví dụ ab hoặc sub/main")
	  Return False
   EndIf

   Return True
EndFunc


Func isValidateInputFolderEntity($val,$message,$id)
   $val = trim($val)
   If StringRegExp($val, '^[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)*$') <> 1 Then
	  GUICtrlSetBkColor($id, $red)
	  _WinAPI_SetFocus(ControlGetHandle("", "", $id))
	  MsgBox($MB_ICONERROR+262144+8192,"Error",$message&" sai định dạng." & @CRLF & "Ví dụ giayphep hoặc name.giayphep")
	  Return False
   EndIf

   Return True
EndFunc

Func isValidateInputEntityName($val,$message,$id)
   $val = trim($val)
   If StringRegExp($val, '^[a-zA-Z0-9]+(_[a-zA-Z0-9]+)*$') <> 1 Then
	  GUICtrlSetBkColor($id, $red)
	  _WinAPI_SetFocus(ControlGetHandle("", "", $id))
	  MsgBox($MB_ICONERROR+262144+8192,"Error",$message&" sai định dạng." & @CRLF & "Ví dụ Name_GiayPhep hoặc Name_GiayPhep")
	  Return False
   EndIf

   Return True
EndFunc

Func _FileOpenTemplate($path, $fileName)
   Local $hand = FileOpen($path & $fileName)

   If ($hand == -1) Then
	  MsgBox($MB_ICONERROR+262144+8192, $ErrorDiaglogTitle, $fileName & " Not found!")
	  Return
   EndIf

   Return $hand
EndFunc

