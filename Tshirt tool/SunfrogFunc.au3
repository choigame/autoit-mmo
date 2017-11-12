
Func pngDesign()
   local $files = FileOpenDialog("PNGs",@ScriptDir,"Images (*.png)", $FD_FILEMUSTEXIST + $FD_MULTISELECT)

   if (@error == 1) Then
	  ; ko chon file
	  return;
   ElseIf (@error = 0) then
	  GUICtrlSetData($txtAreaPNG,$files)
   EndIf
EndFunc

Func uploadDesign()

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

#comments-start
   Local $isDataValid = UtilsValidateCamp($pngPaths,$title,$desc,$category,$chkGuysTee,$chkLadyTee,$chkHoodie,$chkSweat,$chkUniLSleeve,$chkGuysColor,$chkLadyColor,$chkHoodieColor,$chkSweatColor,$chkUniLSleeveColor,$chkColoredMug)
   If Not ($isDataValid = '') Then
	  MsgBox($MB_ICONERROR+262144+8192,"Error", $isDataValid)
	  Return
   EndIf
#comments-end

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

   $sunfrogDataUpload = StringReplace($sunfrogDataUpload,  '#CATEGORY', $category)
   $sunfrogDataUpload = StringReplace($sunfrogDataUpload,  '#TYPES', $sunfrogTypesJSON)
   $sunfrogDataUpload = StringReplace($sunfrogDataUpload,  '#COLLECTION', $collection)

   Local $pngs = pathFilesToArray($pngPaths)
   Local $sunfrogDataUploadFinal = ''

   If (UBound($pngs) > 0) Then
	  ; >=2 files
	  For $i=0 to UBound($pngs) - 1
		 $sunfrogDataUploadFinal = sendUpload($sunfrogDataUpload, $pngs[$i] , $keyword , $title, $desc , $isBack)
		 ;upload($sunfrogDataUploadFinal)
		 ConsoleWrite($sunfrogDataUploadFinal & @CRLF)
	  Next
   Else
	  ; 1 file PNG

	  $sunfrogDataUploadFinal = sendUpload($sunfrogDataUpload, $pngs , $keyword , $title, $desc, $isBack)
	 ;upload($sunfrogDataUploadFinal)

	 ConsoleWrite($sunfrogDataUploadFinal)
   EndIf

EndFunc

Func  sendUpload($sunfrogDataUpload, $pngs , $keyword , $title, $desc, $isBack)

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
