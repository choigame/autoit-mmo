<tr>
	<td colspan="2"><label class="egov-label-bold">UPPERFIRSTLETTER </label>
		<label class="egov-label-red">*</label> <br> 
		<select name="NAMEBYTAN" id="NAMEBYTAN" 
		onchange='checkDanToc("NAMEBYTAN","");'
		 class="egov-select">
		<option>--Chọn--</option>
		 <%
		 for (QuocGiaSoap item : service.getDanhSachQuocGia()) {
		 %>
		 <option value="<%=item.getId()%>"
			<%=ActionUtils.checkData(item.getId(), hoSo.getUPPERFIRSTLETTER())%>>
			Cục xuất nhập cảnh <%=item.getTen()%></option>
		 <%} %>
		 </select>
	</td>
</tr>