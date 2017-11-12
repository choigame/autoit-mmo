<tr>
	<td colspan="2"><label class="egov-label-bold">Giới tính </label>
		<label class="egov-label-red">*</label><br> 
		<select name="NAMEBYTAN" id="NAMEBYTAN" 
		 class="egov-select">
		<option value="-1">Chọn giới tính</option>
		 <%
			for (GioiTinhSoap   item : service.getDSGioiTinh()) {
		 %>
			<option value="<%=item.getId()%>"
				<%=ActionUtils.checkData(item.getId(), hoSo.getUPPERFIRSTLETTER())%>>
				<%=item.getTen()%>
			</option>
		 <%
		 	} 
		 %>
		 </select>
	</td>
</tr>


