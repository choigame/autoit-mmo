Func JSPAction()

   Local $HandFileOpen = FileOpenDialog("Choose *.jsp", $PathEclipse, "JSP (*.jsp)", $FD_FILEMUSTEXIST)

   If @error Then
        MsgBox($MB_SYSTEMMODAL+262144+8192, "", "No file were selected.")
		Return
   EndIf

   Local $FileName = StringSplit($HandFileOpen,"\")
   $FileName = $FileName[$FileName[0]]
   $FileName = StringReplace(".jsp",".txt")

   Local $JSPInput = FileRead($HandFileOpen)

   Local $PathFolderOut = $WorkingDir & "\Log_" & $HandFileOpen

   If FileExists($PathFolderOut) Then
	  Local $yesDialog = MsgBox (4 + 32 + 256 + 262144 + 8192,"Tạo File mới", $FileName & " đã tồn tại. Bạn muốn tạo mới không ?")
	  If $yesDialog == 7 Then Return
   EndIf

   Local $InputText = StringRegExp($JSPInput, '(?s)<\s*entity.+?</entity>', 3)


EndFunc
