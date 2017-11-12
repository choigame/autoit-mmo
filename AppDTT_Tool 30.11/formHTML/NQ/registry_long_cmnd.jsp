<tr>
	<td colspan="6"><label class="egov-label-bold">Cơ quan cấp </label>
	<label class="egov-label-red">*</label> <br> 
		<select class="egov-select" name="NAMEBYTAN" id="NAMEBYTAN">
			<option>
				Chọn nơi cấp
			</option>
			<%
				for (DonViHanhChinh item : DonViHanhChinhLocalServiceUtil.getDanhSachNoiCapCMND()) {
			%>
			<option value="<%=item.getId()%>"
				<%=ActionUtils.checkData(item.getId(), hoSo.getUPPERFIRSTLETTER())%>>
				<%=item.getMa().length()>=4 ? "Cục cảnh sát ĐKQL cư trú và dữ liệu quốc gia về dân cư" : "Công an"%>&nbsp;
				<%=item.getTen()%>
			</option>
			<%}%>
		</select>
	</td>
</tr>