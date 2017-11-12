<%@page import="vn.dtt.sharedservice.cmon.consumer.citizen.DonViHanhChinhSoap"%>
<%@page import="vn.dtt.csms.khaisinhkethopchameconnn.model.impl.KhaiSinhKetHopChaMeConNNImpl"%>
<%@page import="vn.dtt.csms.khaisinhkethopchameconnn.model.KhaiSinhKetHopChaMeConNNClp"%>
<%@page import="vn.dtt.portlet.csms.CSMConstrants"%>
<%@page import="vn.dtt.portlet.utils.ActionUtils"%>
<%@page import="vn.dtt.csms.khaisinhkethopchameconnn.service.KhaiSinhKetHopChaMeConNNLocalServiceUtil"%>
<%@page import="vn.dtt.csms.khaisinhkethopchameconnn.model.KhaiSinhKetHopChaMeConNN"%>

<%@page import="vn.dtt.cmon.dao.qlhc.model.CoQuanQuanLy"%>
<%@page import="java.util.List"%>
<%@page import="vn.dtt.cmon.dao.thamso.service.ThamSoLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>

<%@page import="com.liferay.portal.kernel.log.LogFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.log.Log"%>
<%@page import="vn.dtt.cmon.dao.cd.model.CongDan"%>
<%@page import="vn.dtt.cmon.dao.dn.model.DoanhNghiep"%>

<%@page import="vn.dtt.cmon.dao.cd.model.CongDanClp"%>
<%@page import="vn.dtt.cmon.dao.cd.service.CongDanLocalServiceUtil"%>
<%@page import="vn.dtt.cmon.dao.dn.service.DoanhNghiepLocalServiceUtil"%>
<%@page import="vn.dtt.portlet.utils.CommonValidatorAndDebug"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@page import="javax.portlet.PortletPreferences"%>
<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>
<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui"%>
<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet"%>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui"%>
<%@ taglib uri="http://liferay.com/tld/util" prefix="liferay-util"%>
    
<%@ include file="/html/portlet/csms/csmsinit.jsp" %>


<portlet:actionURL var="saveKhaiSinhKetHopChaMeConNN" name="saveKhaiSinhKetHopChaMeConNN">
	<portlet:param name="<%=CSMConstrants.ACTION%>"
		value="khaisinhkethopchameconnn.save" />
		<portlet:param name="jspPage"
	value="/html/portlet/csms/khaisinhkethopchameconnn/registry_khaisinhkethopchameconnn_step.jsp" />
</portlet:actionURL>

<html>
	<head>
	   <script src="<%=request.getContextPath()%>/js/togglesubmit.js"
			type="text/javascript"></script>
		<script src="<%=request.getContextPath()%>/js/cmonHeader.js"
			type="text/javascript"></script>
			<script src="<%=request.getContextPath()%>/js/formatNumber.js"
	  type="text/javascript"></script>
	  	<link type="text/css" rel="stylesheet" 
	  	href="<%=request.getContextPath()%>/css/customEgovTheme.css" charset="utf-8">	
	</head>
<%  
	Log log = LogFactoryUtil.getLog(this.getClass());
	ICitizenService service = WebserviceFactory.getCmonService();
	long thuTucHanhChinhId = CommonValidatorAndDebug.getThuTucId(request);
	long hoSoId = CommonValidatorAndDebug.getHoSoId(request);
	Long userId = PortalUtil.getUserId(request);
	String doiTuong = CommonValidatorAndDebug.getLoaiDoiTuongFromRequest(request);
	List<CoQuanQuanLy> danhSachCoQuanNhanHoSo = 
			CommonValidatorAndDebug.getDanhSachCoQuanQuanLyByThuTuc(thuTucHanhChinhId);
	
	List<DonViHanhChinh> danhSachTinhThanh = DonViHanhChinhLocalServiceUtil.getDanhSachTinhThanh();
	List<CoQuanQuanLySoap> coQuanQuanLySoaps = service.getDSCoQuanQuanLyTheoTTHC(new Long(thuTucHanhChinhId));
	Long donViHanhChinhId =  Long.parseLong(ConfigUtils.getValue("egov.application.bacninh.id", "31"));
	List<DonViHanhChinhSoap> donViHanhChinhSoaps =  service.getDanhsachDVHC(donViHanhChinhId);

	KhaiSinhKetHopChaMeConNN hoSo= null;

	if(request.getAttribute("obj") != null){  
		 hoSo = (KhaiSinhKetHopChaMeConNN)request.getAttribute("obj"); 
 	}

 	DoanhNghiep doanhNghiep = null;
	CongDan congDan = null;
	String loaiDoiTuong = "";

	if(hoSo == null){
		if(hoSoId > 0) {
			hoSo = KhaiSinhKetHopChaMeConNNLocalServiceUtil.fetchKhaiSinhKetHopChaMeConNN(hoSoId);
		}
	}


	if(hoSo == null){
		hoSo = new KhaiSinhKetHopChaMeConNNImpl();
		if(DoanhNghiepLocalServiceUtil.getDoanhNghiepByTaiKhoanNguoiDungId(userId) != null){
			doanhNghiep = DoanhNghiepLocalServiceUtil.getDoanhNghiepByTaiKhoanNguoiDungId(userId);
			loaiDoiTuong = "doanh nghiep";
			if (doanhNghiep.getNguoiDaiDienId() !=null){
			congDan = CongDanLocalServiceUtil.fetchCongDan(doanhNghiep.getNguoiDaiDienId());
			}else{
				congDan = new CongDanClp();
			}
			if(congDan.getTenDayDu() != null){
			}
			if(doanhNghiep.getTenChiNhanh() != null){
			}
			if(doanhNghiep.getDiaChiDoanhNghiepTinhId() != null){
				hoSo.setTinh1(doanhNghiep.getDiaChiDoanhNghiepTinhId());
			}
			if(doanhNghiep.getDiaChiDoanhNghiepHuyenId() != null){
				hoSo.setQuan1(doanhNghiep.getDiaChiDoanhNghiepHuyenId());
			}
			if(doanhNghiep.getDiaChiDoanhNghiepXaId() != null){
				hoSo.setXa1(doanhNghiep.getDiaChiDoanhNghiepXaId());
			}
			if(doanhNghiep.getDiaChiDoanhNghiep() != null){
				hoSo.setDiaChi1(doanhNghiep.getDiaChiDoanhNghiep());
			}
		}else if(CongDanLocalServiceUtil.getCongDanByLiferayUserId(userId) != null){
			congDan = CongDanLocalServiceUtil.getCongDanByLiferayUserId(userId);
			loaiDoiTuong = "cong dan";
			if(congDan.getTenDayDu() != null){
				hoSo.setTen(congDan.getTenDayDu());
			}
			if(congDan.getDiaChiThuongTruTinhId() != null){
				hoSo.setTinh1(congDan.getDiaChiThuongTruTinhId());
			}
			if(congDan.getDiaChiThuongTruHuyenId() != null){
				hoSo.setQuan1(congDan.getDiaChiThuongTruHuyenId());
			}
			if(congDan.getDiaChiThuongTruXaId() != null){
				hoSo.setXa1(congDan.getDiaChiThuongTruXaId());
			}
			if(congDan.getDiaChiThuongTru() != null){
				hoSo.setDiaChi1(congDan.getDiaChiThuongTru());
			}
			if(congDan.getSoCmnd() != null){
				hoSo.setCmnd(congDan.getSoCmnd()); 
			}
			if(congDan.getNgaySinh() != null){
			}
			if(congDan.getNgayCapCmnd() != null){
			}
			if(congDan.getNoiCapCmndId()!=null){
			}
		}
	}

	String []danhSachRequired = {"ten1Tab1","quocGia1Tab1","quan1","xa1","diaChi1","cmnd1Tab1","ngayCapCmnd1Tab1","noiCapCmnd1Tab1","hoChieu1Tab1","ngayCapHoChieu1Tab1","noiCapHoChieu1Tab1","tenGTK1Tab1","soGTK1Tab1","noiCapGTK1Tab1","ngayCapGTK1Tab1","quanHe1Tab1","ten2Tab1","sex2Tab1","birth2Tab1","birth2BangChuTab1","danToc2Tab1","quocTich2Tab1","quocGia2Tab1","quan2","xa2","diaChi2","quocTich3Tab1","quocGia3Tab1","quan3","xa3","diaChi3","danToc4Tab1","quan4","xa4","diaChi4","ten1Tab2","birth1Tab2","danToc1Tab2","quocTich1Tab2","quan5","xa5","diaChi5","cmnd1Tab2","hoChieu1Tab2","tenGTK1Tab2","soGTK1Tab2","ten2Tab2","birth2Tab2","danToc2Tab2","quocTich2Tab2","quan6","xa6","diaChi6","cmnd2Tab2","hoChieu2Tab2","tenGTK2Tab2","soGTK2Tab2","quanHe2Tab2","ten3Tab2","birth3Tab2","danToc3Tab2","quocTich3Tab2","quan7","xa7","diaChi7",
		"cmnd3Tab2","hoChieu3Tab2","tenGTK3Tab2","soGTK3Tab2"};

String []danhSachDate = {"ngayCapCmnd1Tab1","ngayCapHoChieu1Tab1","ngayCapGTK1Tab1","birth2Tab1","birth3Tab1","birth4Tab1","birth1Tab2","ngayCapCmnd1Tab2","ngayCapHoChieu1Tab2","ngayCapGTK1Tab2","birth2Tab2","ngayCapCmnd2Tab2","ngayCapHoChieu2Tab2","ngayCapGTK2Tab2","birth3Tab2","ngayCapCmnd3Tab2","ngayCapHoChieu3Tab2","ngayCapGTK3Tab2"};

String []danhsachCMND = {"cmnd1Tab1","cmnd1Tab2","cmnd2Tab2","cmnd3Tab2"};

String []danhsachPhone = {""};

String []danhsachEmail = {""};
%>


<body class="nav-md">
	<div class = 'egov-container'>
		<jsp:include page="/html/portlet/cmonHeaderNoJSNoHeader.jsp"/>
		<form action = "<%=saveKhaiSinhKetHopChaMeConNN%>" id = "myForm" method = "post"> 
			<table  class = "egov-table-form">
				<tr>
					<td colspan="6">
						<p class="egov-p-20-no-margin" ><%="TITLE1".toUpperCase()%></p>
						<div style="margin-top:12px;">
						 	<p class="egov-p-20-no-margin"><%="TITLE2".toUpperCase()%></p>
						</div>
						<br>
					</td>
				</tr>
				
				<!-- ERROR -->
				<tr style="display: none;">
					<td colspan="6">
						<select style="display: none;" id="egov-form-errors">
						<%
							for (String elementId : danhSachRequired){
						 %>
							<option value="<%=elementId%>">
								 <liferay-ui:error key="<%=elementId%>">
					 				<%=ActionUtils.getMessageValidate()%>
								 </liferay-ui:error>
							 </option>
					 	<%
					 		}
					 	%>

						<%
							for (String elementId : danhSachDate){
								String key1 = elementId +"lonHonHienTai";
								String key1b = elementId +"nhoHonHienTai";
						 %>
							<option value="<%=elementId%>">
								<liferay-ui:error key="<%=key1%>"
									 message="Phải trước hoặc bằng ngày hiện tại.">
					 			</liferay-ui:error>
							</option>

							<option value="<%=elementId%>">
								<liferay-ui:error key="<%=key1b%>"
									 message="Phải sau hoặc bằng ngày hiện tại.">
					 			</liferay-ui:error>
							</option>
						<%
							}
						%>

						<%
							for (String elementId : danhsachCMND){
								String key2 = elementId +"NhapSai";
						%>
							<option value="<%=elementId%>">
								<liferay-ui:error key="<%=key2%>"
									message="Số chứng minh chỉ có 9 hoặc 12 chữ số." />
							</option>
						<%
							}
						%>

						<%
							for (String elementId : danhsachEmail){
								String key3 = elementId +"NhapSai";
						%>
							<option value="<%=elementId%>">
								<liferay-ui:error key="<%=key3%>"
									message="Email không hợp lệ."/>
							</option>
						<%
							}
						%>


						<%
							for (String elementId : danhsachPhone){
								String key4 = elementId +"NhapSai";
								String key5 = elementId +"NhapSai2";
						%>
							<option value="<%=elementId%>">
								<liferay-ui:error key="<%=key4%>"
									message="Phải ít nhất 10 chữ số."/>
							</option>

							<option value="<%=elementId%>">
								<liferay-ui:error key="<%=key5%>"
									message="Không hợp lệ."/>
							</option>
						<%
							}
						%>

						</select>
					</td>
				</tr>
				
				<tr>
					<td colspan ="6">
						<input  type ='hidden' 
							name = 'ID_QUY_TRINH'
							 id = 'ID_QUY_TRINH'
							value = '<%=thuTucHanhChinhId %>'
						/>
						<input  type ='hidden' 
							name = 'idQuyTrinh'
							 id = 'idQuyTrinh'
							value = '<%=thuTucHanhChinhId %>'
						/>
						<input  type ='hidden' 
							name = 'loaiDoiTuong'
							id = 'loaiDoiTuong'
							value = '<%=loaiDoiTuong %>'
						/>
						<input  type ='hidden' 
							name = 'ID_DANH_SACH_HO_SO'
							id = 'ID_DANH_SACH_HO_SO'
							value = '<%=hoSoId%>'
						/>
						<input  type ='hidden' 
							name = 'id' 
							id = 'id'
							value = '<%=hoSoId%>'
						/>
					</td>
				</tr>
		        
				<tr>
					<td colspan="6">
						<label class="egov-label-header"><br>
							CƠ QUAN GIẢI QUYẾT HỒ SƠ
						</label>
						<label class="egov-label-red">*</label>
						<label style = "color :red; margin: 0px; padding: 0px; float: right;" >
										<liferay-ui:message
										key="vn.dtt.hms.luuybatbuocnhap" />
						</label>
						<br>
						 <select name="coQuanQuanLyId" id="coQuanQuanLyId" 
						class="egov-select" >
							
							<%
								for (CoQuanQuanLySoap cq : coQuanQuanLySoaps) {
							%>
							<option value="<%=cq.getId()%>"
								<%=ActionUtils.checkData(cq.getId(),
										hoSo.getCoQuanQuanLyId())%>><%=cq.getTen()%></option>
							<%
								}
							%>
						</select>
					</td>
				</tr>
			
				<tr>
					<td colspan="6">
						<label class="egov-label-header"><br>THÔNG TIN NGƯỜI YÊU CẦU</label>
					</td>
				</tr>

				<!-- ------------------- Form ------------------------------- -->
										<tr>
	<td colspan="6">
		<label class="egov-label-bold">Ten1Tab1 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="ten1Tab1" id="ten1Tab1" maxlength="200"
			value="<%=hoSo.getTen1Tab1() %>" />
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Quốc gia </label>
		<label class="egov-label-red">*</label> <br> 
		<select name="quocGia1Tab1" id="quocGia1Tab1" 
		onchange='checkDanToc("quocGia1Tab1","");'
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
		<select name="tinh1" id="tinh1"
		style="width: 96%" class="egov-select"
		onchange='reDrawSelectBox("tinh1","quan1","xa1")'>
		<%
			long tinh1 = ActionUtils.getValueLong(request, "tinh1");
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
		<select name="quan1" id="quan1"
			style="width: 96%" class="egov-select"
			onchange='reDrawSelectBox("quan1","xa1")'>
			<option value="-1">Chọn quận huyện</option>
			<%
				donViHanhChinhSoaps = service.getDanhsachDVHC(tinh1);
				long quan1= ActionUtils.getValueLong(request,
						 "quan1"); 
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
		<select name="xa1" id="xa1"
			style="width: 97%" class="egov-select">
			<option>Chọn phường xã</option>
			<%
				long xa1 = ActionUtils.getValueLong(request, "xa1");
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
			class="egov-inputfield" name="diaChi1"
			id="diaChi1" maxlength="200"
			value="<%=hoSo.getDiaChi1()%>" />
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Radio1Tab1 </label>
		<br>
		<input type="text" class="egov-inputfield" name="radio1Tab1" id="radio1Tab1" maxlength="200"
			value="<%=hoSo.getRadio1Tab1() %>" />
	</td>
</tr>

<tr>
	<td colspan="2">
	<label class="egov-label-bold">Số </label>
	<label class="egov-label-red">*</label><br>
	<input type="text" class="egov-inputfield onlyNumeric" 
			name="cmnd1Tab1" id="cmnd1Tab1" maxlength="12"
					value="<%=hoSo.getCmnd1Tab1() %>" />
	</td>
</tr>

<tr>
	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="ngayCapCmnd1Tab1" id="ngayCapCmnd1Tab1" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getNgayCapCmnd1Tab1()) %>"/>
	</td>
</tr>

<tr>
	<td colspan="6"><label class="egov-label-bold">Cơ quan cấp </label>
	<label class="egov-label-red">*</label> <br> 
		<select class="egov-select" name="noiCapCmnd1Tab1" id="noiCapCmnd1Tab1">
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
		<input type="text" class="egov-inputfield" name="hoChieu1Tab1" id="hoChieu1Tab1" maxlength="200"
			value="<%=hoSo.getHoChieu1Tab1() %>" />
	</td>
</tr>

<tr>
	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="ngayCapHoChieu1Tab1" id="ngayCapHoChieu1Tab1" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getNgayCapHoChieu1Tab1()) %>"/>
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">NoiCapHoChieu1Tab1 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="noiCapHoChieu1Tab1" id="noiCapHoChieu1Tab1" maxlength="200"
			value="<%=hoSo.getNoiCapHoChieu1Tab1() %>" />
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">TenGTK1Tab1 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="tenGTK1Tab1" id="tenGTK1Tab1" maxlength="200"
			value="<%=hoSo.getTenGTK1Tab1() %>" />
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">SoGTK1Tab1 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="soGTK1Tab1" id="soGTK1Tab1" maxlength="200"
			value="<%=hoSo.getSoGTK1Tab1() %>" />
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">NoiCapGTK1Tab1 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="noiCapGTK1Tab1" id="noiCapGTK1Tab1" maxlength="200"
			value="<%=hoSo.getNoiCapGTK1Tab1() %>" />
	</td>
</tr>

<tr>
	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="ngayCapGTK1Tab1" id="ngayCapGTK1Tab1" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getNgayCapGTK1Tab1()) %>"/>
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Quan hệ </label>
		<label class="egov-label-red">*</label> <br> 
		<select name="quanHe1Tab1" id="quanHe1Tab1" 
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
		<input type="text" class="egov-inputfield" name="ten2Tab1" id="ten2Tab1" maxlength="200"
			value="<%=hoSo.getTen2Tab1() %>" />
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Giới tính </label>
		<label class="egov-label-red">*</label><br> 
		<select name="sex2Tab1" id="sex2Tab1" 
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
		name="birth2Tab1" id="birth2Tab1" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getBirth2Tab1()) %>"/>
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Birth2BangChuTab1 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="birth2BangChuTab1" id="birth2BangChuTab1" maxlength="200"
			value="<%=hoSo.getBirth2BangChuTab1() %>" />
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Dân tộc </label>
		<label class="egov-label-red">*</label><br> 
		<select name="danToc2Tab1" id="danToc2Tab1" 
				onchange='setDanToc("","danToc2Tab1");'
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
		<select name="quocTich2Tab1" id="quocTich2Tab1" 
				onchange='setDanToc("","quocTich2Tab1");'
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
		<select name="quocGia2Tab1" id="quocGia2Tab1" 
		onchange='checkDanToc("quocGia2Tab1","");'
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
		<select name="tinh2" id="tinh2"
		style="width: 96%" class="egov-select"
		onchange='reDrawSelectBox("tinh2","quan2","xa2")'>
		<%
			long tinh2 = ActionUtils.getValueLong(request, "tinh2");
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
		<select name="quan2" id="quan2"
			style="width: 96%" class="egov-select"
			onchange='reDrawSelectBox("quan2","xa2")'>
			<option value="-1">Chọn quận huyện</option>
			<%
				donViHanhChinhSoaps = service.getDanhsachDVHC(tinh2);
				long quan2= ActionUtils.getValueLong(request,
						 "quan2"); 
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
		<select name="xa2" id="xa2"
			style="width: 97%" class="egov-select">
			<option>Chọn phường xã</option>
			<%
				long xa2 = ActionUtils.getValueLong(request, "xa2");
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
			class="egov-inputfield" name="diaChi2"
			id="diaChi2" maxlength="200"
			value="<%=hoSo.getDiaChi2()%>" />
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Ten3Tab1 </label>
		<br>
		<input type="text" class="egov-inputfield" name="ten3Tab1" id="ten3Tab1" maxlength="200"
			value="<%=hoSo.getTen3Tab1() %>" />
	</td>
</tr>

<tr>
	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="birth3Tab1" id="birth3Tab1" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getBirth3Tab1()) %>"/>
	</td>
</tr><tr>
	<td colspan="2"><label class="egov-label-bold">Dân tộc </label>
		<br> 
		<select name="danToc3Tab1" id="danToc3Tab1" 
				onchange='setDanToc("","danToc3Tab1");'
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
		<select name="quocTich3Tab1" id="quocTich3Tab1" 
		onchange='checkDanToc("quocTich3Tab1","");'
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
		<select name="quocGia3Tab1" id="quocGia3Tab1" 
		onchange='checkDanToc("quocGia3Tab1","");'
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
		<select name="tinh3" id="tinh3"
		style="width: 96%" class="egov-select"
		onchange='reDrawSelectBox("tinh3","quan3","xa3")'>
		<%
			long tinh3 = ActionUtils.getValueLong(request, "tinh3");
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
		<select name="quan3" id="quan3"
			style="width: 96%" class="egov-select"
			onchange='reDrawSelectBox("quan3","xa3")'>
			<option value="-1">Chọn quận huyện</option>
			<%
				donViHanhChinhSoaps = service.getDanhsachDVHC(tinh3);
				long quan3= ActionUtils.getValueLong(request,
						 "quan3"); 
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
		<select name="xa3" id="xa3"
			style="width: 97%" class="egov-select">
			<option>Chọn phường xã</option>
			<%
				long xa3 = ActionUtils.getValueLong(request, "xa3");
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
			class="egov-inputfield" name="diaChi3"
			id="diaChi3" maxlength="200"
			value="<%=hoSo.getDiaChi3()%>" />
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Ten4Tab1 </label>
		<br>
		<input type="text" class="egov-inputfield" name="ten4Tab1" id="ten4Tab1" maxlength="200"
			value="<%=hoSo.getTen4Tab1() %>" />
	</td>
</tr>

<tr>
	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="birth4Tab1" id="birth4Tab1" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getBirth4Tab1()) %>"/>
	</td>
</tr><tr>
	<td colspan="2"><label class="egov-label-bold">Dân tộc </label>
		<label class="egov-label-red">*</label><br> 
		<select name="danToc4Tab1" id="danToc4Tab1" 
				onchange='setDanToc("","danToc4Tab1");'
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
		<select name="tinh4" id="tinh4"
		style="width: 96%" class="egov-select"
		onchange='reDrawSelectBox("tinh4","quan4","xa4")'>
		<%
			long tinh4 = ActionUtils.getValueLong(request, "tinh4");
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
		<select name="quan4" id="quan4"
			style="width: 96%" class="egov-select"
			onchange='reDrawSelectBox("quan4","xa4")'>
			<option value="-1">Chọn quận huyện</option>
			<%
				donViHanhChinhSoaps = service.getDanhsachDVHC(tinh4);
				long quan4= ActionUtils.getValueLong(request,
						 "quan4"); 
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
		<select name="xa4" id="xa4"
			style="width: 97%" class="egov-select">
			<option>Chọn phường xã</option>
			<%
				long xa4 = ActionUtils.getValueLong(request, "xa4");
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
			class="egov-inputfield" name="diaChi4"
			id="diaChi4" maxlength="200"
			value="<%=hoSo.getDiaChi4()%>" />
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Ten1Tab2 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="ten1Tab2" id="ten1Tab2" maxlength="200"
			value="<%=hoSo.getTen1Tab2() %>" />
	</td>
</tr>

<tr>
	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="birth1Tab2" id="birth1Tab2" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getBirth1Tab2()) %>"/>
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Dân tộc </label>
		<label class="egov-label-red">*</label><br> 
		<select name="danToc1Tab2" id="danToc1Tab2" 
				onchange='setDanToc("","danToc1Tab2");'
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
		<select name="quocTich1Tab2" id="quocTich1Tab2" 
		onchange='checkDanToc("quocTich1Tab2","");'
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
		<select name="tinh5" id="tinh5"
		style="width: 96%" class="egov-select"
		onchange='reDrawSelectBox("tinh5","quan5","xa5")'>
		<%
			long tinh5 = ActionUtils.getValueLong(request, "tinh5");
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
		<select name="quan5" id="quan5"
			style="width: 96%" class="egov-select"
			onchange='reDrawSelectBox("quan5","xa5")'>
			<option value="-1">Chọn quận huyện</option>
			<%
				donViHanhChinhSoaps = service.getDanhsachDVHC(tinh5);
				long quan5= ActionUtils.getValueLong(request,
						 "quan5"); 
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
		<select name="xa5" id="xa5"
			style="width: 97%" class="egov-select">
			<option>Chọn phường xã</option>
			<%
				long xa5 = ActionUtils.getValueLong(request, "xa5");
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
			class="egov-inputfield" name="diaChi5"
			id="diaChi5" maxlength="200"
			value="<%=hoSo.getDiaChi5()%>" />
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Radio1Tab2 </label>
		<br>
		<input type="text" class="egov-inputfield" name="radio1Tab2" id="radio1Tab2" maxlength="200"
			value="<%=hoSo.getRadio1Tab2() %>" />
	</td>
</tr>

<tr>
	<td colspan="2">
	<label class="egov-label-bold">Số </label>
	<label class="egov-label-red">*</label><br>
	<input type="text" class="egov-inputfield onlyNumeric" 
			name="cmnd1Tab2" id="cmnd1Tab2" maxlength="12"
					value="<%=hoSo.getCmnd1Tab2() %>" />
	</td>

	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="ngayCapCmnd1Tab2" id="ngayCapCmnd1Tab2" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getNgayCapCmnd1Tab2()) %>"/>
	</td>

	<td colspan="2"><label class="egov-label-bold">Cơ quan cấp </label>
	 <br> 
		<select class="egov-select" name="noiCapCmnd1Tab2" id="noiCapCmnd1Tab2">
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
	<td colspan="2">
		<label class="egov-label-bold">HoChieu1Tab2 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="hoChieu1Tab2" id="hoChieu1Tab2" maxlength="200"
			value="<%=hoSo.getHoChieu1Tab2() %>" />
	</td>

	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="ngayCapHoChieu1Tab2" id="ngayCapHoChieu1Tab2" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getNgayCapHoChieu1Tab2()) %>"/>
	</td>

	<td colspan="2"><label class="egov-label-bold">Nơi cấp </label><br> 
		<select name="noiCapHoChieu1Tab2" id="noiCapHoChieu1Tab2" 
		 class="egov-select">
		<option>Chọn tỉnh/thành</option>
		 <%
		 for (DonViHanhChinh item : DonViHanhChinhLocalServiceUtil.getDanhSachTinhThanh()) {
		 %>
		 <option value="<%=item.getId()%>"
		<%=ActionUtils.checkData(item.getId(), hoSo.getNoiCapHoChieu1Tab2())%>><%=item.getTen()%></option>
		 <%} %>
		</select>
	</td>
</tr>

<tr>
	<td colspan="3">
		<label class="egov-label-bold">TenGTK1Tab2 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="tenGTK1Tab2" id="tenGTK1Tab2" maxlength="200"
			value="<%=hoSo.getTenGTK1Tab2() %>" />
	</td>

	<td colspan="3">
		<label class="egov-label-bold">SoGTK1Tab2 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="soGTK1Tab2" id="soGTK1Tab2" maxlength="200"
			value="<%=hoSo.getSoGTK1Tab2() %>" />
	</td>
</tr>

<tr>
	<td colspan="3">
		<label class="egov-label-bold">NoiCapGTK1Tab2 </label>
		<br>
		<input type="text" class="egov-inputfield" name="noiCapGTK1Tab2" id="noiCapGTK1Tab2" maxlength="200"
			value="<%=hoSo.getNoiCapGTK1Tab2() %>" />
	</td>

	<td colspan="3">
		<label class="egov-label-bold">Ngày cấp </label>
		<br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="ngayCapGTK1Tab2" id="ngayCapGTK1Tab2" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getNgayCapGTK1Tab2()) %>"/>
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Quan hệ </label>
		 <br> 
		<select name="quanHe1" id="quanHe1" 
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
		<input type="text" class="egov-inputfield" name="ten2Tab2" id="ten2Tab2" maxlength="200"
			value="<%=hoSo.getTen2Tab2() %>" />
	</td>
</tr>

<tr>
	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="birth2Tab2" id="birth2Tab2" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getBirth2Tab2()) %>"/>
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Dân tộc </label>
		<label class="egov-label-red">*</label><br> 
		<select name="danToc2Tab2" id="danToc2Tab2" 
				onchange='setDanToc("","danToc2Tab2");'
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
		<select name="quocTich2Tab2" id="quocTich2Tab2" 
		onchange='checkDanToc("quocTich2Tab2","");'
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
		<select name="tinh6" id="tinh6"
		style="width: 96%" class="egov-select"
		onchange='reDrawSelectBox("tinh6","quan6","xa6")'>
		<%
			long tinh6 = ActionUtils.getValueLong(request, "tinh6");
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
		<select name="quan6" id="quan6"
			style="width: 96%" class="egov-select"
			onchange='reDrawSelectBox("quan6","xa6")'>
			<option value="-1">Chọn quận huyện</option>
			<%
				donViHanhChinhSoaps = service.getDanhsachDVHC(tinh6);
				long quan6= ActionUtils.getValueLong(request,
						 "quan6"); 
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
		<select name="xa6" id="xa6"
			style="width: 97%" class="egov-select">
			<option>Chọn phường xã</option>
			<%
				long xa6 = ActionUtils.getValueLong(request, "xa6");
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
			class="egov-inputfield" name="diaChi6"
			id="diaChi6" maxlength="200"
			value="<%=hoSo.getDiaChi6()%>" />
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Radio2Tab2 </label>
		<br>
		<input type="text" class="egov-inputfield" name="radio2Tab2" id="radio2Tab2" maxlength="200"
			value="<%=hoSo.getRadio2Tab2() %>" />
	</td>
</tr>

<tr>
	<td colspan="2">
	<label class="egov-label-bold">Số </label>
	<label class="egov-label-red">*</label><br>
	<input type="text" class="egov-inputfield onlyNumeric" 
			name="cmnd2Tab2" id="cmnd2Tab2" maxlength="12"
					value="<%=hoSo.getCmnd2Tab2() %>" />
	</td>

	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="ngayCapCmnd2Tab2" id="ngayCapCmnd2Tab2" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getNgayCapCmnd2Tab2()) %>"/>
	</td>

	<td colspan="2"><label class="egov-label-bold">Cơ quan cấp </label>
	 <br> 
		<select class="egov-select" name="noiCapCmnd2Tab2" id="noiCapCmnd2Tab2">
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
	<td colspan="2">
		<label class="egov-label-bold">HoChieu2Tab2 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="hoChieu2Tab2" id="hoChieu2Tab2" maxlength="200"
			value="<%=hoSo.getHoChieu2Tab2() %>" />
	</td>

	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="ngayCapHoChieu2Tab2" id="ngayCapHoChieu2Tab2" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getNgayCapHoChieu2Tab2()) %>"/>
	</td>

	<td colspan="2"><label class="egov-label-bold">Nơi cấp </label><br> 
		<select name="noiCapHoChieu2Tab2" id="noiCapHoChieu2Tab2" 
		 class="egov-select">
		<option>Chọn nơi cấp</option>
		 <%
		 for (DonViHanhChinh item : DonViHanhChinhLocalServiceUtil.getDanhSachTinhThanh()) {
		 %>
		 <option value="<%=item.getId()%>"
		<%=ActionUtils.checkData(item.getId(), hoSo.getNoiCapHoChieu2Tab2())%>>Cục xuất nhập cảnh <%=item.getTen()%></option>
		 <%} %>
		</select>
	</td>
</tr>

<tr>
	<td colspan="3">
		<label class="egov-label-bold">TenGTK2Tab2 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="tenGTK2Tab2" id="tenGTK2Tab2" maxlength="200"
			value="<%=hoSo.getTenGTK2Tab2() %>" />
	</td>

	<td colspan="3">
		<label class="egov-label-bold">SoGTK2Tab2 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="soGTK2Tab2" id="soGTK2Tab2" maxlength="200"
			value="<%=hoSo.getSoGTK2Tab2() %>" />
	</td>
</tr>

<tr>
	<td colspan="3">
		<label class="egov-label-bold">NoiCapGTK2Tab2 </label>
		<br>
		<input type="text" class="egov-inputfield" name="noiCapGTK2Tab2" id="noiCapGTK2Tab2" maxlength="200"
			value="<%=hoSo.getNoiCapGTK2Tab2() %>" />
	</td>

	<td colspan="3">
		<label class="egov-label-bold">Ngày cấp </label>
		<br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="ngayCapGTK2Tab2" id="ngayCapGTK2Tab2" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getNgayCapGTK2Tab2()) %>"/>
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Quan hệ </label>
		<label class="egov-label-red">*</label> <br> 
		<select name="quanHe2Tab2" id="quanHe2Tab2" 
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
		<input type="text" class="egov-inputfield" name="ten3Tab2" id="ten3Tab2" maxlength="200"
			value="<%=hoSo.getTen3Tab2() %>" />
	</td>
</tr>

<tr>
	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="birth3Tab2" id="birth3Tab2" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getBirth3Tab2()) %>"/>
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Dân tộc </label>
		<label class="egov-label-red">*</label><br> 
		<select name="danToc3Tab2" id="danToc3Tab2" 
				onchange='setDanToc("","danToc3Tab2");'
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
		<select name="quocTich3Tab2" id="quocTich3Tab2" 
		onchange='checkDanToc("quocTich3Tab2","");'
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
		<select name="tinh7" id="tinh7"
		style="width: 96%" class="egov-select"
		onchange='reDrawSelectBox("tinh7","quan7","xa7")'>
		<%
			long tinh7 = ActionUtils.getValueLong(request, "tinh7");
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
		<select name="quan7" id="quan7"
			style="width: 96%" class="egov-select"
			onchange='reDrawSelectBox("quan7","xa7")'>
			<option value="-1">Chọn quận huyện</option>
			<%
				donViHanhChinhSoaps = service.getDanhsachDVHC(tinh7);
				long quan7= ActionUtils.getValueLong(request,
						 "quan7"); 
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
		<select name="xa7" id="xa7"
			style="width: 97%" class="egov-select">
			<option>Chọn phường xã</option>
			<%
				long xa7 = ActionUtils.getValueLong(request, "xa7");
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
			class="egov-inputfield" name="diaChi7"
			id="diaChi7" maxlength="200"
			value="<%=hoSo.getDiaChi7()%>" />
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">Radio3Tab2 </label>
		<br>
		<input type="text" class="egov-inputfield" name="radio3Tab2" id="radio3Tab2" maxlength="200"
			value="<%=hoSo.getRadio3Tab2() %>" />
	</td>
</tr>

<tr>
	<td colspan="2">
	<label class="egov-label-bold">Số </label>
	<label class="egov-label-red">*</label><br>
	<input type="text" class="egov-inputfield onlyNumeric" 
			name="cmnd3Tab2" id="cmnd3Tab2" maxlength="12"
					value="<%=hoSo.getCmnd3Tab2() %>" />
	</td>
</tr>

<tr>
	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="ngayCapCmnd3Tab2" id="ngayCapCmnd3Tab2" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getNgayCapCmnd3Tab2()) %>"/>
	</td>
</tr><tr>
	<td colspan="6"><label class="egov-label-bold">Cơ quan cấp </label>
	 <br> 
		<select class="egov-select" name="noiCapCmnd3Tab2" id="noiCapCmnd3Tab2">
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
		<input type="text" class="egov-inputfield" name="hoChieu3Tab2" id="hoChieu3Tab2" maxlength="200"
			value="<%=hoSo.getHoChieu3Tab2() %>" />
	</td>
</tr>

<tr>
	<td colspan="2"><label class="egov-label-bold">Nơi cấp </label><br> 
		<select name="noiCapHoChieu3Tab2" id="noiCapHoChieu3Tab2" 
		 class="egov-select">
		<option>Chọn nơi cấp</option>
		 <%
		 for (DonViHanhChinh item : DonViHanhChinhLocalServiceUtil.getDanhSachTinhThanh()) {
		 %>
		 <option value="<%=item.getId()%>"
		<%=ActionUtils.checkData(item.getId(), hoSo.getNoiCapHoChieu3Tab2())%>><%=item.getTen()%></option>
		 <%} %>
		</select>
	</td>

	<td colspan="2">
		<label class="egov-label-bold">Ngày cấp </label>
		<br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="ngayCapHoChieu3Tab2" id="ngayCapHoChieu3Tab2" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getNgayCapHoChieu3Tab2()) %>"/>
	</td>
</tr>

<tr>
	<td colspan="3">
		<label class="egov-label-bold">TenGTK3Tab2 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="tenGTK3Tab2" id="tenGTK3Tab2" maxlength="200"
			value="<%=hoSo.getTenGTK3Tab2() %>" />
	</td>

	<td colspan="3">
		<label class="egov-label-bold">SoGTK3Tab2 </label>
		<label class="egov-label-red">*</label><br>
		<input type="text" class="egov-inputfield" name="soGTK3Tab2" id="soGTK3Tab2" maxlength="200"
			value="<%=hoSo.getSoGTK3Tab2() %>" />
	</td>
</tr>

<tr>
	<td colspan="3">
		<label class="egov-label-bold">NoiCapGTK3Tab2 </label>
		<br>
		<input type="text" class="egov-inputfield" name="noiCapGTK3Tab2" id="noiCapGTK3Tab2" maxlength="200"
			value="<%=hoSo.getNoiCapGTK3Tab2() %>" />
	</td>

	<td colspan="3">
		<label class="egov-label-bold">Ngày cấp </label>
		<br>
		<input type="text" class="egov-calendar" readonly="readonly" 
		name="ngayCapGTK3Tab2" id="ngayCapGTK3Tab2" maxlength="10"
		value="<%= ActionUtils.parseDateToTring(hoSo.getNgayCapGTK3Tab2()) %>"/>
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">YKien1 </label>
		<br>
		<input type="text" class="egov-inputfield" name="yKien1" id="yKien1" maxlength="200"
			value="<%=hoSo.getYKien1() %>" />
	</td>
</tr>

<tr>
	<td colspan="6">
		<label class="egov-label-bold">YKien2 </label>
		<br>
		<input type="text" class="egov-inputfield" name="yKien2" id="yKien2" maxlength="200"
			value="<%=hoSo.getYKien2() %>" />
	</td>
</tr>


				<tr>
					<td colspan="6"><input type="checkbox" class="egov-checkbox"
					onclick="setCommit()" id="chk" name="chk" onchange="unchecked" />
						<label class="egov-label">Đồng ý</label><br><br>
						<div align="left" class="egov-terms">
						<label class="egov-label" style="text-align: justify;">
							Tôi cam đoan lời khai trên đây là đúng sự thật và chịu trách nhiệm trước pháp luật về cam đoan của mình.
						</label>
						</div>
					</td>
				</tr>

				<tr>
					<td colspan="6">
						<div align="left">
							<input name="" type="submit" id="sm" size="20"
							class="egov-button" disabled="disabled"
							value="Tiếp tục"
							onclick="saveSubmitInfoTan('tinh1','quan1','xa1',
													'tinh2','quan2','xa2',
													'tinh3','quan3','xa3');"/>
							<input type="hidden" id="tinh1Hidden"/>
							<input type="hidden" id="quan1Hidden"/>
							<input type="hidden" id="xa1Hidden"/>
							<input type="hidden" id="tinh2Hidden"/>
							<input type="hidden" id="quan2Hidden"/>
							<input type="hidden" id="xa2Hidden"/>
							<input type="hidden" id="tinh3Hidden"/>
							<input type="hidden" id="quan3Hidden"/>
							<input type="hidden" id="xa3Hidden"/>

							<input type="hidden" id="radioGiayToHidden"/>
						</div>
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>

<portlet:actionURL var="getDVHCId"
					name="getDonViHanhChinhById">
	<portlet:param name="jspPage"
		value="/html/portlet/csms/khaisinhkethopchameconnn/registry_khaisinhkethopchameconnn_step.jsp" />
</portlet:actionURL>

<script type="text/javascript">
	var url = '<%=getDVHCId.toString()%>';
	document.getElementById("sm").disabled = true;
	document.getElementById("chk").checked = false;
	$(document).ready(function() {
	
		//showGiayTo($('#radioGiayToHidden').val());
		//getTableWhenClickBackButton("loadHidden","tbl_thongTinSanPham",3);
		reloadQuanHuyenTan('tinh1','quan1','xa1','tinh2','quan2','xa2', 'tinh3','quan3','xa3');
	});

	function setCommit() {
		if (document.getElementById("sm").disabled) {
			document.getElementById("sm").disabled = false;
		} else {
			document.getElementById("sm").disabled = true;
		}
		chkValue = document.getElementById("chk").checked;
		submitButton = document.getElementById("sm");
		if (!chkValue) 
			submitButton.disabled = true;
		else 
			submitButton.disabled = false;
	}

	function saveSubmitInfoTan(a1,a2,a3,b1,b2,b3,c1,c2,c3){
		//saveTableWhenSubmit("loadHidden","tbl_thongTinSanPham");
		document.getElementById(a1 + "Hidden").value = getSelectedValueById(a1);
		document.getElementById(a2 + "Hidden").value = getSelectedValueById(a2);
		document.getElementById(a3 + "Hidden").value = getSelectedValueById(a3);
		document.getElementById(b1 + "Hidden").value = getSelectedValueById(b1);
		document.getElementById(b2 + "Hidden").value = getSelectedValueById(b2);
		document.getElementById(b3 + "Hidden").value = getSelectedValueById(b3);
		document.getElementById(c1 + "Hidden").value = getSelectedValueById(c1);
		document.getElementById(c2 + "Hidden").value = getSelectedValueById(c2);
		document.getElementById(c3 + "Hidden").value = getSelectedValueById(c3);
	 }
	 
	function reloadQuanHuyenTan(a1,a2,a3,b1,b2,b3,c1,c2,c3){
		var tinh1 = document.getElementById(a1 + "Hidden").value;
		if(tinh1 != null && tinh1 != "" ){
			reDrawSelectBoxWithId($('#' + a2 + 'Hidden').val(),tinh1,a2);
			reDrawSelectBoxWithId($('#' + a3 + 'Hidden').val(),$('#' + a2 + 'Hidden').val(),a3);
		}

		var tinh2 = document.getElementById(b1 + "Hidden").value;
		if(tinh2 != null && tinh2 != "" ){
			reDrawSelectBoxWithId($('#' + b2 + 'Hidden').val(),tinh2,b2);
			reDrawSelectBoxWithId($('#' + b3 + 'Hidden').val(),$('#' + b2 + 'Hidden').val(),b3);
		}

		var tinh3 = document.getElementById(c1 + "Hidden").value;
		if(tinh3 != null && tinh3 != "" ){
			reDrawSelectBoxWithId($('#' + c2 + 'Hidden').val(),tinh3,c2);
			reDrawSelectBoxWithId($('#' + c3 + 'Hidden').val(),$('#' + c2 + 'Hidden').val(),c3);
		}
	}

	function checkDanToc(idQuocTichCon,idDanTocCon ) {
	var quocTich = document.getElementById(idQuocTichCon).value; 
	if (quocTich == -1) {
		return;
	}
	var danTocSelectBox = document.getElementById(idDanTocCon);
	
	if (quocTich != quocTichVN && quocTich != 0) {
		danTocSelectBox.value = danTocNuocNgoai;
	} else if (quocTich == quocTichVN ){
		danTocSelectBox.value = danTocKinh;
	}else{
		danTocSelectBox.value = 0;
	}
}

	function setDanToc(idQuocTichCon,idDanTocCon ) {
		var quocTich = document.getElementById(idQuocTichCon).value;
		if (quocTich == -1) {
			return;
		}
		var danTocSelectBox = document.getElementById(idDanTocCon);
		
		if(quocTich != quocTichVN && quocTich > 0){
			danTocSelectBox.value = danTocNuocNgoai;
		}
	}

	function showGiayTo(nameSelected){
		if (nameSelected =='cmnd') {
			document.getElementById('byCmndArea').style.display = '';
			document.getElementById('byHoChieuArea').style.display = 'none';
			$('#radioGiayToHidden').val('cmnd');
		} else if (nameSelected =='hoChieu') {
			document.getElementById('byCmndArea').style.display = 'none';
			document.getElementById('byHoChieuArea').style.display = '';
			$('#radioGiayToHidden').val('hoChieu');
		}
	}
</script>