Func CloseApp()
	Exit
EndFunc

Func Action()
	Local $token = GUICtrlRead($inputToken)
	Local $postId = GUICtrlRead($inputPostId)
	Local $graphURL = 'https://graph.facebook.com/' & $postId & '?fields=' & $FIELD & '&access_token=' & $token
	Local $result = ''

	Do
		Local $data = _HttpRequest(2, $graphURL)
		If (@error == 3) Then MsgBox(0, "Error" , "Connect error" )
		$data = _UnicodeToANSI($data)
		Local $messages = StringRegExp($data , '(?s)"message": "(.*?)",' , 3)

		For $i = 0 To UBound($messages) - 1
			$result &= $messages[$i] & @CRLF
		Next

		$graphURL = _StringRegExp($data , '(?s)"next": "(.*?)"' )

	Until $graphURL == -1

	_FileWriteToTest("comment.txt" , $result)

EndFunc
