#include <Array.au3>


Func StrToArray($Str)
   return StringSplit($Str,",")
EndFunc

Func pathFilesToArray($path)
; D:\Autoit Project\winhttp|abc.png|design.png

If (Not StringInStr($path,"|")) Then
   return $path
EndIf

Local $arr = StringSplit($path,"|")
Local $root = $arr[1] & "\"
Local $result[UBound($arr)-2]

for $i = 0 to UBound($arr)-3
   $result[$i] = $root & $arr[$i+2]
Next
   return $result
EndFunc


Func UtilsValidateCamp($pngPaths,$title,$desc,$category,$chkGuysTee,$chkLadyTee,$chkHoodie,$chkSweat,$chkUniLSleeve,$chkGuysColor,$chkLadyColor,$chkHoodieColor,$chkSweatColor,$chkUniLSleeveColor,$chkColoredMug)

   Local $isPickApparel = false

   If (GUICtrlRead($chkGuysTee) = 1) Then $isPickApparel = true
   If (GUICtrlRead($chkLadyTee) = 1) Then $isPickApparel = true
   If (GUICtrlRead($chkHoodie) = 1) Then $isPickApparel = true
   If (GUICtrlRead($chkSweat) = 1) Then $isPickApparel = true
   If (GUICtrlRead($chkUniLSleeve) = 1) Then $isPickApparel = true

 ;  If (GUICtrlRead($chkColoredMug) = 1) Then $isPickApparel = true

   If Not $isPickApparel Then Return 'Choosen Apparel'

   ; color
   Local $isGuysColor = false
   Local $isLadyColor = false
   Local $isHoodieColor = false
   Local $isSweatColor = false
   Local $isUniLSleeveColor = false

   $isGuysColor = validApparelColor($chkGuysTee,$chkGuysColor)
   $isLadyColor = validApparelColor($chkLadyTee,$chkLadyColor)
   $isHoodieColor = validApparelColor($chkHoodie,$chkHoodieColor)
   $isSweatColor = validApparelColor($chkSweat,$chkSweatColor)
   $isUniLSleeveColor = validApparelColor($chkUniLSleeve,$chkUniLSleeveColor)

   if Not $isGuysColor then Return 'Choosen Guys Color'
   if Not $isLadyColor then Return 'Choosen Lady Color'
   if Not $isHoodieColor then Return 'Choosen Hoodie Color'
   if Not $isSweatColor then Return 'Choosen Sweat Color'
   if Not $isUniLSleeveColor then Return 'Choosen Unisex Sleeve Color'

   if $pngPaths = '' Then
	  Return 'Choosen png'
   EndIf

   if $title = '' Then
	  Return 'Fill Title'
   EndIf

   if $desc = '' Then
	  Return 'Fill Description'
   Else
	  Local $words = StringSplit($desc," ")
	  ConsoleWrite($words)
	  If $words > ($descWordLength + 1) Then
		 Return 'Description Only Up To 30 words'
	  EndIf
   EndIf

   if $category = $CHOOSE Then
	  Return 'Choose CATEGORY'
   EndIf

   Return ''
EndFunc

Func validApparelColor($chk,$chkColor)
      If (GUICtrlRead($chk) = 1) Then
		 For $i = 0 To UBound($chkColor) - 1
			if (GUICtrlRead($chkColor[$i]) = 1) Then Return true
		 Next
		 Return false
	  Else
		 Return true
	  EndIf

	  Return false
   EndFunc

Func SunfrogTypesJSON($chkGuysTee,$chkLadyTee,$chkHoodie,$chkSweat,$chkUniLSleeve,$chkGuysColor,$chkLadyColor,$chkHoodieColor,$chkSweatColor,$chkUniLSleeveColor,$chkColoredMug)

   Local $temp = ''

   $temp &= teesType($chkGuysTee,$chkGuysColor, $SUNFROG_GUYSTEE)
   $temp &= teesType($chkLadyTee,$chkLadyColor, $SUNFROG_LADYTEE)
   $temp &= teesType($chkHoodie,$chkHoodieColor, $SUNFROG_HOODIE)
   $temp &= teesType($chkSweat,$chkSweatColor, $SUNFROG_SWEAT)
   $temp &= teesType($chkUniLSleeve,$chkUniLSleeveColor, $SUNFROG_UNILSLEEVE)
   $temp =  StringTrimLeft($temp,1)

   return $temp

EndFunc

Func teesType($chkTee,$chkColor,$TYPE)

   if GUICtrlRead($chkTee) = 1 Then
	  Local $htemp = @ScriptDir &$sunfrogTypeJSONTemp
	  local $temp = FileRead($htemp)

	  $temp = StringReplace($temp,"#ID" , $TYPE[0])
	  $temp = StringReplace($temp,"#NAME" , $TYPE[1])
	  $temp = StringReplace($temp,"#PRICE" , $TYPE[2])

	  local $colors = ''

	  For $i = 0 To UBound($chkColor) - 1
		 if (GUICtrlRead($chkColor[$i]) = 1) Then $colors &= "," & quote(GUICtrlRead($chkColor[$i],1))
	  Next

	  $temp = StringReplace($temp,"#COLORS" , StringTrimLeft($colors,1))
	  return "," & $temp
   EndIf
   ; {"id":8,"name":"Guys Tee","price":19,"colors":["Black","Navy Blue"]}
   Return ''
EndFunc

Func SunfrogImagesJSON($pngs)
   Local $base64 = base64($pngs)
   Local $htemp = @ScriptDir &$sunfrogimagesJSONTemp
   local $temp = FileRead($htemp)

   return StringReplace($temp,"#BASE64" , $base64)
EndFunc

func base64($png)
   $dat=FileRead(FileOpen($png,16))
   $objXML=ObjCreate("MSXML2.DOMDocument")
   $objNode=$objXML.createElement("b64")
   $objNode.dataType="bin.base64"
   $objNode.nodeTypedValue=$dat

   local $out = StringRegExpReplace($objNode.Text,"\n","")
   return $out
EndFunc

Func SunfrogKeyWordsJSON($keyword, $png)

   Local $r = ""
   Local $fileName = fileNameFromPath($png)

   If $keyword = '' Then
	  $r = quote($fileName)
   Else
	  Local $arr = StringSplit($keyword," ")
	  if $arr[0] = 1 Then
		 $r = quote($fileName) & "," & quote($arr[1])

	  Elseif $arr[0] >= 2 Then
		 $r = quote($fileName)   & "," & quote($arr[1])  & "," & quote($arr[2])
	  EndIf

  EndIf

  return $r

EndFunc


Func fileNameFromPath($file)
  Local $arr = StringSplit($file,"\")
  Local $fileName = $arr[$arr[0]]

  $fileName =  StringReplace($fileName," ","")
  $fileName =  StringReplace($fileName,".png","")

  Return upper1stLetter($fileName)
EndFunc

Func SunfrogTitleJSON($title, $png)

   Local $r = ""

   If StringInStr($title,"#KEY") Then
	  Local $fileName = fileNameFromPath($png)
	  $r = StringReplace($title,"#KEY",$fileName)
   EndIf

   Return $r

EndFunc





