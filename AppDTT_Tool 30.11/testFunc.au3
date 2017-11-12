#include <MsgBoxConstants.au3>

Test1()


; This example demonstrates a basic replacement.  It replaces the vowels aeiou
; with the @ character.
Func Test1()
   Local $x = 'getAge()'
   Local $y = StringRegExp($x, '^get[A-Z].*')

   MsgBox(0,"",$y)
 EndFunc   ;==>Test1

