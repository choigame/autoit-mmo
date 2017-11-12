<tr>
	<td colspan="6"><label class="egov-label-bold">Nơi cấp:</label> 
	<label class="egov-label">
		<% if(hoSo.getNoiCapCmnd() >0 &&DonViHanhChinhLocalServiceUtil.fetchDonViHanhChinh(hoSo.getNoiCapCmnd())!=null){%>
		<%=DonViHanhChinhLocalServiceUtil.fetchDonViHanhChinh(hoSo.getNoiCapCmnd()).getMa().length()>=4 ? "Cục cảnh sát ĐKQL cư trú và dữ liệu quốc gia về dân cư" : "Công an" %> 
		<%=DonViHanhChinhLocalServiceUtil.fetchDonViHanhChinh(hoSo.getNoiCapCmnd()).getTen()%>
		</label>
		<%} %>
	</td>
</tr>