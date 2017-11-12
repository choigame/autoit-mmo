Global $cookieLogin = ''
Global $fs_csrf = ''

Func CloseApp()
	Exit
EndFunc

Func Login()
	If Not ($cookieLogin == '') Then
		Logout()
		GUICtrlSetData($buttonLogin,"Login")
		Return
	EndIf

	Local $email = GUICtrlRead($inputEmailLogin)
	Local $password = GUICtrlRead($inputPassLogin)
	Local $html = _HttpRequest(2, $URL)

	$fs_csrf = _StringRegExp($html, $INPUT_FS_CSRF)

	If  $fs_csrf == -1 Then
		Return
	EndIf

	Local $dataToLogin = "fs_csrf=" &$fs_csrf& "&LoginForm%5Bemail%5D=" & _URIEncode($email)& "&LoginForm%5Bpassword%5D=" & _URIEncode($password) & "&LoginForm%5Bcheckloginpopup%5D=0&LoginForm%5BrememberMe%5D=0&yt0=%C4%90%C4%83ng+nh%E1%BA%ADp"

	Local $headerAfterLogin = _HttpRequest(1, $URL_LOG_IN, $dataToLogin)
	$cookieLogin  = _GetCookie($headerAfterLogin)

	If ($cookieLogin == '') Then
		MsgBox(16, "Notification","Login fail")
		Return
	EndIf

	GUICtrlSetData($buttonLogin,"Log out")
EndFunc

Func Logout()
	_HttpRequest(1, $URL_LOG_OUT, '', $cookieLogin)
	$cookieLogin = ''
EndFunc


Func GetLink()
	If ($cookieLogin == '') Then
		MsgBox($MB_ICONWARNING, "Notification","Login first")
		Return
	EndIf

	Local $link = GUICtrlRead($inputLink)

	Local $linkCode = _StringRegExp($link , '/file/(.*)')
	If $linkCode == -1 Then
		MsgBox($MB_ICONWARNING, "Notification","Link invalid")
		Return
	EndIf

	$linkCode = StringReplace($linkCode,"/","")

	;Redirect to urlFile
	_HttpRequest(2, $link, '', $cookieLogin)

	Local $dataToDownload = 'fs_csrf='& $fs_csrf &'&DownloadForm%5Bpwd%5D=&DownloadForm%5Blinkcode%5D='& $linkCode &'&ajax=download-form&undefined=undefined'

	Local $json = _HttpRequest(2, $URL_DOWNLOAD, $dataToDownload, $cookieLogin)
	Local $linkDownload = _StringRegExp($json,'(?s){"url":"(.*?)","wait_time":"1"}')
	If $linkDownload == -1 Then
		MsgBox($MB_ICONWARNING, "Notification","Link Invalid")
		Return
	EndIf
	$linkDownload = StringReplace($linkDownload,"\/","/")

	ClipPut($linkDownload)
	MsgBox($MB_ICONWARNING, "Successful","Copied To Clipboard")
EndFunc