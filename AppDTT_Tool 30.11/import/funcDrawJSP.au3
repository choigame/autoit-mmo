Func chooseListIdFile()
   Local $f = FileOpenDialog("Choose ListID file",@ScriptDir&"\TempWorking","Text (*.txt)",1,"listID.txt",$guiInTab)
   If Not @error Then
	  $pathListIDFile = $f
   Else
	  Return
   EndIf

   Local $n = _FileCountLines($pathListIDFile)

   For $k = 0 to $numberOfRow - 1

		 For $t = 0 to 5
			 For $j = 2 to $n
			   GUICtrlSetData($comboIDCombo[$k][$t],FileReadLine($pathListIDFile,$j))
			Next
			 _GUICtrlComboBox_SetCurSel($comboIDCombo[$k][$t],0)
		 Next
	  Next

   $pathRegistryForm = $WorkingDir&"\drawJSP\registry-FormJSP.txt"
   $fillData2FormForm = $WorkingDir&"\drawJSP\filldata2Form-FormJSP.txt"
   $validatorForm = $WorkingDir&"\drawJSP\validator-FormJSP.txt"
   $pathReviewForm = $WorkingDir&"\drawJSP\review-FormJSP.txt"

   FileOpen($pathRegistryForm, $modeWrite)
   FileOpen($fillData2FormForm, $modeWrite)
   FileOpen($validatorForm, $modeWrite)
   FileOpen($pathReviewForm, $modeWrite)

   FileWriteLine($fillData2FormForm, '//coQuanQuanLyId - long' &@CRLF & _
		'String coQuanQuanLyId = ParamUtil.getString(request,"coQuanQuanLyId").trim();' &@CRLF & _
		'hoSo.setCoQuanQuanLyId(ActionUtils.convertToLong(coQuanQuanLyId));')

EndFunc

Func checkRequiredEntity($file,$line)
   for $i=1 to _FileCountLines($file)
	  if(StringInStr(FileReadLine($file,$i),'get'&upperFirstLetter($line)&'()')) Then
		  MsgBox($MB_ICONERROR+262144+8192, "Error !", $line&" must be unique!")
		  Return false
		  EndIf
	   Next
	   Return true
EndFunc

Func eventProcessComboBoxID($k,$i)
   _GUICtrlComboBox_ResetContent ( $comboIDTypeCombo[$k][$i] )
   Local $value = ""

   Local $v = GUICtrlRead($comboIDCombo[$k][$i])
   If StringInStr(StringSplit($v," ")[1],"long") Then
	  $value = StringSplit($valueIDTypeLongCombo,"|")
	  For $j = 1 to $value[0]
		 GUICtrlSetData($comboIDTypeCombo[$k][$i],$value[$j])
	  Next
   ElseIf StringInStr(StringSplit($v," ")[1],"Date") Then
	   $value = StringSplit($valueIDTypeDateCombo,"|")
	  For $j = 1 to $value[0]
		 GUICtrlSetData($comboIDTypeCombo[$k][$i],$value[$j])
	  Next
   ElseIf StringInStr(StringSplit($v," ")[1],"String") Then
	  $value = StringSplit($valueIDTypeStringCombo,"|")
	  For $j = 1 to $value[0]
		 GUICtrlSetData($comboIDTypeCombo[$k][$i],$value[$j])
	  Next
   EndIf
    _GUICtrlComboBox_SetCurSel($comboIDTypeCombo[$k][$i],0)
EndFunc


Func getListID()
   Local $r = '';
   $pathListIDFile
   Local $n = _FileCountLines($pathListIDFile)
   For $i = 2 to $n
	  $r &=  FileReadLine($pathListIDFile,$i)
	  If Not $r = $n Then $r&= "|"
   Next
   return $r
EndFunc


Func lastRowEvent($index)
   If(GUICtrlRead($lastRowChk[$index])=$GUI_CHECKED) THEN
	  For $k = $index + 1 to $numberOfRow - 1
		 For $i = 0 to 5
		 GUICtrlSetState($normalRadio[$k],$GUI_DISABLE)
		 GUICtrlSetState($addressRadio[$k],$GUI_DISABLE)
		 GUICtrlSetState($nationRadio[$k],$GUI_DISABLE)
		 GUICtrlSetState($radioWithRowChk[$k],$GUI_DISABLE)

		 For $t = 0 to $numberOfRow - 1
		 If Not $t = $index Then
			GUICtrlSetState($lastRowChk[$t],$GUI_DISABLE)
			EndIf
	  Next
		 GUICtrlSetState($headerName1Input[$k],$GUI_DISABLE)
		 GUICtrlSetBkColor($headerName1Input[$k],$xanhLaChuoi)

		 GUICtrlSetState($radioNameInput[$k],$GUI_DISABLE)
		 GUICtrlSetBkColor($radioNameInput[$k],$xanhLaChuoi)

		 GUICtrlSetState($labelInput[$k][$i],$GUI_DISABLE)
		 GUICtrlSetBkColor($labelInput[$k][$i],$xanhLaChuoi)
		 GUICtrlSetState($colspanCombo[$k][$i],$GUI_DISABLE)
		 GUICtrlSetState($comboIDTypeCombo[$k][$i],$GUI_DISABLE)
		 GUICtrlSetState($comboIDCombo[$k][$i],$GUI_DISABLE)
		 GUICtrlSetState($requiredChk[$k][$i],$GUI_DISABLE)
	  Next
   Next
   Else
   	  For $k = $index + 1 to $numberOfRow - 1
		 For $i = 0 to 5

			GUICtrlSetState($normalRadio[$k],$GUI_ENABLE)
			GUICtrlSetState($addressRadio[$k],$GUI_ENABLE)
			GUICtrlSetState($nationRadio[$k],$GUI_ENABLE)

			GUICtrlSetState($headerName1Input[$k],$GUI_ENABLE)
			GUICtrlSetBkColor($headerName1Input[$k],0xffffff)

			GUICtrlSetState($radioNameInput[$k],$GUI_ENABLE)
			GUICtrlSetBkColor($radioNameInput[$k],0xffffff)

			GUICtrlSetState($labelInput[$k][$i],$GUI_ENABLE)
			GUICtrlSetBkColor($labelInput[$k][$i],0xffffff)

			GUICtrlSetState($colspanCombo[$k][$i],$GUI_ENABLE)
			GUICtrlSetBkColor($colspanCombo[$k][$i],0x191919)

			GUICtrlSetState($comboIDTypeCombo[$k][$i],$GUI_ENABLE)
			GUICtrlSetBkColor($comboIDTypeCombo[$k][$i],0x191919)

			GUICtrlSetState($comboIDCombo[$k][$i],$GUI_ENABLE)
			GUICtrlSetBkColor($comboIDCombo[$k][$i],0x191919)

			GUICtrlSetState($requiredChk[$k][$i],$GUI_ENABLE)

			For $t = 0 to $numberOfRow - 1
			If $t < $index Then
			   GUICtrlSetState($radioWithRowChk[$t],$GUI_ENABLE)
			   GUICtrlSetState($lastRowChk[$t],$GUI_ENABLE)
			EndIf
			NEXT
		 next
	  next
   EndIf
EndFunc

Func radioRadio()
   If GUICtrlRead($radioRadio)= $GUI_CHECKED THEN
		 GUICtrlSetData($radioNameInput[0],"Chứng minh nhân dân")

		 GUICtrlSetData($labelInput[0][0],"Chứng minh nhân dân số")     ; row1 (0) & cell 0
		 GUICtrlSetData($colspanCombo[0][0],3)

		 GUICtrlSetData($labelInput[0][1],"Ngày cấp")
		 GUICtrlSetData($colspanCombo[0][1],3)

		 GUICtrlSetData($labelInput[0][3],"Nơi cấp")
		 GUICtrlSetData($colspanCombo[0][3],6)

		 GUICtrlSetData($radioNameInput[1],"Hộ chiếu")

		 GUICtrlSetData($labelInput[1][0],"Số hộ chiếu")     ; row2 (1) & cell 0
		 GUICtrlSetData($colspanCombo[1][0],3)

		 GUICtrlSetData($labelInput[1][1],"Ngày cấp")
		 GUICtrlSetData($colspanCombo[1][1],3)

		 GUICtrlSetData($labelInput[1][3],"Nơi cấp")
		 GUICtrlSetData($colspanCombo[1][3],6)

		 GUICtrlSetData($radioNameInput[2],"Giấy tờ khác")

		 GUICtrlSetData($labelInput[2][0],"Loại")     ; row2 (1) & cell 0
		 GUICtrlSetData($colspanCombo[2][0],2)

		 GUICtrlSetData($labelInput[2][1],"Số")
		 GUICtrlSetData($colspanCombo[2][1],2)

		 GUICtrlSetData($labelInput[2][2],"Ngày cấp")
		 GUICtrlSetData($colspanCombo[2][2],2)

		 GUICtrlSetData($labelInput[2][3],"Nơi cấp")
		 GUICtrlSetData($colspanCombo[2][3],6)
   ElseIf GUICtrlRead($nationRadio)= $GUI_CHECKED THEN

   EndIf
EndFunc

Func generateRadioArea()
   Local $fileOut = @ScriptDir &"\TempWorking\generateRadio.txt"
   Local $hfileOpen = FileOpen($fileOut,10)

   Local $areaRadioChoose = ''
   Local $areaRadioButton = ''

   Local $area[3]
   Local $label[3][6]
   Local $colspan[3][6]
   Local $id[3][6]
   Local $idType[3][6]
   Local $required[3][6]

   ;Get Data from Input form
   For $k = 0 To 2
	  $area[$k] =  GUICtrlRead($radioNameInput[$k])
	  For $i = 0 To 5
		 $label[$k][$i] = GUICtrlRead($labelInput[$k][$i])
		 $colspan[$k][$i] = GUICtrlRead($colspanCombo[$k][$i])
		 $id[$k][$i] = GUICtrlRead($comboIDCombo[$k][$i])
		 $idType[$k][$i] = GUICtrlRead($comboIDTypeCombo[$k][$i])
		 $required[$k][$i] = GUICtrlRead($requiredChk[$k][$i])
	  Next
   Next

$areaRadioChoose =  '<%'
   If Not ($area[0] = '') Then $areaRadioChoose &=@CRLF&'String area1 = "area1";'
   If Not ($area[1] = '') Then $areaRadioChoose &=@CRLF&'String area2 = "area2";'
   If Not ($area[2] = '') Then $areaRadioChoose &=@CRLF&'String area3 = "area3";'

   $areaRadioChoose &= @CRLF&'String radio = ActionUtils.getValueString(request, "radio");'

   If Not ($area[0] = '') Then
	  $areaRadioChoose &=@CRLF&'if ("".equals(radio)) radio = area1;'
   ElseIf Not ($area[1] = '') Then
	  $areaRadioChoose &=@CRLF&'if ("".equals(radio)) radio = area2;'
   EndIf

   $areaRadioChoose &= @CRLF&'%>'

   $areaRadioButton =  '<tr>'
   For $k = 0 To 2
	  If Not ($area[$k] = '') Then
		 $areaRadioButton &= @CRLF&'<td colspan="2"><input type="radio"' &@CRLF & _
								'name="radio" value="<%=area'&$k+1&'%>"' &@CRLF & _
								'<%=area'&$k+1&'.equals(radio) ? "checked":""%>' &@CRLF & _
								'onclick="showArea(this.value);"> <label class="egov-label-bold"> Area '&$k+1&' </label></td>'
	  EndIf
   Next
   $areaRadioButton&='</tr>'


FileWrite($hfileOpen,$areaRadioChoose &@CRLF& $areaRadioButton)
FileClose($hfileOpen)
EndFunc


Func createHeader()
   Local $value = trim(GUICtrlRead($headerName1Input[0]))

   If ($pathRegistryFormFile='') Then
	  MsgBox($MB_ICONERROR+262144+8192,"Error","Choose ListId File!")
	  Return
   EndIf

   if($value='') Then
	  MsgBox($MB_ICONERROR+262144+8192,"Error","Input First!")
	  Return
   EndIf
   $header = '<tr>' &@CRLF & _
			   '<td colspan = "6">' &@CRLF & _
				 ' <label class="egov-label-bold">' &@CRLF & _
						StringUpper($value) &@CRLF & _
				  '</label>' &@CRLF & _
			  ' </td>' &@CRLF & _
			 '</tr>' &@CRLF
   FileWrite($hfileOpen,$header)
   GUICtrlSetData($headerName1Input[0],'')
   FileClose($hfileOpen)

   ;Write to review JSP
   Local $review = '<tr>' &@CRLF & _
	'<td colspan="6"><label class="egov-label-bold">'&StringUpper($header)&': </label>' &@CRLF & _
	'</td>' &@CRLF & _
   '</tr>' &@CRLF

   Local $pathReviewFormOpen = FileOpen($pathReviewForm,9)
   FileWrite($pathReviewFormOpen,$review)
   FileClose($pathReviewFormOpen)
EndFunc

Func createAdress()
   If ($pathRegistryForm ='') Then
	  MsgBox($MB_ICONERROR+262144+8192,"Error","Choose ListId File!")
	  Return
   EndIf

   Local $tinhField = StringSplit(GUICtrlRead($comboIDCombo[1][0])," ")[2]
   Local $quanField = StringSplit(GUICtrlRead($comboIDCombo[1][1])," ")[2]
   Local $xaField = StringSplit(GUICtrlRead($comboIDCombo[1][2])," ")[2]
   Local $diaChiField = StringSplit(GUICtrlRead($comboIDCombo[1][3])," ")[2]

   if( $tinhField='' or $quanField='' or $xaField='' or $diaChiField='' ) Then
	  MsgBox($MB_ICONERROR+262144+8192,"Error","Input Field First!")
	  Return
   EndIf

   if( $tinhField=$quanField or $tinhField=$xaField or $tinhField=$diaChiField) Then
	  MsgBox($MB_ICONERROR+262144+8192,"Error","Input Field Same!")
	  Return
   EndIf

   if( $xaField=$quanField or $quanField=$diaChiField) Then
	  MsgBox($MB_ICONERROR+262144+8192,"Error","Input Field Same!")
	  Return
   EndIf

   if( $xaField=$diaChiField) Then
	  MsgBox($MB_ICONERROR+262144+8192,"Error","Input Field Same!")
	  Return
   EndIf

   IF NOT (checkRequiredEntity($pathRegistryForm,$tinhField)) Then Return
   IF NOT (checkRequiredEntity($pathRegistryForm,$quanField)) Then Return
   IF NOT (checkRequiredEntity($pathRegistryForm,$xaField)) Then Return
   IF NOT (checkRequiredEntity($pathRegistryForm,$diaChiField)) Then Return

   Local $header = trim(GUICtrlRead($headerName1Input[1]))
   if ($header ='') then  $header = "Địa chỉ thường trú/ tạm trú"

   Local $tinhRequired = GUICtrlRead($requiredChk[1][0])
   Local $quanRequired = GUICtrlRead($requiredChk[1][1])
   Local $xaRequired = GUICtrlRead($requiredChk[1][2])
   Local $diaChiRequired = GUICtrlRead($requiredChk[1][3])

   Local $required = '<label class="egov-label-red">*</label>'

   Local $value
   $value = '<tr>' &@CRLF & _
			   '<td colspan = "6">' &@CRLF & _
				 ' <label class="egov-label-bold">' &@CRLF & _
						StringUpper($header) &@CRLF & _
				  '</label>' &@CRLF & _
			  ' </td>' &@CRLF & _
			 '</tr>' &@CRLF & _
   '<tr>' &@CRLF & _
	'<td colspan="2"><label class="egov-label-bold">Tỉnh/Thành phố</label>'  &@CRLF

   if($tinhRequired==1) then
	  $value &= $required&'<br>'&@CRLF
   Else
	  $value &= '<br>'&@CRLF
   EndIf
	$value &= '<select name='&quote($tinhField)&' id='&quote($tinhField)&' style="width: 96%" class="egov-select"' &@CRLF & _
	"onchange='reDrawSelectBox("&quote($tinhField)&','&quote($quanField)&','&quote($xaField)&")'>" &@CRLF & _
	'<%' &@CRLF & _
		'long '&$tinhField&' = ActionUtils.getValueLong(request, '&quote($tinhField)&');' &@CRLF & _
			'if ('&$tinhField&' ==0 ) '&$tinhField&' = hoSo.get'&upperFirstLetter($tinhField)&'();' &@CRLF & _
			'if ('&$tinhField&' ==0 ) '&$tinhField&' = donViHanhChinhId;' &@CRLF & _
			'for (DonViHanhChinh item : danhSachTinhThanh) {' &@CRLF & _
	'%>' &@CRLF & _
	'<option value="<%=item.getId()%>"' &@CRLF & _
		'<%=ActionUtils.checkData(item.getId(),'&$tinhField&')%>><%=item.getTen()%></option>' &@CRLF & _
	'<%}%>' &@CRLF & _
	'</select>' &@CRLF & _
   '</td>' &@CRLF & _
	'<td colspan="2"><label class="egov-label-bold">Quận/Huyện</label>' &@CRLF

   if($quanRequired==1) then
	  $value &= $required &'<br>'  &@CRLF
   else
	  $value &= '<br>'&@CRLF
   EndIf

	$value &= '<select name='&quote($quanField)&' id='&quote($quanField) &@CRLF & _
	'style="width: 96%" class="egov-select"' &@CRLF & _
	"onchange='reDrawSelectBox("&quote($quanField)&','&quote($xaField)&")'>" &@CRLF & _
	'<option value="-1">Chọn quận huyện</option>' &@CRLF & _
	'<%' &@CRLF & _
		'donViHanhChinhSoaps = service.getDanhsachDVHC('&$tinhField&');' &@CRLF & _
			'long '&$quanField&'= ActionUtils.getValueLong(request, '&quote($quanField)&');' &@CRLF & _
				'if ('&$quanField&' == 0)' &@CRLF & _
					$quanField&' = hoSo.get'&upperFirstLetter($quanField)&'();' &@CRLF & _
				'for (DonViHanhChinhSoap item : donViHanhChinhSoaps) {' &@CRLF & _
	'%>' &@CRLF & _
	'<option value="<%=item.getId()%>"' &@CRLF & _
		'<%=ActionUtils.checkData(item.getId(),' &@CRLF & _
					$quanField&')%>><%=item.getTen()%></option>' &@CRLF & _
	'<%' &@CRLF & _
		'}' &@CRLF & _
	'%>' &@CRLF & _
	'</select></td>' &@CRLF & _
	'<td colspan="2"><label class="egov-label-bold">Phường/Xã/Thị trấn</label>' &@CRLF

   If($xaRequired==1) then
	  $value &= $required&'<br>'&@CRLF
   Else
	  $value &= '<br>'&@CRLF
   EndIf

	$value &= '<select name='&quote($xaField)&' id='&quote($xaField) &@CRLF & _
		'style="width: 97%" class="egov-select">' &@CRLF & _
	'<option>Chọn phường xã</option>' &@CRLF & _
	'<%' &@CRLF & _
		'long '&$xaField&' = ActionUtils.getValueLong(request, '&quote($xaField)&');' &@CRLF & _
		'if('&$xaField&'==0) xa = hoSo.get'&upperFirstLetter($xaField)&'();' &@CRLF & _
		'}' &@CRLF & _
	'%>' &@CRLF & _
	'<%' &@CRLF & _
		'if('&$quanField&' !=0){' &@CRLF & _
				'for (DonViHanhChinhSoap item : service.getDanhsachDVHC('&$quanField&')) {' &@CRLF & _
	'%>' &@CRLF & _
	'<option value="<%=item.getId()%>"' &@CRLF & _
				$xaField&')%>><%=item.getTen()%></option>' &@CRLF & _
	'<%' &@CRLF & _
		'}}' &@CRLF & _
	'%>' &@CRLF & _
	'</select></td>' &@CRLF & _
	'</tr>' &@CRLF & _
	'<tr>' &@CRLF & _
		'<td colspan="6"><label class="egov-label-bold">Số nhà/ đường phố /xóm/ thôn ấp</label>' &@CRLF

   if($diaChiRequired==1) then $value &= $required  &@CRLF

   $value &='<input type="text"' &@CRLF & _
			'class="egov-inputfield" name='&quote($diaChiField) &@CRLF & _
			'id='&quote($diaChiField)&' maxlength="200"' &@CRLF & _
			'value=" <%=hoSo.get'&upperFirstLetter($diaChiField)&'()%>" /></td>' &@CRLF & _
	'</tr>' &@CRLF & _
   '<input type="hidden" id='&quote($tinhField)&'/>' &@CRLF & _
   '<input type="hidden" id='&quote($quanField)&'/>' &@CRLF & _
   '<input type="hidden" id='&quote($xaField)&'/>' &@CRLF

   ;Write to registry JSP
   Local $pathRegistryFormOpen = FileOpen($pathRegistryForm,9)
   FileWrite($pathRegistryFormOpen,$value)
   FileClose($pathRegistryFormOpen)

   ;Write to review JSP
   Local $review = '<tr>' &@CRLF & _
	'<td colspan="6"><label class="egov-label-bold">'&StringUpper($header)&': </label>' &@CRLF & _
	'<label class="egov-label">' &@CRLF & _
	'<%=(hoSo.get'&upperFirstLetter($diaChiField)&'().length() == 0 ? "" : hoSo.get'&upperFirstLetter($diaChiField)&'()+",") ' &@CRLF & _
	    '+ (hoSo.get'&upperFirstLetter($xaField)&'()  >0 ? " "+service.getDonViHanhChinhTheoId(hoSo.get'&upperFirstLetter($xaField)&'()).getTen()+"," : "") ' &@CRLF & _
		'+ (hoSo.get'&upperFirstLetter($quanField)&'() >0 ? " "+service.getDonViHanhChinhTheoId(hoSo.get'&upperFirstLetter($quanField)&'()).getTen()+"," : "")' &@CRLF & _
		'+ (hoSo.get'&upperFirstLetter($tinhField)&'() >0 ? " " +service.getDonViHanhChinhTheoId(hoSo.get'&upperFirstLetter($tinhField)&'()).getTen()+"." : "")' &@CRLF & _
	'%>' &@CRLF & _
	'</label>' &@CRLF & _
	'</td>' &@CRLF & _
'</tr>' &@CRLF

   Local $pathReviewFormOpen = FileOpen($pathReviewForm,9)
   FileWrite($pathReviewFormOpen,$review)
   FileClose($pathReviewFormOpen)

   ;Write to validatorFile
   Local $validator

   if ($tinhRequired = 1) then
   $validator = '//'&$tinhField&' - long' &@CRLF& _
					' String '&$tinhField&' = ParamUtil.getString(request, "'&$tinhField&'").trim();' &@CRLF& _
					' if(ActionUtils.convertToLong('&$tinhField&') == 0 || ActionUtils.convertToLong('&$tinhField&') <0){' &@CRLF& _
						' SessionErrors.add(request, "'&$tinhField&'");' &@CRLF& _
						' valid = false;' &@CRLF& _
					' }' &@CRLF
   EndIf
   if ($quanRequired = 1) then
   $validator &= '//'&$quanField&' - long' &@CRLF& _
					' String '&$quanField&' = ParamUtil.getString(request, "'&$quanField&'").trim();' &@CRLF& _
					' if(ActionUtils.convertToLong('&$quanField&') == 0 || ActionUtils.convertToLong('&$quanField&') <0){' &@CRLF& _
						' SessionErrors.add(request, "'&$quanField&'");' &@CRLF& _
						' valid = false;' &@CRLF& _
					' }' &@CRLF
   EndIf
   if ($xaRequired = 1) then
   $validator &= '//'&$xaField&' - long' &@CRLF& _
					' String '&$xaField&' = ParamUtil.getString(request, "'&$xaField&'").trim();' &@CRLF& _
					' if(ActionUtils.convertToLong('&$xaField&') == 0 || ActionUtils.convertToLong('&$xaField&') <0){' &@CRLF& _
						' SessionErrors.add(request, "'&$xaField&'");' &@CRLF& _
						' valid = false;' &@CRLF& _
					' }' &@CRLF
   EndIf
   if ($diaChiRequired = 1) then
   $validator &= '//'&$diaChiField&' - String' &@CRLF & _
					 'String '&$diaChiField&' = ParamUtil.getString(request, '&quote($diaChiField)&').trim();' &@CRLF & _
					 'if ('&$diaChiField&'.length() == 0) {' &@CRLF & _
						'SessionErrors.add(request, '&quote($diaChiField)&');' &@CRLF & _
						'valid = false;' &@CRLF & _
					 '}' &@CRLF

   EndIf

   Local $validatorFormOpen = FileOpen($validatorForm,9)
   FileWrite($validatorFormOpen,$validator)
   FileClose($validatorFormOpen)

   ;Write to fillData2Form

   Local $fill

   $fill = '// '&$tinhField&' - long' &@CRLF& _
		'long '&$tinhField&' = ParamUtil.getLong(request,'&quote($tinhField)&');' &@CRLF & _
		'hoSo.set' & upperFirstLetter($tinhField) & '('&$tinhField&');' &@CRLF & _
		'// '&$quanField&' - long' &@CRLF& _
		'long '&$quanField&' = ParamUtil.getLong(request,'&quote($quanField)&');' &@CRLF& _
		'hoSo.set' & upperFirstLetter($quanField) & '('&$quanField&');' &@CRLF & _
		'// '&$xaField&' - long' &@CRLF& _
		'long '&$xaField&' = ParamUtil.getLong(request,'&quote($xaField)&');' &@CRLF& _
		'hoSo.set' & upperFirstLetter($xaField) & '('&$xaField&');' &@CRLF & _
		'// '&$diaChiField&' - String' &@CRLF& _
		'String '&$diaChiField&' = ParamUtil.getString(request,'&quote($diaChiField)&').trim();' &@CRLF& _
		'hoSo.set' & upperFirstLetter($diaChiField) & '('&$diaChiField&');' &@CRLF

   Local $fillData2FormFormOpen = FileOpen($fillData2FormForm,9)
   FileWrite($fillData2FormFormOpen,$fill)
   FileClose($fillData2FormFormOpen)

EndFunc

Func createRow()
   If ($pathRegistryForm ='') Then
	  MsgBox($MB_ICONERROR+262144+8192,"Error","Choose ListId File!")
	  Return
   EndIf

   Local $td1Field = GUICtrlRead($comboIDCombo[2][0])
   Local $td2Field = GUICtrlRead($comboIDCombo[2][1])
   Local $td3Field = GUICtrlRead($comboIDCombo[2][2])

   if( $td1Field='--' and $td2Field='--' and $td3Field='--') Then
	  MsgBox($MB_ICONERROR+262144+8192,"Error","Must input 1 field!")
	  Return
   Else
	  if( $td1Field=$td2Field and Not ($td2Field = '--')) Then
		 MsgBox($MB_ICONERROR+262144+8192,"Error","1,2 Field Same!")
		 Return
	  EndIf

	  if( $td2Field=$td3Field and Not ($td3Field = '--')) Then
		 MsgBox($MB_ICONERROR+262144+8192,"Error","2,3 Field Same!")
		 Return
	  EndIf

	  if( $td1Field=$td3Field and Not ($td3Field = '--')) Then
		 MsgBox($MB_ICONERROR+262144+8192,"Error","1,3 Field Same!")
		 Return
	  EndIf
   EndIf

   IF NOT (checkRequiredEntity($pathRegistryForm,$td1Field)) Then Return
   IF NOT (checkRequiredEntity($pathRegistryForm,$td2Field)) Then Return
   IF NOT (checkRequiredEntity($pathRegistryForm,$td3Field)) Then Return

   Local $td1 = ""
   Local $td2 = ""
   Local $td3 = ""

   Local $data1 = ""
   Local $data2 = ""
   Local $data3 = ""

   Local $type1 = ""
   Local $type2 = ""
   Local $type3 = ""

   Local $td1Required = ""
   Local $td2Required = ""
   Local $td3Required = ""

   Local $col1
   Local $col2
   Local $col3

   If NOT ($td1Field = '--') Then
	  $col1 = GUICtrlRead($colspanCombo[2][0])
	  $td1 = StringSplit($td1Field," ")[2]
	  $data1 = StringSplit($td1Field," ")[1]
	  $td1Required = GUICtrlRead($requiredChk[2][0])
	  $type1 = GUICtrlRead($comboIDTypeCombo[2][0])
   Else
	  $col1 = 0
   EndIf

   If NOT ($td2Field = '--') Then
	  $col2 = GUICtrlRead($colspanCombo[2][1])
	  $td2 = StringSplit($td2Field," ")[2]
	  $data2 = StringSplit($td2Field," ")[1]
	  $td2Required = GUICtrlRead($requiredChk[2][1])
	  $type2 = GUICtrlRead($comboIDTypeCombo[2][1])
   Else
	  $col2 = 0
   EndIf

   If NOT ($td3Field = '--') Then
	  $col3 = GUICtrlRead($colspanCombo[2][2])
	  $td3 = StringSplit($td3Field," ")[2]
	  $data3 = StringSplit($td3Field," ")[1]
	  $td3Required = GUICtrlRead($requiredChk[2][2])
	  $type3 = GUICtrlRead($comboIDTypeCombo[2][2])
   Else
	  $col3 = 0
   EndIf

   IF NOT (checkRequiredEntity($pathRegistryForm,$td1)) Then Return
   IF NOT (checkRequiredEntity($pathRegistryForm,$td2)) Then Return
   IF NOT (checkRequiredEntity($pathRegistryForm,$td3)) Then Return

   if NOT ($col1+$col2+$col3==6) Then
	  MsgBox($MB_ICONERROR+262144+8192,"Error","Check sum of colspan!")
	  Return
   EndIf

   Local $label1 = trim(GUICtrlRead($labelInput[2][0]))
   Local $label2 = trim(GUICtrlRead($labelInput[2][1]))
   Local $label3 = trim(GUICtrlRead($labelInput[2][2]))


   Local $required = '<label class="egov-label-red">*</label>'

   Local $row = '<tr>' &@CRLF

   If not ($td1 = "") Then
	  $row &= '<td colspan='&quote($col1)&'>' &@CRLF & _
			   '<label class="egov-label-bold">'&$label1&'</label>' &@CRLF
	  if ($td1Required = 1) Then
		 $row &= $required&'<br>'
	  Else
		 $row &= '<br>'&@CRLF
	  EndIf

	  ;td1
	  If ($data1 = "String") Then
		 If ($type1 = "String") Then
			$row &= '<input type="text" class="egov-inputfield"'  &@CRLF & _
			   'name='&quote($td1)&' id='&quote($td1)&' maxlength="200"' &@CRLF & _
			   'value="<%=hoSo.get'&upperFirstLetter($td1)&'() %>" />' &@CRLF
		 EndIf

		 If ($type1 = "cmnd") Then
			$row &= '<input type="text" class="egov-inputfield"'  &@CRLF & _
			   'name='&quote($td1)&' id='&quote($td1)&' maxlength="200"' &@CRLF & _
			   'value="<%=hoSo.get'&upperFirstLetter($td1)&'() %>" />' &@CRLF
		 EndIf

		 If ($type1 = "num") Then
			$row &= '<input type="text" class="egov-inputfield NUMERIC"'  &@CRLF & _
			   'name='&quote($td1)&' id='&quote($td1)&' maxlength="200"' &@CRLF & _
			   'value="<%=hoSo.get'&upperFirstLetter($td1)&'() %>" />' &@CRLF
			EndIf

		 If ($type1 = "numFormat") Then
			$row &= '<input type="text" class="egov-inputfield NUMERIC"'  &@CRLF & _
			   'onkeyup="formatNumberInput(this,event)"' &@CRLF & _
			   'name='&quote($td1)&' id='&quote($td1)&' maxlength="200"' &@CRLF & _
			   'value="<%=hoSo.get'&upperFirstLetter($td1)&'() %>" />' &@CRLF
			EndIf

		 If ($type1 = "upperCase") Then
			$row &= '<input type="text" class="egov-inputfield"'  &@CRLF & _
			   'style="width: 100%; text-transform: uppercase"'  &@CRLF & _
			   'name='&quote($td1)&' id='&quote($td1)&' maxlength="200"' &@CRLF & _
			   'value="<%=hoSo.get'&upperFirstLetter($td1)&'() %>" />' &@CRLF
			EndIf

	  ElseIf ($data1 = "long") Then
		 If ($type1 = "--") Then
			MsgBox($MB_ICONERROR+262144+8192,"Error","Choose type field 1!")
			Return
		 EndIf

		 If ($type1 = "nation") Then
			$row &= '<select name='&quote($td1)&' id='&quote($td1)  &@CRLF & _
						"onchange='checkQuocGia("&quote($td1)&");'" &@CRLF & _
						   'class="egov-select">' &@CRLF & _
						'<option>Lựa chọn quốc gia</option>' &@CRLF & _
						 '<%' &@CRLF & _
							 'for (QuocGiaSoap item : service.getDanhSachQuocGia()) {' &@CRLF & _
						 '%>' &@CRLF & _
						 '<option value="<%=item.getId()%>"' &@CRLF & _
							 '<%=ActionUtils.checkData(item.getId(), hoSo.get'&upperFirstLetter($td1)&'())%>><%=item.getTen()%></option>' &@CRLF & _
						 '<%' &@CRLF & _
							 '}' &@CRLF & _
						 '%>' &@CRLF & _
						'</select>' &@CRLF
		 EndIf

		 If ($type1 = "cmnd") Then
			$row &= '<select class="egov-select" name='&quote($td1)&' id='&quote($td1)&'>' &@CRLF & _
			   '<option>Chọn nơi cấp</option>' &@CRLF & _
			   '<%' &@CRLF & _
				   'for (DonViHanhChinh item : DonViHanhChinhLocalServiceUtil.getDanhSachNoiCapCMND()) {' &@CRLF & _
			   '%>' &@CRLF & _
			   '<option value="<%=item.getId()%>"' &@CRLF & _
				   '<%=ActionUtils.checkData(item.getId(), hoSo.get'&upperFirstLetter($td1)&'())%>>' &@CRLF & _
				   '<%=item.getMa().length()>=4 ? "Cục cảnh sát ĐKQL cư trú và dữ liệu quốc gia về dân cư" : "Công an"%> <%=item.getTen()%>' &@CRLF & _
			   '</option>' &@CRLF & _
			   '<%}%>' &@CRLF & _
		   '</select>' &@CRLF
		 EndIf

		 If ($type1 = "people") Then
			$row &= '<select name='&quote($td1)&' id='&quote($td1)  &@CRLF & _
						"onchange='setDanToc(quocTich,"&quote($td1)&" );'" &@CRLF & _
						   'class="egov-select">' &@CRLF & _
						'<option>Lựa chọn dân tộc</option>' &@CRLF & _
						 '<%' &@CRLF & _
							 'for (DanTocSoap item : service.getDanhSachDanToc()) {' &@CRLF & _
						 '%>' &@CRLF & _
						 '<option value="<%=item.getId()%>"' &@CRLF & _
							 '<%=ActionUtils.checkData(item.getId(), hoSo.get'&upperFirstLetter($td1)&'())%>><%=item.getTen()%></option>' &@CRLF & _
						 '<%' &@CRLF & _
							 '}' &@CRLF & _
						 '%>' &@CRLF & _
						'</select>' &@CRLF
			EndIf

		 If ($type1 = "sex") Then
			$row &= '<select name='&quote($td1)&' id='&quote($td1)  &@CRLF & _
						   'class="egov-select">' &@CRLF & _
						'<option value="-1">Chọn giới tính</option>' &@CRLF & _
						 '<%' &@CRLF & _
							 'for (GioiTinhSoap item : service.getDSGioiTinh()) {' &@CRLF & _
						 '%>' &@CRLF & _
						 '<option value="<%=item.getId()%>"' &@CRLF & _
							 '<%=ActionUtils.checkData(item.getId(), hoSo.get'&upperFirstLetter($td1)&'())%>><%=item.getTen()%></option>' &@CRLF & _
						 '<%' &@CRLF & _
							 '}' &@CRLF & _
						 '%>' &@CRLF & _
						'</select>' &@CRLF
			EndIf

		 If ($type1 = "quanHe") Then
			$row &= '<select name='&quote($td1)&' id='&quote($td1)  &@CRLF & _
						   'class="egov-select">' &@CRLF & _
						'<option value="-1">Chọn quan hệ</option>' &@CRLF & _
						 '<%' &@CRLF & _
							 'for (QuanHeGiaDinh  item : QuanHeGiaDinhLocalServiceUtil.getQuanHeGiaDinhs()) {' &@CRLF & _
						 '%>' &@CRLF & _
						 '<option value="<%=item.getId()%>"' &@CRLF & _
							 '<%=ActionUtils.checkData(item.getId(), hoSo.get'&upperFirstLetter($td1)&'())%>><%=item.getTen()%></option>' &@CRLF & _
						 '<%' &@CRLF & _
							 '}' &@CRLF & _
						 '%>' &@CRLF & _
						'</select>' &@CRLF
					 EndIf

		 If ($type1 = "tinh") Then
			$row &= '<select name='&quote($td1)&' id='&quote($td1)  &@CRLF & _
						   'class="egov-select">' &@CRLF & _
						'<option>Chọn</option>' &@CRLF & _
						 '<%' &@CRLF & _
							 'for ((DonViHanhChinh   item : danhSachTinhThanh) {' &@CRLF & _
						 '%>' &@CRLF & _
						 '<option value="<%=item.getId()%>"' &@CRLF & _
							 '<%=ActionUtils.checkData(item.getId(), hoSo.get'&upperFirstLetter($td1)&'())%>><%=item.getTen()%></option>' &@CRLF & _
						 '<%' &@CRLF & _
							 '}' &@CRLF & _
						 '%>' &@CRLF & _
						'</select>' &@CRLF
			EndIf
	  EndIf
   EndIf

   $row  &= '</td>' &@CRLF & _
		 '</tr>' &@CRLF

   ;Writr to registry
   Local $pathRegistryFormOpen = FileOpen($pathRegistryForm,9)
   FileWrite($pathRegistryFormOpen,$row)
   FileClose($pathRegistryFormOpen)
EndFunc
