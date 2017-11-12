#include 'lib\_HttpRequest.au3'

#cs
   finalCookie  = cookie dung de luot trang.
   fshare.vn thi login ko dung cookie visit page lan dau
   1. $dataToSend: thay doi khi POST len server. => phai tim chuoi fs_csrf trong code html cua page GET ve.
	Referer: https://www.fshare.vn/login
	  <input type="hidden" name="fs_csrf" value="040e54450b629b3f78e98aa5d1901cd6db6c470d" />
	  email va password phai duoc ma hoa
   2. $cookieAfterLogin co phai finalCookie ? Neu phan Location ko con Set-Cookie nua => do la finalCookie
#ce

$url = "https://www.fshare.vn"
$email = "dactandn6@gmail.com"
$password = "handoi"

$html = _HttpRequest(2, $url)
$fs_csrf = StringRegExp($html, '<input type="hidden" value="(.*?)" name="fs_csrf"',1)[0]
$dataToLogin = "fs_csrf=" &$fs_csrf& "&LoginForm%5Bemail%5D=" & _URIEncode($email)& "&LoginForm%5Bpassword%5D=" & $password & "&LoginForm%5Bcheckloginpopup%5D=0&LoginForm%5BrememberMe%5D=0&yt0=%C4%90%C4%83ng+nh%E1%BA%ADp"
$urlLogin = "https://www.fshare.vn/login"

$headerAfterLogin = _HttpRequest(1, $urlLogin, $dataToLogin)
$cookieAfterLogin  = _GetCookie($headerAfterLogin)

ConsoleWrite(@CRLF & "Cookie After Login = " & $cookieAfterLogin)

$location = StringRegExp($headerAfterLogin, 'Location: (.*)',1)[0]
$data = _HttpRequest(2, $location, '', $cookieAfterLogin)

$output = @ScriptDir & '\output\fshare.html'
FileWrite($output,$data)
ShellExecute($output)


#cs
https://www.fshare.vn/login

POST /login HTTP/1.1
Host: www.fshare.vn
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:47.0) Gecko/20100101 Firefox/47.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate, br
Referer: https://www.fshare.vn/login
Cookie: session_id=mi2mlv7ud8493itgpavnei7117; proxy_s_sv=1499678732983; _ga=GA1.2.1038619667.1499676933; _gid=GA1.2.189277990.1499676933; _gat=1
Connection: keep-alive
Content-Type: application/x-www-form-urlencoded
Content-Length: 215
fs_csrf=6ced517ce34265946f85ed2eca58f8f240a1c904&LoginForm%5Bemail%5D=dactandn6%40gmail.com&LoginForm%5Bpassword%5D=handoi&LoginForm%5Bcheckloginpopup%5D=0&LoginForm%5BrememberMe%5D=0&yt0=%C4%90%C4%83ng+nh%E1%BA%ADp
HTTP/1.1 302 Found
Server: nginx
Date: Mon, 10 Jul 2017 08:55:44 GMT
Content-Type: text/html; charset=UTF-8
Expires: Thu, 19 Nov 1981 08:52:00 GMT
Pragma: no-cache
Cache-Control: private, max-age=0
Set-Cookie: session_id=02r7a0jsmuko98sarj3ae7ipt5; path=/; HttpOnly
Location: https://www.fshare.vn/home
X-Firefox-Spdy: 3.1
----------------------------------------------------------
https://www.fshare.vn/home

GET /home HTTP/1.1
Host: www.fshare.vn
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:47.0) Gecko/20100101 Firefox/47.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate, br
Referer: https://www.fshare.vn/login
Cookie: session_id=02r7a0jsmuko98sarj3ae7ipt5; proxy_s_sv=1499678732983; _ga=GA1.2.1038619667.1499676933; _gid=GA1.2.189277990.1499676933; _gat=1
Connection: keep-alive

HTTP/1.1 200 OK
Server: nginx
Date: Mon, 10 Jul 2017 08:55:45 GMT
Content-Type: text/html; charset=UTF-8
Expires: Thu, 19 Nov 1981 08:52:00 GMT
Cache-Control: no-store, no-cache, must-revalidate
Pragma: no-cache
X-Frame-Options: DENY
Content-Encoding: gzip
X-Firefox-Spdy: 3.1
#ce