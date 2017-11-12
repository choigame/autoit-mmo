<tr>
	<td colspan="6"><label class="egov-label-bold">Nơi cấp </label>
	<label class="egov-label-red">*</label> <br> 
		<select class="egov-select" name="NAMEBYTAN" id="NAMEBYTAN">
			<option>
				--Chọn--
			</option>
			<%
				for (DonViHanhChinh item : DonViHanhChinhLocalServiceUtil.getDanhSachNoiCapCMND()) {
			%>
			<option value="<%=item.getId()%>"
				<%=ActionUtils.checkData(item.getId(), hoSo.getUPPERFIRSTLETTER())%>>
				<%=item.getMa().length()>=4 ? "Cục cảnh sát ĐKQL cư trú và dữ liệu quốc gia về dân cư" : "Công an"%> 
				<%=item.getTen()%>
			</option>
			<%}%>
		</select>
	</td>
</tr>