<tr>
	<td colspan="2"><label class="egov-label-bold">Dân tộc </label>
		<label class="egov-label-red">*</label><br> 
		<select name="NAMEBYTAN" id="NAMEBYTAN" 
				onchange='setDanToc("","NAMEBYTAN");'
				 class="egov-select">
		<option>Chọn dân tộc</option>
		 <%
			 for (DanTocSoap  item : service.getDanhSachDanToc()) {
		 %>
			 <option value="<%=item.getId()%>"
			<%=ActionUtils.checkData(item.getId(), hoSo.getUPPERFIRSTLETTER())%>><%=item.getTen()%></option>
		 <%
			} 
		 %>
		</select>
	</td>
</tr>