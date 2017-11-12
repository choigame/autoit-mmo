#cs
	$cookieVisitPage: cookie lan dau vao page. Tuy site ma su dung cho POST login
	$dataLogin : static hay dynamic. Demo nay $dataLogin la static
	$cookieAfterLogin : cookie su dung xuyen suot website cho 1 session
#ce

#include 'lib\_HttpRequest.au3'

$url = "https://autoitvn.com/"
$data = _HttpRequest(1, $url) ; 1 = get Header, 2 = get code html
$cookieVisitPage = _GetCookie($data)

ConsoleWrite("Cookie Viist Page = " & $cookieVisitPage)

$dataLogin = "login=choigame3000&register=0&password=handoi&cookie_check=1&redirect=%2F&_xfToken="
$urlLogin = "https://autoitvn.com/login/login"
$referer = "https://autoitvn.com/"

$data = _HttpRequest(1, $urlLogin, $dataLogin, $cookieVisitPage, $referer)
$cookieAfterLogin  = _GetCookie($data)

ConsoleWrite(@CRLF & "Cookie After Login = " & $cookieAfterLogin)

$location = "https://autoitvn.com/"

; trang chuyen tiep sau khi login hoac url cua thread nao do
; https://autoitvn.com/threads/cho-minh-xin-vi-du-ve-ocr-voi.940/

$data = _HttpRequest(2, $location, '', $cookieAfterLogin, $referer)
$output = @ScriptDir & '\output\login.' & @MSEC & '.html'
FileWrite($output,$data)
ShellExecute($output)

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