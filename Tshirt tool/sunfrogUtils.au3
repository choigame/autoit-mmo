#include <Array.au3>
#include 'http\_HttpRequest.au3'

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

Func fileNameFromPath($file)
  Local $arr = StringSplit($file,"\")
  Local $fileName = $arr[$arr[0]]

  $fileName =  StringReplace($fileName," ","")
  $fileName =  StringReplace($fileName,".png","")

  Return upper1stLetter($fileName)
EndFunc

Func UtilsValidateSunfrogCamp($pngPaths,$title,$desc,$category,$chkGuysTee,$chkLadyTee,$chkHoodie,$chkSweat,$chkUniLSleeve,$chkGuysColor,$chkLadyColor,$chkHoodieColor,$chkSweatColor,$chkUniLSleeveColor,$chkColoredMug)

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

   if Not $isGuysColor then Return msgValidateColorPick('Guys')
   if Not $isLadyColor then Return msgValidateColorPick('Lady')
   if Not $isHoodieColor then Return  msgValidateColorPick('Hoodie')
   if Not $isSweatColor then Return  msgValidateColorPick('Sweat')
   if Not $isUniLSleeveColor then Return  msgValidateColorPick('UnisexSleeve')

   if $pngPaths = '' Then
	  Return 'Choosen png'
   EndIf

   if $title = '' Then
	  Return 'Fill Title'
   EndIf

   if $desc = '' Then
	  Return 'Fill Description'
   Else
	  $desc = StringRegExpReplace($desc, "\s{2,}"," ")

	  Local $words = StringSplit($desc," ")
	  ConsoleWrite($words[0])
	  If $words[0]> ($sunfrogDescWordLength + 1) Then
		 Return 'Description max '& $sunfrogDescWordLength &' words'
	  EndIf
   EndIf

   if $category = $CHOOSE Then
	  Return 'Choose CATEGORY'
   EndIf

   Return ''
EndFunc

Func validApparelColor($chk,$chkColor)
	  Local $num = 0
      If (GUICtrlRead($chk) = 1) Then
		 For $i = 0 To UBound($chkColor) - 1
			If (GUICtrlRead($chkColor[$i]) = 1) Then
			   $num = $num + 1
			EndIf
		 Next

		 If ($num <= $SUNFROG_MAX_COLOR_PICK) AND ($num > 0) Then
			Return True
		 EndIf

		 Return False
	  Else
		 Return true
	  EndIf
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




Func SunfrogTitleJSON($title, $png)

   Local $r = ""

   If StringInStr($title,"#KEY") Then
	  Local $fileName = fileNameFromPath($png)
	  $r = StringReplace($title,"#KEY",$fileName)
   EndIf

   Return $r

EndFunc


Func sunfrogProgressLogin($USER, $PASS)

   Local $data = _HttpRequest(1, $SUNFROG_LOGIN_URL) ; 1 = get Header, 2 = get code html
   Local $cookieVisitPage = _GetCookie($data)

   Local $dataLogin = "username="&_URIEncode($USER)&"&password="&$PASS&"&login=Login"

   $data = _HttpRequest(1, $SUNFROG_LOGIN_URL, $dataLogin, $cookieVisitPage, $SUNFROG_LOGIN_URL)

   If Not (StringInStr($data, 'index.cfm?dashboard')) Then
	  Return ''
   EndIf

   $cookieAfterLogin  = _GetCookie($data)

   Return $cookieAfterLogin

  ; _HttpRequest(2, $SUNFROG_UPLOAD_URL, $dataUpload, $cookieFinal)

EndFunc


Func SunfrogCategoryJSON($category)
   Local $categoryDB = @ScriptDir & $sunfrogCategoryDB
   Local $db = FileRead($categoryDB)
   Local $regex = '<option value="(.+)">'&$category
   Local $out = StringRegExp($db , $regex , 3)

   if @error = 0 Then
		 return $out[0]
	  Else
		 sysout("error sunfrogUtils SunfrogCategoryJSON")
		 return 82 ; hobby
   Endif
EndFunc

Func msgValidateColorPick($txt)
   return 'Choosen '&$txt&' Color (Max='&$SUNFROG_MAX_COLOR_PICK&')'
EndFunc





