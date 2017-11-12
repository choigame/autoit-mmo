<tr>
	<td colspan="2"><label class="egov-label-bold">Nơi cấp </label><br> 
		<select name="NAMEBYTAN" id="NAMEBYTAN" 
		 class="egov-select">
		<option>--Chọn--</option>
		 <%
		 for (DonViHanhChinh item : DonViHanhChinhLocalServiceUtil.getDanhSachTinhThanh()) {
		 %>
		 <option value="<%=item.getId()%>"
		<%=ActionUtils.checkData(item.getId(), hoSo.getUPPERFIRSTLETTER())%>>
			Cục xuất nhập cảnh <%=item.getTen()%>
			
		</option>
		 <%} %>
		</select>
	</td>
</tr>