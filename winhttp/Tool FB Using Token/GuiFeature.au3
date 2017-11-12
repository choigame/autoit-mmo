

Global $guiFeature = GUICreate("Feature Facebook", $widthGuiFeature , $heightGuiFeature)

_GuiSetFont(12, "Times")
GUISetOnEvent($GUI_EVENT_CLOSE, "BackToGuiLogin")

GUICtrlCreateTab(4, 4, $widthGuiFeature - 10, $heightGuiFeature - 10)
$tabListFriend = GUICtrlCreateTabItem("ListFriend")
$inputFieldOfFriend = GUICtrlCreateInput($FIELD_OF_FRIEND , 15, 35, 300, 25)
$btnGetListFriend = GUICtrlCreateButton("GetListFriend", 320, 35, 100, 25)
GUICtrlSetOnEvent($btnGetListFriend, "GetListFriend")



$tabListFriendByUID = GUICtrlCreateTabItem("ListFriendByUID")


GUICtrlCreateTabItem("") ; end tabitem definition


