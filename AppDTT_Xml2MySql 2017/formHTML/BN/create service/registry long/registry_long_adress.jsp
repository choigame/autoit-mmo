<tr>
	<td colspan="6">
		<label class="egov-label-bold">Địa chỉ thường trú</label>
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Tỉnh/Thành phố</label>
		<label class="egov-label-red">*</label>
		<select name="tinhNAMEBYTAN" id="tinhNAMEBYTAN"
		style="width: 96%" class="egov-select"
		onchange='reDrawSelectBox("tinhNAMEBYTAN","quanNAMEBYTAN","xaNAMEBYTAN")'>
		<%
			long tinhUPPERFIRSTLETTER = ActionUtils.getValueLong(request, "tinhNAMEBYTAN");
			if (tinhUPPERFIRSTLETTER ==0 ) tinhUPPERFIRSTLETTER = hoSo.getTinhUPPERFIRSTLETTER();
			if (tinhUPPERFIRSTLETTER ==0 ) tinhUPPERFIRSTLETTER = donViHanhChinhId;
			for (DonViHanhChinh item : danhSachTinhThanh) {
		%>
			<option value="<%=item.getId()%>"
			<%=ActionUtils.checkData(item.getId(),
			tinhUPPERFIRSTLETTER)%>><%=item.getTen()%></option>
		<%
			}
		%>
		</select>
	</td>

	<td colspan="2">
		<label class="egov-label-bold">Quận/Huyện</label>
		<label class="egov-label-red">*</label>
		<select name="quanNAMEBYTAN" id="quanNAMEBYTAN"
			style="width: 96%" class="egov-select"
			onchange='reDrawSelectBox("quanNAMEBYTAN","xaNAMEBYTAN")'>
			<option value="-1">Chọn quận huyện</option>
			<%
				donViHanhChinhSoaps = service.getDanhsachDVHC(tinhUPPERFIRSTLETTER);
				long quanUPPERFIRSTLETTER= ActionUtils.getValueLong(request,
						 "quanNAMEBYTAN"); 
				if (quanUPPERFIRSTLETTER == 0) quanUPPERFIRSTLETTER = hoSo.getQuanUPPERFIRSTLETTER();
				for (DonViHanhChinhSoap item : donViHanhChinhSoaps) {
			%>
				<option value="<%=item.getId()%>"
				<%=ActionUtils.checkData(item.getId(),
					quanUPPERFIRSTLETTER)%>><%=item.getTen()%></option>
			<%
				}
			%>
		</select>
	</td>

	<td colspan="2">
		<label class="egov-label-bold">Phường/Xã/Thị trấn</label>
		<label class="egov-label-red">*</label>
		<select name="xaNAMEBYTAN" id="xaNAMEBYTAN"
			style="width: 97%" class="egov-select">
			<option>Chọn phường xã</option>
			<%
				long xaUPPERFIRSTLETTER = ActionUtils.getValueLong(request, "xaNAMEBYTAN");
				if(xaUPPERFIRSTLETTER==0) xaUPPERFIRSTLETTER = hoSo.getXaUPPERFIRSTLETTER();
				List<DonViHanhChinhSoap> danhSachXaThuongTruUPPERFIRSTLETTER = service.getDanhsachDVHC(quanUPPERFIRSTLETTER);
				if(quanUPPERFIRSTLETTER !=0){
				for (DonViHanhChinhSoap item : danhSachXaThuongTruUPPERFIRSTLETTER) {
			%>
				<option value="<%=item.getId()%>"
					<%=ActionUtils.checkData(item.getId(),xaUPPERFIRSTLETTER)%>><%=item.getTen()%>
				</option>
			<%
				}}
			%>
		</select>
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Số nhà/Đường phố/Ấp/Thôn</label>
		<label class="egov-label-red upper">*</label><br> 
		<input type="text"
			class="egov-inputfield" name="diaChiNAMEBYTAN"
			id="diaChiNAMEBYTAN" maxlength="MAXLENGTHBYTAN"
			value="<%=hoSo.getDiaChiUPPERFIRSTLETTER()%>" />
	</td>
</tr>

<input type="hidden" name="tinhNAMEBYTAN">
<input type="hidden" name="quanNAMEBYTAN">
<input type="hidden" name="xaNAMEBYTAN">
