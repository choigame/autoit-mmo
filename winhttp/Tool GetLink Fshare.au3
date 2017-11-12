#include 'lib\_HttpRequest.au3'

$url = "https://www.fshare.vn"
$email = "dactandn6@gmail.com"
$password = "handoi"
$urlFile = 'https://www.fshare.vn/file/T9Q6Q9HTKT/'

$linkCode = StringRegExp($urlFile,'file/(.*)',1)[0]
$linkCode = StringReplace($linkCode,"/","")

;Login
$html = _HttpRequest(2, $url)
$fs_csrf = StringRegExp($html, '<input type="hidden" value="(.*?)" name="fs_csrf"',1)[0]
$dataToLogin = "fs_csrf=" &$fs_csrf& "&LoginForm%5Bemail%5D=" & _URIEncode($email)& "&LoginForm%5Bpassword%5D=" & _URIEncode($password) & "&LoginForm%5Bcheckloginpopup%5D=0&LoginForm%5BrememberMe%5D=0&yt0=%C4%90%C4%83ng+nh%E1%BA%ADp"
$urlLogin = "https://www.fshare.vn/login"

$headerAfterLogin = _HttpRequest(1, $urlLogin, $dataToLogin)
$cookieAfterLogin  = _GetCookie($headerAfterLogin)

;Redirect to urlFile
_HttpRequest(2, $urlFile, '', $cookieAfterLogin)

$urlDownload = 'https://www.fshare.vn/download/get'
$dataToDownload = 'fs_csrf='& $fs_csrf &'&DownloadForm%5Bpwd%5D=&DownloadForm%5Blinkcode%5D='& $linkCode &'&ajax=download-form&undefined=undefined'
$json = _HttpRequest(2, $urlDownload, $dataToDownload, $cookieAfterLogin)
$linkDownload = StringRegExp($json,'(?s){"url":"(.*?)","wait_time":"1"}',1)[0]
$linkDownload = StringReplace($linkDownload,"\/","/")
ConsoleWrite($linkDownload)

#cs
https://www.fshare.vn/download/get

POST /download/get HTTP/1.1
Host: www.fshare.vn
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:47.0) Gecko/20100101 Firefox/47.0
Accept: application/json, text/javascript, */*; q=0.01
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate, br
Content-Type: application/x-www-form-urlencoded; charset=UTF-8
X-Requested-With: XMLHttpRequest
Referer: https://www.fshare.vn/file/T9Q6Q9HTKT/
Content-Length: 148
Cookie: _ga=GA1.2.1038619667.1499676933; _gid=GA1.2.189277990.1499676933; fosp_aid=f65b3791f10c30d5; fosp_location_zone=1; session_id=hhti9us596e7k8itsv2bp1t8d4; proxy_s_sv=1499696552895; apluuid=af44e18aaf0e4e6883bcee90b862d340; __gads=ID=d14df38514744990:T=1499694740:S=ALNI_MYGK1zFw-YGqb80t95vq75y01aY9w; _gat=1
Connection: keep-alive
fs_csrf=ec27971df5df559ef249202ab63a6aef87ed6081&DownloadForm%5Bpwd%5D=&DownloadForm%5Blinkcode%5D=T9Q6Q9HTKT&ajax=download-form&undefined=undefined
#ce