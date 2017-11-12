<tr>
	<td colspan="2"><label class="egov-label-bold">Quan hệ </label>
		<label class="egov-label-red">*</label> <br> 
		<select name="NAMEBYTAN" id="NAMEBYTAN" 
		 class="egov-select">
		<option value="-1">Chọn quan hệ</option>
		 <%
		 	for (QuanHeGiaDinh  item : QuanHeGiaDinhLocalServiceUtil.getQuanHeGiaDinhs(-1,-1)) {
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