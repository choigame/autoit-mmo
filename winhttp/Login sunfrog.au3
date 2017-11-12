#cs
	$cookieVisitPage: cookie lan dau vao page. Tuy site ma su dung cho POST login
	$dataLogin : static hay dynamic. Demo nay $dataLogin la static
	$cookieAfterLogin : cookie su dung xuyen suot website cho 1 session
#ce

#include 'lib\_HttpRequest.au3'

$url = "https://manager.sunfrogshirts.com/"
$data = _HttpRequest(1, $url) ; 1 = get Header, 2 = get code html
$cookieVisitPage = _GetCookie($data)

ConsoleWrite("Cookie Viist Page = " & $cookieVisitPage)

$dataLogin = "username=dactandn%40gmail.com&password=handoi11&login=Login"
$urlLogin = "https://manager.sunfrogshirts.com/"
$referer  = "https://manager.sunfrogshirts.com/"

$data = _HttpRequest(1, $urlLogin, $dataLogin, $cookieVisitPage, $referer)
$cookieAfterLogin  = _GetCookie($data)

ConsoleWrite(@CRLF & "Cookie After Login = " & $cookieAfterLogin)

$location = "https://manager.sunfrogshirts.com/index.cfm?dashboard"

; trang chuyen tiep sau khi login hoac url cua thread nao do
; https://autoitvn.com/threads/cho-minh-xin-vi-du-ve-ocr-voi.940/

$data = _HttpRequest(2, $location, '', $cookieAfterLogin, $referer)
$headerLocation = _HttpRequest(1, $location, '', $cookieAfterLogin, $referer)
$cookieFinal  = _GetCookie($headerLocation)

ConsoleWrite(@CRLF & "Cookie Final = " & $cookieFinal &@CRLF)

$output = @ScriptDir & '\output\login.' & @MSEC & '.html'
FileWrite($output,$data)
;ShellExecute($output)

Local $designURL = 'https://manager.sunfrogshirts.com/Designer/php/upload-handler.cfm'

;afer finish upload : https://manager.sunfrogshirts.com/my-art-edit.cfm?editNewDesign

Local $dataUpload = '{'      & _
 '"ArtOwnerID":0,"IAgree":true,' & _
'"Title":"Autoit Tshirt",' & _
'"Category":"43",' & _
'"Description":"Autoit",' & _
'"Collections":"gun",' & _
'"Keywords":["tag1","tag2","tag3"],' & _
'"imageFront":"<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" viewBox=\"311.00000000008 150 387.99999999984004 517.33333333312\" height=\"3200\" width=\"2400\" version=\"1.1\" id=\"SvgjsSvg1000\"><g transform=\"scale(0.14495238095232 0.14495238095232) translate(2233.9027595284033 1069.3166885681237)\" id=\"SvgjsG1054\"><image height=\"3500\" width=\"2500\" xlink:href=\"__dataURI:0__\" id=\"SvgjsImage1055\"></image></g><defs id=\"SvgjsDefs1001\"></defs></svg>",' & _
'"imageBack":"",' & _
'"types":[{"id":8,"name":"Guys Tee","price":19,"colors":["Black","Navy Blue"]},{"id":34,"name":"Ladies Tee","price":19,"colors":["Black","Red"]},{"id":19,"name":"Hoodie","price":34,"colors":["Black","Navy Blue"]},{"id":27,"name":"Sweat Shirt","price":31,"colors":["Black","Navy Blue"]}],' & _
'"images":[{"id":"__dataURI:0__","uri":"data:image/png;base64,' &base64()& '"}]' & _
'}'

$output = @ScriptDir & '\output\data' & @MSEC & '.txt'
FileWrite($output,$dataUpload)
;$out = _HttpRequest(2, $designURL, $dataUpload, $cookieFinal)


func base64()
$FN= "8-back-final-02-02.png"
$dat=FileRead(FileOpen($FN,16))
$objXML=ObjCreate("MSXML2.DOMDocument")
$objNode=$objXML.createElement("b64")
$objNode.dataType="bin.base64"
$objNode.nodeTypedValue=$dat


local $out = StringRegExpReplace($objNode.Text,"\n","")
   return $out
EndFunc





#cs
https://autoitvn.com/login/login

POST /login/login HTTP/1.1
Host: autoitvn.com
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:47.0) Gecko/20100101 Firefox/47.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate, br
Referer: https://autoitvn.com/
Cookie: xf_session=e35c652a8187801d730314fa341b2651
Connection: keep-alive
Content-Type: application/x-www-form-urlencoded
Content-Length: 83
login=choigame3000&register=0&password=handoi&cookie_check=1&redirect=%2F&_xfToken=

HTTP/1.1 303 See Other
Date: Mon, 10 Jul 2017 07:45:11 GMT
Server: Apache/2
Expires: Thu, 19 Nov 1981 08:52:00 GMT
Cache-Control: private, max-age=0
Set-Cookie: xf_session=6ea2da77b28bc43603820fa7ff351253; path=/; secure; httponly
X-Frame-Options: SAMEORIGIN
Last-Modified: Mon, 10 Jul 2017 07:45:11 GMT
Location: https://autoitvn.com/
Vary: User-Agent
Content-Length: 0
Keep-Alive: timeout=2, max=100
Connection: Keep-Alive
Content-Type: text/html; charset=UTF-8
#ce