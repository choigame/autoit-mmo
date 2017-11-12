<!-- TYPEBYTAN -->
<tr>
	<td colspan="6">
		<label class="egov-label">Nơi cấp: 
			<% if(hoSo.getUPPERFIRSTLETTER() >0 &&DonViHanhChinhLocalServiceUtil.fetchDonViHanhChinh(hoSo.getUPPERFIRSTLETTER())!=null){%>
			<%=DonViHanhChinhLocalServiceUtil.fetchDonViHanhChinh(hoSo.getUPPERFIRSTLETTER()).getMa().length()>=4 ? "Cục cảnh sát ĐKQL cư trú và dữ liệu quốc gia về dân cư" : "Công an" %>
			<%=DonViHanhChinhLocalServiceUtil.fetchDonViHanhChinh(hoSo.getUPPERFIRSTLETTER()).getTen()%>
			<%} %>
		</label>
	</td>
</tr>