Func CloseApp()
	Exit
EndFunc

Func Login()
	If Not ($cookieLogin == '') Then
		Logout()
		GUICtrlSetData($buttonLogin,"Login")
		Return
	EndIf

	Local $headerLoadPage = _HttpRequest(1, $URL)
	Local $cookieLoadPage = _GetCookie($headerLoadPage)

	Local $email = GUICtrlRead($inputEmailLogin)
	Local $password = GUICtrlRead($inputPassLogin)

	Local $dataToLogin = '&email='& _URIEncode ($email)& '&pass=' & _URIEncode ($password)

	Local $headerAfterLogin = _HttpRequest(1, $URL_LOG_IN, $dataToLogin, $cookieLoadPage)
	$cookieLogin  = _GetCookie($headerAfterLogin)

	If StringInStr($cookieLogin , 'sfau=')  Then
		;exist sfau = wrong password
		MsgBox(16, "Notification","Wrong Password")
		$cookieLogin = ''
		Return
	EndIf

    If Not StringInStr($cookieLogin , 'sb=') Then
		;exist sb = login successfully
		MsgBox(16, "Notification","Wrong Email")
		$cookieLogin = ''
		Return
	EndIf

	$c_user = _StringRegExp($cookieLogin , 'c_user=(.+?);')

	Local $html = _HttpRequest(2, $URL, '', $cookieLogin)
	$fb_dtsg  = _StringRegExp($html, $INPUT_FB_DTSG)

	GUICtrlSetData($buttonLogin,"Log out")
EndFunc

Func Logout()
	Local $dataLogout = 'fb_dtsg=' & _URIEncode($fb_dtsg) & '&ref=mb&h=AfcXUa3bwyBTMt03'
	local $header = _HttpRequest(1, $URL_LOG_OUT, $dataLogout , $cookieLogin)
	$cookieLogin = ''
EndFunc

Func PostStatus()
	If ($cookieLogin == '') Then
		MsgBox($MB_ICONWARNING, "Notification","Login first")
		Return
	EndIf

	Local $URL_POST_STATUS = 'https://m.facebook.com/composer/mbasic/?av=' & $c_user &'&refid=8'
	Local $content = GUICtrlRead($inputStatusContent)
	Local $private = GetValueComboFromLabel(GuictrlRead($comboPrivate))
	$content = 'fb_dtsg=' & _URIEncode($fb_dtsg) & '&privacyx=' & $private &'&target=' & $c_user& '&c_src=feed&cwevent=composer_entry&referrer=feed&ctype=inline&cver=amber&rst_icv=&xc_message=' & _URIEncode($content) & '&view_post=%C4%90%C4%83ng'

	_HttpRequest(2, $URL_POST_STATUS, $content , $cookieLogin)
EndFunc
