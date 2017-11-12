﻿#include-once
#include <Array.au3>
;#include <WinHttp.au3> ;Thanks [@ProAndy ] [Trancexx] autoitscript.com


#cs Bao gồm các hàm chính
	_HttpRequest ...............................$iReturn: + force GZUncompress, - Return Binary Data (mode2) hoặc Cookies (mode 1), * enable redirect, . UTF8
	_HttpRequest_ErrorNotify ..............Bật tắt thông báo lỗi ở Console
	_HttpRequest_ReadWriteStatus .....Chi tiết về lượng data gửi nhận khi download và upload
	_HttpRequest_Authorization ..........Thực hiện Authorization
	_HttpRequest_SetOption ...............Cài đặt Proxy, Timeout, phím tắt dừng quá trình Upload, set Option En/Disable Redirects
	_HttpRequest_SetUserAgent .........Thay đổi UserAgent mặc định
	_BoundaryGenerator .....................Tạo chuỗi Boundary khi Upload
	_Data2SendEncode .......................Encode nhanh Data2Send
	_URIEncode .................................Mã hoá chuỗi URL hoặc dữ liệu trong DataToSend
	_URIDecode .................................Giải mã chuỗi URL hoặc dữ liệu trong DataToSend
	_HTMLEncode ..............................Mã hoá js trong source về dạng như \u2A21, \x2121, &#x1234; ... Mặc định của Escape Character là \u
	_HTMLDecode ..............................Giải mã js trong source có những dạng như \u2A21, \x2121, &#x1234; ... Mặc định của Escape Character là \u
	_GetHiddenValues ........................Lấy các giá trị Hidden trong source HTML để POST
	_GetCookie ..................................Tách lấy Cookie từ Response Header
	_GetLocation_Redirect ..................Tách Location từ Response Header
	_GetFileInfos ...............................Trả về mảng gồm: [0] Tên file, [1] Kiểu của file (Content-Type), [2] Data của file. Dùng khi Upload.
	_FileWrite_Test ............................Ghi giá trị trả về ra 1 file
	_B64Encode .................................Mã hoá Base64 đơn giản
	_B64Decode .................................Giải mã Base64 đơn giản
	_TimeStampUNIX .........................Tạo đóng dấu Timetamp theo giờ hệ thống
	-------------------------------------------------------------------------------------------------------------
	_HttpRequest_SetSession ..............Cài đặt Session cho Request
	_HttpRequest_ClearSession ...........Xoá tất cả Cookies và Handles mà 1 Session đã sử dụng
	_HttpRequest_GetSessionList .........Lấy danh sách Session đang tồn tại
#ce


#cs Các hàm đang test Beta
	_HttpRequest_CreateDataFormSimple ..........Tạo nhanh biểu mẫu Data2Send đơn giản cho việc Upload
	_HttpRequest_ContentDisposition_Convert .....Hàm giúp chuyển đổi nhanh Data của POST Content-Type: multipart/form-data từ LHH sang code autoit
	-------------------------------------------------------------------------------------------------------------
	_JS_Execute ...............................................Chạy code Javascript
	_JS_ToStringAu3 ........................................Chuyển nhanh code JS sang dạng string để gán biến trong code AutoIt
	_JS_Beauty .................................................Làm đẹp lại code JS
#ce


#cs Note
	*** WINHTTP_STATUS_CALLBACK  https://msdn.microsoft.com/en-us/library/windows/desktop/aa383917(v=vs.85).aspx
	*** WINHTTP_DISABLE_REDIRECTS: Automatic redirection is disabled when sending requests with WinHttpSendRequest. If automatic redirection is disabled, an application must register a callback function in order for Passport authentication to succeed.
	*** Authentication in WinHTTP: https://msdn.microsoft.com/en-us/library/windows/desktop/aa383144(v=vs.85).aspx

	_WinHttpAddRequestHeaders($g___hRequest, "Cookie: -1", $WINHTTP_ADDREQ_FLAG_REPLACE)
	_WinHttpSetOption($g___hRequest, $WINHTTP_OPTION_AUTOLOGON_POLICY, $WINHTTP_AUTOLOGON_SECURITY_LEVEL_LOW)
	_WinHttpSetOption($g___hRequest, $WINHTTP_OPTION_SERVER_CERT_CONTEXT, Null)
#ce



Global $g___hOpen[1000], $g___hConnect[1000], $g___hRequest, $g___sSN = -1, $g___SessionCheck = '|'
;------------------------------------------------------------------------------------
Global $Z_Buffer, $Z_BufferMemory, $Z_BufferPtr, $Z_Alloc_Callback, $Z_Free_Callback
Global $Z_InfInit, $Z_InfInit2, $Z_Inf, $Z_InfEnd, $Z_DefInit, $Z_DefInit2, $Z_Def, $Z_DefEnd, $Z_DefBound
;------------------------------------------------------------------------------------
Global Const $def___sChr64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
Global Const $def___aChr64 = StringSplit($def___sChr64, "", 2)
Global Const $def___sPadding = '='
Global $g___sChr64 = $def___sChr64
Global $g___aChr64 = $def___aChr64
Global $g___sPadding = $def___sPadding
;------------------------------------------------------------------------------------
Global $g___iUserAgent = 'Mozilla/5.0 (Windows NT 5.1; rv:47.0) Gecko/20100101 Firefox/47.0'
Global Const $g___iUserAgentBk = $g___iUserAgent
Global $g___TotalLoops = 0, $g___PosLoop = 0, $g___BytesReadPerLoop = 8192, $g___DataSizeBytes = 0
Global $g___Proxy = '', $g___ProxyBk = '', $g___ProxyBypass = ''
Global $g___sUserName = '', $g___sPassword = ''
Global $g___Disable_Redirects = 1
Global $g___CancelReadWrite = 0
Global $g___ErrorNotify = True
Global $g___Authorization = 0
Global $g___URLConnect = ''
Global $g___CheckPort = 80
Global $g___MaskFunc = 0
Global $g___TimeOut = ''
Global $g___User32DLL = DllOpen("user32.dll")
DllOpen("user32.dll")
Global $g___WinHttpDLL = DllOpen("winhttp.dll")
DllOpen("winhttp.dll")
OnAutoItExitRegister('__HttpRequestCloseAll')

;-----------------------------------------------------------------------------------------


#Region <Quản lý các Session của _HttpRequest>
	Func _HttpRequest_SetSession($sSessionNumber)
		If StringIsDigit($sSessionNumber) Then $sSessionNumber = Number($sSessionNumber)
		If Not IsNumber($sSessionNumber) Then Exit MsgBox(4096, 'Lỗi', '$sSessionNumber chỉ có thể từ số từ 0 đến 999')
		If $sSessionNumber < 0 Or $sSessionNumber > 999 Then Exit MsgBox(4096, 'Lỗi', '$sSessionNumber chỉ có thể từ số từ 0 đến 999')
		$g___sSN = $sSessionNumber
		If Not StringInStr($g___SessionCheck, '|' & $sSessionNumber & '|', 1, 1) Then $g___SessionCheck &= $sSessionNumber & '|'
	EndFunc

	Func _HttpRequest_GetSessionList()
		Local $aSession = StringRegExp($g___SessionCheck, '\d+', 3)
		If @error Then Return SetError(201, '', False)
		For $i = 0 To UBound($aSession) - 1
			$aSession[$i] = Number($aSession[$i])
		Next
		Return $aSession
	EndFunc

	Func _HttpRequest_ClearSession($sSessionNumber = 0)
		If StringIsDigit($sSessionNumber) Then $sSessionNumber = Number($sSessionNumber)
		If Not IsNumber($sSessionNumber) Then Exit MsgBox(4096, 'Lỗi', '$sSessionNumber chỉ có thể từ số từ 0 đến 999')
		If $sSessionNumber < 0 Or $sSessionNumber > 999 Then Exit MsgBox(4096, 'Lỗi', '$sSessionNumber chỉ có thể từ số từ 0 đến 999')
		If Not StringRegExp($g___SessionCheck, '\d+') Then Return SetError(202, __HttpRequestErrNotify('_HttpRequest_ClearSession', '202'))
		If Not StringInStr($g___SessionCheck, '|' & $sSessionNumber & '|', 1, 1) Then Return SetError(203, __HttpRequestErrNotify('_HttpRequest_ClearSession', '203'))
		If $g___hConnect[$sSessionNumber] Then $g___hConnect[$sSessionNumber] = _WinHttpCloseHandle2($g___hConnect[$sSessionNumber])
		If $g___hOpen[$sSessionNumber] Then $g___hOpen[$sSessionNumber] = _WinHttpCloseHandle2($g___hOpen[$sSessionNumber])
		$g___SessionCheck = StringReplace($g___SessionCheck, '|' & $sSessionNumber & '|', '|', 1, 1)
	EndFunc
#EndRegion


#Region <Tạo nhanh Form Upload>
	Func _HttpRequest_CreateDataFormSimple($a_Content_Disposition)
		Local $l__sBoundary = _BoundaryGenerator()
		Local $l__sDataToSend = $l__sBoundary & @CRLF
		If IsArray($a_Content_Disposition) And UBound($a_Content_Disposition, 2) = 2 Then
			Local $l__uBound = UBound($a_Content_Disposition) - 1
			For $i = 0 To $l__uBound
				$l__sDataToSend &= 'Content-Disposition: form-data; name="' & $a_Content_Disposition[$i][0] & '"' & @CRLF & @CRLF & $a_Content_Disposition[$i][1]
				If $i < $l__uBound Then $l__sDataToSend &= @CRLF & $l__sBoundary & @CRLF
			Next
		EndIf
		$l__sDataToSend = StringReplace($l__sDataToSend, 'form-data; name=""', ' form-data; name="', 0, 1)
		$l__sDataToSend = StringRegExpReplace($l__sDataToSend, '(?im)^(Content-Type:[^"]+)"', '$1')
		Return $l__sDataToSend & @CRLF & $l__sBoundary & '--'
	EndFunc

	Func _HttpRequest_ContentDisposition_Convert($l__sData = Default)
		If $l__sData = Default Then $l__sData = ClipGet()
		Local $l__sResult = '', $l__aSpData
		Local $l__sBoundary = StringRegExp($l__sData, '(?m)^(-{4,}.+)$', 1)
		If @error Then Return SetError(1, '', False)
		$l__sBoundary = $l__sBoundary[0]
		Local $aData = StringSplit($l__sData, $l__sBoundary, 1)
		For $i = 1 To $aData[0]
			If $aData[$i] = '' Then ContinueLoop
			$l__aSpData = StringSplit(StringStripWS($aData[$i], 3), @CRLF & @CRLF, 1)
			If $l__aSpData[0] = 1 Then ContinueLoop
			If StringInStr($l__aSpData[1], @CRLF, 1, 1) Then
				$l__aSpData[1] = StringReplace(StringReplace($l__aSpData[1], @CRLF, "' & @CRLF & '", 1, 1), 'Content-Disposition: form-data; name=', '', 1, 1)
			Else
				$l__aSpData[1] = StringTrimRight(StringReplace($l__aSpData[1], 'Content-Disposition: form-data; name="', '', 1, 1), 1)
			EndIf
			$l__sResult &= "['" & $l__aSpData[1] & "', " & "'" & $l__aSpData[2] & "'], "
		Next
		$l__sResult = 'Local $aDispos = [' & StringTrimRight($l__sResult, 2) & ']'
		ConsoleWrite('!Converted' & @CRLF)
		ClipPut($l__sResult)
		Return $l__sResult
	EndFunc
#EndRegion


Func _HttpRequest_ErrorNotify($___ErrorNotify = True)
	$g___ErrorNotify = $___ErrorNotify
EndFunc

Func _HttpRequest_ReadWriteStatus() ;[0] vòng lặp hiện tại, [1] Tổng vòng lặp tải data, [2] Số bytes tải về trong 1 vòng lặp, [3] Tổng dung lượng data
	Local $aReturn = [$g___PosLoop, $g___TotalLoops, $g___BytesReadPerLoop, $g___DataSizeBytes]
	Return $aReturn
EndFunc

Func _HttpRequest_SetOption($__Proxy = '', $__TimeOut = '', $__sHotKeyCancelReadWrite = '', $__Disable_Redirects = True)
	$g___Proxy = ($__Proxy And $__Proxy <> Default ? $__Proxy : '')
	$g___TimeOut = ($__TimeOut And $__TimeOut <> Default ? $__TimeOut : '')
	$g___Disable_Redirects = ((Not $__Disable_Redirects Or $__Disable_Redirects <> Default) ? 0 : 1)
	HotKeySet(($__sHotKeyCancelReadWrite And $__sHotKeyCancelReadWrite <> Default) ? $__sHotKeyCancelReadWrite : '', '_HttpRequest_CancelReadWrite')
EndFunc

Func _HttpRequest_SetUserAgent($___sUserAgent)
	If $___sUserAgent And $___sUserAgent <> Default Then
		$g___iUserAgent = $___sUserAgent
	Else
		$g___iUserAgent = $g___iUserAgentBk
	EndIf
EndFunc

Func _HttpRequest_Authorization($___sUserName = '', $___sPassword = '')
	If $___sUserName Or $___sPassword Then
		$g___Authorization = 1
		$g___sUserName = $___sUserName
		$g___sPassword = $___sPassword
	Else
		$g___Authorization = 0
	EndIf
EndFunc



Func _HttpRequest($iReturn, $sURL, $sDataToSend = '', $sCookie = '', $sReferer = '', $sAdditional_Headers = '', $sOVerb = '', $ptCallBackFunc_ReadWrite = '', $ptAdditionalFunc_BeforeSendRequest = '', $ptAdditionalFunc_AfterSendRequest = '')
	Local $aURL = _URLSplit($sURL)
	If @error Then Return SetError(1, __HttpRequestErrNotify('_HttpRequest', '$sURL'), '$sURL: Error')
	;-------------------------------------------------
	Local $aReturn = StringRegExp($iReturn, '([\+\-\.\*]|\d+)', 3)
	If @error Then Return SetError(2, __HttpRequestErrNotify('_HttpRequest', '$iReturn'), '$iReturn: Error')
	;-------------------------------------------------
	If $g___sSN = -1 Then _HttpRequest_SetSession(0)
	;-------------------------------------------------
	Local $forceMode[4], $rData[2], $iError = 0, $vContentType = ''
	;-------------------------------------------------
	For $p = 0 To UBound($aReturn) - 1
		Switch $aReturn[$p]
			Case '-' ;force ReturnBinary
				$forceMode[0] = 1
			Case '+' ;force GZUncompress
				$forceMode[1] = 1
			Case '*' ;force Enable Redirect
				$forceMode[2] = 1
			Case '.' ;force UTF8 Data2Send POST/PUT/PATCH
				$forceMode[3] = 1
			Case Else
				If StringIsDigit($aReturn[$p]) Then $iReturn = Number($aReturn[$p])
		EndSwitch
	Next
	;-------------------------------------------------
	If Not $g___hOpen[$g___sSN] Then $g___hOpen[$g___sSN] = _WinHttpOpen2($g___iUserAgent)
	;-------------------------------------------------
	If Not $g___hConnect[$g___sSN] Or $aURL[2] & $aURL[1] <> $g___URLConnect & $g___CheckPort Or $sCookie = -1 Then
		$g___URLConnect = $aURL[2]
		$g___CheckPort = $aURL[1]
		If $g___hConnect[$g___sSN] Then $g___hConnect[$g___sSN] = _WinHttpCloseHandle2($g___hConnect[$g___sSN])
		$g___hConnect[$g___sSN] = _WinHttpConnect2($g___hOpen[$g___sSN], $aURL[2], $aURL[1], $aURL[0])
	EndIf
	;-------------------------------------------------
	If $sReferer Then $sReferer = StringRegExpReplace($sReferer, '(?i)^Referer\s?:\s?', '')
	$g___hRequest = _WinHttpOpenRequest2($g___hConnect[$g___sSN], ($sOVerb ? $sOVerb : ($sDataToSend ? "POST" : "GET")), $aURL[3], $sReferer, ($aURL[0] - 1) * 0x800000)
	;-------------------------------------------------
	If $g___TimeOut Then _WinHttpSetTimeouts2($g___hRequest, $g___TimeOut)
	;-------------------------------------------------
	If $g___Proxy Or (Not $g___Proxy And $g___ProxyBk) Then
		$g___ProxyBk = $g___Proxy
		_WinHttpSetProxy2($g___hRequest, $g___Proxy, $g___ProxyBypass)
	EndIf
	;------------------------------------------------------------
	_WinHttpSetOption2($g___hRequest, 118, 3) ;OPTION_DECOMPRESSION = DECOMPRESSION_FLAG_ALL
	_WinHttpSetOption2($g___hRequest, 31, 13056) ;OPTION_SECURITY_FLAGS = SECURITY_FLAG_IGNORE_ALL
	;_WinHttpSetOption2($g___hRequest, 88, 2) ;OPTION_REDIRECT_POLICY = REDIRECT_POLICY_ALWAYS
	;_WinHttpSetOption2($g___hRequest, 84, 0x000000A8) ;OPTION_SECURE_PROTOCOLS = ALL
	;------------------------------------------------------------
	If $iReturn = 1 And $g___Disable_Redirects = 1 And $forceMode[2] = 0 Then _WinHttpSetOption2($g___hRequest, 63, 2)
	;-------------------------------------------------------------
	If $g___Authorization Or $aURL[4] Or $aURL[5] Then
		Local $addProx = ($g___Proxy ? 2 : 0)
		If $g___Authorization Then
			$aURL[4] = $g___sUserName
			$aURL[5] = $g___sPassword
		EndIf
		_WinHttpSetOption2($g___hRequest, 0x1000 + $addProx, $aURL[4])
		_WinHttpSetOption2($g___hRequest, 0x1001 + $addProx, $aURL[5])
	EndIf
	;-------------------------------------------------
	If IsFunc($ptAdditionalFunc_BeforeSendRequest) Then $ptAdditionalFunc_BeforeSendRequest()
	;-------------------------------------------------
	If $sAdditional_Headers Then
		Local $aAddition = StringSplit($sAdditional_Headers, '|')
		For $i = 1 To $aAddition[0]
			If StringRegExp($aAddition[$i], '(?i)^Content-Type\s?:') Then
				$vContentType = $aAddition[$i]
				ContinueLoop
			EndIf
			_WinHttpAddRequestHeaders2($g___hRequest, $aAddition[$i])
		Next
	EndIf
	;-------------------------------------------------
	If $sCookie Then _WinHttpAddRequestHeaders2($g___hRequest, "Cookie: " & StringRegExpReplace($sCookie, '(?i)^Cookie\s?:\s?', ''))
	;-------------------------------------------------
	If $sDataToSend Then
		Local $l__sBoundary = StringRegExp($sDataToSend, '(?m)^(-{5,}\w+)$', 1)
		If @error Then
			If Not $vContentType Then
				$vContentType = 'Content-Type: application/x-www-form-urlencoded'
				If StringRegExp($sDataToSend, '^[\s\t]*?[\{\[][\s\t]*?[\x22\x27]?') Then $vContentType = 'Content-Type: application/json'
			EndIf
			If $forceMode[3] Then
				$vContentType &= ';charset=utf-8'
				$sDataToSend = StringToBinary($sDataToSend, 4)
			EndIf
			If _WinHttpSendRequest2($g___hRequest, $vContentType, $sDataToSend) = 0 Then $iError = 4
		Else
			$l__sBoundary = $l__sBoundary[0]
			If StringRight($sDataToSend, 2) <> '--' Then
				If StringRegExp($sDataToSend, '(?s)\R\Q' & $l__sBoundary & '\E$') Then
					$sDataToSend &= '--'
				Else
					$sDataToSend &= @CRLF & $l__sBoundary & '--'
				EndIf
			EndIf
			If Not $vContentType Then $vContentType = 'Content-Type: multipart/form-data'
			If _WinHttpSendRequest2($g___hRequest, $vContentType & ';boundary=' & StringTrimLeft($l__sBoundary, 2), '', StringLen($sDataToSend)) Then
				_WinHttpWriteData_Ex($g___hRequest, $sDataToSend, $ptCallBackFunc_ReadWrite)
				If @error Then $iError = @error
			Else
				$iError = 5
			EndIf
		EndIf
	Else
		If _WinHttpSendRequest2($g___hRequest, $vContentType) = 0 Then $iError = 3
	EndIf
	;-------------------------------------------------
	If $iError = 0 Then
		If _WinHttpReceiveResponse2($g___hRequest) Then
			If $iReturn = 1 Or $iReturn > 3 Then
				$rData[0] = _WinHttpQueryHeaders2($g___hRequest)
				If @error Then $iError = 7
				If $iError = 0 And $forceMode[0] And $iReturn = 1 Then
					$rData[0] = _GetCookie($rData[0])
					If @error Then $iError = 8
				EndIf
			EndIf
			;-----------------------------------------------------------------
			If $iReturn > 1 Then
				Local $bData = _WinHttpReadData_Ex($g___hRequest, $ptCallBackFunc_ReadWrite)
				If @error Then
					$iError = @error
				Else
					If $forceMode[0] Then
						$rData[1] = $bData
					Else
						If $forceMode[1] Or StringRegExp(BinaryMid($bData, 1, 1), '(?i)0x(1F|08|8B)') Then $bData = __ZL_GZUncompress($bData)
						$rData[1] = BinaryToString($bData, 4)
					EndIf
				EndIf
			EndIf
		Else
			$iError = 6
		EndIf
	EndIf
	;-------------------------------------------------
	If IsFunc($ptAdditionalFunc_AfterSendRequest) And $iError = 0 Then $ptAdditionalFunc_AfterSendRequest()
	;-------------------------------------------------
	_WinHttpCloseHandle2($g___hRequest)
	$g___MaskFunc = 0
	$g___PosLoop = 0
	$g___TotalLoops = 0
	$g___DataSizeBytes = 0
	;-------------------------------------------------
	Switch $iReturn
		Case 1
			Return SetError($iError, __HttpRequestErrNotify('_HttpRequest', $iError), $rData[0])
		Case 2, 3
			Return SetError($iError, __HttpRequestErrNotify('_HttpRequest', $iError), $rData[1])
		Case Else
			Return SetError($iError, __HttpRequestErrNotify('_HttpRequest', $iError), $rData)
	EndSwitch
EndFunc


Func _BoundaryGenerator()
	Local $sData = ""
	For $i = 1 To 12
		$sData &= Random(1, 9, 1)
	Next
	Return ('-----------------------------' & $sData)
EndFunc


Func _Data2SendEncode($sData2Send)
	Local $aData2Send = StringRegExp($sData2Send, '(?:^|&)([^=]+)(?:=)([^&]*)', 3), $uBound = UBound($aData2Send), $sResult
	If Mod($uBound, 2) Then Return $sData2Send
	For $i = 0 To $uBound - 1 Step 2
		If Not StringRegExp($aData2Send[$i], '\%\w\w?') Then $aData2Send[$i] = _URIEncode($aData2Send[$i])
		If Not StringRegExp($aData2Send[$i + 1], '\%\w\w?') Then $aData2Send[$i + 1] = _URIEncode($aData2Send[$i + 1])
		$sResult &= $aData2Send[$i] & '=' & $aData2Send[$i + 1] & '&'
	Next
	Return StringTrimRight($sResult, 1)
EndFunc


Func _URIEncode($sData) ; [Prog@ndy] autoitscript.com
	Local $aData = StringSplit(BinaryToString(StringToBinary($sData, 4), 1), "")
	Local $nChar
	$sData = ""
	For $i = 1 To $aData[0]
		$nChar = Asc($aData[$i])
		Switch $nChar
			Case 45, 46, 48 To 57, 65 To 90, 95, 97 To 122, 126
				$sData &= $aData[$i]
			Case 32
				$sData &= "+"
			Case Else
				$sData &= "%" & Hex($nChar, 2)
		EndSwitch
	Next
	Return $sData
EndFunc


Func _URIDecode($sData) ; [Prog@ndy] autoitscript.com
	Local $aData = StringSplit(StringReplace($sData, "+", " ", 0, 1), "%")
	$sData = ""
	For $i = 2 To $aData[0]
		$aData[1] &= Chr(Dec(StringLeft($aData[$i], 2))) & StringTrimLeft($aData[$i], 2)
	Next
	Return BinaryToString(StringToBinary($aData[1], 1), 4)
EndFunc


Func _HTMLEncode($sData, $Escape_Char = '\u', $end_Escape_Char = '', $iPassSpace = False)
	Return StringReplace(StringRegExpReplace(Execute('"' & StringRegExpReplace(StringReplace($sData, '"', '¶', 0, 1), '([^\w\-\+\/\¶' & ($iPassSpace ? ' ' : '') & '])', '\' & $Escape_Char & '" & Hex(AscW("$1"),4) & "' & $end_Escape_Char) & '"'), '(\' & $Escape_Char & ')00(0?)([a-zA-z1-9])', '$1$2$3'), '¶', $Escape_Char & '22', 0, 1)
EndFunc


Func _HTMLDecode($sData, $Escape_Character = '\u', $end_Escape_Char = ';')
	$sData = StringReplace(StringReplace(StringReplace(StringReplace($sData, "&amp;", "&"), "&lt;", "<"), "&gt;", ">"), "&quot;", '"')
	Local $aSRE = StringRegExp($sData, '(?i)\Q' & $Escape_Character & '\E([[:xdigit:]]{2,4})\' & $end_Escape_Char & '?', 3)
	If @error Then Return $sData
	For $i = 0 To UBound($aSRE) - 1
		$sData = StringRegExpReplace($sData, '\Q' & $Escape_Character & $aSRE[$i] & '\E\' & $end_Escape_Char & '?', ChrW(Int('0x' & $aSRE[$i])))
	Next
	If Not $sData Then Return SetError(1, __HttpRequestErrNotify('_HTMLDecode', 1), $sData)
	Return $sData
EndFunc


Func _GetHiddenValues($sURL, $sPaternVal0 = '', $sPaternVal1 = '', $sPaternVal2 = '', $sPaternVal3 = '', $sPaternVal4 = '', $sPaternVal5 = '', $sPaternVal6 = '', $sPaternVal7 = '', $sPaternVal8 = '', $sPaternVal9 = '') ;dùng Eval sẽ bị lỗi khi OBF
	Local $aPaternVal = [$sPaternVal0, $sPaternVal1, $sPaternVal2, $sPaternVal3, $sPaternVal4, $sPaternVal5, $sPaternVal6, $sPaternVal7, $sPaternVal8, $sPaternVal9], $__aRegexp
	ReDim $aPaternVal[@NumParams - 1]
	Local $__sGetSource = _HttpRequest(2, $sURL)
	For $i = 0 To UBound($aPaternVal) - 1
		$__aRegexp = StringRegExp($__sGetSource, $aPaternVal[$i], 1)
		If @error Then Return SetError($i + 1)
		$aPaternVal[$i] = $__aRegexp[0]
	Next
	Return $aPaternVal
EndFunc


Func _GetCookie($sHeader, $Excluded_Values = '')
	If $sHeader == '' Then SetError(1, __HttpRequestErrNotify('_GetCookie', 1), '')
	If $Excluded_Values Then $Excluded_Values = '(?i)(?!' & StringRegExpReplace($Excluded_Values, '($|\|)', '=${1}') & ')'
	Local $__aRH = StringRegExp($sHeader, '(?im)^Set-Cookie:\s{0,1}' & $Excluded_Values & '([^=]+)=(?!deleted;)(.*)$', 3)
	If @error Or Not IsArray($__aRH) Then Return SetError(2, __HttpRequestErrNotify('_GetCookie', 2), '')
	Local $__sRH = '', $__uBound = UBound($__aRH)
	If Mod($__uBound, 2) Then Return SetError(3, __HttpRequestErrNotify('_GetCookie', 3), '')
	For $i = $__uBound - 2 To 0 Step -2
		If $__aRH[$i] == '' Then ContinueLoop
		$__sRH = $__aRH[$i] & '=' & $__aRH[$i + 1] & '; ' & $__sRH
		For $k = 0 To $i Step 2
			If $__aRH[$k] == $__aRH[$i] Then $__aRH[$k] = ''
		Next
	Next
	$__sRH = StringRegExpReplace($__sRH, '(?i)\s?(Path|Expires|Max-Age|Domain)=[^;]*(;| ;)', '')
	$__sRH = StringRegExpReplace($__sRH, '(?i);\s?(Secure; Httponly|Httponly|Secure)(;|$)', ';')
	Return $__sRH
EndFunc


Func _GetLocation_Redirect($__sHeader)
	If Not $__sHeader Then Return SetError(1, __HttpRequestErrNotify('_GetLocation_Redirect', 1), '')
	Local $__aRH = StringRegExp($__sHeader, '(?im)^Location:\s?(.+)$', 1)
	If @error Or Not IsArray($__aRH) Then Return SetError(2, __HttpRequestErrNotify('_GetLocation_Redirect', 2), '')
	Return $__aRH[0]
EndFunc


Func _GetFileInfos($sFilePath)
	If Not FileExists($sFilePath) Then Return SetError(1, __HttpRequestErrNotify('_GetFileInfos', 1), '')
	Local $sFileName = StringRegExp($sFilePath, '[\\\/]([^\\\/]+\.\w+)$', 1)
	If @error Then Return SetError(2, __HttpRequestErrNotify('_GetFileInfos', 2), '')
	Local $FileOpen = FileOpen($sFilePath, 16)
	If @error Then Return SetError(3, __HttpRequestErrNotify('_GetFileInfos', 3), '')
	Local $sFileData = FileRead($FileOpen)
	FileClose($FileOpen)
	Local $aReturn[4] = [$sFileName[0], __WinHttpMIMEType2($sFileName[0]), BinaryToString($sFileData), BinaryLen($sFileData)]
	Return $aReturn
EndFunc


Func _GetProxyName($hInternet)
	Local $tProxy1 = DllStructCreate("DWORD dwAccessType;ptr lpszProxy;ptr lpszProxyBypass;")
	DllCall($g___WinHttpDLL, "bool", "WinHttpQueryOption", "handle", $hInternet, "dword", 38, "ptr", DllStructGetPtr($tProxy1), "dword*", DllStructGetSize($tProxy1))
	Local $tProxy2 = DllStructCreate("wchar Data[255]", DllStructGetData($tProxy1, "lpszProxy"))
	Local $sProxy = DllStructGetData($tProxy2, "Data")
	$tProxy1 = ''
	$tProxy2 = ''
	Return $sProxy
EndFunc


Func _FileWrite_Test($sData, $FilePath = @TempDir & '\Test.html', $iMode = 0)
	If Not $sData Then SetError(1, __HttpRequestErrNotify('_FileWrite_Test', 'Empty Data'), '')
	ClipPut($sData)
	If StringRegExp($sData, '(?i)^0x[[:xdigit:]]+$') Then $iMode = 16
	Local $l___hOpen = FileOpen($FilePath, 2 + $iMode)
	FileWrite($l___hOpen, $sData)
	FileClose($l___hOpen)
	ShellExecute($FilePath)
EndFunc


Func _TimeStampUNIX($ModeMilliSecond = False, $iYear = @YEAR, $iMonth = @MON, $iDay = @MDAY, $iHour = @HOUR, $iMin = @MIN, $iSec = @SEC)
	Local $iMSec = 0
	If $ModeMilliSecond Then
		Local $stSystemTime = DllStructCreate('ushort;ushort;ushort;ushort;ushort;ushort;ushort;ushort')
		DllCall('kernel32.dll', 'none', 'GetSystemTime', 'ptr', DllStructGetPtr($stSystemTime))
		$iMSec = StringFormat('%03d', DllStructGetData($stSystemTime, 8))
	EndIf
	Local $nYear = $iYear - ($iMonth < 3 ? 1 : 0)
	Return ((Int(Int($nYear / 100) / 4) - Int($nYear / 100) + $iDay + Int(365.25 * ($nYear + 4716)) + Int(30.6 * (($iMonth < 3 ? $iMonth + 12 : $iMonth) + 1)) - 2442110) * 86400 + ($iHour * 3600 + $iMin * 60 + $iSec)) * ($iMSec ? 1000 : 1) + $iMSec
EndFunc


Func _B64Encode($binaryData, $iLinebreak = 0, $safeB64 = False)
	If Not $binaryData Then Return SetError(1, __HttpRequestErrNotify('_B64Encode', 1), '')
	Local $lenData = StringLen($binaryData) - 2, $iOdd = Mod($lenData, 3), $spDec = '', $base64Data = ''
	For $i = 3 To $lenData - $iOdd Step 3
		$spDec = Dec(StringMid($binaryData, $i, 3))
		$base64Data &= $g___aChr64[$spDec / 64] & $g___aChr64[Mod($spDec, 64)]
	Next
	If $iOdd Then
		$spDec = BitShift(Dec(StringMid($binaryData, $i, 3)), -8 / $iOdd)
		$base64Data &= $g___aChr64[$spDec / 64] & ($iOdd = 2 ? $g___aChr64[Mod($spDec, 64)] & $g___sPadding & $g___sPadding : $g___sPadding)
	EndIf
	If $iLinebreak Then $base64Data = StringRegExpReplace($base64Data, '(.{' & $iLinebreak & '})', '${1}' & @LF)
	If $safeB64 Then $base64Data = StringReplace(StringReplace($base64Data, '+', '-', 0, 1), '/', '_', 0, 1)
	Return $base64Data
EndFunc


Func _B64Decode($base64Data)
	If Not $base64Data Then Return SetError(1, __HttpRequestErrNotify('_B64Decode', 1), '')
	$base64Data = StringStripWS($base64Data, 8)
	If Mod(StringLen($base64Data), 2) Then SetError(2, __HttpRequestErrNotify('_B64Decode', 2), '')
	Local $aData = StringSplit($base64Data, ''), $binaryData = '0x', $iOdd = 0 * StringReplace($base64Data, $g___sPadding, '', 0, 1) + @extended
	For $i = 1 To $aData[0] - $iOdd * 2 Step 2
		$binaryData &= Hex((StringInStr($g___sChr64, $aData[$i], 1, 1) - 1) * 64 + StringInStr($g___sChr64, $aData[$i + 1], 1, 1) - 1, 3)
	Next
	If $iOdd Then $binaryData &= Hex(BitShift((StringInStr($g___sChr64, $aData[$i], 1, 1) - 1) * 64 + ($iOdd - 1) * (StringInStr($g___sChr64, $aData[$i + 1], 1, 1) - 1), 8 / $iOdd), $iOdd)
	Return $binaryData
EndFunc


Func _B64SetupDatabase($___sChr64, $___sPadding = '=')
	If StringInStr($___sChr64, $___sPadding, 1, 1) Then Return SetError(1, __HttpRequestErrNotify('_B64SetupDatabase', 1), False)
	Local $___aChr64 = StringSplit($___sChr64, "", 2)
	Local $___iCounter = 0, $___uBound = UBound($___aChr64) - 1
	If $___uBound <> 63 Then Return SetError(2, __HttpRequestErrNotify('_B64SetupDatabase', 2), False)
	For $i = 0 To $___uBound
		For $k = 0 To $___uBound
			If $___aChr64[$i] == $___aChr64[$k] Then $___iCounter += 1
		Next
		If $___iCounter = 2 Then Return SetError(3, __HttpRequestErrNotify('_B64SetupDatabase', 3), False)
		$___iCounter = 0
	Next
	$g___sChr64 = $___sChr64
	$g___aChr64 = $___aChr64
	$g___sPadding = $___sPadding
	Return True
EndFunc




#Region <FUNC đã đổi tên và sẽ bị loại bỏ ở phiên bản sau>
	Func _URLDecode($sData, $Escape_Character = '\u', $end_Escape_Char = ';')
		ConsoleWrite('!HAM _URLDecode DA DUOC DOI TEN THANH _HTMLDecode. VUI LONG SU DUNG TEN HAM MOI BOI _URLDecode SE BI LOAI BO O CAC PHIEN BAN SAU' & @CRLF)
		$sData = _HTMLDecode($sData, $Escape_Character, $end_Escape_Char)
		If @error Then Return SetError(1, __HttpRequestErrNotify('_URLDecode', 1), $sData)
		Return $sData
	EndFunc

	Func _WinHttpBoundaryGenerator()
		ConsoleWrite('!HAM _WinHttpBoundaryGenerator DA DUOC DOI TEN THANH _BoundaryGenerator. VUI LONG SU DUNG TEN HAM MOI BOI _WinHttpBoundaryGenerator SE BI LOAI BO O CAC PHIEN BAN SAU' & @CRLF)
		Return _BoundaryGenerator()
	EndFunc

	Func _HttpRequest_ClearCookies($sSessionNumber = 0)
		ConsoleWrite('!HAM _HttpRequest_ClearCookies DA DUOC DOI TEN THANH _HttpRequest_ClearSession. VUI LONG SU DUNG TEN HAM MOI BOI _HttpRequest_ClearCookies SE BI LOAI BO O CAC PHIEN BAN SAU' & @CRLF)
		_HttpRequest_ClearSession($sSessionNumber)
	EndFunc

	Func _HttpRequest_NewSession($sSessionNumber = 0)
		ConsoleWrite('!HAM _HttpRequest_NewSession DA DUOC DOI TEN THANH _HttpRequest_ClearSession. VUI LONG SU DUNG TEN HAM MOI BOI _HttpRequest_NewSession SE BI LOAI BO O CAC PHIEN BAN SAU' & @CRLF)
		_HttpRequest_ClearSession($sSessionNumber)
	EndFunc
#EndRegion




#Region <INTERNAL FUNCTIONS>
	Func _WinHttpReadData_Ex($hRequest, $ptCallBackFunc_ReadWrite = '')
		$g___MaskFunc = 1
		$g___PosLoop = 0
		;----------------------------------
		Local $vBinaryData = Binary(''), $aCall, $iCheckCallbackFunc = 0, $NOBPR = $g___BytesReadPerLoop
		Local $tBuffer = DllStructCreate("byte[" & $NOBPR & "]")
		;----------------------------------
		$g___DataSizeBytes = Number(_WinHttpQueryHeaders2($hRequest, 5)) ;$WINHTTP_QUERY_CONTENT_LENGTH
		If $g___DataSizeBytes Then
			If $g___DataSizeBytes > 2147483647 Then Return SetError(102, __HttpRequestErrNotify('File is too large', 102), 'File is too large')
			$g___TotalLoops = Ceiling($g___DataSizeBytes / $NOBPR)
		EndIf
		;----------------------------------
		If IsFunc($ptCallBackFunc_ReadWrite) Then $iCheckCallbackFunc = 1
		;----------------------------------
		For $i = 0 To 2147483647
			$g___PosLoop += 1
			If $g___CancelReadWrite Then
				$g___CancelReadWrite = 0
				Return SetError(999, __HttpRequestErrNotify('Cancel Read Data', 999), '')
			EndIf
			$aCall = DllCall($g___WinHttpDLL, "bool", "WinHttpReadData", "handle", $hRequest, "struct*", $tBuffer, "dword", $NOBPR, 'dword*', 0)
			If @error Or Not $aCall[0] Or Not $aCall[4] Then ExitLoop
			If $aCall[4] < $NOBPR Then
				$vBinaryData &= BinaryMid(DllStructGetData($tBuffer, 1), 1, $aCall[4])
			Else
				$vBinaryData &= DllStructGetData($tBuffer, 1)
			EndIf
			If $iCheckCallbackFunc Then $ptCallBackFunc_ReadWrite()
		Next
		Return $vBinaryData
	EndFunc


	Func _WinHttpWriteData_Ex($hRequest, $sDataToSend, $ptCallBackFunc_ReadWrite = '')
		$g___MaskFunc = 2
		$g___PosLoop = 0
		;----------------------------------
		Local $aCall, $iLenBytes_Write, $tBuffer, $iBytes_Write, $iStart = 1, $iCheckCallbackFunc = 0
		If IsFunc($ptCallBackFunc_ReadWrite) Then $iCheckCallbackFunc = 1
		If Not IsBinary($sDataToSend) Then $sDataToSend = StringToBinary($sDataToSend)
		$g___DataSizeBytes = BinaryLen($sDataToSend)
		If $g___DataSizeBytes > 2147483647 Then Return SetError(101, __HttpRequestErrNotify('File is too large', 101), 'File is too large')
		$g___TotalLoops = Ceiling($g___DataSizeBytes / $g___BytesReadPerLoop)
		For $i = 1 To $g___TotalLoops
			$g___PosLoop += 1
			If $g___CancelReadWrite Then
				$g___CancelReadWrite = 0
				Return SetError(999, __HttpRequestErrNotify('Cancel Write Data', 999), '')
			EndIf
			$iBytes_Write = BinaryMid($sDataToSend, $iStart, $g___BytesReadPerLoop)
			$iLenBytes_Write = BinaryLen($iBytes_Write)
			If $iLenBytes_Write = 0 Then ExitLoop
			$tBuffer = DllStructCreate("byte[" & $iLenBytes_Write & "]")
			DllStructSetData($tBuffer, 1, $iBytes_Write)
			$aCall = DllCall($g___WinHttpDLL, "bool", "WinHttpWriteData", "handle", $hRequest, "struct*", $tBuffer, "dword", $iLenBytes_Write, "dword*", 0)
			If @error Or Not $aCall[0] Then ExitLoop
			$iStart += $g___BytesReadPerLoop
			If $iCheckCallbackFunc Then $ptCallBackFunc_ReadWrite()
		Next
	EndFunc


	Func _URLSplit($sURL)
		Local $aResult[6] = [1, 80]
		Local $aURL1 = StringRegExp(StringStripWS($sURL, 3), '(?i)^http(s)?://(www\.)?(.+)$', 3)
		If @error Or Not $aURL1[2] Then Return SetError(1)
		If $aURL1[0] Then
			$aResult[0] = 2
			$aResult[1] = 443
		EndIf
		Local $aURL2 = StringRegExp($aURL1[2], '^([^@:]*):?([^@]*)@(.+)$', 3)
		If @error Then
			$sURL = $aURL1[1] & $aURL1[2]
		Else
			$sURL = $aURL1[1] & $aURL2[2]
			$aResult[4] = $aURL2[0]
			$aResult[5] = $aURL2[1]
		EndIf
		Local $aURL3 = StringRegExp($sURL, '^([^\/\?]+)(\/?.*)$', 3)
		If @error Then Return SetError(2)
		$aResult[3] = $aURL3[1]
		Local $aURL4 = StringRegExp($aURL3[0], '^([^\:]+)\:?(.*?)$', 3)
		If @error Then Return SetError(3)
		$aResult[2] = $aURL4[0]
		If StringIsDigit($aURL4[1]) Then $aResult[1] = $aURL4[1]
		Return $aResult
	EndFunc

	Func _HttpRequest_CancelReadWrite()
		$g___CancelReadWrite = 1
	EndFunc

	Func __HttpRequestCloseAll()
		Local $aListSession = _HttpRequest_GetSessionList()
		If Not @error Then
			For $i = 0 To UBound($aListSession) - 1
				_HttpRequest_ClearSession($aListSession[$i])
			Next
		EndIf
		If $g___WinHttpDLL Then DllClose($g___WinHttpDLL)
		If $g___User32DLL Then DllClose($g___User32DLL)
	EndFunc

	Func __HttpRequestErrNotify($__TrueValue = '', $__ErrorNote = 0, $__FalseValue = '')
		If $g___ErrorNotify = True And $__ErrorNote Then
			ConsoleWrite('! ' & $__TrueValue & ' - Warning: ' & $__ErrorNote & @CRLF)
		Else
			Return $__FalseValue
		EndIf
	EndFunc

	Func __WinHttpMIMEType2($sFileName)
		Local $__sDataType = ''
		$__sDataType &= ';ai|application/postscript;aif|audio/x-aiff;aifc|audio/x-aiff;aiff|audio/x-aiff;asc|text/plain;atom|'
		$__sDataType &= 'application/atom+xml;au|audio/basic;avi|video/x-msvideo;bcpio|application/x-bcpio;bin|application/oc'
		$__sDataType &= 'tet-stream;bmp|image/bmp;cdf|application/x-netcdf;cgm|image/cgm;class|application/octet-stream;cpio|'
		$__sDataType &= 'application/x-cpio;cpt|application/mac-compactpro;csh|application/x-csh;css|text/css;dcr|application'
		$__sDataType &= '/x-director;dif|video/x-dv;dir|application/x-director;djv|image/vnd.djvu;djvu|image/vnd.djvu;dll|app'
		$__sDataType &= 'lication/octet-stream;dmg|application/octet-stream;dms|application/octet-stream;doc|application/mswo'
		$__sDataType &= 'rd;dtd|application/xml-dtd;dv|video/x-dv;dvi|application/x-dvi;dxr|application/x-director;eps|applic'
		$__sDataType &= 'ation/postscript;etx|text/x-setext;exe|application/octet-stream;ez|application/andrew-inset;gif|imag'
		$__sDataType &= 'e/gif;gram|application/srgs;grxml|application/srgs+xml;gtar|application/x-gtar;hdf|application/x-hdf'
		$__sDataType &= ';hqx|application/mac-binhex40;htm|text/html;html|text/html;ice|x-conference/x-cooltalk;ico|image/x-i'
		$__sDataType &= 'con;ics|text/calendar ;ief|image/ief;ifb|text/calendar;iges|model/iges;igs|model/iges;jnlp|applicati'
		$__sDataType &= 'on/x-java-jnlp-file;jp2|image/jp2;jpe|image/jpeg;jpeg|image/jpeg;jpg|image/jpeg;js|application/x-jav'
		$__sDataType &= 'ascript;kar|audio/midi;latex|application/x-latex;lha|application/octet-stream;lzh|application/octet-'
		$__sDataType &= 'stream;m3u|audio/x-mpegurl;m4a|audio/mp4a-latm;m4b|audio/mp4a-latm;m4p|audio/mp4a-latm;m4u|video/vnd'
		$__sDataType &= '.mpegurl;m4v|video/x-m4v;mac|image/x-macpaint;man|application/x-troff-man;mathml|application/mathml+'
		$__sDataType &= 'xml;me|application/x-troff-me;mesh|model/mesh;mid|audio/midi;midi|audio/midi;mif|application/vnd.mif'
		$__sDataType &= ';mov|video/quicktime;movie|video/x-sgi-movie;mp2|audio/mpeg;mp3|audio/mpeg;mp4|video/mp4;mpe|video/m'
		$__sDataType &= 'peg;mpeg|video/mpeg;mpg|video/mpeg;mpga|audio/mpeg;ms|application/x-troff-ms;msh|model/mesh;mxu|vide'
		$__sDataType &= 'o/vnd.mpegurl;nc|application/x-netcdf;oda|application/oda;ogg|application/ogg;pbm|image/x-portable-b'
		$__sDataType &= 'itmap ;pct|image/pict;pdb|chemical/x-pdb;pdf|application/pdf;pgm|image/x-portable-graymap;pgn|applic'
		$__sDataType &= 'ation/x-chess-pgn;pic|image/pict;pict|image/pict;png|image/png;pnm|image/x-portable-anymap;pnt|image'
		$__sDataType &= '/x-macpaint;pntg|image/x-macpaint;ppm|image/x-portable-pixmap;ppt|application/vnd.ms-powerpoint;ps|a'
		$__sDataType &= 'pplication/postscript;qt|video/quicktime;qti|image/x-quicktime;qtif|image/x-quicktime;ra|audio/x-pn-'
		$__sDataType &= 'realaudio;ram|audio/x-pn-realaudio;ras|image/x-cmu-raster;rdf|application/rdf+xml;rgb|image/x-rgb;rm'
		$__sDataType &= '|application/vnd.rn-realmedia;roff|application/x-troff;rtf|text/rtf;rtx|text/richtext;sgm|text/sgml;'
		$__sDataType &= 'sgml|text/sgml;sh|application/x-sh;shar|application/x-shar;silo|model/mesh;sit|application/x-stuffit'
		$__sDataType &= ';skd|application/x-koan;skm|application/x-koan;skp|application/x-koan;skt|application/x-koan;smi|app'
		$__sDataType &= 'lication/smil;smil|application/smil;snd|audio/basic;so|application/octet-stream ;spl|application/x-f'
		$__sDataType &= 'uturesplash;src|application/x-wais-source;sv4cpio|application/x-sv4cpio;sv4crc|application/x-sv4crc;'
		$__sDataType &= 'svg|image/svg+xml;swf|application/x-shockwave-flash;t|application/x-troff;tar|application/x-tar;tcl|'
		$__sDataType &= 'application/x-tcl;tex|application/x-tex;texi|application/x-texinfo;texinfo|application/x-texinfo;tif'
		$__sDataType &= '|image/tiff;tiff|image/tiff;tr|application/x-troff;tsv|text/tab-separated-values;txt|text/plain;usta'
		$__sDataType &= 'r|application/x-ustar;vcd|application/x-cdlink;vrml|model/vrml;vxml|application/voicexml+xml;wav|aud'
		$__sDataType &= 'io/x-wav;wbmp|image/vnd.wap.wbmp;wbmxl|application/vnd.wap.wbxml;wml|text/vnd.wap.wml;wmlc|applicati'
		$__sDataType &= 'on/vnd.wap.wmlc;wmls|text/vnd.wap.wmlscript;wmlsc|application/vnd.wap.wmlscriptc;wrl|model/vrml;xbm|'
		$__sDataType &= 'image/x-xbitmap;xht|application/xhtml+xml;xhtml|application/xhtml+xml;xls|application/vnd.ms-excel;x'
		$__sDataType &= 'ml|application/xml;xpm|image/x-xpixmap;xsl|application/xml;xslt|application/xslt+xml;xul|application'
		$__sDataType &= '/vnd.mozilla.xul+xml;xwd|image/x-xwindowdump;xyz|chemical/x-xyz;zip|application/zip;'
		Local $aArray = StringRegExp($__sDataType, "(?i)\Q;" & StringRegExpReplace($sFileName, ".*\.", "") & "\E\|(.*?);", 3)
		If @error Then Return "application/octet-stream"
		Return $aArray[0]
	EndFunc
#EndRegion






#Region -------------------ZLIB UDF by [WARD] autoitscript.com--------------------------------
	Func __MemVrAlloc($pAddress, $iSize, $iAllocation, $iProtect)
		Local $aResult = DllCall("kernel32.dll", "ptr", "VirtualAlloc", "ptr", $pAddress, "ulong_ptr", $iSize, "dword", $iAllocation, "dword", $iProtect)
		If @error Then Return SetError(@error, @extended, 0)
		Return $aResult[0]
	EndFunc

	Func __MemVrFree($pAddress, $iSize, $iFreeType)
		Local $aResult = DllCall("kernel32.dll", "bool", "VirtualFree", "ptr", $pAddress, "ulong_ptr", $iSize, "dword", $iFreeType)
		If @error Then Return SetError(@error, @extended, False)
		Return $aResult[0]
	EndFunc

	Func __ZL_Alloc($Opaque, $Items, $Size)
		Local $aResult = DllCall("kernel32.dll", "handle", "GlobalAlloc", "uint", 0x40, "ulong_ptr", $Items * $Size)
		If @error Then Return SetError(@error, @extended, 0)
		Return $aResult[0]
	EndFunc

	Func __ZL_Free($Opaque, $Addr)
		Local $aResult = DllCall("kernel32.dll", "ptr", "GlobalFree", "handle", $Addr)
		If @error Then Return SetError(@error, @extended, False)
	EndFunc

	Func __ZL_Exit()
		$Z_Buffer = 0
		__MemVrFree($Z_BufferMemory, 0, 0x8000)
		DllCallbackFree($Z_Alloc_Callback)
		DllCallbackFree($Z_Free_Callback)
	EndFunc

	Func __ZL_Startup()
		If IsDllStruct($Z_Buffer) Then Return
		Local $Code = '', $Var_Opcode = ''
		If @AutoItX64 Then
			$Code &= '1K0AAP8OAejNKRwOTI0DQblYcBAY6Q95Cv8CMOi4K0iD7OZFdosFBMdEJDgfHFiJEjBBGYtADBEoEggmIELg6Ph1oS3EzMP/DAPp'
			$Code &= 'sWyBBO/9V58PBYi9VYUh6GoBTonCQbhRYwOOECLoVYhJiVPAeBEIjTsjmWqPDyT4OqWJYfifKIBWV8x0zwbWdkwBwfzzpF9ew0gQ'
			$Code &= '0IY/ql+5WA3o+f8CwiCWMAd3ACxhDu66UQmZHxnEbUCP9GpwNaUAY+mjlWSeMogB2w6kuNx5HvjV4PbZANKXK0y2Cb18ALF+By24'
			$Code &= '55EdB7+QZBC3YPIgsGoASHG5895BvoQAfdTaGuvk3W08UbWA9MeF04NWmABsE8Coa2R6+QBi/ezJZYpPXAMBFNlsBmOIPQ/6KPUN'
			$Code &= 'vgDIIG47XhBpTADkQWDVcnFnonnRAAM8R9QES/2FAA3Sa7UKpfqo6jUAbJiyQtbJu9sHQPm8rOPQ2DJ1XADfRc8N1txZPQHRq6ww'
			$Code &= '2SY6wN5RcoAA18gWYdC/tfQAtCEjxLNWmZUBus8Ppb24nsgCKAAIiAVfstkMxpAgAAuxh3xvLxFMAGhYqx1hwT0tAGa2kEHcdgZx'
			$Code &= 'ANsBvCDSmCoQB9XviYWx4B+1tgYApeS/nzPUuOgDoskHeDT5gA+OqAAJlhiYDuG7DQBqfy09bQiXbABkkQFcY+b0UXFrPmJhgRzY'
			$Code &= 'MGWFTsPQ8u2VfQYAe6UBG8H0CIIAV8QP9cbZsGUAUOm3Euq4vosAfIi5/N8d3WIHSS3aFfPQ04xlTAHU+1hhsk3OIC06cHQAvKPi'
			$Code &= 'MLvUQaUG30rXldjEAMTRpPv01tNqAOlpQ/zZbjRGAIhnrdC4YNpzAC0EROUdAzNfAEwKqsl8Dd08HnEFUENBAicQiAu+hgAgDMkl'
			$Code &= 'tWhXsz2FbwAJ1Ga5n+RhAM4O+d5emMnZOikigNCwtKjXxxcHPbNZgQ2gLjtcvQC3rWy6wCCDuAHttrO/mgzi2QPU0rEBdDlH1eqv'
			$Code &= 'd+SdFQAm2wSDFtxzEgALY+OEO2SUPgdqbQ2oWld68M8O5J0H/wmTJ64ACrGeBz19RAAP8NKjCIdoAPIBHv7CBmldAFdi98tnZYBx'
			$Code &= 'DzZsGefga252G9QA/uAr04laetoAEMxK3Wdv37lx+Q7vvo5DY7cX1bCwYOg4o9aAfpPRocTC2AA4UvLfT/Fnu/vMV7wApt0GtT9L'
			$Code &= 'NrIASNorDdhMGwoPr/ZKA8BgegRBw3bvOd9VHWeowI5uMXm+aQBGjLNhyxqDZgC8oNJvJTbiaABSlXcMzANHCwC7uRYCIi8mBQNV'
			$Code &= 'vju6xSj4vbKSAFq0KwRqs1ynAP/XwjHP0LWLAJ7ZLB2u3luw/GQAmybyY+yco2oAdQqTbQKpBgn2PwA2DuuFZwdyE7CNAAWCSr+V'
			$Code &= 'FHq4AOKuK7F7OBu2AAybjtKSDb7VAOW379x8Id/bPwvUh9OGQuJg8fiz3QBoboPaH80WvgCBWya59uF3sHNvBEe3GOZawH5wag8A'
			$Code &= '/8o7BmZcCwF5EQCeZY9prmL40/JrTGHFAGwWeOIKoO4A0g3XVIMETsIAswM5YSZnp/cAFmDQTUdpSdsAd24+SmrRrtwAWtbZZgvf'
			$Code &= 'QPAPO9g3U8C8qcWeuwDef8+yR+n/tQ4wHPK9IYrCusrkk7MAU6ajtCQFNtD77AbXuJ0AV95Uv2fZIy4AemazuEphxAIAG2hdlCtv'
			$Code &= 'KjcBvgu0oY4Mw/zfBQVaje8CLcgAQX4xARmCYjYyw1P+QSTFMNlFAPR3fYanWlbHAJZBTwiK2chJHbvC0cPo7/rL2PTjDANPtaxN'
			$Code &= 'fq6oji2DAJ7PHJiHURLCAEoQI9lT03D0AHiSQe9hVdeuBy4U5rU3fmCYHJaEgzsFWYcbghipAJvb+i0PsJrLNk5dIXfmHGzE/98A'
			$Code &= 'P0HUng5azaIAJISV4xWfjCAARrKnYXepvqYD4ejx59DzqCSD3gHDZbLF2qqugGTrn0ZEKMwDa29p/XB2/3AxOe9aACogLAkHC204'
			$Code &= 'ARwS8zZG37LsXcYLcVRw7QCDa/T38xIqu7YA4qJ1kRyJADSgB5D7vJ8XALqNhA553qklBzjvsjz/kPNzvkgD6Gp9G8VB6CreWAAF'
			$Code &= 'T3nwRH5i6TyHLYXCxhxUwAmKFZQAQLsOjYPoI6YBwtk4vw3FoNRM9AG7IY+nlgrOzI0TcAkAzFxIMddFi2IJ+m7KUwDmVF27uhMV'
			$Code &= 'bKAAxj+NiJcOAJaRUJjX3hGpAMzH0vrh7JPLuON/XABich3meWvetQBUQJ+ET1lYEgAOFhkjFQ/acA84JJtBID2na/1lmCTkfAAl'
			$Code &= 'CctXZDjQTi6jrlcA4p+KGCHMAKczYP28Kq/hAiSt7tA/tEBvEp8HbLIJhqvwSMnqFQBT0ClGfvtodwBl4vZ5Py+3SAAkNnQbCR01'
			$Code &= 'KgASBPK8U0uzjQBIUnDeZXkx7wB+YP7z5ue/wnf9AHyR0NU9oMvMA/o2ioO7B+iaeFQAvLE5ZaeoS5j+OzoKqYAiyfq1CYjLAK4Q'
			$Code &= 'T13vXw5sAfRGzT/ZbYzkwnQAQxJa8wIjQeocwXBs3YDAd9hH1zaXAwbmLY7FtYGlhMQbvAAaikFxW7taaAeY6HdD2RdskB5PLRUH'
			$Code &= 'X342DJxwGyfdHOA+cBIAmLlTMYOgkGIerovRQLWSFsX03XNXB+/ElKfCUNWW2fYA6bwHrqiNHLeQIQ4xnCrvRIXtgCvKrEgBcNNv'
			$Code &= 'G134LvxG4eI2JN5mxwHFf2NU6MgiZRzzTeXAsgKkwqkbAGeRhDAmoJ8pB7iuxeT5cN79Oswd89Z7gOjPvGupgPpaB7KZPgmfUH84'
			$Code &= 'hKsAsCQcLPEVBzUBMkYqHnN3MeS04QBwSPXQa1E2gz9GeoKyXWNO12DXD+YO4dLMtUn5jyeg4EoSlq89CyMAtshwoJ2JQQ+7hEZd'
			$Code &= 'oAMHbDgaA8Q/FTGFDogoQpgAT2cDqVR+wPoAeVWBy2JMH8V3OABe9COYnacOswfclhWqGwBU5VoxDk/8mWIg19hTec57FwDhSVZ+'
			$Code &= '+lCVLf57AdQczGITio3oUrsOljSR6KAf0NmgBgDs835ercJlRwdukUhsL/BTdeg2ABI6qQcJI2pUACQIK2U/EeR5mHkApUi8j2Yb'
			$Code &= 'kaQHJyqKveCwy/KhjRTQ62LzAMAj7+bZveEfvBT8wKcNP4OKJh1+spHPuSSgcPgVy2kKO0bmQuEA/Vu1a2XcAPRafsU3CVPuA3Y4'
			$Code &= 'SPexrsi48J8AEqEzzD+Kcv0uJJMAQDdqwgEAbtSEA1m+RgIs3KhZH+vAywayfI0EAIUWTwW4URMOB4870Q/W0JcN4e8GVQxk+RqU'
			$Code &= 'A5PYCAotnpk9R3DScB2jJhzAyeQdHneiOx8pO2CArAsvG5th7QAawt+rGPW1aQAZyPI1Ev+Y9wATpiaxEZFMcwAQFFo8FSMw/u56'
			$Code &= 'B464Fk3kYRfgRtg41x8sjznAksk7ufgLBzo87kQ/YISGPlL0wPZlAFACPVgXXjZvHX2cN0DD2jUBqRgANIS/VzGz1ZUAMOpr0zLd'
			$Code &= 'AREeM5DlRSSnj4Lc/mDtJ8kAWy0mTE1iI3v0oHEiAJnmIBXzJCEoALR4Kh/euitGA2D8KXEKPvn0HNgtwwB2syyayPUurQeiNy/A'
			$Code &= 'jaBw9+dYE3GuWQAfmTPcchwBJZN3K09RduTxFwB0RZvVdXjciX9+ALZLfxYIDX0hAGLPfKR0gHmTAB5CeMqgBHr96sYCe7AuvGyH'
			$Code &= '4EFt3gX6OG/pkMcU1IaAclvsdwBqAlIxaDU48wRpCH+vYsA7bWNmAKsrYVHB6WDUA9emZeO9ZIi6AyIAZo1p4Gcgy9cBSBehFUlO'
			$Code &= 'H2C4ebi1AEr8Y95Pywkc/pIBt1pMpd2YTciaxABGr/AGR/ZOQAdFwSSCRBAyzUFzPlgPgCrmSUIdjIsAQ1Bo8VRnAjMAVT68dVcJ'
			$Code &= '1rcAVozA+FO7qjoAUuIUfFDVfr4eUeg5gFrfUyBbhgHtZlmxh6RYMHnrAF0D+ylcWkVvAF5tL61fgBs1AOG3cffg7s+xAOLZpXPj'
			$Code &= 'XLM8POZrgP7nMme45QUADXrkOEom7w93IADuVp6i7GH0YHrtB+Iv6NOIcOmKNqsA671caerwuBNc/e0A0fyebJf+qQAGVf8sEBr6'
			$Code &= 'GwB62PtCxJ75dQeuXPhI6QDzf4PCAPImPYTwEVdGAPGUQQn0oyvLAPX6lY33zf9PAPZgXXjZVze6ANgOifzaOeM+ANu89XHei5+z'
			$Code &= 'Ht/SIUDd5Us33NgADGvX72ap1rbz2NSBALIt1QSkYtAzAM6g0Wpw5tNdABok0hD+XsUnAJScxH4q2sZJAEAYx8xWV8L7ATyVw6KC'
			$Code &= '08HY6BEAwKivTcufxY+Sqh/JyPHdC0B0B0TMQ20Ahs0a08DPLbkWAs5AAO+Rd/xtkAAuQiuSGSjpkwCcPqaWq1RklwDy6iKVxYDg'
			$Code &= 'lAD4x7yfz61+ngCWEzicoXn6nQ8kb7WYYAV3mUq7ADGbfdHzmjA1AImNB19LjF7hAA2OaYvPj+ydB4CK2/dCoIJJBIkOtSPGiCBk'
			$Code &= 'moO/Dn9YAOawHoDR2tyBAFTMk4RjplGFADoYF4cNctWGAKDQ4qmXuiCoAM4EZqr5bqSrAHx4665LEimv5qwOb60lxn2AGIHxpy/r'
			$Code &= 'ADOmdlV1pEE/ALelxCn4oPNDADqhqv18o52XAL6i0HPEtecZPQa0AKdAtonNgrc6DNuBsjuxD7NizUnYVWUAi7BoIte7X0gAFboG'
			$Code &= '9lO4MZwAkbm0it68g+AAHL3aXlq/7TQumL4AQGVnvLgAi8gJqu6vtRIBV5dijzLw3iB5XxZrJbkFmp3vgEHFik8ACH1k4L1vAYfk'
			$Code &= '1wC4v9ZK3dhq8gAzd9/gVhBjWACfVxlQ+jCl6HkU+9xx+ACsQsjAe9+tpwDHZ0MIcnUmbw/OzXB/wJUVGBEtA/u3pD+e0MiHJ+gA'
			$Code &= 'zxpCj3OirCAAxrDJR3oIPq8AMqBbyI4YtWccOwrQAIeyaThQLwAMX+yX4vBZhf3Y5T110QCGZbTgOt1aTw2Pzz8o7PgQ5Dvq4wBY'
			$Code &= 'Ug3Y7UBoDr9R+KFAK/DEn5cMSCowIkZXAJ7i9m9Jf5MIEvXHfQIQ1RjAQNlO0AGfNSu3I43F9ZbkoH8AKicZR/26fCAAQQKSj/QQ'
			$Code &= '9+guSKhhDhSbbj/gI7aQHTEA0/ehiWrPdhR/DwDKrOEHf76EYADDBtJwoF63FwAc5lm4qfQ83wAVTIXnwtHggAB+aQ4vy3trSEx3'
			$Code &= 'aB4PDUHHaLFzKdQEYQBMoLjZ9ZhvRACQ/9P8flBm7gAbN9pWTSe5DgAoQAW2xu+wpAejiAwcGnDbgX/XAGc5kXjSK/QfAG6TA/cm'
			$Code &= 'O2aQmCQDiD8vke1Y+ClUYABEtDEH+AzfqAFNHrrP8abs5JL+AIm4LkZnF5tUHwJwJ8W7SPCAIS9MyQAwgPnbVedFYw+coD9rQMeD'
			$Code &= '0xdoADbBcg+Kecs3AF3krlDhXED/AFROJZjo9nOIf4scFu83wPhAggSdJ7gmACQf6SFBeFWZAK/X4IvKsFwzADu2We1e0eVV90Cx'
			$Code &= 'R9UZAOz/bCE7YglGAIfa5+kyyIKO4nAA1J7tKLH5UZAfX1bkxzoxWDCDCY+nAOZuMx8IwYYNP22mg7Wk4UC9ABb8BS8pSRdKAE71'
			$Code &= 'r/N2IjKWABGeini+K5gdA9mXIEvJ9NgurkhxwAAB/dKlZkFqHABelvd5OSpPl5CPC13y8SOAZBlrTWAAftf1jtFi5+sPtt5fUiAJ'
			$Code &= 'wjfptRx62UYHaLwhINDqMd8AiI9WYzBh+dYBIgSeapq9psgH2ADBAb82brStUwAJCBWaTnId/wApzqURhnu3dADhxw/N2RCSqAC+'
			$Code &= 'rCpGERk4IwB2pYB1ZsbYEAABemD+rs9ymwDJc8oi8aRXRwCWGO+pOa39zABeEUUG7k12YwCJ8c6NJkTc6ABB+GRReS/5ND0ekwTa'
			$Code &= 'sSZTwOua6+l/xgCzjKFFC2IO8A8ZB2lMQL5RmzzbADYnhDWZkpZQOP4u9wC5VCb83uieEgBxXYx3FuE0zgMuNqmrSYoAsuY/AyCB'
			$Code &= 'g7sAdpHg4xP2XFsA/VnpSZg+VfEDIQaCbERhyNSqzgCLxs+pN344QQB/1l0mw26ziTx2fIfuysRv4B1ZCrEAoeHkHhTzgXkAqEvX'
			$Code &= 'acsTsg4Ad6tcocK5OcYAfgGA/qmc5ZkEFSQLNqCAA1EcjgCnFmaGwnHaPhws3m/ASbnTlPCBAQQJlea4sXv0DaM7Hi6AG0g+0kMt'
			$Code &= 'WQBu+8P22+mmkQBnUR+psMx6zgAMdJRhuWbxBi4F3gBAdwcwlgDuDmEsmQlRuvZtAMQZcGr0j+ljAKU1nmSVow7bAIgyedy4pODV'
			$Code &= 'B+kel9LZ0Am2TCsAfrF8vee4LQcOkL8dkUC3EGRqsAAg8vO5cUiEvgBB3hra1H1t3R3k6/TJtVGAloXHE2wAmFZka6jA/WIA+XqK'
			$Code &= 'ZcnsFAEAXE9jBmzZ+g93PQCNCA31O24gyABMaRBe1WBB5AOiZ3FyPAO40UsEANRH0g2F/aUKHLVrNcCo+kKymGwA27vJ1qy8+UA9'
			$Code &= 'MtiB40XfXHXc+A3PAKvRPVkm2TCsUFHGOjvI1wCAv9BhFiG0APS1VrPEI8+6AJWZuL2lDygC7J4AXwWICMYM2bIAsQvpJC9vfIcA'
			$Code &= 'WGhMEcFhHasAtmYtPXbcQZAAAdtxBpjSILwP79UQKkOxhYnotrUfF5+/5ADVuNQzeAdYyeNwmBMAlgmojuEOmBgAf2oNuwhtPS0A'
			$Code &= 'kWRsl+ZjXAFxax5R9BzAYWKFZTDYdvLgTvYGAJXtGwGle4IIAPTB9Q/EV2WwANnGErfpUIu+ALjq/LmIfGLdXB1GA9otSYzT2PP7'
			$Code &= '1AVMZU2yYYVVAyvOo7yDdPi7MOIASt+lQT3YldcApNHEbdPW9PsAQ2npajRu2fwArWeIRtpguNAARAQtczMDHeUAqgpMX90NfMkB'
			$Code &= 'UAVxPCcCQfy+C3EQ+gwDIIZXaLUlsG+Fs5DeANQJzmHkn17eAPkOKdnJmLDQ5iIAx9eotFmzPRd2LgANgbe9XDvAugBsre24gyCa'
			$Code &= 'vxyztgOT4gcVsdKw6tVHOXedAHevBNsmFXPcABaD42MLEpRkLDuE7QdqPnowWqjkDgHPC5MJ/50KwK4nA30HnrHwD/BEhwgAo9Ie'
			$Code &= 'AfJoaQYAwv73YlddgGUAZ8sZbDZxbmsABuf+1Bt2idMAK+AQ2npaZ90ASsz5ud9vjr537zoXt49DYLBH1dYQo+ih0ViTCADYwsRP'
			$Code &= '3/JS9rtcZ/UdvFdAP7UG3UiyADZL2A0r2q8KPRtMAgNK9kEEwcjfyO/DO6hnB1Uxbo6RRmm+cPBhsJ8AvGaDGiVv0qAAUmjiNswM'
			$Code &= 'd5UAuwtHAyICFrkAVQUmL8W6O74Asr0LKCu0WpIAXLNqBMLX/6cAtdDPMSzZnosAW96uHZtkwrAA7GPyJnVqo5wOAm2TCqAJBqnr'
			$Code &= 'DgE2P3IHZ4UFwFcTAJW/SoLiuHoUAHuxK64Mths4AZLSjpvl1b4getwA77cL298hhtMc0tTxgOJCaN2z+AAf2oNugb4WzQD2uSZb'
			$Code &= 'b7B34R0Yt0dmegBa5v8PanAAZgY7yhEBC1wfj2WewPhirmlha+7TABZsz0WgCuJ4ANcN0u5OBINUADkDs8KnZyZhANBgFvdJaUdN'
			$Code &= 'AD5ud9uu0WpKANnWWtxA3wtmADfYO/CpvK5TAN67nsVHss9/BzC1/+m9EPIcyroHwopTs5PwJLSjpvbQBzYFzdcG0FTeVykSI9ln'
			$Code &= 'ANpmei7EYQBKuF1oGwIqbwArlLQLvjfDDACOoVoF3xstAi7vjQBHGaAxQTI2AmKCKy1Tw2DXxQQAfXf0RVZap4YAT0GWx8jZiggB'
			$Code &= '0cK7Sfrv6OTj9PrLDqy1Twxgrn5NnoMALY6HmBzPSsIAElFT2SMQePQAcNNh70GSLq4A11U3teYUHJjr5AWDD4SWghsnWZsAqRiw'
			$Code &= 'LTv62wE2y5rmd13E/2ziHADUQT/fzVoOngCVhCSijJ8V4wCnskYgvql3YQ7x6OGmYPPQ58PeA4Mk2sWyZQBcrqpERp/rbwBrzCh2'
			$Code &= 'cP1pOXkxAK4gKlrvCwcJACwSHDht30Y2H/PGXUCy7XBUcfRYa4UfuyrA96IxwraJAByRdZAHoDQXAJ+8+w6EjbolAKneeTyy7zhz'
			$Code &= 'd/ML/2roSICqxRt9WA/eKjzw4E8F6WJ+O0TCgC2H21QcxpQAFYoBjQ67QKYBI+iDvzjZwsygxT8NIYD0TAqWp48TdY0czlzMAAlF'
			$Code &= '1zFIbhL6YosJ4lMAe7tdVKMAoGwViI0/1pEAlg6X3teYUMcAzKkR7OH60vXmywCTcmLXXGt55gAdQFS13llPhACfFg4SWA8VIwMZ'
			$Code &= 'JDhw2j24QZtlCf1rp3x4AQBXywklTtA4ZAABka6jGIqf4gAzp8whKrz9YACtJOGvtD/Q7iSfEnEAhgmybMlIPySrAFMV6vt+RikA'
			$Code &= '4mV3aC8/efYANiRItx0JG3QBBBIqNUtTvGFF/I2zAHll3nBgfu8xDufm8/4g/cK/1dAAkXzMy6A9g4oeNvqawAe7sbxUeACop2U5'
			$Code &= 'O4OYS3MiAKkKCbX6yRCuAMuIX+9dT0b0AGwObdk/zXTC7owA81oSQ+pBIwIcwWxwz9h3IICXNtdHB44t5galALXFvBtxhABxQYoa'
			$Code &= 'aFq7Ww5Dd+iY52zZEBUtTx4EDDZ+XyfBXpw+wBzdOLmYABKggzFTi64OYpCSteDR3fTFFjrE77lXzOoAlPbZltWuBwC86bccjaic'
			$Code &= 'MRLea4XwAcqQLQDt03BIrPhdGx9v4UbDLmbeNrl/xSHJKwH/Y03zZWDXsurlABupwqQwhJFnACmfoCbkxa64PP3egPnW88w6z+j0'
			$Code &= 'ewGAqWu8mbJa55ifCT4Aq4Q4fywcJLAANQcV8R4qRjLuMQB3c0hw4bRRax/Q9XrAgzZjXbJ3AMv6107S4eYPS/nDAeDcwCmvlhI7'
			$Code &= 'SrYBIwudoHDI+LtBPYkDg11GGjhsA3YVP8QoDoiFZ08AmEJ+VKkDVXkD+sBMYsuBiDjFHwCYI/Resw6nnQOqFZbc5VSAG/xPDjFa'
			$Code &= '12Igmc55U9g+SeGAF1D6flZ71wktlWLMjvfAjYoTNJYcu1IfwOiRBqDZ0ABefvPsR2XCrT9sSIBudVOgLzoSADboIwkHqQgkAlRq'
			$Code &= 'ET9lK2B3eeQAj7xIpaSRG2YDvYoqJ/LL6ODr0BSNocD1AWLZ5u8jFPzhvQANp9D8JoqDP+KRHrJ+cMAkuWnLFfgAQuZGO1v9d3oS'
			$Code &= '3GVrAKl+WvTuUwEJN/dIOHa43K6xAKESn/CKP8wzC5Mk/XKQAAHCAGo3A4TUbgJGLL5ZVwCo3AbLwusABI18sgVPFoUADhNRuA/R'
			$Code &= 'O489DZeA1gxV7+EJGgD5ZAjYk1MKnnMtuM4ARz0cJqNwHeR5yQ4fonceL2BAKRsvC6wAGu1hmxir38IAGWm19RI18sgAE/eY/xGx'
			$Code &= 'JqYAEHNMkRU8WhTi/gEwIxa4jnoXyORNcjgARuA5jyzXO8kAko46C/i5P0QH7jw+hoSur8DAUj0CUGUANl4XWDecfW8eNdrDwDQY'
			$Code &= 'qQExVwC/hDCV1bMy0w9r6jMR590kcuWQwNyPp0wn6wD+Ji1bySNiD01MIqDBeyDmmdwhJADzFSp4tCgrugPeHyn8YEbIPgpxci0A'
			$Code &= 'HPQss3bDLvUByJovN6KtcNiNwABxWOf3cx5ZrgBy3DOZd5MlHAF2UU8rdBfx/HXVAJtFfonceH9LALZPfQ0IFnzPAGIheYB0pHhC'
			$Code &= 'AB6TegSgynvG5v0FbLwusG3AP4dvOC763hQJkOkAboZsancA7FtoMVICafMAODVir38IY22YPQBhK6tmYOnBUQdlptfUZBO94+gi'
			$Code &= 'A7oHZ+BpjUjwyyBJFSyhF7gFH05KxbOAjt5j/PIcAAnLTFq3kk2YB92lRsSaYEcG8K8ARUBO9kSCJMEdQc0y/YAPWHNCSeYqAEOL'
			$Code &= 'jB1U8WhQAFUzAmdXdbw+AFa31glT+MCMAFI6qrtQfBTiB1G+ftVaYDnoWyAAU99ZZu2GWKQAh7Fd65E0XCkA+wNeb0VaX60AL23h'
			$Code &= 'NRuA4PcAcbfisc/u43NMpVMDPLNc5/68gFa4ZzIA5HoNBe8mSjh57gAgD+yinlbtYAf0Yegv4ufpkIjT66sANorqaVy9/RMAuPD8'
			$Code &= '0dLH/pcAbJ7/VQap+hoBECz72Hob+fjEQgf4XK518wDpSPLCAIN/8IQ9JvFGAFcR9AlBlPXLACuj942V+vZPAP/N2XhdYNi6ADdX'
			$Code &= '2vyJDts+AOM53nH1vN+zHZ+L3cAh0tw3S+UA12sM2NapZu9y1O62ANUtsoHQYqQEANGgzjPT5nBqANIkGl3FXv4QAMSclCfG2ip+'
			$Code &= 'AMcYQEnCV1bMAMOVPPvB04KiHsAR6IDLTa+oyo8JxZ/IyQ6uYAsR8cxEAAd0zYZtQ8/AAdMazgK5LZFg8UB/kAD8d5IrQi6T6T8o'
			$Code &= 'GQCmPpyXZFSrAZUi6vKU4ICAcrzH+J5+rQDPnDgTlp36eQShmLVvJMMlBeibMbsASprz0X2NiTUAMIxLXweODeEAXo/Pi2mKgJ12'
			$Code &= '7ABC99uJBEmCiAPGI7WDmmS/kFgOv4AAHrDmgdza0YQAk8xUhVGmY4cAFxg6htVyDakA4tCgqCC6l6oAZgTOq6Ru+a4A63h8rykS'
			$Code &= 'S606b6zy6sYAJafxgRimM+sAL6R1VXaltz8AQaD4KcShOkMA86N8/aqivpc/nbUAc9C0Bhnntj9ApwO3gs2JspjbDLMcD7E7nUlA'
			$Code &= 'YrCLZVW7ANciaLoVSF+4AFP2BrmRnDG8AN6KtL0c4IO/AVpe2r6YNO1yAAC4vGdlqgnIAIsSta/uj2KXAFc33vAyJWtfAtyd1zi5'
			$Code &= 'xcA/730BCE+Kb73gZP5eAQBK1r+48mo/2N0A33czWGMQVgBQGVef6KUw+uPvuBRCrAD4cd97wMhnxwCnrXVyCEPNzh5vJpWBf3At'
			$Code &= 'ERhgAaQdt/uHwNCeGs/oJwCic49CsMYgrAAIekfJoDKvPgAYjshbCjtntTiyhwDQL1A4aZfsAF8MhVnw4j3l9Ic5ZYaA0d064LTP'
			$Code &= 'jzBPWuQoP+oH5BCGUlig40Dt2AEN+FG/aPAr2KFIAJefxFoiMCriAJ5XT39Jb/bHCfUIk9UEEH2A18AYNQGf0E6NI7cr3ZbsxScA'
			$Code &= 'Kn+guv1HGQIAQSB8EPSPkqgASOj3mxRYPSPyP+oxBx2Qtomh99Pwds9qrADKqA++fwfhBgDDYIReoHDS5gAcF7f0qbhZTAAV3zzR'
			$Code &= 'wueFaVh+MwB7yy8Ow3dId2soDQ/PB7Fox2EEMCnZuKAATERvmPX80/8AkO5mUH5W2jcAGw65J022BUAAKKSw78YcDIgeo4HbQBo5'
			$Code &= 'Z9d/KwDSeJGTbh/0OxMm9wMHJJBm0C8/iCkAk1jttERgVAwA+AcxHk2o36YH8c+6/pJw7EYuuAeJVJsXZ5AncAJxAPBIu8lML97b'
			$Code &= 'APmAMGNF51VrAz+gnNODx/DBNmgAF3mKD3LkXTcAy1zhUK5OVP8HQPbomCWQi4hzFjk3758Egtf4ACInnSHpH5jAAFV4QYvg168z'
			$Code &= 'AVywyu1Ztjv85dEoXkev+v8P7BnVYsAhbNqHRpgOBzLp53COEIIo7Z4H1JBR+bGQ5FZfOpAm5qcAjwmDHzNu5g0PhsEItcCmbb1A'
			$Code &= '4RikBfwaF0kLKS+v9YDDMiJ28wCKnhGWmCu+eA4gl9kdoPTJS8BIB64u0v0BcGpBZqUA95ZeHE8qOXlIXZEAl+Uj8fJNawAZBfXX'
			$Code &= 'fmDnYgDRjl/etuvCCe5SB3q16TdoAUbZ0C8BAYjfMepA6VaPIgDW+WGaap4EB5eAAb8BwdgCrbRuNhUI4O8dcgBOmqXOKf+3ewCG'
			$Code &= 'EQ/H4XSSEADZzSqsvqg4Gf5GAICldiPYxmZ1AGB6ARByz67+AMpzyZtXpPEiAO8Ylkf9rTmpAEURXsx2Te4GAM7xiWPcRCaNAGT4'
			$Code &= 'Qej5L3lR7JMfHjRTwrHa65pg7bP5AMbpC0WhjBnwOw5iAExpBzybUb4AhCc225aSmTVxLgf+UCZUuZCe6N78AIxdcRI04RZ3AKk2'
			$Code &= 'Ls4RikmrAAM/5kW7g4EgAOPgkXZbXPYTAEnpWf3xVT6YB2yCBiHUcGFExosAzqp+N6nP1n8AQThuwyZdfHYHibPEyu7zWR2Yb+Gh'
			$Code &= 'ALEK8xQe5EuoAHmBE8tp16t3AA6yucKhXAF+AMY5nKn+gCQVJZnlwP8LjgAcUW6GZhanPgPaccIsb96YlNO5AEkJBIHwsbjmHpWj'
			$Code &= 'Dc97GyAuHkPSPgBI+25ZLenb9gDDUWeRpsywqQAfdAzOema5YQCU3gUG8ej233H/BcNIiVwkg8xBscpE5+NJ4NNQ6GzgLSrGAFhB'
			$Code &= '99JFhcB0eCTOfAPPHsMPtgsYRNBJYzHB4uhnCB7R8IsUlkH6wgD/y3Xcg/sgDxKCKQK9szd8nEffcMHvBUU2MxNjFDfoEFh9FY5e'
			$Code &= 'hJYNBEcSPsiBEjOEjsPkMxgZGASGycK8KXBBDI58QwSGicFMV8BCeoVucL3qHkIIq3aFVkIQqzYUa4uFQiA6jEaFQkBJg8MgrEbK'
			$Code &= 'FuBJWfhKi6z8rT+RlOLABJQ8FISCFCE/SP/P+IXnTf1dJoskpDIEBHJUwHbZScEm6QIqorVlBAb8CaHQvjSHYnJAncl1E7OF23+t'
			$Code &= 'KOKAkPJNGN5gRV7DMcB5hQd0D/bCAVMCM6BIg8EGBNHqdfFu8uxYKA0s0hCyBsjg38pBN7kgvgZDiCgCTLMo6MjE5UGxwASg4cIM'
			$Code &= 'QPx1517EWChJzQgKMDEQe1cNgewgAWA1Uv3W0c9kRg8zjpmBuXApl+EbIC6WerDkTHqEkBUZwAHJfvjkfPH2jWxUNAqM6qDGTeh6'
			$Code &= 'ycgalGwQTMY06GgljSQRVkydQLoRrBINifroLCncx9EV+3QpPqIqmSwOVg9TRwMAdasx90yNnFIksQGJ+EmLWxCKCHMY5wHcX8Pp'
			$Code &= 'KbpJqCR4oCV1A5ArxiTO+xuhHQh1MFAdRA+3kAIfweoQqMESAXU8D2YCvf98DIH58f+Wcm8HEo4PGFxFAWXKFPoWEwgioLIawowX'
			$Code &= 'buKwGi4JyiJKPRAIbsPCjUIBrA2fEC5zRH1EEpLKA0vHQbFI5Mh1V+5gg7hxgN8pBc7iH4eOa9J+R40EEqDgEEQJUshKBYH4sBUK'
			$Code &= 'eg3egbivqW5eIKEcZCRc4AoLvzE8wFDjGoS5WzspaQWCECbCFjRD8d8yC/IcQ/OI9HH1DiH2xPc4+IcQ+eL6HEP7iPxx/Q4h/sT/'
			$Code &= 'Zg2QfphQ+/5FApXhCFQHaYKQYQHRkhaFD7vMbDLLYggpigEEJJVChBCS+aptIBzHJq9LI2TpBDHLAyrA8CMOv8lIEQ9AFI841Cbq'
			$Code &= 'SJmpMtZI7lktb5psyzrrUxBJJuD9ooPoytd7E1hQBxqfAo2ECPBroUiip4spIySvy2jvxxJPmiYOk3gM20PKUhkRpKQk0WQXCMBI'
			$Code &= 'EMQHcT3i+QGcHAVcHhr+GC0aGAUYiMcImeymmJ9V4OpQxwvCKQoBlLcIyLbkq3KeOZMcf45HcitdOGgBwFNRUujhEFhILS7+KFWF'
			$Code &= 'x8OeDgcB+BTBCuEXd8LKBwE5FMt0CyE1sww2RND44vnAFthaWVvDN+iaO2G4ZQaHDUhj0fWtzM1ATBBxHuIDEikNa4svZWDUaW4D'
			$Code &= 'Y29tcGF0wGJsZTkgdp5yc3+4bnw4dWbvFvsG/97cM0Rzdh94Y//kdCB1beWcJnkbZGKVMx9z138/lG0N205DjAtHGRxuZDn59dfP'
			$Code &= 'fIZ0zbthfzvYEDE5LjI4NU+jHZEBuAGtBJEC8gM+RwTIBfo8AYeH6G/yPF+MT1MGBCMHkQjICeQKcgs5DBwNjo+H6AF/IatFB2hX'
			$Code &= 'ECgREpYABwkGCgULBAwCAw0CDgEPRwVFDEy7jAlMicwSLCSsSGyR7CIcRJxcidwSPCS8SHyR/CICRIJCicISIiSiSGKR4iISRJJS'
			$Code &= 'idISMiSySHKR8iIKRIpKicoSKiSqSGqR6iIaRJpaidoSOiS6SHqR+iIGRIZGicYSJiSmSGaR5iIWRJZWidYSNiS2SHaR9iIORI5O'
			$Code &= 'ic4SLiSuSG6R7iIeRJ5eid4SPiS+SH6R/iIBRIFBicESISShSGGR4SIRRJFRidESMSSxSHGR8SIJRIlJickSKSSpSGmR6SIZRJlZ'
			$Code &= 'idkSOSS5SHmR+SIFRIVFicUSJSSlSGWR5SIVRJVVidUSNSS1SHWR9SINRI1Nic0SLSStSG2R7SIdRJ1did0SPSS9SH2R/SoTwugB'
			$Code &= 'zgiTEWQRU10iRdPSJDNdIkWz0iRzXSJF89IkC10iRYvSJEtdIkXL0iQrXSJFq9Ika10iRevSJBtdIkWb0iRbXSJF29IkO10iRbvS'
			$Code &= 'JHtdIkX70iQHXSJFh9IkR10iRcfSJCddIkWn0iRnXSJF59IkF10iRZfSJFddIkXX0iQ3XSJFt9Ikd10iRffSJA9dIkWP0iRPXSJF'
			$Code &= 'z9IkL10iRa/SJG9dIkXv0iQfXSJFn9IkX10iRd/SJD9dIkW/0iR/XSJF/9IrEThAkQkgImBEEFCJMBJwJAhISJEoImhEGFiJOBJ4'
			$Code &= 'JARIRJEkImREFFSJNBJ0JgOFZIMJQ0jDkSMio0Rj44rlBRwFExA3zY3H83yv2ZcIDBIcJAJIEpEKIhpEBhaJDhIeJAFIEZEJIhmB'
			$Code &= 'AhWRCQ0iHUQDE4kLEhskB04XHyUVjAMBAgMEiwWLBiIDB0cIIwmRCvILPkcM8g0/kQ7/Iw/+4cJYN+IT4hTIAxWRFsgX5Bh8GY+R'
			$Code &= 'Gvwbj+Qcf8gd/6QH0kEFByL5UuVSu5RjohCZAREcEo5HEyMU5BV8Fo+RF/IYP5EZ/V+H8hx5msQB82KLBEcBJzn5Cj3diA6RECIU'
			$Code &= 'RBgcyAkgkSgiMEQ4QIlQEmAkcEiAkaAiwFrge6hCh6IGmX8MTHcYpm9TMGcpYF+UwD3fK0FWCVvo2vbyr3gDKEb1CEtDwILYW8N/'
			$Code &= 'U1TjlXJWK6Qv5jHMAZrDHgl7ZbF6JPsYkIXC+S8wbSqn7RweKT3F4mg167YocfRLNS0THPgGw0iNgbwRUrqHAEUxwJBmRIngSJ0O'
			$Code &= 'S4H/ynXziDuwCU1FHhkRpAohE1G4uI8OTImBCRdav+4IyA9mCrwEDo30FuIvOZY+QZsYi4GcJP5NMWPQHNdK2+CRqAuAR40ADBJB'
			$Code &= 'OcEPj4nBm306SWPtTJA0gZkQhOGsEEIPtzAEhwsUn2YCOdByFXUWVl8GhAuklfI48AigCHcD9P9SwTrZY58LCEx1Elk4SAd28ZRa'
			$Code &= 'wocF0UUByRCqM5GbkImEjneRS0KJWZ5855oKE8HUSsMLU2iFdyTqgwRVVlfonDAYHEIQTOga7HKfjyWYFGNQExgx27HH55tsCnON'
			$Code &= 'uYjZShGZCEgw3dqeFDyzEnjtBKzDuchkQRK9PQIgPkwkQBjzZqvGgKCrlTwOjFBoZkhBTh2LAnmomBWdh11jMEw56A8wjapxSSnF'
			$Code &= 'wZZkJFBN+aRQK0QB65J6Zkh0LAry78buHK1Kpkk2RBuCDDtMg0gwew050X4F1tfRwmZD7kx/MDv1f2SowcMYyQrS/4RAqUU7HrQK'
			$Code &= 'fAzEIo/qKR7PRYvYv4c8G50H5wmDr8e5AYAi+gJNhfZ0E4NbMwIp7sgYEQQJSYPE8KQJzQ+FdipQI5RI6UWioQryKQCqEQSF0g+E'
			$Code &= 'sxIBjY1K/70ywUGyhP2DvEgnCQO5kP/9UJMSIUCNdO8f9OoCxCQBrDY3gauKFiZAQ1CExqh/uUww20UQdFuQkqaI8JRApBkCdEVJ'
			$Code &= 'jbyYRrQSY0f8Ca7voMjLOfB/SCqhS5JNREMXn+HQdBokFSkmwUNFlIvOIMhwiIhmRySJVH0k9jCKdcNBmv1gpnzEGF9eJl1b5FF8'
			$Code &= 'BmQEegKDy/+EQvm7LI2bHUQHSwWF8HUJuIrhBhuiD0H6QfaQ52ZFBYlEkwZITv+I8UvH7dRM+IBlssIKmdeKkzseiY59BIH6dGtF'
			$Code &= '5crlC2B2ASyUkYRC6y+hxRU52tAIZpCjixIUEIHkGUwVH4P6zH8JH+iEZAcT7FGMQYsShAsaoWcD6xiyrh8GmJNI/f9CngeaC9QG'
			$Code &= 'qLFAyHWKTvmK1hjhIFahlXIxOxne3qjc4hTJzjXYbQ/+dbVdfCdOA2jXiC5BBZZmbHTziJcgoNxjAf3Qagam4Gf+lHUK4EcIRPeB'
			$Code &= '/uQEYnYmyscRsDBFNpy5pqq3QOWJFEAXuLEUBUQp2IGWfmeEOYS5pDFRKCQjwA9m0+BJfJ0Q/h0JgXRZ1ORDCIgECn3OUigmZCYR'
			$Code &= 'UCdBF92RRFUTHjBtQo1EPRrwsdGC0+glkBU9Hx1rZzS/ZltSJAQZ9L9oSEAoIERV6VUBuevND8HEMEg2Mt8SpZfB/oy+isgiiZnm'
			$Code &= 'naSUZnVpPxpTH6NbpFrENaKmiwGD+A5+Y02LMBT9pYd2ypDyhfDpO1wCPcPqA42vr68isnkOMkwcD4/SATHRmeryRSBk6Gq3+PZD'
			$Code &= 'Dasj8+IbARbn9QInCiHucewarOyPYQl+YBz1hX5H94TrFIgHC4EHkC3iFQmRWUaCXQ16SvsIAwpQ6xa41sgdBkuEXgg2FfiDSsUI'
			$Code &= 'XcwI+PolpAog8kZ1nAaubIsoXtvDRIMZFMs2k0GJ5UTxx/jWgw/5C35bQY2S//6LhItTkUPCFnpQS+8JUoOVQdreuO3/Q2woRSER'
			$Code &= 'ig0iKdmTRk00hegQ9cvqQdKTdjpioMa62qUaZinQsRpUA/gFicyKbUCAV6B5/8iTa6N89kTog4Z9ERSNQP917Awiflig4UP8r3bx'
			$Code &= '9Auaqhx2RgQBRYXbD46ehGfo1OqQrY0ITRyJ2otTFGJQAUKHYX5dbw9/hDKW6euFl1RH88wVoJSqXGt7MrDiqJMRSWzic1bKoUhG'
			$Code &= 'P21BIAtGtwXGk+XSICzZFOhV+BMhRwiwCWkRWDBtsic4gK0gX+kzoiJCVNqazyyBuQ9J9cpo/T8UUhaI6JRFpRcB/4nBApPAePFP'
			$Code &= 'ChdtiDnreUW85kiIMLzB6PNo8J7aNVakL4J4wICB+pUgSXIJwep7B1DCC1AU6MjuJAsMEFhCxygom0mDdIrwErsxwKjCPTnQaA98'
			$Code &= 'lC/DUxo/cDoXMDHtiSNDd8YqHtekBY1dEDmpRCiEh6ifWyVMtTsyLSc4pWJAgobtwdGCSdP56ebAawJGtuUMKP4n6Ij/xZCvGrYc'
			$Code &= 'Ae+y3vSrFo2QdmPTiTHYRFOXAnDVyIljnxsEck5ScZ9kSiKCO8QsQolSCIKMRkojkjU8FnxIzwpyITrppAJ8m42XtRlWZc7k6YzC'
			$Code &= 'Meil70IqBba2xBODlYStiIeJYcJYdIcCQaMp8FKcXxd6BJsyfOtXEpjQlz0xaDYzKMQgauYFRosEoFj8to6IFBQR/u8QKxxICFRE'
			$Code &= 'KVTAoluunUjDOarIAsTrSJpPO5ny40krAZAkCdGc2mRAQYH5mWoKcw6UCFzsE0JBbQhY6xcuhE2BoQcFRBuIq0FC7Gg0n4V0jgL8'
			$Code &= 'S0kM1F2iRySePrETQ0VfP14Qk+XImNEnDAxCmPeoXUTpSIpZ4RyKjQs7qht06aL8RY/zuDpsIBCab7FVpJKLnwIq90zr5NZESDCi'
			$Code &= 'tHMlM0WPhEZFi/iAjlIQrsCFvE/0pmg2vSG5aC/tMQ++cUTTGmXwSstsvxbKqodlJlbxGV3FoTukshwMK+S1L1vDib1gubh/uIFO'
			$Code &= '85kT9fbwAXQOBmaDOAB1UEj/wpeh40HR6IMO+h9+5CcsuWR8N3U5FehkL0jwZCW7I5xJEIw8AURAE4HBCd5smiV86lBal5MqthKA'
			$Code &= 'h8j/HcrR6cGD4AFECa7kXQx/7M7DT4skTVKWuA4TdT7YtEQSi0EoCU9RGgZwnpy7cUgdtC2m5opB+zivzMOGCCl8Li2QEPQ0PPIH'
			$Code &= 'KoMzV/g0Q4DCCH4fiHk96IBaGEDrDJinK34WXTTRbY0ZUh2VONPTiM5FnWTjuc8Ey+iMsL5BJMeDkidmYpWkq1OC9UskQ7hFNcvk'
			$Code &= 'xK2xIOP6U6ATZsHpCBGIDAKkkQX20V4UYXRm99FLLUvgjRnKUgcgRUtmpiyhn8cvwojnETA4GJO3FzvHUpGQp3tLQMAl6DPsny9k'
			$Code &= 'jVAZO2YeHURY6FJWGiNoCKQKZHAicTGAFVUQD5UOhul9N0lTDSdAQ2QMbEQkIlDLWEneWwJH2UG6ZCJMS7gTUEmgkEQ8A1ymIOEP'
			$Code &= 'AdtJRgFBVB5JMIcPBH7jTGPSgSh4KToSauGJUzIXPRJMBiCNQQHKYUQQ6J/9pbqDzASLE4LBTaDb16ncQC8pnisij3QJWpQcIEFU'
			$Code &= 'nVUWVslkOhmtCDJsx2O8YBSn4QiDzVK9z0GqkT5UDhFOlGrpklC11Z1kHUjRqwrkfjqgADkUjnQi/1CHJUhVYweZOMUGhO52fUGI'
			$Code &= 'lDk+RmbrBlILiVSOAioQeADATDnhfMYog78soZ2+SO59f1J7/eoGA//FienrA0O5UN/VjExOWDc2NIbIqThC/492c2DJdAxBiIEC'
			$Code &= 'JymHamwYWHyuColqCItAgZkp0NH4MXEAqvB8FZiOUNjV8sIG+ehs1CeYyyrzffOUtJdviZ/6ZIDe8IsojJdyG41C/1v6j40WZ+6p'
			$Code &= 'TggKOQqPoDGhGyCngQ5N+cycSsqUnK3RIZo0HMG4+h2OZgMSniebmfiHQjtiEIw5EDjIwxTAcwMdCsH+6oLS3wr7hBqi9RRklgIG'
			$Code &= 'O55lCqdijfJAR8ToW6kRk+/DD4035SiXTKR2gv0PK6KJ6kJOjRboZOvXw8nyAdksiPEy+CVAL6eSksVQ+oZYWAeHQV4nXUNc6ZL9'
			$Code &= 'bKRcIAY7gczey5FmYZi2LRPtoj+BYJIWZA5w6NonGUb5YZJ1QbsSvVuYnd9VidqcciDDFoO8i9fMB3XLWDSBwcuAuPoDfeVDjRhM'
			$Code &= 'WxFG2AFwi5SXZCCklsq+8WwS07xlklzK871tZKSiNcwPHeG8YCUU81q5zcw/CZLRbDot6T/Cn8fBIZ5lu70lQLq/0rKadEKyKUuM'
			$Code &= 'RBA9LJarJNj4Ip+cMT9GRK/rly941qCN266OqiwebfB+RkzsRKVuZPciB5z6mCdB+S3Wmg5ZOQEpyIPACy4Sbg5z8hXsiFZNmjmP'
			$Code &= '+iT5mcnj6vxzDiQa45dOdproSszpXZ4Y6MSnPUZnQCXXXfKySs/bY0QPJVYGnWJPDhFe+D7HIgyVqc1HOa5d2kYogZ3PKN92vruW'
			$Code &= '1VY2HmyYrGt+WgBMixFBg3pIAgZ1Ceh996M+iUJKgapACwzoLFX6SU/qWA9kRiYRIHL8WIsj3ZeTMejBCs3Cz3d48Ol7A3PqAznK'
			$Code &= 'dwjrBPiNUAWjrqtGz/fI8BtIhe0zdBZC+Z3IT+qhRKUQ6VEBy3u7UmQNBA+EsQ+ydhCpKVDYk72lamZUQBIEss//ddKps2XLA49E'
			$Code &= 'UJpwxGC3iLmlswzAwsJW3GHo9e4Fh7HJxG6VGN7pi6epRAI68gI2jJEKUOh835JImgnt2hClEFiRVglO8TCiqeSBhex0BfK4v4kK'
			$Code &= 'W3ERbFxcJkAlUXzt0Dl9J9gkjOAh6EH90CtOt/C4G/iLKbmg4AqxtAYTQQYomaQTEjn3fAHi6wL/y9TjEFoJDaG4Kad/+PY1kZwX'
			$Code &= 'rEB6Jw9NAZJUJMiOZFFQZqmULQ5NjSwqkuAB93PdGIPlA5hELSAGAQwx/ynFbpmgZQ9OBO9LjTQT8HIhvpQKXAuyjnlgeoh4uX47'
			$Code &= 'WjDCzpqCXCHQXD8MBEfI6O6GYnCDgepVLyKHiGTIISkKdHUleUsPIT/EUGwmh5AasHWR61MpJ87/EOPzhCnxheJY6vhH+XoeZtpb'
			$Code &= 'FyX5wEDLAki6+P7/UwFJ8LQ1CNixLLwNoAgPGDIUMgk6h+MEjo4znhZ1w6tE0wh1FvfX4hiEDBAnX5omYVQY2NjraHsRDDovqUij'
			$Code &= 'dRvvR1Z2DSVaBLDwIJgYfcBmBxAQIRkCLAEM0jWfg6xMKcg9/t12fbDqEth/ESVeKVQ/yLxBnoQ5lYGYyTw7SKs5fbJKQhDQwxVc'
			$Code &= 'CP8nxP3+SrtFISqdi6TjxMPC4k7+ckTYItBkXkLgJehJhPDXHBX4w14gz2VmJ2F0XxPoQZ+AQ29weXJpGWdodCA5x/gtMjDvy9BK'
			$Code &= 'ZWF6bg9sb3VwT0cvaR5defMeZNtN2XJr5UHj/PoS2wLjU+hFceUewxYKyMtDeQgqsQsJZBgJKEE46F8PVxHIkVgyaAl4AoOIrjn0'
			$Code &= 'uIJbWMN3vLIjc10ZBAUIigkjXxDJds2UCBCyBlcOXFQQty1BigTiYhBNVPqoIBBxgMOUPCCKQjQyEAoOUZQEEKYcyCEQUtkW2ua/'
			$Code &= 'Zscc1gY8zUW8xM7BKoTzFQZ1WSgaQNvmhL8ktd1Ai0Msg/hkAhjRVq2DPwoJewgqhZ7CXA8BdAuLSUxwJ9CAiUXwg+wDFQ+CpTRI'
			$Code &= 'JwfHdgopRkG+5PgXSAHGTZxQ1mQW8hfow6sjQkP/PpXLSQwUo5QHiISsyh4QTFNwDEAEAdPiMcKwYSP8fFxBXzP9dsopMZA3Tz+T'
			$Code &= 'TLBGRDMQAiRw0SHSKB+LYOBUQTFhwEtoRCPRfLSmNqtHVEBmno1RPPKLGIcFDIlAjEU5GOF2slbrBT64/tzQuSWG+tksCVzDIxx0'
			$Code &= 'Fnoikhh5wAUNg3gsAoQdCcVQj2/KwzunqM4kGDRgeSjh3S1EK/NlJYknduFlkKLqSxikHP/J6EVeIUnoiEp5OkIGPypwKEkoCVgh'
			$Code &= 'sDwkiYmRtBgTgaiLIgyk21we0rgoNWCNQj9EyQgHBV/Tg6sGtggCAwHQRY1UYm+ZzMYTTCijTQ1EuUGBLJS7fIJ0YmIJCEHcuULr'
			$Code &= 'b4OYUTAkGBLuwnRggsR6EAIIRIWuGK4KnBSUCEogRQ2sDkoXuoLghOEb85AtMLmQdDwwH20C6xnJ3IEQ0/fYe0X/jCTgBC0GPusD'
			$Code &= 'sDEbeUgPMnUmD3gFH+E6kAbZB9jB6g4y6RmHxAzzAcKSyonJcP8LGAfDQ4V2EMQaD+QGUvMie4JwrMFSCEWIDMJchiMWv6gUD1vD'
			$Code &= 'y1JrKiX3UZPOztN6tMCHD0f4lro64iZSIFzFt4z7ERcw3PvoXTn7SJwlXmEbRrxcHlggx34cKTUYUg4nEsZ4EXxOkdkIdQimRbot'
			$Code &= 'IGVoi8NTe78pdL9V8icoZBq2JNJtMFeJ9IEUKnQxnQpFUCw9SSAnf1tAImf+HYFx/BiB/pq8aD6mEIjlfKNzIFv2UEgQlIoHs4RA'
			$Code &= '/1PVmZafKEdoIUvkYC9xjzpFFQuxaaLvaDC4/eVMiVuQSXIPSdiGQnhGiEaDVCYYUlbkyNKRAULtPLrCInJA9q3TG+4RQvPBOOjj'
			$Code &= 'p0nKoN4lxDMgFxr0C9cqcRsBdRONR/xEf0mVXOY6KV7DJCVEu1vBiRh0jOhhnI+LV0SUGB9NZ0gCCki0JyYMMitHUNYyKXQWQmCC'
			$Code &= 'l/AWhX8EIhdoOzcOT2z2xSVTEMoo4R8cg39gMhbWMWgSyxKRycIRi0dHhUJWUMNvFZboB5V+pBHO00+ATQHA6PNUphR0iWgXSETf'
			$Code &= 'YhgkEF0N6M4jJVkgnI+kl/Qr9T8MYV8IAVTYiiDmyO0+EoUK9kWqlofysGTYS8ORwX4mlZuVveJAaRx5m4WP6BZIFVjJeZa/Qlj9'
			$Code &= 'lUBSYaT0wU9A/bi8IzsX69wt9B0fbdqkgsUI8dQQzzzAPsbYPy/wwfkSp7a+8Swp8EjNXyX4z+zA4PkBdanuF0LwTPCXGeg6ytsT'
			$Code &= 'hCoCdRE4GIoP8noj2bof6QLz6LOlxIZyHyV3DBaI1jiaWkqdnajQVSZRdI+oYxv/yjGS+1ge92hmCzxQpA50D0mX4LUxSNKCjG6t'
			$Code &= 'TBZjm6yyaRhP+MeNCGRYMtu+QMLZAomDqJfmKXwEyBa0zS72BbhjDAbhu4QWDEScxyeDoHM2MhSIOyRYpJxiu5CCDXtwVDBY6U9L'
			$Code &= '941SWlUQWUQmz95pC5quHsR3WNFIK7dAX42MA0n6lAEp1jnKcm0yoixJj4CNFBnomKSZW0kCwSmfenzIDJRkhExKRkCgq0L+wMDq'
			$Code &= 'AjnYcjoEKTzrShRlAlERQ3TmPGlgMdqODFiRSEEh6eo9NUYOrOds3koPuN9NCPIi44GZnAiHomKQngHC5gNIVz0Q3f17UYcbAouP'
			$Code &= '0bIo1BQDci0om4JkRCyAV6B8BJWAs0dwQdMU4P/ADUsBjEQjR3xRFIH5eaMYcw1gB4NpeOMIU/GxchgXIwoFOfFzZTB4jRwB/Nn8'
			$Code &= 'KeLeW7hSKh+5U8ZQgYhRFCqUg4FAl6MDRDJIHqqfgzzrLuKDgCg5wXMkOSnLKs415sP+84HeCgjY6GKVATBNH8lctsmezclR5npQ'
			$Code &= 'S1q+U+cfEEnA+6B4OfAPQucweYv8nLQNYncWxFwgEP6EE7E0EOWf5KFCAYNG6ooGyT8xNk0WdAVFWXJNvPBBxRcbajtByXgJlJrK'
			$Code &= 'tg5TUOuYEvpBLSnICABfCX3wkQabJm83C2qqXAroDLSsRAAbQTl7GHRSXnApRGsnjX17fBSaPAKRgk6s3b0IpV2hWpAj7LJC+NSo'
			$Code &= 'NBF7xfzz8qSsgzLl5ISb9yG9wmiI6Vif8P2XD2iKwY8UwG8QtO/oQ4cJdQ9Ex95tR0T4iSLriN5RQrkDsBTB6VVzj0+w0/XvSbRp'
			$Code &= '1z7LpLy3Sqo8OL1qh53EPcyDJaSKSl4QChXiCFrJJNQCwcbnEaLc0MpTkKkuQ1261rQuU2AEjUkCyOoByy5wZoq0e2ks7CRMtneF'
			$Code &= 'SSHBt3p0tSYOSTGEQGZEaUg8zKVgOhT1mm9oEJoqBChB4LIi1VLBxCnRjcAg2HdSDrAQn/BeN4RVuxEGnSly2DjKsr5DRm6i8tI9'
			$Code &= 'ZuJW8acgplGTK7IeuEiTKSJD6CeA6uAQAeA6iBQU/4MXYlLCUf4+iArSQQQIWSuFCLzZS6bxAkU56HMOgh/kzxAMCFHru5QaBxIh'
			$Code &= '0ouMCPl/EmMU5vpBOimlZNLwVgqKOWG/U7pJCRLCKTJ0O1F+D3d4tjUQg0xvRlLdeOyUkXNfH1NkXtMkJFHuIGALdZ7pkz6Y18WZ'
			$Code &= 'UzCeiLnHxEN9eE/F614plwSiWu48ikNaWfgW1Ek8a+UtZFEZk7zCFSkTIJpSnPrLRUpmWqqbV9JsvJpTFuhk7DpQFvP0PL8CQv2W'
			$Code &= 'sw3XldysBkzDTL+qI/5C9esdOqH0Wf4LyP5dOjtWSiR30biJ1GLGIb8TviBgRI1vbwIGNmi1JqSVLJT4yvEJehS7RCy7y+ah+cuW'
			$Code &= '+CLOcmnFyt7TfijJRN475mz79DdrG4UogqsN7fmgFILljCv8O4VaO4uIA3NYUvG0wvLBFGU9asIh26rsYvXA+AV3JzlPq9HYdBhR'
			$Code &= 'zXUaJqNN6Ys9XLiKdgdrbTSs1sDl1BFQQXw0h8gZNW0WLmQeFChXCVwB/bq+KcxQnsiojKTGrCrpwlDFQ8kc2LBJXPhAocrNDpIL'
			$Code &= 'GfCwQKTLhUKSyzYuif4/W4qgxSxhiehAMIvGUSnIDL+NHkH+iVagLTlC2JMSwKzad0hO6JThmiiKr+UQSogMJcY2os6U5aHbI9x8'
			$Code &= 'TU8hx1vpGeJKCEG5OdGgCJjS0ctiE4X2NJTx/E7jSG0sYLnUmkCWcceyKHQhQfHiGv0UQlAhWBBghUFf7LzTCrY5eLXipd1jkYX/'
			$Code &= 'ycqQrHVcQHm+EOvn6Hpf8ElXAzIqzNcqOXjSIEj8lXnmIRrKNRGQGuksOTDPdEWvy/qyjs/S7n5X/GjTIqfJYrHv59OhMgtE/YJG'
			$Code &= '6WfQ6C+4AxMCZCgm6MGT6VSnJ21mawnIxI2yuA1Q6KzKq+ggWFlEgJKrC4ECkbApSIfPQvNDGNOIkhqKXZEwLuZboJZBMtrJWcBI'
			$Code &= 'Hhy7IEtMC8hBXN+FtlQCrCR/2QoXBOw5wpCAm+8/1AyQjKAVg8HpQhCAIE+NjArR6Bh2nQzPLnVSUguIR3E8DiExxCY4G4cQEOEF'
			$Code &= 'TNTJclyj4HUvjYES08aRtgMssqc00yRyfuDJzLil+JMsyr6Tj7pL9AogmgNci3GWCyPHk1InyPm3iatJJAWnCY7FDgnrXJx/m0jW'
			$Code &= '0fBqmr1Z2elyaycD/hfY4ozkHQgb7Xm2C0+PuZLP2qIbl3GJquzN2keG+cXVJgZCdP8WnbqFRvmYAFo5IeN1FEFm6fD+mhBeWSy7'
			$Code &= '2rqStXfKXqzFc7qcUaJqiFiFevcolqoQHOPoq0PryTRRB+nxAkt8ExLqPmnEsuI6EEHr4h02j3EiENE7E08tXpNYwaIr1IBPj5gh'
			$Code &= 'qZF5IP9CnD6DpDCBlJELiDiRhh/HQWfGQcOwMDH2sXEcmwYMGr6OH4tHEJp3fHSmMhQsgOZ5BffY3hh+Pk8YuiphuHGb3RZF4KzA'
			$Code &= '5NLJNAjS8EgJVxboL/wBGesHEzMQiUNMl2hkd0D8eEzbKp78GijuESTFMJlVHd86KZo/cmJVbExA1c+mzi1iCOemGFUbg/p5BTyH'
			$Code &= 'TNPMIhBUNgs54HVLCsjYhXUmiUPpPWpQZphmXAQmRRObOhgenpQUBWq7kIFBILj7P2L4X9+L6/K0+QloMCVr+MZ75HZT0kq4GFuB'
			$Code &= '98YCEXss2yIUHYb2iOVBt4lHIMRLTSjPAxDGBAEf/390Dqeo2QgWVvYwZEQnTaHAzlZowBBFiCRSASqKRA53pHERrGgppgAJdQWN'
			$Code &= 'UPkl6xZxCYQCfQjDaOJiLBAFutQNoTSmS6OVZAtJxwop0EPp4vW9syZAeSjsYEEOPBjSgDbiEBYleyB7yVDh98pUSA4QhEMIQAoE'
			$Code &= 'gEU5DiAPlcAKwlQUQWLIU0kkxEuwE0BKBLG0HxUhBdEGGQYSHWkHO1Tf6OndoUiQDOQ1FaEmQI05YBB+dMo/GBwguSkECB20XAoW'
			$Code &= 'GTJTQ1w2YWQ8dA+JFFMQ+NgS6EO1Nv78JGM4Q5BFip+Badh2/sES4QyBvlwQKaZBJYuTScIhjOx8GsIKBn0Hxsg26xEZhEngQFvT'
			$Code &= 'RQM+F8GdBgk11OwggXQDg8kwpYUSEEIIcKX34Slx0RfpAcpAVsHqBP/CBGvSH+jT/xHCMJP46gZXTujBJdATozS4E4qtEKG017DH'
			$Code &= 'RYHLNnwkMARLcbm1YAoIRPqBOUM4c3EHhzs7hZY6LPUdxgzRdkDQ+qEu0u+t4U/IIgMpQFQm20Zz19lvMsqIdXQvbCA41lPi1VJi'
			$Code &= 'TgmaETtnJAY4nGe3Yxg5FUpyj2nJHhJsQFHQdm0VwdvtKe6BcOjWs2tlQlGfNBJ1C3J5SSjVu9zFikDaELXiIASgUNVTwXR0O6HS'
			$Code &= 'OAsZGUHLFBeNxBjU6Clys85kpf8RuDV8UMI4dFUpyyanTA5IpxM0CLyZZzbBKsZgEECINJltLWAwl+tOBeL9R2YoG0WBahIZEmgK'
			$Code &= 'M0JgxMhbzvS/IbHOn4iEnH0Is7JY5uSNbpCqxEuyKAepu2cZ3nmLCnVfO+ZOdZLTxf12CCKTUyktIPQBE3c3RoaEkCuZY8m7oiYv'
			$Code &= 'TbGhFCS3Yt2xGm4AxbZjKBDOUCIDyRxnBhQrNntAnKhJXDmQSIlQTtPDQwh1CgkM7X8F+Er0EJYUURhCGnRaCyFftRFHheu8SDIc'
			$Code &= 'E6PIwRMkhe2FEeJFNpEW11iKIrCXxH6ydqAE6Plk9nMluaBiGOfzKwc6Y+t5gojN3wBMjUAIWEhbAYOiFKZjKnQFKonQmi9hrmoB'
			$Code &= 'BjPIEmFvwXV0OcVGtb8Z6FzYnVRAugV0T560JsloFwix1zYqikg6MSV0Wt/fLNLJ4a0F/FmuI0t6Vg/0DWGf4ooUykoO5nLUQoTB'
			$Code &= '4mbyKLr+UZYlJa2KgCqCNX9gI0X9KOmrGCD5Ak2KiJS1lbO2I0JNok4VEE+oDIVEDSohDlOcOW+VQoXkIQja4XfnPNHPM1/vUBEE'
			$Code &= 'W1ss8ON+HQdB92jt0hgkMvCLxMEY4Onb/VzyhW/PFe3DCyQCRU+zYg3+Hhroxt0acImfxUyJhCRSNp9m3cmaz9wAR0WF9fwxhEcC'
			$Code &= 'A4A4MTCwPhODvCS22JlYHDAWQD3JdUvEuPp0hhNd+JFKgy5gM4JRsDmjMHpAFI0FWYbfVUCKTad0YjgmDUoSY331oehGnjuYr5Vk'
			$Code &= 'wcoe6OEIyXkggxL33+uwqvnofn0JW70gQe8QRL4OE3DQy1hBjUhHvgL4CA+HonXGi8QUhZhbLNQIBxGMZq4JEv0WbMlieFngP7V0'
			$Code &= 'H/03SvDLuEoJosyQ8iXyJmFQ+kr4otcpxviUQSx8uWgMaCwQGPR4koZbRfXg/TDf+/HUwkQCXQgNiBJPofQhnaQQmDueTniSRoDY'
			$Code &= '8NPgGYPBAhZ0ax0EQ3y4q6oHAvfh0erDloCFNX6GHdHyVvFGRaxKRqL1hVZ0MhJgOyC/Bl6ulujaZuYzaENhBCS28BZYS/KJSdnD'
			$Code &= 'rDkCFIYXDY0MhdEwxU4BGEw5blB0Y50NYJFdPmgWV024WSVSWJM00eiqycZ/DJZDhqax9QXGRjzSzIZVHqz8jn7ohJCOLXf0mdxQ'
			$Code &= 'cocgWKrhtPQsx0bxaSJw5bAR2SQ4IBLor9+poMjEbu/C0+gdf6c5L89TIItdxglO+T0vyREc2Hjq8ssmg4KeIQJaB+sRVcmBuVUS'
			$Code &= 'BeaPsPZgFoenNf/sEVifLy4gl40oWDtRtx5h9z/X/ghN6mE/sAbCi0TFofE51c3UdBZ3RTtBDAwQugVBTMX26FhS7gKBwDmfgzF0'
			$Code &= 'ONeKOUTTGOq3TEjV2xOPqMhVRPfD2Ye0TAsEgbgcBoGkwvyaz3V/XrGOe32jChBMnOYqowXMC0zcG7vheEG5DxUe8gz5xxwo4T6m'
			$Code &= 'BTAIEeg5/KsznfnqyQPUmUQGvonVINkK4AvgDaOLgxGCE32HghsHHwcjBysHMwc7B0MHUwdjBHOHLgejB8MH4wICAXVtWbhWAogR'
			$Code &= '5BJyEzkUHBWOzVRJngpHaaoIDpLFB0yODYMZ4CHgMZjE4GHggeDB4AHj22cG9gOHBKcGxwjnDPcQ9xjnIOcw50DlYC+ORYIdfhh2'
			$Code &= 'FsgFF5EYIhlEGhuJHBIdJEBJTClKUDZMVGNgEwhVU1a3M5InJuXWahKA8qE+5CbOJgl9qF8axIC9xE2JzZXywLXoMMB0axdUQRXC'
			$Code &= 'py7U4oUCZv+CsahdST/vILdVEmBBuiadeD5Fxq4aXQvO/3RbByB1DeMB8hlW6AIi+uRz7cwk06ZHYNqU0nUtSSSLTb49KFDh4cPW'
			$Code &= 'DneJPkmD8FEEFQwLx5GKpP0L6YBy4H27tRj7dhbKw6pblwwSYUYfwAIsGNNy7iLbv1MBsjxCnIn6jl2Er9Dywi9MgKApz3gV9MLf'
			$Code &= '/kt27AI1fhJczxQGjZ2dCFPI6xqTuemeeLukGGXKFOG6ZA6LkNG0KapM4gPKEsjivDSJEAzn6ErnkQYbLVJAWKpoqYci9lihUAJp'
			$Code &= 'yLVA+TxJ1BoW2bbHPpZcQO5yb9pU42iJ8VjxwCTJQQno7GCIg8q6FD5FmCcn5FryoD3rMrJHL7rcJUItAuo6Ih96/SgPzEoNbEwN'
			$Code &= 'CZiXWb8ETYt9rhI7iKHTeeYqVYCcv2FFRUTDTMqISpDP7ECEdYzuIM2B/lSo6HMPJ+sapsQVHmJQp3IN+ZQM6RwZi5AwtrAZw3TJ'
			$Code &= 'zCjgH4hFUW3o8jnQLn0GfhxQA+sifhovIwxDA23+TDKZQlAXmEIk64QiYOtJudncEsT6gSnhZpD+UiVQjQ4w97Sg/+qYBalARSFL'
			$Code &= 'gxoEl3X0sY1LROwwueKF15CPMdHqDHX6KoIbDN2AsSH4McnuPBoC6wQOXQqeZRiIhti6vaki1tIEZgFUhtAgxCh1HZT1rsRx/BSU'
			$Code &= 'XkWOzUNJom4W3hrXdgkUApGAQWAUD4afarkB35Ah+2+GKmRrEx3QPaEm2U2AuWAMZYRN3reimyOryUfRBAxGk7YJ0HMZQrE8ykGW'
			$Code &= 'fg2a9MD7w+sUM3LnkxJtjFpbXbl7Qd31Am1GaXwJJIH9akLrDERoag0daUcP1JOJ5wLLWKiUr8QBgAjeRIg1DJgVUHvmj0LHXLDM'
			$Code &= 'HglOTMQQk3LBW4CBrESx2Olk2XlrWCKgVWyo8qGgX01SkqWdQ/GlXcxaFjwE3/gJ8AlACxThg8yCBtuIXVFKgap+kBJIFH5wlHqU'
			$Code &= 'dOgOilI3sI8zxwEkrzBsjPrgAknVVFULYIkYymhqH8EexAluZ51nW2nci0X4uQcn8KR/6OlKPeBnKdj7ViRnXPTIGQdoOERZcyXE'
			$Code &= '3m5T7qLl6RiTClTz1jZAFFaSW8weUBNYnpu5dcIxaPxJXWE0BYUK8XUowIPggPsDIHdOrYjZw8NbmsDfCcLrakBB3xIsW2FJIhIj'
			$Code &= 'hihGDIBJIdBCizhEhQSI4SjjlAvuDcggTz+C/KqVGhQGFxLrpw4rxn6e7p+IkqjgLsWIgOHwdBISKMsSDBsJqKPIanBf9xnGkOhL'
			$Code &= 'b4FDiwSDkIbHIO+EW4RKR5khUFjHSZ1KKIROK7HVR8iBD4KMOCKM8Sj+OUwpgNH5cxLzZqULigaIB9zwKF8TxukCWsYlAgv3/gsP'
			$Code &= 'z/MLfLwGsHx8MHS1b4pH/zKIxG0FrDFSq33pyU2ocC9F0gp8CUQB8BAA6fumHkfMxfhBRsrpMdswicFSJFz3U9mdIa8GAfmD3nBg'
			$Code &= 'J3Ue5KaSsqMPLPTwcgbOdmUaK/OkugzrWW9gDDnBdjVLXDZIA1VRkOByzmHBWznIds6oLEIkFJlgIyhLPTwcK4sxoS8UCh6kGpIU'
			$Code &= 'mQD9AKggdE8KHQhRARTrJgohAhAciANEEiIEEQgJIu5L7MmiIGmqWDkTWdQ/BEySiQi5rvgI8LTgkOhI3p/hLVO+ksj/fBFV9o3J'
			$Code &= 'SqnBR6BppJlWETrCsgiDplXnO0LLP9CnUfJyXPo3zynOTfzxNEXvjEpBEBH3ygjB5zQGwNr/jYpY/vOKAQ0WB6GQmTozDDQDN32o'
			$Code &= 'bzgozQ+q/UCTZyfoJma2Ly1EWBfIEWCTH7ydW1Zwx2rGOxhCbIE/QfbCIIAiukZ9AlrRoUSdLIMpm6bqGsCNCFAiCnXexgFN1+gf'
			$Code &= '/CpEW11LgtDzQrwEtfvuBN/o6ow2QwkgxwcdGWjobl2cXJIgwEMDSA9FwaUelggZTBQLFYbbuLBJWuesGFqoWNP6CeUDCwv0KgaN'
			$Code &= 'BNUh4eXBkvYDwsBNrsmJ92LB1Us0JJJLVBQhklmDUSGlVoblBrZkCB0HpBwFvZBiQxjMHidaW3oQkA7MFC8MRMYaeyCaXNybLVkY'
			$Code &= 'LWluHXZhbGf0oI9zdD8PY2U9nG9+vWY8cj9ifXBrU1gltzdv3rUd5ggZdGVyFC/zsW5n6WhPIxVgB8UZCFAJEMEU4XPAEgdmHxlw'
			$Code &= 'CUAwCXDAGRAHChlgmQkgIaA/pkAzgAlAMiHgQQYkWEgYnJAEEwc7SHiRODjQHBEHokRoKImwtxGDxogJZkgh8IFEBFSK0Abw48iB'
			$Code &= 'K5F0IjREyA2JZBIkJKhQMCKEZkQh6IH7ElwmHCFQmMQHZlMZfAllPCHYSNAXkWwiLGa4EQwJRIxMzCH4gQOJUhISpICjSCORciIy'
			$Code &= 'RMQLiWISIiSkSAKRgiJCReTGJFpIGpGUIkNEejqJ1BITJGpIKpG0IgpEikqJ9BIFJFZOFg9AHCJEM3aJNhLMJA9IZpEmIqxEBoaJ'
			$Code &= 'RhLsLrEiXkQenIljEn4kPkjckRsibkQuvIkOEo4kTk78E2IAUSQRkgCDbgBEcTGJwhxhiSESoiQBSIGRQSPikVkiGUeSInlEOdKO'
			$Code &= 'RGkpibIXWJGJIklH8iJVvHQoXE0BAIh1kTUjypFlIiVEqgWJhRJFJOpyXSQdSJrkfUg9kdrIbZEtIrqBUI0STST63QACNBNJAMM3'
			$Code &= 'ACJzRDPGjkRjI4mmFAgwg5lDIeY3ACJbRBuWjkR7O4nWHGuJKxK2KFARiyJLTfYAyFeQF/J3JDdIzuRnSCeRrkBwh4lHEu5uAERf'
			$Code &= 'H4meHH+JPxLeOW8SLyS+UFAij0RP/uF3AOLBPkehyOH5kR8j0eSxfPGP5Ml8qY+R6fKZPkfZyLn5+R/IxfmlHyPl5JV81Y+RtfL1'
			$Code &= 'P5HN8q0+R+3InfndHyO95P1/I8Pko3zjj5GT8tM+R7PI8/5Hy8ir+esfI5vk23y7j5H7/MePkafy5z5Hl8jX+bcfI/f5zx8jr+Tv'
			$Code &= 'fJ+Pkd/yvz5O/4qZJAXXGhcIj38SDa8bEP+3ypcYGRAEFfkg5x3NEEBAA/cYHxACFCYHGBwQIBL5mu4aEEO15MILQKzCQALfgSJC'
			$Code &= 'GSAYQgcgBkJhIGBCBCADQjEgMEINIAxDwSdZbiCdKxgSZXRnkwb/I0ELhnZwDNv+Yi/GDtqLtSKldGj1Ej5UABNf8F9CcxxlQQcM'
			$Code &= 'uRg9xy9MZBX+AtsuI6MgMwksBjQ/D0CfjYKUBRx3VIAjQmZgCViCecdwFN0lxILYG/vNvZEU3FvVqOt0APnXt+bTGFLOhyd87M3y'
			$Code &= 'c5+SpQ+QwAYx7ffbP+sPANXB/QT/xYMO+jB9A6/j9qCmJPj7uJhvBQqEfhqvZUOrLudnFlf61kMUOeMoqg/1EVhWAcdH0vH0nPGW'
			$Code &= 'bxg8NOj6xIPrvvxx7QSqKKXXgcsrkbyEvhJB3PJFtLo1G6zuOKpGIQ40ki2BL7P0fYt8tltph/JIwmebE+xoWECbupFtgznoQbib'
			$Code &= 'G0oT9OWLYktLQzjceVB1GBWNRvzu2q0ebTlDKK36ZF4KaDjomMW/McdgdA5IQ/K9axezawJE+OvBuPrfng/WdOoOaElp0PGxDekK'
			$Code &= 'N68gcaM73vZSeUk8iiQH2TBIQUDDkIQKEH8sRbMtYZ0U67YcBCB3HonR7DyYbFFEOdPg45j/yMEh2I0UQQFee4rzFujcsTUgTmhF'
			$Code &= 'CYkObAUbgfhY6Mxe/IiBYJkURGwULokgdtJpXvgt6WzOkhp7E7Sy0hR1Ic5F5j7B4tPikj5OSdEwEh+RGQeLKOmgWaMSZBMd4bpv'
			$Code &= 'A/4sdQxvXyIjMNPnq3vwK24Y/60M+qIaOf1y0FUSo15hAvroInF2FwpDLLwAYzTrVit767w0ewDoOe8PR/1IA9lKRMKfUegbcErX'
			$Code &= 'UnQb9RriAzzoTHQ0KuZwPKNbEXYbAXvffZM5rwNJRMSJfxlAMHOwnG/4GDKxPS6L/nxLbOxt36SDyfqG/2o0h/yB9Ltx1KMVBn5J'
			$Code &= 'cY4y9hqWKXT9x4u48XuEIUGLBohDeJWmiHAaJH5EEURo68TkvZYkYLsCbkC5DF+aQl6di1hFVHuSBrj/S8GGSxDccwjMDiMyTZ8D'
			$Code &= 'xVU4uXW8LuIeemO4CH0wDoYeD4dYxek0UBpnVloIg7oMwccGQU/p3yTUg7h0KXMhow1OB0M+CR4k1A8JxwhYdTnOSabEERjFQ3Lf'
			$Code &= 'BPbCAnRH+A8QH4sSdT69pMTwkxMFB1Ww7jTYBZNGGKiGNW0eHuVN6NQ5Aon9DvQYZOUBImUlSe4YYjR+EL/IrQfHSkCyDgJB9kYI'
			$Code &= 'Af7aOFOEMs1s6PVDrJvhdyiXRE969yWJyNxEH+j6YC4Ea8AfdzmQOHCOgz1RJAc8CHQVciUcVt1s0x2ERQTyByhDwe3dDM/8Uuns'
			$Code &= '4XkP+giadVA/kU5NKP+QyJDqQcoQoxToL6uyPl8IlPfVs5maTGAs5VICwXcozQmxVC7O6S2lBFL9UHaGmlYbcIyUM+hWZxXIf6lg'
			$Code &= 'Yu4FN7O4brfCgP389BIyIQ73xWq1YhHX9RoeNS2lC0BO/PJEC5kmL7G/45ZkOEYQMAJnI0SIkIGExqSYyRmxEo2yoMCjkv+RjauX'
			$Code &= 'tKYFFusFCoEgosRMayAgpLaksr2Hq2hKb+U1UIRyQW4VjO8wyohFsdEvhTMYJhAyPbMismYUK8CRgeQDchAwywSTI3oU92UURcXv'
			$Code &= 'ENCRlddf4Wz0SAyRAHyPfxEERTrmJWwsh0SPyRC+bkiRDEUYK3vExpBo60gNTrTBt3gQUooFNGF5c0g58XFIesQgsDhfrC1YLud3'
			$Code &= 'ShBP3SUBUBgpyoIaHI0EE3xWOvwW0esC4cDP3185oOLNAWCaBGhs4JlZE0yJiWLYOeg9u4kFHCneSQEd1oleSIfffkuiiE4DWhDR'
			$Code &= 'Fo5xhREIJHMTRjE7n4h2ikoasZr/x++awJKUX4J3UCBysVIQtT87AShzB4gcEZ9ARiq6eAUKOfdyy4jzKcb4iAi1j8ZEHuYpVf6K'
			$Code &= 'oF6DIssCSTEf95qV5AcpyhQjnAJ5MA8hOH5DIKI2HTe81V24CFxzeIIknQgpAlNIZUqI+gHezTK31geN0HQS6PNZFuex60k2KEjz'
			$Code &= 'pkzB9hDB+Ali63tSPIhcN1jBtcGJZ45FuYq0ZIYLUJy3j/LIBAvnBiAyRbgmKKLN6e3YbZn4CiKQp0RTayAgmmSZ5SCOvVBhOIHh'
			$Code &= 'd89WAVYt33SkJagUyETn+qi2hnEKFJJbDAGEkQ1Oq3JBjQqdRY0etk+hKWs2sRJABrykQpgTKHQWmchFGkPhB9DT7SkKz+kj/8JE'
			$Code &= 'A5hokuEaigPBSK0P0e1Jzyw+3QTZHxQDL8wo/xnIdDsJJAUM6Nkh6E5QUI3aMgKM/lF357bpZBtkAiEQWD3po9InAQnx6Nb2sjcu'
			$Code &= 'E7i1hZKEhEKB430zKGMIRcAznRAOODRkIxIF8XMITdgsUPuuSV24TwxAdRMkPgkaD42pwZk7P8HMhKCtExAb6JXWxZHFjgwW1EUe'
			$Code &= 'K4mEakjUYCcLKVLoT3BPmnj5FVh6KexvGeZjDU6SUPj9gqokRShCqkfl+hpSn00B5OjRq833OHwdEDklgpUHFDxpmKthVEgoWKIO'
			$Code &= 'RcI6JP4dbzENRYt+QnpT8kt/RIfZ/s7v1/kO+rInTtMps4MyBsmG+2FJZ2tSvxIhJynCKfrBitySBtkkS9aXINOSlOnk8elpHfc7'
			$Code &= 'POMRQBmxDqzSI4D+UQ4I6ZIRQAXyyBTqYuEfZBd24n2BcQGCQCAP/0/CIzrAnUzZdAhWQHhGDXCB+R49MU0SJPrJVvh4RIV+fEiD'
			$Code &= 'EaanlHDfdP5zTFuasfj969xrZGF8iVuBNP1R6PzxOpYf4CZZZuRM+gPxheaMRogOV//qfFvCcqVrOvATcyOjPCFqx2iHFLwtpAAj'
			$Code &= 'ct1JjU5kaAiGqfI9TaGOPxiJAQZGWNIrtcYv6JMFKMcBB7K1SuFYMZ6UMpZEO0SCQRPokd9oK0UwuvF8KiT1EfLwnvuA6LWtFZGR'
			$Code &= 'Vw0jEig1dANSdLYFD4MYAhASkE8leAIHjUj/SnH1i58nzVgzBIjnnNa0nMsoKgTJOfl2Rog6vkf8kD5RPlQ7VUNGR0axd7qyHhgQ'
			$Code &= 'Q07XQ3NUFyRVte8xOTnP+SRz9RJe/D6aYSbCOcchPUNWRc4WXMpt2fd8JI6E7QoT6TcmCEXTvL8GJWREUva1l/j6TALUFHMgXHmH'
			$Code &= '7EBy+SK5XxJyDcrHuTLYNSeZCzjoiYSTpc6srvWypc4IwJYitpn9mvMMw98RenXE1FIDKJhG++bMStH8QJvRZMGjBybN6OtvQonQ'
			$Code &= 'olQ/kfmifyQLSgfBGNAk+QGhxothHSPJPAM1dKyApDnRd0tYsmookBZ7ZpvFSOQJdeq2GCyC6CBLBfodDIZKz2bFFr6IpDF1mHTk'
			$Code &= 'D48IKvmI9A7wFfmLJqJ051i+CEIDfpvuJOtOiWi61m4EnXtdE3xc+xAJyEQE6KPcyu4uGWhC6Gi2aSCs+JBmi1cg4XgxTmy/YEGm'
			$Code &= '+UIVBlKTNEfKbHdTlPktuZABQ9yEU8djnFEN4kkhg30o9ltOKBJFwDhosUW4KRJfWftAFBGD/txyYr/QUL2vTSxZ/kuVUBElUxii'
			$Code &= 'YXMI/ZqcUliUY4ToE+OMZQuVqS5RNp4jtEqpV0qNbCo0Ou8MZ/dRx06GnPvpUb8QNHdN6F5ZWLnZqL5EH8t6Zz4ELz2sullDCATx'
			$Code &= 'GvTLtxa9hEwUx1OoUPCSv5WRWMJluDXaIHbqSwi2pT/CWadeX166y7KlYAz/yUUhbekYBpUkQ5RNLxVdtVZtFTwyyiwBYQU5+Hb/'
			$Code &= 'Tw1V1KePXbC2nVXLqA2gslesyayuOLdpwqKvArXGSbtMF9nK6Ac4FMC5jELSgK5kVEVgd2Wlp8vYNolIjiuQ26Zoig8rGxqaWjOC'
			$Code &= '7FaORBkhSfYriAoQk4JFLgkUQMB0mAuPGhwzrBYfFYpU3DKdUMuLpbD2RLLZQiIQe/f5zDt+E1By3rYEGCnXM8hEpNhA7UZlSAiW'
			$Code &= 'M6iLZBe8FoyBhlXgEiH0JApglMP6RwNCAfcVkWy8YI+p+xDA6shha5P930k//ORgfyEBrTrpRwRK12KkCTwnTfSp+Yjr1rIkFykx'
			$Code &= 'KEwlBk/kxJf1a4hMUyXIGF7RUfVj7E+w7cCU2iXB5EvagYQ7TjDhHyiUEdgbRK/QRwiFnvMGNUY0X1QKmSzcZofK6wRpBrLCLQZI'
			$Code &= 'SQNWODUUDusKDlrlQKU8Avk50YewR86bGDVQTAqJejxcFUhCxCgKu0jBzX5yiO51XPCWlFRMIkgJddbKKPTpaC0Zr2Kg9Jv3bMtm'
			$Code &= 'XsqiNNMVoywRAU8QCrNOjVho7aFl9BvW6MFIAh1DHP+6RktJxS9aHqoTGb3CpZ3+ewMH6PiAHYTrBd3+75bLnRQy00WzfQnpdSZR'
			$Code &= 'L6Xop+AQlRI1+THoEEcYiRNmtJFcWAceE0Ly4kGZJBsqMgsIBW5ihWeWzyOW89A7bgIcdDXo3ga0XFvmEjebMkuJpykxwumh85Z8'
			$Code &= 'QhxPycphjwdsuetU2yMKFyt7GPydvDwPUwgBbxx9O7MM8H7FNahCBLx0MvDwXi6lgEhGiUj4QqbG9yRFs0N/NLkPFEVBp7AWg/oT'
			$Code &= 'M3QNCg6qCN0gRonI6wmwneG0/x2QSAT32P05XywZmgzhQEwLneICYHyNBFkI/Q9FA07Y8EtIn2meBJP3BodOj0sMditNKNc3Vfg+'
			$Code &= 'MunESlnU4k9KugrL5zKnVDFwdD2de1WMNEwSOERNK88kUDOqKfQgddCdUbjPZ8dDvY0vxIO/zqeT6yudPsbfpzUXdBTpMZ5EC4N7'
			$Code &= 'k+YfsTsKtAqD78/ImD91JZc4U3Z+gn1mY5he+mnWG/lELQcQ++vBPotXW6RsUOUEQr8NxwNWQFDrpbcLBFoWDDnGdidI8smGwC+i'
			$Code &= 'IAHq6MZZt0aZgdAM+iipPduEBK+JF4pC8Ulqtk7WaZ9PBTswNiZFQlFEzR2RN0AU9kAIWwLAz4lQID3HQvDhO6NR1BKZygl69JHL'
			$Code &= 'y/baE27V6JoWBHP8bTAKEwK4/99hC0LDgkN1BX0Bv+sUhLG0EonZ5Au5UgSWPynsGgb/o7IdBkU5l3KgEwtBRHrzAUUGmxwJI+SO'
			$Code &= 'cl6NtDAz7bXHhZDglrCKdZh5O39El3MQ7GXUa/E/H0isOCd0WVCwqHPHB2IfZYnRVKYF02dA1tIskIcHCHIni0/TTI2UgquQhL9H'
			$Code &= 'wZnC+CjyWJYuAZ9jwIlCOCcHc+JIjcZ8CGNUUMcBcI8S6PT+IWxGCJTkFhsL6OT+/F3LA4IMKWcuNk55CtZuFA6dCHwEdBH95nVf'
			$Code &= 'HIAW6Orj3o02VgjSIPy4SYWQJ6SESWk3XqULgzgNDianeEQOywZduhy5pVNqxV9lOa4IwcxiaAF37HZQXwmLSXpFilINjUIwoZAa'
			$Code &= 'RYWDev9Ltjp2nsqEr9utCUG915hy6BuCVn4mQS9sJEQF61g5I4tA8H7yb5BwSD9SNShF4HfTTuK9Gd/UxSwvJcUghY1F/OiYteop'
			$Code &= 'TT6F4/5MIeFI2p159YXo81YXz7ajS9VWDTLiI4lgX1gFdYf0OkkMOcNyQxnUQxsddzdPKfsFgetPG8FAAkqNhJ6VRjonRlhxqRcp'
			$Code &= 'Cs4tEafY6cVuhIYyHWAFh+wFkCDp3qkcfYWTFVfc5OtBMtPlLOmu4ypSkLEWbjh+ULTLCSjpJiuAFkGG0KS1QhmCEMeAVTqsQhT+'
			$Code &= 'p3MhSUdFPq6AQ/kPdeX/7iROgFLwkYfIw4ooGHWAFoiS0yu0GoQMsFKEDlu4XYSlXRjtWUgJgenrqiVJECDCmIsEboIK+UpacAPg'
			$Code &= '6SrMu7BkkDIk7P4xxglHkwLEIk6UBNxEcZUEDpYIvoghlxFRImMgtpggJZlELJKIEJqAHZuAdp6BfRGQoALuInSiBMdEdqMe4iBu'
			$Code &= 'pETq9Yl5p4hZ72Fjb3LFZdR0IJ3O6eeUGmseqSrpJWk53EbcncdrXo9AO3rx08x+QiPyYgjhUgfPcJVhfSEHdVctHw1t0sc9KGfn'
			$Code &= 'WGTjb2aZYmzWnM2E4VBthnmsSqIbHNjueQ9tYm9stFe9G5jbfDSKZQ5RZyiQvK0QHXR5cJEWaocbYa45+mPypLCBk3QhmRgbdTlu'
			$Code &= 'ax1vd1QgI9P6CltnedqU0oxFp9RGdxLrt4xwsnplvFnGfm1wgKsl7hj1lLBo4XDAAA=='
			$Var_Opcode &= '0x89C04150535657524889CE4889D7FCB28031DBA4B302E87500000073F631C9E86C000000731D31C0E8630000007324B302'
			$Var_Opcode &= 'FFC1B010E85600000010C073F77544AAEBD3E85600000029D97510E84B000000EB2CACD1E8745711C9EB1D91FFC8C1E008AC'
			$Var_Opcode &= 'E8340000003D007D0000730A80FC05730783F87F7704FFC1FFC141904489C0B301564889FE4829C6F3A45EEB8600D275078A'
			$Var_Opcode &= '1648FFC610D2C331C9FFC1E8EBFFFFFF11C9E8E4FFFFFF72F2C35A4829D7975F5E5B4158C389D24883EC08C70100000000C6'
			$Var_Opcode &= '4104004883C408C389F64156415541544D89CC555756534C89C34883EC20410FB64104418800418B3183FE010F84AB000000'
			$Var_Opcode &= '73434863D24D89C54889CE488D3C114839FE0F84A50100000FB62E4883C601E8C601000083ED2B4080FD5077E2480FBEED0F'
			$Var_Opcode &= 'B6042884C00FBED078D3C1E20241885500EB7383FE020F841C01000031C083FE03740F4883C4205B5E5F5D415C415D415EC3'
			$Var_Opcode &= '4863D24D89C54889CE488D3C114839FE0F84CA0000000FB62E4883C601E86401000083ED2B4080FD5077E2480FBEED0FB604'
			$Var_Opcode &= '2884C078D683E03F410845004983C501E964FFFFFF4863D24D89C54889CE488D3C114839FE0F84E00000000FB62E4883C601'
			$Var_Opcode &= 'E81D01000083ED2B4080FD5077E2480FBEED0FB6042884C00FBED078D389D04D8D7501C1E20483E03041885501C1F8044108'
			$Var_Opcode &= '45004839FE747B0FB62E4883C601E8DD00000083ED2B4080FD5077E6480FBEED0FB6042884C00FBED078D789D0C1E2064D8D'
			$Var_Opcode &= '6E0183E03C41885601C1F8024108064839FE0F8536FFFFFF41C7042403000000410FB6450041884424044489E84883C42029'
			$Var_Opcode &= 'D85B5E5F5D415C415D415EC34863D24889CE4D89C6488D3C114839FE758541C7042402000000410FB60641884424044489F0'
			$Var_Opcode &= '4883C42029D85B5E5F5D415C415D415EC341C7042401000000410FB6450041884424044489E829D8E998FEFFFF41C7042400'
			$Var_Opcode &= '000000410FB6450041884424044489E829D8E97CFEFFFF56574889CF4889D64C89C1FCF3A45F5EC3E8500000003EFFFFFF3F'
			$Var_Opcode &= '3435363738393A3B3C3DFFFFFFFEFFFFFF000102030405060708090A0B0C0D0E0F10111213141516171819FFFFFFFFFFFF1A'
			$Var_Opcode &= '1B1C1D1E1F202122232425262728292A2B2C2D2E2F3031323358C3'
		Else
			$Code &= 'RKcAAP8AAYPsDMdEJBxwOMMC6AUqMAqJGhiDxAwM6cdxGP9gAjws6O8ppBZliwg4ZyvAUAyJVP4UyA4IkBAiBH4MoScIEzQiEQR4'
			$Code &= 'MO3w6B5sbl6OIMOoLMIQIKQDbhw1NCLIIEKqZREIAhwRBBkRGpxUCeY5BUo8xClTaCGI6D+qsDIjJLAIJAQrT4giDDkiWvl6QymE'
			$Code &= 'codKI2tWfbCNFCSn8ReeGilhGmILKB4JVleLfCQmdJIxTEA8hcnyLwD8g/kIcif3x1UBhfgCpG5JFLCABWalg+n+iTPKwQrz13fR'
			$Code &= 'w+EDuaTruhYGX17DV3dEEDAwD7bGDGnAbAEDrQjIdANBCqpJSAp1VPY//Cnzq0AAql/DUOgG3zPPxVhbBNn5/7gCRJYAMAd3LGEO'
			$Code &= '7roDUQmZGcRt6I/0agBwNaVj6aOVZACeMojbDqS43D95Hh7V4MDZ0pcrTLYACb18sX4HLbgA55Edv5BkELfs8gAgsGpIcbnz3gBB'
			$Code &= 'voR91Noa6wfk3W1RtZD0x4XTAINWmGwTwKhrAGR6+WL97MllAIpPXAEU2WwGcWMAPQ/69Q0IjcgAIG47XhBpTOQAQWDVcnFnotHy'
			$Code &= 'AwA8R9QES/2FDQHSa7UKpfqo1DVsAJiyQtbJu9tAD/m8rOOg2DJ1XN8ARc8N1txZPdEDq6ww2SY6gN5RgOTXAMgWYdC/tfS0ACEj'
			$Code &= 'xLNWmZW6A88Ppb24npACKAgAiAVfstkMxiQA6Quxh3xvLxEATGhYqx1hwT0ALWa2kEHcdgYAcdsBvCDSmCoDENXviYWx8B+1tgAG'
			$Code &= 'peS/nzPUuAHooskHeDT5wA+OAKgJlhiYDuG7AA1qfy09bQiXAGxkkQFcY+b0OFFrn2JhQBzYMGWFTuHo8u0+lQaAe6UBG8H0CACC'
			$Code &= 'V8QP9cbZsABlUOm3Euq4vpCjAIi5/N8d3WJJDy3aFfOg04xlTNQC+1hhsk3OQC06dOC8AKPiMLvUQaXfDErXldjExADRpPv01tNq'
			$Code &= '6QBpQ/zZbjRGiABnrdC4YNpzLQAEROUdAzNfTJDnAMl8Dd08cQVQ8kEcAicQQAu+hiAMyQEltWhXs4Vv6AnUAGa5n+Rhzg75Ad5e'
			$Code &= 'mMnZKSLU0LAAtKjXxxc9s1k9gQ0ALjtcvbetbCy6wJQAuO22s7+aOwziOgOA0rF0OUfV6jyvd4SdFSbbwLIW3HMAEgtj44Q7ZJQD'
			$Code &= 'PmptDahaq3r4zw7kA53/CZMnroAKsZ4eB31EgA/w0qMIhwBo8gEe/sIGaQBdV2L3y2dlgAdxNmwZ5/BrbnYbANT+4CvTiVp6ANoQ'
			$Code &= 'zErdZ2/fOLn5h+++jkMxtxfV2LBgHOij1kB+k9GhxMIA2DhS8t9P8Wd9u+ZXALym3Qa1P0s2ALJI2isN2EwbBwqv9koD4GB6BEE7'
			$Code &= 'w+8c31WOZ6jgjm4xeb4AaUaMs2HLGoMAZryg0m8lNuIAaFKVdwzMA0cAC7u5FgIiLyYBBVW+O7rFKPy9sgCSWrQrBGqzXACn/9fC'
			$Code &= 'Mc/QtQCLntksHa7eW36wAGSbJvJj7JyjAGp1CpNtAqkGewkAPzYO64VnB3I4E1cABYJKv5UUegC44q4rsXs4GwC2DJuO0pINvgDV'
			$Code &= '5bfv3Hwh3x/bC9TD04ZC4rDx+LMA3Whug9ofzRYAvoFbJrn24Xc5sG+CR7cY5lpgfnBqAA//yjsGZlwLPAERgJ5lj2muYvh50yZr'
			$Code &= 'YcUAbBZ44gqgAO7SDddUgwROAMKzAzlhJmenAPcWYNBNR2lJANt3bj5KatGuANxa1tlmC99AB/A72DdT4LypxZ4Au95/z7JH6f8H'
			$Code &= 'tTAc8r0QisK6yvKTALNTpqO0JAU2fdD2BgDXzSlX3lS/ZwDZIy56ZrO4SgBhxAIbaF2UKwBvKje+C7Shjj8Mw4DfBVqN7wItuQAP'
			$Code &= 'QTHAGYJiNjI/w1PIJCbF2QBF9Hd9hqcAWlbHlkFPCIoD2chJu8LRuOjv+nvLAPTjDE+1rE1+da4Aji2Dns8cmIcAURLCShAj2VMA'
			$Code &= '03D0eJJB72EAVdeuLhTmtTfvzJgcB5aEgwVZcBuCGKngmwHb+i2wmss26V3Ed+Y4HGyA/98/QdSeDgBazaIkhJXjFQCfjCBGsqdh'
			$Code &= 'dwCpvqbh6PHn0HXzACSD3sNlssXaMKquZOufRgBEKMxrb2n9cH927jEAOe9aKiAsCQcAC204HBLzNkY937KBXcZxVHDtYINrAvT3'
			$Code &= '8yq7tkDionUAkRyJNKAHkPsAvJ8Xuo2EDnkA3qklOO+yPP/y8wBzvkjoan0bxX1BACreWAVPefBEB35i6YctkMLGHFS4CQCKFZRA'
			$Code &= 'uw6NgwDoI6bC2Ti/DTrFoIBM9Lshj6eWOQrOjo0TCQDMXEgx1wFFi2L6bspTIOZUAl27uhVsoGDGP40AiJcOlpFQmNcA3hGpzMfS'
			$Code &= '+uEX7JPLD+Nc4GJyHeZ5AGvetVRAn4RPAFlYEg4WGSMVAQ/acDgkm0HkPacTa/1lHCSAfCUJy1dkBTjQTqOuwFfin4oAGCHMpzNg'
			$Code &= '/bwAKq/hJK3u0D9ItG8AEp9ssgmGq/5IAMnqFVPQKUZ+APtod2Xi9nk/AC+3SCQ2dBsJAB01KhIE8rxTAEuzjUhScN5lAHkx735g'
			$Code &= '/vPmDue/wv3gfJHQ1T0AoMvM+jaKg7t9BwCaeFS8sTllpx+oS5jHOwqpUCLJ+rUACYjLrhBPXe8AXw5s9EbNP9k8bYyAwnRDElrz'
			$Code &= 'AgMjQerBcGybgLh32EcA1zaXBuYtjsVwtTilhIAbvBqKQXFbALtaaJjod0PZ4mzyHgBPLRVffjYMnO4bHCfdHA4+EgCYuVMxgwOg'
			$Code &= 'kGKui9HItZIWDsX03Vdg78SUp8Lq1QCW2fbpvAeuqBKNHLcBITGcKu/Ihe2QKwDKrEhw028bXT/4LpxG4UQ23maAx8V/YzlU6AMi'
			$Code &= 'ZfNN5ZiyAqQAwqkbZ5GEMCYAoJ8puK7F5Pnu3gP9Oszz1nuw6M+8H2upgEBaspk+CZ/qfwA4hKuwJBws8QAVBzUyRioeczx3MYC0'
			$Code &= '4XBI9dBrB1E2g0Z68LJdY05M19cBD+bh0sy1yfkxJ/TgSgcSlq8LI6C2yHCgAZ2JQbuERl30AwcAbDgaxD8VMYVxDgAoQphPZwOp'
			$Code &= 'VAB+wPp5VYHLYg5MH8U44F70I5idAKcOs9yWFaob4FQB5VoxT/yZYsTX2A9Tec4XYOFJVn76H1CVLcB71BzMYhM9io0BUruWNJHo'
			$Code &= '1B/QANmgBuzzfl6tAMJlR26RSGwv/lMAdeg2EjqpBwkAI2pUJAgrZT8TEeR5AHmlSLyPZgAbkaQnKoq94PbLAvKhjdDrYoDzwCPv'
			$Code &= '5gPZveG8FPz4pw0/A4OKJn6ykbm5JPRw+AEVy2k7RuZCQOH9W7UAa2Xc9Fp+xTcACVPudjhI97F5rgC48J8SoTPMPwWKcv0kk8gA'
			$Code &= 'NwBqwgFu1IQDWQW+RgLcqINZ6/jLBrIAfI0EhRZPBbgAURMOjzvRD9b6lwAN4e9VDGT5GsCUk9gICi1zni49R9IDcKMmHLjJ5B0H'
			$Code &= 'HneiHylnYHCsCy8bAJth7RrC36sYAPW1aRnI8jUSAP+Y9xOmJrERAJFMcxAUWjwVHSMw/sB6jrgWTeTsFzvgRgM41yyPOfiSyTsA'
			$Code &= 'ufgLOjzuRD/shB6GPlKewMBlUAI9WBcDXjZvfZw3qMPaNQABqRg0hL9XMQCz1ZUw6mvTMgPdAREzkOXIJKePsNxM/u0AJ8lbLSZM'
			$Code &= 'TR5iI3uOoCIgmeYgFfMAJCEotHgqH94AuitGYPwpcQp/Pjv0HAAtw3azLJrIAPUuraI3L8CN9HAC9+dYca5ZYB+ZMwDcchwlk3cr'
			$Code &= 'TzxRdoDxF3RFm9V1D3jciX7gtkt/FggADX0hYs98pHQAgHmTHkJ4yqAdBHr9QMZ7sC68bFyHQQBt3vo4b+mQuBT6hpByAFvsd2oC'
			$Code &= 'UjFoADU482kIf69imDsAbWNmqythUcEA6WDU16Zl471xZAC6AyJmjWngZwAgy9dIF6EVSSxOH7gXeQC1Svxj3k8fywkcwJK3Wkyl'
			$Code &= '3TmYTQCaxEav8AZHAPZOQEXBJIJE4jIHzUFzWA/QKuZJQgAdjItDUGjxVABnAjNVPrx1VwAJ1rdWjMD4UwC7qjpS4hR8UAPVfr5R'
			$Code &= '6DnQWt9TACBbhu1mWbGHJqRYeQDrXQP7KVwAWkVvXm0vrV8AgBs14bdx9+AA7s+x4tmlc+MHXLM85muQ/ucyZwC45QUNeuQ4Sg4m'
			$Code &= '7w8g4O5WnqLsD2H0YO1A4i/o04ju6QCKNqvrvVxp6gvwuBP9gO3R/J5sAJf+qQZV/ywQABr6G3rY+0LEAJ75da5c+Ejp4PMAf4PC'
			$Code &= '8iY9hPAAEVdG8ZRBCfQAoyvL9fqVjfcAzf9P9mBdeNkAVze62A6J/NoAOeM+27z1cd4Di5+z39IhyN3lSwA33NgMa9fvZh6p1rZ7'
			$Code &= 'ANSBsi3VBKQAYtAzzqDRanAA5tNdGiTSEP4AXsUnlJzEfioA2sZJQBjHzFYAV8L7PJXDooI708EA6BHAqK9NyxKfxY9DqsnI8fsL'
			$Code &= 'qHQHRADMQ22GzRrTwALPLbkCzkDA75F3APxtkC5CK5IZACjpk5w+pparAFRkl/LqIpXFAIDglPjHvJ/PAK1+npYTOJyhAXn6nSRv'
			$Code &= 'tZjsBXcAmUq7MZt90fMAmjA1iY0HX0sAjF7hDY5pi88Aj+ydgIrb90L0ggFJBIm1I8aIxGSaD4O/Dljg5rAegNEA2tyBVMyThGMA'
			$Code &= 'plGFOhgXhw0ActWGoNDiqZcAuiCozgRmqvkAbqSrfHjrrkscEimvwaxvrSXGz7AYgfEApy/rM6Z2VXUApEE/t6XEKfgAoPNDOqGq'
			$Code &= '/XwAo52XvqLQc8QHtecZBrSgp0C2iQfNgrcM21CyO7EPObNiu0kAVWWLsGgi1wC7X0gVugb2UwC4MZyRubSK3gC8g+AcvdpeWgW/'
			$Code &= '7TSYvsgAZQBnvLiLyAmq7gCvtRJXl2KPMiTw3nkCX2slucCane+wQQDFik8IfWTgvRxvAYeA17i/1krdANhq8jN33+BWABBjWJ9X'
			$Code &= 'GVD6DzCl6BQ/e4Bx+KxCyMB7AN+tp8dnQwhyAXUmb87NcH/4lRUAGBEt+7ekP5550ACHJ+jPGkKPcwCirCDGsMlHegAIPq8yoFvI'
			$Code &= 'jgMYtWc7CtCAh7JpADhQLwxf7JfiH/BZhbsO5T3RoIZltOA6Ad1aT4/PPyi/7AcQ5OrjYFhSDdgB7UBov1H4ocgr8AHEn5dIKjAi'
			$Code &= 'gEZXnuL2b0kCf5MI9cd9QBDVGEjA2QBO0J81K7cjPo3FvJaAoH8qJxlH/QC6fCBBApKP9AUQ9+hIqMFhFJvNP9wjtgCQHTHT96GJ'
			$Code &= 'ag/PdhQP4Mqs4Qd/AL6EYMMG0nCgAF63FxzmWbipAPQ83xVMhefCANHggH5pDi/LCXtrSHeDaA8NyMdosTpzKYAEYUyguNn1AJhv'
			$Code &= 'RJD/0/x+AFBm7hs32lZNACe5DihABbbGAO+wpKOIDBwa7tsAgX/XZzmReNIAK/QfbpMD9yYTO2aQACSIPy+R7X9YAClUYES0MQf4'
			$Code &= 'AAzfqE0eus/xPKbsgJL+ibguRmcDF5tUAnAn+LtI8LAhAC9MyTCA+dtVAedFY5ygP2vox4MA0xdoNsFyD4oAecs3XeSuUOEAXED/'
			$Code &= 'VE4lmOgP9nOIi+MW7zeY+ECCFwSdJwAmJB/pIUEAeFWZr9fgi8oAsFwzO7ZZ7V4e0eVV6LEAR9UZ7P9sITsAYglGh9rn6TIcyIKO'
			$Code &= 'QHDUnu0osQP5UZBfVuT4OjFY5oMACY+n5m4zHwgHwYYNbabwtaThQGC9FvwFLykASRdKTvWv83YAIjKWEZ6KeL4AK5gd2ZcgS8l7'
			$Code &= '9A4urkjAIAH90qVmAEFqHF6W93k5EipPlwGPXfLxI3BkGQBrTWB+1/WO0QFi5+u23l9S5AnCAzfptXrZRoBovCHk0ADqMd+Ij1Zj'
			$Code &= 'MABh+dYiBJ5qmjm9pgAH2MEBvzZuALStUwkIFZpOAHId/ynOpRGGAHu3dOHHD83ZABCSqL6sKkYRABk4I3algHVmAMbYEAF6YP6u'
			$Code &= 'AM9ym8lzyiLxAKRXR5YY76k5AK39zF4RRQbuAE12Y4nxzo0mAETc6EH4ZFF5By/5NB6ToNqxJlOY6w+a6+nG4LOMoUULAWIO8BkH'
			$Code &= 'aUzovlEAmzzbNieENZkHkpZQ/i4e4LlUJvzeAOieEnFdjHcWAOE0zi42qatJYIqy5j8DIACBg7t2keDjEwD2XFv9WelJmAA+VfEh'
			$Code &= 'BoJsRHlhANSqzovGz6k3AH44QX/WXSbDB26ziXZ8kO7KxG/8HQBZCrGh4eQeFADzgXmoS9dpywATsg53q1yhwgC5OcZ+AYD+qQCc'
			$Code &= '5ZkVJAs2oJADAFEcjqcWZobCA3HaPizeb5hJudMAlPCBBAmV5rg+sXuHDaMeLnAbSD7SAEMtWW77w/bbAOmmkWdRH6mwAMx6zgx0'
			$Code &= 'lGG5BWbxBgXeyAB3AAcwlu4OYSyZHglRusBtxBlwavQAj+ljpTWeZJUAow7biDJ53LgApODV6R6X0tn6CQC2TCt+sXy95wG4LQeQ'
			$Code &= 'vx2RyLcQAGRqsCDy87lxAEiEvkHeGtrUA31t3eTr9Lm1UTCWhQDHE2yYVmRrqADA/WL5eoplyQDsFAFcT2MGbA7Z+g894I0IDfU7'
			$Code &= 'AG4gyExpEF7VAGBB5KJncXI8dwMA0UsE1EfSDYUD/aUKtWs1mKj6QgCymGzbu8nWrAe8+UAy2LDjRd9cP3XcAA3Pq9E9WSYK2TCs'
			$Code &= 'UcYHOsjXYIC/0GEAFiG09LVWs8QAI8+6lZm4vaUdDygCgJ5fBYgIxgAM2bKxC+kkLwBvfIdYaEwRwQBhHau2Zi09dgDcQZAB23EG'
			$Code &= 'mAHSILzv1RAq6LGFfYkCtrUfn7/k4NW41AszeAfJDuMTABOWCaiO4QAOmBh/ag27CABtPS2RZGyX5g5jXAFrI1H0HNhhYoUOZTDY'
			$Code &= '8tweTsAGle0bAaUAe4II9MH1D8QAV2Ww2cYSt+kAUIu+uOr8uYgLfGLdHYBG2i1JjHvTAPP71ExlTbJhsFWgK86jcLx/dAC7MOJK'
			$Code &= '36VBPQDYldek0cRt0wDW9PtDaelqNABu2fytZ4hG2gBguNBEBC1zMwADHeWqCkxf3QANfMlQBXE8Jz8CQY6+CxA/QAwghldotXYl'
			$Code &= 'Em+FswDe1AnOYeQAn17e+Q4p2ckcmLDQwCLH16i0WQ6zPRcuwA2Bt71cADvAumyt7biDAyCav7O2A5LiYBWx0vbqDtVHOZ3gd68E'
			$Code &= '2yYAFXPcFoPjYwsFEpRkO4SA7Wo+euZaAKjkDs8Lkwn/OJ0KAK4nfQeesfB+DwBEhwij0h4B8gBoaQbC/vdiVwBdgGVnyxlsNgBx'
			$Code &= 'bmsG5/7UGwB2idMr4BDaegBaZ91KzPm53w5vjr7v5xe3UUNgsOjV1uKjC+ih0ZMACNjCxE8e3/JSy7tng/W8V6g/tQYA3UiyNkvY'
			$Code &= 'DSsH2q8KG0ygA0r2QVgEyDnfB+/DqGdgVTFujvJGLmm+8BZhAJ+8ZoMaJQBv0qBSaOI2zAAMd5W7C0cDIgACFrlVBSYvxQC6O76y'
			$Code &= 'vQsoKwC0WpJcs2oEwgDX/6e10M8xLADZnotb3q4dmwBkwrDsY/ImdQFqo5wCbZMK1AkGAKnrDjY/cgdnOIUFAFcTlb9KguIAuHoU'
			$Code &= 'e7ErrgwAths4ktKOm+Uk1b56ANzvtwvb3wMhhtPS1PGQ4kJoAN2z+B/ag26BAL4Wzfa5JltvA7B34Ri3R6zAelrm/wAPanBmBjvK'
			$Code &= 'EQMBC1yPZZ74+GKuHWlha8DTFmzPRaAACuJ41w3S7k4ABINUOQOzwqcAZyZh0GAW90kAaUdNPm53264A0WpK2dZa3EAA3wtmN9g7'
			$Code &= '8KkAvK5T3ruexUcAss9/MLX/6b3i8gAcyrrCilOzk/4kHrSjpsDQNgXN1wb6VALeVykj2WdA2mZ6AC7EYUq4XWgbAAIqbyuUtAu+'
			$Code &= 'ADfDDI6hWgXfBRstAu+NyAAZ9DEAQTI2YoIrLVNMw9cAxQR9d/RFVgBap4ZPQZbHyADZigjRwrtJ+jzv6J/j9EHLrLVPDMyufgBN'
			$Code &= 'noMtjoeYHADPSsISUVPZIwAQePRw02HvQQCSLq7XVTe15h0UHJh8gQWDhJaCG+RZm+CpBxiwLfrbYDbLmuY4d12c/2xAHNRBP9/N'
			$Code &= 'AFoOnpWEJKKMAJ8V46eyRiC+Aal3YfHo4abM89AA58PegyTaxbJgZVyuqkRGAJ/rb2vMKHZwD/1pOTEgriAqWu8ACwcJLBIcOG0D'
			$Code &= '30Y288Zd6LLtcAtUcfRrA4W7Kvj3ojEAwraJHJF1kAcAoDQXn7z7DoQAjbolqd55PLIO7zhz8+H/auhIcKrFARt9WN4qPPD8TwUH'
			$Code &= '6WJ+RMJwLYfbVAAcxpQVigGNDgC7QKYj6IO/ODnZwoegxQ0h8PRMCpYOp48TjaPOXMyACUXXAjFIbvpii0HiUyB7uwBdVKOgbBWI'
			$Code &= 'jQA/1pGWDpfe1wCYUMfMqRHs4Rz60vXAy5NyYtdcAGt55h1AVLXeAFlPhJ8WDhJYAA8VIxkkOHDadz0BQZtl/WunfC8AAVfLCSVO'
			$Code &= 'ANA4ZAGRrqMYAIqf4jOnzCEqALz9YK0k4a+0BD/Q7p8SgHGGCbIHbMlIJKvgUxXq+wB+RiniZXdoLwA/efY2JEi3HQAJG3QEEio1'
			$Code &= 'SyxTvEU/gI2zeWXecGABfu8x5+bz/sT9wgC/1dCRfMzLoAM9g4o2+prYB7uxALxUeKinZTk7DoOYSyJgqQoJtfoAyRCuy4hf710A'
			$Code &= 'T0b0bA5t2T8dzXTCwIzzWhJD6gNBIwLBbHCZ2HfkgJcANtdHji3mBqXgtQ7FvBuEIHFBihpoAVq7W0N36JjcbNniFQAtTx4MNn5f'
			$Code &= 'J5heOJw+BxzduZgAEqCDMQFTi65ikJK13NHdB/TFFsTvV1c5gOqU9tmWANWuB7zptxyNAqicMd5rhV4BEsoALe3TcEisA/hdG2/h'
			$Code &= 'RvguZt53NiR/xcklYP9jTSzzZdcdskDlG6nCpDAAhJFnKZ+gJuQHxa64/d6Q+dbzzB46z+iAe4Cpa7yZPLJa8wCfCT6rhDh/LAAc'
			$Code &= 'JLA1BxXxHh0qRjLAMXdzSHDhA7RRa9D1eviDNmMAXbJ3y/rXTtIJ4eYP+XgBe+CYKQevlhJKtmAjC52gP3DIB7tBiQOwXUYaOGBs'
			$Code &= 'dhU/xChxDgCFZ0+YQn5UqQADVXn6wExiy3GBADjFH5gj9F6zAA6nnaoVltzlcFQBG/xPMVrXYsSZzgd5U9hJ4dAXUPp+AVZ71y2V'
			$Code &= 'Yswx99iNigMTNJa7Uh+Y6JEGAKDZ0F5+8+xHB2XCrWxI8G51U6AALzoSNugjCQcAqQgkVGoRP2VMK3cAeeSPvEilpACRG2a9iion'
			$Code &= '8n3LAuDr0I2hwID1Ytnm7z8jFIDhvQ2n0PwmHIqDP0ORsn5w2CS5aQDLFfhC5kY7WwL9d3rcZWtAqX5aAPTuUwk390g4O3a4gK6x'
			$Code &= 'oRKf8IoBP8wzkyT9cnIAAAHCajcDhNQFbgJGvlmAV6jcBgDLwusEjXyyBQBPFoUOE1G4DwfRO48Nl7DWDFXvAOEJGvlkCNiTDlMK'
			$Code &= 'ni13AM5HPRwmow9wHeTJIR+idx7FYOgpGwAvC6wa7WGbGACr38IZabX1EgA18sgT95j/EQCxJqYQc0yRFRw8WhRA/jAjFriOOXoX'
			$Code &= 'DuRNOEBG4DmPLADXO8mSjjoL+AC5P0TuPD6GhPXVwPhSPQACUGU2XhdYNwOcfW812sPYNBipAAExV7+EMJXVAbMy02vqMxH83STu'
			$Code &= '5ViQ3AmPpyeA6/4mLVsBySNiTUwioPh7IDvmmYAhJPMVKni0ACgrut4fKfxgeUYOPgpxLUAc9CyzdgDDLvXImi83ojutcACNwHFY'
			$Code &= '5/dzAB5ZrnLcM5l3AJMlHHZRTyt0PxfxgHXVm0V+idwAeH9Ltk99DQgAFnzPYiF5gHQApHhCHpN6BKAcynvGwP1svC6wbbg/BYdv'
			$Code &= 'OPrewRSQ6SBuhgBsanfsW2gxUgACafM4NWKvfxMIY20APWErq2ZgAOnBUWWm19Rk4r194wAiA7pn4GmNSP7LBSBJFaEXgLgfTkq4'
			$Code &= 's7COHt5j/EAcCctMWrcAkk2Y3aVGxJrsRwAG8K9FQE72RAOCJMFBzTK/sA9Yc0IASeYqQ4uMHVQA8WhQVTMCZ1cAdbw+VrfWCVMA'
			$Code &= '+MCMUjqqu1AAfBTiUb5+1VrsOQDoWyBT31lm7QCGWKSHsV3rkQA0XCn7A15vRQBaX60vbeE1GwCA4Pdxt+Kxzwnu43OlgFM8s1zn'
			$Code &= 'd/6QVgC4ZzLkeg0F7w8mSjjuICAP7KKeAFbtYPRh6C/i/OnyiADT66s2iuppXAC9/RO48PzR0gDH/pdsnv9VBgCp+hoQLPvYej8b'
			$Code &= '+QDEQvhcrnXz4OkASPLCg3/whD0AJvFGVxH0CUEAlPXLK6P3jZUA+vZP/83ZeF0AYNi6N1fa/IkADts+4znecfUDvN+zn4vduCHS'
			$Code &= '3AA3S+XXawzY1g6pZu/UXcC21S2ygdAAYqQE0aDOM9MA5nBq0iQaXcUAXv4QxJyUJ8YA2ip+xxhAScIAV1bMw5U8+8ED04KiwBHo'
			$Code &= '0MtNrwGoyo/Fn8jJIa7MCxEA8cxEB3TNhm0AQ8/A0xrOArksLZHxD0CQ4Px3kitCBy6T6SgZ4KY+nJcAZFSrlSLq8pQw4IByvMf4'
			$Code &= 'AJ5+rc+cOBOWAJ36eaGYtW8kmCV9BQCbMbtKmvPRfQCNiTUwjEtfBwCODeFej8+LaQ6KgJ3swEL324kEAEmCiMYjtYOad2TyWAAO'
			$Code &= 'v4AesOaB3ADa0YSTzFSFUQCmY4cXGDqG1QByDani0KCoIAC6l6pmBM6rpABu+a7reHyvKQcSS61vrF5dQMYlp/GBGACmM+svpHVV'
			$Code &= 'dgCltz9BoPgpxAChOkPzo3z9qgeivpedteBz0LQGBxnntkCn4LeCzYlzsgPbDLMPsTuTSahisIsAZVW71yJouhUASF+4U/YGuZEA'
			$Code &= 'nDG83oq0vRwA4IO/Wl7avpguNO0AQLi8Z2UAqgnIixK1r+4Aj2KXVzfe8DIAJWtf3J3XOLlYxT8A730IT4pvvT/gZMvAAUrWvwe4'
			$Code &= '8mrY3eDfdzNYAGMQVlAZV5/oHKUw+n33ABRCrPhx33vAAMhnx6etdXIIA0PNzm8mldB/cC0sERgBA6S3+4e40J4aAM/oJ6Jzj0Kw'
			$Code &= 'AMYgrAh6R8mgADKvPhiOyFsKBztntbKHANAvUDgAaZfsXwyFWfAe4j3lh4dlhjDR3TrgBrTPj09a5AAoP+rkEIZSWPTjAEDt2A34'
			$Code &= 'Ub9oO/ArAKFIl5/EWiIAMCrinldPf0kBb/bH9QiT1SAQfZDXAMAYNZ/QTo0jO7crvZaAxScqf6C6/QBHGQJBIHwQ9ACPkqhI6Peb'
			$Code &= 'FB5YPSNdP0AxHZC2iaH+0/52AM9qrMqoD75/AAfhBsNghF6gAHDS5hwXt/SpALhZTBXfPNHCC+eFaX4AM3vLLw4Ow3dIa+UNDwDP'
			$Code &= 'sWjHYQTmKQDZuKBMRG+Y9QD80/+Q7mZQfgBW2jcbDrknTQC2BUAopLDvxgMcDIijgdvIGjlnANd/K9J4kZNuAh/0Oyb3A2AkkGb6'
			$Code &= 'LwA/iCmTWO20RABgVAz4BzEeTQCo36bxz7r+ku7sAEYuuIlUmxdn8icAcAJx8Ei7yUwAL97b+YAwY0UA51VrP6Cc04N+xwDBNmgX'
			$Code &= 'eYoPcgDkXTfLXOFQrgBOVP9A9uiYJfKLB4hzFjfvMwSC+vjgIiedEyHpHwDAVXhBi+AA168zXLDK7Vk/tjuF5dFeRx+vQf/sGdVi'
			$Code &= '+CFsE9qHRgAOMunncI7iggAo7Z7UkFH5sfLkElZfOhwmwKePCYMfMwFu5g2GwQi1+KZtA71A4aQF/AEaF0kpL6/1cMMyACJ284qe'
			$Code &= 'EZaYASu+eCCX2R3U9MkAS8BIri7S/QHuagBBZqX3ll4cTwkqOXldAJGX5SPxAPJNaxkF9dd+AGDnYtGOX962HevCCcBSerXpN2jg'
			$Code &= 'RiXZ0OABiN8oMerpAFaPItb5YZpqEp4EB/ABvwABwdittG42FVwI7wAdck6apc4pAP+3e4YRD8fhAHSSENnNKqy+H6g4GcBGgKV2'
			$Code &= 'I9gAxmZ1YHoBEHIAz67+ynPJm1cApPEi7xiWR/0ArTmpRRFezHYATe4GzvGJY9wARCaNZPhB6PkdL3lRg5MeNFP4sdrrTJrtALP5'
			$Code &= 'xukLRaEHjBnwDmJgTGkHPACbUb6EJzbblg6SmTUuIP5QJlS58p4A6N78jF1xEjQA4RZ3qTYuzhEAikmrAz/mRbsAg4Eg4+CRdlsA'
			$Code &= 'XPYTSelZ/fEAVT6YbIIGIdTuYQBExovOqn43qQDP1n9BOG7DJgBdfHaJs8TK7v5Zcx0Ab+GhsQrzFB4A5EuoeYETy2kA16t3DrK5'
			$Code &= 'wqEAXAF+xjmcqf4EgCQVmeW4/wALjhxRboZmABanPtpxwixvc94AlNO5SQkEgfADsbjmlaMN2Xsb5C4eAEPSPkj7blktAOnb9sNR'
			$Code &= 'Z5GmAMywqR90DM56AGa5YZTeBQbxSLiYSuH83N//4sNRVceAD1aJ1vfQhRz2dBvOwQOgFg+2ETESwoHivSd/B+gIM0SVAEFOdeUA'
			$Code &= 'U1eD/iAPgvHAd4n3we8FeTPuwu7qfBB8wwrrCIHjLSEzDIuUYATODjPunQgIIB98GGVUGCUZHCqFwQyDD1EEidAqthAUIIuExWGJ'
			$Code &= '03FIM4RIO9OEQUQJWJUslTwVQQh463WPeRAPQ3KQPdF4vBSPWIPBZyD2+GfubfyguYCNfnH8HrBPD4UmFP4gKPoGBHJLifL+SAL2'
			$Code &= 'QZHz0sdgABCBVOdQvEO9IcPFvDyLfIUQvNDHAARKifh1ul9NW20TF5A7aSbqigFeXcMxwC7C7A5hjwHXcuYBg8IE0el18jCtiZiG'
			$Code &= 'l2FMfTACxgop97sgfw8MN+9V5ejOHKOAiQaDxgRLAnXtX15bXYMqgeyE0qtTiYgA3c6F23/NaPAy9eybNrktgMdFgJdIBYnI5Ex6'
			$Code &= 'hR9AAckf+MZ89I0qdFCjqBuZ6JIL/8oLG1Et+4N0Ez3ECL1VqVIhlXESLARgIKEFD4nxjZVIFUegmwrR+3QnJk2clHlHKqIMLIbo'
			$Code &= 'UyAnFHWvlAozRQiXyLKfixwM303YUA4Q6FI8NRJdwhE1GaIjPHdNkCckdQYtIBChCRCoRAwgKvyOH/5T6fAQV/TPkbAS4fn5A4P7'
			$Code &= 'AXUzUKF7EPLRGIH58SdyBvDpoAgBz/H6mRDvCUCpweAQCl8JyFtOBlaLddZ09gIKjUYBXl+sEpQQJHM8WQx0C5YGMgHBLs9BfPVa'
			$Code &= 'UQe4cYAHIvfnYTYPNIDgOgQpigH4XlNYgfs1sBVKglLOeo4Dr6luXvfjAVYLiVUMgetAGbhbAcU9thYZpwpW70S+CAKORwMjBJEF'
			$Code &= 'yAbkB3IIOQkcCo5HCyMMkQ3IDu9wmghAUhBIsAIgd/+MzEThaXPSktzQPN7kMxLXpIaOWkU/RxaDhM2EiG0Qod+REYnYMOAEr8z2'
			$Code &= 'FIPrEM+idKqiuPoX3kSJm71JXixRjCTGJFwU1yuI5mr3QynWy7fpifO7OLqv4BTXjYQQb/At5UX8eSnk6RAmKdGajgH57NlMDqIT'
			$Code &= 'QbL8ZcAnRyMUJFXxPXAvAcUaBS0fByoZ0RhNQZwEm8tJfOfexDN96Fj/DeRyFUA6dyP2+ikiCPlE7uGJ1hLCJLVKoBxoAQNTUVLo'
			$Code &= 'hENYLTgZJbsECwFwSwqJunJQATkUi3QJib4KPEQJ/OL6AO9aWVvDN+ivM2K4VXcIfZXLCUCIQ0Q1MogBwrjWBQgpyosCDooEE7mY'
			$Code &= 'kx7IKQq8AGluY29tcGF4dAdibGUgdjNyc8/3bg+HdWYdFv9/BvvbhkRucx/PYx/8jnQgbbyzJnmDZHJiph96c+/n8m2bDWhOjAto'
			$Code &= 'GeNuZIc/Prr575mGdLthoX6HYy4ykzWE7zksGwGKAQTZAh8jA+QEfAWPuEUMexA4ERIACAcJBgoFCwQEDAMNAsLRD7WWI37IbvIx'
			$Code &= 'XgZMBAeORwgjCZEKyAvkDHINOpcV6AH8haMVB/HiDKaMjAlETMyJLBKsJGxI7JEcIpxEXNyJPBK8JHxI/JECIoJEQsKJIhKiJGJI'
			$Code &= '4pESIpJEUtKJMhKyJHJI8pEKIopESsqJKhKqJGpI6pEaIppEWtqJOhK6JHpI+pEGIoZERsaJJhKmJGZI5pEWIpZEVtaJNhK2JHZI'
			$Code &= '9pEOIo5ETs6JLhKuJG5I7pEeIp5EXt6JPhK+JH5I/pEBIoFEQcGJIRKhJGFI4ZERIpFEUdGJMRKxJHFI8ZEJIolEScmJKRKpJGlI'
			$Code &= '6ZEZIplEWdmJORK5JHlI+ZEFIoVERcWJJRKlJGVI5ZEVIpVEVdWJNRK1JHVI9ZENIo1ETc2JLRKtJG1I7ZEdIp1EXd2JPRK9JH1I'
			$Code &= '/ZUTwnRnAQiTCLIRUy6RItPpEjMukSKz6RJzLpEi8+kSCy6RIovpEksukSLL6RIrLpEiq+kSay6RIuvpEhsukSKb6RJbLpEi2+kS'
			$Code &= 'Oy6RIrvpEnsukSL76RIHLpEih+kSRy6RIsfpEicukSKn6RJnLpEi5+kSFy6RIpfpElcukSLX6RI3LpEit+kSdy6RIvfpEg8ukSKP'
			$Code &= '6RJPLpEiz+kSLy6RIq/pEm8ukSLv6RIfLpEin+kSXy6RIt/pEj8ukSK/6RJ/LpEi/+kViBFAyAkgkWAiEERQMIlwEggkSEgokWgi'
			$Code &= 'GERYOIl4EgQkREgkkWQiFERUNIl0EwMyhYMJQyTDSCORoyJjReNi3s4FCRCbzcbH+b6vbJcIDIkcEgIkEkgKkRoiBkQWDokeEgEk'
			$Code &= 'EUgJkRlAAhXICQ2RHSIDRBMLiRsSByQXUX+BAQIDBMf/FgYDRAcIjkcJIwrkC3wMj+QNfyMO/kcP/cOEsfnFE8UUkQMVIxaRF8gY'
			$Code &= '+RkfIxr5Gx/IHP+RHf9JB6SCBQdE+aTlpbspY0UQMgERORIcE45HFMgV+RYfIxfkGH8jGfq/h+Qc82uJAeczEwTOyk5ywgp7phEO'
			$Code &= 'IhBkFAkYSByRICIoRDA4iUASUCRgSHCRgCKgRMDgnqNyNX+UBnfKDG9lGDJnMJlfYExXwKY9+VpBsFvo6mP2/IkDuXf1jw9DBEHY'
			$Code &= 'W8NT9eZRkpUrASkqs7OtHjgJD1AuQ0P7Id9RHIqpvyrTxx4KLsI39pYnV+3nFD4rJ4kTOFrDjTKClA+5gGVWMfZmAIkwg8AESXX1'
			$Code &= 'xC6ICSY5hxaIfAqRE+K4k/toHJL3jDHAEKxBFpAMqMiwZKBLXuggUYskkFC5klPgagj2nC2wXIB/jQw2iQFd/DnRD4+hgI99NYu0'
			$Code &= 'iGDbLzy8IA+3FOWACByfZjnacgEZdRiKlAZYtIFISh06DkF3AUFNEdxV/Mhjl7tCDEB1EyWKKJwCJnc6qC12LsEmCIm0kFQvN43R'
			$Code &= 'zgHJ0oiPggl+glCa/IymlpcbsGd9JgjPapReohP4nKUgotJ3gwcoi1EEU0cZZkmuPlXoMxEK3DIjVg7gAwhX2HkQMd+8FOSTO9Fy'
			$Code &= 'PsHisQkOiDyygQxAGUQMSIZDTCFQkFTIWJqLGBLyM4NQmGhMKZMCFCiDSEE6OdiofbQEdfiB+T3QfQ+NTZKM60ksiuz0uhUGKcoB'
			$Code &= '6vjs/k0o8JDNUfShBouF3wt6gEE5+X4GRonrooFXUDvAfw9Hi33kov+ESJOlEsI5+gHxidYp/qAqzkk0iQc8kwHxY6/PqohE3smc'
			$Code &= '3NjAYBAsVJECAWfyLtdSkKwSDpFwAINF9AT/TezyjASF9g+Et5Dajbx4olShY0lmg/KoYKqiCAZ1CoPqAi1wOjZ09gz4RD4CTLqx'
			$Code &= 'n5QBIpQ8YBQPg+4CxJp/vpeVcdJ0Z0P47DP0Pwz06//rThOs8I13A8b87vukVvgHdeA7mtAZL0p8QeqNdI4IOdegGYnTKfvo3/kh'
			$Code &= 'Np0sDKiyCPkBuKig/euoaBrQlrg34JxGvBQG7IPvAkrF+JxIX+ryEHyZPr/P/cB6RwIx0scbRfj/A/989kpzBwlyBIXAgkW5ipDW'
			$Code &= 'cANTuL0EiUSfBugnEIiQj8dpQymr2thuXdBr8A2XCiStGwdCOcp9BE+pdIew8oUKS++HEGLrL8OadBY7dcJJCIxFE7sQqLwaHxWD'
			$Code &= '+ox/CR3AhGQHE8RQjiCJ1NZJRoEGcgPrFqjIHQZDcf31CpkHCkqXEfwK9HWA2NEcB8l40FVe1RTgCNjsaKci2IrlxM3ItwxsIQOE'
			$Code &= 'UP/WLEQFxiQGR2kgzRd96LskBR7e5JSoRn30ZNos5B4meBX84ExcJv4EGvCRQWH4MKOe2FNMvLBVfrghyeEWArpSICwp+oKYXTK0'
			$Code &= 'sKbvOYnyhNPii0iAAAmQuMJHD7aYhQeLgLGIHBE7/0BkIbkiSP0tpicxywFJsRBNh9LA6SjRwH7ujUw68MqSsDmgjz7rFFhGQl1o'
			$Code &= 'tFdpeJahholMhQ8qhWf2KukRp5GzGMuTO3Vl7BKqMq+MGb9NqSACTVb4uU1ANGg4JFXUY2WyCorkXmiuioqACQqIBKE0LF2XnHjx'
			$Code &= 'RYqQSLyIosUytktvQTe8CLTv+4S4jVQKhFIlGhA/wCG4CushvRG8yud9TcoTGgNGYsEeKdou/0+Kvql8QWejqKhXEBp5VrynQqGk'
			$Code &= 'YYuDwjCF+RQOflyI6kaFaFGIfMqe8oTIgeHpUAIm4YeDwfPpOJydETQ7DyePGSpPJhHCUiHiwDVxIBLAT8hKJ3kNC7zzjwgpAfED'
			$Code &= 'MfpYGcaHZMRr4sQXRPUCCX5ZF1n3GxLrE2gWB6Z6JU30C2ILDnCISg48B+sZHjnOJQYPPwwpBw4RBDuD3PZYYS7oWwjj+i5yWVFq'
			$Code &= 'HCfUjlkLUwX/2HpcV7bQ1goLflaGFMLWhE4UCPwQlslWBU+GcdYBXkLQlhl+Q9xOaIpK1kSWJjaO00Do9SOJlhCGouAPkYIFiY4Y'
			$Code &= 'RQysg1ZIeP4jEAaDwPz0QgzqI/R5BBgxB/85fRAPtKKUa3SC0GBo6HZI6oEED7YUOMHlhJYp5EKQ0Y3ZOJ5dlCl6IkZDniBOQ1Yj'
			$Code &= 'liGJpRp/CZiob4vomMDrJOgOqGgEOJaFCIZ+UZZnfUaiCAHfO42MXlLK2HcXSY2WkJuJ8OgoV/gRRAyIQwkiRl9fi1JQFpBMoKbH'
			$Code &= 'DFbSsKRGB4EKmGNgFhBXC1egGI0+vqaeUbAOJco4bg60kJQRN1EoGIJQ6GjxRgwoEFgbLZgEKKEHginxgfn65TFzDUg97wgMAQhY'
			$Code &= '6xLB6QeQIC3FjAgQIDgpiKQmqxGcaW6HNjn6bwBfD5TCXola0ChIi/QIwjZWVzmYuA+EWVE7OutQrPTIcKSnhZ1RZr+yFzQyQgqM'
			$Code &= '/K8m/ctC1GNNrOKSCVSzAmbmZdcq+NKmYQI0s3k3S8JTxxWQmNOJOWKd1iapSrEVbTYnTS7uoNpzPwbpoAIZY4vD0+ZEsBMBGtHp'
			$Code &= 'hSuCATPwEDwwT1gCCrsGBA60l8jTrwJrOdmQmpS6bAQzJPCe1dctCC2dWesfREDrURuaCWFju5cpNQGgGucAixy4SlgNa4mWewwV'
			$Code &= 'fSiG8QErNBZJnC7k35NFUCWm9yiAo0S4aHiJORoqCBP/5/yOPSHZgvCNTAvTdonrDB4wVtmRJ0qCpoH6ZU4I7+xCNBALBADRzFDd'
			$Code &= 'qRK0NlBJ01sFwLECYqi7GPuJJH3wVpRg0GM5PLIk1vpV9tA0tbU9VaUyFo9D8LIZQngKvjgq8kDjmIZI+VOhXeYRPLAEhcewCoRw'
			$Code &= 'g6AVse+AKxSKJSW+MKz+OfG54hDWKeaikbCicCQxj1QmcJ1MJg6TVObqgIbZgKY78NHjqZMWfY/FSiimO7Fugg+CsfxIRbeTTQIU'
			$Code &= 'Ro+J1gV8CEySczaz4RTPLiHw+lnOySmInS6QCK2Uvot6LF/yD4i08uY4UUsJc0IJX8VBrbJ5M6ghWpBgun/A/zrzMReNjiCf9sIB'
			$Code &= 'B3QGZoM5AXVGQCjNHtHqx/gfflwivmy4Oyo0yBW8ZCpIyGMguJYPxH4UAQqQO5AOiT2QVHzvybLDebM7aRJeNw+D5oIJ8ErDzbfR'
			$Code &= 'hdJ/58DoXsOTMgBTg/kQdTeZTsqcpqZ80ie1l+pR7iI7MFvDeAh8J9o/SpZPZApwkCZfKIOAJkn42MpbcVAIfkIi9CRqMnfrXUAg'
			$Code &= 'fhLVOar0K4NLokh9TMt8Euid6U8sfVEJx4AJYdGUinRCvtMkE1fpi4nZDIAkDEkX99g92fZT0RCYQvfRriNdX0kpGkYTSxI/DSMe'
			$Code &= 'mSWekDVGEnXm7aCXEwGjYXZLiie7xBi5zXxLJMnLOjZOKEUwMD8DQe2RGCB7VCYLLIRDQiI4UFjgiobtCMdSgsyDXek5SkkgWCBW'
			$Code &= 'jTV14rAx3Sny8DRCmHUddDXgf7LOBvZjZg8MiUxF0w8I+GF+5DH2QaV4JJwoVJIC8EwWwBJEVeCJwWxARBHoNuX9oBQABLdGOd5+'
			$Code &= '3F6XFCacfDmkUykdONJAT3wMohiDyVWLzInlQJ/Hhp2ISQGyFFQpenfEsH42wXs8hyBtIlT/H4tQlgaJd4SdEJ1F/HrGKDBYNsHw'
			$Code &= '6wcx0oLiVIcCQFzzCXzKiMYpPpN9URgRCgVBH4nI6zTSK0QnusZ4MhSHlAYY/46Xqc5c90jRAoMCKYZ0j6FOinyyqKdI+0oE7VBL'
			$Code &= 'mSnQ+MMl0fvwLBN8EVPBVF7sAktfDHYjfVHv6wbXBoQp+IzvR27UnvmXFUiJFBtqAWTRjmAjrW1xUgELg8roAZadka2OQQaJnN6I'
			$Code &= 'OBN5hA1Elx20HQMSn8TNQb+PipQeCd2MTcYRgzjKMO3SM3MDCtECRf7CiJQOiRnYQ6YlzguftH2KQYhsSOgloev5MiPshw+NQv0D'
			$Code &= 'FHMRmwYoli+yrCmJlM2i8EVAOAEKjZY8xkK8/dNSpXjwzWgcKWZ+fxToAe7hiigSiIgJQu/tD4mGsLfh/aB6DLhLEiEEKeAFC9BY'
			$Code &= 'QSABOwLljn4KJ3VsMBGERMJUeQLIM5bERgX43zAxTAH+pTIQOjjfwsj9cTDp6EDl+AN9ApWNTEARAUbvsLBTSA2ZQgJaDyMDS0wv'
			$Code &= 'W4hy/2nUipMUp22lnXhmiEs6QyDu8SspYCyWSmUGhQMCnuh2+3Uay1AANVUUy6HsKa3JEG5z22RT/Ckaoxy6AieS1XZ4IS2tCMO6'
			$Code &= 'xEqnKcUBcKNA5jKGqFK/TErKCoXrCVKUo2HTEoyjApKgakenavAx/5WXWJIJsk6F6Ju8dUJsdpb0QynKOVwLk/oJDrjlFPXkLYMb'
			$Code &= '7ehZjVn2Au4eQrAX6LnSoV5ZcZEHShAO/+KclR0l+WonWMa3KRiGxYQr4FcUx0X8CDB+MD6DfzAsAjLo5feyFHtHsHtDGBBm+kyT'
			$Code &= 'Sk9MUY1aGTuEvdHYPPwSltagRI6iABvCCvafI+oDq+mcoHY5C9F3B+sDFEsF48qpQwT50PkbLhMK8W4D3H2YV1NQsN0o2fxKDBDp'
			$Code &= 'TgF5vl6IkM4PhLXbD3QlEK1lPTBfjVcEkZ0UUvUl0GJvVDJEhmhGiQEPeoFOFz8ohk0zU0DBCXTqg8AEpYZill6DclQc2lT5MfIo'
			$Code &= 'CxKW5J0AQFBBUUJS6K9c74qEiAlWYq9RSAKY8qTCFRTpjK2xRwIdKmvf2jJWa1nzG9GtxeiZ1fAGoQzcDYmRBw1HnX9EjuUWsLAH'
			$Code &= 'oRX3OiwTVx5WU4MHJItUNzhHTHc8g0J42pqQvTnYzxY0x1p8GQG86wJL0OMQDAnDiRxOglKQ2Q9adDnDfAKJJyRcXL0Pcjg/+7sE'
			$Code &= 'g2psjXw1h76e3yDB+PfYg+BDj0TbFAmILC0GIM0pxX8CNjHtuyuhmMaDYwgPtx9bf4fCUzj/BxMMi3pANxRw6xoh0d8mR0856WWG'
			$Code &= '/S4QgepvgISI1Kx4iUR4SAzYdd2LigTcGswBOxAQ/M9liWyLJoH1NwHON/G6+P4kmrw3OAjzcrQwgAeLBDIz5jpQdZBE8evPTz+9'
			$Code &= 'JwdwHf7pO+txwKm3rzCMBhQCn+DELAHw0tpqVgBOKfg9AsR5fUyNHQOjHBn4fxPXCEmrCbKk8qolyjCoBthOhkpwRCJ9LVIE45Hc'
			$Code &= 'b1uRyCFMmcfQW1poY1vKGypTQX9DOcToW15fTl3nqAAgZGVmbGF06+J3EzTwQ29wA3lyaWdodDggOf8dLTIw+XoPSmVhbkFsb3Vw'
			$Code &= '6UflaePLeb4ee2R7TTxya7xBf53CznkcA1BT6DQxD4mseAidD0N/lKkJCDIUBiAELMIdDIQOOAhEGVAGXAJoAnRbiYbUkfAaWoEE'
			$Code &= 'mAUICVNbogxXr8vUDMkGVGY5Uwx+2DEERl62Kr1VGBgMgOHKOSAVGt8ZKgoTlAQMmxQhGRAtGsjGn3tXF9+F0ggH1UJyHN4olMoL'
			$Code &= 'WEKZFr8ITloYGbYYsxYSXgHA2n4EKv6Fa6Qf2CxcFGFQZTCwGSdF00TiPolBYHeD+wNyYH5wLDnLdg8Gic8pyQGA9lY4V1Cw3Taq'
			$Code &= 'rk0WwTZYiX5slgZcFJucFkZIGG4QSgEeMcgj01THeIfSU8f9cy1MfRI7fm5X3xg4QEQQfgIlXkDByE4wrvjZUzY0k0lmAoJBIdfY'
			$Code &= '2mx7MFZGZ0QUFHJCO4LadsXAiDHAn2TyyRK4rrhfJ9lPRAigGxnuQGAcDxKDeBgnAnXYXeaJLUgcUo6iPC0tEwosMzBKHIdnKtdQ'
			$Code &= 'bnpQ2auxfboBLdOOSqIjVRD7+Cf50aJDh2+RLo0ng+sXWomIN8fGFGpQgAlVeRi/E1D5UHxCQRQU8w3QDI0sQj9DFwawugFK0B/x'
			$Code &= 'nUzaBa2Et02MoqyEgqFWtJGhe0hHrTjoB1Z0X0g2TQYtB7hJyOsgLXdaHCXOqwm+SAm+DivJBkO6ysBQvSQcU8SACIoZQEGEGdt1'
			$Code &= '+CAkTg9nViwHW/YWUhkC6xGybHB/GfVwgQTLHgbIvrkPwKM5TzB1JM4KULcBddbB7g5loHxPLRl6t1wMNX4S8F6NBLcHX4hOA5gV'
			$Code &= '+1AJjUEGqAhWi0pwjKPKIMHq7j7fFufGzHxwtKWNDDoTRbuiuyRGeQpOECwEOc92xy9JQW01IFAQySgMgFJR6FisixhEAX7ieBDF'
			$Code &= 'DBQpG98ftlrsdu01TQfDm6uFh/iJNhCfqlFakJHmEMKbVNrAVRvMQMHa/xkqdCwKRSGpngpJkCJA/R3PCmfoGB9xzxOB6Zrjg+kL'
			$Code &= 'XyOfJ176AIKHkd4NJDdQzpYohv/R5GsI2CV2RDoXIUDxOA7bGCknUhAob4iDD5XsX1HHsmIwJF7HCuD9gkiMclYdS1buSNE4oAGX'
			$Code &= 'pMnbD3l058uJMdBrhh1XuQ6FmPYM86WLQ8ZLCyBoxBbr/lHTbKLWQEI4PX3UGleQgwVzHOjxqoi5LPYepDQpagKZIBGYnI0SEEwj'
			$Code &= 'QGWWqTdkKkRyBBhOOMrUPJS0MAmlyTKMh6pADBS4hkRErooRs6a0EdOEgA2V0nhB8WeqE042IFfO1BgByVEo6FSpE0wCRA5xiEFk'
			$Code &= 'DAgIOdARMIT8EEUrawpzhpUh4okByq4YZ8KNkUHR6vHB3BRXoZcw/JakpLJajpSt44lajbbxji5C3F+JhtKfzkoY0JfVMplqcK3o'
			$Code &= 'Sp2Vc4Jw/DNYJHu3uGJGBMG2xzLFhnUFbpSRDyn4ui5E40xAZnseAXUP1A7tFDBXsgzo9M1062sSKAmgCdECwU4wZO1twSle7/IW'
			$Code &= '5AGI1VupgAE+krWQ+ZDhbPidkiyRCRJWDAbAUDzSwrD+SlH+EvfAV41UewkYUjH/kOho1G8DWkOTjQRAYlQicPlUs2C3TEECo04S'
			$Code &= 'eo6Aov0SV/mjsxS3FLQVlowTK0QslgHwhpCpFDBYJ1QcAga44rnesgZ0BGgJSAVlfAyPeAZgF1/peoEqU4vhLDCrdzk8K650V76+'
			$Code &= 'T4SNlAv6kCopxjkS0HJbSepTA5EYURKufKgktAC9R0QpX3DKBmybswxcMThQ0kH+PuBxOQ7YcgQplyKNSorpPBnplEDd2pA+Wf3M'
			$Code &= '3ossB4PmJFyRxmOydAOdDKbxCjiY+KFvXFCAAUd00i20dfoUA3IdoTtsc2k4qFCxEgaJR8ilToT2VMUdgfqkgHNTDFIThS7RhIfA'
			$Code &= 'MlYBTzw5yHNnj30B1i/wIC0p8YnLJ4H7oZh2BbtGB0KD4PHxanjiEOCnlG8F816JnwQ7W8PEahQiBhJzJw4MgVQMeH7BTc4xdM9t'
			$Code &= 'Vv8hEarKtzMJXlvuS7HbLfpkoC4MvrfkMjbA+/90ZMYidNBadxDoVYXjphtVRJ9JARF7XEfxZsco4TMMPDFzHDnCct0pEokQBuQs'
			$Code &= 'bJoNeAc+MHfKkkNg0vQpyFBS/OgoJfNFZWw+XEz7xKpbRPoP9HmWVRRHT5g8LClbyiafm1SCRUeByBLACQy1huJE8k9UbECJxWbo'
			$Code &= 'GA9DF6h6KEj/E19eUqFKY8sadPOpHkOcHgv+BNB7bVLVzgJPkxIekiHJ+TFUOUHwdQ6iLeI36TACoqg7yx2Nh2EB6R45vUaelebw'
			$Code &= 'oQ09I9sEIuhV/Y0wFIkkEqI3F1YCY5dVSxGCt3Kk70jUJCH4dzQqHjPngaxMEQIzKGEaRCHWdakEm+KpTgqncvicI9o0KdhpbUoa'
			$Code &= 'dmG0pDYrMzY09qw2dB8/JKA/wYFI6kDC0XcNouGw8/lsjkdgzn9hAw+CM5s3ZlWjK6NwupfcHpuKNsq39mdlyfgpiJdvtBwALAOI'
			$Code &= 'BDIBn6ILCZqi7FfWdIbJgNNmAZyXvxEThFEHgcEyODi4UF85+HNhDpvoItR+IOMI6xPAHNHB6gfoVBERhFUQJpeAh+IbdoQsMclt'
			$Code &= 'HjmoaKETYCBnwf0hOyK3dS47h0xAd1eD+ZAuKlJIxlgBylIvdpE4v9pO3AIk0+ORLTHYIjUSXzREMA+3BCHTlShNNVoaIatdLI8c'
			$Code &= 'Sv9JYBiqdbcm6YPH6QalA6PNnMe6oiXokPf1bFa0zLHrTF2bwTiKBALlj0yll3akncb0onuzRiUwmFOhKS5I4UeUCJCPlCdFDSCC'
			$Code &= 'KSrZOUOSh4KNBeXWUtEiG8FqMEWvTOtq4Taof0fvhSH3ijpI9xGG/UoiSMNl8XGiW0kT2PY58d4UTVvy5/m98yDEJoH59OJh+igQ'
			$Code &= '4AqDfQyULxM3IvTJBOBazpHISTL262QcYARwvrI1e3N49mTsd1lgCglKO4+QNnNCoWNPYBLCIYHphMp3MESe8Cz4BAV3HjmfvdQW'
			$Code &= 'dBNGkHURY2IrooH6faOidgNAnat40zMdN6JNOZoWh28yQFct3CiAj3THKdqUn8gPjfYINP2KYAmnyrITaU1TpDQvxZicTRqaGZVm'
			$Code &= 'FYoZYFIF04fR0MY+I7/QUmJQYlRlUhF4EonaCQgBYKHA/qL6gitNCMxJCTnydz45j18ijPTfTZDJ0gLFeHWzK3pSqhFhRmgJNE0C'
			$Code &= 'hCaE3NhEVwjSkE8i0U3J1QjQUFEJFu1NzIhM9HGkM9WWDLlok5KUYE39MIZELAj/dVJlh5dRcrePEoVoCoqHItBCl1VWqQ4dyhvC'
			$Code &= 'dS/NdOJ37DwhrfMi65q4BTlxEOlXlA0jDomzaPHz/AQnqtVG3Sxgmf+7LVyzJ6R6FGiZrHVYDM641EfrhArzOtNnx1LHvlu5kQKE'
			$Code &= 'nPZgXQg9RgIg2+fqMdquESjJmRenJpVAG5y0F0itEsKCOf/ecTEOHDD2VYqZyxqCNTAOdXiuChpugcLCFhpCSspACuQ2LCyFkCKy'
			$Code &= 'GBZCDtPgw3JZrJZIYigFXprmLDnIypJPyf9YfnI0eIosmDss0jTomR8cUb9Yp+SIPbeOFuhmzzJxEF0FyYeZnBAH6EfNohhpc7QY'
			$Code &= 'j4SUuyV54z7CSnVPEq+EzKBoiZj7UVWYKEbJCLm521t8mrlFueXwitZN00l6CQF3bEhdPP6WPvQjrenC4/AcIwH+0fseK2RJZJo0'
			$Code &= 'inAj+8/wrSVvQ4d0hlYs6DbroAuBu6Ri2N2Slz04XyWVHyW5EkYqFyoQjN+WTyWNKTDaTJOJujlRWXWEdoijjpV51s3vCDl6WZAe'
			$Code &= 'W00yU1spWhMkdPMkVxVATrJ2GtNTkPvVI+TbkksQWfMEOd90eeh4d3fee3I+XyAzbQok0mjhZhSQBggkGCMILAKlQ53vOXixdhgn'
			$Code &= 'XhTg5QX36b4eQj3BANkZyYPhuVPp6XHT8U4EpRBACQfoJcC/YRUF3digD50zMFZsKOFp4XsnZoIB8mUFH8JnZ/U+QilRlKdJJDTa'
			$Code &= 'JHf454opCwFNDIP5BfCHHdQZzHyLzQsKP1bAv99F2PkHJ6WkPb37GnUJWAHtheYHQywQBB4Y6J7CkRhAHEeLsV+4+6XhUlqVAeyL'
			$Code &= 'VihCtD5fCBW5PM7zCCf44DGhAr2wCTlWZhgc/jFUagLoKeu+zq1qoIQPxsA1HwFe1hW1ragaHIYNRU4EnE0NHFUo/liyS/M4a1GI'
			$Code &= 'hydzhTlBwr0aJWQH0KOjAAl1BY1DAeteF4wiAiR9CXOJfAQKUXAduKlneQsTx++GcTs+6cRjRVAkmEgs9wLaGNKA4hBDwLvJuuGG'
			$Code &= '78omUhwMIQghGJAEGYM47wg1SsHCLgfOiBS6W8UcgRpJBEFuDBAJ5xchUgWmakImRSM7UcMmsgc2jdoSB+KWQty9sLaJikkMpVoo'
			$Code &= 'bzyDeNBIdB8hikDpKsxOFa2ElE6Hg4N6LIF0ETpTdQlnMHizIg69ot2LKFkxKi9CRSmVm48wgyAIweEMgb/K9EEWlkibfVYguH4U'
			$Code &= '0HwWpD8G2+Ds67B5atIXKgLCjUICxLA+weC6CQyDfmzQA+zJACC4hRBCCPfhOCnRl+mNElavC7ABDkTYrAUp993wJ54T6I+EZEAx'
			$Code &= 'Eg+3TzL+gNkfEzDldxSchYVDvGhMoSRXEMSR+ZMOErAQaFz7JHbFOQXJc2pP9zsCDHU2lPBLGQmhFXAgivfCUzH4FklQzfjpObTL'
			$Code &= 'YxuVfRFtdCxzMUoQDCCK9kEpXiQ+GP+SNLiJDLNOBiBnQeBCrNVyVpZiUpdCZaGxuw0GUVprO2YKnWhxSRRdzuBCoyBOc3mJjyPv'
			$Code &= 'KxTClTMYQ8Ig0M6rKfVgfci7VMjCiHfqxcIkvwyfTgZeyeJbrnLDC0GJ9+v5A69iUF2EJqfEUsXyKT4KuEFbsUi3AdH8VzCdgtz5'
			$Code &= 'uqxbYQq4w1QgrVuM7wKhsT0kUq2NMZBKrvGmugoQyenoJI9xSwsqB6tGZ3f6W6w2WEtlg8ECO7AMdgepgEkYjWBQJFYMdzVpioiy'
			$Code &= 'lGopUfGs6EmCZF8xZHiBixCkIYCL5rk6KEaytSO3dB8lm/yLipFtPp40KPIDW1jLu2cuoq7BB3UmO1f8tCGhnAPA6PK9UZISW4qT'
			$Code &= 'mlDlxxQfOWG86OC8kVlII0/IHwp1GYMlhOYT9Jr2qpEsOhbrimGhiBJRWpFfDML15ylAgOsptk4iESNm9RMY9mMDFEDoEOUH1USQ'
			$Code &= 'CFZ20DTtinV0BS4pTxOaplAQdAGfbWajppUmOdgOEICGRQwWAnULVui13pFZSoVQBXRFmbiILPzdRBCsqmSiMPz90+L40+L0SSR+'
			$Code &= '6Ogoc5QoUwzXWsBQiUZsyQZcImKa5zkXIVtdZEtiSja9tJT2FoSRn0YYQat/C3GTqVQrSLKJhYGxpootw10ekgRtVzGjjdkhMh8j'
			$Code &= 'M+9R8gk+RwrIC9Hr7uTZqH2l5rvbmpwTJ968erfkfvNcThrEbgK/D5RnRS0iQqb9CP9cGOi+un1AEJlNkP7g6AXj1his9cIgMclX'
			$Code &= 'itWvZMiHvOQCA4A4MTWgFxMPOCRwNA0V5H05WM/sBY1B/l8OQiATTnM5fdN1+C4su11vbFgkKIEkskgksxvaWEt4zNUjF/6lxH4T'
			$Code &= 'qwWay32EYIDr99vrtqg5mX4N8wIXz/ShaDqLCRhIAI4ID4ePUAF7EPUHHBWNLEv4GRkHLHkRuAlJp7KgHGujJBwEIRRhAPsIdQWJ'
			$Code &= 'RbgyWMPwOSjQjFa9MRJSMa5vKBIrhML4iXcc4UMYfkS7XjDNHTofuFIY7AgquA1h4DpQjVNCvlb+nAxMSAhUuhcYuKuqAvfhP9Hq'
			$Code &= 'rz5Mvc14LEQ6GfrYT3oLJVPRSWgSa3lJyBJzZtAkRKJTBmsWx4axABABagSJt5rQBb5QUb+3elGOEG4SzAvuOC6BVXYQRggLDHRN'
			$Code &= '0mjsR70vZIlB0GkUPYnKm2hGtwkESGJWwibc/m8jVRxXIqqY7I5RhD0snYDGRiQI6FkZ3xJeW3TI3MHoJpW4KUYYaJAq+JhR5CFv'
			$Code &= 'JAU2JhpD/p8a+hkSC0ZD63EWLtkXKpKH9RxE6lOaO5iz0mALCL/5yhcRuaY4w0XhCeSPuqAtXRC8g5eHtC87Up6mCnUqi7Ro0hNJ'
			$Code &= 'BE2W4EnBAm1EgV3Axn9TyCKFQMNYO0QBiwhbdBGDetr80gBqBVLo1vTQMYgUOb47G3RRW/VGCwHJaPzgt7jfSgLUIAwigDboPCsk'
			$Code &= 'SARVL4ZGGFcsJRkKBEaQCBmGEkQIBgZ8fIu4ogEZoFtjRkqhmebHVDQcOQwqiTgg0k2XevliUBQIUevqr0YPCLeC84D8DEgQlVPo'
			$Code &= 'kgO8K4kGXZJlQd8KwQvBDWHPwRHBE8EXwRvBH8EjwSvBMyEZwUMhS8FjwXMhOMGjwkFA4yvEFbrbs3CtAhERyBLkE3IUORUdmlRJ'
			$Code &= 'nhRH0qoRDZKKB46ZDYMZwSHBMcFBwWHBgcHBIU3HtgbP9gMPBE8Glw+4DO8Q7xjPIM8wz0DKYI5eioI6fjF2FpEFFyIYRBkaiRsS'
			$Code &= 'HCQdSECn0dwocu4QuMqhf8j3kcHh6Qne6kJA3UWkyAaoEKwgsEC0uIG8A8AmUFZ9LSAdDENm/wZETaSNTAhLQMCG7ot1sO1dDnQV'
			$Code &= 'uA+eT/B3fNKCqE9ZaQwBc/Jw9Bc5wXZWOR0W7/ApSCmziRCOy2tAmivBlAogbATxSAfHn4u88Sil8hwlV78QMPh2ZA2jfUcFR9HH'
			$Code &= 'cvPQ+XNfA+FPLyfNhfL4YB5VpMD2Kc54FkI/g/oWdu9TKQUWfhNNqAX/1Apfd14qyP9QlO+LRYbE4vKLH0wFhJkDCqQrhrUs2BtY'
			$Code &= 'HnJM6UuEdRzriJwpyeg8jg3sHcAU7zSsVcJciQRWiA35sxqNaCPT/AHIcteJ0CvCSrlaEbAlc0hMF3sWGf4jI9zCWKcI4HkBGOTr'
			$Code &= 'MPl1LDsaLQL7BRuvKQ1hoc3kP0XT6w3/GbcG3JMfE4nORiY9ZPB62KFQZ8wUMdv5OfidXeyGx41ItvbQyEDUFMz3LAH4BD1UA0wK'
			$Code &= 'GAL4C/hQz7UPahVgPy3o8F7CVIpV+IDa5CjaiPARobjoQsgCQIw58RJ9BsYYh2ojfmwbI8zgFgHAiod/htxKPxBm6BTyPDYSpEdI'
			$Code &= 'YDrfMDT4KdnxhZB97Lozj+Ln63RETDbIL400qKrHIJgwDLlAECnx5UGcOXWwVuyNSv+uvcBU7IXBdAYx0egMdfooUgEJjXj/Ic+v'
			$Code &= 'Zg+rA4NF6LSqjDkBkF6QfMPEdRs7wvTh3MwWcIqwArZFDAmI5u8oAGfKNvzChif+SoJ1zCH+g+PEO8PYNVgWI6F8Ae5d/J3w8KqV'
			$Code &= 'NwyCXpq2aINhjRQLRoavPXMcNnTKnBM+KfiA8AxCQV+Dx0KcM3Jm66LEeEDUCJl7jtPnyfoTZkokpHMIfYGRZJYLidKrGmUcsCLS'
			$Code &= 'yvzcGhaI4GIFh2n8hVSHvuQ2lRkEB8H5gWlF2DRhhvDpTXkPC4jQKFisqVNA66MREi5NEuilNVF6u02bHOwBzfg7plxgJ1rxZE2i'
			$Code &= 'MZfv9vhT7MLxJHjTWOguhAyGjlIChcd0B5BLULxySBvqspnDFEX/YpQIgk9VGNCLWQJZ2hYoQQysklspAlkLAWludmFs1GQgwwh0'
			$Code &= 'ZXI+FC92PW5nP2iPY29k9SPnLydzdJ+FY2V6HXZxb/pm9HLwYv31a8FaK+Z40v5yJg8mHwlEP3+J/wgBiQMSByQPSB+RPyJ/+wgB'
			$Code &= 'iQMSByQPSB+RPyJ//QgBiQMSByQPSB+RPyJ//lcBVlVTnIPsQCAedDokWCR+gRdWFogEgcKD7oClRCQsv3kHHmwdXBBOAF4MKc33'
			$Code &= '3QHkgXTpqpTfAc9cJDzTJDgo2DxnOkdeZk9QZWIIHQy49ilkVIKdSOMw/TIOWBMnQgSRpzDYVzTdGzddvMk4/m/FBl88T4MsWSQU'
			$Code &= 'YJV3CSKDwQuDOrgMd3eYxAt8JBzzBBHBh7pnqs1I89dIAusY98ZEOP8ouAmKBkaBHIPDCITECcXrxiFcXDyAIisLgzgCWAQTkNCj'
			$Code &= 'd3RQnXDdKJyLjjmBNMAg4J34WgwxwnRHeA8dooH75N0cdV47Hfmk7B5sUzMU1b14eElTK7hpPt8DtYPgvLxUBnUZ98IicIDwAn/r'
			$Code &= 'xMDL/Q7HG7eDWPsNIR68kAOTrh0XCel7IFuQgPsPLncNN4etiNmywxCSnncIguGFCCHqAIqRiOEo4w3T7YTAsIXGEKo5HbZs0BNl'
			$Code &= 'oWHqoN53xOla0xfqI42Io6gYNIT0t4Dh8HQBJTjLcxGIzU9Wf1npDMBIKMsh6NSov1RUGKV+bCwEyP8MaFxIhGhiRLJyZRdn6wkp'
			$Code &= 'hgIg+CtAxig5LdAP2eUwuRiJ/gQp1oPpA4GTiAfQRgHuVlwCWH32R/P5V54Sx2TFKeML6RB8ka6wFb31BSh0t08GOIoHbIspmwJ5'
			$Code &= 'BslYBALr6ehIxKhAEg+FEVBYgKb88tCqyGDQBIIp6bogiOUCVkIMNBnRhzbpo2j32SnzOKga4Vl3Yyok8jDJOkxbe2TGPxjoLSBg'
			$Code &= 'gp4QvetWyB1SWUiTQTCBuywDmII0XCnO5fKZMi4JBFdMvzAhHq40URQoDCYIrBaCiTn+ElW2HJqDbsWJ3TgKJPs0b9wOw0cEPxDV'
			$Code &= 'k+/J7IgGCOsDkAL+0wPBg/0gdxIyOPUGPkNFHUDz/o/FIOfrx/Tbw49+FAZv4+M/g5m2zDzJYZgnRoQfAnG66dPcdSLi4SkjzHQX'
			$Code &= 'ZrtuyIzsKQnFUuhxcM4CIwyCWgHKtXQil2QM8Ogc4EbqT638NhD0/4FbqxxXjZAWostnLZDYIqb80ZIWTd4r/YnxCOlq5X1J07sz'
			$Code &= 'Lxq1T3RFLegqk/1yEeCyjhKMCImHCI/65dEcu4rpyCVkr3hqjqu4tcbdUpDzTBc/qRK6oi08Jj8hIAM5ynZYx0kY497rZE4dSixA'
			$Code &= 'mzuQKOZBQipIN7YgVxowKBAkyCUIUgrpBnkhUbfogyw3EboaAOssqCB0DLncFQq6CxAFHOhEchwQhzXoShDuFYktWADPA4lIGLcm'
			$Code &= 'ghAksLIlCvkaIcHPif6OINTkE1Ac7DNBg9XhqAqxOXgMmVo8Ko1qlnQIORR1UJCLsN7MFQEQWJgCPOsLZBmJrdnMS6K5R/gkCFNk'
			$Code &= 'xcDkId2JUWrngU8583YKKdCDwzMLiXTrHBTe974zxhhw5jkDEDn7dg0poYHDLVVoPpsxGt/3y/rHpw948IPEQJ0EW11eX8PmWCdg'
			$Code &= 'IygIUDgJEDwUOHMMEgcfGXDICTAOCcADEAcKMxlgCSAnIaB8/caACWZAIeBBRAZYiRgTkIATBzuJeBI4J9ADEQeUSGiRKDawEYP4'
			$Code &= 'iMwJSCHwyIEEkVReHmIZ44ErEnQkNEjIkQ0iZEQkqIoEMIRMRCHo34FiRFwcyiGYxAwHUxl8zAk8Idip0BcSbCQsTLgRDMgJjJlM'
			$Code &= 'IfiRgQMiUlQSgKOJIxJyJDJIxJELImJEIqSJAhKCJEJI5LjEWokaEpQkQ0h6kToi1EQTaokqErQkCkiKkUoi9EQFVokWwUDjhEgz'
			$Code &= 'kXYiNkTMD4lmEiYkrEgGkYYiRkXs1iReSB6RnCJjRH4+idwSGyRuSC6RvCIORI5OifzCbABEURGSAE2DAMhxkTEjwpFhIiFEogGJ'
			$Code &= 'gRJBJOJyWSQZSJLkeUg5kdLIaZEpIrLrEokkSUjy5FVSodBCXAFsAER1NYnKHGWJJRKqJAVIhZFFI+qRXSIdR5oifUQ92o5EbS2J'
			$Code &= 'uhQIUI2RTSb6AOg0EhNJAMO5AHMSMyTGcmMkI0imoDBEg0PJIea5AFsSGySWcnskO0jW5GtIK5G2QFCLiUsS9m4ARFcXh5F3IjdH'
			$Code &= 'ziJnRCeuigRwh0hHk+5yAF8kH0ie5H9IP5HeyG+RLyK+gVCPEk8n/gu/ABHB8qE+R+HIkfnRHyOx5PF/I8nkqXzpj5GZ8tk+R7nI'
			$Code &= '+f5Hxcil+eUfI5Xk1Xy1j5H1/M2Pka3y7T5Hncjd+b0fI/35wx8jo+TjfJOPkdPysz5H8/LLPkeryOv5mx8j2+S7fPuP5Md8p4+R'
			$Code &= '5/KXPkfXyLf59x/Iz/mvHyPv5J9834+Rv/L/XF/iEAVB1xeoCH/xIK8b3xD7fKGXGY8QBBWSDOcdEEDQQPcxGBACFPJhBxyPECAS'
			$Code &= 'me4apBC1PkwLKkDCzUACgfIkGSIYBAciBgRhImAEBCIDBDEiMAQNIgwEwTQphz4ldIllPknDBvcRLQvDOHYMbf5il8YOuThb9kBL'
			$Code &= 'sMjKPHRknUIc3cjWXfxCczJKFAYIABjHQjCfE8YZGEgEBgwCIAQoCCwQMCA4HjyNiHDnx0AU4IDGT0hsBkBQTH3HJcAb5j/IFMSt'
			$Code &= '5o215ecle80Ji00JreP6j4V5vh321m3p9Z9ABjHb997rAA6J88H7BEODDv4wfQOm5g8wNXQWGIONBXwKFn4MXuaJX4gRR040hFwE'
			$Code &= 'unck+Nt9OUEovEnbyGUIvwahxzi0hpJR7atjQOgPb2l2l6gep6vUH1AQU9bqwUOEmxW8+I6SEIgUmogVKZqHhN5ACV6NQy3+W2m1'
			$Code &= 'iegYOfogJXUKWKYglSnIHigXJPUH1Z+tH9HyASBXaMwbbtyQx4g536Lf15ZU1oiwFFIKiX4cVp0ENOju/Yonw2FlFFE8JFdvjS5v'
			$Code &= 'ZmhsKonYMyu4+j0jti35hwAIUFFqD1Iv6DRTrEl++gXQdFPhUZsPTE/x0X0gvlBlOAY86jLbVlfAQn8pYYsejTQKIFMgE3ceV+ZR'
			$Code &= 'XgD7cDxPI31hEBYBeDhqycJrKdV6mhQFUegH9VW17RdAVLWQ/+r8hA9QBFgFS1n+OEo5AnMcg35ChV+CbXUrr9jkUyD9bcRLKJAb'
			$Code &= 'Uf/SkhokiUbDhXULX0sbXlkKkjkGCHUTZZ87yvswXgaAbigre0kQI1qHZ62EAP1WNFAQKcFREBt3aC9Mlyzg/zDcay/G/zXDK3e8'
			$Code &= 'EC34YeJ9B3o3RwM2MHRE+eFEdk1F/PzPdKGgQ4c6TjRXtfgFmujHChpWVIZ+MF/2UyxQYdEBTjBHoDkI8GlsTCz+wlhzgzLKS1+a'
			$Code &= 'JrGHg+gwV5VoFWMUvWXdGVgXg+5fpaJOCQo4fqIteXqUPw91fwsKBscHDFUmby1gdU3o0BDxJ0B+xQtfOHKh5tD6B7drciUy8Hbf'
			$Code &= 'S1CdT9ijAi8e4TISAOm2GMR5RwiJUQhJ6WptL+QEEHMiw9H8Ne+8H6oLWf/4BUjxiAZCg8YIlTABw0Vy3vbAcgJ0PoH7IB+LJXU2'
			$Code &= '21IIFJpHGOACjU3sWmbB3YtX8kg5/pmLTHI4bjes9tYBhEUCn/ogua8QxAiYmKAjQDCx/jOzATj2pUINw8Hg5ivk0QFMyKcnuehV'
			$Code &= '9/G/DjNoh4OJ2oDi1zD6CHQVkj7Uv4cY9xotSBgKWemgEVwDJMHrBBN6g+G/HnI7fKTnfzpNTyaJaqgosUCJVxToUn+eKE1C3WCB'
			$Code &= '99OD4wLMywmrqppBYQ0fRLQGselXn5WFAcUgJlDoaqBoQRgQWOk4k0VW6DoIEkIwP+kjEZNEZ3j43JjQ6oBQ+8ES2bOILVhW4kAQ'
			$Code &= '90/DveJrNdgKFei8GdjEyBAiIEktCiMWQNwB8UWzTEICWR5IiHBFwlN8VcYWZe1QGPg7EoOYNXsiedtEe0QC65QaFCCfodkQD8gg'
			$Code &= 'IWsSA7HuGGQui1H0eq353uBK6gYEjUXcOU3tmFXuNu+LLE8YDpUPdLIDORAKI2VREAo1Fsq7hgRxgfcIlqog61iUSEEMr+timJc8'
			$Code &= 'RQQHMYiUYX6z55x7UJRArPVSFG6iTRpG1FMqbsXrDmS4lMSNz5D8BebmbJMbQkDnr+dhQcgXTz885WFzUt2D2D66ScnA1JkVNLwg'
			$Code &= '9EoUMStPWlIYgSbkAcE50b9evFX8a9Dd+Bk51AP8q+3ici2YrCl1KRdmGh7EJEX4lYbuRTWIlimiklMpvLE6wtGDEeuDf9roQ+EO'
			$Code &= 'gcejIK0RBsgITjFWKjW9SahbDbYMEHCq2RyCkSS1Ib4RQa6MF9ZAfTuYTG8P0OqKmCfQ4mj/ppRHfcqOGQjvOwFyv0qfZVxNJbFX'
			$Code &= 'rrmdFOmVn6kENlCgnH2KnlJDHEKsnGO5R4gR1kYkiCjdkT24mUYNyCRrax6FYktFZ3yIaw3cl0DDGDlZy/PErhVx1QwEiWI3GEHF'
			$Code &= 'MHb5WAn4hEgs1Cv2dV1+hZaUyspZv4vHy0aB6Zimh/J55/43Jtymaxbg/hyAIpB8mXi7feYlqQ/IprnzvCnYXiZmxApT7EbOSrSJ'
			$Code &= 'siwQVQiiKAihj6OJMf4MBQJoLBUGgV4JL9KXFIiJ0gEH0+spzpFSGhrp5l8FkAMosjWNRAMh0etFp1IRukknT3cgVndY6XyWXCCq'
			$Code &= 'ZAKcDUKD7gNjbEuj4BpzQfcCfMf6H7XjRkBJHtWKJC8QcmYqh2INFDMiNh2GL0VIDbIEsBS0WfGOCx+B99El/2+zS1gDV+cRiRPE'
			$Code &= '7gpkJZ4MN0DgDosipjveGC4/ySnYyCGTBotYyEe2GEfwQiBSbEm+xEXoISlucywuARoku7MG8C4S6DjLIxDpe0Dzog6lxB/K4fkO'
			$Code &= 'CQL0H0AEBYHpPyTWgQdPYLEdLeAfkzIPqluaHp/Q7g6BfyhgHiEwR2REXA+HT99zdNaEFu1oxQcR+E6fWDtEc06R6+JKCjcYi3jo'
			$Code &= 'TEvzsoIpQYwSB6iMH0dw9iyRyPQDOeGdcrK4ItwxOSxzHWsMMldmGYYlDFH8nUVPGDA7cuUvjYeuj8JPbInATEdM/JdZ8Kw/UvoL'
			$Code &= 'VFBRx/nGDGoTGnD7NM2iQt5VMCDNRVnYhCckEK6vEY4mNAks4nIRMOkiUwnoyBJKChwD2GDtD4NrAc3wU7Ta70FMSCHY2ASBJ4nB'
			$Code &= 'CFL4EsnQH/F2P5MMCD4J01JtD1EMCjxVGwo/z3e0Dy8QCrZaIxkPOc6KJ1VNHk5h0lkgLMyNTnLZD1RpyI1moen2ImOG6TntixEY'
			$Code &= 'sXVhS41BTAJ9Ctw5xlnEkG2VVNyukCdtwk6hslako0Ygm+y3y7RuKbqOt2nAdYwZm+Sqv4/FK+l6nc3PEcuMxXVFhgOlZxEpqAOO'
			$Code &= '0MhVIgfSn0sXuPjT5d1DlEIHRaPk5D8jB2R/CAthB7j5Fexnmh5XqeQzvfrBTtrwd2RjsvS1NrY4MbD5PoSNjWsBF3XsMwGFgv9C'
			$Code &= 'j4M/HYSEAlDmFr9wkZJ1NjNUEQQPxOAGUBIRxQ7IzkkQZr8Ojmm8JR3EpPQTYHLHCS/zMMYB6Nxp2/AWw1sVcspEsWBuCFdRbEvZ'
			$Code &= 'UGINyFggz2RgkgbZxaYyQIBSagLoj9uzE8swzdoNjmshYZZnget1siEYFHGsvg5yboHawEsCy2VAb4rog/5uZwwS+Gwd4PZQYxAi'
			$Code &= '/FE8DgT7vskCdzzoIHWIUyoLUAzr4XwogtXqo/Lsn2haPwu+4ssB3Q+FrC9JY4d7SY/pnfZpbwkZBAHSN4lJvUx+EyA7exHDBb8S'
			$Code &= 'hMC6MdCo8EOMsEURHziBQSIh4YkMyAOR59xZSbQajbpLDfQisgHIlJTbUGR+o2botcAuCjnwdlaYxCtknbYSn0KMlSDF2Vi3yTGP'
			$Code &= 'CldN2JFdTGl/Wt7lPZWzgVXWhkasMXeq092LBMiYiUiPHZDPogGoDhi1mo1Q4E9ASoTIKRmEIEQEvYS7FY5sTmJtK4QZQNwSpUcL'
			$Code &= 'NA8tUv2GJ45kSFQVzVDmaTpAYZV3+xBPBOw7IndI0Wzc0JFF1exHQKKbM6N7NKG6yBasQhZ/SljiQ5TjyFBWKUCQcAnfAzzkR1jI'
			$Code &= 'UNSv3HFQHoRPA3uIUPxGAeUsrNxHCRRjAitpkUlF4CWxftVPCV4XHbQImwJ3kESmmlwYDMzwhVmKafYrz+66T0QEyFcpIzvjLNAb'
			$Code &= 'g79uwFsS5h8RFwnNw6uZuDBZDwYSPjQDNyhlscHrC7YbDh54MIKplxMas9w+TxX0LusOaLQ49UVIftzTYto3aTTUXUbcRfromunK'
			$Code &= 'FtSRPONX6wMMF4oMAS+IJQhADdha5HXslRhCQQG51kPpNt0oz4r1FkjvoogwRfAMJBKEIn8IcK+8kNBXAY3NlkcaOC/w9yRBFEEb'
			$Code &= 'HJz8koApUjQnVxhiz9UgyVFSdAf+nF6I4iQ7tN9tAQYghomF4PTYdV4jJMa4OCbhjklyP7bnaXhjhBBmGA47biZ0Dw9ijAcw61e8'
			$Code &= '6GQbMgglkUgKEJWHyeOOhG4CO18cdFdGyCMVBy2ZU4v62hsUhnHtuU+EOf8pZqXQGhtRGCDAlBK3FmliFFAQS14JF1v0+kgraKHE'
			$Code &= 'HFOg4gGJ6/dLE1D3Re0DviiEs1w/dfwJPxp9LihnnI87QcV0Iw8LXWPoautUfGsUyLAep/nb6JuQdQNF0CtGBFBSnl6QTfNr145q'
			$Code &= '4SkfJ2B2dDG1BJ0tiCJTvWEVVqj4VC8p2gKH+IYC6w9dxKHJItl4QycGh8QtnwqwBkETdAxCtgh8oWEOdQdEDIzpBL9KFvUDDuFA'
			$Code &= 'LzALWBGwZQYISoHigFE+AcoSVzwMe9DqVhEsdQQtBtK39BlOi1KUBaCx/qsilPueudQyYLUQbhikvooiEnQ9+ycedDa/jBUv/EC3'
			$Code &= 'JDEKvo6kIE5BVv0kQb//0Gstdj8S++8rmVRHVpVShW/EQ4tzVt9EuUaDfuK1QuKHaxGjPgpLCvir9iMldSdsQyLphRJNDFfuDBPe'
			$Code &= 'FztMRpl9yFn9UItDCRDoxekYpRJfJMcGpmqlIx6gsdN78L05Fsd2JQUoUAGpwBYhYaf6QfjdLEe7ef6h6DIseAf6UQGMSvxbYOIz'
			$Code &= 'BYl+LF9tIi/yVPIgMBn272oNDRPnbgX3x0GtU5L/Klt0780KrS54jhJ2QVO/ABsEczWKFGAwEAIZ/4E05wFRwz3ay8fmeQA5+3UD'
			$Code &= 'QesRhAfSdAQxyYMJurYpAynKidFAOxp4csaRfUDkCl1Jw2bIV0TKInvWN0e/CL3kaHWAYn88CFtzgi37/zoYQO4fViZ0T5IEPInB'
			$Code &= 'uXIGZzgpyMJfx9V98a8gTPgkCHLgA3c4ileft+ixiFQN/MHu7kFoiSIcQXPnjeFoIZDWYSrHaEWF6Cj/zGuLWEsKKjMbMOgWJQFD'
			$Code &= 'CHMpdgRIA/R40DuDPmhIuhBeX6fYDlMUVxMZBWOs5Y2h705OuDwnXpk/X3+dzH7ay1ZsIyECGoM4DVVAtXg8oeAJLGCQJV6KMslR'
			$Code &= 'XSLZU1ZCDuqcQt3dFtFlXorb84Je4UB5jSIVkJW9aXsLQRVOKHpwjlH/0Ia3CwzQdUg6Uy40Yb9wi+o7hPQk1Uu5cploIKVc/LZt'
			$Code &= 'WrFEqnUbZiYjVy3uy5uGoJmX8Y4iZijzpZxQ/KfoJIVeDYdDTI3ry9Faj6CNNvqTabxF3wDcLCnYLaAYwfgKAo2Ehgot2GuBglBw'
			$Code &= 'RoFU6Rj5gJSOhjNWUIxsKcQMMmSMYU5sUsUYkLhDNI6/6veJmxrwyv9B8zRgGHFaHOOyS+zK5hqdcxtEGpiHE78WuabbnXFI2U5I'
			$Code &= 'LUf9MAj5Jw91/vA/+r8S5nRkCQHImJH5GLXhb4hpwSsrHegPSQihEetiWrLh/0ziSFkAEBqkfJk7FgOsIgLIWln/4H+wll2LgLOM'
			$Code &= 'gFKNgcaICTuOEbkQZo8QEpAityBEkUShyIncEZSSscMJBZMCYSTZRMGUBMWXCMuI1pkILJoIipsR1xCmnCLKIImdICqeRDOCihyf'
			$Code &= 'RrmjNjLPRwllJHZLWFRx4WNvcsVl1uJaf7urnhpoa5Qe8v9kPoQcWliiq70/zu31qjstnb146eaIgkDchCNOUb4j2MhGkErPYjTr'
			$Code &= 'tA/ZcCphTvoOf64tPhtt5o4oe2fPWGTHb2YzYmytOdcI622hkHlZSkQlOeLceW0fYm9saVd6NKKPmLZ8indl71RnZCh5JAgddCR5'
			$Code &= 'cCBahpFhrs76Y3ypsCCTSHSjRhsOdW5rR293VSA0I+/Ci2dPPqncSEXK3nRudxK7jHtwJHplVFyMY8aSbXCUqy/uGPWUxGjrcMAA'
			$Var_Opcode &= '0x89C0608B7424248B7C2428FCB28031DBA4B302E86D00000073F631C9E864000000731C31C0E85B0000007323B30241B010'
			$Var_Opcode &= 'E84F00000010C073F7753FAAEBD4E84D00000029D97510E842000000EB28ACD1E8744D11C9EB1C9148C1E008ACE82C000000'
			$Var_Opcode &= '3D007D0000730A80FC05730683F87F770241419589E8B3015689FE29C6F3A45EEB8E00D275058A164610D2C331C941E8EEFF'
			$Var_Opcode &= 'FFFF11C9E8E7FFFFFF72F2C32B7C2428897C241C61C389D28B442404C70000000000C6400400C2100089F65557565383EC1C'
			$Var_Opcode &= '8B6C243C8B5424388B5C24308B7424340FB6450488028B550083FA010F84A1000000733F8B5424388D34338954240C39F30F'
			$Var_Opcode &= '848B0100000FB63B83C301E8CD0100008D57D580FA5077E50FBED20FB6041084C00FBED078D78B44240CC1E2028810EB6B83'
			$Var_Opcode &= 'FA020F841201000031C083FA03740A83C41C5B5E5F5DC210008B4C24388D3433894C240C39F30F84CD0000000FB63B83C301'
			$Var_Opcode &= 'E8740100008D57D580FA5077E50FBED20FB6041084C078DA8B54240C83E03F080283C2018954240CE96CFFFFFF8B4424388D'
			$Var_Opcode &= '34338944240C39F30F84D00000000FB63B83C301E82E0100008D57D580FA5077E50FBED20FB6141084D20FBEC278D78B4C24'
			$Var_Opcode &= '0C89C283E230C1FA04C1E004081189CF83C70188410139F374750FB60383C3018844240CE8EC0000000FB654240C83EA2B80'
			$Var_Opcode &= 'FA5077E00FBED20FB6141084D20FBEC278D289C283E23CC1FA02C1E006081739F38D57018954240C8847010F8533FFFFFFC7'
			$Var_Opcode &= '4500030000008B4C240C0FB60188450489C82B44243883C41C5B5E5F5DC210008D34338B7C243839F3758BC7450002000000'
			$Var_Opcode &= '0FB60788450489F82B44243883C41C5B5E5F5DC210008B54240CC74500010000000FB60288450489D02B442438E9B1FEFFFF'
			$Var_Opcode &= 'C7450000000000EB9956578B7C240C8B7424108B4C241485C9742FFC83F9087227F7C7010000007402A449F7C70200000074'
			$Var_Opcode &= '0566A583E90289CAC1E902F3A589D183E103F3A4EB02F3A45F5EC3E8500000003EFFFFFF3F3435363738393A3B3C3DFFFFFF'
			$Var_Opcode &= 'FEFFFFFF000102030405060708090A0B0C0D0E0F10111213141516171819FFFFFFFFFFFF1A1B1C1D1E1F2021222324252627'
			$Var_Opcode &= '28292A2B2C2D2E2F3031323358C3'
		EndIf
		$Var_Opcode = Binary($Var_Opcode)
		Local $CodeBufferMemory = __MemVrAlloc(0, BinaryLen($Var_Opcode), 0x1000, 0x40)
		Local $CodeBuffer = DllStructCreate("byte[" & BinaryLen($Var_Opcode) & "]", $CodeBufferMemory)
		DllStructSetData($CodeBuffer, 1, $Var_Opcode)
		Local $CodeBufferPtr = DllStructGetPtr($CodeBuffer)
		Local $B64D_State = DllStructCreate("byte[16]")
		Local $Length = StringLen($Code)
		Local $output = DllStructCreate("byte[" & $Length & "]")
		DllCall($g___User32DLL, "int", 'CallWindowProc', "ptr", $CodeBufferPtr + ((StringInStr($Var_Opcode, "89F6") - 3) / 2), "str", $Code, "uint", $Length, "ptr", DllStructGetPtr($output), "ptr", DllStructGetPtr($B64D_State))
		Local $ResultLen = DllStructGetData(DllStructCreate("uint", DllStructGetPtr($output)), 1)
		Local $Result = DllStructCreate("byte[" & ($ResultLen + 16) & "]")
		Local $Ret = DllCall($g___User32DLL, "uint", 'CallWindowProc', "ptr", $CodeBufferPtr + ((StringInStr($Var_Opcode, "89C0") - 3) / 2), "ptr", DllStructGetPtr($output) + 4, "ptr", DllStructGetPtr($Result), "int", 0, "int", 0)
		__MemVrFree($CodeBufferMemory, 0, 0x8000)
		$Var_Opcode = 0
		Local $Opcode = String(BinaryMid(DllStructGetData($Result, 1), 1, $Ret[0]))
		$Z_DefInit = (StringInStr($Opcode, "FF01") + 1) / 2
		$Z_DefInit2 = (StringInStr($Opcode, "FF02") + 1) / 2
		$Z_Def = (StringInStr($Opcode, "FF03") + 1) / 2
		$Z_DefEnd = (StringInStr($Opcode, "FF04") + 1) / 2
		$Z_DefBound = (StringInStr($Opcode, "FF05") + 1) / 2
		$Z_InfInit = (StringInStr($Opcode, "FF21") + 1) / 2
		$Z_InfInit2 = (StringInStr($Opcode, "FF22") + 1) / 2
		$Z_Inf = (StringInStr($Opcode, "FF23") + 1) / 2
		$Z_InfEnd = (StringInStr($Opcode, "FF24") + 1) / 2
		$Opcode = Binary($Opcode)
		$Z_BufferMemory = __MemVrAlloc(0, BinaryLen($Opcode), 0x1000, 0x40)
		$Z_Buffer = DllStructCreate("byte[" & BinaryLen($Opcode) & "]", $Z_BufferMemory)
		DllStructSetData($Z_Buffer, 1, $Opcode)
		$Z_BufferPtr = DllStructGetPtr($Z_Buffer)
		$Z_DefInit += $Z_BufferPtr
		$Z_DefInit2 += $Z_BufferPtr
		$Z_Def += $Z_BufferPtr
		$Z_DefEnd += $Z_BufferPtr
		$Z_DefBound += $Z_BufferPtr
		$Z_InfInit += $Z_BufferPtr
		$Z_InfInit2 += $Z_BufferPtr
		$Z_Inf += $Z_BufferPtr
		$Z_InfEnd += $Z_BufferPtr
		$Z_Alloc_Callback = DllCallbackRegister("__ZL_Alloc", "ptr:cdecl", "ptr;uint;uint")
		$Z_Free_Callback = DllCallbackRegister("__ZL_Free", "none:cdecl", "ptr;ptr")
		OnAutoItExitRegister("__ZL_Exit")
	EndFunc

	Func __ZL_GZUncompress($Data)
		If Not IsDllStruct($Z_Buffer) Then __ZL_Startup()
		Local $Stream = DllStructCreate('ptr next_in;uint avail_in;uint total_in;ptr next_out;uint avail_out;uint total_out;ptr msg;ptr state;ptr zalloc;ptr zfree;ptr opaque;int data_type;uint adler;uint reserved')
		DllStructSetData($Stream, "zalloc", DllCallbackGetPtr($Z_Alloc_Callback))
		DllStructSetData($Stream, "zfree", DllCallbackGetPtr($Z_Free_Callback))
		DllCall($g___User32DLL, "int", 'CallWindowProc', "ptr", $Z_InfInit2, "ptr", DllStructGetPtr($Stream), "int", 16 + 15, "int", 0, "int", 0)
		Local $SourceLen = BinaryLen($Data)
		Local $DestLen = $SourceLen * 2
		Local $Source = DllStructCreate("byte[" & $SourceLen & "]")
		Local $Dest = DllStructCreate("byte[" & $DestLen & "]")
		Local $DestPtr = DllStructGetPtr($Dest)
		DllStructSetData($Source, 1, $Data)
		DllStructSetData($Stream, "next_in", DllStructGetPtr($Source))
		DllStructSetData($Stream, "avail_in", $SourceLen)
		Local $Ret = Binary(""), $Error
		Do
			DllStructSetData($Stream, "next_out", $DestPtr)
			DllStructSetData($Stream, "avail_out", $DestLen)
			$Error = DllCall($g___User32DLL, "int", 'CallWindowProc', "ptr", $Z_Inf, "ptr", DllStructGetPtr($Stream), "int", 0, "int", 0, "int", 0)[0]
			If $Error = 2 Or $Error < 0 Then
				DllCall($g___User32DLL, "int", 'CallWindowProc', "ptr", $Z_InfEnd, "ptr", DllStructGetPtr($Stream), "int", 0, "int", 0, "int", 0)
				Return SetError($Error, 0, $Ret)
			EndIf
			Local $AvailOut = DllStructGetData($Stream, "avail_out")
			$Ret &= BinaryMid(DllStructGetData($Dest, 1), 1, $DestLen - $AvailOut)
		Until $AvailOut <> 0
		DllCall($g___User32DLL, "int", 'CallWindowProc', "ptr", $Z_InfEnd, "ptr", DllStructGetPtr($Stream), "int", 0, "int", 0, "int", 0)
		Return $Ret
	EndFunc
#EndRegion


#Region <UDF WinHttp by Trancexx, ProAndy>
	Func _WinHttpQueryHeaders2($hRequest, $iInfoLevel = 22)
		Local $aCall = DllCall($g___WinHttpDLL, "bool", "WinHttpQueryHeaders", "handle", $hRequest, "dword", $iInfoLevel, "wstr", '', "wstr", "", "dword*", 65536, "dword*", 0)
		If @error Or Not $aCall[0] Then Return SetError(1, 0, "")
		Return $aCall[4]
	EndFunc

	Func _WinHttpAddRequestHeaders2($hRequest, $sHeader, $iModifier = Default)
		DllCall($g___WinHttpDLL, "bool", "WinHttpAddRequestHeaders", "handle", $hRequest, "wstr", $sHeader, "dword", -1, "dword", 0x10000000)
	EndFunc

	Func _WinHttpOpen2($sUserAgent = Default)
		If Not $sUserAgent Or $sUserAgent = Default Then $sUserAgent = $g___iUserAgentBk
		Local $aCall = DllCall($g___WinHttpDLL, "handle", "WinHttpOpen", "wstr", $sUserAgent, "dword", 1, "wstr", '', "wstr", '', "dword", 0)
		If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
		Return $aCall[0]
	EndFunc

	Func _WinHttpSendRequest2($hRequest, $sHeaders = '', $vOptional = '', $iTotalLength = 0)
		Local $pOptional = 0, $iOptionalLength = 0
		If @NumParams > 2 Then
			Local $tOptional
			$iOptionalLength = BinaryLen($vOptional)
			$tOptional = DllStructCreate("byte[" & $iOptionalLength & "]")
			If $iOptionalLength Then $pOptional = DllStructGetPtr($tOptional)
			DllStructSetData($tOptional, 1, $vOptional)
		EndIf
		If Not $iTotalLength Or $iTotalLength < $iOptionalLength Then $iTotalLength += $iOptionalLength
		Local $aCall = DllCall($g___WinHttpDLL, "bool", "WinHttpSendRequest", "handle", $hRequest, "wstr", $sHeaders, "dword", 0, "ptr", $pOptional, "dword", $iOptionalLength, "dword", $iTotalLength, "dword_ptr", 0)
		If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
		Return 1
	EndFunc

	Func _WinHttpConnect2($hSession, $sServerName, $iServerPort, $iServerScheme = 1)
		Local $aCall = DllCall($g___WinHttpDLL, "handle", "WinHttpConnect", "handle", $hSession, "wstr", $sServerName, "dword", $iServerPort, "dword", 0)
		If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
		_WinHttpSetOption2($aCall[0], 45, $iServerScheme)
		Return $aCall[0]
	EndFunc

	Func _WinHttpSetTimeouts2($hInternet, $iTimeout = 30000)
		DllCall($g___WinHttpDLL, "bool", "WinHttpSetTimeouts", "handle", $hInternet, "int", 0, "int", $iTimeout, "int", $iTimeout, "int", $iTimeout)
	EndFunc

	Func _WinHttpCloseHandle2($hInternet)
		DllCall($g___WinHttpDLL, "bool", "WinHttpCloseHandle", "handle", $hInternet)
		Return ''
	EndFunc

	Func _WinHttpOpenRequest2($hConnect, $sVerb = 'GET', $sObjectName = '', $sReferrer = '', $iFlags = 0x40, $sVersion = 'HTTP/1.1')
		Local $aCall = DllCall($g___WinHttpDLL, "handle", "WinHttpOpenRequest", "handle", $hConnect, "wstr", StringUpper($sVerb), "wstr", $sObjectName, "wstr", StringUpper($sVersion), "wstr", $sReferrer, "ptr", 0, "dword", $iFlags)
		If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
		Return $aCall[0]
	EndFunc

	Func _WinHttpReceiveResponse2($hRequest)
		Local $aCall = DllCall($g___WinHttpDLL, "bool", "WinHttpReceiveResponse", "handle", $hRequest, "ptr", 0)
		If Not @error And $aCall[0] Then Return 1
	EndFunc

	Func _WinHttpSetOption2($hInternet, $iOption, $vSetting)
		Local $iSize = -1, $sType
		If IsBinary($vSetting) Then
			$iSize = DllStructCreate("byte[" & BinaryLen($vSetting) & "]")
			DllStructSetData($iSize, 1, $vSetting)
			$vSetting = $iSize
			$iSize = DllStructGetSize($vSetting)
		EndIf
		Switch $iOption
			Case 2 To 7, 12, 13, 31, 36, 58, 63, 68, 73, 74, 77, 79, 80, 83 To 85, 88 To 92, 96, 100, 101, 110, 118
				$sType = "dword*"
				$iSize = 4
			Case 1, 86
				$sType = "ptr*"
				$iSize = 4
				If @AutoItX64 Then $iSize = 8
				If Not IsPtr($vSetting) Then Return SetError(3, 0, 0)
			Case 45
				$sType = "dword_ptr*"
				$iSize = 4
				If @AutoItX64 Then $iSize = 8
			Case 41, 0x1000 To 0x1003
				$sType = "wstr"
				If (IsDllStruct($vSetting) Or IsPtr($vSetting)) Then Return SetError(3, 0, 0)
				If $iSize < 1 Then $iSize = StringLen($vSetting)
			Case 38, 47, 59, 97, 98
				$sType = "ptr"
				If Not (IsDllStruct($vSetting) Or IsPtr($vSetting)) Then Return SetError(3, 0, 0)
			Case Else
				Return SetError(1, 0, 0)
		EndSwitch
		If $iSize < 1 Then
			If IsDllStruct($vSetting) Then
				$iSize = DllStructGetSize($vSetting)
			Else
				Return SetError(2, 0, 0)
			EndIf
		EndIf
		DllCall($g___WinHttpDLL, "bool", "WinHttpSetOption", "handle", $hInternet, "dword", $iOption, $sType, IsDllStruct($vSetting) ? DllStructGetPtr($vSetting) : $vSetting, "dword", $iSize)
	EndFunc

	Func _WinHttpSetProxy2($hInternet, $sProxy = "", $sProxyBypass = "")
		Local $tProxyInfo = DllStructCreate("dword AccessType;ptr Proxy;ptr ProxyBypass")
		DllStructSetData($tProxyInfo, "AccessType", $sProxy ? 3 : 1)
		Local $tProxy = DllStructCreate("wchar[" & StringLen($sProxy) + 1 & "]")
		DllStructSetData($tProxy, 1, $sProxy)
		Local $tProxyBypass = DllStructCreate("wchar[" & StringLen($sProxyBypass) + 1 & "]")
		DllStructSetData($tProxyBypass, 1, $sProxyBypass)
		If $sProxy Then
			DllStructSetData($tProxyInfo, "Proxy", DllStructGetPtr($tProxy))
			DllStructSetData($tProxyInfo, "ProxyBypass", DllStructGetPtr($tProxyBypass))
		EndIf
		Local $aCall = DllCall($g___WinHttpDLL, "bool", "WinHttpSetOption", "handle", $hInternet, "dword", 38, "ptr", DllStructGetPtr($tProxyInfo), "dword", DllStructGetSize($tProxyInfo))
		If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
		Return 1
	EndFunc
#EndRegion


#Region <Chạy code javascript>
	Func _JS_ToStringAu3($jsBeauty = False)
		Local $jsCode = ClipGet()
		If Not $jsCode Then Return SetError(1, MsgBox(4096, 'Lỗi', 'Hãy copy đoạn js cần chuyển thành string Au3 trước khi chạy hàm này'), '')
		If $jsBeauty Then
			$jsCode = _JS_Beauty($jsCode)
			If @error Or Not $jsCode Then Return SetError(2, '', '')
		EndIf
		$jsCode = StringStripCR(StringRegExpReplace($jsCode, '(?m)^[\s\t]*$[\r\n]+', ''))
		$jsCode = StringRegExpReplace(StringReplace($jsCode, "'", "''", 0, 1), '(?m)^', "'")
		$jsCode = StringTrimRight(StringRegExpReplace($jsCode, '(?m)($)', "' & @CRLF & _"), 3)
		ClipPut($jsCode)
		Return $jsCode
	EndFunc

	Func _JS_Beauty($jsCode)
		$jsCode = _HttpRequest(2, 'http://javascriptbeautifier.com/compress', 'js_code=' & _URIEncode($jsCode) & '&js_code_result=&beautify=true')
		$jsCode = StringRegExp($jsCode, '(?s)"mini":"(.+?)"\}$', 1)
		If @error Or StringInStr($jsCode[0], 'undefined","error"', 0, 1, 1, 30) Then Return SetError(1, '', '')
		$jsCode = StringReplace($jsCode[0], '\n', @CRLF)
		$jsCode = StringRegExpReplace($jsCode, '\\([''"])', '$1')
		Return $jsCode
	EndFunc

	Func _JS_Execute($LibraryJS, $sCodeJS, $Name_Var_Return_Val, $SaveTempLibJS = True, $PathTempLibJS = Default)
		Local $oError = ObjEvent("AutoIt.Error", "___ObjectErrDetect")
		Local $oIE = ObjCreate("InternetExplorer.Application")
		If Not IsObj($oIE) Then Return SetError(1, 0, '')
		If FileExists($PathTempLibJS) Then
			If StringRight($PathTempLibJS, 1) <> '\' Then $PathTempLibJS &= '\'
		Else
			$PathTempLibJS = ''
		EndIf
		Local $TempPath, $hOpen, $iError = 0
		With $oIE
			.navigate("about:blank")
			If @error Then $iError = 300
			If $LibraryJS Or IsArray($LibraryJS) Then
				If Not IsArray($LibraryJS) Then $LibraryJS = StringSplit($LibraryJS, '|', 2)
				For $i = 0 To UBound($LibraryJS) - 1
					If StringRegExp($LibraryJS[$i], '^https?://') Then
						$TempPath = $PathTempLibJS & StringRight(_B64Encode(StringToBinary(StringRegExpReplace($LibraryJS[$i], '(https?://|/|\.|.js)', '')), 0, True), 200) & '.js'
						If FileExists($TempPath) Then
							$LibraryJS[$i] = FileRead($TempPath)
						Else
							$LibraryJS[$i] = _HttpRequest(2, $LibraryJS[$i])
							If @error Or Not $LibraryJS[$i] Then $iError = 301
							If $SaveTempLibJS Then
								$hOpen = FileOpen($TempPath, 2 + 32 + 8)
								FileWrite($hOpen, $LibraryJS[$i])
								FileClose($hOpen)
							EndIf
						EndIf
					Else
						$LibraryJS[$i] = FileRead($LibraryJS[$i])
					EndIf
					.document.parentwindow.execScript($LibraryJS[$i])
					If @error Then $iError = 302
				Next
			EndIf
			If StringRight($sCodeJS, 1) <> ';' Then $sCodeJS &= ';'
			$sCodeJS &= 'document.write(' & $Name_Var_Return_Val & ');'
			.document.parentwindow.execScript($sCodeJS)
			If @error Then $iError = 303
			$sResult = .document.body.innerHTML
			If @error Then $iError = 304
			.quit()
		EndWith
		$oIE = 0
		$oError = 0
		Return SetError($iError, '', $sResult)
	EndFunc
	Func ___ObjectErrDetect()
	EndFunc
#EndRegion