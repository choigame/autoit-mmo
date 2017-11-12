<tr>
	<td colspan="2">
		<label class="egov-label-bold">Số </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield onlyNumeric" 
			name="cmndNAMEBYTAN" id="cmndNAMEBYTAN" 
			maxlength="12"
			value="<%=hoSo.getCmndUPPERFIRSTLETTER() %>" />
	</td>

	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="ngayCapCmndNAMEBYTAN" id="ngayCapCmndNAMEBYTAN" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getNgayCapCmndUPPERFIRSTLETTER()) %>"/>
	</td>

	<td colspan="2"><label class="egov-label-bold">Nơi cấp </label>
	<label class="egov-label-red">*</label> <br> 
		<select class="egov-select" name="noiCapCmndNAMEBYTAN" id="noiCapCmndNAMEBYTAN">
			<option>
				--Chọn--
			</option>
			<%
				for (DonViHanhChinh item : DonViHanhChinhLocalServiceUtil.getDanhSachNoiCapCMND()) {
			%>
			<option value="<%=item.getId()%>"
				<%=ActionUtils.checkData(item.getId(), hoSo.getNoiCapCmndUPPERFIRSTLETTER())%>>
				<%=item.getMa().length()>=4 ? "Cục cảnh sát ĐKQL cư trú và dữ liệu quốc gia về dân cư" : "Công an"%>
				<%=item.getTen()%>
			</option>
			<%}%>
		</select>
	</td>
</tr>