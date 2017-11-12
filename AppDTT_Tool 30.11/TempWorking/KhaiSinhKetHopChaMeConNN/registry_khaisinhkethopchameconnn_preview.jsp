<%@page import="vn.dtt.csms.khaisinhkethopchameconnn.model.impl.KhaiSinhKetHopChaMeConNNImpl"%>
<%@page import="vn.dtt.csms.khaisinhkethopchameconnn.service.KhaiSinhKetHopChaMeConNNLocalServiceUtil"%>
<%@page import="vn.dtt.csms.khaisinhkethopchameconnn.model.KhaiSinhKetHopChaMeConNN"%>
<%@page import="vn.dtt.portlet.csms.CSMConstrants"%>
<%@include file="/html/portlet/csms/csmsinit.jsp"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="vn.dtt.cmon.dao.cd.model.CongDanClp"%>
<%@page import="vn.dtt.cmon.dao.cd.service.CongDanLocalServiceUtil"%>
<%@page import="vn.dtt.cmon.dao.dn.service.DoanhNghiepLocalServiceUtil"%>
<%@page import="vn.dtt.cmon.dao.cd.model.CongDan"%>
<%@page import="vn.dtt.cmon.dao.dn.model.DoanhNghiep"%>
<%@page import="com.liferay.portal.kernel.log.LogFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.log.Log"%>

<head>
	<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/customEgovTheme.css"
	type="text/css" media="screen" />
	<script src="<%=request.getContextPath()%>/js/togglesubmit.js"
	type="text/javascript"></script>
	<script src="<%=request.getContextPath()%>/js/cmonHeader.js"
	type="text/javascript"></script>
	<script src="<%=request.getContextPath()%>/js/formatNumber.js"
	type="text/javascript"></script>
	<style>
		#tbl_thongtinThem,#tbl_thongtinThem tr,th,td,#tbl_thongtinThem .row td {
			border: solid 1px black !important;
		}
	</style>
</head>
<%
// tham so id tren url cua review.jsp
String idHoSo = ParamUtil.getString(request, "id");
long id = (new Long(idHoSo)).intValue();

ICitizenService service = WebserviceFactory.getCmonService();
Long userId = PortalUtil.getUserId(request);
HoSoTTHCCong hoSoTTHCCong = HoSoTTHCCongLocalServiceUtil.fetchHoSoTTHCCong(id);
KhaiSinhKetHopChaMeConNN hoSo = KhaiSinhKetHopChaMeConNNLocalServiceUtil.fetchKhaiSinhKetHopChaMeConNN(id);
%>

<body>
	<div class="egov-container" id="page_Container">
		 <table class="egov-table-form">
			<tr>
				<td colspan="6" align="center" style = "text-align: center;">
					<label class="egov-label"
						style="font-style: italic; text-align: center;margin-top: 5px;font-size: 14px !important;">
						(Ban hành kèm theo Thông tư liên tịch số 13/2014/TTLT-BLĐTBXH-BTC ngày 03/6/2014 của Bộ<br>Lao động - Thương binh và Xã hội, Bộ Tài chính)
					</label> 

					<br/><br>

					<label class="egov-label"
						style = "font-weight: bold;
						font-size : 16px;
						text-align: center;">
						CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM
					</label>

					<div style="margin-top:5px;">
						<p class="egov-p-13"
								align="center"
							style = "font-weight: bold;
							  font-size: 16px;">
							 Độc lập - Tự do - Hạnh phúc
							<br>
							<span style="font-size: 12px;">_____________________</span>
						</p>
					</div>
					
					<div align="right" style="margin: 7px 0;">
						<p class="egov-p-13" style="font-style: italic;text-align: right;font-size: 13px;">
							Bắc Ninh, <%=ActionUtils.getNgayThangNam(hoSoTTHCCong.getNgayNopHoSo()) %>
						</p>
					</div>
				</td>
			</tr>

	
			<tr>
				<td colspan="6" align="center" style="text-align: center;">
					<p style="font-weight: bold; font-size: 18px;"> 
						<%="title".toUpperCase()%>
					</p>

					<div style="margin-top: 12px;">
						<p style="font-weight: bold; font-size: 18px;">
							<%="title".toUpperCase()%>
						</p>
					</div><br>
				</td>
			</tr>

			<tr>
				<td colspan="6" style="text-align: center;">
					<span style="font-size: 12px;">__________________</span>
				</td>
			</tr>


			<tr>
				<td colspan="6" align="center" style = "text-align: center;">
				<label class="egov-label-bold">Kính gửi:</label>
				<label class="egov-label">
					 <%=ActionUtils.getKinhGui(hoSo.getCoQuanQuanLyId()) %>
				</label>
				</td>
			</tr>

			<tr>
				<td width="16.67%">&nbsp;</td>
				<td width="16.67%">&nbsp;</td>
				<td width="16.67%">&nbsp;</td>
				<td width="16.67%">&nbsp;</td>
				<td width="16.67%">&nbsp;</td>
				<td width="16.67%">&nbsp;</td>
			</tr>
					<!-- -------------------------- here ------------------------------  -->
									<!-- input * -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">Ten1Tab1:
		<%=hoSo.getTen1Tab1() %></label> 
	</td>
</tr>

<!-- nation * -->
<tr>
	<td colspan="2">
		<label class="egov-label">QuocGia1Tab1: 
			<%=ActionUtils.getQuocTich(hoSo.getQuocGia1Tab1())%>
		</label>
	</td>
</tr>



<!-- address * -->
<tr>
	<td colspan="6">
		<label class="egov-label">Địa chỉ : 
			<%=ActionUtils.getAddress(hoSo.getDiaChi1(),
									hoSo.getTinh1(),
									hoSo.getQuan1(),
									hoSo.getXa1())
									%> 
		</label>
	 </td>
</tr>

<!-- input -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">Radio1Tab1:
		<%=hoSo.getRadio1Tab1() %></label> 
	</td>
</tr>

<!-- cmnd * -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">Cmnd1Tab1:
		<%=hoSo.getCmnd1Tab1() %></label> 
	</td>
</tr>

<!-- Date * -->
<tr>
	<td colspan="6"><label class="egov-label" >Ngày cấp:
		<%= ActionUtils.parseDateToTring(hoSo.getNgayCapCmnd1Tab1()) %></label> 
	</td>
</tr>


<!-- cmnd * -->
<tr>
	<td colspan="6">
		<label class="egov-label">Nơi cấp: 
			<% if(hoSo.getNoiCapCmnd1Tab1() >0 &&DonViHanhChinhLocalServiceUtil.fetchDonViHanhChinh(hoSo.getNoiCapCmnd1Tab1())!=null){%>
			<%=DonViHanhChinhLocalServiceUtil.fetchDonViHanhChinh(hoSo.getNoiCapCmnd1Tab1()).getMa().length()>=4 ? "Cục cảnh sát ĐKQL cư trú và dữ liệu quốc gia về dân cư" : "Công an" %>
			<%=DonViHanhChinhLocalServiceUtil.fetchDonViHanhChinh(hoSo.getNoiCapCmnd1Tab1()).getTen()%>
			<%} %>
		</label>
	</td>
</tr>

<!-- input * -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">HoChieu1Tab1:
		<%=hoSo.getHoChieu1Tab1() %></label> 
	</td>
</tr>

<!-- Date * -->
<tr>
	<td colspan="6"><label class="egov-label" >Ngày cấp:
		<%= ActionUtils.parseDateToTring(hoSo.getNgayCapHoChieu1Tab1()) %></label> 
	</td>
</tr>


<!-- input * -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">NoiCapHoChieu1Tab1:
		<%=hoSo.getNoiCapHoChieu1Tab1() %></label> 
	</td>
</tr>

<!-- input * -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">TenGTK1Tab1:
		<%=hoSo.getTenGTK1Tab1() %></label> 
	</td>
</tr>

<!-- input * -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">SoGTK1Tab1:
		<%=hoSo.getSoGTK1Tab1() %></label> 
	</td>
</tr>

<!-- input * -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">NoiCapGTK1Tab1:
		<%=hoSo.getNoiCapGTK1Tab1() %></label> 
	</td>
</tr>

<!-- Date * -->
<tr>
	<td colspan="6"><label class="egov-label" >Ngày cấp:
		<%= ActionUtils.parseDateToTring(hoSo.getNgayCapGTK1Tab1()) %></label> 
	</td>
</tr>


<!-- quanHe * -->
<tr>
	<td colspan="2">
		<label class="egov-label">QuanHe1Tab1: 
			<%=ActionUtils.getQuanHeGiaDinh(hoSo.getQuanHe1Tab1())%>
		</label>
	</td>
</tr>



<!-- input * -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">Ten2Tab1:
		<%=hoSo.getTen2Tab1() %></label> 
	</td>
</tr>

<!-- sex * -->
<tr>
	<td colspan="2">
		<label class="egov-label">Sex2Tab1:
			<%=ActionUtils.getGioiTinh(hoSo.getSex2Tab1())%>
		</label>
	</td>
</tr>

<!-- Date * -->
<tr>
	<td colspan="6"><label class="egov-label" >Ngày cấp:
		<%= ActionUtils.parseDateToTring(hoSo.getBirth2Tab1()) %></label> 
	</td>
</tr>


<!-- input * -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">Birth2BangChuTab1:
		<%=hoSo.getBirth2BangChuTab1() %></label> 
	</td>
</tr>

<!-- danToc * -->
<tr>
	<td colspan="2">
		<label class="egov-label">DanToc2Tab1: 
			<%=ActionUtils.getDanToc(hoSo.getDanToc2Tab1())%>
		</label>
	</td>
</tr>


<!-- danToc * -->
<tr>
	<td colspan="2">
		<label class="egov-label">QuocTich2Tab1: 
			<%=ActionUtils.getDanToc(hoSo.getQuocTich2Tab1())%>
		</label>
	</td>
</tr>


<!-- nation * -->
<tr>
	<td colspan="2">
		<label class="egov-label">QuocGia2Tab1: 
			<%=ActionUtils.getQuocTich(hoSo.getQuocGia2Tab1())%>
		</label>
	</td>
</tr>



<!-- address * -->
<tr>
	<td colspan="6">
		<label class="egov-label">Địa chỉ : 
			<%=ActionUtils.getAddress(hoSo.getDiaChi2(),
									hoSo.getTinh2(),
									hoSo.getQuan2(),
									hoSo.getXa2())
									%> 
		</label>
	 </td>
</tr>

<!-- input -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">Ten3Tab1:
		<%=hoSo.getTen3Tab1() %></label> 
	</td>
</tr>

<!-- Date  -->
<tr>
	<td colspan="6"><label class="egov-label" >Ngày cấp:
		<%= ActionUtils.parseDateToTring(hoSo.getBirth3Tab1()) %></label> 
	</td>
</tr>


<!-- danToc -->
<tr>
	<td colspan="2">
		<label class="egov-label">DanToc3Tab1: 
			<%=ActionUtils.getDanToc(hoSo.getDanToc3Tab1())%>
		</label>
	</td>
</tr>


<!-- nation * -->
<tr>
	<td colspan="2">
		<label class="egov-label">QuocTich3Tab1: 
			<%=ActionUtils.getQuocTich(hoSo.getQuocTich3Tab1())%>
		</label>
	</td>
</tr>



<!-- nation * -->
<tr>
	<td colspan="2">
		<label class="egov-label">QuocGia3Tab1: 
			<%=ActionUtils.getQuocTich(hoSo.getQuocGia3Tab1())%>
		</label>
	</td>
</tr>



<!-- address * -->
<tr>
	<td colspan="6">
		<label class="egov-label">Địa chỉ : 
			<%=ActionUtils.getAddress(hoSo.getDiaChi3(),
									hoSo.getTinh3(),
									hoSo.getQuan3(),
									hoSo.getXa3())
									%> 
		</label>
	 </td>
</tr>

<!-- input -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">Ten4Tab1:
		<%=hoSo.getTen4Tab1() %></label> 
	</td>
</tr>

<!-- Date  -->
<tr>
	<td colspan="6"><label class="egov-label" >Ngày cấp:
		<%= ActionUtils.parseDateToTring(hoSo.getBirth4Tab1()) %></label> 
	</td>
</tr>


<!-- danToc * -->
<tr>
	<td colspan="2">
		<label class="egov-label">DanToc4Tab1: 
			<%=ActionUtils.getDanToc(hoSo.getDanToc4Tab1())%>
		</label>
	</td>
</tr>


<!-- nation -->
<tr>
	<td colspan="2">
		<label class="egov-label">QuocTich4Tab1: 
			<%=ActionUtils.getQuocTich(hoSo.getQuocTich4Tab1())%>
		</label>
	</td>
</tr>



<!-- nation -->
<tr>
	<td colspan="2">
		<label class="egov-label">QuocGia4Tab1: 
			<%=ActionUtils.getQuocTich(hoSo.getQuocGia4Tab1())%>
		</label>
	</td>
</tr>



<!-- address * -->
<tr>
	<td colspan="6">
		<label class="egov-label">Địa chỉ : 
			<%=ActionUtils.getAddress(hoSo.getDiaChi4(),
									hoSo.getTinh4(),
									hoSo.getQuan4(),
									hoSo.getXa4())
									%> 
		</label>
	 </td>
</tr>

<!-- input * -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">Ten1Tab2:
		<%=hoSo.getTen1Tab2() %></label> 
	</td>
</tr>

<!-- Date * -->
<tr>
	<td colspan="6"><label class="egov-label" >Ngày cấp:
		<%= ActionUtils.parseDateToTring(hoSo.getBirth1Tab2()) %></label> 
	</td>
</tr>


<!-- danToc * -->
<tr>
	<td colspan="2">
		<label class="egov-label">DanToc1Tab2: 
			<%=ActionUtils.getDanToc(hoSo.getDanToc1Tab2())%>
		</label>
	</td>
</tr>


<!-- nation * -->
<tr>
	<td colspan="2">
		<label class="egov-label">QuocTich1Tab2: 
			<%=ActionUtils.getQuocTich(hoSo.getQuocTich1Tab2())%>
		</label>
	</td>
</tr>



<!-- address * -->
<tr>
	<td colspan="6">
		<label class="egov-label">Địa chỉ : 
			<%=ActionUtils.getAddress(hoSo.getDiaChi5(),
									hoSo.getTinh5(),
									hoSo.getQuan5(),
									hoSo.getXa5())
									%> 
		</label>
	 </td>
</tr>

<!-- input -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">Radio1Tab2:
		<%=hoSo.getRadio1Tab2() %></label> 
	</td>
</tr>

<!-- cmnd * -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">Cmnd1Tab2:
		<%=hoSo.getCmnd1Tab2() %></label> 
	</td>
</tr>

<!-- Date  -->
<tr>
	<td colspan="6"><label class="egov-label" >Ngày cấp:
		<%= ActionUtils.parseDateToTring(hoSo.getNgayCapCmnd1Tab2()) %></label> 
	</td>
</tr>


<!-- cmnd -->
<tr>
	<td colspan="6">
		<label class="egov-label">Nơi cấp: 
			<% if(hoSo.getNoiCapCmnd1Tab2() >0 &&DonViHanhChinhLocalServiceUtil.fetchDonViHanhChinh(hoSo.getNoiCapCmnd1Tab2())!=null){%>
			<%=DonViHanhChinhLocalServiceUtil.fetchDonViHanhChinh(hoSo.getNoiCapCmnd1Tab2()).getMa().length()>=4 ? "Cục cảnh sát ĐKQL cư trú và dữ liệu quốc gia về dân cư" : "Công an" %>
			<%=DonViHanhChinhLocalServiceUtil.fetchDonViHanhChinh(hoSo.getNoiCapCmnd1Tab2()).getTen()%>
			<%} %>
		</label>
	</td>
</tr>

<!-- input * -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">HoChieu1Tab2:
		<%=hoSo.getHoChieu1Tab2() %></label> 
	</td>
</tr>


<!-- city -->
<tr>
	<td colspan="2">
		<label class="egov-label">NoiCapHoChieu1Tab2: 
			<%=hoSo.getNoiCapHoChieu1Tab2() > 0 ? 
				service.getDonViHanhChinhTheoId(hoSo.getNoiCapHoChieu1Tab2()).getTen() :""%>
		</label>
	</td>
</tr>

<!-- Date  -->
<tr>
	<td colspan="6"><label class="egov-label" >Ngày cấp:
		<%= ActionUtils.parseDateToTring(hoSo.getNgayCapHoChieu1Tab2()) %></label> 
	</td>
</tr>


<!-- input * -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">TenGTK1Tab2:
		<%=hoSo.getTenGTK1Tab2() %></label> 
	</td>
</tr>

<!-- input * -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">SoGTK1Tab2:
		<%=hoSo.getSoGTK1Tab2() %></label> 
	</td>
</tr>

<!-- input -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">NoiCapGTK1Tab2:
		<%=hoSo.getNoiCapGTK1Tab2() %></label> 
	</td>
</tr>

<!-- Date  -->
<tr>
	<td colspan="6"><label class="egov-label" >Ngày cấp:
		<%= ActionUtils.parseDateToTring(hoSo.getNgayCapGTK1Tab2()) %></label> 
	</td>
</tr>


<!-- quanHe -->
<tr>
	<td colspan="2">
		<label class="egov-label">QuanHe1: 
			<%=ActionUtils.getQuanHeGiaDinh(hoSo.getQuanHe1())%>
		</label>
	</td>
</tr>



<!-- input * -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">Ten2Tab2:
		<%=hoSo.getTen2Tab2() %></label> 
	</td>
</tr>

<!-- Date * -->
<tr>
	<td colspan="6"><label class="egov-label" >Ngày cấp:
		<%= ActionUtils.parseDateToTring(hoSo.getBirth2Tab2()) %></label> 
	</td>
</tr>


<!-- danToc * -->
<tr>
	<td colspan="2">
		<label class="egov-label">DanToc2Tab2: 
			<%=ActionUtils.getDanToc(hoSo.getDanToc2Tab2())%>
		</label>
	</td>
</tr>


<!-- nation * -->
<tr>
	<td colspan="2">
		<label class="egov-label">QuocTich2Tab2: 
			<%=ActionUtils.getQuocTich(hoSo.getQuocTich2Tab2())%>
		</label>
	</td>
</tr>



<!-- address * -->
<tr>
	<td colspan="6">
		<label class="egov-label">Địa chỉ : 
			<%=ActionUtils.getAddress(hoSo.getDiaChi6(),
									hoSo.getTinh6(),
									hoSo.getQuan6(),
									hoSo.getXa6())
									%> 
		</label>
	 </td>
</tr>

<!-- input -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">Radio2Tab2:
		<%=hoSo.getRadio2Tab2() %></label> 
	</td>
</tr>

<!-- cmnd * -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">Cmnd2Tab2:
		<%=hoSo.getCmnd2Tab2() %></label> 
	</td>
</tr>

<!-- Date  -->
<tr>
	<td colspan="6"><label class="egov-label" >Ngày cấp:
		<%= ActionUtils.parseDateToTring(hoSo.getNgayCapCmnd2Tab2()) %></label> 
	</td>
</tr>


<!-- cmnd -->
<tr>
	<td colspan="6">
		<label class="egov-label">Nơi cấp: 
			<% if(hoSo.getNoiCapCmnd2Tab2() >0 &&DonViHanhChinhLocalServiceUtil.fetchDonViHanhChinh(hoSo.getNoiCapCmnd2Tab2())!=null){%>
			<%=DonViHanhChinhLocalServiceUtil.fetchDonViHanhChinh(hoSo.getNoiCapCmnd2Tab2()).getMa().length()>=4 ? "Cục cảnh sát ĐKQL cư trú và dữ liệu quốc gia về dân cư" : "Công an" %>
			<%=DonViHanhChinhLocalServiceUtil.fetchDonViHanhChinh(hoSo.getNoiCapCmnd2Tab2()).getTen()%>
			<%} %>
		</label>
	</td>
</tr>

<!-- input * -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">HoChieu2Tab2:
		<%=hoSo.getHoChieu2Tab2() %></label> 
	</td>
</tr>

<!-- city -->
<tr>
	<td colspan="2">
		<label class="egov-label">NoiCapHoChieu2Tab2: 
			<%=hoSo.getNoiCapHoChieu2Tab2() > 0 ? 
				service.getDonViHanhChinhTheoId(hoSo.getNoiCapHoChieu2Tab2()).getTen() :""%>
		</label>
	</td>
</tr>



<!-- Date  -->
<tr>
	<td colspan="6"><label class="egov-label" >Ngày cấp:
		<%= ActionUtils.parseDateToTring(hoSo.getNgayCapHoChieu2Tab2()) %></label> 
	</td>
</tr>


<!-- input * -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">TenGTK2Tab2:
		<%=hoSo.getTenGTK2Tab2() %></label> 
	</td>
</tr>

<!-- input * -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">SoGTK2Tab2:
		<%=hoSo.getSoGTK2Tab2() %></label> 
	</td>
</tr>

<!-- input -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">NoiCapGTK2Tab2:
		<%=hoSo.getNoiCapGTK2Tab2() %></label> 
	</td>
</tr>

<!-- Date  -->
<tr>
	<td colspan="6"><label class="egov-label" >Ngày cấp:
		<%= ActionUtils.parseDateToTring(hoSo.getNgayCapGTK2Tab2()) %></label> 
	</td>
</tr>


<!-- quanHe * -->
<tr>
	<td colspan="2">
		<label class="egov-label">QuanHe2Tab2: 
			<%=ActionUtils.getQuanHeGiaDinh(hoSo.getQuanHe2Tab2())%>
		</label>
	</td>
</tr>



<!-- input * -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">Ten3Tab2:
		<%=hoSo.getTen3Tab2() %></label> 
	</td>
</tr>

<!-- Date * -->
<tr>
	<td colspan="6"><label class="egov-label" >Ngày cấp:
		<%= ActionUtils.parseDateToTring(hoSo.getBirth3Tab2()) %></label> 
	</td>
</tr>


<!-- danToc * -->
<tr>
	<td colspan="2">
		<label class="egov-label">DanToc3Tab2: 
			<%=ActionUtils.getDanToc(hoSo.getDanToc3Tab2())%>
		</label>
	</td>
</tr>


<!-- nation * -->
<tr>
	<td colspan="2">
		<label class="egov-label">QuocTich3Tab2: 
			<%=ActionUtils.getQuocTich(hoSo.getQuocTich3Tab2())%>
		</label>
	</td>
</tr>



<!-- address * -->
<tr>
	<td colspan="6">
		<label class="egov-label">Địa chỉ : 
			<%=ActionUtils.getAddress(hoSo.getDiaChi7(),
									hoSo.getTinh7(),
									hoSo.getQuan7(),
									hoSo.getXa7())
									%> 
		</label>
	 </td>
</tr>

<!-- input -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">Radio3Tab2:
		<%=hoSo.getRadio3Tab2() %></label> 
	</td>
</tr>

<!-- cmnd * -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">Cmnd3Tab2:
		<%=hoSo.getCmnd3Tab2() %></label> 
	</td>
</tr>

<!-- Date  -->
<tr>
	<td colspan="6"><label class="egov-label" >Ngày cấp:
		<%= ActionUtils.parseDateToTring(hoSo.getNgayCapCmnd3Tab2()) %></label> 
	</td>
</tr>


<!-- cmnd -->
<tr>
	<td colspan="6">
		<label class="egov-label">Nơi cấp: 
			<% if(hoSo.getNoiCapCmnd3Tab2() >0 &&DonViHanhChinhLocalServiceUtil.fetchDonViHanhChinh(hoSo.getNoiCapCmnd3Tab2())!=null){%>
			<%=DonViHanhChinhLocalServiceUtil.fetchDonViHanhChinh(hoSo.getNoiCapCmnd3Tab2()).getMa().length()>=4 ? "Cục cảnh sát ĐKQL cư trú và dữ liệu quốc gia về dân cư" : "Công an" %>
			<%=DonViHanhChinhLocalServiceUtil.fetchDonViHanhChinh(hoSo.getNoiCapCmnd3Tab2()).getTen()%>
			<%} %>
		</label>
	</td>
</tr>

<!-- input * -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">HoChieu3Tab2:
		<%=hoSo.getHoChieu3Tab2() %></label> 
	</td>
</tr>

<!-- city -->
<tr>
	<td colspan="2">
		<label class="egov-label">NoiCapHoChieu3Tab2: 
			<%=hoSo.getNoiCapHoChieu3Tab2() > 0 ? 
				service.getDonViHanhChinhTheoId(hoSo.getNoiCapHoChieu3Tab2()).getTen() :""%>
		</label>
	</td>
</tr>

<!-- Date  -->
<tr>
	<td colspan="6"><label class="egov-label" >Ngày cấp:
		<%= ActionUtils.parseDateToTring(hoSo.getNgayCapHoChieu3Tab2()) %></label> 
	</td>
</tr>

<!-- input * -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">TenGTK3Tab2:
		<%=hoSo.getTenGTK3Tab2() %></label> 
	</td>
</tr>

<!-- input * -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">SoGTK3Tab2:
		<%=hoSo.getSoGTK3Tab2() %></label> 
	</td>
</tr>

<!-- input -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">NoiCapGTK3Tab2:
		<%=hoSo.getNoiCapGTK3Tab2() %></label> 
	</td>
</tr>

<!-- Date  -->
<tr>
	<td colspan="6"><label class="egov-label" >Ngày cấp:
		<%= ActionUtils.parseDateToTring(hoSo.getNgayCapGTK3Tab2()) %></label> 
	</td>
</tr>



<!-- input -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">YKien1:
		<%=hoSo.getYKien1() %></label> 
	</td>
</tr>

<!-- input -->
<tr>
	<td colspan="6"><label class="egov-label" style="word-wrap: break-word;">YKien2:
		<%=hoSo.getYKien2() %></label> 
	</td>
</tr>


					<!-- -------------------------- here ------------------------------  -->
			<tr>
				<td colspan="6">
					<div style = "display: block; text-align :justify; font-size: 15px;">
						<label class="egov-label">
							Tôi cam đoan lời khai trên đây là đúng sự thật và chịu trách
							nhiệm trước pháp luật về cam đoan của mình. 
						</label>
					</div>
				</td>
			</tr>

			<tr>
				<td width="16.67%">&nbsp;</td>
				<td width="16.67%">&nbsp;</td>
				<td width="16.67%">&nbsp;</td>
				<td width="16.67%">&nbsp;</td>
				<td width="16.67%">&nbsp;</td>
				<td width="16.67%">&nbsp;</td>
			</tr>

			<tr >
				<td colspan="3">
					<label class = "egov-label-note" style= "margin-left : 15px;">Bắc Ninh, ngày ...... tháng ...... năm ...........</label><br>
					<label class = "egov-label-bold" style= "margin-left : 15px;">Xác nhận của UBND cấp xã nơi cư trú 
					</label><br/>
					 <label class = "egov-label-note" style= "margin-left : 45px;">(Ký, ghi rõ họ tên, đóng đấu) </label>
				</td>

				<td colspan="3" style="text-align: center;"><label
					class="egov-label-note">
					Làm tại: ........... , ngày ..... tháng ..... năm ..........</label><br> <label
					class="egov-label-bold">
					Người yêu cầu </label><br /> <label class="egov-label-note"
					style="margin-right: 0px;">(Ký, ghi rõ họ, chữ đệm, tên) </label></td>
			</tr>

			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td colspan="4" style="text-align: center;">
					<label class="egov-label-note">
						Bắc Ninh, ngày .......... tháng ......... năm ..............    
					</label>				
				</td>
			</tr>
			
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td colspan="4" style="text-align: center;">
					<label class="egov-label-bold">CƠ QUAN, TỔ CHỨC, DOANH NGHIỆP<br>
					ĐĂNG KÝ THỰC HIỆN QUẢNG CÁO<br>
					</label>
					<label class="egov-label-note">(ký, họ tên, chức vụ và đóng dấu)</label>				
				</td>	
			</tr>	
		</table>
	</div>
	
	<div style="margin-left: 15px; margin-top: 10px;">
		<jsp:include page="/html/portlet/xuLyHoSoButtons.jsp">
			<jsp:param name="editJSP"
				value="/html/portlet/csms/khaisinhkethopchameconnn/registry_khaisinhkethopchameconnn_step.jsp" />
		</jsp:include>
	</div>
</body>