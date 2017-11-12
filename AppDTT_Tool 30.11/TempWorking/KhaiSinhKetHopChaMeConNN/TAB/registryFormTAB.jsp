<tr>
	<td colspan="6">
		<label class="egov-label-bold">Ten1Tab1 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="ten1Tab1TabByTan" id="ten1Tab1TabByTan" maxlength="200"
			value="<%=hoSo.getTen1Tab1() %>" />
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Quốc gia </label>
		<label class="egov-label-red">*</label> <br> 
		<select name="quocGia1Tab1TabByTan" id="quocGia1Tab1TabByTan" 
		onchange='checkDanToc("quocGia1Tab1TabByTan","");'
		 class="egov-select">
		<option>Chọn nước</option>
		 <%
		 for (QuocGiaSoap item : service.getDanhSachQuocGia()) {
		 %>
		 <option value="<%=item.getId()%>"
			<%=ActionUtils.checkData(item.getId(), hoSo.getQuocGia1Tab1())%>><%=item.getTen()%></option>
		 <%} %>
		 </select>
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Địa chỉ thường trú</label>
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Tỉnh/Thành phố</label>
		<label class="egov-label-red">*</label>
		<select name="tinh1TabByTan" id="tinh1TabByTan"
		style="width: 96%" class="egov-select"
		onchange='reDrawSelectBox("tinh1TabByTan","quan1TabByTan","xa1TabByTan")'>
		<%
			long tinh1 = ActionUtils.getValueLong(request, "tinh1TabByTan");
			if (tinh1 ==0 ) tinh1 = hoSo.getTinh1();
			if (tinh1 ==0 ) tinh1 = donViHanhChinhId;
			for (DonViHanhChinh item : danhSachTinhThanh) {
		%>
			<option value="<%=item.getId()%>"
			<%=ActionUtils.checkData(item.getId(),
			tinh1)%>><%=item.getTen()%></option>
		<%
			}
		%>
		</select>
	</td>

	<td colspan="2">
		<label class="egov-label-bold">Quận/Huyện</label>
		<label class="egov-label-red">*</label>
		<select name="quan1TabByTan" id="quan1TabByTan"
			style="width: 96%" class="egov-select"
			onchange='reDrawSelectBox("quan1TabByTan","xa1TabByTan")'>
			<option value="-1">Chọn quận huyện</option>
			<%
				donViHanhChinhSoaps = service.getDanhsachDVHC(tinh1);
				long quan1= ActionUtils.getValueLong(request,
						 "quan1TabByTan"); 
				if (quan1 == 0) quan1 = hoSo.getQuan1();
				for (DonViHanhChinhSoap item : donViHanhChinhSoaps) {
			%>
				<option value="<%=item.getId()%>"
				<%=ActionUtils.checkData(item.getId(),
					quan1)%>><%=item.getTen()%></option>
			<%
				}
			%>
		</select>
	</td>

	<td colspan="2">
		<label class="egov-label-bold">Phường/Xã/Thị trấn</label>
		<label class="egov-label-red">*</label>
		<select name="xa1TabByTan" id="xa1TabByTan"
			style="width: 97%" class="egov-select">
			<option>Chọn phường xã</option>
			<%
				long xa1 = ActionUtils.getValueLong(request, "xa1TabByTan");
				if(xa1==0) xa1 = hoSo.getXa1();
				List<DonViHanhChinhSoap> danhSachXaThuongTru1 = service.getDanhsachDVHC(quan1);
				if(quan1 !=0){
				for (DonViHanhChinhSoap item : danhSachXaThuongTru1) {
			%>
				<option value="<%=item.getId()%>"
					<%=ActionUtils.checkData(item.getId(),xa1)%>><%=item.getTen()%>
				</option>
			<%
				}}
			%>
		</select>
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Số nhà/Đường phố/Ấp/Thôn</label>
		<label class="egov-label-red">*</label><br> 
		<input type="text"
			class="egov-inputfield" name="diaChi1TabByTan"
			id="diaChi1TabByTan" maxlength="200"
			value="<%=hoSo.getDiaChi1()%>" />
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Radio1Tab1 </label>
		<br>
		<input type="text" class="egov-inputfield" name="radio1Tab1TabByTan" id="radio1Tab1TabByTan" maxlength="200"
			value="<%=hoSo.getRadio1Tab1() %>" />
	</td>
</tr>

<tr>
	<td colspan="2">
	<label class="egov-label-bold">Số </label>
	<label class="egov-label-red">*</label><br>
	<input type="text" class="egov-inputfield onlyNumeric" 
			name="cmnd1Tab1TabByTan" id="cmnd1Tab1TabByTan" maxlength="12"
					value="<%=hoSo.getCmnd1Tab1() %>" />
	</td>
</tr>

<tr>
	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="ngayCapCmnd1Tab1TabByTan" id="ngayCapCmnd1Tab1TabByTan" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getNgayCapCmnd1Tab1()) %>"/>
	</td>
</tr>

<tr>
	<td colspan="6"><label class="egov-label-bold">Cơ quan cấp </label>
	<label class="egov-label-red">*</label> <br> 
		<select class="egov-select" name="noiCapCmnd1Tab1TabByTan" id="noiCapCmnd1Tab1TabByTan">
			<option>
				Chọn nơi cấp
			</option>
			<%
				for (DonViHanhChinh item : DonViHanhChinhLocalServiceUtil.getDanhSachNoiCapCMND()) {
			%>
			<option value="<%=item.getId()%>"
				<%=ActionUtils.checkData(item.getId(), hoSo.getNoiCapCmnd1Tab1())%>>
				<%=item.getMa().length()>=4 ? "Cục cảnh sát ĐKQL cư trú và dữ liệu quốc gia về dân cư" : "Công an"%>&nbsp;
				<%=item.getTen()%>
			</option>
			<%}%>
		</select>
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">HoChieu1Tab1 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="hoChieu1Tab1TabByTan" id="hoChieu1Tab1TabByTan" maxlength="200"
			value="<%=hoSo.getHoChieu1Tab1() %>" />
	</td>
</tr>

<tr>
	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="ngayCapHoChieu1Tab1TabByTan" id="ngayCapHoChieu1Tab1TabByTan" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getNgayCapHoChieu1Tab1()) %>"/>
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">NoiCapHoChieu1Tab1 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="noiCapHoChieu1Tab1TabByTan" id="noiCapHoChieu1Tab1TabByTan" maxlength="200"
			value="<%=hoSo.getNoiCapHoChieu1Tab1() %>" />
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">TenGTK1Tab1 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="tenGTK1Tab1TabByTan" id="tenGTK1Tab1TabByTan" maxlength="200"
			value="<%=hoSo.getTenGTK1Tab1() %>" />
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">SoGTK1Tab1 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="soGTK1Tab1TabByTan" id="soGTK1Tab1TabByTan" maxlength="200"
			value="<%=hoSo.getSoGTK1Tab1() %>" />
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">NoiCapGTK1Tab1 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="noiCapGTK1Tab1TabByTan" id="noiCapGTK1Tab1TabByTan" maxlength="200"
			value="<%=hoSo.getNoiCapGTK1Tab1() %>" />
	</td>
</tr>

<tr>
	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="ngayCapGTK1Tab1TabByTan" id="ngayCapGTK1Tab1TabByTan" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getNgayCapGTK1Tab1()) %>"/>
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Quan hệ </label>
		<label class="egov-label-red">*</label> <br> 
		<select name="quanHe1Tab1TabByTan" id="quanHe1Tab1TabByTan" 
		 class="egov-select">
		<option value="-1">Chọn quan hệ</option>
		 <%
		 	for (QuanHeGiaDinh  item : QuanHeGiaDinhLocalServiceUtil.getQuanHeGiaDinhs(-1,-1)) {
		 %>
			<option value="<%=item.getId()%>"
				<%=ActionUtils.checkData(item.getId(), hoSo.getQuanHe1Tab1())%>>
				<%=item.getTen()%>
			</option>
		 <%
			 }
		 %>
		 </select>
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Ten2Tab1 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="ten2Tab1TabByTan" id="ten2Tab1TabByTan" maxlength="200"
			value="<%=hoSo.getTen2Tab1() %>" />
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Giới tính </label>
		<label class="egov-label-red">*</label><br> 
		<select name="sex1Tab1TabByTan" id="sex1Tab1TabByTan" 
		 class="egov-select">
		<option>Chọn giới tính</option>
		 <%
			for (GioiTinhSoap   item : service.getDSGioiTinh()) {
		 %>
			<option value="<%=item.getId()%>"
				<%=ActionUtils.checkData(item.getId(), hoSo.getSex1Tab1())%>>
				<%=item.getTen()%>
			</option>
		 <%
		 	} 
		 %>
		 </select>
	</td>
</tr>




<tr>
	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="ngaySinh1Tab1TabByTan" id="ngaySinh1Tab1TabByTan" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getNgaySinh1Tab1()) %>"/>
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">NgaySinhBangChu1Tab1 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="ngaySinhBangChu1Tab1TabByTan" id="ngaySinhBangChu1Tab1TabByTan" maxlength="200"
			value="<%=hoSo.getNgaySinhBangChu1Tab1() %>" />
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Giới tính </label>
		<label class="egov-label-red">*</label><br> 
		<select name="sex2Tab1TabByTan" id="sex2Tab1TabByTan" 
		 class="egov-select">
		<option>Chọn giới tính</option>
		 <%
			for (GioiTinhSoap   item : service.getDSGioiTinh()) {
		 %>
			<option value="<%=item.getId()%>"
				<%=ActionUtils.checkData(item.getId(), hoSo.getSex2Tab1())%>>
				<%=item.getTen()%>
			</option>
		 <%
		 	} 
		 %>
		 </select>
	</td>
</tr>




<tr>
	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="birth2Tab1TabByTan" id="birth2Tab1TabByTan" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getBirth2Tab1()) %>"/>
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Birth2BangChuTab1 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="birth2BangChuTab1TabByTan" id="birth2BangChuTab1TabByTan" maxlength="200"
			value="<%=hoSo.getBirth2BangChuTab1() %>" />
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Dân tộc </label>
		<label class="egov-label-red">*</label><br> 
		<select name="danToc2Tab1TabByTan" id="danToc2Tab1TabByTan" 
				onchange='setDanToc("","danToc2Tab1TabByTan");'
				 class="egov-select">
		<option>Chọn dân tộc</option>
		 <%
			 for (DanTocSoap  item : service.getDanhSachDanToc()) {
		 %>
			 <option value="<%=item.getId()%>"
			<%=ActionUtils.checkData(item.getId(), hoSo.getDanToc2Tab1())%>><%=item.getTen()%></option>
		 <%
			} 
		 %>
		</select>
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Dân tộc </label>
		<label class="egov-label-red">*</label><br> 
		<select name="quocTich2Tab1TabByTan" id="quocTich2Tab1TabByTan" 
				onchange='setDanToc("","quocTich2Tab1TabByTan");'
				 class="egov-select">
		<option>Chọn dân tộc</option>
		 <%
			 for (DanTocSoap  item : service.getDanhSachDanToc()) {
		 %>
			 <option value="<%=item.getId()%>"
			<%=ActionUtils.checkData(item.getId(), hoSo.getQuocTich2Tab1())%>><%=item.getTen()%></option>
		 <%
			} 
		 %>
		</select>
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Quốc gia </label>
		<label class="egov-label-red">*</label> <br> 
		<select name="quocGia2Tab1TabByTan" id="quocGia2Tab1TabByTan" 
		onchange='checkDanToc("quocGia2Tab1TabByTan","");'
		 class="egov-select">
		<option>Chọn nước</option>
		 <%
		 for (QuocGiaSoap item : service.getDanhSachQuocGia()) {
		 %>
		 <option value="<%=item.getId()%>"
			<%=ActionUtils.checkData(item.getId(), hoSo.getQuocGia2Tab1())%>><%=item.getTen()%></option>
		 <%} %>
		 </select>
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Địa chỉ thường trú</label>
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Tỉnh/Thành phố</label>
		<label class="egov-label-red">*</label>
		<select name="tinh2TabByTan" id="tinh2TabByTan"
		style="width: 96%" class="egov-select"
		onchange='reDrawSelectBox("tinh2TabByTan","quan2TabByTan","xa2TabByTan")'>
		<%
			long tinh2 = ActionUtils.getValueLong(request, "tinh2TabByTan");
			if (tinh2 ==0 ) tinh2 = hoSo.getTinh2();
			if (tinh2 ==0 ) tinh2 = donViHanhChinhId;
			for (DonViHanhChinh item : danhSachTinhThanh) {
		%>
			<option value="<%=item.getId()%>"
			<%=ActionUtils.checkData(item.getId(),
			tinh2)%>><%=item.getTen()%></option>
		<%
			}
		%>
		</select>
	</td>

	<td colspan="2">
		<label class="egov-label-bold">Quận/Huyện</label>
		<label class="egov-label-red">*</label>
		<select name="quan2TabByTan" id="quan2TabByTan"
			style="width: 96%" class="egov-select"
			onchange='reDrawSelectBox("quan2TabByTan","xa2TabByTan")'>
			<option value="-1">Chọn quận huyện</option>
			<%
				donViHanhChinhSoaps = service.getDanhsachDVHC(tinh2);
				long quan2= ActionUtils.getValueLong(request,
						 "quan2TabByTan"); 
				if (quan2 == 0) quan2 = hoSo.getQuan2();
				for (DonViHanhChinhSoap item : donViHanhChinhSoaps) {
			%>
				<option value="<%=item.getId()%>"
				<%=ActionUtils.checkData(item.getId(),
					quan2)%>><%=item.getTen()%></option>
			<%
				}
			%>
		</select>
	</td>

	<td colspan="2">
		<label class="egov-label-bold">Phường/Xã/Thị trấn</label>
		<label class="egov-label-red">*</label>
		<select name="xa2TabByTan" id="xa2TabByTan"
			style="width: 97%" class="egov-select">
			<option>Chọn phường xã</option>
			<%
				long xa2 = ActionUtils.getValueLong(request, "xa2TabByTan");
				if(xa2==0) xa2 = hoSo.getXa2();
				List<DonViHanhChinhSoap> danhSachXaThuongTru2 = service.getDanhsachDVHC(quan2);
				if(quan2 !=0){
				for (DonViHanhChinhSoap item : danhSachXaThuongTru2) {
			%>
				<option value="<%=item.getId()%>"
					<%=ActionUtils.checkData(item.getId(),xa2)%>><%=item.getTen()%>
				</option>
			<%
				}}
			%>
		</select>
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Số nhà/Đường phố/Ấp/Thôn</label>
		<label class="egov-label-red">*</label><br> 
		<input type="text"
			class="egov-inputfield" name="diaChi2TabByTan"
			id="diaChi2TabByTan" maxlength="200"
			value="<%=hoSo.getDiaChi2()%>" />
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Ten3Tab1 </label>
		<br>
		<input type="text" class="egov-inputfield" name="ten3Tab1TabByTan" id="ten3Tab1TabByTan" maxlength="200"
			value="<%=hoSo.getTen3Tab1() %>" />
	</td>
</tr>

<tr>
	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="birth3Tab1TabByTan" id="birth3Tab1TabByTan" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getBirth3Tab1()) %>"/>
	</td>
</tr>
<tr>
	<td colspan="2"><label class="egov-label-bold">Dân tộc </label>
		<br> 
		<select name="danToc3Tab1TabByTan" id="danToc3Tab1TabByTan" 
				onchange='setDanToc("","danToc3Tab1TabByTan");'
				 class="egov-select">
		<option>Chọn dân tộc</option>
		 <%
			 for (DanTocSoap  item : service.getDanhSachDanToc()) {
		 %>
			 <option value="<%=item.getId()%>"
			<%=ActionUtils.checkData(item.getId(), hoSo.getDanToc3Tab1())%>><%=item.getTen()%></option>
		 <%
			} 
		 %>
		</select>
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Quốc gia </label>
		<label class="egov-label-red">*</label> <br> 
		<select name="quocTich3Tab1TabByTan" id="quocTich3Tab1TabByTan" 
		onchange='checkDanToc("quocTich3Tab1TabByTan","");'
		 class="egov-select">
		<option>Chọn nước</option>
		 <%
		 for (QuocGiaSoap item : service.getDanhSachQuocGia()) {
		 %>
		 <option value="<%=item.getId()%>"
			<%=ActionUtils.checkData(item.getId(), hoSo.getQuocTich3Tab1())%>><%=item.getTen()%></option>
		 <%} %>
		 </select>
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Quốc gia </label>
		<label class="egov-label-red">*</label> <br> 
		<select name="quocGia3Tab1TabByTan" id="quocGia3Tab1TabByTan" 
		onchange='checkDanToc("quocGia3Tab1TabByTan","");'
		 class="egov-select">
		<option>Chọn nước</option>
		 <%
		 for (QuocGiaSoap item : service.getDanhSachQuocGia()) {
		 %>
		 <option value="<%=item.getId()%>"
			<%=ActionUtils.checkData(item.getId(), hoSo.getQuocGia3Tab1())%>><%=item.getTen()%></option>
		 <%} %>
		 </select>
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Địa chỉ thường trú</label>
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Tỉnh/Thành phố</label>
		<label class="egov-label-red">*</label>
		<select name="tinh3TabByTan" id="tinh3TabByTan"
		style="width: 96%" class="egov-select"
		onchange='reDrawSelectBox("tinh3TabByTan","quan3TabByTan","xa3TabByTan")'>
		<%
			long tinh3 = ActionUtils.getValueLong(request, "tinh3TabByTan");
			if (tinh3 ==0 ) tinh3 = hoSo.getTinh3();
			if (tinh3 ==0 ) tinh3 = donViHanhChinhId;
			for (DonViHanhChinh item : danhSachTinhThanh) {
		%>
			<option value="<%=item.getId()%>"
			<%=ActionUtils.checkData(item.getId(),
			tinh3)%>><%=item.getTen()%></option>
		<%
			}
		%>
		</select>
	</td>

	<td colspan="2">
		<label class="egov-label-bold">Quận/Huyện</label>
		<label class="egov-label-red">*</label>
		<select name="quan3TabByTan" id="quan3TabByTan"
			style="width: 96%" class="egov-select"
			onchange='reDrawSelectBox("quan3TabByTan","xa3TabByTan")'>
			<option value="-1">Chọn quận huyện</option>
			<%
				donViHanhChinhSoaps = service.getDanhsachDVHC(tinh3);
				long quan3= ActionUtils.getValueLong(request,
						 "quan3TabByTan"); 
				if (quan3 == 0) quan3 = hoSo.getQuan3();
				for (DonViHanhChinhSoap item : donViHanhChinhSoaps) {
			%>
				<option value="<%=item.getId()%>"
				<%=ActionUtils.checkData(item.getId(),
					quan3)%>><%=item.getTen()%></option>
			<%
				}
			%>
		</select>
	</td>

	<td colspan="2">
		<label class="egov-label-bold">Phường/Xã/Thị trấn</label>
		<label class="egov-label-red">*</label>
		<select name="xa3TabByTan" id="xa3TabByTan"
			style="width: 97%" class="egov-select">
			<option>Chọn phường xã</option>
			<%
				long xa3 = ActionUtils.getValueLong(request, "xa3TabByTan");
				if(xa3==0) xa3 = hoSo.getXa3();
				List<DonViHanhChinhSoap> danhSachXaThuongTru3 = service.getDanhsachDVHC(quan3);
				if(quan3 !=0){
				for (DonViHanhChinhSoap item : danhSachXaThuongTru3) {
			%>
				<option value="<%=item.getId()%>"
					<%=ActionUtils.checkData(item.getId(),xa3)%>><%=item.getTen()%>
				</option>
			<%
				}}
			%>
		</select>
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Số nhà/Đường phố/Ấp/Thôn</label>
		<label class="egov-label-red">*</label><br> 
		<input type="text"
			class="egov-inputfield" name="diaChi3TabByTan"
			id="diaChi3TabByTan" maxlength="200"
			value="<%=hoSo.getDiaChi3()%>" />
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Ten4Tab1 </label>
		<br>
		<input type="text" class="egov-inputfield" name="ten4Tab1TabByTan" id="ten4Tab1TabByTan" maxlength="200"
			value="<%=hoSo.getTen4Tab1() %>" />
	</td>
</tr>

<tr>
	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="birth4Tab1TabByTan" id="birth4Tab1TabByTan" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getBirth4Tab1()) %>"/>
	</td>
</tr>
<tr>
	<td colspan="2"><label class="egov-label-bold">Dân tộc </label>
		<label class="egov-label-red">*</label><br> 
		<select name="danToc4Tab1TabByTan" id="danToc4Tab1TabByTan" 
				onchange='setDanToc("","danToc4Tab1TabByTan");'
				 class="egov-select">
		<option>Chọn dân tộc</option>
		 <%
			 for (DanTocSoap  item : service.getDanhSachDanToc()) {
		 %>
			 <option value="<%=item.getId()%>"
			<%=ActionUtils.checkData(item.getId(), hoSo.getDanToc4Tab1())%>><%=item.getTen()%></option>
		 <%
			} 
		 %>
		</select>
	</td>
</tr>





<tr>
	<td colspan="6">
		<label class="egov-label-bold">Địa chỉ thường trú</label>
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Tỉnh/Thành phố</label>
		<label class="egov-label-red">*</label>
		<select name="tinh4TabByTan" id="tinh4TabByTan"
		style="width: 96%" class="egov-select"
		onchange='reDrawSelectBox("tinh4TabByTan","quan4TabByTan","xa4TabByTan")'>
		<%
			long tinh4 = ActionUtils.getValueLong(request, "tinh4TabByTan");
			if (tinh4 ==0 ) tinh4 = hoSo.getTinh4();
			if (tinh4 ==0 ) tinh4 = donViHanhChinhId;
			for (DonViHanhChinh item : danhSachTinhThanh) {
		%>
			<option value="<%=item.getId()%>"
			<%=ActionUtils.checkData(item.getId(),
			tinh4)%>><%=item.getTen()%></option>
		<%
			}
		%>
		</select>
	</td>

	<td colspan="2">
		<label class="egov-label-bold">Quận/Huyện</label>
		<label class="egov-label-red">*</label>
		<select name="quan4TabByTan" id="quan4TabByTan"
			style="width: 96%" class="egov-select"
			onchange='reDrawSelectBox("quan4TabByTan","xa4TabByTan")'>
			<option value="-1">Chọn quận huyện</option>
			<%
				donViHanhChinhSoaps = service.getDanhsachDVHC(tinh4);
				long quan4= ActionUtils.getValueLong(request,
						 "quan4TabByTan"); 
				if (quan4 == 0) quan4 = hoSo.getQuan4();
				for (DonViHanhChinhSoap item : donViHanhChinhSoaps) {
			%>
				<option value="<%=item.getId()%>"
				<%=ActionUtils.checkData(item.getId(),
					quan4)%>><%=item.getTen()%></option>
			<%
				}
			%>
		</select>
	</td>

	<td colspan="2">
		<label class="egov-label-bold">Phường/Xã/Thị trấn</label>
		<label class="egov-label-red">*</label>
		<select name="xa4TabByTan" id="xa4TabByTan"
			style="width: 97%" class="egov-select">
			<option>Chọn phường xã</option>
			<%
				long xa4 = ActionUtils.getValueLong(request, "xa4TabByTan");
				if(xa4==0) xa4 = hoSo.getXa4();
				List<DonViHanhChinhSoap> danhSachXaThuongTru4 = service.getDanhsachDVHC(quan4);
				if(quan4 !=0){
				for (DonViHanhChinhSoap item : danhSachXaThuongTru4) {
			%>
				<option value="<%=item.getId()%>"
					<%=ActionUtils.checkData(item.getId(),xa4)%>><%=item.getTen()%>
				</option>
			<%
				}}
			%>
		</select>
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Số nhà/Đường phố/Ấp/Thôn</label>
		<label class="egov-label-red">*</label><br> 
		<input type="text"
			class="egov-inputfield" name="diaChi4TabByTan"
			id="diaChi4TabByTan" maxlength="200"
			value="<%=hoSo.getDiaChi4()%>" />
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Ten1Tab2 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="ten1Tab2TabByTan" id="ten1Tab2TabByTan" maxlength="200"
			value="<%=hoSo.getTen1Tab2() %>" />
	</td>
</tr>

<tr>
	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="birth1Tab2TabByTan" id="birth1Tab2TabByTan" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getBirth1Tab2()) %>"/>
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Dân tộc </label>
		<label class="egov-label-red">*</label><br> 
		<select name="danToc1Tab2TabByTan" id="danToc1Tab2TabByTan" 
				onchange='setDanToc("","danToc1Tab2TabByTan");'
				 class="egov-select">
		<option>Chọn dân tộc</option>
		 <%
			 for (DanTocSoap  item : service.getDanhSachDanToc()) {
		 %>
			 <option value="<%=item.getId()%>"
			<%=ActionUtils.checkData(item.getId(), hoSo.getDanToc1Tab2())%>><%=item.getTen()%></option>
		 <%
			} 
		 %>
		</select>
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Quốc gia </label>
		<label class="egov-label-red">*</label> <br> 
		<select name="quocTich1Tab2TabByTan" id="quocTich1Tab2TabByTan" 
		onchange='checkDanToc("quocTich1Tab2TabByTan","");'
		 class="egov-select">
		<option>Chọn nước</option>
		 <%
		 for (QuocGiaSoap item : service.getDanhSachQuocGia()) {
		 %>
		 <option value="<%=item.getId()%>"
			<%=ActionUtils.checkData(item.getId(), hoSo.getQuocTich1Tab2())%>><%=item.getTen()%></option>
		 <%} %>
		 </select>
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Địa chỉ thường trú</label>
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Tỉnh/Thành phố</label>
		<label class="egov-label-red">*</label>
		<select name="tinh5TabByTan" id="tinh5TabByTan"
		style="width: 96%" class="egov-select"
		onchange='reDrawSelectBox("tinh5TabByTan","quan5TabByTan","xa5TabByTan")'>
		<%
			long tinh5 = ActionUtils.getValueLong(request, "tinh5TabByTan");
			if (tinh5 ==0 ) tinh5 = hoSo.getTinh5();
			if (tinh5 ==0 ) tinh5 = donViHanhChinhId;
			for (DonViHanhChinh item : danhSachTinhThanh) {
		%>
			<option value="<%=item.getId()%>"
			<%=ActionUtils.checkData(item.getId(),
			tinh5)%>><%=item.getTen()%></option>
		<%
			}
		%>
		</select>
	</td>

	<td colspan="2">
		<label class="egov-label-bold">Quận/Huyện</label>
		<label class="egov-label-red">*</label>
		<select name="quan5TabByTan" id="quan5TabByTan"
			style="width: 96%" class="egov-select"
			onchange='reDrawSelectBox("quan5TabByTan","xa5TabByTan")'>
			<option value="-1">Chọn quận huyện</option>
			<%
				donViHanhChinhSoaps = service.getDanhsachDVHC(tinh5);
				long quan5= ActionUtils.getValueLong(request,
						 "quan5TabByTan"); 
				if (quan5 == 0) quan5 = hoSo.getQuan5();
				for (DonViHanhChinhSoap item : donViHanhChinhSoaps) {
			%>
				<option value="<%=item.getId()%>"
				<%=ActionUtils.checkData(item.getId(),
					quan5)%>><%=item.getTen()%></option>
			<%
				}
			%>
		</select>
	</td>

	<td colspan="2">
		<label class="egov-label-bold">Phường/Xã/Thị trấn</label>
		<label class="egov-label-red">*</label>
		<select name="xa5TabByTan" id="xa5TabByTan"
			style="width: 97%" class="egov-select">
			<option>Chọn phường xã</option>
			<%
				long xa5 = ActionUtils.getValueLong(request, "xa5TabByTan");
				if(xa5==0) xa5 = hoSo.getXa5();
				List<DonViHanhChinhSoap> danhSachXaThuongTru5 = service.getDanhsachDVHC(quan5);
				if(quan5 !=0){
				for (DonViHanhChinhSoap item : danhSachXaThuongTru5) {
			%>
				<option value="<%=item.getId()%>"
					<%=ActionUtils.checkData(item.getId(),xa5)%>><%=item.getTen()%>
				</option>
			<%
				}}
			%>
		</select>
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Số nhà/Đường phố/Ấp/Thôn</label>
		<label class="egov-label-red">*</label><br> 
		<input type="text"
			class="egov-inputfield" name="diaChi5TabByTan"
			id="diaChi5TabByTan" maxlength="200"
			value="<%=hoSo.getDiaChi5()%>" />
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Radio1Tab2 </label>
		<br>
		<input type="text" class="egov-inputfield" name="radio1Tab2TabByTan" id="radio1Tab2TabByTan" maxlength="200"
			value="<%=hoSo.getRadio1Tab2() %>" />
	</td>
</tr>

<tr>
	<td colspan="2">
	<label class="egov-label-bold">Số </label>
	<label class="egov-label-red">*</label><br>
	<input type="text" class="egov-inputfield onlyNumeric" 
			name="cmnd1Tab2TabByTan" id="cmnd1Tab2TabByTan" maxlength="12"
					value="<%=hoSo.getCmnd1Tab2() %>" />
	</td>
</tr>

<tr>
	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="ngayCapCmnd1Tab2TabByTan" id="ngayCapCmnd1Tab2TabByTan" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getNgayCapCmnd1Tab2()) %>"/>
	</td>
</tr>
<tr>
	<td colspan="6"><label class="egov-label-bold">Cơ quan cấp </label>
	 <br> 
		<select class="egov-select" name="noiCapCmnd1Tab2TabByTan" id="noiCapCmnd1Tab2TabByTan">
			<option>
				Chọn nơi cấp
			</option>
			<%
				for (DonViHanhChinh item : DonViHanhChinhLocalServiceUtil.getDanhSachNoiCapCMND()) {
			%>
			<option value="<%=item.getId()%>"
				<%=ActionUtils.checkData(item.getId(), hoSo.getNoiCapCmnd1Tab2())%>>
				<%=item.getMa().length()>=4 ? "Cục cảnh sát ĐKQL cư trú và dữ liệu quốc gia về dân cư" : "Công an"%>&nbsp;
				<%=item.getTen()%>
			</option>
			<%}%>
		</select>
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">HoChieu1Tab2 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="hoChieu1Tab2TabByTan" id="hoChieu1Tab2TabByTan" maxlength="200"
			value="<%=hoSo.getHoChieu1Tab2() %>" />
	</td>
</tr>



<tr>
	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="ngayCapHoChieu1Tab2TabByTan" id="ngayCapHoChieu1Tab2TabByTan" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getNgayCapHoChieu1Tab2()) %>"/>
	</td>
</tr>
<tr>
	<td colspan="6">
		<label class="egov-label-bold">TenGTK1Tab2 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="tenGTK1Tab2TabByTan" id="tenGTK1Tab2TabByTan" maxlength="200"
			value="<%=hoSo.getTenGTK1Tab2() %>" />
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">SoGTK1Tab2 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="soGTK1Tab2TabByTan" id="soGTK1Tab2TabByTan" maxlength="200"
			value="<%=hoSo.getSoGTK1Tab2() %>" />
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">NoiCapGTK1Tab2 </label>
		<br>
		<input type="text" class="egov-inputfield" name="noiCapGTK1Tab2TabByTan" id="noiCapGTK1Tab2TabByTan" maxlength="200"
			value="<%=hoSo.getNoiCapGTK1Tab2() %>" />
	</td>
</tr>

<tr>
	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="ngayCapGTK1Tab2TabByTan" id="ngayCapGTK1Tab2TabByTan" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getNgayCapGTK1Tab2()) %>"/>
	</td>
</tr>
<tr>
	<td colspan="2"><label class="egov-label-bold">Quan hệ </label>
		 <br> 
		<select name="quanHe1TabByTan" id="quanHe1TabByTan" 
		 class="egov-select">
		<option value="-1">Chọn quan hệ</option>
		 <%
		 	for (QuanHeGiaDinh  item : QuanHeGiaDinhLocalServiceUtil.getQuanHeGiaDinhs(-1,-1)) {
		 %>
			<option value="<%=item.getId()%>"
				<%=ActionUtils.checkData(item.getId(), hoSo.getQuanHe1())%>>
				<%=item.getTen()%>
			</option>
		 <%
			 }
		 %>
		 </select>
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Ten2Tab2 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="ten2Tab2TabByTan" id="ten2Tab2TabByTan" maxlength="200"
			value="<%=hoSo.getTen2Tab2() %>" />
	</td>
</tr>

<tr>
	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="birth2Tab2TabByTan" id="birth2Tab2TabByTan" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getBirth2Tab2()) %>"/>
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Dân tộc </label>
		<label class="egov-label-red">*</label><br> 
		<select name="danToc2Tab2TabByTan" id="danToc2Tab2TabByTan" 
				onchange='setDanToc("","danToc2Tab2TabByTan");'
				 class="egov-select">
		<option>Chọn dân tộc</option>
		 <%
			 for (DanTocSoap  item : service.getDanhSachDanToc()) {
		 %>
			 <option value="<%=item.getId()%>"
			<%=ActionUtils.checkData(item.getId(), hoSo.getDanToc2Tab2())%>><%=item.getTen()%></option>
		 <%
			} 
		 %>
		</select>
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Quốc gia </label>
		<label class="egov-label-red">*</label> <br> 
		<select name="quocTich2Tab2TabByTan" id="quocTich2Tab2TabByTan" 
		onchange='checkDanToc("quocTich2Tab2TabByTan","");'
		 class="egov-select">
		<option>Chọn nước</option>
		 <%
		 for (QuocGiaSoap item : service.getDanhSachQuocGia()) {
		 %>
		 <option value="<%=item.getId()%>"
			<%=ActionUtils.checkData(item.getId(), hoSo.getQuocTich2Tab2())%>><%=item.getTen()%></option>
		 <%} %>
		 </select>
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Địa chỉ thường trú</label>
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Tỉnh/Thành phố</label>
		<label class="egov-label-red">*</label>
		<select name="tinh6TabByTan" id="tinh6TabByTan"
		style="width: 96%" class="egov-select"
		onchange='reDrawSelectBox("tinh6TabByTan","quan6TabByTan","xa6TabByTan")'>
		<%
			long tinh6 = ActionUtils.getValueLong(request, "tinh6TabByTan");
			if (tinh6 ==0 ) tinh6 = hoSo.getTinh6();
			if (tinh6 ==0 ) tinh6 = donViHanhChinhId;
			for (DonViHanhChinh item : danhSachTinhThanh) {
		%>
			<option value="<%=item.getId()%>"
			<%=ActionUtils.checkData(item.getId(),
			tinh6)%>><%=item.getTen()%></option>
		<%
			}
		%>
		</select>
	</td>

	<td colspan="2">
		<label class="egov-label-bold">Quận/Huyện</label>
		<label class="egov-label-red">*</label>
		<select name="quan6TabByTan" id="quan6TabByTan"
			style="width: 96%" class="egov-select"
			onchange='reDrawSelectBox("quan6TabByTan","xa6TabByTan")'>
			<option value="-1">Chọn quận huyện</option>
			<%
				donViHanhChinhSoaps = service.getDanhsachDVHC(tinh6);
				long quan6= ActionUtils.getValueLong(request,
						 "quan6TabByTan"); 
				if (quan6 == 0) quan6 = hoSo.getQuan6();
				for (DonViHanhChinhSoap item : donViHanhChinhSoaps) {
			%>
				<option value="<%=item.getId()%>"
				<%=ActionUtils.checkData(item.getId(),
					quan6)%>><%=item.getTen()%></option>
			<%
				}
			%>
		</select>
	</td>

	<td colspan="2">
		<label class="egov-label-bold">Phường/Xã/Thị trấn</label>
		<label class="egov-label-red">*</label>
		<select name="xa6TabByTan" id="xa6TabByTan"
			style="width: 97%" class="egov-select">
			<option>Chọn phường xã</option>
			<%
				long xa6 = ActionUtils.getValueLong(request, "xa6TabByTan");
				if(xa6==0) xa6 = hoSo.getXa6();
				List<DonViHanhChinhSoap> danhSachXaThuongTru6 = service.getDanhsachDVHC(quan6);
				if(quan6 !=0){
				for (DonViHanhChinhSoap item : danhSachXaThuongTru6) {
			%>
				<option value="<%=item.getId()%>"
					<%=ActionUtils.checkData(item.getId(),xa6)%>><%=item.getTen()%>
				</option>
			<%
				}}
			%>
		</select>
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Số nhà/Đường phố/Ấp/Thôn</label>
		<label class="egov-label-red">*</label><br> 
		<input type="text"
			class="egov-inputfield" name="diaChi6TabByTan"
			id="diaChi6TabByTan" maxlength="200"
			value="<%=hoSo.getDiaChi6()%>" />
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Radio2Tab2 </label>
		<br>
		<input type="text" class="egov-inputfield" name="radio2Tab2TabByTan" id="radio2Tab2TabByTan" maxlength="200"
			value="<%=hoSo.getRadio2Tab2() %>" />
	</td>
</tr>

<tr>
	<td colspan="2">
	<label class="egov-label-bold">Số </label>
	<label class="egov-label-red">*</label><br>
	<input type="text" class="egov-inputfield onlyNumeric" 
			name="cmnd2Tab2TabByTan" id="cmnd2Tab2TabByTan" maxlength="12"
					value="<%=hoSo.getCmnd2Tab2() %>" />
	</td>
</tr>

<tr>
	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="ngayCapCmnd2Tab2TabByTan" id="ngayCapCmnd2Tab2TabByTan" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getNgayCapCmnd2Tab2()) %>"/>
	</td>
</tr>
<tr>
	<td colspan="6"><label class="egov-label-bold">Cơ quan cấp </label>
	 <br> 
		<select class="egov-select" name="noiCapCmnd2Tab2TabByTan" id="noiCapCmnd2Tab2TabByTan">
			<option>
				Chọn nơi cấp
			</option>
			<%
				for (DonViHanhChinh item : DonViHanhChinhLocalServiceUtil.getDanhSachNoiCapCMND()) {
			%>
			<option value="<%=item.getId()%>"
				<%=ActionUtils.checkData(item.getId(), hoSo.getNoiCapCmnd2Tab2())%>>
				<%=item.getMa().length()>=4 ? "Cục cảnh sát ĐKQL cư trú và dữ liệu quốc gia về dân cư" : "Công an"%>&nbsp;
				<%=item.getTen()%>
			</option>
			<%}%>
		</select>
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">HoChieu2Tab2 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="hoChieu2Tab2TabByTan" id="hoChieu2Tab2TabByTan" maxlength="200"
			value="<%=hoSo.getHoChieu2Tab2() %>" />
	</td>
</tr>



<tr>
	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="ngayCapHoChieu2Tab2TabByTan" id="ngayCapHoChieu2Tab2TabByTan" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getNgayCapHoChieu2Tab2()) %>"/>
	</td>
</tr>
<tr>
	<td colspan="6">
		<label class="egov-label-bold">TenGTK2Tab2 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="tenGTK2Tab2TabByTan" id="tenGTK2Tab2TabByTan" maxlength="200"
			value="<%=hoSo.getTenGTK2Tab2() %>" />
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">SoGTK2Tab2 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="soGTK2Tab2TabByTan" id="soGTK2Tab2TabByTan" maxlength="200"
			value="<%=hoSo.getSoGTK2Tab2() %>" />
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">NoiCapGTK2Tab2 </label>
		<br>
		<input type="text" class="egov-inputfield" name="noiCapGTK2Tab2TabByTan" id="noiCapGTK2Tab2TabByTan" maxlength="200"
			value="<%=hoSo.getNoiCapGTK2Tab2() %>" />
	</td>
</tr>

<tr>
	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="ngayCapGTK2Tab2TabByTan" id="ngayCapGTK2Tab2TabByTan" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getNgayCapGTK2Tab2()) %>"/>
	</td>
</tr>
<tr>
	<td colspan="2"><label class="egov-label-bold">Quan hệ </label>
		<label class="egov-label-red">*</label> <br> 
		<select name="quanHe2Tab2TabByTan" id="quanHe2Tab2TabByTan" 
		 class="egov-select">
		<option value="-1">Chọn quan hệ</option>
		 <%
		 	for (QuanHeGiaDinh  item : QuanHeGiaDinhLocalServiceUtil.getQuanHeGiaDinhs(-1,-1)) {
		 %>
			<option value="<%=item.getId()%>"
				<%=ActionUtils.checkData(item.getId(), hoSo.getQuanHe2Tab2())%>>
				<%=item.getTen()%>
			</option>
		 <%
			 }
		 %>
		 </select>
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Ten3Tab2 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="ten3Tab2TabByTan" id="ten3Tab2TabByTan" maxlength="200"
			value="<%=hoSo.getTen3Tab2() %>" />
	</td>
</tr>

<tr>
	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="birth3Tab2TabByTan" id="birth3Tab2TabByTan" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getBirth3Tab2()) %>"/>
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Dân tộc </label>
		<label class="egov-label-red">*</label><br> 
		<select name="danToc3Tab2TabByTan" id="danToc3Tab2TabByTan" 
				onchange='setDanToc("","danToc3Tab2TabByTan");'
				 class="egov-select">
		<option>Chọn dân tộc</option>
		 <%
			 for (DanTocSoap  item : service.getDanhSachDanToc()) {
		 %>
			 <option value="<%=item.getId()%>"
			<%=ActionUtils.checkData(item.getId(), hoSo.getDanToc3Tab2())%>><%=item.getTen()%></option>
		 <%
			} 
		 %>
		</select>
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Quốc gia </label>
		<label class="egov-label-red">*</label> <br> 
		<select name="quocTich3Tab2TabByTan" id="quocTich3Tab2TabByTan" 
		onchange='checkDanToc("quocTich3Tab2TabByTan","");'
		 class="egov-select">
		<option>Chọn nước</option>
		 <%
		 for (QuocGiaSoap item : service.getDanhSachQuocGia()) {
		 %>
		 <option value="<%=item.getId()%>"
			<%=ActionUtils.checkData(item.getId(), hoSo.getQuocTich3Tab2())%>><%=item.getTen()%></option>
		 <%} %>
		 </select>
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Địa chỉ thường trú</label>
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Tỉnh/Thành phố</label>
		<label class="egov-label-red">*</label>
		<select name="tinh7TabByTan" id="tinh7TabByTan"
		style="width: 96%" class="egov-select"
		onchange='reDrawSelectBox("tinh7TabByTan","quan7TabByTan","xa7TabByTan")'>
		<%
			long tinh7 = ActionUtils.getValueLong(request, "tinh7TabByTan");
			if (tinh7 ==0 ) tinh7 = hoSo.getTinh7();
			if (tinh7 ==0 ) tinh7 = donViHanhChinhId;
			for (DonViHanhChinh item : danhSachTinhThanh) {
		%>
			<option value="<%=item.getId()%>"
			<%=ActionUtils.checkData(item.getId(),
			tinh7)%>><%=item.getTen()%></option>
		<%
			}
		%>
		</select>
	</td>

	<td colspan="2">
		<label class="egov-label-bold">Quận/Huyện</label>
		<label class="egov-label-red">*</label>
		<select name="quan7TabByTan" id="quan7TabByTan"
			style="width: 96%" class="egov-select"
			onchange='reDrawSelectBox("quan7TabByTan","xa7TabByTan")'>
			<option value="-1">Chọn quận huyện</option>
			<%
				donViHanhChinhSoaps = service.getDanhsachDVHC(tinh7);
				long quan7= ActionUtils.getValueLong(request,
						 "quan7TabByTan"); 
				if (quan7 == 0) quan7 = hoSo.getQuan7();
				for (DonViHanhChinhSoap item : donViHanhChinhSoaps) {
			%>
				<option value="<%=item.getId()%>"
				<%=ActionUtils.checkData(item.getId(),
					quan7)%>><%=item.getTen()%></option>
			<%
				}
			%>
		</select>
	</td>

	<td colspan="2">
		<label class="egov-label-bold">Phường/Xã/Thị trấn</label>
		<label class="egov-label-red">*</label>
		<select name="xa7TabByTan" id="xa7TabByTan"
			style="width: 97%" class="egov-select">
			<option>Chọn phường xã</option>
			<%
				long xa7 = ActionUtils.getValueLong(request, "xa7TabByTan");
				if(xa7==0) xa7 = hoSo.getXa7();
				List<DonViHanhChinhSoap> danhSachXaThuongTru7 = service.getDanhsachDVHC(quan7);
				if(quan7 !=0){
				for (DonViHanhChinhSoap item : danhSachXaThuongTru7) {
			%>
				<option value="<%=item.getId()%>"
					<%=ActionUtils.checkData(item.getId(),xa7)%>><%=item.getTen()%>
				</option>
			<%
				}}
			%>
		</select>
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Số nhà/Đường phố/Ấp/Thôn</label>
		<label class="egov-label-red">*</label><br> 
		<input type="text"
			class="egov-inputfield" name="diaChi7TabByTan"
			id="diaChi7TabByTan" maxlength="200"
			value="<%=hoSo.getDiaChi7()%>" />
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Radio3Tab2 </label>
		<br>
		<input type="text" class="egov-inputfield" name="radio3Tab2TabByTan" id="radio3Tab2TabByTan" maxlength="200"
			value="<%=hoSo.getRadio3Tab2() %>" />
	</td>
</tr>

<tr>
	<td colspan="2">
	<label class="egov-label-bold">Số </label>
	<label class="egov-label-red">*</label><br>
	<input type="text" class="egov-inputfield onlyNumeric" 
			name="cmnd3Tab2TabByTan" id="cmnd3Tab2TabByTan" maxlength="12"
					value="<%=hoSo.getCmnd3Tab2() %>" />
	</td>
</tr>

<tr>
	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="ngayCapCmnd3Tab2TabByTan" id="ngayCapCmnd3Tab2TabByTan" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getNgayCapCmnd3Tab2()) %>"/>
	</td>
</tr>
<tr>
	<td colspan="6"><label class="egov-label-bold">Cơ quan cấp </label>
	 <br> 
		<select class="egov-select" name="noiCapCmnd3Tab2TabByTan" id="noiCapCmnd3Tab2TabByTan">
			<option>
				Chọn nơi cấp
			</option>
			<%
				for (DonViHanhChinh item : DonViHanhChinhLocalServiceUtil.getDanhSachNoiCapCMND()) {
			%>
			<option value="<%=item.getId()%>"
				<%=ActionUtils.checkData(item.getId(), hoSo.getNoiCapCmnd3Tab2())%>>
				<%=item.getMa().length()>=4 ? "Cục cảnh sát ĐKQL cư trú và dữ liệu quốc gia về dân cư" : "Công an"%>&nbsp;
				<%=item.getTen()%>
			</option>
			<%}%>
		</select>
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">HoChieu3Tab2 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="hoChieu3Tab2TabByTan" id="hoChieu3Tab2TabByTan" maxlength="200"
			value="<%=hoSo.getHoChieu3Tab2() %>" />
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Tỉnh/Thành </label><br> 
		<select name="noiCapHoChieu3Tab2TabByTan" id="noiCapHoChieu3Tab2TabByTan" 
		 class="egov-select">
		<option>Chọn tỉnh/thành</option>
		 <%
		 for (DonViHanhChinh item : DonViHanhChinhLocalServiceUtil.getDanhSachTinhThanh()) {
		 %>
		 <option value="<%=item.getId()%>"
		<%=ActionUtils.checkData(item.getId(), hoSo.getNoiCapHoChieu3Tab2())%>><%=item.getTen()%></option>
		 <%} %>
		</select>
	</td>
</tr>

<tr>
	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="ngayCapHoChieu3Tab2TabByTan" id="ngayCapHoChieu3Tab2TabByTan" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getNgayCapHoChieu3Tab2()) %>"/>
	</td>
</tr>
<tr>
	<td colspan="6">
		<label class="egov-label-bold">YKien1 </label>
		<br>
		<input type="text" class="egov-inputfield" name="yKien1TabByTan" id="yKien1TabByTan" maxlength="200"
			value="<%=hoSo.getYKien1() %>" />
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">YKien2 </label>
		<br>
		<input type="text" class="egov-inputfield" name="yKien2TabByTan" id="yKien2TabByTan" maxlength="200"
			value="<%=hoSo.getYKien2() %>" />
	</td>
</tr>

