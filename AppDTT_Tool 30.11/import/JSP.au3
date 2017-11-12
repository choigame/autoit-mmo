Func generateFolderJSP($group,$constant,$entityN,$folderN,$folderE,$utilsN,$hoSo)
   ;$group  = GUICtrlRead($pathComboBox2,0)               ; iacs , csms ....
   ;$constant  = GUICtrlRead($constantCombo,0)
   ;$folderN = trim(GUICtrlRead($folderName,0))       : Folder Cua Don             :  lower
   ;$folderE = trim(GUICtrlRead($folderEntity,0))     : Folder Entity              :  lower
   ;$utilsN  = trim(GUICtrlRead($utilsName,0))        : Utils and Validators Name  : upperFirstLetter
   ;$entityN = trim(GUICtrlRead($entityGenerate,0))   : Entity NAME				   :  upperFirstLetter
   ;$hoSo . vi du sub/mainjsp thi $hoSo = mainjsp va $folderN = sub/mainjsp

 Local  $f1 = $WorkingDir&"\"&$hoSo&"\registry_"&$hoSo&"_step.jsp"
 Local  $f2 = $WorkingDir&"\"&$hoSo&"\registry_"&$hoSo&"_preview.jsp"


  Local $f1Open =   FileOpen($f1,$modeWrite)
  Local $f2Open =   FileOpen($f2,$modeWrite)

  ; ================ RegistryStep.jsp ======================================================================================

Local $path = @ScriptDir & $jspFolderTemplate
Local $hand = FileOpen($path&$jspRegistry)

If ($hand == -1) Then
   MsgBox($MB_ICONERROR+262144+8192,"Error",$jspRegistry&" Not found!")
EndIf

Local $value = FileRead($hand)
	  $value = StringReplace($value,"GROUPBYTAN",$group)
	  $value = StringReplace($value,"FOLDERENTITYBYTAN",$folderE)
	  $value = StringReplace($value,"ENTITYNAMEBYTAN",$entityN)
	  $value = StringReplace($value,"GROUPCONSTANTBYTAN",$constant)
	  $value = StringReplace($value,"UTILSNAMEBYTAN",$utilsN)
	  $value = StringReplace($value,"FOLDERJSPBYTAN",$folderN)
	  $value = StringReplace($value,"HOSOBYTAN",$hoSo)

   $hand = FileOpen($WorkingDir&"\"& $entityN &"\arrRequired.java")

   If ($hand <> -1) Or (FileRead($hand) <> '') Then
	  Local $arrayValidateFormFromService = FileRead($hand)
	  $value = StringRegExpReplace($value, "(?s)<arrayValidateFormFromService>(.*?)</arrayValidateFormFromService>", $arrayValidateFormFromService)
   Else
	   $value = StringReplace($value,"<arrayValidateFormFromService>","")
	   $value = StringReplace($value,"</arrayValidateFormFromService>","")
	EndIf

   $hand = FileOpen($WorkingDir&"\"& $entityN &"\registryForm.jsp")

   If ($hand <> -1) Or (FileRead($hand) <> '') Then
	  Local $formJspFromService = FileRead($hand)
	  $value = StringReplace($value, "formJspFromService", $formJspFromService)
   Else
	   $value = StringReplace($value,"formJspFromService","")
   EndIf

   FileWrite($f1Open,$value)

   ;Review.JSP
   $hand = FileOpen($path&$jspReview)
   $value = FileRead($hand)
   $value = StringReplace($value,"GROUPBYTAN",$group)
   $value = StringReplace($value,"FOLDERENTITYBYTAN",$folderE)
   $value = StringReplace($value,"ENTITYNAMEBYTAN",$entityN)
   $value = StringReplace($value,"GROUPCONSTANTBYTAN",$constant)
   $value = StringReplace($value,"FOLDERJSPBYTAN",$folderN)
   $value = StringReplace($value,"HOSOBYTAN",$hoSo)

   $hand = FileOpen($WorkingDir&"\"& $entityN &"\review.jsp")

   If ($hand <> -1) Or (FileRead($hand) <> '') Then
	  Local $reviewJspFormService = FileRead($hand)
	  $value = StringRegExpReplace($value, "reviewJspFormService", $reviewJspFormService)
   Else
	  $value = StringReplace($value,"reviewJspFormService","")
	EndIf

   FileWrite($f2Open,$value)

   FileClose($f1Open)
   FileClose($f2Open)

   GUICtrlSetData($resultGenerate,"Done")
EndFunc