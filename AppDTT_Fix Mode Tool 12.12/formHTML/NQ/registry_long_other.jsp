<tr>
	<td colspan="3"><label class="egov-label-bold">UPPERFIRSTLETTER </label>
	<label class="egov-label-red">*</label><br> 
		<select name="NAMEBYTAN" id="NAMEBYTAN" 
		 class="egov-select">
			<option value="-1">Chọn UPPERFIRSTLETTER</option>
			 <%
				for (UPPERFIRSTLETTER item : UPPERFIRSTLETTERocalServiceUtil.getUPPERFIRSTLETTERs(-1,-1)) {
			 %>
				<option value="<%=item.getId()%>"
			  		<%=ActionUtils.checkData(item.getId(), hoSo.getUPPERFIRSTLETTER())%>><%=item.getTen()%>
			  	</option>
			 <%
				 } 
			 %>
		</select>
	</td>
</tr>