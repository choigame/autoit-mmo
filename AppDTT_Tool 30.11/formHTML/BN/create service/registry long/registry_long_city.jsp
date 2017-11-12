<tr>
	<td colspan="2"><label class="egov-label-bold">Tỉnh/Thành </label><br> 
		<select name="NAMEBYTAN" id="NAMEBYTAN" 
		 class="egov-select">
		<option>Chọn tỉnh/thành</option>
		 <%
		 for (DonViHanhChinh item : DonViHanhChinhLocalServiceUtil.getDanhSachTinhThanh()) {
		 %>
		 <option value="<%=item.getId()%>"
		<%=ActionUtils.checkData(item.getId(), hoSo.getUPPERFIRSTLETTER())%>><%=item.getTen()%></option>
		 <%} %>
		</select>
	</td>
</tr>