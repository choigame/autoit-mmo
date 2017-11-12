#include-once

Func eventProcessComboBox($v)
   getForm(IniRead ( $configPath, "form", $v, "Value not found" ))
EndFunc

Func getForm($fileName)
   $h = FileOpen(@ScriptDir&"\formHTML\"&$fileName,0)
	GUICtrlSetData($textFieldGenerate,FileRead($h))
EndFunc


Func generate()     ;validators + utils + viewAction + XxxxConstants + ipms + businessUtils

   GUICtrlSetData($resultGenerate,"")

   Local $group  = GUICtrlRead($pathComboBox2,0)

   Local $constant  = GUICtrlRead($constantCombo,0)
   Local $entityN = trim(GUICtrlRead($entityGenerate,0))

   ; folder cua Đơn
   Local $folderN = trim(GUICtrlRead($folderName,0))

   Local $folderE = trim(GUICtrlRead($folderEntity,0))
   Local $utilsN  = trim(GUICtrlRead($utilsName,0))

   Local $maQuiT = trim(GUICtrlRead($maQuiTrinh,0))

   Local $hoSo, $nHoso , $nEntity ,$subFolderEntity = "" , $subFolderHoSo = ""

   ;required
   if ($group = $index0Combo) Then
	  messageSelectCombo("")
	  Return
   EndIf

      ;required
   if ($constant = $index0Combo) Then
	  messageSelectCombo("")
	  Return
   EndIf

   If Not (isRequiredInputField($folderE,"FolderEntity",$folderEntity)) Then Return
   If Not (isCharAndDigistAndDot($folderE,"FolderEntity",$folderEntity)) Then Return
   If Not (isValidateInputFolderEntity($folderE,"FolderEntity",$folderEntity)) Then Return

   If Not (isRequiredInputField($entityN,"EntityName",$entityGenerate)) Then Return
   If Not (isCharAndDigist($entityN,"EntityName",$entityGenerate)) Then Return

   If Not (isRequiredInputField($utilsN,"UtilsName",$utilsName)) Then Return
   If Not (isCharAndDigist($utilsN,"UtilsName",$utilsName)) Then Return

   If Not (isRequiredInputField($folderN,"FolderJSP",$folderName)) Then Return
   If Not (isCharAndDigistAnd($folderN,"FolderJSP",$folderName,"/")) Then Return

   If Not (isRequiredInputField($maQuiT,"maQT",$maQuiTrinh)) Then Return
   If Not (isCharAndDigist($maQuiT,"maQT",$maQuiTrinh)) Then Return

   Local $path = @ScriptDir & $jspFolderTemplate
   Local $hand

   $entityN = upperFirstLetter($entityN)
   $utilsN = upperFirstLetter($utilsN)

   $folderN = StringLower($folderN)   ; folder cua Đơn
   $folderE = StringLower($folderE)   ; folder Entity

   $maQuiT  = StringUpper($maQuiT)

   if (StringInStr($folderN,"/") = 0 ) Then
	  $hoSo = $folderN
   Else
	  $nHoso = StringSplit($folderN,"/")
	  $hoSo = $nHoso[$nHoso[0]]
	  for $i = 1 to $nHoso[0] - 1
		 $subFolderHoSo &= $nHoso[$i]
	  Next
   EndIf

   If FileExists($WorkingDir & '\' & $hoSo) Then
	  Local $yesDialog = MsgBox (4 + 32 + 256 + 262144 + 8192,"Tạo Folder Jsp mới","Folder Jsp đã tồn tại. Bạn muốn tạo mới không ?")
	  If $yesDialog == 7 Then Return
   EndIf

   if Not ($subFolderHoSo = "") Then $subFolderHoSo = "." & $subFolderHoSo

   if (StringInStr($folderE,".") = 0 ) Then
   Else
	  $nEntity = StringSplit($folderE,".")
	  for $i = 1 to $nEntity[0] - 1
		 $subFolderEntity &= "." &$nEntity[$i]
	  Next
   EndIf

   ;$hoSo . vi du sub/mainjsp thi $hoSo = mainjsp

   ; Ko dung Validators.java nua ma viet chung file Utils.java
   ; Local $path1 = $WorkingDir&"\"&$hoSo&"\"&$utilsN&"Validators.java"

   Local $path2 = $WorkingDir&"\"&$hoSo&"\"&$utilsN&"Utils.java"
   Local $path3 = $WorkingDir&"\"&$hoSo&"\CopyVao "&upperFirstLetter(StringLower($group))&"ActionPorlet.java"
   Local $path4 = $WorkingDir&"\"&$hoSo&"\"&"Config.txt"
   Local $path5 = $WorkingDir&"\"&$hoSo&"\CopyVao BusinessUtils.java"

   ;Local $hFileOpen1 = FileOpen($path1, $modeWrite) ;

   Local $hFileOpen2 = FileOpen($path2, $modeWrite) ; 2+8 : create if not exist and write override
   Local $hFileOpen3 = FileOpen($path3, $modeWrite) ; 1+8 : create if not exist and write append
   Local $hFileOpen4 = FileOpen($path4, $modeWrite) ;
   Local $hFileOpen5 = FileOpen($path5, $modeWrite) ;

   #comments-start
   ;Validators.java
   $hand  = FileOpen($path&$validatorJava)
   If ($hand == -1) Then
	  MsgBox($MB_ICONERROR+262144+8192,"Error",$validatorJava&" Not found!")
   EndIf

   Local $c1 = FileRead($hand)
   $c1 = StringReplace($c1,"SUBFOLDERENTITYBYTAN",$subFolderEntity)
   $c1 = StringReplace($c1,"GROUPBYTAN",$group)
   $c1 = StringReplace($c1,"UTILSNAMEBYTAN",$utilsN)
   #comments-end

   ;Utils.java
   $hand  = FileOpen($path&$utilsJava)

   If ($hand == -1) Then
	  MsgBox($MB_ICONERROR+262144+8192,"Error",$utilsJava&" Not found!")
   EndIf

   Local $c2 = FileRead($hand)
   $c2 = StringReplace($c2,"SUBFOLDERENTITYBYTAN",$subFolderEntity)
   $c2 = StringReplace($c2,"GROUPBYTAN",$group)
   $c2 = StringReplace($c2,"GROUPCONSTANTBYTAN",$constant)
   $c2 = StringReplace($c2,"FOLDERENTITYBYTAN",$folderE)
   $c2 = StringReplace($c2,"ENTITYNAMEBYTAN",$entityN)
   $c2 = StringReplace($c2,"UTILSNAMEBYTAN",$utilsN)

   $hand = FileOpen($WorkingDir&"\"& $entityN &"\fillData2Form.java")

   If ($hand <> -1) Or (FileRead($hand) <> '') Then
	  Local $fillData2FormFormService = FileRead($hand)
	  $c2 = StringRegExpReplace($c2, "fillData2FormFormService", $fillData2FormFormService)
   Else
	  $c2 = StringReplace($c2,"fillData2FormFormService","")
   EndIf

   $hand = FileOpen($WorkingDir&"\"& $entityN &"\validators.java")

   If ($hand <> -1) Or (FileRead($hand) <> '') Then
	  Local $validateFormService = FileRead($hand)
	  $c2 = StringRegExpReplace($c2, "validateFormService", $validateFormService)
   Else
	  $c2 = StringReplace($c2,"validateFormService","")
   EndIf

   ;save va update trong ActionPorlet
   $hand  = FileOpen($path&$saveActionPortlet)
   If ($hand == -1) Then
	  MsgBox($MB_ICONERROR+262144+8192,"Error",$saveActionPortlet&" Not found!")
   EndIf
   $c3 = FileRead($hand)
   $c3 = StringReplace($c3,"UTILSNAMEBYTAN",$utilsN)
   $c3 = StringReplace($c3,"ENTITYNAMEBYTAN",$entityN)
   $c3 = StringReplace($c3,"HOSOBYTAN",$hoSo)
   $c3 = StringReplace($c3,"GROUPCONSTANTBYTAN",$constant)

   ;Config trong ipms, viewAction.jsp
   $hand  = FileOpen($path&$config)
   If ($hand == -1) Then
	  MsgBox($MB_ICONERROR+262144+8192,"Error",$config&" Not found!")
   EndIf

   $c4 = FileRead($hand)
   $c4 = StringReplace($c4,"GROUPBYTAN",$group)
   $c4 = StringReplace($c4,"FOLDERJSPBYTAN",$folderN)
   $c4 = StringReplace($c4,"GROUPCONSTANTBYTAN",$constant)
   $c4 = StringReplace($c4,"HOSOBYTAN",$hoSo)
   $c4 = StringReplace($c4,"MAQTBYTAN",$maQuiT)

  ; BusinessUtils.java

   $hand  = FileOpen($path&$businessUtils)
   If ($hand == -1) Then
	  MsgBox($MB_ICONERROR+262144+8192,"Error",$businessUtils&" Not found!")
   EndIf

   Local $c5 = FileRead($hand)
   $c5 = StringReplace($c5,"ENTITYNAMEBYTAN",$entityN)

   ;FileWrite($hFileOpen1,$c1)
   FileWrite($hFileOpen2,$c2)
   FileWrite($hFileOpen3,$c3)
   FileWrite($hFileOpen4,$c4)
   FileWrite($hFileOpen5,$c5)

   ;FileClose($hFileOpen1)
   FileClose($hFileOpen2)
   FileClose($hFileOpen3)
   FileClose($hFileOpen4)
   FileClose($hFileOpen5)

   ;========== JSP =======================================================================================
   generateFolderJSP($group,$constant,$entityN,$folderN,$folderE,$utilsN,$hoSo)

   ;$group  = GUICtrlRead($pathComboBox2,0)               ; iacs , csms ....
   ;$constant  = GUICtrlRead($constantCombo,0)
   ;$varibleConstantK = trim(GUICtrlRead($varibleConstantKey,0))       : ACTION_SAVE_HO_SO


   ;$folderN = trim(GUICtrlRead($folderName,0))       : Folder Cua Don             : đã lower
   ;$folderE = trim(GUICtrlRead($folderEntity,0))     : Folder Entity              : đã lower
   ;$utilsN  = trim(GUICtrlRead($utilsName,0))        : Utils and Validators Name  : đã upperFirstLetter
   ;$entityG = trim(GUICtrlRead($entityGenerate,0))   : Entity NAME				   : đã upperFirstLetter
EndFunc

Func loadFileConfig()
   Local $path = $WorkingDir&"\Config.txt"
   Local $hFileOpen = FileOpen($path,0)
    If $hFileOpen = -1 Then
        MsgBox($MB_ICONERROR+262144+8192, "Error !", "File Not Found.")
		Return
	 Else
		 $hFileOpen = FileOpen($path,0)
		 GUICtrlSetData($textFieldGenerate,FileRead($hFileOpen))
		  FileClose($hFileOpen)
		  GUICtrlSetBkColor($textFieldGenerate,$white)
	 EndIf
EndFunc

Func openFileConfig()
   Local $path = $WorkingDir&"\Config.txt"
   Local $hFileOpen = FileOpen($path,0)
    If $hFileOpen = -1 Then
        MsgBox($MB_ICONERROR+262144+8192, "Error !", "File Not Found.")
		Return
   Else
		Run ("notepad.exe " &$path, @WindowsDir)
   EndIf
EndFunc

;============================== Open file form HTML ==============================================
Func openFileHTML()
   Local $key = GUICtrlRead($formComboBox)
   If $key = "-- Utils --" Then Return
   $value = IniRead ( $configPath, "form", $key , "Value not found" )
   Local $path = @ScriptDir&"\formHTML\"&$value
   Local $hFileOpen = FileOpen($path,0)
   If $hFileOpen = -1 Then
        MsgBox($MB_ICONERROR+262144+8192, "Error !", "File Not Found.")
		Return
   Else
		Run ("notepad.exe " &$path, @WindowsDir)
   EndIf
EndFunc