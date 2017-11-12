
Func pngDesign()
   local $files = FileOpenDialog("PNGs",@ScriptDir,"Images (*.png)", $FD_FILEMUSTEXIST + $FD_MULTISELECT)

   if (@error == 1) Then
	  ; ko chon file
	  return;
   ElseIf (@error = 0) then
	  GUICtrlSetData($txtAreaPNG,$files)
   EndIf
EndFunc

Func sunfrogLogin()
   GUICtrlSetState($sunfrogLogin, $GUI_DISABLE)
   If ($SUNFROG_SESSION_LOGIN = '') Then
	  Local $USER= GUICtrlRead($sunfrogUser)
	  Local $PASS= GUICtrlRead($sunfrogPass)

	  $SUNFROG_SESSION_LOGIN = sunfrogProgressLogin($USER,$PASS)

	  If $SUNFROG_SESSION_LOGIN = '' Then
		 MsgBox($MB_ICONERROR+262144+8192,"Error", $LOGIN_FAIL)
		 $IS_SUNFROG_LOGIN = False
	  Else
		 $IS_SUNFROG_LOGIN = True
		 GUICtrlSetData($sunfrogLogin, $LOGOUT)
	  Endif
   Else
	  $SUNFROG_SESSION_LOGIN = ''
	  $IS_SUNFROG_LOGIN = False
	  GUICtrlSetData($sunfrogLogin, $LOGIN)
   EndIf

   GUICtrlSetState($sunfrogLogin, $GUI_ENABLE)
  ; ConsoleWrite($SUNFROG_SESSION_LOGIN & " . " &  $IS_SUNFROG_LOGIN &@CRLF)

EndFunc


Func uploadSunfrogCamp()

   If $SUNFROG_SESSION_LOGIN = '' Then
	  MsgBox($MB_ICONERROR+262144+8192,"Error", $LOGIN_FIST)
	  Return
   Endif

   ;Required
   Local $pngPaths = trim(GUICtrlRead($txtAreaPNG))
   Local $title = trim(GUICtrlRead($titleCamp))
   Local $desc = trim(GUICtrlRead($descCamp))
   Local $category = GUICtrlRead($categoriesCampCombo)

#comments-start
   $chkGuysTee
   $chkLadyTee
   $chkHoodie
   $chkSweat
   $chkUniLSleeve
   $chkColorMug

   $chkGuysColor
   $chkLadyColor
   $chkHoodieColor
   $chkSweatColor
   $chkUniLSleeveColor
#comments-end


   Local $isDataValid = UtilsValidateCamp($pngPaths,$title,$desc,$category,$chkGuysTee,$chkLadyTee,$chkHoodie,$chkSweat,$chkUniLSleeve,$chkGuysColor,$chkLadyColor,$chkHoodieColor,$chkSweatColor,$chkUniLSleeveColor,$chkColoredMug)
   If Not ($isDataValid = '') Then
	  MsgBox($MB_ICONERROR+262144+8192,"Error", $isDataValid)
	  Return
   EndIf

   GUICtrlSetState($sunfrogUploadCampBtn, $GUI_DISABLE)

   ;Optional
   Local $keyword = trim(GUICtrlRead($keywordCamp))

   Local $collection = GUICtrlRead($collectionCampCombo)
   If $collection = $CHOOSE Then $collection = ''

   Local $isBack = GUICtrlRead($chkBackDesign)

;------------------------------------- logic ---------------------------------
   Local $sunfrogImagesJSON
   Local $sunfrogKeyWordsJSON

   Local $hSunfrogDataUploadTemp = @ScriptDir & $sunfrogDataUploadJSONTemp
   Local $sunfrogDataUpload = FileRead($hSunfrogDataUploadTemp)

   ; TypesJSON
   Local $sunfrogTypesJSON = SunfrogTypesJSON($chkGuysTee,$chkLadyTee,$chkHoodie,$chkSweat,$chkUniLSleeve,$chkGuysColor,$chkLadyColor,$chkHoodieColor,$chkSweatColor,$chkUniLSleeveColor,$chkColoredMug)

   #comments-start
	  D:\Autoit Project\winhttp|abc.png|design.png
	  ImageJSON
   #comments-end

   Local $sunfrogCategoryJSON = SunfrogCategoryJSON($category)

   $sunfrogDataUpload = StringReplace($sunfrogDataUpload,  '#CATEGORY', $sunfrogCategoryJSON)
   $sunfrogDataUpload = StringReplace($sunfrogDataUpload,  '#TYPES', $sunfrogTypesJSON)
   $sunfrogDataUpload = StringReplace($sunfrogDataUpload,  '#COLLECTION', $collection)

   Local $pngs = pathFilesToArray($pngPaths)
   Local $sunfrogDataUploadFinal = ''

   If (UBound($pngs) > 0) Then
	  ; >=2 files
	  For $i=0 to UBound($pngs) - 1
		 $sunfrogDataUploadFinal = dataUpload($sunfrogDataUpload, $pngs[$i] , $keyword , $title, $desc , $isBack)
		 sleep(50)
		 ;uploadSunfrogCampProgress($sunfrogDataUploadFinal)
		 ;ConsoleWrite($sunfrogDataUploadFinal & @CRLF)
	  Next
   Else
	  ; 1 file PNG

	  $sunfrogDataUploadFinal = dataUpload($sunfrogDataUpload, $pngs , $keyword , $title, $desc, $isBack)
	  uploadSunfrogCampProgress($sunfrogDataUploadFinal)

	 ;ConsoleWrite($sunfrogDataUploadFinal)
  EndIf

   GUICtrlSetState($sunfrogUploadCampBtn, $GUI_ENABLE)
EndFunc

Func uploadSunfrogCampProgress($sunfrogDataUploadFinal)
  $h = FileOpen(@ScriptDir &'\data.txt',10)
  FileWrite($h,$sunfrogDataUploadFinal)
  FileClose($h)
   _HttpRequest(2, $SUNFROG_UPLOAD_URL, $sunfrogDataUploadFinal, $SUNFROG_SESSION_LOGIN)
EndFunc

Func  dataUpload($sunfrogDataUpload, $pngs , $keyword , $title, $desc, $isBack)

   $sunfrogImagesJSON = SunfrogImagesJSON($pngs)
   $sunfrogKeyWordsJSON = SunfrogKeyWordsJSON($keyword, $pngs)
   $sunfrogTitleJSON = SunfrogTitleJSON($title, $pngs)
   $sunfrogDescJSON = SunfrogTitleJSON($desc, $pngs)

   Local $hSunfrogImageFrontJSONTemp = @ScriptDir & $sunfrogImageFrontJSONTemp
   Local $sunfrogImageFrontJSON = FileRead($hSunfrogImageFrontJSONTemp)

   Local $hSunfrogImageBackJSONTemp = @ScriptDir & $sunfrogImageBackJSONTemp
   Local $sunfrogImageBackJSON = FileRead($hSunfrogImageBackJSONTemp)


    ;phu thuoc vao PNG
   If $isBack = 1 Then
		 $sunfrogDataUpload = StringReplace($sunfrogDataUpload,  '#IMAGEFRONT', "")
		 $sunfrogDataUpload = StringReplace($sunfrogDataUpload,  '#IMAGEBACK', $sunfrogImageBackJSON)
   Else
		 $sunfrogDataUpload = StringReplace($sunfrogDataUpload,  '#IMAGEBACK', "")
		 $sunfrogDataUpload = StringReplace($sunfrogDataUpload,  '#IMAGEFRONT', $sunfrogImageFrontJSON)
   EndIf


   $sunfrogDataUpload = StringReplace($sunfrogDataUpload,  '#DESC', $sunfrogDescJSON)
   $sunfrogDataUpload = StringReplace($sunfrogDataUpload,  '#TITLE', $sunfrogTitleJSON)
   $sunfrogDataUpload = StringReplace($sunfrogDataUpload,  '#KEYWORDS', $sunfrogKeyWordsJSON)
   return StringReplace($sunfrogDataUpload,  '#IMAGES', $sunfrogImagesJSON)
EndFunc
