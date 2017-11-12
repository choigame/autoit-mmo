#include-once
#include 'Import.au3'

Func GetListFriend()
	Local $fieldOfFriend = GUICtrlRead($inputFieldOfFriend)
	Local $graphURL = 'https://graph.facebook.com/' & $VERSION_FB_API & '/me?fields=friends{' & $fieldOfFriend & '}&access_token=' & $token
	Local $data = _HttpRequest(2, $graphURL)
	ClipPut($graphURL)
	_FileWriteToTest('list_friend.txt' , $data)
EndFunc
