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
			long tinhUPPERFIRSTLETTERBYTAN = ActionUtils.getValueLong(request, "tinhNAMEBYTAN");
			if (tinhUPPERFIRSTLETTERBYTAN ==0 ) tinhUPPERFIRSTLETTERBYTAN = hoSo.getTinhUPPERFIRSTLETTERBYTAN();
			if (tinhUPPERFIRSTLETTERBYTAN ==0 ) tinhUPPERFIRSTLETTERBYTAN = donViHanhChinhId;
			for (DonViHanhChinh item : danhSachTinhThanh) {
		%>
			<option value="<%=item.getId()%>"
			<%=ActionUtils.checkData(item.getId(),
			tinhUPPERFIRSTLETTERBYTAN)%>><%=item.getTen()%></option>
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
				donViHanhChinhSoaps = service.getDanhsachDVHC(tinhUPPERFIRSTLETTERBYTAN);
				long quanUPPERFIRSTLETTERBYTAN= ActionUtils.getValueLong(request,
						 "quanNAMEBYTAN"); 
				if (quanUPPERFIRSTLETTERBYTAN == 0) quanUPPERFIRSTLETTERBYTAN = hoSo.getQuanUPPERFIRSTLETTERBYTAN();
				for (DonViHanhChinhSoap item : donViHanhChinhSoaps) {
			%>
				<option value="<%=item.getId()%>"
				<%=ActionUtils.checkData(item.getId(),
					quanUPPERFIRSTLETTERBYTAN)%>><%=item.getTen()%></option>
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
				long xaUPPERFIRSTLETTERBYTAN = ActionUtils.getValueLong(request, "xaNAMEBYTAN");
				if(xaUPPERFIRSTLETTERBYTAN==0) xaUPPERFIRSTLETTERBYTAN = hoSo.getXaUPPERFIRSTLETTERBYTAN();
				List<DonViHanhChinhSoap> danhSachXaThuongTruUPPERFIRSTLETTERBYTAN = service.getDanhsachDVHC(quanUPPERFIRSTLETTERBYTAN);
				if(quanUPPERFIRSTLETTERBYTAN !=0)
				for (DonViHanhChinhSoap item : danhSachXaThuongTruUPPERFIRSTLETTERBYTAN) {
			%>
				<option value="<%=item.getId()%>"
					<%=ActionUtils.checkData(item.getId(),xaUPPERFIRSTLETTERBYTAN)%>><%=item.getTen()%>
				</option>
			<%
				}
			%>
		</select>
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Số nhà/ Đường phố / Ấp / Thôn</label>
		<label class="egov-label-red">*</label><br> 
		<input type="text"
			class="egov-inputfield" name="diaChiNAMEBYTAN"
			id="diaChiNAMEBYTAN" maxlength="MAXLENGTHBYTAN"
			value=" <%=hoSo.getDiaChiUPPERFIRSTLETTERBYTAN()%>" />
	</td>
</tr>



