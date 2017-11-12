#include-once
#include <MessageBox.au3>
#include <utils.au3>
#include <utilsGui.au3>
#include <eventChangeCombo.au3>
#include <hover.au3>

Global Enum $idOpen = 1000, $idSave, $idInfo

Func createKeyValue()
   Local $path = $WorkingDir&"\Language.txt"
   $val = trim(GUICtrlRead($value,0))
   Local $group  = GUICtrlRead($tab1Combo,0)
   ;$group = StringLower($group)
   $folderJ = trim(GUICtrlRead($folderJsp,0))

   if ($group = $index0Combo) Then
	  messageSelectCombo("")
	  Return
   EndIf

   If Not (isRequiredInputField($folderJ,"Folder jsp",$folderJsp)) Then Return
   If Not (isCharAndDigist($folderJ,"Folder jsp",$folderJsp)) Then Return 		;0-9a-Z only
  ; If Not isNotDotFirstAndLast($folderJ,"Folder jsp",$folderJsp) Then Return
   If Not (isRequiredInputField($val,"Folder jsp",$value)) Then Return


   $folderJ = StringLower($folderJ)
   Local $hFileOpen = FileOpen($path, $modeWrite) ;1+8 : create if not exist and write

    If Not $hFileOpen = -1 Then
        removeBlankLineInFile($path)
   EndIf

   ;show into listVIew
   $fullKey="vn.dtt."&$group&"."&$folderJ&"."&viToEnglish($val)
   $lastLine = _FileCountLines($path)+1
   $contentShow = $lastLine&"|"&$fullKey&"|"&$val
   $idItem = GUICtrlCreateListViewItem($contentShow, $idListview)

   ;wrire to file

   $contentWrite = $fullKey&"="&$val
   FileWriteLine($hFileOpen, $contentWrite)
   FileClose($hFileOpen)
   _GUICtrlListView_SetItemFocused($idListview,$lastLine,true)
   _GUICtrlListView_SetItemFocused($idListview, $lastLine-1)
   _resetInputField($value)
   ;_resetInputField($folderJsp)
EndFunc

Func loadFileToListView()
    Local $path = $WorkingDir&"\Language.txt"
   _GUICtrlListView_DeleteAllItems ($idListview)
   Local $hFileOpen = FileOpen($path,0)
    If $hFileOpen = -1 Then
        MsgBox($MB_ICONERROR+262144+8192, "Error !", "File Not Found.")
		Return
	 Else
		 removeBlankLineInFile($path)
		 $hFileOpen = FileOpen($path,0)
	 EndIf


   for $i=1 to _FileCountLines($path)
		    $str = FileReadLine($hFileOpen,$i)
			if(StringLen($str)>0) then
				$str = StringStripWS($str, 3)  ;trim()
			$arr = StringSplit($str,"=")
			if ($arr[0]=1) Then ContinueLoop
		   $idItem = GUICtrlCreateListViewItem($i&"|"&$arr[1]&"|"&$arr[2], $idListview)
		   EndIf
   Next
    FileClose($hFileOpen)
    _GUICtrlListView_ClickItem($idListview,0)
 EndFunc

Func openFile()
   Local $path = $WorkingDir&"\Language.txt"
   Local $hFileOpen = FileOpen($path,0)
    If $hFileOpen = -1 Then
        MsgBox($MB_ICONERROR+262144+8192, "Error !", "File Not Found.")
		Return
   Else
		Run ("notepad.exe " &$path, @WindowsDir)
   EndIf
EndFunc

Func getKeyRowInList()
   Local $row = GUICtrlRead(GUICtrlRead($idListview))       ; get Row In ListView
   if($row=0) Then
	  MsgBox($MB_ICONERROR+262144+8192,"Error","Choose a row first!")
	  Return
   EndIf
   ClipPut(StringSplit($row,"|")[2])
EndFunc

Func copyRowInList()
   Local $row = GUICtrlRead(GUICtrlRead($idListview))       ; get Row In ListView
   If($row=0) Then
	  MsgBox($MB_ICONERROR+262144+8192,"Error","Choose a row first!")
	  Return
   EndIf
   Local $arr = StringSplit($row,"|")
   ClipPut($arr[2]&"="&$arr[3])
EndFunc

Func removeBlankLineInFile($file)
Local $aLines
_FileReadToArray($file, $aLines)
For $i = $aLines[0] To 1 Step -1
    If $aLines[$i] = "" Then
        _ArrayDelete($aLines, $i)
    EndIf
Next
_FileWriteFromArray($file, $aLines, 1)
 EndFunc
