#include <Array.au3>

Func GetValueComboFromLabel($label)
	If ($label == $PRIVATE_STATUS[0]) Then Return 286958161406148  ;Chi minh toi
	If ($label == $PRIVATE_STATUS[1]) Then Return 300645083384735  ;Moi nguoi
	If ($label == $PRIVATE_STATUS[2]) Then Return 291667064279714  ;Ban be
EndFunc

Func ArrayToString($array , $indexRemove)
	Local $element = ''
	Local $suffix = '|'
	For $i = 0 To UBound($array) - 1
		If ($i > $indexRemove) Then
			If ($i == (UBound($array) - 1)) Then $suffix = ''
			$element &= $array[$i] & $suffix
		EndIf
	Next

	Return $element
EndFunc