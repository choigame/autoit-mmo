#include-once
#include 'Import.au3'

Func FB_GetAccessTokenVIP($sEmail, $sPassword, $iAppSelect = Default)
	If $iAppSelect = Default Or $iAppSelect < 0 Or $iAppSelect > 1 Then $iAppSelect = 1
	Local $aAppInfo = [ _
			['3e7c78e35a76a9299309885393b02d97', '6628568379', 'c1e620fa708a1d5696fb991c1bde5662'], _ ;iPhone
			['882a8490361da98702bf97a021ddc14d', '350685531728', '62f8ce9f74b12f84c123cc23437a4a32']] ;Android
	Local $sData = 'api_key=' & $aAppInfo[$iAppSelect][Random(0, 1, 1)] & '&email=' & $sEmail & '&format=JSON&locale=vi_vn&method=auth.login&password=' & $sPassword & '&return_ssl_resources=0&v=1.0'
	Local $sResult = _HttpRequest(2, 'https://api.facebook.com/restserver.php', _Data2SendEncode($sData & '&sig=' & StringLower(Hex(_Crypt_HashData(StringReplace($sData, '&', '', 0, 1) & $aAppInfo[$iAppSelect][2], $CALG_MD5)))))
	If @error Or $sResult = 1 Then Return SetError(1, '', 'Error: Cannot fetch your data')
	Local $aCheckError = StringRegExp($sResult, '"error_code":(\d+),"error_msg":"([^"]+)"', 3)
	If Not @error Then Return SetError(2, '', 'Error: ' & $aCheckError[1])
	Local $sToken = StringRegExp($sResult, '"access_token":"([^"]+)"', 1)
	If @error Then Return SetError(3, '', 'Error: Cannot get the access_token')
	;ConsoleWrite($sToken[0])$sToken[0]

	ConsoleWrite($sToken[0])
	Return $sToken[0]
EndFunc


Func InitToken()
	#cs
		_IniWrite tự tạo path nếu không tìm thấy
	#ce
	Local $email = GUICtrlRead($inputEmailLogin)
	Local $pass = GUICtrlRead($inputPassLogin)
	Local $tokenFromIni = IniRead($PATH_OF_TOKEN_INI_CONFIG, "token" , $email , '')
	If  $tokenFromIni == '' Then
		$token = FB_GetAccessTokenVIP($email, $pass)
		If Not StringInStr($token,"Error") Then
			_IniWrite($PATH_OF_TOKEN_INI_CONFIG, "token" , $email , $token)
			ShowGuiLogin(false)
		Else
			MsgBox(0,"Error","Check Email or Password",2)
		EndIf
	Else
		$token = $tokenFromIni
		ShowGuiLogin(false)
	EndIf
EndFunc


Func CloseApp()
	Exit
EndFunc

Func BackToGuiLogin()
	ShowGuiLogin(true)
EndFunc

Func _GuiSetFont($size , $fontName)
	GUISetFont($size,  "", "", $fontName)
	GUICtrlSetFont($size,  "", "", $fontName)
EndFunc

Func ShowGuiLogin($isTrue)
	If $isTrue Then
		GUISetState(@SW_SHOW, $guiLogin)
		GUISetState(@SW_HIDE , $guiFeature)
	Else
		GUISetState(@SW_SHOW, $guiFeature)
		GUISetState(@SW_HIDE , $guiLogin)
	EndIf
EndFunc





