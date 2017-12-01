#include <Array.au3>

Func spySunfrog()
   local $urlSpyConfig = $SUNFROG_SPY_URL

   Local $keyword = trim(GUICtrlRead($sunfrogKeyword))
   Local $pageFrom = trim(GUICtrlRead($sunfrogOffsetFrom))
   Local $pageTo = trim(GUICtrlRead($sunfrogOffsetTo))
   Local $filter = trim(GUICtrlRead($sunfrogFilter))

   if $keyword = '' or $pageFrom = '' or $pageTo = '' Then
	  MsgBox($MB_ICONERROR+262144+8192,"Error", "Fill Params")
	  Return
   EndIf

   if Not isCharAndDigit($keyword, "keyword") Then
	  return
   EndIf

   if Not isDigist($pageFrom, "page from") Then
	  return
   EndIf

   if Not isDigist($pageTo, "page to") Then
	  return
   EndIf

   If ($pageTo - $pageFrom) < 0 Then
	  MsgBox($MB_ICONERROR+262144+8192,"Error", "Invalid From and To")
	  Return
   EndIf

   setDisable($spySunfrogBtn)

   Local $urlSpy
   Local $offset
   Local $data
   Local $arraySKU

   #comments-start
;   Local $collectionID = trim(GUICtrlRead($sunfrogCollectionID))
   if StringLen($collectionID) > 0 Then

	  if Not isDigist($collectionID, "Collection ID") Then
		 setEnable($spySunfrogBtn)
		 return
	  EndIf
	  if $SUNFROG_SESSION_LOGIN = '' Then
		 $SUNFROG_SESSION_LOGIN = sunfrogProgressLogin("dactandn@gmail.com", "handoi11")
		 sysout("login")
	  EndIf

	  If StringLen($SUNFROG_SESSION_LOGIN) > 0 Then
		 Local $ref = "https://manager.sunfrogshirts.com/Collections/collections-edit.cfm?collectionID="& $collectionID
		 Local $dataInCollection = _HttpRequest(1, $ref, '' , $SUNFROG_SESSION_LOGIN, $ref)
		 $cookieForCollection = _GetCookie($dataInCollection)
		  sysout("$cookieForCollection = " & $cookieForCollection)
	  EndIf
   EndIf
   #comments-end

   Local $pageFromTemp = $pageFrom
   Local $pageToTemp = $pageTo

   While ($pageTo - $pageFrom) >= 0

	  If $pageFrom = 1 then
		 $offset = 0
	  Else
		  $offset = ($pageFrom-1) * 40 + 1
	  EndIf

	  $urlSpy = $urlSpyConfig & '&schTrmFilter='&$filter & '&offset=' &  $offset & '&search=' & _URIEncode($keyword)
	  sysout($urlSpy)

	  $data = _HttpRequest(2, $urlSpy)

	  #comments-start
	  Local $open = @ScriptDir&'\sunfrog-spy\out.txt'
	  FileWrite($open,$data)
	  #comments-end

	  $arraySKU = StringRegExp($data, "/(\d{9}-\d{9})\.html",3)

	  Local $outputDir = @ScriptDir&'\sunfrog-spy\'
	  Local $outputFileName = $keyword & "-" & $pageFromTemp & "-" & $pageToTemp & "-" & $filter & ".txt"
	  Local $hOut = FileOpen($outputDir & "\" & $outputFileName , 1+8)

	  FileWriteLine($hOut,"---Page " & $pageFrom)

	  For $i=0 to UBound($arraySKU) - 1
		 Local $idAo = StringSplit($arraySKU[$i],"-")[1]
		 Local $js = 'addItem(' & $idAo & ');'
		 FileWriteLine($hOut, $js)
	  Next

	  Local $arraySKU10So = StringRegExp($data, "/(\d+-\d{10})\.html",3)

	  FileWriteLine($hOut,"---SKU 10 so")

	   For $i=0 to UBound($arraySKU10So) - 1
		 FileWriteLine($hOut,$arraySKU10So[$i])
	  Next

	  #comments-start
	  if StringLen($collectionID) > 0 Then
		 For $i=0 to UBound($arraySKU) - 1
			Local $idAo = StringSplit($arraySKU[$i],"-")[1]
			Local $urlAdd  = "https://manager.sunfrogshirts.com/Collections/ajax_collectionADDItem.cfm?collectionid=" &$collectionID& "&m="&$idAo
			_HttpRequest(2, $urlAdd, '' , $cookieForCollection)
			sleep(500)
		 Next
	  EndIf
	  #comments-end
	  ;_ArrayDisplay($arraySKU)

	  $pageFrom = $pageFrom + 1
   WEnd

   setEnable($spySunfrogBtn)
   MsgBox(0,"","Finish SPY")
EndFunc


Func copyCollectionHelp()
 ;  Local $help = FileRead(@ScriptDir & $sunfrogCloneCollection)
 ;  GUICtrlSetData($sunfrogCollectionItems, $help)
   Run("Explorer.exe " & @ScriptDir & $sunfrogCloneCollection)
EndFunc

Func copyCollection()
   Local $result = ''
   Local $data = GUICtrlRead($sunfrogCollectionItems)

   if $data = '' Then
	  MsgBox($MB_ICONERROR+262144+8192,"Error", "Fill Collection Item")
	  Return
   EndIf
   #comments-start

   Local $arraySKU = StringRegExp($data, "/(\d+-\d{8,10})\.html",3)
   For $i=0 to UBound($arraySKU) - 1
	  Local $idAo = StringSplit($arraySKU[$i],"-")[1]
	  Local $js = 'addItem(' & $idAo & ');'
	  $result &= $js & @CRLF
   Next


   $result &= "*** SKU 10 số ***" & @CRLF

   Local $arraySKU10So = StringRegExp($data, "/(\d+-\d{10})\.html",3)

   For $i=0 to UBound($arraySKU10So) - 1
	  $result &= $arraySKU10So[$i] & @CRLF
   Next
   #comments-end

   Local $arraySKU = StringRegExp($data, "\d+",3)
   $result = 'var arr = ['
   for $i = 0 to UBound($arraySKU) - 1
	  if $i = UBound($arraySKU) - 1 Then
		 $result &= $arraySKU[$i]
	  Else
		 $result &= $arraySKU[$i] & ','
	  EndIf
   Next

   $result &= '];' & @CRLF

   Local $js =  'for (var i=0; i<' & UBound($arraySKU) &  '; i++) (function(t) {' & _
	  'window.setTimeout(function() {' & _
	  'console.log(t);' & _
	  'addItem(arr[t]);' & _
	  '}, 3000)' & _
	  '}(i))'


   $result &= $js

   ClipPut($result)

   GUICtrlSetData($sunfrogCollectionItemsFilter, $result)

EndFunc

