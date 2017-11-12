<tr>
	<td colspan="2"><label class="egov-label-bold">Nghề nghiệp </label>
		<label class="egov-label-red">*</label><br> 
		<select name="NAMEBYTAN" id="NAMEBYTAN" 
			 		class="egov-select">
			<option value="-1">Chọn nghề nghiệp</option>
			 <%
			for (NgheNghiep item : NgheNghiepLocalServiceUtil.findAll()) {
			 %>
			<option value="<%=item.getId()%>"
			<%=ActionUtils.checkData(item.getId(), hoSo.getUPPERFIRSTLETTER())%>><%=item.getTen()%></option>
			<%
			 	}
			%>
		 </select>
	</td>
</tr>