#include 'lib\_HttpRequest.au3'

$url = "http://mp3.zing.vn"
$data = _HttpRequest(2, $url)
; 1 = get Header
; 2 = get code html

$output = @ScriptDir&'\output\page.html'
FileWrite($output,$data)
ShellExecute($output)